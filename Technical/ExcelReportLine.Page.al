Page 50302 "Excel Report Line"
{
    Caption = 'Column Setup';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Excel Report Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Column No."; Rec."Column No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Column Name"; Rec."Column Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
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
                    Editable = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cell Type"; Rec."Cell Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Cell Format"; Rec."Cell Format")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Show Formula as Text"; Rec."Show Formula as Text")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Find Record"; Rec."Find Record")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Next Record"; Rec."Next Record")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Edit)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit';
                Image = Edit;
                RunObject = Page "Excel Report Line Card";
                RunPageLink = "Excel Report Code" = field("Excel Report Code"),
                              "Column No." = field("Column No.");
                ShortCutKey = 'Shift+Ctrl+E';
            }
            action(New)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'New';
                Image = New;
                ShortCutKey = 'Ctrl+n';

                trigger OnAction()
                begin
                    recExRepLine.SetRange("Excel Report Code", Rec."Excel Report Code");
                    if recExRepLine.FindLast then
                        NextColNo := recExRepLine."Column No." + 1
                    else
                        NextColNo := 1;

                    recExRepLine.Reset;
                    Clear(recExRepLine);
                    recExRepLine."Excel Report Code" := Rec."Excel Report Code";
                    recExRepLine.Validate("Column No.", NextColNo);
                    recExRepLine.Insert;
                end;
            }
        }
    }

    var
        recExRepLine: Record "Excel Report Line";
        NextColNo: Integer;
}
