Page 50190 "Data Export Record Fields"
{
    Caption = 'Data Export Record Fields';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Data Export Record Field";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = FlowFieldStyle;
                }
                field("Field Type"; Rec."Field Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Field Class"; Rec."Field Class")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = FlowFieldStyle;
                }
                field("Date Filter Handling"; Rec."Date Filter Handling")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Export Field Name"; Rec."Export Field Name")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Add ")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Add';
                Image = Add;

                trigger OnAction()
                var
                    "Field": Record "Field";
                    DataExportFieldList: Page "Data Export Field List";
                    DataExportCode: Code[10];
                    DataExportRecTypeCode: Code[10];
                    CurrGroup: Integer;
                    TableNo: Integer;
                    SelectedLineNo: Integer;
                    SourceLineNo: Integer;
                begin
                    CurrGroup := Rec.FilterGroup;
                    Rec.FilterGroup(4);
                    Evaluate(TableNo, Rec.GetFilter(Rec."Table No."));
                    Evaluate(SourceLineNo, Rec.GetFilter(Rec."Source Line No."));
                    DataExportCode := Rec.GetRangeMin(Rec."Data Export Code");
                    DataExportRecTypeCode := Rec.GetRangeMin(Rec."Data Exp. Rec. Type Code");
                    Rec.FilterGroup(CurrGroup);
                    Field.FilterGroup(4);
                    Field.SetRange(TableNo, TableNo);
                    Field.SetFilter(Type, '%1|%2|%3|%4|%5|%6|%7',
                      Field.Type::Option, Field.Type::Text, Field.Type::Code, Field.Type::Integer, Field.Type::Decimal,
                      Field.Type::Date, Field.Type::Boolean);
                    Field.FilterGroup(0);

                    Clear(DataExportFieldList);
                    DataExportFieldList.SetTableview(Field);
                    DataExportFieldList.LookupMode := true;
                    if DataExportFieldList.RunModal = Action::LookupOK then begin
                        DataExportFieldList.SetSelectionFilter(Field);
                        SelectedLineNo := GetSelectedFieldsLineNo(DataExportCode, DataExportRecTypeCode, SourceLineNo);
                        Rec.InsertSelectedFields(Field, DataExportCode, DataExportRecTypeCode, SourceLineNo, SelectedLineNo);
                    end;
                end;
            }
            action(Delete)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete';
                Image = Delete;

                trigger OnAction()
                var
                    DataExportRecordField: Record "Data Export Record Field";
                begin
                    CurrPage.SetSelectionFilter(DataExportRecordField);
                    DataExportRecordField.DeleteAll;
                end;
            }
            action(MoveUp)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Move Up';
                Image = MoveUp;

                trigger OnAction()
                begin
                    Rec.MoveRecordUp(Rec);
                end;
            }
            action(MoveDown)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Move Down';
                Image = MoveDown;

                trigger OnAction()
                begin
                    Rec.MoveRecordDown(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Field Class" = Rec."field class"::FlowField then
            FlowFieldStyle := 'StandardAccent'
        else
            FlowFieldStyle := 'Normal';
    end;

    var
        FlowFieldStyle: Text[30];


    procedure GetSelectedFieldsLineNo(DataExportCode: Code[10]; RecordCode: Code[10]; SourceLineNo: Integer) SelectedLineNo: Integer
    var
        DataExportRecordField: Record "Data Export Record Field";
    begin
        DataExportRecordField.SetRange("Data Export Code", DataExportCode);
        DataExportRecordField.SetRange("Data Exp. Rec. Type Code", RecordCode);
        DataExportRecordField.SetRange("Source Line No.", SourceLineNo);
        if DataExportRecordField.IsEmpty then
            SelectedLineNo := 0
        else
            SelectedLineNo := Rec."Line No.";
    end;
}
