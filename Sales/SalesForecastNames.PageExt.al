pageextension 50274 SalesForecastNamesZX extends "Item Budget Names"
{
    Caption = 'Sales Forecast Names';

    layout
    {
        modify(Blocked)
        {
            Visible = false;
        }
        modify("Budget Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Budget Dimension 2 Code")
        {
            Visible = false;
        }
        modify("Budget Dimension 3 Code")
        {
            Visible = false;
        }
        addafter(Description)
        {
            field("Block Email on Forecast"; Rec."Block Email on Forecast")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies that the email is blocked when we receive forecast thrugh the web service';
            }
        }
    }
}
