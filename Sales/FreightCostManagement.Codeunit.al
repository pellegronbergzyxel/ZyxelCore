Codeunit 50012 "Freight Cost Management"
{
    Permissions = TableData "Freight Cost Value Entry" = m;

    trigger OnRun()
    begin
    end;

    var
        Text001: label 'Freight Cost Adj.';


    procedure Post(pDocumentNo: Code[20])
    var
        recFreightCostValueEntry: Record "Freight Cost Value Entry";
        recGenJnlLine: Record "Gen. Journal Line";
        recValueEntry: Record "Value Entry";
        recGenPostSetup: Record "General Posting Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        ShortcutDimCode: array[8] of Code[20];
    begin
        recFreightCostValueEntry.SetRange("Document No.", pDocumentNo);
        recFreightCostValueEntry.SetRange("Freight Posted to G/L", false);
        if recFreightCostValueEntry.FindSet(true) then
            repeat
                recValueEntry.Get(recFreightCostValueEntry."Value Entry No.");
                recGenPostSetup.Get(recValueEntry."Gen. Bus. Posting Group", recFreightCostValueEntry."Gen. Prod. Posting Group");

                Clear(recGenJnlLine);
                recGenJnlLine.Init;
                recGenJnlLine.Validate("Account Type", recGenJnlLine."account type"::"G/L Account");
                recGenJnlLine.Validate("Account No.", recGenPostSetup."COGS Account");
                recGenJnlLine.Validate("Posting Date", recValueEntry."Posting Date");
                recGenJnlLine.Validate("Document No.", recValueEntry."Document No.");
                recGenJnlLine.Validate(Description, Text001);
                recGenJnlLine.Validate(Amount, recFreightCostValueEntry.Amount);
                recGenJnlLine.Validate("Reason Code", 'FRGT-ADJ');

                recGenPostSetup.Get(recValueEntry."Gen. Bus. Posting Group", recValueEntry."Gen. Prod. Posting Group");
                recGenJnlLine.Validate("Bal. Account Type", recGenJnlLine."bal. account type"::"G/L Account");
                recGenJnlLine.Validate("Bal. Account No.", recGenPostSetup."COGS Account");

                recGenJnlLine.Validate("VAT Bus. Posting Group", '');
                recGenJnlLine.Validate("VAT Prod. Posting Group", '');

                recGenJnlLine.Validate("Shortcut Dimension 1 Code", recValueEntry."Global Dimension 1 Code");
                recGenJnlLine.Validate("Shortcut Dimension 2 Code", recValueEntry."Global Dimension 2 Code");
                DimMgt.GetShortcutDimensions(recValueEntry."Dimension Set ID", ShortcutDimCode);
                recGenJnlLine.ValidateShortcutDimCode(3, ShortcutDimCode[3]);

                Commit;
                if GenJnlPostLine.Run(recGenJnlLine) then begin
                    recFreightCostValueEntry."Freight Posted to G/L" := true;
                    recFreightCostValueEntry.Modify;
                end else
                    if GetLastErrorText <> '' then
                        Error(GetLastErrorText);
            until recFreightCostValueEntry.Next() = 0;
    end;


    procedure PerformManualPost(pDocumentNo: Code[20])
    var
        lText001: label 'Do you want to post freight cost for %1?';
    begin
        if Confirm(lText001, true, pDocumentNo) then
            Post(pDocumentNo);
    end;
}
