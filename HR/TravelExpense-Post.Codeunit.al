Codeunit 50094 "TravelExpense-Post"
{
    // 001. 27-08-20 ZY-LD 2020082610000087 - "VAT Prod. Post Grp" can only be used on a G/L Account.
    // 002. 16-10-20 ZY-LD 2020101510000192 - New filter.
    // 003. 17-12-20 ZY-LD 2020121710000131 - Run only if milage is different from zero.
    // 004. 21-06-22 ZY-LD 2022062010000123 - Text for other than milage.

    TableNo = "Travel Expense Header";

    trigger OnRun()
    begin
        recTrExpLine.SetCurrentkey("Bal. Account No.");
        recTrExpLine.SetRange("Document No.", Rec."No.");
        recTrExpLine.SetRange("Show Expense", true);
        recTrExpLine.SetRange("Posting Type", recTrExpLine."posting type"::"G/L Journal");
        if recTrExpLine.FindSet then begin
            recConcurSetup.Get;
            recConcurSetup.TestField("Travel Exp. Gen. Jnl. Template");
            recConcurSetup.TestField("Travel Exp. Gen. Jnl. Batch");
            recGenJnl.SetRange("Journal Template Name", recConcurSetup."Travel Exp. Gen. Jnl. Template");
            recGenJnl.SetRange("Journal Batch Name", recConcurSetup."Travel Exp. Gen. Jnl. Batch");
            recGenJnl.DeleteAll(true);

            repeat
                recVATProdPostGrp.Get(recTrExpLine."VAT Prod. Posting Group");
            until recTrExpLine.Next() = 0;

            recTrExpLine.FindSet;
            recGenJnl.LockTable;
            repeat
                CreateGeneralJournal(Rec, recTrExpLine);

                recTrExpLine.SetRange("Bal. Account No.", recTrExpLine."Bal. Account No.");
                recTrExpLine.FindLast;
                recTrExpLine.SetRange("Bal. Account No.");
            until recTrExpLine.Next() = 0;

            Commit;
            if PostJournal then begin
                recGenJnl.SetRange("Journal Template Name", recConcurSetup."Travel Exp. Gen. Jnl. Template");
                recGenJnl.SetRange("Journal Batch Name", recConcurSetup."Travel Exp. Gen. Jnl. Batch");
                recGenJnl.SetRange("Document No.", recGenJnl."Document No.");
                if Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", recGenJnl) then
                    Message(Text001);
            end else
                Page.Run(Page::"General Journal", recGenJnl);
        end;

        recTrExpLine.SetRange("Posting Type", recTrExpLine."posting type"::Salary);
        recTrExpLine.SetRange("Milage is Sent to Salary", false);
        if recTrExpLine.FindFirst then
            CreatePeriodJournal(Rec, recTrExpLine);
    end;

    var
        recTrExpLine: Record "Travel Expense Line";
        recGenJnl: Record "Gen. Journal Line";
        xrecGenJnl: Record "Gen. Journal Line";
        recGenJnlTmp: Record "Gen. Journal Line" temporary;
        recVATProdPostGrp: Record "VAT Product Posting Group";
        recConcurSetup: Record "Concur Setup";
        GenJnlManagement: Codeunit GenJnlManagement;
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        PostJournal: Boolean;
        Text001: label 'Journal has been posted.';

    local procedure CreateGeneralJournal(var pTrExpHead: Record "Travel Expense Header"; var pTrExpLine: Record "Travel Expense Line")
    var
        recGenJnlTempl: Record "Gen. Journal Template";
        recGenJnlBatch: Record "Gen. Journal Batch";
        recTrExpLine2: Record "Travel Expense Line";
        GenJournalTemplate: Record "Gen. Journal Template";
        BalVendAmount: Decimal;
        DocNo: Code[20];
        BalanceAttemps: Integer;
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        begin
            recTrExpLine2.CopyFilters(pTrExpLine);
            recTrExpLine2.SetRange("Bal. Account No.", pTrExpLine."Bal. Account No.");

            if pTrExpHead."Concur Company Name" = CompanyName() then begin
                if recTrExpLine2.FindSet then begin
                    recGenJnlTempl.Get(recConcurSetup."Travel Exp. Gen. Jnl. Template");
                    recGenJnlBatch.Get(recGenJnlTempl.Name, recConcurSetup."Travel Exp. Gen. Jnl. Batch");
                    xrecGenJnl.SetRange("Journal Template Name", recGenJnlTempl.Name);
                    xrecGenJnl.SetRange("Journal Batch Name", recGenJnlBatch.Name);
                    if not xrecGenJnl.FindLast then;

                    repeat
                        recTrExpLine2.TestField("Bal. Account No.");

                        Clear(recGenJnl);
                        recGenJnl.Init;
                        recGenJnl.Validate("Journal Template Name", recGenJnlTempl.Name);
                        recGenJnl.Validate("Journal Batch Name", recGenJnlBatch.Name);
                        recGenJnl.CopyFilters(xrecGenJnl);
                        Commit;
                        GenJnlManagement.CalcBalance(recGenJnl, xrecGenJnl, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
                        recGenJnl.SetUpNewLine(xrecGenJnl, Balance, true);
                        recGenJnl.Validate("Line No.", GetNextJnlLine(recGenJnl));
                        if ZGT.TurkishServer then
                            recGenJnl."Document No." := pTrExpHead."No.";

                        recGenJnl.Validate("Posting Date", pTrExpHead."Posting Date");
                        recGenJnl.Validate("Account Type", recTrExpLine2."Account Type");
                        recGenJnl.Validate("Account No.", recTrExpLine2."Account No.");
                        recGenJnl.Validate(Description, CopyStr(recTrExpLine2."Business Purpose", 1, MaxStrLen(recGenJnl.Description)));
                        recGenJnl.Validate("Currency Code", recTrExpLine2."Currency Code");
                        if recTrExpLine2."Account Type" = recTrExpLine2."account type"::"G/L Account" then  // 27-08-20 ZY-LD 001
                            recGenJnl.Validate("VAT Prod. Posting Group", recTrExpLine2."VAT Prod. Posting Group");
                        recGenJnl.Validate(Amount, recTrExpLine2.Amount);
                        recGenJnl.Validate("Shortcut Dimension 1 Code", recTrExpLine2."Division Code - Zyxel");
                        recGenJnl.Validate("Shortcut Dimension 2 Code", recTrExpLine2."Department Code - Zyxel");
                        recGenJnl.Insert(true);

                        if recTrExpLine2."Country Code" <> '' then
                            recGenJnl.ValidateShortcutDimCode(3, recTrExpLine2."Country Code")
                        else
                            recGenJnl.ValidateShortcutDimCode(3, pTrExpHead."Country Code");
                        if recTrExpLine2."Cost Type" <> '' then
                            recGenJnl.ValidateShortcutDimCode(4, recTrExpLine2."Cost Type")
                        else
                            recGenJnl.ValidateShortcutDimCode(4, pTrExpHead."Cost Type Name");
                        recGenJnl.Modify(true);

                        xrecGenJnl := recGenJnl;
                        BalVendAmount += recGenJnl.Amount;
                    until recTrExpLine2.Next() = 0;

                    // Balance Account
                    Clear(recGenJnl);
                    recGenJnl.Init;
                    recGenJnl.Validate("Journal Template Name", recGenJnlTempl.Name);
                    recGenJnl.Validate("Journal Batch Name", recGenJnlBatch.Name);
                    recGenJnl.CopyFilters(xrecGenJnl);
                    Commit;
                    GenJnlManagement.CalcBalance(recGenJnl, xrecGenJnl, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
                    recGenJnl.SetUpNewLine(xrecGenJnl, Balance, true);
                    recGenJnl.Validate("Line No.", GetNextJnlLine(recGenJnl));
                    recGenJnl.Validate("Posting Date", pTrExpHead."Posting Date");
                    recGenJnl.Validate("Account Type", recTrExpLine2."Bal. Account Type");
                    recGenJnl.Validate("Account No.", recTrExpLine2."Bal. Account No.");
                    recGenJnl.Validate(Description, pTrExpHead."Concur Report Name");
                    recGenJnl.Validate("Currency Code", recTrExpLine."Currency Code");
                    recGenJnl.Validate(Amount, -BalVendAmount);
                    recGenJnl.Insert(true);

                    recGenJnl.ValidateShortcutDimCode(3, pTrExpHead."Country Code");
                    recGenJnl.Modify(true);

                    Commit;
                    GenJnlManagement.CalcBalance(recGenJnl, xrecGenJnl, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
                    if (TotalBalance >= -1) and (TotalBalance <= 1) then begin
                        recGenJnl.Find('<');
                        repeat
                            recGenJnl.Validate("Amount (LCY)", recGenJnl."Amount (LCY)" - TotalBalance);
                            recGenJnl.Modify(true);
                            GenJnlManagement.CalcBalance(recGenJnl, xrecGenJnl, Balance, TotalBalance, ShowBalance, ShowTotalBalance);

                            BalanceAttemps += 1;
                        until (TotalBalance = 0) or (BalanceAttemps >= 100);
                    end;
                end;
            end;

            pTrExpHead."Document Status" := pTrExpHead."document status"::Posted;
            pTrExpHead."G/L Document No." := recGenJnl."Document No.";
            pTrExpHead."G/L Posting Date" := recGenJnl."Posting Date";
            pTrExpHead.Modify;
        end;
    end;

    local procedure GetNextJnlLine(pGenJnlLine: Record "Gen. Journal Line"): Integer
    var
        recGenJnl: Record "Gen. Journal Line";
    begin
        recGenJnl.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        recGenJnl.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        if recGenJnl.FindLast then
            exit(recGenJnl."Line No." + 10000)
        else
            exit(10000);
    end;

    local procedure CreatePeriodJournal(var pTrExpHead: Record "Travel Expense Header"; var pTrExpLine: Record "Travel Expense Line")
    var
        recTrExpLine: Record "Travel Expense Line";
        recConcurSetup: Record "Concur Setup";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";
        TotalMilage: Decimal;
        BodyText: Text;
        BodyText2: Text;
        lText001: label 'Payroll entries has been created based on the milage entries,\and e-mail has been sent to the accounting manager.';
        lText002: label 'E-mail has been sent to the accounting manager.';
        lText003: label 'Document No., Business Purpose: km.</br>';
        lText004: label '%1, %2: %3 km.</br>';
        lText005: label '</br>Total Milage: %1 km.</br></br>';
        lText006: label 'Other Salary Postings</br>';
        lText007: label '%1, %2: %3 %4</br>';
    begin
        if pTrExpHead."Concur Company Name" = CompanyName() then begin
            recTrExpLine.CopyFilters(pTrExpLine);
            if recTrExpLine.FindSet(true) then begin
                recConcurSetup.Get;
                recConcurSetup.TestField("Travel Exp. Pay Type Mail Add.");

                repeat
                    if (recTrExpLine."Car Business Distance" <> 0) or (recTrExpLine."Car Personal Distance" <> 0) then begin  // 17-12-20 ZY-LD 003
                        /*IF recConcurSetup."Travel Exp. Pay Type Code" <> '' THEN BEGIN  // DK
                        There need to be a dependensi to Payroll in the setup.
                            recGenRegJnl.VALIDATE("Journal Name", 'STANDARD');
                            recGenRegJnl.VALIDATE("Line No.", GetNextPeriodLine);
                            recGenRegJnl.VALIDATE("Employee No.", DELCHR(pTrExpHead."Cost Type Name", '=', 'DK'));
                            recGenRegJnl.VALIDATE("Pay Type No.", recConcurSetup."Travel Exp. Pay Type Code");
                            recGenRegJnl.VALIDATE("Reg. Journal Date", TODAY);
                            recGenRegJnl.VALIDATE(Units, recTrExpLine."Car Business Distance" + recTrExpLine."Car Personal Distance");
                            recGenRegJnl.INSERT(TRUE);
                        END;*/

                        if BodyText = '' then
                            BodyText := lText003;
                        BodyText += StrSubstNo(lText004, recTrExpLine."Document No.", recTrExpLine."Business Purpose", recTrExpLine."Car Business Distance" + recTrExpLine."Car Personal Distance");
                        TotalMilage += recTrExpLine."Car Business Distance" + recTrExpLine."Car Personal Distance";

                        recTrExpLine."Milage is Sent to Salary" := true;
                        recTrExpLine.Modify;
                    end else begin
                        //>> 21-06-22 ZY-LD 004
                        if BodyText2 = '' then
                            BodyText2 := lText006;
                        BodyText2 += StrSubstNo(lText007, recTrExpLine."Expense Type", recTrExpLine."Business Purpose", recTrExpLine.Amount, recTrExpLine."Currency Code");
                        //<< 21-06-22 ZY-LD 004
                    end;
                until recTrExpLine.Next() = 0;
                if TotalMilage <> 0 then
                    BodyText += StrSubstNo(lText005, TotalMilage);

                pTrExpHead.CalcFields("Employee Name");
                SI.SetMergefield(100, pTrExpHead."Employee Name");
                //>> 17-12-20 ZY-LD 003
                //SI.SetMergefield(101,BodyText);
                //EmailAddMgt.CreateSimpleEmail(recGenSetup."Travel Exp. Pay Type Mail Add.",'','');
                EmailAddMgt.CreateEmailWithBodytext2(recConcurSetup."Travel Exp. Pay Type Mail Add.", '', BodyText + BodyText2, '');
                //<< 17-12-20 ZY-LD 003
                EmailAddMgt.Send;
                if ZGT.CompanyNameIs(10) then
                    Message(lText001)
                else
                    Message(lText002);

                pTrExpHead."Document Status" := pTrExpHead."document status"::Posted;
                pTrExpHead.Modify;
                Commit;
            end;
        end;
    end;



    procedure SetPostJournal(NewPostJournal: Boolean)
    begin
        PostJournal := NewPostJournal;
    end;
}
