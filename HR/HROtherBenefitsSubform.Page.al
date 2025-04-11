Page 50306 "HR Other Benefits Subform"
{
    Caption = 'HR Other Benefits Subform';
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "HR Other Benefits";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Benefit; Rec.Benefit)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("ER %"; Rec."ER %")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EE %"; Rec."EE %")
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
