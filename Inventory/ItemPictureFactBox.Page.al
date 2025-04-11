Page 50000 "Item Picture FactBox"
{
    Caption = 'Item Picture';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field(Picture; Rec.Picture)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        WhseClassCode;
        NetWeight;
    end;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Item Card", Rec);
    end;

    local procedure WhseClassCode(): Code[20]
    begin
        exit(Rec."Warehouse Class Code");
    end;

    local procedure NetWeight(): Decimal
    var
        ItemBaseUOM: Record "Item Unit of Measure";
    begin
        if ItemBaseUOM.Get(Rec."No.", Rec."Base Unit of Measure") then
            exit(ItemBaseUOM.Weight);

        exit(0);
    end;
}
