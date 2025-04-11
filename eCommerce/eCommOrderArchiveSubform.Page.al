page 50066 "eComm. Order Archive Subform"
{
    AutoSplitKey = true;
    Caption = 'eCommerce Order Archive Subform';
    DeleteAllowed = false;
    Editable = false;
    PageType = ListPart;
    SourceTable = "eCommerce Order Line Archive";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
            group(Control7)
            {
                group(Control6)
                {
                    field("recAmzOrderArch.""Total (Exc. Tax)"""; recAmzOrderArch."Total (Exc. Tax)")
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(recAmzOrderArch."Currency Code");
                        Caption = 'Total Amount Excl. VAT';
                        Editable = false;
                    }
                    field("recAmzOrderArch.""Total Tax Amount"""; recAmzOrderArch."Total Tax Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(recAmzOrderArch."Currency Code");
                        Caption = 'Total VAT';
                        Editable = false;
                    }
                    field("recAmzOrderArch.""Total (Inc. Tax)"""; recAmzOrderArch."Total (Inc. Tax)")
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(recAmzOrderArch."Currency Code");
                        Caption = 'Total Amount Incl. VAT';
                        Editable = false;
                    }
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
