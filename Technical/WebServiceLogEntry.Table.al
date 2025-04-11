Table 62009 "Web Service Log Entry"
{
    // 001. 12-04-19 ZY-LD P0218 - New field.
    // 002. 16-04-24 ZY-LD 000 - Procedure is created here.

    Caption = 'Web Service Log Entry';
    DrillDownPageID = "Web Service Log Entries";
    LookupPageID = "Web Service Log Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Web Service Name"; Code[20])
        {
            Caption = 'Web Service Name';
        }
        field(3; "Web Service Function"; Code[50])
        {
            Caption = 'Web Service Function';
        }
        field(4; "Start Time"; DateTime)
        {
            Caption = 'Start Time';
        }
        field(5; "End Time"; DateTime)
        {
            Caption = 'End Time';
        }
        field(6; "Quantity Inserted"; Integer)
        {
            Caption = 'Quantity Inserted';
        }
        field(7; "Quantity Deleted"; Integer)
        {
            Caption = 'Quantity Deleted';
        }
        field(8; "User ID"; Code[100])
        {
        }
        field(9; "Filter"; Text[250])
        {
            Caption = 'Filter';
        }
        field(11; "Quantity Modified"; Integer)
        {
            Caption = 'Quantity Modified';
        }
        field(12; "Quantity Sent"; Integer)
        {
            Caption = 'Quantity Sent';
            Description = '12-04-19 ZY-LD 001';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure CreateWebServiceLog(FunctionName: Text; FilterText: Text)
    begin
        //>> 16-04-24 ZY-LD 002
        Clear(Rec);
        Rec.LockTable;
        Rec."Web Service Name" := 'HQWEBSERVICE';
        Rec."Web Service Function" := CopyStr(FunctionName, 1, MaxStrLen(Rec."Web Service Function"));
        Rec.filter := CopyStr(FilterText, 1, MaxStrLen(Rec.filter));
        Rec."Start Time" := CurrentDateTime();
        Rec."User ID" := UserId();
        Rec.Insert();
        //<< 16-04-24 ZY-LD 002
    end;

    procedure CloseWebServiceLog()
    begin
        //>> 16-04-24 ZY-LD 002
        Rec."End Time" := CurrentDatetime;
        Rec.Modify();
        //<< 16-04-24 ZY-LD 002
    end;

}
