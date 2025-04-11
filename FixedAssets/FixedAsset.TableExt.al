tableextension 50205 FixedAssetZX extends "Fixed Asset"
{
    Caption = 'Fixed Asset';
    fields
    {
        modify("No.")
        {
            Caption = 'No.';
        }
        modify(Description)
        {
            Caption = 'Description';
        }
        modify("Description 2")
        {
            Caption = 'Description 2';
        }
        modify("FA Class Code")
        {
            Caption = 'FA Class Code';
        }
        modify("Vendor No.")
        {
            Caption = 'Vendor No.';
        }
        modify("No. Series")
        {
            Caption = 'No. Series';
        }
        field(50000; "Old Number"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(50001; "Book Value"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("FA Ledger Entry".Amount where("FA No." = field("No."),
                                                             "Part of Book Value" = const(true),
                                                             "FA Posting Date" = field("FA Posting Date Filter")));
            Caption = 'Book Value';
            Description = '18-09-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
