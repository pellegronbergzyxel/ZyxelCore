Page 50362 "IC Reconciliation Templates"
{
    ApplicationArea = Basic, Suite;
    Caption = 'IC Reconciliation Templates';
    PageType = List;
    SourceTable = "IC Reconciliation Template";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Te&mplate")
            {
                Caption = 'Te&mplate';
                Image = Template;
                action("Reconciliation Names")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reconciliation Names';
                    Image = List;
                    RunObject = Page "IC Reconciliation Names";
                    RunPageLink = "Reconciliation Template Name" = field(Name);
                }
            }
        }
    }

    trigger OnClosePage()
    begin
        SI.SetHideSalesDialog(false);
    end;

    trigger OnOpenPage()
    begin
        SI.SetHideSalesDialog(true);
    end;

    var
        SI: Codeunit "Single Instance";
}
