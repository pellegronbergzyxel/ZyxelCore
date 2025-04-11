Page 50285 "HR Zyxel KPI Entry Subform"
{
    Caption = 'HR Zyxel KPI Entry Subform';
    PageType = ListPart;
    SourceTable = "HR Zyxel KPI Entry";
    SourceTableView = order(descending)
                      where(Type = const(KPI));

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
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quarter 1"; Rec."Quarter 1")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quarter 2"; Rec."Quarter 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quarter 3"; Rec."Quarter 3")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quarter 4"; Rec."Quarter 4")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Total; Total)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Total := Rec."Quarter 1" + Rec."Quarter 2" + Rec."Quarter 3" + Rec."Quarter 4";
    end;

    var
        Total: Decimal;
}
