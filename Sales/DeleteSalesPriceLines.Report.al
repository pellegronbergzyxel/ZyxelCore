report 50117 "Delete Sales Price Cleanup"
{
    //12-03-2026 BK: #558088
    Caption = 'Delete Price Lists Cleanup';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", Blocked;
            trigger OnPreDataItem()
            begin
                SetRange(Status, Item.Status::"End of Life");
            end;

            trigger OnAfterGetRecord()
            begin
                if Item."Block on Sales Order" then
                    //DeletePriceLinesForItem(Item."No.");

                Error('waiting for approval'); // for at undgå at vise data i report output, da det er en processing only report
            end;

            trigger OnPostDataItem()
            begin
                // Til sidst: slet alle prislinjer hvor både start- og slutdato er før i dag
                //DeleteExpiredPriceLines();
            end;
        }
    }

    var
        PriceListLine: Record "Price List Line";
        DeletedBlockedCnt: Integer;
        DeletedExpiredCnt: Integer;
        TodayDate: Date;
        CommitEvery: Integer;
        SinceLastCommit: Integer;

    trigger OnPreReport()
    begin
        TodayDate := Today();
        CommitEvery := 5000; // justér efter datamængde
        SinceLastCommit := 0;
        DeletedBlockedCnt := 0;
        DeletedExpiredCnt := 0;
    end;

    trigger OnPostReport()
    begin
        if GuiAllowed then
            Message(
            'Deleting finished.\' +
            'Deleted lines from Items: %1\' +
            'Deleted expired price lines (Date before today): %2',
            DeletedBlockedCnt, DeletedExpiredCnt);
    end;

    local procedure DeletePriceLinesForItem(ItemNo: Code[20])
    begin
        PriceListLine.Reset();
        PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
        PriceListLine.SetRange("Asset No.", ItemNo);

        // Slet kun linjer der faktisk findes
        if PriceListLine.FindSet(true) then begin
            repeat
                PriceListLine.Delete();
                DeletedBlockedCnt += 1;
                HandleCommit();
            until PriceListLine.Next() = 0;
        end;
    end;

    local procedure DeleteExpiredPriceLines()
    var
        PriceListLine: Record "Price List Line";
    begin
        PriceListLine.Reset();

        // Antag felter: "Starting Date" og "Ending Date"
        // Krav: både startdato og slutdato før i dag
        PriceListLine.SetFilter("Starting Date", '..%1', CalcDate('<-1D>', TodayDate));
        PriceListLine.SetFilter("Ending Date", '..%1', CalcDate('<-1D>', TodayDate));

        if PriceListLine.FindSet(true) then begin
            repeat
                PriceListLine.Delete();
                DeletedExpiredCnt += 1;
                HandleCommit();
            until PriceListLine.Next() = 0;
        end;
    end;

    local procedure HandleCommit()
    begin
        SinceLastCommit += 1;
        if SinceLastCommit >= CommitEvery then begin
            Commit();
            SinceLastCommit := 0;
        end;
    end;
}
