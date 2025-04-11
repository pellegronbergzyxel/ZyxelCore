tableextension 50120 SalesCommentLineZX extends "Sales Comment Line"
{
    fields
    {
        field(50000; "User Id"; Code[50])
        {
            Caption = 'User Id';
            Editable = false;
        }
        field(50001; "From Document No."; Code[20])
        {
            Caption = 'From Document No.';
        }
    }
}
