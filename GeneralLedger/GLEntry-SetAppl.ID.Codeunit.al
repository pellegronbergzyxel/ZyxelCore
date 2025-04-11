Codeunit 76122 "G/L Entry-SetAppl.ID"
{
    // //CO4.20: Controling - Basic: Applying G/L Entries;

    Permissions = TableData "G/L Entry" = m;

    trigger OnRun()
    begin
    end;

    var
        gcoGLEntryApplID: Code[20];


    procedure SetApplId(var lreGLEntry: Record "G/L Entry"; lreApplyingGLEntry: Record "G/L Entry"; ldeAppliedAmount: Decimal; lcoAppliesToID: Code[20])
    begin
        lreGLEntry.LockTable;
        if lreGLEntry.Find('-') then begin
            // Make Applies-to ID
            if lreGLEntry."Applies-to ID" <> '' then
                gcoGLEntryApplID := ''
            else begin
                gcoGLEntryApplID := lcoAppliesToID;
                if gcoGLEntryApplID = '' then begin
                    gcoGLEntryApplID := UserId;
                    if gcoGLEntryApplID = '' then
                        gcoGLEntryApplID := '***';
                end;
            end;

            // Set Applies-to ID
            repeat
                lreGLEntry.TestField(Closed, false);
                lreGLEntry."Applies-to ID" := gcoGLEntryApplID;
                // Set Amount to Apply
                if ((lreGLEntry."Amount to Apply" <> 0) and (gcoGLEntryApplID = '')) or
                  (gcoGLEntryApplID = '')
                then
                    lreGLEntry."Amount to Apply" := 0
                else
                    if lreGLEntry."Amount to Apply" = 0 then begin
                        lreGLEntry.CalcFields("Applied Amount");
                        lreGLEntry."Amount to Apply" := lreGLEntry.Amount - lreGLEntry."Applied Amount";
                    end;

                if lreGLEntry."Entry No." = lreApplyingGLEntry."Entry No." then
                    lreGLEntry."Applying Entry" := lreApplyingGLEntry."Applying Entry";
                lreGLEntry.Modify;
            until lreGLEntry.Next() = 0;
        end;
    end;
}
