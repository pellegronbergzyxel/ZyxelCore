pageextension 50260 RevaluationJournalZX extends "Revaluation Journal"
{
    layout
    {
        modify("Posting Date")
        {
            Editable = true;
        }
        addafter("Applies-to Entry")
        {
            field("Unit Cost (Difference)"; Rec."Unit Cost (Difference)")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Reason Code")
        {
            field("Item Ledg. Entry Doc. Type"; Rec."Item Ledg. Entry Doc. Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Unit Cost (Difference)" := Rec."Unit Cost (Revalued)" - Rec."Unit Cost (Calculated)";  // 14-02-20 ZY-LD 002
    end;
}
