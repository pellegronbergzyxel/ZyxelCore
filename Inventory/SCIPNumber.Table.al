table 50054 "SCIP Number"
{
    // 001 16-04-24 ZY-LD 000 - Created.

    Caption = 'SCIP Number';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(2; "SCIP No."; Text[50])
        {
            Caption = 'SCIP No.';
        }
    }
    keys
    {
        key(PK; "Item No.", "SCIP No.")
        {
            Clustered = true;
        }
    }
}
