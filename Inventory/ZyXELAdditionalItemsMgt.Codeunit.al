Codeunit 50069 "ZyXEL Additional Items Mgt"
{
    // 001. 20-11-18 ZY-LD 2018111910000071 - Forecast Territory is added.
    // 002. 16-01-19 ZY-LD 2019011610000067 - It must not run through additional item lines.
    // 003. 31-07-19 ZT-PBA 13-07-19 .. 02-07-19 PAB - Changes made for Project Rock Go-live.
    // 004. 26-08-19 ZY-LD 2019082610000062 - Shipping Date and Shipping Date Confirmed was not set correct on update.
    // 005. 30-12-19 ZY-LD 000 - Additional Items don't go with drop shipments.
    // 006. 08-10-20 ZY-LD P0494 - Edit Additional Line.


    trigger OnRun()
    begin
    end;

    var
        SI: Codeunit "Single Instance";


    procedure InsertAdditionalItems(DocumentType: enum "Sales Document Type"; DocumentNo: Code[20]; ItemNo: Code[20]; SalesLineNo: Integer)
    var
        recItem: Record Item;
        recDimSetEntry: Record "Dimension Set Entry";
        recGenLedgSetup: Record "General Ledger Setup";
        recSalesHeader: Record "Sales Header";
        recAdditionalItems: Record "Additional Item";
        recCust: Record Customer;
        ZGT: Codeunit "ZyXEL General Tools"; //10-03-2026 BK #560238
        AddItem1: Code[20];
        AddItem2: Code[20];
        AddItem3: Code[20];
        AddFound: Boolean;

        LoopNo: Integer;
    begin
        if DocumentType = Documenttype::Order then begin
            recSalesHeader.SetRange("Document Type", DocumentType);
            recSalesHeader.SetRange("No.", DocumentNo);
            recSalesHeader.SetFilter("Sales Order Type", '<>%1', recSalesHeader."sales order type"::"Drop Shipment");
            if recSalesHeader.FindFirst then begin
                recGenLedgSetup.Get;
                recDimSetEntry.SetRange("Dimension Set ID", recSalesHeader."Dimension Set ID");
                recDimSetEntry.SetRange("Dimension Code", recGenLedgSetup."Global Dimension 2 Code");
                recDimSetEntry.SetRange("Dimension Value Code", 'RMA');
                if not recDimSetEntry.FindFirst then begin

                    recCust.Get(recSalesHeader."Sell-to Customer No.");
                    recCust.TestField("Forecast Territory");
                    //recAdditionalItems.SETRANGE("Ship-to Country/Region",recSalesHeader."Ship-to Country/Region Code");
                    recAdditionalItems.SetFilter("Ship-to Country/Region", '%1|%2', '', recSalesHeader."Ship-to Country/Region Code");
                    recAdditionalItems.SetFilter("Forecast Territory", '%1|%2', '', recCust."Forecast Territory");
                    if recCust."Additional Items" then
                        recAdditionalItems.SetRange("Customer No.", recCust."No.")
                    else
                        recAdditionalItems.SetFilter("Customer No.", '%1', '');
                    recAdditionalItems.SetRange("Item No.", ItemNo);
                    if recAdditionalItems.FindSet then
                        repeat
                            //10-03-2026 BK #560238
                            LoopNo := ZGT.FindNextSalesLine(DocumentNo, SalesLineNo);//10-03-2026 BK #560238
                            AddLine(
                              DocumentType,
                              DocumentNo,
                              SalesLineNo,
                              SalesLineNo + LoopNo,
                              recAdditionalItems."Additional Item No.",
                              0,
                              recAdditionalItems.Quantity,
                              recAdditionalItems."Hide Line",
                              0D,
                              false,
                              recAdditionalItems."Edit Additional Sales Line");
                        until recAdditionalItems.Next() = 0;
                end;
            end;
        end;
    end;



    procedure UpdateAdditionalItems(SalesOrderType: enum "Sales Document Type"; SalesOrderNo: Code[20]; ShipToCountry: Code[10])
    var
        recSalesLine: Record "Sales Line";
        recSalesLine2: Record "Sales Line";
        recAddItem: Record "Additional Item";
        recCust: Record Customer;
        LoopNo: Integer;
        lText001: label 'Additional items are inserted.';
        lText002: label 'Additional items are deleted.';
        AddItemsAdded: Boolean;
        AddItemsDeleted: Boolean;
    begin
        // If Ship-to Country is changed after additional items are inserted, we ajust the additional items
        if SalesOrderType = Salesordertype::Order then begin
            recSalesLine.SetRange("Document Type", SalesOrderType);
            recSalesLine.SetRange("Document No.", SalesOrderNo);
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            recSalesLine.SetFilter("No.", '<>%1', '');
            recSalesLine.SetRange("Additional Item Line No.", 0);
            if recSalesLine.FindSet then begin
                repeat
                    LoopNo := 0;
                    recAddItem.SetRange("Item No.", recSalesLine."No.");
                    recCust.Get(recSalesLine."Sell-to Customer No.");
                    recCust.TestField("Forecast Territory");
                    recAddItem.SetFilter("Ship-to Country/Region", '%1|%2', '', ShipToCountry);
                    recAddItem.SetFilter("Forecast Territory", '%1|%2', '', recCust."Forecast Territory");
                    if recCust."Additional Items" then
                        recAddItem.SetRange("Customer No.", recCust."No.")
                    else
                        recAddItem.SetFilter("Customer No.", '%1', '');
                    if recAddItem.FindSet then begin
                        repeat
                            LoopNo += 1;

                            // Search for existing additional items
                            recSalesLine2.SetRange("Document Type", SalesOrderType);
                            recSalesLine2.SetRange("Document No.", SalesOrderNo);
                            recSalesLine2.SetRange("Additional Item Line No.", recSalesLine."Line No.");
                            recSalesLine2.SetRange("No.", recAddItem."Additional Item No.");
                            if not recSalesLine2.FindFirst then begin
                                AddLine(
                                  recSalesLine."Document Type",
                                  recSalesLine."Document No.",
                                  recSalesLine."Line No.",
                                  recSalesLine."Line No." + LoopNo,
                                  recAddItem."Additional Item No.",
                                  recSalesLine.Quantity,
                                  recAddItem.Quantity,
                                  recAddItem."Hide Line",
                                  recSalesLine."Shipment Date",
                                  recSalesLine."Shipment Date Confirmed",
                                  recAddItem."Edit Additional Sales Line");
                                AddItemsAdded := true;
                            end;
                        until recAddItem.Next() = 0;
                    end else begin
                        // Delete all addtional items.
                        recSalesLine2.SetRange("Document Type", SalesOrderType);
                        recSalesLine2.SetRange("Document No.", SalesOrderNo);
                        recSalesLine2.SetRange("Additional Item Line No.", recSalesLine."Line No.");
                        if recSalesLine2.FindFirst then begin
                            SI.SetAllowToDeleteAddItem(true);
                            recSalesLine2.DeleteAll(true);
                            SI.SetAllowToDeleteAddItem(false);
                            AddItemsDeleted := true;
                        end;
                    end;
                until recSalesLine.Next() = 0;

                if AddItemsAdded then
                    Message(lText001);
                if AddItemsDeleted then
                    Message(lText002);
            end;
        end;
    end;

    local procedure AddLine(SalesOrderType: enum "Sales Document Type"; SalesOrderNo: Code[20]; SalesLineNo: Integer; LineNo: Integer; ItemNo: Code[20]; Qty: Integer; AddQty: Decimal; HideLine: Boolean; ShipDate: Date; ShipDateConfirmed: Boolean; EditAddLine: Boolean)
    var
        recSaleLine: Record "Sales Line";
    begin
        if LineNo <> 0 then begin
            recSaleLine.Init;
            recSaleLine.Validate("Document Type", recSaleLine."document type"::Order);
            recSaleLine.Validate("Document No.", SalesOrderNo);
            recSaleLine.Validate("Line No.", LineNo);
            recSaleLine.Validate(Type, recSaleLine.Type::Item);
            recSaleLine.Validate("No.", ItemNo);
            recSaleLine.Validate(Quantity, Qty);
            recSaleLine.Validate("Hide Line", HideLine);
            recSaleLine."Additional Item Line No." := SalesLineNo;
            if AddQty = 0 then
                AddQty := 1;
            recSaleLine."Additional Item Quantity" := AddQty;
            recSaleLine."Shipment Date" := ShipDate;
            recSaleLine."Shipment Date Confirmed" := ShipDateConfirmed;
            recSaleLine."Edit Additional Sales Line" := EditAddLine;  // 08-10-20 ZY-LD 006
            recSaleLine.Insert(true);
        end else
            Message('Cant Get Line No');
    end;
}
