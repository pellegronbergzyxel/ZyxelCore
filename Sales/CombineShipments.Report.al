report 50295 "Combine Shipments ZX"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Combine Shipments';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(SalesOrderHeader; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order), "Combine Shipments" = CONST(true), "Completely Invoiced" = CONST(false));
            RequestFilterFields = "Sell-to Customer No.", "Bill-to Customer No.", "Picking List No. Filter";
            RequestFilterHeading = 'Sales Order';
            dataitem("Sales Shipment Header"; "Sales Shipment Header")
            {
                DataItemLink = "Order No." = FIELD("No."), "Picking List No." = FIELD("Picking List No. Filter"), "Picking List No. Filter" = FIELD("Picking List No. Filter");
                DataItemTableView = SORTING("Order No.");
                RequestFilterFields = "Posting Date";
                RequestFilterHeading = 'Posted Sales Shipment';
                dataitem("Sales Shipment Line"; "Sales Shipment Line")
                {
                    DataItemLink = "Document No." = FIELD("No."), "Picking List No." = FIELD("Picking List No. Filter");
                    DataItemTableView = SORTING("Document No.", "Line No.");

                    trigger OnAfterGetRecord()
                    var
                        IsHandled: Boolean;
                    begin
                        IsHandled := false;
                        OnBeforeSalesShipmentLineOnAfterGetRecord("Sales Shipment Line", IsHandled);
                        if IsHandled then
                            CurrReport.Skip();

                        if Type = Type::" " then
                            if (not CopyTextLines) or ("Attached to Line No." <> 0) then
                                CurrReport.Skip();

                        if "Authorized for Credit Card" then
                            CurrReport.Skip();

                        if ("Qty. Shipped Not Invoiced" <> 0) or (Type = Type::" ") then begin
                            if ("Bill-to Customer No." <> Cust."No.") and
                               ("Sell-to Customer No." <> '')
                            then
                                if "Bill-to Customer No." <> '' then
                                    Cust.Get("Bill-to Customer No.")
                                else
                                    if "Sell-to Customer No." <> '' then
                                        Cust.Get("Sell-to Customer No.");

                            if not (Cust.Blocked in [Cust.Blocked::All, Cust.Blocked::Invoice]) then begin
                                if ShouldFinalizeSalesInvHeader(SalesOrderHeader, SalesHeader, "Sales Shipment Line") then begin
                                    if SalesHeader."No." <> '' then
                                        FinalizeSalesInvHeader();
                                    InsertSalesInvHeader();
                                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                                    SalesLine."Document Type" := SalesHeader."Document Type";
                                    SalesLine."Document No." := SalesHeader."No.";
                                end else
                                    ModifySalesInvHeader;  // 01-11-19 ZY-LD 001

                                SalesShptLine := "Sales Shipment Line";
                                HasAmount := HasAmount or ("Qty. Shipped Not Invoiced" <> 0);
                                OnSalesShipmentLineOnAfterGetRecordOnBeforeInsertInvLineFromShptLine(SalesLine, SalesShptLine);
                                SalesShptLine.InsertInvLineFromShptLine(SalesLine);
                            end else
                                NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
                        end;
                    end;

                    trigger OnPostDataItem()
                    var
                        SalesShipmentLine: Record "Sales Shipment Line";
                        SalesLineInvoice: Record "Sales Line";
                        SalesGetShpt: Codeunit "Sales-Get Shipment";
                    begin
                        SalesShipmentLine.SetRange("Document No.", "Document No.");
                        SalesShipmentLine.SetRange(Type, Type::"Charge (Item)");
                        if SalesShipmentLine.FindSet() then
                            repeat
                                SalesLineInvoice.SetRange("Document Type", SalesLineInvoice."Document Type"::Invoice);
                                SalesLineInvoice.SetRange("Document No.", SalesHeader."No.");
                                SalesLineInvoice.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");
                                if SalesLineInvoice.FindFirst() then
                                    SalesGetShpt.GetItemChargeAssgnt(SalesShipmentLine, SalesLineInvoice."Qty. to Invoice");
                            until SalesShipmentLine.Next() = 0;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    DueDate: Date;
                    PmtDiscDate: Date;
                    PmtDiscPct: Decimal;
                begin
                    IF NOT HideDialog THEN  // 01-11-19 ZY-LD 001
                        Window.Update(3, "No.");

                    if IsCompletlyInvoiced() then
                        CurrReport.Skip();

                    if OnlyStdPmtTerms then begin
                        Cust.Get("Bill-to Customer No.");
                        PmtTerms.Get(Cust."Payment Terms Code");
                        if PmtTerms.Code = "Payment Terms Code" then begin
                            DueDate := CalcDate(PmtTerms."Due Date Calculation", "Document Date");
                            PmtDiscDate := CalcDate(PmtTerms."Discount Date Calculation", "Document Date");
                            PmtDiscPct := PmtTerms."Discount %";
                            if (DueDate <> "Due Date") or
                               (PmtDiscDate <> "Pmt. Discount Date") or
                               (PmtDiscPct <> "Payment Discount %")
                            then begin
                                NoOfskippedShiment := NoOfskippedShiment + 1;
                                CurrReport.Skip();
                            end;
                        end else begin
                            NoOfskippedShiment := NoOfskippedShiment + 1;
                            CurrReport.Skip();
                        end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnAfterGetRecordSalesOrderHeader(SalesOrderHeader, IsHandled);
                if IsHandled then
                    CurrReport.Skip();

                CurrReport.Language := LanguageCU.GetLanguageIdOrDefault("Language Code");

                //>> 09-07-20 ZY-LD 003
                PickingListNo := SalesOrderHeader.GetFilter("Picking List No. Filter");  // 09-07-20 ZY-LD 003
                IF recWhseOutbHead.GET(PickingListNo) AND (recWhseOutbHead."Delivery Terms Terms" <> '') THEN
                    ShipmentMethodCode := recWhseOutbHead."Delivery Terms Terms"
                ELSE
                    ShipmentMethodCode := "Shipment Method Code";
                //<< 09-07-20 ZY-LD 003

                //>> 26-01-22 ZY-LD
                recCustSell.GET("Sell-to Customer No.");
                IF (recCustSell."Currency Code" = '') OR (recCustSell."Currency Code" = "Currency Code Sales Doc SUB") THEN
                    "Currency Code Sales Doc SUB" := '';


                IF NOT HideDialog THEN BEGIN  // 01-11-19 ZY-LD 001
                    Window.Update(1, "Bill-to Customer No.");
                    Window.Update(2, "No.");
                end;
            end;

            trigger OnPostDataItem()
            begin
                CurrReport.Language := ReportLanguage;
                IF NOT HideDialog THEN  // 01-11-19 ZY-LD 001
                    Window.Close();
                ShowResult();
            end;

            trigger OnPreDataItem()
            begin
                SetCurrentKey("Sell-to Customer No.", "Bill-to Customer No.", "Currency Code", "EU 3-Party Trade", "Dimension Set ID");

                if PostingDateReq = 0D then
                    Error(Text000);
                if DocDateReq = 0D then
                    Error(Text001);
                if VATDateReq = 0D then
                    Error(VATDateEmptyErr);

                IF NOT HideDialog THEN  // 01-11-19 ZY-LD 001
                    Window.Open(
                      Text002 +
                      Text003 +
                      Text004 +
                      Text005);

                OnSalesOrderHeaderOnPreDataItem(SalesOrderHeader);
                ReportLanguage := CurrReport.Language();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date for the invoice(s) that the batch job creates. This field must be filled in.';

                        trigger OnValidate()
                        begin
                            UpdateVATDate();
                        end;
                    }
                    field(DocDateReq; DocDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Date';
                        ToolTip = 'Specifies the document date for the invoice(s) that the batch job creates. This field must be filled in.';

                        trigger OnValidate()
                        begin
                            UpdateVATDate();
                        end;
                    }
                    field(VATDate; VATDateReq)
                    {
                        ApplicationArea = VAT;
                        Caption = 'VAT Date';
                        Editable = VATDateEnabled;
                        Visible = VATDateEnabled;
                        ToolTip = 'Specifies the VAT Date for the invoice(s) that the batch job creates. This field must be filled in.';
                    }
                    field(CalcInvDisc; CalcInvDisc)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Calc. Inv. Discount';
                        ToolTip = 'Specifies if you want the invoice discount amount to be automatically calculated on the shipment.';

                        trigger OnValidate()
                        begin
                            SalesSetup.Get();
                            SalesSetup.TestField("Calc. Inv. Discount", false);
                        end;
                    }
                    field(PostInv; PostInv)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Invoices';
                        ToolTip = 'Specifies if you want to have the invoices posted immediately.';
                    }
                    field(OnlyStdPmtTerms; OnlyStdPmtTerms)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Only Std. Payment Terms';
                        ToolTip = 'Specifies if you want to include shipments with standard payments terms. If you select this option, you must manually invoice all other shipments.';
                    }
                    field(CopyTextLines; CopyTextLines)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Copy Text Lines';
                        ToolTip = 'Specifies if you want manually written text on the shipment lines to be copied to the invoice.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            VATReportingDateMgt: Codeunit "VAT Reporting Date Mgt";
        begin
            if PostingDateReq = 0D then
                PostingDateReq := WorkDate();
            if DocDateReq = 0D then
                DocDateReq := WorkDate();
            if VATDateReq = 0D then
                VATDateReq := GLSetup.GetVATDate(PostingDateReq, DocDateReq);
            SalesSetup.Get();
            CalcInvDisc := SalesSetup."Calc. Inv. Discount";
            VATDateEnabled := VATReportingDateMgt.IsVATDateEnabled();
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        SI.SetHideSalesDialog(FALSE);  // 18-11-20 ZY-LD 005
    end;

    trigger OnPreReport()
    begin
        SI.SetHideSalesDialog(TRUE);  // 18-11-20 ZY-LD 005
    end;


    var
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        GLSetup: Record "General Ledger Setup";
        PmtTerms: Record "Payment Terms";
        LanguageCU: Codeunit Language;
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        Window: Dialog;
        HasAmount: Boolean;
        HideDialog: Boolean;
        NoOfSalesInvErrors: Integer;
        NoOfSalesInv: Integer;
        NoOfskippedShiment: Integer;
        ReportLanguage: Integer;

        Text000: Label 'Enter the posting date.';
        Text001: Label 'Enter the document date.';
        Text002: Label 'Combining shipments...\\';
        Text003: Label 'Customer No.    #1##########\';
        Text004: Label 'Order No.       #2##########\';
        Text005: Label 'Shipment No.    #3##########';
        Text007: Label 'Not all the invoices were posted. A total of %1 invoices were not posted.';
        Text008: Label 'There is nothing to combine.';
        Text010: Label 'The shipments are now combined and the number of invoices created is %1.';
        Text011: Label 'The shipments are now combined, and the number of invoices created is %1.\%2 Shipments with nonstandard payment terms have not been combined.', Comment = '%1-Number of invoices,%2-Number Of shipments';
        VATDateEmptyErr: Label 'Enter the VAT date.';
        NotAllInvoicesCreatedMsg: Label 'Not all the invoices were created. A total of %1 invoices were not created.';
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        recWhseOutbHead: Record "VCK Delivery Document Header";
        PickingListNo: Code[20];
        ShipmentMethodCode: Code[10];
        recCustSell: Record Customer;

    protected var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        PostingDateReq: Date;
        DocDateReq: Date;
        VATDateReq: Date;
        CalcInvDisc: Boolean;
        PostInv: Boolean;
        OnlyStdPmtTerms: Boolean;
        CopyTextLines: Boolean;
        VATDateEnabled: Boolean;

    local procedure FinalizeSalesInvHeader()
    var
        HasError: Boolean;
        ShouldPostInv: Boolean;
    begin
        HasError := false;
        OnBeforeFinalizeSalesInvHeader(SalesHeader, HasAmount, HasError);
        if HasError then
            NoOfSalesInvErrors += 1;

        with SalesHeader do begin
            if (not HasAmount) or HasError then begin
                OnFinalizeSalesInvHeaderOnBeforeDelete(SalesHeader);
                Delete(true);
                OnFinalizeSalesInvHeaderOnAfterDelete(SalesHeader);
                exit;
            end;
            OnFinalizeSalesInvHeader(SalesHeader);
            if CalcInvDisc then
                SalesCalcDisc.Run(SalesLine);
            Find();
            Commit();
            Clear(SalesCalcDisc);
            Clear(SalesPost);
            NoOfSalesInv := NoOfSalesInv + 1;
            ShouldPostInv := PostInv;
            OnFinalizeSalesInvHeaderOnAfterCalcShouldPostInv(SalesHeader, NoOfSalesInv, ShouldPostInv);
            if ShouldPostInv then begin
                Clear(SalesPost);
                if not SalesPost.Run(SalesHeader) then
                    NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
            end;
        end;
    end;

    local procedure InsertSalesInvHeader()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInsertSalesInvHeader(SalesHeader, SalesOrderHeader, "Sales Shipment Header", "Sales Shipment Line", NoOfSalesInv, HasAmount, IsHandled);
        if not IsHandled then begin
            GLSetup.Get();
            Clear(SalesHeader);
            with SalesHeader do begin
                SetHideValidationDialog(TRUE);  // 01-11-19 ZY-LD 001
                Init();
                "Document Type" := "Document Type"::Invoice;
                "No." := '';
                OnBeforeSalesInvHeaderInsert(SalesHeader, SalesOrderHeader);
                Insert(true);
                ValidateCustomerNo(SalesHeader, SalesOrderHeader);
                Validate("Posting Date", PostingDateReq);
                Validate("Document Date", DocDateReq);
                Validate("VAT Reporting Date", VATDateReq);
                Validate("Currency Code", SalesOrderHeader."Currency Code");
                Validate("EU 3-Party Trade", SalesOrderHeader."EU 3-Party Trade");
                if GLSetup."Journal Templ. Name Mandatory" then
                    Validate("Journal Templ. Name", SalesOrderHeader."Journal Templ. Name");
                "Salesperson Code" := SalesOrderHeader."Salesperson Code";
                "Shortcut Dimension 1 Code" := SalesOrderHeader."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := SalesOrderHeader."Shortcut Dimension 2 Code";
                "Dimension Set ID" := SalesOrderHeader."Dimension Set ID";
                OnBeforeSalesInvHeaderModify(SalesHeader, SalesOrderHeader);
                Modify();
                Commit();
                HasAmount := false;
            end;
        end;
        OnAfterInsertSalesInvHeader(SalesHeader, "Sales Shipment Header");
    end;

    procedure InitializeRequest(NewPostingDate: Date; NewDocDate: Date; NewCalcInvDisc: Boolean; NewPostInv: Boolean; NewOnlyStdPmtTerms: Boolean; NewCopyTextLines: Boolean)
    begin
        PostingDateReq := NewPostingDate;
        DocDateReq := NewDocDate;
        VATDateReq := GLSetup.GetVATDate(PostingDateReq, DocDateReq);
        CalcInvDisc := NewCalcInvDisc;
        PostInv := NewPostInv;
        OnlyStdPmtTerms := NewOnlyStdPmtTerms;
        CopyTextLines := NewCopyTextLines;
    end;

    procedure InitializeRequest(NewPostingDate: Date; NewDocDate: Date; NewVATDate: Date; NewCalcInvDisc: Boolean; NewPostInv: Boolean; NewOnlyStdPmtTerms: Boolean; NewCopyTextLines: Boolean)
    begin
        InitializeRequest(NewPostingDate, NewDocDate, NewCalcInvDisc, NewPostInv, NewOnlyStdPmtTerms, NewCopyTextLines);
        VATDateReq := NewVATDate;
    end;

    local procedure ValidateCustomerNo(var ToSalesHeader: Record "Sales Header"; FromSalesOrderHeader: Record "Sales Header")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeValidateCustomerNo(ToSalesHeader, FromSalesOrderHeader, "Sales Shipment Header", "Sales Shipment Line", IsHandled);
        if IsHandled then
            exit;

        ToSalesHeader.Validate("Sell-to Customer No.", FromSalesOrderHeader."Sell-to Customer No.");
        ToSalesHeader.Validate("Bill-to Customer No.", FromSalesOrderHeader."Bill-to Customer No.");
    end;

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure ShowResult()
    begin
        OnBeforeShowResult(SalesHeader, NoOfSalesInvErrors, PostInv);

        if SalesHeader."No." <> '' then begin // Not the first time
            FinalizeSalesInvHeader();
            OnSalesShipmentHeaderOnAfterFinalizeSalesInvHeader(SalesHeader, NoOfSalesInvErrors, PostInv, HideDialog);
            if (NoOfSalesInvErrors = 0) and not HideDialog then begin
                if NoOfskippedShiment > 0 then
                    Message(Text011, NoOfSalesInv, NoOfskippedShiment)
                else
                    Message(Text010, NoOfSalesInv);
            end else
                if not HideDialog then
                    if PostInv then
                        Message(Text007, NoOfSalesInvErrors)
                    else
                        Message(NotAllInvoicesCreatedMsg, NoOfSalesInvErrors)
        end else
            if not HideDialog then
                Message(Text008);
    end;

    local procedure ShouldFinalizeSalesInvHeader(SalesOrderHeader: Record "Sales Header"; SalesHeader: Record "Sales Header"; SalesShipmentLine: Record "Sales Shipment Line") Finalize: Boolean
    begin
        Finalize :=
          (SalesOrderHeader."Sell-to Customer No." <> SalesHeader."Sell-to Customer No.") or
          (SalesOrderHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") or
          (SalesOrderHeader."Currency Code" <> SalesHeader."Currency Code") or
          (SalesOrderHeader."EU 3-Party Trade" <> SalesHeader."EU 3-Party Trade") or
          (SalesOrderHeader."Dimension Set ID" <> SalesHeader."Dimension Set ID") or
          (SalesOrderHeader."Journal Templ. Name" <> SalesHeader."Journal Templ. Name") or
          (SalesOrderHeader."Sales Order Type" <> SalesHeader."Sales Order Type") OR  // 01-11-19 ZY-LD 001
                                                                                      //((SalesOrderHeader."No." <> SalesHeader."Your Reference") AND (SalesHeader."Your Reference" <> '')) OR  // 16-06-20 ZY-LD 002  // 15-09-21 ZY-LD 008
          ((SalesOrderHeader."No." <> SalesHeader."Create Invoice pr. Order No.") AND (SalesHeader."Create Invoice pr. Order No." <> '')) OR  // 15-09-21 ZY-LD 008
          ((SalesOrderHeader."Currency Code Sales Doc SUB" <> SalesHeader."Currency Code Sales Doc SUB") AND (ZGT.IsZComCompany)) OR  // 06-07-21 ZY-LD 006
          ((SalesOrderHeader."Ship-to VAT" <> SalesHeader."Ship-to VAT") AND (SalesHeader."Sell-to Customer No." <> SalesHeader."Bill-to Customer No."));  // 17-08-21 ZY-LD 007

        OnAfterShouldFinalizeSalesInvHeader(SalesOrderHeader, SalesHeader, Finalize, SalesShipmentLine, "Sales Shipment Header");
        exit(Finalize);
    end;

    local procedure UpdateVATDate()
    begin
        VATDateReq := GLSetup.GetVATDate(PostingDateReq, DocDateReq);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetRecordSalesOrderHeader(var SalesOrderHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertSalesInvHeader(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinalizeSalesInvHeader(var SalesHeader: Record "Sales Header"; var HasAmount: Boolean; var HasError: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertSalesInvHeader(var SalesInvoiceHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line"; var NoOfSalesInv: Integer; var HasAmount: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePreReport()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePostReport()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesInvHeaderInsert(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowResult(var SalesInvoiceHeader: Record "Sales Header"; var NoOfSalesInvErrors: Integer; PostInvoice: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesInvHeaderModify(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesShipmentLineOnAfterGetRecord(var SalesShipmentLine: Record "Sales Shipment Line"; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateCustomerNo(var ToSalesHeader: Record "Sales Header"; var FromSalesOrderHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeader(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeaderOnAfterDelete(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeaderOnAfterCalcShouldPostInv(var SalesHeader: Record "Sales Header"; var NoOfSalesInv: Integer; var ShouldPostInv: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizeSalesInvHeaderOnBeforeDelete(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSalesOrderHeaderOnPreDataItem(var SalesOrderHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShouldFinalizeSalesInvHeader(var SalesOrderHeader: Record "Sales Header"; SalesHeader: Record "Sales Header"; var Finalize: Boolean; SalesShipmentLine: Record "Sales Shipment Line"; SalesShipmentHeader: Record "Sales Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSalesShipmentLineOnAfterGetRecordOnBeforeInsertInvLineFromShptLine(var SalesLine: Record "Sales Line"; var SalesShipmentLine: Record "Sales Shipment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSalesShipmentHeaderOnAfterFinalizeSalesInvHeader(var SalesHeader: Record "Sales Header"; var NoOfSalesInvErrors: Integer; PostInvoice: Boolean; var HideDialog: Boolean)
    begin
    end;

    LOCAL PROCEDURE ModifySalesInvHeader();
    BEGIN
        WITH SalesHeader DO BEGIN
            //>> 01-11-19 ZY-LD 001
            IF SalesOrderHeader."External Document No." <> '' THEN
                IF StrPos("External Document No.", SalesOrderHeader."External Document No.") = 0 THEN
                    IF "External Document No." <> '' THEN
                        "External Document No." := COPYSTR(STRSUBSTNO('%1,%2', "External Document No.", SalesOrderHeader."External Document No."), 1, MAXSTRLEN("External Document No."))
                    ELSE
                        "External Document No." := SalesOrderHeader."External Document No.";
            //<< 01-11-19 ZY-LD 001
        END;
    END;

}
