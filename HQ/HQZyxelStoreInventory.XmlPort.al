xmlport 50000 "HQ Zyxel Store Inventory"
{
    Caption = 'HQ Zyxel Store Inventory';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/ZyStoreInv';
    Direction = Both;
    Format = Xml;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;
    schema
    {
        textelement(root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'Item';
                MinOccurs = Once;
                MaxOccurs = Unbounded;
                UseTemporary = true;
                fieldelement(ItemNo; Item."No.") { }
                fieldelement(Inventory; Item.Inventory)
                {
                    AutoCalcField = false;
                    MinOccurs = Zero;
                }
            }
        }
    }

    procedure ProcessData(): Boolean
    var
        recItem: Record Item;
        ItemLogEnvent: Codeunit "Item / Logistic Events";
    begin
        recItem.SetRange("Location Filter", ItemLogEnvent.GetMainWarehouseLocation);
        if item.FindSet() then
            repeat
                recItem.get(Item."No.");
                Item.Inventory := recItem.CalcAvailableStock(true);
                Item.Modify();
            until Item.next = 0;
    end;
}
