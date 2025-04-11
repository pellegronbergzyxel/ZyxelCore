Table 50113 "E-mail address Body"
{
    // 001. 16-03-22 ZY-LD 2022031610000057 - New field.

    Caption = 'E-mail address Body';

    fields
    {
        field(1; "E-mail Address Code"; Code[10])
        {
            Caption = 'E-mail Address Code';
            TableRelation = "E-mail address";
        }
        field(2; "Language Code"; Code[10])
        {
            TableRelation = Language;
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Body Text"; Text[250])
        {
        }
        field(5; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Description = '16-03-22 ZY-LD 001';
            TableRelation = Customer;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "E-mail Address Code", "Language Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnRename()
    begin
        Error(Text001);
    end;

    var
        Text001: label 'You are not allowed to rename.';


    procedure GetEmailAddress(pCode: Code[10]): Text
    var
        lEmailaddress: Record "E-mail address";
    begin
        lEmailaddress.Get(pCode);
        exit(lEmailaddress.Recipients);
    end;
}
