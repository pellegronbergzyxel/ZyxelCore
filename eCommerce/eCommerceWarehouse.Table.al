Table 50077 "eCommerce Warehouse"
{
    Caption = 'eCommerce Warehouse';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Sales Channel"; Code[10])
        {
            Caption = 'Sales Channel';
        }
        field(4; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
                recAmzHead: Record "eCommerce Order Header";
            begin
                recAmzHead.SetRange("Warehouse Code", Code);
                recAmzHead.SetFilter("Ship From Country", '%1', '');
                if recAmzHead.FindSet(true) then
                    repeat
                        recAmzHead.Validate("Ship From Country", "Country Code");
                        recAmzHead.ValidateDocument;
                        recAmzHead.Modify(true);
                    until recAmzHead.Next() = 0;
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
}
