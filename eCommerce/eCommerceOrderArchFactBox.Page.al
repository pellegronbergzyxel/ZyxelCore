page 50313 "eCommerce Order Arch. FactBox"
{
    Caption = 'Sales Details';
    PageType = CardPart;
    SourceTable = "eCommerce Order Archive";

    layout
    {
        area(content)
        {
            group(Control8)
            {
                ShowCaption = false;
                field("eCommerce Order Id"; Rec."eCommerce Order Id")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = true;
                }
                field("Sell-to Type"; Rec."Sell-to Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Total)
                {
                    Caption = 'Total';
                    field(Amount; Rec.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Tax Amount"; Rec."Tax Amount")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Amount Including VAT"; Rec."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;

        DiscountPct := 1;
        if Rec."Total (Exc. Tax)" <> 0 then
            TotalExTax := Rec."Total (Exc. Tax)" - (Rec."Total (Exc. Tax)" * DiscountPct / 100)
        else
            TotalExTax := 0;
        if Rec."Total Tax Amount" <> 0 then
            TotalTax := Rec."Total Tax Amount" - (Rec."Total Tax Amount" * DiscountPct / 100)
        else
            TotalTax := 0;
        if Rec."Total (Inc. Tax)" <> 0 then
            TotalInclTax := Rec."Total (Inc. Tax)" - (Rec."Total (Inc. Tax)" * DiscountPct / 100)
        else
            TotalInclTax := 0;
    end;

    trigger OnOpenPage()
    begin
        SetActions;
    end;

    var
        Text001: Label 'zfasdf';
        TotalExTax: Decimal;
        TotalTax: Decimal;
        TotalInclTax: Decimal;
        DiscountPct: Decimal;
        AmountDetailVisible: Boolean;
        ShippingExclVatVisible: Boolean;
        PromoExclVatVisible: Boolean;

    local procedure SetActions()
    begin
        Rec.CalcFields(Rec."Promotion Excl. VAT", Rec."Shipping Excl. VAT");
        AmountDetailVisible := ((Rec."Promotion Excl. VAT" <> 0) or (Rec."Shipping Excl. VAT" <> 0));
        ShippingExclVatVisible := Rec."Shipping Excl. VAT" <> 0;
        PromoExclVatVisible := Rec."Promotion Excl. VAT" <> 0;
    end;
}
