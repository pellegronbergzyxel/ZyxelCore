Page 50304 "Excel Report Line Card"
{
    PageType = Card;
    SourceTable = "Excel Report Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Column No."; Rec."Column No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Column Name"; Rec."Column Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Formula; Rec.Formula)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = '# = Line number; % = Value comming from NAV';

                    trigger OnAssistEdit()
                    begin
                        Rec.EnterFormula;
                    end;
                }
                field(Caption; Rec.Caption)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Show Formula as Text"; Rec."Show Formula as Text")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cell Type"; Rec."Cell Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cell Format"; Rec."Cell Format")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Find Record"; Rec."Find Record")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Next Record"; Rec."Next Record")
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
