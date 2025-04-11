pageextension 50310 ConcurrentSessionListZX extends "Concurrent Session List"
{
    actions
    {
        addfirst(Processing)
        {
            action("Kill Session")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Kill Session';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    if Confirm(Text001, false) then
                        StopSession(Rec."Session ID");
                end;
            }
        }
    }

    var
        Text001: Label 'Kill Session ?';
}
