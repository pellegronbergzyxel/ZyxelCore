Table 50121 "Additional Item"
{
    // 001. 20-11-18 ZY-LD 2018111910000071 - New field.
    // 002. 08-10-20 ZY-LD P0494 - New field.

    Caption = 'Additional Items';
    DataCaptionFields = "Additional Item No.";
    Description = 'Additional Items';
    DrillDownPageID = "Additional Item List";
    LookupPageID = "Additional Item List";

    fields
    {
        field(1; "Ship-to Country/Region"; Code[20])
        {
            Caption = 'Ship-to Country/Region';
            TableRelation = "Country/Region".Code;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(3; "Additional Item No."; Code[20])
        {
            Caption = 'Additional Item No.';
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                CalcFields("Additional Item Description");
            end;
        }
        field(4; Quantity; Integer)
        {
            BlankZero = true;
            Caption = 'Quantity';
            MaxValue = 999;
            MinValue = 0;
        }
        field(5; "Hide Line"; Boolean)
        {
            Caption = 'Hide Line';
            InitValue = true;
        }
        field(6; "Forecast Territory"; Code[10])
        {
            Caption = 'Forecast Territory';
            Description = '20-11-18 ZY-LD 001';
            TableRelation = "Forecast Territory";
        }
        field(7; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = '20-11-18 ZY-LD 001';
            TableRelation = Customer;
        }
        field(8; "Edit Additional Sales Line"; Boolean)
        {
            Caption = 'Edit Additional Sales Line';
            Description = '08-10-20 ZY-LD 002';

            trigger OnValidate()
            begin
                //>> 15-10-20 ZY-LD 002
                recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                recSalesLine.SetRange("No.", "Additional Item No.");
                recSalesLine.SetFilter("Additional Item Line No.", '<>0');
                recSalesLine.SetFilter("Outstanding Quantity", '<>0');
                if recSalesLine.FindSet(true) then
                    repeat
                        recSalesLine."Edit Additional Sales Line" := "Edit Additional Sales Line";
                        recSalesLine.Modify(true);
                    until recSalesLine.Next() = 0;
                //<< 15-10-20 ZY-LD 002
            end;
        }
        field(10; Description; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Additional Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Additional Item No.")));
            Caption = 'Additional Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
    }

    keys
    {
        key(Key1; "Item No.", "Ship-to Country/Region", "Forecast Territory", "Customer No.", "Additional Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Creation Date" := Today;
    end;

    var
        recSalesLine: Record "Sales Line";
}
