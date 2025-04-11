page 50154 "Edit eCommerce Order Line"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "eCommerce Order Line";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                group(Amount)
                {
                    Caption = 'Amount';
                    field("Total (Exc. Tax)"; Rec."Total (Exc. Tax)")
                    {
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            SumTotal;
                        end;
                    }
                    field("Total Tax Amount"; Rec."Total Tax Amount")
                    {
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            SumTotal;
                        end;
                    }
                    field("Total (Inc. Tax)"; Rec."Total (Inc. Tax)")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                }
                group(Promo)
                {
                    field("Total Promo (Exc. Tax)"; Rec."Total Promo (Exc. Tax)")
                    {
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            SumTotal;
                        end;
                    }
                    field("Total Promo Tax Amount"; Rec."Total Promo Tax Amount")
                    {
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            SumTotal;
                        end;
                    }
                    field("Total Promo (Inc. Tax)"; Rec."Total Promo (Inc. Tax)")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                }
                group(Shipping)
                {
                    field("Total Shipping (Exc. Tax)"; Rec."Total Shipping (Exc. Tax)")
                    {
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            SumTotal;
                        end;
                    }
                    field("Total Shipping Tax Amount"; Rec."Total Shipping Tax Amount")
                    {
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            SumTotal;
                        end;
                    }
                    field("Total Shipping (Inc. Tax)"; Rec."Total Shipping (Inc. Tax)")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                }
                group(Discount)
                {
                    field("Line Discount Excl. Tax"; Rec."Line Discount Excl. Tax")
                    {
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            SumTotal;
                        end;
                    }
                    field("Line Discount Tax Amount"; Rec."Line Discount Tax Amount")
                    {
                        ApplicationArea = Basic, Suite;

                        trigger OnValidate()
                        begin
                            SumTotal;
                        end;
                    }
                    field("Line Discount Incl. Tax"; Rec."Line Discount Incl. Tax")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                }
            }
        }
    }

    local procedure SumTotal()
    begin
        Rec."Total (Inc. Tax)" := Rec."Total (Exc. Tax)" + Rec."Total Tax Amount";
        Rec."Total Promo (Inc. Tax)" := Rec."Total Promo (Exc. Tax)" + Rec."Total Promo Tax Amount";
        Rec."Total Shipping (Inc. Tax)" := Rec."Total Shipping (Exc. Tax)" + Rec."Total Shipping Tax Amount";
        Rec."Line Discount Incl. Tax" := Rec."Line Discount Excl. Tax" + Rec."Line Discount Tax Amount";
    end;
}
