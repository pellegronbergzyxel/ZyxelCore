Table 50014 "Daily E-mail Report"
{

    fields
    {
        field(1; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Claim Report,Daily Sales Report';
            OptionMembers = " ","Claim Report","Daily Sales Report";
        }
        field(2; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "E-mail"; Text[250])
        {
            Caption = 'E-mail';
        }
        field(5; "E-mail Address Code"; Code[10])
        {
            Caption = 'E-mail Address Code';
            TableRelation = "E-mail address";
        }
        field(6; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(11; "Forecast Territory Filter"; Text[50])
        {
            Caption = 'Filter';
            TableRelation = "Forecast Territory";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(12; Filename; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Source Type", "Source Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
