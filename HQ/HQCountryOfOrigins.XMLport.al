XmlPort 50025 "HQ Country Of Origins"
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/coo';
    Encoding = UTF8;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'CountryOfOrigin';
                UseTemporary = true;
                fieldelement(ItemNo; Item."No.")
                {
                }
                fieldelement(Code; Item."Country/Region of Origin Code")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }


    procedure GetData(var pItem: Record Item temporary)
    begin
        if Item.FindSet then
            repeat
                pItem := Item;
                pItem.Insert;
            until Item.Next() = 0;
    end;
}
