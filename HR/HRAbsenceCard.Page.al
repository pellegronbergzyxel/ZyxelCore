Page 50207 "HR Absence Card"
{
    Caption = 'Absence';
    PageType = Card;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Employee Absence";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Free Text"; Rec."Free Text")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000007; Links)
            {
                Visible = true;
            }
            systempart(Control1000000006; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Co&mments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Human Resource Comment Sheet";
                RunPageLink = "Table Name" = const("Human Resources Comment Table Name"::"Employee Absence"),
                              "Table Line No." = field("Entry No.");
            }
            action("Cause Of Abscence Codes")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cause Of Abscence Codes';
                Image = Absence;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Causes of Absence";
                ToolTip = 'Edit List of Cause Of Abscence Codes used by the HR module';
            }
        }
    }
}
