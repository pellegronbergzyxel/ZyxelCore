Table 50001 "Invoice Description"
{
    // 001.  DT1.06  14-07-2010  SH
    //  .Object created
    // 002.  DT1.07  15-07-2010  SH
    //  .Delete lines belonging to code
    // 
    // 003. 30-07-18 2018072710000206 - "SQL Data Type" on the field Code is set to Integer.

    Caption = 'Invoice Description';
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "Invoice Description List";
    LookupPageID = "Invoice Description List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            SQLDataType = Integer;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
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
        Lines.SetRange("Invoice Description Code", Code);
        Lines.DeleteAll;
    end;

    var
        Lines: Record "Invoice Line Text";
}
