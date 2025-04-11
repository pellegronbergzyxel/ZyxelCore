Codeunit 50023 "Post Whse. Adjustment"
{

    trigger OnRun()
    begin
        PostMovement;
        PostCorrection;
    end;


    procedure PostMovementWithConfirmation()
    var
        lText001: label 'Do you want to post movements?';
    begin
        if Confirm(lText001, true) then
            PostMovement;
    end;


    procedure PostCorrectionWithConfirmation()
    var
        lText001: label 'Do you want to post corrections?';
    begin
        if Confirm(lText001, true) then
            PostCorrection;
    end;

    local procedure PostMovement()
    var
        recItemJnlLine: Record "Item Journal Line";
        recWhseStockCorrLedEntry: Record "Whse. Stock Corr. Led. Entry";
    begin
        recWhseStockCorrLedEntry.SetRange("Posting Type", recWhseStockCorrLedEntry."posting type"::Move);
        recWhseStockCorrLedEntry.SetRange(Open, true);
        if recWhseStockCorrLedEntry.FindSet(true) then
            repeat
                Clear(recItemJnlLine);
                recItemJnlLine.Init;
                recItemJnlLine.Validate("Journal Template Name", 'TRANSFER');
                recItemJnlLine.Validate("Journal Batch Name", 'VCK');
                recItemJnlLine.Validate("Line No.", GetNextLineNo(recItemJnlLine."Journal Template Name", recItemJnlLine."Journal Batch Name"));
                Commit;
                recItemJnlLine.SetUpNewLine(recItemJnlLine);
                recItemJnlLine.Validate("Posting Date", Today);
                recItemJnlLine.Validate("Entry Type", recItemJnlLine."entry type"::Transfer);
                recItemJnlLine.Validate("Item No.", recWhseStockCorrLedEntry."Product No.");
                recItemJnlLine.Validate(Quantity, recWhseStockCorrLedEntry.Quantity);
                recItemJnlLine.Validate("Location Code", recWhseStockCorrLedEntry.Location);
                recItemJnlLine.Validate("New Location Code", recWhseStockCorrLedEntry."New Location");
                recItemJnlLine.Validate("External Document No.", StrSubstNo('%1 %2', recWhseStockCorrLedEntry.FieldCaption("Message No."), recWhseStockCorrLedEntry."Message No."));
                recItemJnlLine.Insert(true);

                recWhseStockCorrLedEntry.Open := false;
                recWhseStockCorrLedEntry.Modify(true);
            until recWhseStockCorrLedEntry.Next() = 0;
    end;

    local procedure PostCorrection()
    var
        recItemJnlLine: Record "Item Journal Line";
        xrecItemJnlLine: Record "Item Journal Line";
        recWhseStockCorrLedEntry: Record "Whse. Stock Corr. Led. Entry";
        recItem: Record Item;
        CalcInv: Report "Calculate Inventory";
    begin
        recWhseStockCorrLedEntry.SetRange("Posting Type", recWhseStockCorrLedEntry."posting type"::Correction);
        recWhseStockCorrLedEntry.SetRange(Open, true);
        if recWhseStockCorrLedEntry.FindSet(true) then
            repeat

                Clear(recItemJnlLine);
                recItemJnlLine.Init;
                recItemJnlLine.Validate("Journal Template Name", 'ITEM');
                recItemJnlLine.Validate("Journal Batch Name", 'VCK');
                recItemJnlLine.Validate("Line No.", GetNextLineNo(recItemJnlLine."Journal Template Name", recItemJnlLine."Journal Batch Name"));
                Commit;
                recItemJnlLine.SetUpNewLine(xrecItemJnlLine);

                recItemJnlLine.Validate("Posting Date", Today);
                if recWhseStockCorrLedEntry.Quantity < 0 then
                    recItemJnlLine.Validate("Entry Type", recItemJnlLine."entry type"::"Negative Adjmt.")
                else
                    recItemJnlLine.Validate("Entry Type", recItemJnlLine."entry type"::"Positive Adjmt.");
                recItemJnlLine.Validate("Item No.", recWhseStockCorrLedEntry."Product No.");
                recItemJnlLine.Validate("Location Code", recWhseStockCorrLedEntry.Location);
                recItemJnlLine.Validate(Quantity, recWhseStockCorrLedEntry.Quantity);
                recItemJnlLine.Validate("External Document No.", StrSubstNo('%1 %2', recWhseStockCorrLedEntry.FieldCaption("Message No."), recWhseStockCorrLedEntry."Message No."));
                recItemJnlLine.Insert(true);

                xrecItemJnlLine := recItemJnlLine;

                recWhseStockCorrLedEntry.Open := false;
                recWhseStockCorrLedEntry.Modify(true);
            until recWhseStockCorrLedEntry.Next() = 0;
    end;

    local procedure GetNextLineNo(pJnlTempName: Code[20]; pJnlBatchName: Code[20]): Integer
    var
        recItemJnlLine: Record "Item Journal Line";
    begin
        recItemJnlLine.SetRange("Journal Template Name", pJnlTempName);
        recItemJnlLine.SetRange("Journal Batch Name", pJnlBatchName);
        if recItemJnlLine.FindLast then
            exit(recItemJnlLine."Line No." + 10000)
        else
            exit(10000);
    end;
}
