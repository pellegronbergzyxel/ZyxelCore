report 50073 "NL to DK Posting"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Shipping NL to DK Reverse Charge Posting';
    UsageCategory = Tasks;
    Permissions = tabledata "Sales Invoice Header" = m;
    ProcessingOnly = true;
    dataset
    {
        dataitem(PostedSalesHeader; "Sales Invoice Header")
        {
            DataItemTableView = where("Ship-to Country/Region Code" = filter('DK'), "NL to DK Rev. Charge Posted" = const(false), "Sales Order Type" = const(Normal));
            RequestFilterFields = "No.", "Sell-to Customer No.", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                CreateInvoices(PostedSalesHeader);

                if PostInvoices or not GuiAllowed then begin
                    SalesPost.Run(SalesHead);
                    PurchPost.Run(PurchHead);
                end;
            end;

            trigger OnPreDataItem()
            begin
                SalesSetup.get;
                PurchSetup.get;
                if not SalesSetup."Run NL to DK Posting" then
                    CurrReport.Break();

                SI.SetHideSalesDialog(true);
            end;

            trigger OnPostDataItem()
            begin
                SI.SetHideSalesDialog(false);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostInvoices; PostInvoices)
                    {
                        Caption = 'Post Invoice';
                        ApplicationArea = Basic, Suite;
                        Enabled = false;
                        ToolTip = 'Not enabled, because it has not been tested.';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnInitReport()
    begin
        PostInvoices := not GuiAllowed;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        SalesHead: Record "Sales Header";
        PurchHead: Record "Purchase Header";
        SalesPost: Codeunit "Sales-Post";
        PurchPost: Codeunit "Purch.-Post";
        SI: Codeunit "Single Instance";
        PostInvoices: Boolean;

    local procedure CreateInvoices(pSalesInvHead: Record "Sales Invoice Header")
    var
        SalesInvLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        Item: Record Item;
        SalesInvCreated: Boolean;
        PurchInvCreated: Boolean;
        UnitCostLCY: Decimal;
        SalesDocType: Enum "Sales Document Type";
        PurchDocType: Enum "Purchase Document Type";
        LiNoSI: Integer;
        LiNoPI: Integer;
    begin
        SalesInvLine.SetRange("Document No.", pSalesInvHead."No.");
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesInvLine.SetFilter(Quantity, '<>0');
        if SalesInvLine.FindSet then begin
            SalesInvCreated := CreateSalesHead(pSalesInvHead."No.", SalesDocType::Invoice, pSalesInvHead."Dimension Set ID");
            PurchInvCreated := CreatePurchHead(pSalesInvHead."No.", PurchDocType::Invoice, pSalesInvHead."Dimension Set ID");

            repeat
                if SalesInvLine."Unit Cost (LCY)" = 0 then begin
                    Item.SetAutoCalcFields("Actual FOB Price");
                    Item.Get(SalesInvLine."No.");
                    if Item."Actual FOB Price" <> 0 then
                        UnitCostLCY := Item."Actual FOB Price"
                    else
                        UnitCostLCY := Item."Unit Cost";
                end else
                    UnitCostLCY := SalesInvLine."Unit Cost (LCY)";

                if UnitCostLCY <> 0 then begin
                    if SalesInvCreated then begin
                        LiNoSI += 10000;
                        Clear(SalesLine);
                        SalesLine.Init;
                        SalesLine.Validate("Document Type", SalesHead."Document Type");
                        SalesLine.Validate("Document No.", SalesHead."No.");
                        SalesLine.Validate("Line No.", LiNoSI);
                        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                        SalesLine.Validate("No.", SalesSetup."NL to DK Debit Account No.");
                        SalesLine.Validate(Description, SalesInvLine."No.");
                        SalesLine.Validate(Quantity, SalesInvLine.Quantity);
                        SalesLine.Validate("Unit Price", UnitCostLCY);
                        SalesLine.Insert(true);

                        LiNoSI += 10000;
                        Clear(SalesLine2);
                        SalesLine2.Init;
                        SalesLine2.Validate("Document Type", SalesHead."Document Type");
                        SalesLine2.Validate("Document No.", SalesHead."No.");
                        SalesLine2.Validate("Line No.", LiNoSI);
                        SalesLine2.Validate(Type, SalesLine.Type::"G/L Account");
                        SalesLine2.Validate("No.", SalesSetup."NL to DK Credit Account No.");
                        SalesLine2.Validate("VAT Prod. Posting Group", SalesSetup."NL to DK VAT Prod. Post. Grp.");
                        SalesLine2.Validate(Description, SalesInvLine."No.");
                        SalesLine2.Validate(Quantity, -SalesLine.Quantity);
                        SalesLine2.Validate("Unit Price", UnitCostLCY);
                        SalesLine2.Insert(true);
                    end;

                    if PurchInvCreated then begin
                        LiNoPI += 10000;
                        Clear(PurchLine);
                        PurchLine.Init;
                        PurchLine.Validate("Document Type", PurchHead."Document Type");
                        PurchLine.Validate("Document No.", PurchHead."No.");
                        PurchLine.Validate("Line No.", LiNoPI);
                        PurchLine.Validate(Type, PurchLine.Type::"G/L Account");
                        PurchLine.Validate("No.", PurchSetup."NL to DK Debit Account No.");
                        PurchLine.Validate(Description, SalesInvLine."No.");
                        PurchLine.Validate(Quantity, SalesInvLine.Quantity);
                        PurchLine.Validate("Direct Unit Cost", UnitCostLCY);
                        PurchLine.Insert(true);

                        LiNoPI += 10000;
                        Clear(PurchLine2);
                        PurchLine2.Init;
                        PurchLine2.Validate("Document Type", PurchHead."Document Type");
                        PurchLine2.Validate("Document No.", PurchHead."No.");
                        PurchLine2.Validate("Line No.", LiNoPI);
                        PurchLine2.Validate(Type, PurchLine.Type::"G/L Account");
                        PurchLine2.Validate("No.", PurchSetup."NL to DK Credit Account No.");
                        PurchLine2.Validate("VAT Prod. Posting Group", PurchSetup."NL to DK VAT Prod. Post. Grp.");
                        PurchLine2.Validate(Description, SalesInvLine."No.");
                        PurchLine2.Validate(Quantity, -PurchLine.Quantity);
                        PurchLine2.Validate("Direct Unit Cost", UnitCostLCY);
                        PurchLine2.Insert(true);
                    end;
                end;
            until SalesInvLine.Next = 0;
        end;
    end;

    local procedure CreateSalesHead(pNo: Code[20]; pDocType: Enum "Sales Document Type"; pDimSetID: Integer) rValue: Boolean
    var
        SalesHead2: Record "Sales Header";
        SalesInvHead: Record "Sales Invoice Header";
        SalesCrdHead: Record "Sales Cr.Memo Header";
    begin
        SalesHead2.SetRange("Document Type", pDocType);
        SalesHead2.SetRange("NL to DK Reverse Chg. Doc No.", pNo);
        SalesInvHead.SetRange("NL to DK Reverse Chg. Doc No.", pNo);
        SalesCrdHead.SetRange("NL to DK Reverse Chg. Doc No.", pNo);
        if SalesHead2.IsEmpty and SalesInvHead.IsEmpty and SalesCrdHead.IsEmpty then begin
            Clear(SalesHead);
            SalesHead.init;
            SalesHead.Validate("Document Type", pDocType);

            SalesHead.Insert(true);
            SalesHead.Validate("Sales Order Type", SalesHead."Sales Order Type"::"G/L Account");
            SalesHead.Validate("Sell-to Customer No.", SalesSetup."NL to DK Customer No.");
            SalesHead.validate("External Document No.", pNo);
            SalesHead.Validate("NL to DK Reverse Chg. Doc No.", pNo);
            SalesHead.Validate("Dimension Set ID", pDimSetID);
            SalesHead.Modify(true);
            rValue := true;
        end else
            NLtoDKRevChargePosted(pNo, pDocType);
    end;

    local procedure CreatePurchHead(pNo: Code[20]; pDocType: Enum "Purchase Document Type"; pDimSetID: Integer) rValue: Boolean
    var
        PurchHead2: Record "Purchase Header";
        PurchInvHead: Record "Purch. Inv. Header";
        PurchCrdHead: Record "Purch. Cr. Memo Hdr.";
    begin
        PurchHead2.SetRange("Document Type", pDocType);
        PurchHead2.SetRange("NL to DK Reverse Chg. Doc No.", pNo);
        PurchInvHead.SetRange("NL to DK Reverse Chg. Doc No.", pNo);
        PurchCrdHead.SetRange("NL to DK Reverse Chg. Doc No.", pNo);
        if PurchHead2.IsEmpty and PurchInvHead.IsEmpty and PurchCrdHead.IsEmpty then begin
            Clear(PurchHead);
            PurchHead.init;
            PurchHead.Validate("Document Type", pDocType);
            PurchHead.Insert(true);
            PurchHead.Validate("Buy-from Vendor No.", PurchSetup."NL to DK Vendor No.");
            If pDocType = pDocType::Invoice then
                PurchHead.Validate("Vendor Invoice No.", pNo)
            else
                PurchHead.Validate("Vendor Cr. Memo No.", pNo);
            PurchHead.Validate("NL to DK Reverse Chg. Doc No.", pNo);
            PurchHead.Validate("Dimension Set ID", pDimSetID);
            PurchHead.Modify(true);
            rValue := true;
        end;
    end;

    procedure NLtoDKRevChargePosted(pNo: Code[20]; pDocType: Enum "Sales Document Type")
    var
        SalesInvHead: Record "Sales Invoice Header";
        SalesCrdHead: Record "Sales Cr.Memo Header";
        PurchInvHead: Record "Purch. Inv. Header";
        PurchCrdHead: Record "Purch. Cr. Memo Hdr.";
    begin
        case pDocType of
            pDocType::Invoice:
                begin
                    SalesInvHead.SetRange("NL to DK Reverse Chg. Doc No.", pNo);
                    PurchInvHead.SetRange("NL to DK Reverse Chg. Doc No.", pNo);
                    if not SalesInvHead.IsEmpty and not PurchInvHead.IsEmpty then begin
                        SalesInvHead.Reset();
                        if SalesInvHead.get(pNo) then begin
                            SalesInvHead."NL to DK Rev. Charge Posted" := true;
                            SalesInvHead.Modify();
                        end;
                    end;
                end;
            pDocType::"Credit Memo":
                begin
                    SalesCrdHead.SetRange("NL to DK Reverse Chg. Doc No.", pNo);
                    PurchInvHead.SetRange("NL to DK Reverse Chg. Doc No.", pNo);
                    if not SalesCrdHead.IsEmpty and not PurchCrdHead.IsEmpty then begin
                        SalesCrdHead.Reset();
                        if SalesCrdHead.get(pNo) then begin
                            SalesCrdHead."NL to DK Rev. Charge Posted" := true;
                            SalesCrdHead.Modify();
                        end;
                    end;
                end;
        end;
    end;

    procedure InitReport(NewPostInvoices: Boolean)
    begin
        PostInvoices := NewPostInvoices;
    end;
}
