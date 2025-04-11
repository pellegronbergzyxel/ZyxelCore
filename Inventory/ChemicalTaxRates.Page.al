Page 50127 "Chemical Tax Rates"
{
    Caption = 'Chemical Tax Rates';
    PageType = List;
    SourceTable = "Chemical Tax Rate";
    SourceTableView = sorting("Start Date")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax Rate (SEK/kg)"; Rec."Tax Rate (SEK/kg)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax Rate Cap (SEK/Item)"; Rec."Tax Rate Cap (SEK/Item)")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then;
    end;
}
