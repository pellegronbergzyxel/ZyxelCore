Table 62015 "HR Offices"
{
    // 001. 05-06-18 ZY-LD 2018060410000242 - New field.
    // 002. 29-11-18 ZY-LD 2018111310000046 - New field.

    Caption = 'HR Offices';
    DrillDownPageID = "HR Offices List";
    LookupPageID = "HR Offices List";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            Description = 'PAB 1.0';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            Description = 'PAB 1.0';
        }
        field(3; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
            Description = 'PAB 1.0';
        }
        field(4; Address; Text[50])
        {
            Caption = 'Address';
            Description = 'PAB 1.0';
        }
        field(5; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            Description = 'PAB 1.0';
        }
        field(6; City; Text[30])
        {
            Caption = 'City';
            Description = 'PAB 1.0';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(7; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            Description = 'PAB 1.0';
            ExtendedDatatype = PhoneNo;
        }
        field(8; "Phone No. 2"; Text[30])
        {
            Caption = 'Phone No. 2';
            Description = 'PAB 1.0';
            ExtendedDatatype = PhoneNo;
        }
        field(9; "Telex No."; Text[30])
        {
            Caption = 'Telex No.';
            Description = 'PAB 1.0';
        }
        field(10; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            Description = 'PAB 1.0';
        }
        field(30; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            Description = 'PAB 1.0';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".Code
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".Code where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(31; County; Text[30])
        {
            Caption = 'County';
            Description = 'PAB 1.0';
        }
        field(36; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'PAB 1.0';
            TableRelation = "Country/Region";
        }
        field(37; "HQ Entity"; Code[10])
        {
            Caption = 'HQ Entity';
            Description = '05-06-18 ZY-LD 001';
            TableRelation = "HQ Entity";
        }
        field(38; "Probation Period (Month)"; Integer)
        {
            Caption = 'Probation Period (Month)';
            Description = '29-11-18 ZY-LD 002';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
