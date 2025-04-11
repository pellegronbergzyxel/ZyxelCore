Codeunit 61300 "Read Warehouse Inventory"
{

    trigger OnRun()
    begin
        Message(Text001, CountDifference(recItemTmp, true), Today - 1);
        ShowDifference(recItemTmp);
    end;

    var
        recItemTmp: Record Item temporary;
        Text001: label 'There are %1 items (..%2) where there are difference between the physical inventory and the inventory in NAV.';
        ZGT: Codeunit "ZyXEL General Tools";


    procedure CountDifference(var pItemTmp: Record Item temporary; ShowAll: Boolean): Integer
    var
        recItem: Record Item;
        recInvSetup: Record "Inventory Setup";
        recAutoSetup: Record "Automation Setup";
        WhseInv: Query "Warehouse Inventory";
        InsertTmp: Boolean;
        i: Integer;
        WorkDays: Integer;
        OriginalDiff: Integer;
    begin
        if ZGT.IsRhq then begin
            pItemTmp.DeleteAll;
            recInvSetup.Get;
            recAutoSetup.Get;
            WhseInv.SetFilter(Date_Filter, '..%1', Today - 1);
            WhseInv.SetRange(Location_Filter, recInvSetup."AIT Location Code");
            WhseInv.Open;
            while WhseInv.Read do begin
                if WhseInv.Net_Change <> WhseInv.Warehouse_Inventory then begin
                    InsertTmp := true;
                    WorkDays := 1;
                    OriginalDiff := WhseInv.Warehouse_Inventory - WhseInv.Net_Change;

                    if recAutoSetup.EndOfMonthAllowed and (not ShowAll) then begin
                        recItem.SetRange("Location Filter", recInvSetup."AIT Location Code");
                        recItem.SetRange("Quanty Type Filter", recItem."quanty type filter"::"On Hand");
                        for i := 2 to 6 do
                            if Date2dwy(Today - i, 1) <= 5 then begin  // We don't calculate weekends.
                                recItem.SetFilter("Date Filter", '..%1', Today - i);
                                recItem.Get(WhseInv.No);
                                recItem.CalcFields("Net Change", "Warehouse Inventory");
                                if (recItem."Net Change" = recItem."Warehouse Inventory") or
                                   ((recItem."Warehouse Inventory" - recItem."Net Change") <> OriginalDiff)  // If difference is identical for 4 says we want to show.
                                then begin
                                    InsertTmp := false;
                                    i := 999;
                                end;

                                WorkDays += 1;
                                if WorkDays >= 4 then
                                    i := 999;
                            end;
                    end;

                    if InsertTmp then begin
                        pItemTmp."No." := WhseInv.No;
                        pItemTmp.Description := WhseInv.Description;
                        pItemTmp.Insert;
                    end;
                end;
            end;
            exit(pItemTmp.Count);
        end;
    end;


    procedure ShowDifference(var pItemTmp: Record Item temporary)
    var
        recInvSetup: Record "Inventory Setup";
    begin
        if ZGT.IsRhq then begin
            recInvSetup.Get;

            pItemTmp.SetFilter("Date Filter", '..%1', Today - 1);
            pItemTmp.SetRange("Location Filter", recInvSetup."AIT Location Code");
            pItemTmp.SetRange("Quanty Type Filter", pItemTmp."quanty type filter"::"On Hand");
            Page.RunModal(Page::"Whse. Inventory Diff.", pItemTmp);
        end;
    end;
}
