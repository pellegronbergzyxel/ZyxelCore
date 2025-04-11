Codeunit 76121 "G/L Entry-Edit ZX"
{
    // //CO4.20: Controling - Basic: Applying G/L Entries;

    Permissions = TableData "G/L Entry" = m;
    TableNo = "G/L Entry";

    trigger OnRun()
    var
        lrrRecRef: RecordRef;
        lrrxRecRef: RecordRef;
    begin

        greGLEntry := Rec;
        greGLEntry.LockTable;
        greGLEntry.Find;
        lrrxRecRef.GetTable(greGLEntry);
        if not greGLEntry.Closed then begin
            greGLEntry."Applies-to ID" := Rec."Applies-to ID";
            greGLEntry.Validate("Amount to Apply", Rec."Amount to Apply");
            greGLEntry.Validate("Applying Entry", Rec."Applying Entry");
        end;
        greGLEntry.Modify;
        Rec := greGLEntry;
        lrrRecRef.GetTable(greGLEntry);
        gcuChangeLogMgt.LogModification(lrrRecRef);
    end;

    var
        greGLEntry: Record "G/L Entry";
        gcuChangeLogMgt: Codeunit "Change Log Management";
}
