Page 50213 "It Department Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "It department Cue";

    layout
    {
        area(content)
        {
            cuegroup(Users)
            {
                Caption = 'Users';
                field("Enabled Users"; Rec."Enabled Users")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = Users;
                    Image = People;
                }
                field("Disabled Users"; Rec."Disabled Users")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = Users;
                }
                field("Expired Users"; Rec."Expired Users")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = Users;
                }
                field("System Accounts"; Rec."System Accounts")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = Users;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        StartDate: Date;
    begin
        Rec.SetFilter(Rec."Date Filter ..Today", '<>%1&..%2', 0DT, CurrentDateTime);
        Rec.SetFilter(Rec."Date Filter Today..", '%1|%2..', 0DT, CurrentDateTime + (24 * 60 * 60 * 1000));
    end;

    var
        UserRec: Record User;
}
