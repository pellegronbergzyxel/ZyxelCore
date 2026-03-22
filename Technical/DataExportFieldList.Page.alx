Page 50144 "Data Export Field List"
{
    Caption = 'Data Export Field List';
    DataCaptionExpression = GetCaption;
    Editable = false;
    PageType = List;
    SourceTable = "Field";
    SourceTableView = sorting(TableNo, "No.");

    layout
    {
        area(content)
        {
            repeater(Control1140000)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Field No.';
                    StyleExpr = ClassColumnStyle;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Field Name';
                    StyleExpr = ClassColumnStyle;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type';
                    StyleExpr = ClassColumnStyle;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Class';
                    StyleExpr = ClassColumnStyle;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.Class = Rec.Class::FlowField then
            ClassColumnStyle := 'StandardAccent'
        else
            ClassColumnStyle := 'Normal';
    end;

    var
        ClassColumnStyle: Text[30];

    local procedure GetCaption(): Text[250]
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        if AllObjWithCaption.Get(AllObjWithCaption."object type"::Table, Rec.TableNo) then
            exit(Format(Rec.TableNo) + ' ' + AllObjWithCaption."Object Caption");

        exit('');
    end;
}
