Table 50008 "VCK Country Shipm. Day Sub"
{
    // 001. 06-09-18 ZY-LD 2018090610000046 - Created.

    Caption = 'VCK Country Shipmebt Day Sub';
    DrillDownPageID = "VCK Ship. Detail Received";
    LookupPageID = "VCK Ship. Detail Received";

    fields
    {
        field(1; "Country Code"; Code[20])
        {
            Caption = 'Country Code';
            NotBlank = true;
            TableRelation = "Country/Region";
        }
        field(2; "Week Day"; Integer)
        {
            Caption = 'Week Day';
        }
    }

    keys
    {
        key(Key1; "Country Code", "Week Day")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
