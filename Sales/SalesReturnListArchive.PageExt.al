pageextension 50264 SalesReturnListArchiveZX extends "Sales Return List Archive"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Date Archived"; Rec."Date Archived")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Archived By"; Rec."Archived By")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
}
