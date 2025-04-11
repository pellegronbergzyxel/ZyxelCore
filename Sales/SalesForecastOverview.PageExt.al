pageextension 50276 SalesForecastOverviewZX extends "Sales Budget Overview"
{
    Caption = 'Sales Forecast Overview';

    actions
    {
        modify(DeleteBudget)
        {
            Visible = false;
        }
    }
}
