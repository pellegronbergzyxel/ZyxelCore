Page 50181 "HR Disciplinary Line Card"
{
    Caption = 'Disciplinary';
    DataCaptionFields = "Employee No.", "Full Name";
    LinksAllowed = true;
    PageType = Card;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "HR Disciplinary Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Date of Warning"; Rec."Date of Warning")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Date of Warning Expiration"; Rec."Date of Warning Expiration")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warning Code"; Rec."Warning Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field("Warning Description"; Rec."Warning Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        Rec.CalcFields(Rec."Warning Description");
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000000; Links)
            {
                Visible = true;
            }
            systempart(Control1000000001; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Disciplinary)
            {
                Caption = 'Disciplinary';
                Image = Absence;
                action("Co&mments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = const("Human Resources Comment Table Name"::"HR Disciplinary Line"),
                                  "Table Line No." = field(UID);
                }
                action("Disciplinary Codes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Disciplinary Codes';
                    Image = Warning;
                    RunObject = Page "HR Disiplinary Code List";
                    ToolTip = 'Edit List of Disciplinary Codes used by the HR module';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Rec."Full Name");
    end;
}
