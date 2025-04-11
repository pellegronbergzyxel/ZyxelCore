Table 50066 "E-mail address"
{
    // 001. 30-11-18 ZY-LD 000 "Sales Order" is added to "Document Usage".
    // 002. 22-08-22 ZY-LD 000 - New field.
    // 003. 08-03-24 ZY-LD 000 - Lookup- and DrillDown page has been added.

    Caption = 'E-mail address';
    LookupPageId = "E-mail Address List";  // 08-03-24 ZY-LD 003
    DrillDownPageId = "E-mail Address List";  // 08-03-24 ZY-LD 003

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; Recipients; Text[250])
        {
            Caption = 'E-mail';
        }
        field(4; "Sender Name"; Text[50])
        {
        }
        field(5; "Sender Address"; Text[50])
        {
        }
        field(6; Subject; Text[100])
        {
        }
        field(7; "Html Formatted"; Boolean)
        {
            InitValue = true;
        }
        field(8; "Body Text"; Boolean)
        {
            CalcFormula = exist("E-mail address Body" where("E-mail Address Code" = field(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; BCC; Text[250])
        {
        }
        field(10; "Document Usage"; Option)
        {
            Caption = 'Document Usage';
            OptionCaption = ' ,Sales Invoice,Sales Credit Memo,Statement,Reminder,Finance Charge Memo,Sales Order,Sales Return Order';
            OptionMembers = " ","Sales Invoice","Sales Credit Memo",Statement,Reminder,"Finance Charge Memo","Sales Order","Sales Return Order";

            trigger OnValidate()
            begin
                //>> 30-11-18 ZY-LD 001
                if Subject = '' then
                    Subject := StrSubstNo(Text002, DelStr(Format("Document Usage"), 1, 6));
                //<< 30-11-18 ZY-LD 001
            end;
        }
        field(11; "Last E-mail Send Date Time"; DateTime)
        {
            Caption = 'Last E-mail Send Date Time';
        }
        field(12; Replicated; Boolean)
        {
            Caption = 'Replicated';
        }
        field(13; "Do Not Replicate"; Boolean)
        {
            Caption = 'Do Not Replicate';
            InitValue = true;
        }
        field(14; "E-mail HTML file"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "E-mail HTML files".Code;
        }
        field(15; "Color Scheme"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "E-mail HTML Color Schemes".Code;
        }
        field(16; "Footer E-Mail"; Text[50])
        {
            Caption = 'Footer E-Mail';
        }
        field(17; "Delay on Automated E-mail"; Integer)
        {
            Caption = 'Delay on Automated E-mail (min.)';
        }
        field(18; "Show Variable Body Text in"; Option)
        {
            Caption = 'Show Variable Body Text in';
            OptionCaption = ' ,Top,Buttom';
            OptionMembers = " ",Top,Buttom;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        EmailaddressBody.SetRange("E-mail Address Code", Code);
        EmailaddressBody.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        //>> 30-11-18 ZY-LD 001
        recCompInfo.Get;
        "Sender Name" := recCompInfo.Name;
        if recCompInfo."Finance E-Mail" <> '' then
            "Sender Address" := recCompInfo."Finance E-Mail"
        else
            "Sender Address" := recCompInfo."E-Mail";
        //<< 30-11-18 ZY-LD 001
    end;

    trigger OnRename()
    begin
        Error(Text001);
    end;

    var
        Text001: label 'You are not allowed to rename.';
        EmailaddressBody: Record "E-mail address Body";
        recCompInfo: Record "Company Information";
        Text002: label '%1 from %21';


    procedure GetEmailAddress(pCode: Code[10]): Text
    var
        lEmailaddress: Record "E-mail address";
    begin
        lEmailaddress.Get(pCode);
        exit(lEmailaddress.Recipients);
    end;
}
