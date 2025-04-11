tableextension 50141 GenBusinessPostingGroupZX extends "Gen. Business Posting Group"
{
    fields
    {
        field(50000; "Sample / Test Equipment"; Option)
        {
            Caption = 'Sample / Test Equipment';
            Description = '13-08-19 ZY-LD 001';
            OptionCaption = ' ,Sample (Unit Price = Unit Cost),Sample (Unit Price = Zero),Test Equipment';
            OptionMembers = " ","Sample (Unit Price = Unit Cost)","Sample (Unit Price = Zero)","Test Equipment";
        }
        field(50001; "Sample G/L Account No."; Code[20])
        {
            Caption = 'Sample G/L Account No.';
            Description = '04-02-21 ZY-LD 002';
            TableRelation = "G/L Account";
        }
    }
}
