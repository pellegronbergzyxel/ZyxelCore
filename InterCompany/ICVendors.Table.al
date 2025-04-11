Table 50007 "IC Vendors"
{
    // 
    // 001.  DT2.11  25-10-2011  SH
    //  .Object created

    DrillDownPageID = "VAT Registration No";
    LookupPageID = "VAT Registration No";

    fields
    {
        field(1; Identification; Code[10])
        {
            Caption = 'Identification';
        }
        field(2; "VAT registration No"; Text[30])
        {
            Caption = 'VAT Registration No.';
        }
        field(50000; "IC Company Name"; Text[30])
        {
            Caption = 'IC Company Name';
            Description = 'RD CZ 1.0';
        }
        field(50001; "IC Location 1"; Code[20])
        {
            Caption = 'IC Location 1';
            Description = 'RD CZ 1.0';
            TableRelation = Location.Code;
        }
        field(50002; "IC Vendor 1"; Code[20])
        {
            Caption = 'IC Vendor 1';
            Description = 'RD CZ 1.0';
        }
        field(50003; "IC Location 2"; Code[20])
        {
            Caption = 'IC Location 2';
            Description = 'RD CZ 1.0';
            TableRelation = Location.Code;
        }
        field(50004; "IC Vendor 2"; Code[20])
        {
            Caption = 'IC Vendor 2';
            Description = 'RD CZ 1.0';
        }
        field(50005; "Sub Yes/No"; Boolean)
        {
            Caption = 'Sub Yes/No';
            Description = 'RD CZ 1.0';
        }
        field(50006; "Currency code"; Code[10])
        {
            Caption = 'Currency Code';
            Description = 'RD CZ 1.0';
        }
        field(50007; "Intern Customer"; Code[20])
        {
            Caption = 'Internal Customer';
            Description = 'RD CZ 1.0';
        }
        field(50008; Sphairon; Code[20])
        {
            Caption = 'Sphairon';
            Description = 'RD 2.0';
        }
        field(50009; "IC Location 3"; Code[20])
        {
            Caption = 'IC Location 3';
            Description = 'RD 3.0';
        }
        field(50010; "IC Vendor 3"; Code[20])
        {
            Caption = 'IC Vendor 3';
            Description = 'RD 3.0';
        }
        field(50011; "IC Location 4"; Code[20])
        {
            Caption = 'IC Location 4';
            Description = 'RD 3.0';
        }
        field(50012; "IC Vendor 4"; Code[20])
        {
            Caption = 'IC Vendor 4';
            Description = 'RD 3.0';
        }
        field(50013; "IC Location 5"; Code[20])
        {
            Caption = 'IC Location 5';
            Description = 'RD 3.0';
        }
        field(50014; "IC Vendor 5"; Code[20])
        {
            Caption = 'IC Vendor 5';
            Description = 'RD 3.0';
        }
        field(50015; "Gen.Bus.Posting Group"; Code[10])
        {
            Caption = 'Gen.Bus.Posting Group';
            Description = 'RD 4.0';
        }
        field(50016; "VAT Bus.Posting Group 3P"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group 3P';
            Description = 'RD 4.0';
        }
        field(50017; "VAT Bus.Posting Group Rev"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group Rev';
            Description = 'RD 4.0';
        }
        field(50018; UID; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; Identification)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
