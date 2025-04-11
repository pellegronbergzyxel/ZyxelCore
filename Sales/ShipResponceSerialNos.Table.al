Table 73008 "Ship Responce Serial Nos."
{
    // 001. 19-02-19 PAB - Updated for new NAV XML

    Caption = 'Ship Responce Serial Nos.';
    Description = 'Ship Responce Serial Nos.';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Description = 'PAB 1.0';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'PAB 1.0';
        }
        field(4; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Description = 'PAB 1.0';
        }
        field(5; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            Description = 'PAB 1.0';
        }
        field(6; "Serial No."; Text[200])
        {
            Caption = 'Serial No.';
            Description = 'PAB 1.0';
        }
        field(7; "Order No."; Code[50])
        {
            Caption = 'Order No.';
        }
        field(8; "Index No."; Integer)
        {
            Caption = 'Index No.';
        }
        field(9; "Identical Serial Numbers"; Integer)
        {
            CalcFormula = count("Ship Responce Serial Nos." where("Response No." = field("Response No."),
                                                                   "Serial No." = field("Serial No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(201; "Response No."; Code[20])
        {
            Caption = 'Response No.';
            TableRelation = "Ship Response Header";
        }
        field(202; "Response Line No."; Integer)
        {
            Caption = 'Response Line No.';
        }
    }

    keys
    {
        key(Key1; "Response No.", "Response Line No.", "Serial No.")
        {
            Clustered = true;
        }
        key(Key2; "Sales Order No.", "Sales Order Line No.", "Serial No.")
        {
        }
    }

    fieldgroups
    {
    }
}
