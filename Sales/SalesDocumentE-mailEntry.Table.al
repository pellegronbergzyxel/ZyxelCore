Table 50027 "Sales Document E-mail Entry"
{
    // 001. 01-12-23 ZY-LD 000 - New field.

    Caption = 'Sales Document E-mail Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = " ","Posted Sales Invoice","Posted Sales Credit Memo";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = if ("Document Type" = filter("Posted Sales Invoice")) "Sales Invoice Header"
            else
            if ("Document Type" = const("Posted Sales Credit Memo")) "Sales Cr.Memo Header";
        }
        field(4; "Send E-mail at"; DateTime)
        {
            Caption = 'Send E-mail at';
        }
        field(5; Sent; Boolean)
        {
            Caption = 'Sent';

            trigger OnValidate()
            begin
                if Sent then begin
                    "E-mail Sent at" := CurrentDatetime;
                    "On Hold" := '';
                end;
            end;
        }
        field(6; "E-mail Sent at"; DateTime)
        {
            Caption = 'E-mail Sent at';
        }
        field(7; "Created in Job Queue"; Boolean)  // 01-12-23 ZY-LD 001
        {
            Caption = 'Created in Job Queue';
        }
        field(11; "E-mail Address Code"; Code[10])
        {
            Caption = 'E-mail Address Code';
            TableRelation = "E-mail address";
        }
        field(12; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Document No.", "Send E-mail at")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "E-mail Address Code" = '' then begin
            recAutoSetup.Get;
            if "Send E-mail at" = 0DT then begin
                if recAutoSetup."Delay Btw. Post and Send Email" = 0 then
                    recAutoSetup."Delay Btw. Post and Send Email" := 60;
                "Send E-mail at" := CurrentDatetime + (1000 * 60 * recAutoSetup."Delay Btw. Post and Send Email");
            end;

            "On Hold" := recAutoSetup."On Hold for Sales Document";
        end;
    end;

    var
        recAutoSetup: Record "Automation Setup";
}
