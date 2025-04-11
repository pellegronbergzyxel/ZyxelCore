pageextension 50105 CountriesRegionsZX extends "Countries/Regions"
{
    actions
    {
        addfirst("&Country/Region")
        {
            action(Card)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Card';
                Image = CountryRegion;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Country/Region Card";
                RunPageLink = Code = field(Code);
            }
        }
        addafter("&Country/Region")
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field(Code);
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(9));
                }
            }
        }
    }
}
