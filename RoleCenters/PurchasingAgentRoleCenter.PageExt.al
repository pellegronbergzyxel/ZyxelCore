pageextension 50289 PurchasingAgentRoleCenterZX extends "Purchasing Agent Role Center"
{
    layout
    {
        addbefore(Control1907662708)
        {
            part("Picking Dates"; "Picking Dates Cue")
            {
                Caption = 'Picking Dates';
            }
        }
        /*addafter(Control1907662708)
        {
            part("Delivery Documents"; "Delivery Document Cue")
            {
                Caption = 'Delivery Documents';
            }
        }*/
    }
}
