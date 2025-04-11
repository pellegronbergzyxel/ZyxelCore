pageextension 50159 PostedSalesInvoicesZX extends "Posted Sales Invoices"
{
    layout
    {
        addfirst(Control1)
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("No.")
        {
            field("Pre-Assigned No."; Rec."Pre-Assigned No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce No.';
            }
            field(ExternalDocumentSL; ExternalDocumentSL)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'External Document No. 2';
                ToolTip = 'External Document No. 2 comes from the sales invoice line';
                Visible = false;
            }
            field("E-Invoice Comment"; Rec."E-Invoice Comment")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Picking List No."; Rec."Picking List No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Amount Including VAT")
        {
            field(VATAmount; VATAmount)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT Amount';
                DecimalPlaces = 2 : 2;
            }
        }
        addafter("Sell-to Post Code")
        {
            field("Intercompany Purchase"; Rec."Intercompany Purchase")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Bill-to Post Code")
        {
            field("Bill-to City"; Rec."Bill-to City")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Document Exchange Status")
        {
            field(ICInfoPurch; ICInfoPurch)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'IC Purchase Invoice No.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    //>> 01-11-17 ZY-LD 003
                    SI.SetSalesInvoiceNo(Rec."No.");
                    Page.RunModal(Page::"Posted Purchase Invoice Tmp");
                    //<< 01-11-17 ZY-LD 003
                end;
            }
            field(PostingDateInDifferentMonth; PostingDateInDifferentMonth)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted in Different Months';
            }
            field(ICInfoSale; ICInfoSale)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'IC Sales Invoice No.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    //>> 01-11-17 ZY-LD 003
                    SI.SetSalesInvoiceNo(Rec."No.");
                    Page.RunModal(Page::"Posted Sales Invoice Tmp");
                    //<< 01-11-17 ZY-LD 003
                end;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Serial Numbers Status"; Rec."Serial Numbers Status")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Invoice No. for End Customer"; Rec."Invoice No. for End Customer")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Company VAT Registration Code"; Rec."Company VAT Registration Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Ship-to VAT"; Rec."Ship-to VAT")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Send Mail"; Rec."Send Mail")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Customer Document No."; Rec."Customer Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("SAP No."; Rec."SAP No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Total Amount on eCommerce"; Rec."Total Amount on eCommerce")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Order Desk Resposible Code"; Rec."Order Desk Resposible Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addlast(Control1)
        {
            field("RHQ Invoice No"; Rec."RHQ Invoice No")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("NL to DK Rev. Charge Posted"; Rec."NL to DK Rev. Charge Posted")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        modify(ActionGroupCRM)
        {
            Visible = false;
        }
        addafter(ActionGroupCRM)
        {
            action("Show Serial No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Serial No.';
                Image = SerialNo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowSerialNo();  // 23-04-19 ZY-LD 006
                end;
            }
        }
        addafter("&Invoice")
        {
            action("Show Delivery Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Delivery Document';
                Image = Document;
                RunObject = Page "VCK Delivery Document";
                RunPageLink = "No." = field("Picking List No.");
            }
        }
        addafter("Print")
        {
            action("Print eCommerce Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print eCommerce Invoice';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Sales - Invoice eCommerce";
                Visible = eCommerceVisible;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Sales - Invoice eCommerce", true, true, SalesInvHeader);
                end;
            }
            action("Bulk Export of eCommerce Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bulk Export of eCommerce Invoice';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Bulk Print eCommerce Invoice";
                Visible = eCommerceVisible;
            }
            action("Print Customs Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Customs Invoice';
                Image = Print;
                Visible = PrintCustomsInvoiceVisible;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    //>> 08-11-21 ZY-LD 010
                    Message(zText001);
                    /*//>> 27-01-21 ZY-LD 010
                    SalesInvHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    CLEAR(repSalesCustomsInvoiceZNet);
                    repSalesCustomsInvoiceZNet.SetCustomsInvoice(TRUE);
                    repSalesCustomsInvoiceZNet.SETTABLEVIEW(SalesInvHeader);
                    repSalesCustomsInvoiceZNet.USEREQUESTPAGE(TRUE);
                    repSalesCustomsInvoiceZNet.RUNMODAL;
                    //<< 27-01-21 ZY-LD 010*/
                    //<< 08-11-21 ZY-LD 010
                end;
            }
        }
        addafter("Email")
        {
            action("Add to E-mail Queue")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Add to E-mail Queue';
                Image = Add;

                trigger OnAction()
                begin
                    AddToEmailQueue();  // 25-11-19 ZY-LD 009
                end;
            }
        }
        addafter(ActivityLog)
        {
            group(Zyxel)
            {
                Caption = 'Zyxel';
                action("Chemical Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Chemical Report';
                    Image = "Report";
                    RunObject = Report "Item Chemical Report";
                }
                action("Search On External Document No")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Search On External Document No';
                    Image = Find;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SearchOnExtDocNo();
                    end;
                }
                action("Create IC Outbox Transaction")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create IC Outbox Transaction';
                    Image = CreateDocuments;

                    trigger OnAction()
                    begin
                        CreateOutboxOnSalesInvoice();  // 18-10-19 ZY-LD 002
                    end;
                }
                action("Send Container Details")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Container Details';
                    Image = SendTo;

                    trigger OnAction()
                    begin
                        SendContainerDetails();  // 12-07-19 ZY-LD 007
                    end;
                }
                action("Send Unshipped Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Unshipped Quantity';
                    Image = SendTo;

                    trigger OnAction()
                    begin
                        SendUnshippedQuantity();  // 12-07-19 ZY-LD 007
                    end;
                }
                action("Reverse value of Send Mail")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reverse value of "Send Mail"';
                    Image = ReverseLines;

                    trigger OnAction()
                    begin
                        ReverseValueOfSendMail();  // 25-09-19 ZY-LD 008
                    end;
                }
                action("Update Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Update Ship-to Code';
                    Image = UpdateShipment;

                    trigger OnAction()
                    begin
                        UpdateShipToCode();
                    end;
                }
                action("Update Invoice No. for End Customer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Update Invoice No. for End Customer';
                    Image = UpdateDescription;

                    trigger OnAction()
                    begin
                        UpdateInvoiceNoForEndCust();  // 23-04-19 ZY-LD 006
                    end;
                }
                action("Send Batch")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Batch';

                    trigger OnAction()
                    begin
                        SendEmailBatch();
                    end;
                }
            }
        }
        moveafter(IncomingDoc; CRMGotoInvoice)
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 20-10-17 ZY-LD 002
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Amount Including VAT", Amount);
        VATAmount := Rec."Amount Including VAT" - Rec.Amount;
        ShowInterCompanyInfo;
        ExternalDocumentSL := SalesHeaderLineEvent.GetExternalDocNoFromSalesInvLine(Rec."No.");  // 21-09-18 ZY-LD 005
        SetActions();  // 27-01-21 ZY-LD 010
    end;

    var
        Error005: Label 'No eCommerce Folder Specified.';
        Error002: Label 'This procedure cannot be run in RHQ, only an eCommerce Sub';
        RHQComp: Label 'ZyXEL (RHQ) Go LIVE';
        VATAmount: Decimal;
        ICInfoSale: Code[20];
        ICInfoPurch: Code[20];
        PostingDateInDifferentMonth: Boolean;
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        ExternalDocumentSL: Text;
        SalesHeaderLineEvent: Codeunit "Sales Header/Line Events";
        PrintCustomsInvoiceVisible: Boolean;
        zText001: Label 'Please use "Customs/Shipping Invoice" from the Delivery Document.';
        eCommerceVisible: Boolean;

    local procedure CreateFolder(FolderName: Text[1024])
    var
        SystemIODirectory: dotnet Directory;
        SystemIODirectoryInfo: dotnet DirectoryInfo;
    begin
        if not SystemIODirectory.Exists(FolderName) then SystemIODirectoryInfo := SystemIODirectory.CreateDirectory(FolderName);
    end;

    local procedure CreateOutboxOnSalesInvoice()
    var
        lSalesInvoiceHeader: Record "Sales Invoice Header";
        lICOutboxTransaction: Record "IC Outbox Transaction";
        lHandledICOutboxTrans: Record "Handled IC Outbox Trans.";
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        lText001: Label 'Do you want to create an outbox transaction on %1 invoices?';
        lText002: Label '%1 created in %2.\%3 rejected. Look in %2. (%4: %5)';
        QtyRejected: Integer;
        QtyCreated: Integer;
        TransactionNo: Integer;
    begin
        //>> 18-10-19 ZY-LD 002
        CurrPage.SetSelectionFilter(lSalesInvoiceHeader);
        if Confirm(lText001, false, lSalesInvoiceHeader.Count()) then begin
            lSalesInvoiceHeader.FindSet();
            repeat
                lICOutboxTransaction.SetRange("Document Type", lICOutboxTransaction."document type"::Invoice);
                lICOutboxTransaction.SetRange("Document No.", lSalesInvoiceHeader."No.");
                lHandledICOutboxTrans.SetRange("Document Type", lHandledICOutboxTrans."document type"::Invoice);
                lHandledICOutboxTrans.SetRange("Document No.", lSalesInvoiceHeader."No.");
                if lICOutboxTransaction.FindFirst() or lHandledICOutboxTrans.FindFirst() then begin
                    QtyRejected += 1;
                    if lICOutboxTransaction."Transaction No." <> 0 then
                        TransactionNo := lICOutboxTransaction."Transaction No."
                    else
                        TransactionNo := lHandledICOutboxTrans."Transaction No.";
                end else begin
                    ICInboxOutboxMgt.CreateOutboxSalesInvTrans(lSalesInvoiceHeader);
                    QtyCreated += 1;
                end;
            until lSalesInvoiceHeader.Next() = 0;
            Message(lText002, QtyCreated, lHandledICOutboxTrans.TableCaption(), QtyRejected, lICOutboxTransaction.FieldCaption("Transaction No."), TransactionNo);
        end;
        //<< 18-10-19 ZY-LD 002
    end;

    local procedure ShowInterCompanyInfo()
    var
        lBillToCust: Record Customer;
        lICPartner: Record "IC Partner";
        lSalesInvoiceHeader: Record "Sales Invoice Header";
        lPurchInvHeader: Record "Purch. Inv. Header";
        lText001: Label 'EXPECTED';
        lCustLedgEntry: Record "Cust. Ledger Entry";
        lText002: Label 'Credited';
        lAppCustLedgerEntry: Record "Cust. Ledger Entry";
        lDetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        lText003: Label 'Deleted';
    begin
        //>> 01-11-17 ZY-LD 003
        ICInfoSale := '';
        ICInfoPurch := '';
        PostingDateInDifferentMonth := false;
        if lBillToCust.Get(Rec."Bill-to Customer No.") then begin
            if lBillToCust."IC Partner Code" <> '' then
                if lICPartner.Get(lBillToCust."IC Partner Code") and (lICPartner."Inbox Type" = lICPartner."inbox type"::Database) then begin
                    if Rec."Amount Including VAT" <> 0 then begin
                        if lSalesInvoiceHeader.ChangeCompany(lICPartner."Inbox Details") then
                            if lSalesInvoiceHeader.ReadPermission then begin  // 26-04-22 ZY-LD 011
                                lSalesInvoiceHeader.SetRange("External Document No.", Rec."No.");
                                if lSalesInvoiceHeader.FindFirst() then begin
                                    ICInfoSale := lSalesInvoiceHeader."No.";
                                end else begin
                                    lCustLedgEntry.SetRange("Customer No.", lBillToCust."No.");
                                    lCustLedgEntry.SetRange("Document Type", lCustLedgEntry."document type"::Invoice);
                                    lCustLedgEntry.SetRange("Document No.", Rec."No.");
                                    if lCustLedgEntry.FindFirst() then begin
                                        lDetCustLedgEntry.SetRange("Cust. Ledger Entry No.", lCustLedgEntry."Entry No.");
                                        lDetCustLedgEntry.SetRange("Entry Type", lDetCustLedgEntry."entry type"::Application);
                                        if lDetCustLedgEntry.FindFirst() then begin
                                            if lAppCustLedgerEntry.Get(lDetCustLedgEntry."Applied Cust. Ledger Entry No.") and
                                                (lAppCustLedgerEntry."Document Type" = lAppCustLedgerEntry."document type"::"Credit Memo")
                                            then begin
                                                ICInfoSale := lText002;
                                                ICInfoPurch := lText002;
                                            end else
                                                ICInfoSale := lText001;
                                        end;
                                    end;
                                end;

                                if ICInfoPurch = '' then begin
                                    lPurchInvHeader.ChangeCompany(lICPartner."Inbox Details");
                                    if lPurchInvHeader.ReadPermission then begin  // 26-04-22 ZY-LD 011
                                        lPurchInvHeader.SetRange("Vendor Invoice No.", Rec."No.");
                                        if lPurchInvHeader.FindFirst() then begin
                                            ICInfoPurch += lPurchInvHeader."No.";
                                            if Date2dmy(Rec."Posting Date", 2) <> Date2dmy(lPurchInvHeader."Posting Date", 2) then
                                                PostingDateInDifferentMonth := true;
                                        end else
                                            ICInfoPurch := lText001;
                                    end;
                                end;
                            end;
                    end else begin
                        ICInfoSale := lText003;
                        ICInfoPurch := lText003;
                    end;
                end;
        end;
        //<< 01-11-17 ZY-LD 003
    end;

    local procedure SearchOnExtDocNo()
    var
        lSaleInvHead: Record "Sales Invoice Header";
        lSaleInvHeadTmp: Record "Sales Invoice Header" temporary;
        lSaleInvLine: Record "Sales Invoice Line";
        lSaleCrMemoHead: Record "Sales Cr.Memo Header";
        lSaleCrMemoHeadTmp: Record "Sales Cr.Memo Header" temporary;
        lSaleCrMemoLine: Record "Sales Cr.Memo Line";
        GenericInputPage: Page "Generic Input Page";
        lText001: Label 'Search for External Document No.';
        lText002: Label 'Search String';
        FilterStr: Text;
    begin
        //>> 20-12-17 ZY-LD 004
        GenericInputPage.SetPageCaption(lText001);
        GenericInputPage.SetFieldCaption(lText002);
        GenericInputPage.SetVisibleField(0);  // Text
        if GenericInputPage.RunModal = Action::OK then begin
            FilterStr := StrSubstNo('*%1*', UpperCase(GenericInputPage.GetText));

            lSaleInvLine.SetCurrentkey("External Document No.");
            lSaleInvLine.SetFilter("External Document No.", FilterStr);
            if lSaleInvLine.FindSet() then begin
                ZGT.OpenProgressWindow('', lSaleInvLine.Count());
                repeat
                    ZGT.UpdateProgressWindow(lSaleInvLine."Document No.", 0, true);
                    lSaleInvHead.Get(lSaleInvLine."Document No.");
                    lSaleInvHeadTmp := lSaleInvHead;
                    if not lSaleInvHeadTmp.Insert() then;
                until lSaleInvLine.Next() = 0;
                ZGT.CloseProgressWindow;
            end;

            lSaleCrMemoLine.SetCurrentkey("External Document No.");
            lSaleCrMemoLine.SetFilter("External Document No.", FilterStr);
            if lSaleCrMemoLine.FindSet() then begin
                ZGT.OpenProgressWindow('', lSaleCrMemoLine.Count());
                repeat
                    ZGT.UpdateProgressWindow(lSaleCrMemoLine."Document No.", 0, true);
                    lSaleCrMemoHead.Get(lSaleCrMemoLine."Document No.");
                    lSaleCrMemoHeadTmp := lSaleCrMemoHead;
                    if not lSaleCrMemoHeadTmp.Insert() then;
                until lSaleCrMemoLine.Next() = 0;
                ZGT.CloseProgressWindow;
            end;

            if not lSaleInvHeadTmp.IsEmpty() then
                Page.RunModal(Page::"Posted Sales Invoices", lSaleInvHeadTmp);

            if not lSaleCrMemoHeadTmp.IsEmpty() then
                Page.RunModal(Page::"Posted Sales Credit Memos", lSaleCrMemoHeadTmp);
        end;
        //<< 20-12-17 ZY-LD 004
    end;

    local procedure ShowSerialNo()
    var
        recSalesShipLine: Record "Sales Shipment Line";
        recSalesInvLine: Record "Sales Invoice Line";
        recSerialNo: Record "VCK Delivery Document SNos";
        recSerialNoTmp: Record "VCK Delivery Document SNos" temporary;
    begin
        //>> 23-04-19 ZY-LD 006
        recSalesInvLine.SetRange("Document No.", Rec."No.");
        recSalesInvLine.SetRange(Type, recSalesInvLine.Type::Item);
        if recSalesInvLine.FindSet() then begin
            recSerialNo.SetCurrentkey("Sales Order No.", "Sales Order Line No.");
            ZGT.OpenProgressWindow('', recSalesInvLine.Count());

            repeat
                ZGT.UpdateProgressWindow(recSalesInvLine."Document No.", 0, true);

                if recSalesShipLine.Get(recSalesInvLine."Shipment No.", recSalesInvLine."Shipment Line No.") then begin
                    recSerialNo.SetRange("Sales Order No.", recSalesShipLine."Order No.");
                    recSerialNo.SetRange("Sales Order Line No.", recSalesShipLine."Order Line No.");
                    if recSerialNo.FindSet() then
                        repeat
                            recSerialNoTmp := recSerialNo;
                            recSerialNoTmp.Insert();
                        until recSerialNo.Next() = 0;
                end;
            until recSalesInvLine.Next() = 0;

            ZGT.CloseProgressWindow;
            if not recSerialNoTmp.IsEmpty() then
                Page.RunModal(Page::"VCK Delivery Document SNos", recSerialNoTmp);
        end;
        //<< 23-04-19 ZY-LD 006
    end;

    local procedure UpdateInvoiceNoForEndCust()
    var
        recBillToCust: Record Customer;
        recIcPartner: Record "IC Partner";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        lText001: Label 'Do you want to update "%1"?';
    begin
        //>> 23-04-19 ZY-LD 006
        if Rec."Invoice No. for End Customer" = '' then
            if Confirm(lText001, false, Rec.FieldCaption(Rec."Invoice No. for End Customer")) then
                if Rec."Sell-to Customer No." <> Rec."Bill-to Customer No." then begin
                    if recBillToCust.Get(Rec."Bill-to Customer No.") then
                        if recBillToCust."IC Partner Code" <> '' then
                            if recIcPartner.Get(recBillToCust."IC Partner Code") and
                                (recIcPartner."Inbox Type" in [recIcPartner."inbox type"::Database, recIcPartner."inbox type"::"Web Service"]) then begin
                                Rec."Invoice No. for End Customer" := ZyWebServMgt.GetSalesInvoiceNo(recIcPartner."Inbox Details", Rec."No.");
                                Rec.Modify();
                            end;
                end else begin
                    Rec."Invoice No. for End Customer" := Rec."No.";
                    Rec.Modify();
                end;
        //<< 23-04-19 ZY-LD 006
    end;

    local procedure SendContainerDetails()
    var
        lText001: Label 'Do you want to send container details to "%1"?';
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
    begin
        //>> 12-07-19 ZY-LD 007
        if Confirm(lText001, true, ZGT.GetSistersCompanyName(1)) then begin
            SalesHeadEvent.SendContainerDetails(Rec."No.", Rec."Sell-to Customer No.");
            SalesHeadEvent.UpdateUnshippedQuantity(Rec."Sell-to Customer No.");
        end;
        //<< 12-07-19 ZY-LD 007
    end;

    local procedure SendUnshippedQuantity()
    var
        lText001: Label 'Do you want to send container details to "%1"?';
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
    begin
        //>> 12-07-19 ZY-LD 007
        if Confirm(lText001, true, ZGT.GetSistersCompanyName(1)) then
            SalesHeadEvent.UpdateUnshippedQuantity(Rec."Sell-to Customer No.");
        //<< 12-07-19 ZY-LD 007
    end;

    local procedure ReverseValueOfSendMail()
    var
        recSalesInvHead: Record "Sales Invoice Header";
        lText001: Label 'Do you want to reverse "%1" on %2 invoices?';
    begin
        //>> 25-09-19 ZY-LD 008
        CurrPage.SetSelectionFilter(recSalesInvHead);
        recSalesInvHead.SetRange("No. Printed", 0);
        if Confirm(lText001, true, Rec.FieldCaption(Rec."Send Mail"), recSalesInvHead.Count()) then
            if recSalesInvHead.FindSet(true) then
                repeat
                    recSalesInvHead."Send Mail" := not recSalesInvHead."Send Mail";
                    recSalesInvHead.Modify(true);
                until recSalesInvHead.Next() = 0;
        //<< 25-09-19 ZY-LD 008
    end;

    local procedure SendEmailBatch()
    var
        ProcessSalesDocumentEmail: Codeunit "Process Sales Document E-mail";
    begin
        ProcessSalesDocumentEmail.SendSalesInvoices(true);
    end;

    local procedure AddToEmailQueue()
    var
        recSalesDocEmail: Record "Sales Document E-mail Entry";
        lText001: Label 'Do you want to add %1 the the e-mail queue?';
        recSalesDocEmail2: Record "Sales Document E-mail Entry";
        lText002: Label '%1 has already been sent %2 time(s).\Latest at %3.\\Do you want to continue?';
        lText003: Label 'Function cancled.';
        lText004: Label '%1 is already ready to send at %2.';
    begin
        //>> 25-11-19 ZY-LD 009
        if Confirm(lText001, true, Rec."No.") then begin
            recSalesDocEmail2.SetRange("Document Type", recSalesDocEmail2."document type"::"Posted Sales Invoice");
            recSalesDocEmail2.SetRange("Document No.", Rec."No.");
            recSalesDocEmail2.SetRange(Sent, false);
            if recSalesDocEmail2.FindFirst() then
                Error(lText004, Rec."No.", recSalesDocEmail2."Send E-mail at");

            recSalesDocEmail2.SetRange(Sent, true);
            if recSalesDocEmail2.FindLast() then
                if not Confirm(lText002, false, Rec."No.", recSalesDocEmail2.Count(), recSalesDocEmail2."E-mail Sent at") then
                    Error(lText003);

            recSalesDocEmail."Document Type" := recSalesDocEmail."document type"::"Posted Sales Invoice";
            recSalesDocEmail."Document No." := Rec."No.";
            recSalesDocEmail.Insert(true);
        end;
        //<< 25-11-19 ZY-LD 009
    end;

    local procedure SetActions()
    begin
        PrintCustomsInvoiceVisible := ZGT.IsRhq; // AND ZGT.IsZNetCompany;  // 27-01-21 ZY-LD 010
        eCommerceVisible := Rec."eCommerce Order";
    end;

    local procedure UpdateShipToCode()
    var
        recShiptoAdd: Record "Ship-to Address";
        lText001: Label 'Are you sure you want to update "Ship-to Address"?';
        recDelDocHead: Record "VCK Delivery Document Header";
    begin
        Rec.CalcFields(Rec."Picking List No.");
        recDelDocHead.Get(Rec."Picking List No.");
        recShiptoAdd.SetRange("Customer No.", Rec."Sell-to Customer No.");
        if not recShiptoAdd.Get(Rec."Sell-to Customer No.", CopyStr(recDelDocHead."Ship-to Code", StrPos(recDelDocHead."Ship-to Code", '.') + 1, StrLen(recDelDocHead."Ship-to Code"))) then;
        if Page.RunModal(Page::"Ship-to Address List", recShiptoAdd) = Action::LookupOK then
            if Confirm(lText001, true) then begin
                Rec."Ship-to Code" := recShiptoAdd.Code;
                Rec."Ship-to Name" := recShiptoAdd.Name;
                Rec."Ship-to Name 2" := recShiptoAdd."Name 2";
                Rec."Ship-to Address" := recShiptoAdd.Address;
                Rec."Ship-to Address 2" := recShiptoAdd."Address 2";
                Rec."Ship-to City" := recShiptoAdd.City;
                Rec."Ship-to Contact" := recShiptoAdd.Contact;
                Rec."Ship-to Post Code" := recShiptoAdd."Post Code";
                Rec."Ship-to County" := recShiptoAdd.County;
                Rec."Ship-to Country/Region Code" := recShiptoAdd."Country/Region Code";
                Rec."Ship-to E-Mail" := recShiptoAdd."E-Mail";
                Rec.Modify();
            end;
    end;
}
