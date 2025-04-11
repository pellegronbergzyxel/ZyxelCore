pageextension 50217 ChangeLogEntriesZX extends "Change Log Entries"
{
    layout
    {
        modify("Table Caption")
        {
            Visible = false;
        }
        modify("Primary Key Field 1 Value")
        {
            Visible = false;
        }
        modify("Primary Key Field 2 Value")
        {
            Visible = false;
        }
        modify("Primary Key Field 3 Value")
        {
            Visible = false;
        }
        modify("Old Value Local")
        {
            Visible = false;
        }
        modify("New Value Local")
        {
            Visible = false;
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst() then;
    end;

    trigger OnAfterGetRecord()
    begin
        if recField.Get(Rec."Table No.", Rec."Field No.") and (recField.Type = recField.Type::Option) then begin
            if not Evaluate(OldValue, Rec."Old Value") then
                OldValue := 0;
            Rec."Old Value" := SelectStr(OldValue + 1, recField.OptionString);
            if not Evaluate(NewValue, Rec."New Value") then
                NewValue := 0;
            Rec."New Value" := SelectStr(NewValue + 1, recField.OptionString);
        end;
    end;

    var
        recField: Record "Field";
        OldValue: Integer;
        NewValue: Integer;
}
