page 50264 "eCommerce Order Archive Lines"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Order Archive Lines';
    Editable = false;
    PageType = List;
    SourceTable = "eCommerce Order Line Archive";
    UsageCategory = ReportsandAnalysis;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("eCommerce Order Id"; Rec."eCommerce Order Id")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ASIN; Rec.ASIN)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Item Price (Exc. Tax)"; Rec."Item Price (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Total (Exc. Tax)"; Rec."Total (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Item Price (Inc. Tax)"; Rec."Item Price (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Total Tax Amount"; Rec."Total Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Total (Inc. Tax)"; Rec."Total (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Total Promo (Inc. Tax)"; Rec."Total Promo (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Total Promo Tax Amount"; Rec."Total Promo Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Total Promo (Exc. Tax)"; Rec."Total Promo (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Total Shipping (Inc. Tax)"; Rec."Total Shipping (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Total Shipping Tax Amount"; Rec."Total Shipping Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Total Shipping (Exc. Tax)"; Rec."Total Shipping (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if (Rec."eCommerce Order Id" <> recAmzOrderArch."eCommerce Order Id") or
           (Rec."Invoice No." <> recAmzOrderArch."Invoice No.")
        then begin
            recAmzOrderArch.SetAutoCalcFields("Total (Exc. Tax)", "Total Tax Amount", "Total (Inc. Tax)");
            recAmzOrderArch.Get(Rec."Transaction Type", Rec."eCommerce Order Id", Rec."Invoice No.");
        end;
    end;

    var
        recAmzOrderArch: Record "eCommerce Order Archive";
        DocumentTotals: Codeunit "Document Totals";
}
