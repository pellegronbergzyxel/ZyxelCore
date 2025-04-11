Page 50131 "EiCard Cue SubPage"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = CardPart;
    SaveValues = true;
    ShowFilter = false;
    SourceTable = "EiCard Queue";

    layout
    {
        area(content)
        {
            group("E-mail Distribution")
            {
                Caption = 'E-mail Distribution';
                field("Distributor E-mail"; Rec."Distributor E-mail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("End User E-mail"; Rec."End User E-mail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EiCard To E-mail 2"; Rec."EiCard To E-mail 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EiCard To E-mail 3"; Rec."EiCard To E-mail 3")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EiCard To E-mail 4"; Rec."EiCard To E-mail 4")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Order Details")
            {
                Caption = 'Order Details';
                field("Distributor Reference"; Rec."Distributor Reference")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("From E-Mail Address"; Rec."From E-Mail Address")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("From E-Mail Signature"; Rec."From E-Mail Signature")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
