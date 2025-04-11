Table 76121 "Post Grp. pr. Country / Loc."
{
    // 001. 25-02-19 ZY-LD 2019022010000075 - Created for handling consignment stock.

    Caption = 'Post Grp. pr. Country / Loc.';
    DrillDownPageID = "Post Grp. pr. Country / Loc.s";
    LookupPageID = "Post Grp. pr. Country / Loc.s";

    fields
    {
        field(1; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(3; "VAT Prod. Post. Group - Sales"; Code[10])
        {
            Caption = 'VAT Prod. Post. Group - Sales';
            TableRelation = "VAT Product Posting Group";
        }
        field(4; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(5; "VAT Prod. Post. Group - Purch"; Code[10])
        {
            Caption = 'VAT Prod. Post. Group - Purch';
            TableRelation = "VAT Product Posting Group";
        }
    }

    keys
    {
        key(Key1; "Country Code", "Location Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
