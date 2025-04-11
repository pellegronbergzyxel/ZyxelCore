Page 50106 "HR Zyxel Add. Pay. Subform"
{
    ApplicationArea = Basic, Suite;
    Caption = 'HR Zyxel Additional Payment';
    PageType = ListPart;
    SourceTable = "HR Zyxel KPI Entry";
    SourceTableView = order(descending)
                      where(Type = const("Additional Payment"));
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Justification / Explanation"; Rec."Justification / Explanation")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tracking Document"; Rec."Tracking Document")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tracking Document Attached"; Rec."Tracking Document Attached")
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
