report 50078 "Item - Chemical Tax Red. Rate"
{
    // 001. 18-04-24 ZY-LD 000 - Get SCIP No. from sub table.

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item - Chemical Tax Red. Rate.rdlc';
    Caption = 'Item - Chemical Tax Reduction Rate';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = where(Inactive = const(false), "Tax Reduction Rate Active" = const(true), "Tax Reduction rate" = filter(<> 0));
            RequestFilterFields = "No.", "Tax Reduction Rate Date Filter";
            column(No; Item."No.")
            {
            }
            column(Description; Item.Description)
            {
            }
            column(TaxRecuctionRate; Item."Tax Reduction rate")
            {
            }
            column(TaxRate; Item."Tax rate (SEK/kg)")
            {
            }
            column(NetWeight; Item."Net Weight")
            {
            }
            /*column(ScipNo; Item."SCIP No.")  // 18-04-24 ZY-LD 001
            {
            }*/
            column(ScipNo; Item.GetScipNo())  // 18-04-24 ZY-LD 001
            {
            }
        }
    }
}
