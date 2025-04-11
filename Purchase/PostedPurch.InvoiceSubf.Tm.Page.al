Page 50231 "Posted Purch. Invoice Subf. Tm"
{
    // 001.  DT1.00  01-07-2010  TS
    // .Fields Added
    // 50001 Requested Date From Factory
    // 50002 ETD Date
    // 50003 ETA
    // 50004 Actual shipment date

    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Purch. Inv. Line";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cross-Reference No."; Rec."Item Reference No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Insurance No."; Rec."Insurance No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Budgeted FA No."; Rec."Budgeted FA No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("FA Posting Type"; Rec."FA Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Depr. until FA Posting Date"; Rec."Depr. until FA Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Depreciation Book Code"; Rec."Depreciation Book Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Depr. Acquisition Cost"; Rec."Depr. Acquisition Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Requested Date From Factory"; Rec."Requested Date From Factory")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("ETD Date"; Rec."ETD Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Actual shipment date"; Rec."Actual shipment date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Deferral Code"; Rec."Deferral Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
            group(Control31)
            {
                group(Control25)
                {
                    field("Invoice Discount Amount"; TotalPurchInvHeader."Invoice Discount Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalPurchInvHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATCaption(TotalPurchInvHeader."Prices Including VAT");
                        Caption = 'Invoice Discount Amount';
                        Editable = false;
                    }
                }
                group(Control7)
                {
                    field("Total Amount Excl. VAT"; TotalPurchInvHeader.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalPurchInvHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(TotalPurchInvHeader."Currency Code");
                        Caption = 'Total Amount Excl. VAT';
                        DrillDown = false;
                        Editable = false;
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalPurchInvHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(TotalPurchInvHeader."Currency Code");
                        Caption = 'Total VAT';
                        Editable = false;
                    }
                    field("Total Amount Incl. VAT"; TotalPurchInvHeader."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatExpression = TotalPurchInvHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(TotalPurchInvHeader."Currency Code");
                        Caption = 'Total Amount Incl. VAT';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = true;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        DocumentTotals.CalculatePostedPurchInvoiceTotals(TotalPurchInvHeader, VATAmount, Rec);
    end;

    trigger OnOpenPage()
    begin
        GetRecords;
    end;

    var
        TotalPurchInvHeader: Record "Purch. Inv. Header";
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: Decimal;

    local procedure GetRecords()
    var
        lBillToCust: Record Customer;
        lICPartner: Record "IC Partner";
        lSalesInvoiceHeader: Record "Sales Invoice Header";
        lPurchInvHeader: Record "Purch. Inv. Header";
        lPurchInvLine: Record "Purch. Inv. Line";
        SI: Codeunit "Single Instance";
    begin
        lSalesInvoiceHeader.Get(SI.GetSalesInvoiceNo);
        if lBillToCust.Get(lSalesInvoiceHeader."Bill-to Customer No.") then
            if lBillToCust."IC Partner Code" <> '' then
                if lICPartner.Get(lBillToCust."IC Partner Code") and (lICPartner."Inbox Type" = lICPartner."inbox type"::Database) then begin
                    lPurchInvHeader.ChangeCompany(lICPartner."Inbox Details");
                    lPurchInvHeader.SetRange("Vendor Invoice No.", SI.GetSalesInvoiceNo);
                    if lPurchInvHeader.FindFirst then begin
                        lPurchInvLine.ChangeCompany(lICPartner."Inbox Details");
                        lPurchInvLine.SetRange("Document No.", lPurchInvHeader."No.");
                        if lPurchInvLine.FindSet then
                            repeat
                                Rec := lPurchInvLine;
                                Rec.Insert;
                            until lPurchInvLine.Next() = 0;
                    end;
                end;
    end;
}
