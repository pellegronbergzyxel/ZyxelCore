pageextension 50196 BlanketSalesOrderZX extends "Blanket Sales Order"
{
    layout
    {
        addafter("Document Date")
        {
            field(LocationCode2; Rec."Location Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
