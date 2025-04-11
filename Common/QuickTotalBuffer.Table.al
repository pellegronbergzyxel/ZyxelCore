table 76154 "Quick Total Buffer"
{
    fields
    {
        field(5; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(10; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(15; Total; Decimal)
        {
            Caption = 'Total';
        }
        field(20; "Max. Value"; Decimal)
        {
            Caption = 'Max. Value';
        }
        field(25; "Min. Value"; Decimal)
        {
            Caption = 'Min. Value';
        }
        field(30; "Average Value"; Decimal)
        {
            Caption = 'Average Value';
        }
        field(50; "Records Count"; Integer)
        {
            Caption = 'Records Count';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    procedure GetTotal(var lrrTable: RecordRef)
    var
        lretResult: Record "Quick Total Buffer" temporary;
        lreField: Record "Field";
        lfrField: FieldRef;
        ldeTemp: Decimal;
        ldiDialog: Dialog;
        linCount: Integer;
        ltcText001: Label 'Counting records';
    begin
        if lrrTable.Find('-') then begin
            ldiDialog.Open(ltcText001 + ' #1###########');

            Clear(lretResult);
            lretResult."No." := -1;
            lretResult.Name := lrrTable.Caption;
            lretResult.Insert();

            Clear(linCount);
            lreField.SetRange(TableNo, lrrTable.Number);
            lreField.SetRange(Type, lreField.Type::Decimal);
            repeat
                linCount += 1;
                if (linCount mod 10 = 0) or (linCount = 1) then
                    ldiDialog.Update(1, linCount);
                if lreField.Find('-') then
                    repeat
                        lfrField := lrrTable.field(lreField."No.");
                        if lreField.Class = lreField.Class::FlowField then
                            lfrField.CalcField;
                        ldeTemp := lfrField.Value;
                        if lretResult.Get(lreField."No.") then begin
                            lretResult.Total += ldeTemp;
                            if ldeTemp > lretResult."Max. Value" then
                                lretResult."Max. Value" := ldeTemp;
                            if ldeTemp < lretResult."Min. Value" then
                                lretResult."Min. Value" := ldeTemp;
                            lretResult.Modify();
                        end else begin
                            lretResult."No." := lreField."No.";
                            lretResult.Name := lreField."Field Caption";
                            lretResult.Total := ldeTemp;
                            lretResult."Max. Value" := ldeTemp;
                            lretResult."Min. Value" := ldeTemp;
                            lretResult.Insert();
                        end;
                    until lreField.Next() = 0;
            until lrrTable.Next() = 0;
            if lretResult.Find('-') then
                repeat
                    lretResult."Records Count" := linCount;
                    lretResult."Average Value" := Round(lretResult.Total / linCount, 0.01);
                    lretResult.Modify();
                until lretResult.Next() = 0;
            lretResult.SetFilter(Total, '<>0');
            if lretResult.Find('-') then;
            ldiDialog.Close();
            Page.Run(0, lretResult);
        end;
    end;
}
