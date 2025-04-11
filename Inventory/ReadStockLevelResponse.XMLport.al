XmlPort 50072 "Read Stock Level Response"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 05-04-22 ZY-LD 000 - QuantityBlocked, QuantityInspecting and QuantityAllocated does not exist anymore. XML structure has been adjusted.
    // 003 09-09-24 ZY-LD 000 - Saving import date.

    Caption = 'Read Stock Level Response';
    Direction = Import;
    Encoding = UTF8;
    Format = Xml;
    FormatEvaluate = Xml;
    UseDefaultNamespace = false;
    UseRequestPage = false;

    schema
    {
        textelement(InventoryRequestResponse)
        {
            textelement(Items)
            {
                tableelement("Warehouse Item Ledger Entry"; "Warehouse Item Ledger Entry")
                {
                    AutoSave = false;
                    XmlName = 'Item';
                    textelement(Index)
                    {
                    }
                    textelement(itemno1)
                    {
                        XmlName = 'ItemNo';
                    }
                    fieldelement(ProductNo; "Warehouse Item Ledger Entry"."Item No.")
                    {
                    }
                    textelement(Description)
                    {
                    }
                    fieldelement(Warehouse; "Warehouse Item Ledger Entry"."Warehouse Location Code")
                    {
                    }
                    fieldelement(Location; "Warehouse Item Ledger Entry"."Location Code")
                    {
                    }
                    textelement(Bin)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(Grade)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(QuantityOnHand)
                    {
                    }

                    trigger OnBeforeInsertRecord()
                    begin
                        recItemTmp."No." := "Warehouse Item Ledger Entry"."Item No.";
                        recItemTmp."Category 1 Code" := "Warehouse Item Ledger Entry"."Location Code";
                        if not recItemTmp.Insert then;

                        if LocationCode = '' then
                            LocationCode := "Warehouse Item Ledger Entry"."Location Code";

                        recWhseItemLedgEntry := "Warehouse Item Ledger Entry";
                        recWhseItemLedgEntry.Date := WhseDate;
                        recWhseItemLedgEntry."Creation Date" := CDT;

                        // Calculate Previous quantity here.
                        recItem.SetAutocalcFields("Warehouse Inventory");
                        recItem.SetFilter("Date Filter", '..%1', WhseDate);

                        recItem.SetRange("Location Filter", "Warehouse Item Ledger Entry"."Location Code");

                        Evaluate(Qty, QuantityOnHand);
                        if Qty <> 0 then begin
                            recItem.SetRange("Quanty Type Filter", recWhseItemLedgEntry."Quanty Type");
                            recItem.Get("Warehouse Item Ledger Entry"."Item No.");

                            if Qty <> recItem."Warehouse Inventory" then begin
                                recWhseItemLedgEntry."Entry No." := NextEntryNo;
                                recWhseItemLedgEntry."Quanty Type" := recWhseItemLedgEntry."quanty type"::"On Hand";
                                recWhseItemLedgEntry.Quantity := Qty - recItem."Warehouse Inventory";
                                recWhseItemLedgEntry.Insert(true);
                                NextEntryNo += 1;
                            end;
                        end;

                        //>> 05-04-22 ZY-LD 002
                        /*EVALUATE(Qty,QuantityBlocked);
                        IF Qty <> 0 THEN BEGIN
                          recItem.SETRANGE("Quanty Type Filter",recWhseItemLedgEntry."Quanty Type");
                          recItem.GET("Warehouse Item Ledger Entry"."Item No.");
                        
                          IF Qty <> recItem."Warehouse Inventory" THEN BEGIN
                            recWhseItemLedgEntry."Entry No." := NextEntryNo;
                            recWhseItemLedgEntry."Quanty Type" := recWhseItemLedgEntry."Quanty Type"::Blocked;
                            recWhseItemLedgEntry.Quantity := Qty - recItem."Warehouse Inventory";
                            recWhseItemLedgEntry.INSERT(TRUE);
                            NextEntryNo += 1;
                          END;
                        END;
                        
                        EVALUATE(Qty,QuantityInspecting);
                        IF Qty <> 0 THEN BEGIN
                          recItem.SETRANGE("Quanty Type Filter",recWhseItemLedgEntry."Quanty Type");
                          recItem.GET("Warehouse Item Ledger Entry"."Item No.");
                        
                          IF Qty <> recItem."Warehouse Inventory" THEN BEGIN
                            recWhseItemLedgEntry."Entry No." := NextEntryNo;
                            recWhseItemLedgEntry."Quanty Type" := recWhseItemLedgEntry."Quanty Type"::Inspecting;
                            recWhseItemLedgEntry.Quantity := Qty - recItem."Warehouse Inventory";
                            recWhseItemLedgEntry.INSERT(TRUE);
                            NextEntryNo += 1;
                          END;
                        END;
                        
                        EVALUATE(Qty,QuantityAllocated);
                        IF Qty <> 0 THEN BEGIN
                          recItem.SETRANGE("Quanty Type Filter",recWhseItemLedgEntry."Quanty Type");
                          recItem.GET("Warehouse Item Ledger Entry"."Item No.");
                        
                          IF Qty <> recItem."Warehouse Inventory" THEN BEGIN
                            recWhseItemLedgEntry."Entry No." := NextEntryNo;
                            recWhseItemLedgEntry."Quanty Type" := recWhseItemLedgEntry."Quanty Type"::Allocated;
                            recWhseItemLedgEntry.Quantity := Qty - recItem."Warehouse Inventory";
                            recWhseItemLedgEntry.INSERT(TRUE);
                            NextEntryNo += 1;
                          END;
                        END;*/
                        //<< 05-04-22 ZY-LD 002

                    end;
                }
            }
        }
    }

    trigger OnPostXmlPort()
    var
        Location: Record Location;
    begin
        // If the warehouse inventory is zero, it will not be present in the file. Therefore we reduce the quantity if inventory is zero.
        //>> 09-09-24 ZY-LD 003        
        Location.SetRange("In Use", true);
        if Location.FindSet() then
            repeat  //<< 09-09-24 ZY-LD 003
                recItem.Reset;
                recItem.SetFilter("Date Filter", '..%1', WhseDate);
                //recItem.SetRange("Location Filter", LocationCode);  // 09-09-24 ZY-LD 003
                recItem.SetRange("Location Filter", Location.Code);  // 09-09-24 ZY-LD 003
                recItem.SetRange("Quanty Type Filter", recItem."quanty type filter"::"On Hand");
                recItem.SetFilter("Warehouse Inventory", '<>%1', 0);  // 09-09-24 ZY-LD 003
                recItem.SetAutocalcFields(Inventory, "Warehouse Inventory");
                if recItem.FindSet then begin
                    ZGT.OpenProgressWindow('', recItem.Count);
                    repeat
                        ZGT.UpdateProgressWindow(Location.Code, 0, true);

                        recItemTmp.SetRange("No.", recItem."No.");  // 09-09-24 ZY-LD 003
                        recItemTmp.SetRange("Category 1 Code", Location.Code);  // 09-09-24 ZY-LD 003
                        if not recItemTmp.FindFirst() then
                            if (recItem.Inventory = 0) and
                               (recItem.Inventory <> recItem."Warehouse Inventory")
                            then begin
                                recWhseItemLedgEntry."Entry No." := NextEntryNo;
                                recWhseItemLedgEntry.Warehouse := recWhseItemLedgEntry.Warehouse::VCK;
                                recWhseItemLedgEntry."Item No." := recItem."No.";
                                recWhseItemLedgEntry."Warehouse Location Code" := Location.code;
                                recWhseItemLedgEntry."Location Code" := Location.Code;
                                recWhseItemLedgEntry.Date := WhseDate;
                                recWhseItemLedgEntry."Creation Date" := CDT;
                                recWhseItemLedgEntry."Quanty Type" := recWhseItemLedgEntry."quanty type"::"On Hand";
                                recWhseItemLedgEntry.Quantity := -recItem."Warehouse Inventory";
                                recWhseItemLedgEntry.Insert(true);
                                NextEntryNo += 1;
                            end;
                    until recItem.Next() = 0;

                    ZGT.CloseProgressWindow;
                end;
            Until Location.Next() = 0;
    end;

    trigger OnPreXmlPort()
    begin
        NextEntryNo := recWhseItemLedgEntry.GetNextEntryNo;
        CDT := CurrentDatetime;
    end;

    var
        recWhseItemLedgEntry: Record "Warehouse Item Ledger Entry";
        recItem: Record Item;
        recItemTmp: Record Item temporary;
        SystemDT: DateTime;
        WhseDate: Date;
        LocationCode: Code[10];
        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        NextEntryNo: Integer;
        Qty: Integer;
        CDT: DateTime;
        ZGT: Codeunit "ZyXEL General Tools";


    procedure Init(NewWarehouseDate: Date)
    var
        AutoSetup: Record "Automation Setup";
    begin
        WhseDate := NewWarehouseDate;

        //>> 09-09-24 ZY-LD 003
        AutoSetup.get;
        AutoSetup."Last Imported Inventory Date" := WhseDate;
        AutoSetup.Modify(true);
        //<< 09-09-24 ZY-LD 003
    end;
}
