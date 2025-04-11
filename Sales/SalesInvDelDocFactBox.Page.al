Page 50059 "Sales Inv Del Doc Fact Box"
{
    Editable = false;
    PageType = CardPart;
    SourceTable = "VCK Delivery Document Header";

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Amount; Rec.Amount)
            {
                ApplicationArea = Basic, Suite;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    Page.RunModal(Page::"VCK Delivery Document", Rec);
                end;
            }
        }
    }

    actions
    {
    }
}
