Page 50303 "Excel Report List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Excel Report List';
    CardPageID = "Excel Report Card";
    Editable = false;
    PageType = List;
    SourceTable = "Excel Report Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Number of Columns"; Rec."Number of Columns")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User Permission"; Rec."User Permission")
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
        area(reporting)
        {
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange(Rec."User Filter", UserId());
        Rec.SetFilter(Rec."User Permission", '%1', UserId());
        Rec.FilterGroup(0);
    end;
}
