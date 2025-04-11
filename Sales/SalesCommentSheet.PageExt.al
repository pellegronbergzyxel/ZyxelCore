pageextension 50138 SalesCommentSheetZX extends "Sales Comment Sheet"
{
    layout
    {
        addafter("Code")
        {
            field("User Id"; Rec."User Id")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
