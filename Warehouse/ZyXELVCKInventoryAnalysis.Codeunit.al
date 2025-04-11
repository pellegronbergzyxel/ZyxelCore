Codeunit 50009 "ZyXEL VCK Inventory Analysis"
{
    // 15-51643  11/02/16  TB
    //   V2009-V2016 Upgrade
    //   Add. Fn. GetDefaultDimensions()
    //   Mod. Fn. MakeInventoryAdjustment()
    // 
    // 001. 01-11-18 ZY-LD 000 - New fields.
    // 002. 15-05-19 ZY-LD 2019051510000061 - Running on Items indtead of value from VCK.
    // 003. 23-11-20 ZY-LD 2020112310000102 - Don´t deduct "Ready to Pick".
    // 004. 07-12-20 ZY-LD 2020120710000079 - Changed the calculation of delta.

    Permissions = TableData "Item Ledger Entry" = r;

    trigger OnRun()
    begin
    end;

    var
        Text001a: label 'The location code of the All-In Logistics warehouse has not been set in the Sales & Receivables Setup.';
        Text002a: label 'AIT Integration has not been setup correctly in Inventory Setup.';


    procedure BuildAnalysisView(ShowDialog: Boolean) Delta: Integer
    var
        recAllInInventoryAnalysis: Record "VCK Inventory Analysis";
        recItem: Record Item;
        recSalesReceivablesSetup: Record "Sales & Receivables Setup";
        AllInLocation: Code[20];
        recAllInInventory: Record "VCK Inventory";
        UID: Integer;
        recDeliveryDocumentLine: Record "VCK Delivery Document Line";
        qtyDD: Integer;
        QtyInvReceived: Integer;
        recItemLedgerEntry: Record "Item Ledger Entry";
        CurrRec: Integer;
        NoOfRecs: Integer;
        window: Dialog;
    begin
        Delta := 0;
        if recSalesReceivablesSetup.FindFirst then
            AllInLocation := recSalesReceivablesSetup."All-In Logistics Location";
        if AllInLocation = '' then
            Error(Text001a);
        recAllInInventoryAnalysis.DeleteAll;

        //IF recAllInInventory.FINDFIRST THEN BEGIN  // 15-05-19 ZY-LD 002
        recDeliveryDocumentLine.SetCurrentkey("Item No.");  // 15-05-19 ZY-LD 002
        recItem.SetFilter("No.", '<>DMY*');
        if recItem.FindFirst then begin  // 15-05-19 ZY-LD 002
            if ShowDialog then begin
                window.Open('Building Inventory Analysis...\@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                NoOfRecs := recItem.Count;  // 15-05-19 ZY-LD 002
            end;

            repeat
                UID := UID + 1;
                if ShowDialog then begin
                    CurrRec += 1;
                    if NoOfRecs <= 100 then
                        window.Update(1, (CurrRec / NoOfRecs * 10000) DIV 1)
                    else
                        if CurrRec MOD (NoOfRecs DIV 100) = 0 then
                            window.Update(1, (CurrRec / NoOfRecs * 10000) DIV 1);
                end;

                //>> 15-05-19 ZY-LD 002
                recAllInInventory.SetRange("Item No.", recItem."No.");
                recAllInInventory.SetRange(Location, AllInLocation);
                if not recAllInInventory.FindFirst then
                    Clear(recAllInInventory);
                //<< 15-05-19 ZY-LD 002

                recAllInInventoryAnalysis.Init;
                recAllInInventoryAnalysis.UID := UID;
                recAllInInventoryAnalysis."Time Stamp" := recAllInInventory."Time Stamp";
                recAllInInventoryAnalysis."Item No." := recItem."No.";  // 15-05-19 ZY-LD 002
                recAllInInventoryAnalysis.Location := AllInLocation;  // 15-05-19 ZY-LD 002
                recAllInInventoryAnalysis.Warehouse := recAllInInventory.Warehouse;
                recAllInInventoryAnalysis."Quantity On Hand VCK" := recAllInInventory."Quantity On Hand";
                qtyDD := 0;
                QtyInvReceived := 0;
                //recDeliveryDocumentLine.RESET;  // 15-05-19 ZY-LD 002
                recDeliveryDocumentLine.SetRange("Item No.", recAllInInventory."Item No.");
                if recDeliveryDocumentLine.FindSet then begin  // 15-05-19 ZY-LD 002  Changed to FINDSET
                    repeat
                        if recDeliveryDocumentLine."Transfer Order No." = '' then begin
                            if recDeliveryDocumentLine."Warehouse Status" = recDeliveryDocumentLine."warehouse status"::Backorder then
                                qtyDD := qtyDD + recDeliveryDocumentLine.Quantity;
                            //IF recDeliveryDocumentLine."Warehouse Status" = recDeliveryDocumentLine."Warehouse Status"::"Ready to Pick" THEN  // 23-11-20 ZY-LD 003
                            //  qtyDD := qtyDD + recDeliveryDocumentLine.Quantity;  // 23-11-20 ZY-LD 003
                            if recDeliveryDocumentLine."Warehouse Status" = recDeliveryDocumentLine."warehouse status"::Picking then
                                qtyDD := qtyDD + recDeliveryDocumentLine.Quantity;
                            if recDeliveryDocumentLine."Warehouse Status" = recDeliveryDocumentLine."warehouse status"::Packed then
                                qtyDD := qtyDD + recDeliveryDocumentLine.Quantity;
                            //>> 01-11-18 ZY-LD 001
                            if recDeliveryDocumentLine."Warehouse Status" = recDeliveryDocumentLine."warehouse status"::"Invoice Received" then
                                QtyInvReceived += recDeliveryDocumentLine.Quantity;
                            //<< 01-11-18 ZY-LD 001
                        end;
                    until recDeliveryDocumentLine.Next() = 0;
                end;
                recItemLedgerEntry.SetCurrentkey("Item No.", "Location Code");
                recItemLedgerEntry.SetFilter("Item No.", recAllInInventoryAnalysis."Item No.");
                recItemLedgerEntry.SetFilter("Location Code", AllInLocation);
                recItemLedgerEntry.CalcSums(Quantity);
                recAllInInventoryAnalysis."Quantity On Hand ZyXEL" := recItemLedgerEntry.Quantity - qtyDD;
                //>> 01-11-18 ZY-LD 001
                recAllInInventoryAnalysis."Quantity Item Ledger Entry" := recItemLedgerEntry.Quantity;
                recAllInInventoryAnalysis."Quantity Delivery Document" := qtyDD;
                recAllInInventoryAnalysis."Quantity Invoice Received" := QtyInvReceived;
                //<< 01-11-18 ZY-LD 001
                //recAllInInventoryAnalysis.Delta := (recItemLedgerEntry.Quantity - qtyDD) - recAllInInventory."Quantity On Hand";  // 07-12-20 ZY-LD 004
                recAllInInventoryAnalysis.Delta := (recItemLedgerEntry.Quantity - qtyDD) - recAllInInventory."Quantity Available";  // 07-12-20 ZY-LD 004
                if (recItemLedgerEntry.Quantity - qtyDD) - recAllInInventory."Quantity On Hand" <> 0 then
                    if recAllInInventory.Warehouse = AllInLocation then
                        if recAllInInventory.Location = AllInLocation then
                            Delta := Delta + 1;
                if (recAllInInventoryAnalysis."Quantity On Hand VCK" <> 0) or (recAllInInventoryAnalysis."Quantity On Hand ZyXEL" <> 0) then  // 15-05-19 ZY-LD 002
                    recAllInInventoryAnalysis.Insert;
            until recItem.Next() = 0;  // 15-05-19 ZY-LD 002
                                       //UNTIL recAllInInventory.Next() = 0;  // 15-05-19 ZY-LD 002
            if ShowDialog then
                window.Close;
        end;
    end;


    procedure MakeInventoryAdjustment(ItemNo: Code[20]; Quantity: Integer; AdjustmentType: Integer; ReasonCode: Code[10])
    var
        recItemJournalBatch: Record "Item Journal Batch";
        recItemJournalLine: Record "Item Journal Line";
        recInventorySetup: Record "Inventory Setup";
        AITJournalTemplateName: Code[10];
        AITBatchName: Code[10];
        AITLocationCode: Code[10];
        AITInventoryPostingGroup: Code[10];
        AITGenProdPostingGroup: Code[10];
        AITJournalDescription: Text[30];
        AITBatchDescription: Text[30];
        recAllInInventoryReasonChange: Record "VCK Inventory Reason Change";
    begin
        // Get Setup
        if recInventorySetup.FindFirst then begin
            AITJournalTemplateName := recInventorySetup."AIT Journal Template Name";
            AITBatchName := recInventorySetup."AIT Batch Name";
            AITLocationCode := recInventorySetup."AIT Location Code";
            AITInventoryPostingGroup := recInventorySetup."AIT Inventory Posting Group";
            AITGenProdPostingGroup := recInventorySetup."AIT Gen. Prod. Posting Group";
            AITJournalDescription := recInventorySetup."AIT Journal Description";
            AITBatchDescription := recInventorySetup."AIT Batch Description";
        end;
        recAllInInventoryReasonChange.SetFilter(Code, ReasonCode);
        if recAllInInventoryReasonChange.FindFirst then
            AITJournalDescription := recAllInInventoryReasonChange.Description;
        if AITJournalTemplateName = '' then
            Error(Text002a);
        if AITBatchName = '' then
            Error(Text002a);
        if AITLocationCode = '' then
            Error(Text002a);
        if AITInventoryPostingGroup = '' then
            Error(Text002a);
        if AITGenProdPostingGroup = '' then
            Error(Text002a);
        if AITJournalDescription = '' then
            Error(Text002a);
        if AITBatchDescription = '' then
            Error(Text002a);
        // Check Batch Name Exists
        recItemJournalBatch.SetFilter(Name, AITBatchName);
        recItemJournalBatch.SetFilter("Journal Template Name", AITJournalTemplateName);
        if not recItemJournalBatch.FindFirst then begin
            recItemJournalBatch.Init;
            recItemJournalBatch.Name := AITBatchName;
            recItemJournalBatch."Journal Template Name" := AITJournalTemplateName;
            recItemJournalBatch.Description := AITBatchDescription;
            recItemJournalBatch."Template Type" := recItemJournalBatch."template type"::Item;
            recItemJournalBatch.Insert;
        end;
        // Make Sure We Delete All Old Lines
        recItemJournalLine.SetFilter("Journal Template Name", AITJournalTemplateName);
        recItemJournalLine.SetFilter("Journal Batch Name", AITBatchName);
        if recItemJournalLine.FindFirst then begin
            repeat
                recItemJournalLine.Delete;
            until recItemJournalLine.Next() = 0;
        end;
        // Create Journal Line
        recItemJournalLine.Init;
        recItemJournalLine.Description := AITJournalDescription;
        recItemJournalLine."Journal Template Name" := AITJournalTemplateName;
        recItemJournalLine."Journal Batch Name" := AITBatchName;
        recItemJournalLine."Location Code" := AITLocationCode;
        recItemJournalLine."Inventory Posting Group" := AITInventoryPostingGroup;
        recItemJournalLine."Gen. Prod. Posting Group" := AITGenProdPostingGroup;
        recItemJournalLine."Line No." := 10000;
        recItemJournalLine."Document No." := GetLastNo;
        recItemJournalLine."Item No." := ItemNo;
        recItemJournalLine."Posting Date" := Today;
        recItemJournalLine."Document Date" := Today;
        if AdjustmentType = 0 then
            recItemJournalLine."Entry Type" := recItemJournalLine."entry type"::"Positive Adjmt.";
        if AdjustmentType = 1 then
            recItemJournalLine."Entry Type" := recItemJournalLine."entry type"::"Negative Adjmt.";
        recItemJournalLine.Quantity := Quantity;
        recItemJournalLine."Quantity (Base)" := Quantity;
        recItemJournalLine.Insert;
        // Get Default Dimensions
        //15-51643 - old code replaced by fn. GetDefaultDimensions()
        //recDefaultDimension.SETFILTER("Table ID",'27');
        //recDefaultDimension.SETFILTER("No.",ItemNo);
        //IF recDefaultDimension.FINDFIRST THEN BEGIN
        //  REPEAT
        //    recJournalLineDimension.INIT;
        //    recJournalLineDimension."Table ID" := 83;
        //    recJournalLineDimension."Journal Template Name" := AITJournalTemplateName;
        //    recJournalLineDimension."Journal Batch Name" := AITBatchName;
        //    recJournalLineDimension."Journal Line No." := 10000;
        //    recJournalLineDimension."Dimension Code" := recDefaultDimension."Dimension Code";
        //    recJournalLineDimension."Dimension Value Code" := recDefaultDimension."Dimension Value Code";
        //    recJournalLineDimension.INSERT;
        //  UNTIL recDefaultDimension.NEXT =0;
        //END;
        GetDefaultDimensions(recItemJournalLine);
        //15-51643 +
        Codeunit.Run(Codeunit::"Item Jnl.-Post", recItemJournalLine);
    end;

    local procedure GetLastNo() return: Code[10]
    var
        strCode: Code[10];
        NextNo: Integer;
        recInventorySetup: Record "Inventory Setup";
        LastNo: Code[20];
    begin
        if recInventorySetup.FindFirst then begin
            LastNo := recInventorySetup."AIT Last Journal Document No";
            if LastNo = '' then
                LastNo := 'AIT100000';
            strCode := DelChr(LastNo, '=', 'AIT');
            Evaluate(NextNo, strCode);
            NextNo := NextNo + 1;
            return := 'AIT' + Format(NextNo);
            recInventorySetup."AIT Last Journal Document No" := return;
            recInventorySetup.Modify;
        end;
    end;

    local procedure GetDefaultDimensions(var TheIJL: Record "Item Journal Line")
    var
        DimMgt: Codeunit DimensionManagement;
        DefDim: Record "Default Dimension";
        tDSE: Record "Dimension Set Entry" temporary;
        NewDSID: Integer;
    begin
        //15-51643
        DimMgt.GetDimensionSet(tDSE, TheIJL."Dimension Set ID");
        DefDim.Reset;
        DefDim.SetRange("Table ID", Database::Item);
        DefDim.SetRange("No.", TheIJL."Item No.");
        if DefDim.FindSet then
            repeat
                tDSE.Reset;
                tDSE.SetRange("Dimension Code", DefDim."Dimension Code");
                if tDSE.FindFirst then begin
                    tDSE.Validate("Dimension Value Code", DefDim."Dimension Value Code");
                    tDSE.Modify;
                end else begin
                    tDSE.Init;
                    tDSE.Validate("Dimension Code", DefDim."Dimension Code");
                    tDSE.Validate("Dimension Value Code", DefDim."Dimension Value Code");
                    tDSE.Insert;
                end;
            until DefDim.Next() = 0;
        tDSE.Reset;
        NewDSID := DimMgt.GetDimensionSetID(tDSE);
        if TheIJL."Dimension Set ID" <> NewDSID then begin
            TheIJL."Dimension Set ID" := NewDSID;
            TheIJL.Modify;
        end;
    end;
}
