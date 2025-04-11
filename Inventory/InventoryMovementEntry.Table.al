Table 50110 "Inventory Movement Entry"
{
    // 001. 15-04-20 ZY-LD 2020041410000035 - Max. Aging Code is added to the primary key.

    Caption = 'Inventory Movement Entry';
    DrillDownPageID = "Inventory Movement Entry";
    LookupPageID = "Inventory Movement Entry";

    fields
    {
        field(1; Year; Integer)
        {
            Caption = 'Year';
            NotBlank = true;
        }
        field(2; Month; Integer)
        {
        }
        field(4; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(5; "Max. Aging Code"; Code[10])
        {
            Caption = 'Max. Aging Code';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 0;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(8; "Period End Date"; Date)
        {
            Caption = 'Period End Date';
        }
        field(9; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(10; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
        }
    }

    keys
    {
        key(Key1; Year, Month, "Item No.", "Max. Aging Code")
        {
            Clustered = true;
        }
        key(Key2; "Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Creation Date" := Today;
    end;

    trigger OnModify()
    begin
        if Today > "Creation Date" then
            "Last Modified Date" := Today;
    end;
}
