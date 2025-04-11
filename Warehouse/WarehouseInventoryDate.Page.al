Page 50331 "Warehouse Inventory Date"
{
    Caption = 'Warehouse Inventory pr. Date';
    Editable = false;
    PageType = List;
    SourceTable = Date;
    SourceTableView = order(descending)
                      where("Period Type" = const(Date),
                            "Period No." = filter(1 .. 5));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period End"; Rec."Period End")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Period Name"; Rec."Period Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("recItem.""Net Change"""; recItem."Net Change")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory';
                }
                field("recItem.""Warehouse Inventory"""; recItem."Warehouse Inventory")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Plysical Whse. Inventory';
                }
                field("recItem.""Warehouse Inventory""-recItem.""Net Change"""; recItem."Warehouse Inventory" - recItem."Net Change")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Difference';
                    DecimalPlaces = 0 : 5;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        recItem.SetFilter("Date Filter", '..%1', Rec."Period Start");
        recItem.CalcFields("Net Change", "Warehouse Inventory");
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Rec."Period Start", '%1..%2', 20191002D, Today);
        if not Rec.FindFirst then;
        recItem.Get(ItemNo);
        recItem.SetRange("Quanty Type Filter", recItem."quanty type filter"::"On Hand");
        recItem.SetRange("Location Filter", LocationCode);
    end;

    var
        recItem: Record Item;
        ItemNo: Code[20];
        LocationCode: Code[10];


    procedure InitPage(pItemNo: Code[20]; pLocationCode: Code[10])
    begin
        ItemNo := pItemNo;
        LocationCode := pLocationCode;
    end;
}
