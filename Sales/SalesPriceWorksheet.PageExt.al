pageextension 50272 PriceWorksheetZX extends "Price Worksheet"
{
    layout
    {
        modify("Currency Code")
        {
            Visible = true;
        }
    }

    actions
    {
        addafter(ImplementPriceChange)
        {
            action(Replace)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Replace';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Replace.LoadDataSet(Database::"Price Worksheet Line", Rec.GetFilters());
                    Replace.SetValidations(true, true);
                    Replace.RunModal;
                    CurrPage.Update();
                    Clear(Replace);
                end;
            }
        }
    }

    var
        Replace: Page Replace;
}
