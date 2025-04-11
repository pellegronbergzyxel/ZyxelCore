Codeunit 62010 "Process EMEA Purchase Price"
{
    // 001. 25-08-20 ZY-LD 000 - Set "New Price" to false on licenses.


    trigger OnRun()
    begin
        if ZGT.IsRhq then begin
            SI.SetHideSalesDialog(true);
            Process;
            SI.SetHideSalesDialog(false);
        end;
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";

    local procedure Process()
    var
        recPurchPrice: Record "Price List Line";
        recPurchPrice2: Record "Price List Line";
        recItem: Record Item;
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
    begin
        recPurchPrice.SetRange("Price Type", recPurchPrice."Price Type"::Purchase);
        recPurchPrice.SetRange("New Price", true);
        recPurchPrice.SetRange("Ending Date", 0D);
        if recPurchPrice.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recPurchPrice.Count);
            repeat
                ZGT.UpdateProgressWindow(recPurchPrice."Asset No.", 0, true);
                if recItem.Get(recPurchPrice."Asset No.") then
                    if (not recItem.IsEICard) and
                       (not recItem."Non ZyXEL License")  // 25-08-20 ZY-LD 001
                    then begin
                        if recItem."SBU Company" <> recItem."sbu company"::" " then
                            ItemLogisticEvents.UpdateEmeaItemPrices(recPurchPrice);
                    end else begin
                        //>> 25-08-20 ZY-LD 001
                        recPurchPrice2 := recPurchPrice;
                        recPurchPrice2."New Price" := false;
                        recPurchPrice2.Modify;
                        //<< 25-08-20 ZY-LD 001
                    end;
            until recPurchPrice.Next() = 0;
            ZGT.CloseProgressWindow;
        end;
    end;
}
