Table 50002 "Invoice Line Text"
{
    // 
    // 001.  DT1.06  14-07-2010  SH
    //  .Object created

    Caption = 'Invoice Line Text';

    fields
    {
        field(1; "Invoice Description Code"; Code[10])
        {
            Caption = 'Invoice Description Code';
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Line text"; Text[80])
        {
            Caption = 'Line Text';
        }
    }

    keys
    {
        key(Key1; "Invoice Description Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
