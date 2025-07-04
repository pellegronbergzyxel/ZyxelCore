pageextension 50204 BusinessManagerEvaluationZX extends "Business Manager Role Center"
{
    //03-07-2025 BK IT related
    layout
    {
        addafter("Intercompany Activities")
        {
            part("Delivery Documents"; "Delivery Document Cue")
            {
                Caption = 'Delivery Documents';
                Visible = False;
            }
            part(Logicall; "Logicall Cue")
            {
                Caption = 'Logicall';
                Visible = False;
            }
            part("Picking Dates"; "Picking Dates Cue")
            {
                Caption = 'Picking Dates';
                Visible = False;
            }

        }
    }
}