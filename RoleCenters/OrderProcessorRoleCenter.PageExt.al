pageextension 50288 OrderProcessorRoleCenterZX extends "Order Processor Role Center"
{
    layout
    {
        addafter(Control1901851508)
        {
            part("Delivery Documents"; "Delivery Document Cue")
            {
                Caption = 'Delivery Documents';
            }
            part(Logicall; "Logicall Cue")
            {
                Caption = 'Logicall';
            }
            part("Picking Dates"; "Picking Dates Cue")
            {
                Caption = 'Picking Dates';
            }

        }
    }
}
