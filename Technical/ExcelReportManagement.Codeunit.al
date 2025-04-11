Codeunit 50086 "Excel Report Management"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        recExRepLineTmp: Record "Excel Report Line" temporary;
        ZGT: Codeunit "ZyXEL General Tools";

    [EventSubscriber(ObjectType::Table, Database::"Excel Report Line", 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnBeforeRename(var Rec: Record "Excel Report Line"; var xRec: Record "Excel Report Line"; RunTrigger: Boolean)
    var
        recExRepLine: Record "Excel Report Line";
    begin
        begin
            recExRepLine.SetRange("Excel Report Code", Rec."Excel Report Code");
            recExRepLine.SetFilter("Column No.", '>=%1&<>%2', Rec."Column No.", xRec."Column No.");
            if recExRepLine.FindSet then
                repeat
                    recExRepLineTmp := recExRepLine;
                    recExRepLineTmp."Previous Column Name" := recExRepLineTmp."Column Name";
                    recExRepLineTmp.Validate("Column No.", recExRepLine."Column No." + 1);
                    recExRepLine.Delete;
                    recExRepLineTmp.Insert;
                until recExRepLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Excel Report Line", 'OnAfterRenameEvent', '', false, false)]
    local procedure OnAfterRename(var Rec: Record "Excel Report Line"; var xRec: Record "Excel Report Line"; RunTrigger: Boolean)
    var
        recExRepLine: Record "Excel Report Line";
    begin
        begin
            if recExRepLineTmp.FindSet then begin
                repeat
                    recExRepLine := recExRepLineTmp;
                    recExRepLine.Insert;
                until recExRepLineTmp.Next() = 0;
                recExRepLineTmp.DeleteAll;
            end;

            ValidateFormulaOnRemane(Rec."Excel Report Code");
        end;
    end;

    local procedure ValidateFormulaOnRemane(pCode: Code[20])
    var
        recExRepLine: Record "Excel Report Line";
        recExRepLine2: Record "Excel Report Line";
        FColumnNo: Integer;
        TColumnNo: Integer;
        TColumnName: Text[10];
        Position: Integer;
    begin
        recExRepLine.SetRange("Excel Report Code", pCode);
        recExRepLine.SetFilter(Formula, '<>%1', '');
        if recExRepLine.FindSet then begin
            repeat
                recExRepLine2.SetRange("Excel Report Code", pCode);
                recExRepLine2.SetFilter("Previous Column Name", '<>%1', '');
                if recExRepLine2.FindSet then begin
                    repeat
                        repeat
                            Position := StrPos(recExRepLine.Formula, recExRepLine2."Previous Column Name" + '#');
                            if Position <> 0 then begin
                                recExRepLine.Formula :=
                                  StrSubstNo('%1%2?%3',
                                    CopyStr(recExRepLine.Formula, 1, Position - 1),
                                    recExRepLine2."Column Name",
                                    CopyStr(recExRepLine.Formula, Position + StrLen(recExRepLine2."Previous Column Name") + 1, StrLen(recExRepLine.Formula)));
                                recExRepLine.Modify;
                            end;
                        until StrPos(recExRepLine.Formula, recExRepLine2."Previous Column Name" + '#') = 0;
                    until recExRepLine2.Next() = 0;

                    recExRepLine.Formula := ConvertStr(recExRepLine.Formula, '?', '#');
                    recExRepLine.Modify;
                end;
            until recExRepLine.Next() = 0;

            recExRepLine2.ModifyAll("Previous Column Name", '');
        end;
    end;
}
