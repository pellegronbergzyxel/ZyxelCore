codeunit 50077 "Zyxel HQ Web Service Mgt."
{
    // 001. 23-07-18 ZY-LD 2018071610000218 - HQ must not update Category 4.
    // 002. 17-08-18 ZY-LD 2018081710000054 - Product Length is added.
    // 003. 30-08-18 ZY-LD 000 - Number pr. parcel is added.
    // 004. 19-11-18 ZY-LD 000 - Purchase Order Line No. is not always updatet from HQ.
    // 005. 29-01-19 ZY-LD 000 - Since we send e-mail to VCK, we don't want to send it from the TEST.
    // 006. 31-01-19 ZY-LD 000 - "HQ Unit Price" can be different from "Direct Unit Cost". If it's different, we will update it to "HQ Unit Price", so GIT value will be correct.
    // 007. 11-02-19 ZY-LD 2019021110000047 - Find purchase order line no.
    // 008. 11-02-19 ZY-LD 2019021110000047 - Show HQ invoice no. in the subject of the e-mail.
    // 009. 26-02-19 ZY-LD 000 - We don't want previous on the list.
    // 010. 12-03-19 ZY-LD 000 - We now will receive data from two different eShops. We separate them on the purchase order no.  // 28-06-19 - Solution has been roled back.
    // 011. 13-03-19 Zy-LD 000 - Send also an e-mail 
    // 012. 14-03-19 ZY-LD 000 - We will not calculate at archived lines.
    // 013. 15-03-19 ZY-LD 000 - Batch No. can't contain a ";", to we do it now in another field.
    // 014. 19-03-19 ZY-LD 2019031810000149 - Sort descending, so "PO Line No." = 0 will be imported last.
    // 015. 28-06-19 ZY-LD P0213 - Vendor Type is added.
    // 016. 21-08-19 ZY-LD 2019072210000053 - Tim doesnt't want current month to be imported.
    // 017. 23-08-19 ZY-LD 2019082310000022 - Give more specific data to the e-mail.
    // 018. 25-09-19 ZY-LD P0307 - Transfer LBOM and OH, and if OH is below zero, then send an e-mail.
    // 019. 04-10-19 ZY-LD P0314 - Transfer "Ship-to Code".
    // 020. 18-10-19 ZY-LD 000 - Import of SBU via PLMS.
    // 021. 24-10-19 ZY-LD 000 - Update SBU Company.
    // 022. 25-11-19 ZY-LD 2019111910000051 - Send a warning.
    // 023. 03-01-19 ZY-LD 2020010310000043 - Suspend update of purchase price.
    // 024. 13-01-19 ZY-LD 000 - Update categories from ZCom HQ into ZNet EMEA.
    // 025. 10-02-20 ZY-LD P0390 - Update unit price on purchase order.
    // 026. 23-03-20 ZY-LD P0394 - New PLMS fields.
    // 027. 23-04-20 ZY-LD P0388 - Keep document no. and line no. if container details are updated.
    // 028. 11-06-20 P0444 - eRMA Turkey
    // 029. 03-07-20 ZY-LD 2020070210000052 - It has been seen that the Line No. didn´t exist.
    // 030. 11-08-20 ZY-LD 000 - Qty. per Color Box is added.
    // 031. 11-09-20 ZY-LD 2020091110000166 - "Carton per Pallet" was transfered but but not updated.
    // 032. 19-10-20 ZY-LD 2020101610000225 - VALIDATE is inserted to update "Business to".
    // 033. 21-10-20 ZY-LD 2020102010000182 - New fields to PLMS. Swedish chemical tax. - Is rolled back.
    // 034. 22-10-20 ZY-LD 2020102210000035 - It was possible that two received lines could have the same primary key. That is now solved by comparing the BatchNo.
    // 035. 06-01-21 ZY-LD 000 - Update of "SCIP No.".
    // 036. 17-02-21 ZY-LD 000 - When there ware more that two lines with the same item no, the line no. was wrong.
    // 037. 24-03-21 ZY-LD 000 - Expected Receipt Date is updated.
    // 038. 13-08-21 ZY-LD 000 - The fields are not used anymore.
    // 039. 14-10-21 ZY-LD 2021101210000089 - Sometimes we receive dummy item numbers that doesn´t exist in our system. We warn logistics about it.
    // 040. 15-11-21 ZY-LD 2021090610000067 - New primary key.
    // 041. 24-11-21 ZY-LD 2021112210000041 - Calculate shipping days.
    // 042. 20-01-21 ZY-LD 000 - We will now receive information about the main warehouse from HQ.
    // 043. 25-01-22 ZY-LD 000 - Since we have changed the primary key, we need to save it too
    // 044. 07-02-22 ZY-LD 000 - HQ doesn´t send lines on eCommerce, so we create them our selves, otherwise the automatated posting won´t run.
    // 045. 03-03-22 ZY-LD 2022030210000038 - New field to Chemical Tax.
    // 046. 17-03-22 ZY-LD 000 - Updating "Unit Volume".
    // 047. 04-05-22 ZY-LD 2022050210000132 - Calculate Expected Receipt Date.
    // 048. 10-05-22 ZY-LD 2022051010000144 - Container No. must only be there once.
    // 049. 19-05-22 ZY-LD 2022051910000119 - Updating Vessel Code.
    // 050. 23-05-22 ZY-LD 2022052310000129 - It happens that SEA freight has not container no., so now we send an e-mail instead.
    // 051. 09-06-22 ZY-LD 2022060810000111 - Container details has been updated, because data was encumbered with errors, which was not handled correct.
    // 052. 27-06-22 ZY-LD 2022062710000049 - We have seen shipments both with and without container no. in the same batch. I don´t think that is correct.
    // 053. 04-07-22 ZY-LD 000 - We did not always get the right line no, which did that the Eicard was now posted automatic.
    // 054. 06-07-22 ZY-LD 000 - "End Date" on the previous price was not set.
    // 055. 12-08-22 ZY-LD 2022081210000064 - According to mail from Steven they don´t want warning about negative overhead.
    // 056. 12-10-22 ZY-LD 000 - Create country mapping, if missing.
    // 057. 02-11-22 ZY-LD 000 - New field transferred from Taiwan.
    // 058. 14-12-22 ZY-LD 000 - New fields transferred after adjusting Amazon.
    // 059. 16-01-23 ZY-LD 2023011610000059 - When there are no lines (EMEA), the unshipped quantity in the sister company doesn´t get deleted.
    // 060. 14-02-23 ZY-LD 000 - Save the original forecast, so we are able to see if it increase or descrease ower time.
    // 061. 01-03-23 ZY-LD 000 - Transaction Type was missing.
    // 062. 24-03-23 ZY-LD 000 - Update if rework from item no is filled.
    // 063. 17-04-23 ZY-LD 000 - It was possible to locate the same purchase order line no. for more that one line. Therefore the filter has been moved.
    // 064. 17-05-23 ZY-LD 000 - WEEE Category.
    // 065. 09-06-23 ZY-LD 000 - Table 76132 was practical unused, and therefore removed.
    // 066. 16-06-23 ZY-LD 000 - MarketPlace ID can be either DE or UK.
    // 067. 15-01-24 ZY-LD 000 - It can happen that ZNet HQ send data to ZCom EMEA where the data is empty, but it has to delete the previous imported data.
    // 068. 23-02-24 ZY-LD 000 - We have seen errors when sending the mail, so to prevent that this function has been invented.
    // 069. 25-03-24 ZY-LD 000 - Previous we used the line no. from the "GetData" but that made a conflikt.
    // 070. 02-04-24 ZY-LD 000 - Updating Location Code.
    // 071. 16-04-24 ZY-LD 000 - Moved to the PLMS XMLport.
    // 072. 06-09-24 ZY-LD 000 - RUB must be handled differently.
    // 073. 26-09-24 ZY-LD 000 - It got blocked if data came from a transfer order.
    var
        WebServiceLogEntry: Record "Web Service Log Entry";
        ServerEnvironment: Record "Server Environment";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";

    procedure CountryOfOrigin(var pItemTmp: Record Item temporary): Boolean
    var
        recItem: Record Item;
        lText001: Label 'COUNTRY OF ORIGIN';
    begin
        // Update Country of Origin into item table
        if pItemTmp.FindSet() then begin
            CreateWebServiceLog(lText001, '');
            recItem.LockTable;
            repeat
                if recItem.Get(pItemTmp."No.") then
                    if recItem."Country/Region of Origin Code" <> pItemTmp."Country/Region of Origin Code" then begin
                        recItem."Country/Region of Origin Code" := pItemTmp."Country/Region of Origin Code";
                        recItem.Modify(true);
                        WebServiceLogEntry."Quantity Inserted" += 1;
                    end;
            until pItemTmp.Next() = 0;

            CloseWebServiceLog;

            exit(true);
        end;
    end;

    //>> 16-04-24 ZY-LD 071
    /*procedure PLMS(var pItemTmp: Record Item temporary; var pHqDimTmp: Record SBU temporary): Boolean
    var
        recItem: Record Item;
        recReworkItem: Record Item;
        recHqDimension: Record SBU;
        ItemNoList: Text;
        lText001: Label 'PLMS';
    begin
        // Updates PLMS into item table
        if pItemTmp.FindSet() then begin
            CreateWebServiceLog(lText001, '');

            //>> 18-10-19 ZY-LD 020
            if pHqDimTmp.FindSet() then
                repeat
                    recHqDimension := pHqDimTmp;
                    if not recHqDimension.Modify() then
                        recHqDimension.Insert();
                until pHqDimTmp.Next() = 0;
            //<< 18-10-19 ZY-LD 020

            recItem.LockTable;
            repeat
                if recItem.Get(pItemTmp."No.") then begin
                    if (recItem."Height (cm)" <> pItemTmp."Height (cm)") or
                       (recItem."Width (cm)" <> pItemTmp."Width (cm)") or
                       (recItem."Length (cm)" <> pItemTmp."Length (cm)") or
                       (recItem."Volume (cm3)" <> pItemTmp."Volume (cm3)") or
                       (recItem."Plastic Weight" <> pItemTmp."Plastic Weight") or
                       (recItem."Paper Weight" <> pItemTmp."Paper Weight") or
                       (recItem."Carton Weight" <> pItemTmp."Carton Weight") or
                       (recItem."Height (ctn)" <> pItemTmp."Height (ctn)") or
                       (recItem."Width (ctn)" <> pItemTmp."Width (ctn)") or
                       (recItem."Length (ctn)" <> pItemTmp."Length (ctn)") or
                       (recItem."Volume (ctn)" <> pItemTmp."Volume (ctn)") or
                       (recItem."Number per carton" <> pItemTmp."Number per carton") or
                       (recItem."Gross Weight" <> pItemTmp."Gross Weight") or
                       (recItem."Net Weight" <> pItemTmp."Net Weight") or
                       (recItem."Pallet Length (cm)" <> pItemTmp."Pallet Length (cm)") or
                       (recItem."Pallet Width (cm)" <> pItemTmp."Pallet Width (cm)") or
                       (recItem."Pallet Height (cm)" <> pItemTmp."Pallet Height (cm)") or
                       (recItem."UN Code" <> pItemTmp."UN Code") or
                       (recItem."Battery weight" <> pItemTmp."Battery weight") or
                       (recItem."Carton Weight" <> pItemTmp."Carton Weight") or
                       (recItem."Units per Parcel" <> pItemTmp."Units per Parcel") or
                       (recItem."Qty Per Pallet" <> pItemTmp."Qty Per Pallet") or
                       (recItem."End of Technical Support Date" <> pItemTmp."End of Technical Support Date") or
                       (recItem."End of RMA Date" <> pItemTmp."End of RMA Date") or
                       (recItem."Tax Reduction rate" <> pItemTmp."Tax Reduction rate") or
                       (recItem."Model Description" <> pItemTmp."Model Description") or
                       (recItem.GTIN <> pItemTmp.GTIN) or
                       (recItem."Category 1 Code" <> pItemTmp."Category 1 Code") or
                       (recItem."Category 2 Code" <> pItemTmp."Category 2 Code") or
                       (recItem."Category 3 Code" <> pItemTmp."Category 3 Code") or
                       //(recItem."Category 4 Code" <> pItemTmp."Category 4 Code") OR  // 23-07-18 ZY-LD 001
                       (recItem."Business Center" <> pItemTmp."Business Center") or
                       (recItem.SBU <> pItemTmp.SBU) or
                       (recItem."SBU Company" <> pItemTmp."SBU Company") or  // 24-10-19 ZY-LD 021
                       (recItem."HQ Model Phase" <> pItemTmp."HQ Model Phase") or
                       (recItem."Product Length (cm)" <> pItemTmp."Product Length (cm)") or  // 17-08-18 ZY-LD 002
                       (recItem."Lifecycle Phase" <> pItemTmp."Lifecycle Phase") or  // 23-03-20 ZY-LD 026
                       (recItem."Last Buy Date" <> pItemTmp."Last Buy Date") or  // 23-03-20 ZY-LD 026
                       (recItem."Qty. per Color Box" <> pItemTmp."Qty. per Color Box") or  // 11-08-20 ZY-LD 030
                       ((recItem."Cartons Per Pallet" <> pItemTmp."Cartons Per Pallet") and (pItemTmp."Cartons Per Pallet" <> 0) or  // 11-09-20 ZY-LD 031
                       (recItem."SCIP No." <> pItemTmp."SCIP No.") or  // 06-01-21 ZY-LD 035
                       (recItem."Tax Reduction Rate Active" <> pItemTmp."Tax Reduction Rate Active") or  // 03-03-22 ZY-LD 045
                       (recItem."SVHC > 1000 ppm" <> pItemTmp."SVHC > 1000 ppm") or  // 02-11-22 ZY-LD 057
                       (recItem."Product use Battery" <> pItemTmp."Product use Battery") or  // 17-05-23 ZY-LD 064
                       (recItem."WEEE Category" <> pItemTmp."WEEE Category"))  // 17-05-23 ZY-LD 064
                    then begin
                        recItem."Height (cm)" := pItemTmp."Height (cm)";
                        recItem."Width (cm)" := pItemTmp."Width (cm)";
                        recItem."Length (cm)" := pItemTmp."Length (cm)";
                        recItem."Volume (cm3)" := pItemTmp."Volume (cm3)";
                        recItem."Plastic Weight" := pItemTmp."Plastic Weight";
                        recItem."Paper Weight" := pItemTmp."Paper Weight";
                        recItem."Carton Weight" := pItemTmp."Carton Weight";
                        recItem."Height (ctn)" := pItemTmp."Height (ctn)";
                        recItem."Width (ctn)" := pItemTmp."Width (ctn)";
                        recItem."Length (ctn)" := pItemTmp."Length (ctn)";
                        recItem."Volume (ctn)" := pItemTmp."Volume (ctn)";
                        recItem."Number per carton" := pItemTmp."Number per carton";
                        recItem."Gross Weight" := pItemTmp."Gross Weight";
                        recItem."Net Weight" := pItemTmp."Net Weight";
                        recItem."Pallet Length (cm)" := pItemTmp."Pallet Length (cm)";
                        recItem."Pallet Width (cm)" := pItemTmp."Pallet Width (cm)";
                        recItem."Pallet Height (cm)" := pItemTmp."Pallet Height (cm)";
                        recItem."UN Code" := pItemTmp."UN Code";
                        recItem."Battery weight" := pItemTmp."Battery weight";
                        recItem."Carton Weight" := pItemTmp."Carton Weight";
                        recItem."Units per Parcel" := pItemTmp."Units per Parcel";
                        recItem."Qty Per Pallet" := pItemTmp."Qty Per Pallet";
                        recItem."End of Technical Support Date" := pItemTmp."End of Technical Support Date";
                        recItem."End of RMA Date" := pItemTmp."End of RMA Date";
                        recItem."Tax Reduction rate" := pItemTmp."Tax Reduction rate";
                        recItem."Model Description" := pItemTmp."Model Description";
                        recItem.GTIN := pItemTmp.GTIN;
                        recItem.Validate("Category 1 Code", pItemTmp."Category 1 Code");  // 19-10-20 ZY-LD 032
                        recItem.Validate("Category 2 Code", pItemTmp."Category 2 Code");  // 19-10-20 ZY-LD 032
                        recItem.Validate("Category 3 Code", pItemTmp."Category 3 Code");  // 19-10-20 ZY-LD 032
                                                                                          //recItem."Category 4 Code" := pItemTmp."Category 4 Code";  // 23-07-18 ZY-LD 001
                        recItem."Business Center" := pItemTmp."Business Center";
                        recItem.SBU := pItemTmp.SBU;
                        recItem."SBU Company" := pItemTmp."SBU Company";  // 24-10-19 ZY-LD 021
                        recItem."HQ Model Phase" := pItemTmp."HQ Model Phase";
                        recItem."Product Length (cm)" := pItemTmp."Product Length (cm)";  // 17-08-18 ZY-LD 002
                        recItem."Number per parcel" := pItemTmp."Number per parcel";  // 30-08-18 ZY-LD 003
                        recItem."Lifecycle Phase" := pItemTmp."Lifecycle Phase";  // 23-03-20 ZY-LD 026
                        recItem."Last Buy Date" := pItemTmp."Last Buy Date";  // 23-03-20 ZY-LD 026
                        recItem.Validate("Qty. per Color Box", pItemTmp."Qty. per Color Box");  // 11-08-20 ZY-LD 030
                        if pItemTmp."Cartons Per Pallet" <> 0 then  // 11-09-20 ZY-LD 031
                            recItem."Cartons Per Pallet" := pItemTmp."Cartons Per Pallet";  // 11-09-20 ZY-LD 031
                        recItem."SCIP No." := pItemTmp."SCIP No.";  // 06-01-21 ZY-LD 035
                        recItem."Tax Reduction Rate Active" := pItemTmp."Tax Reduction Rate Active";  // 03-03-22 ZY-LD 045
                                                                                                      //>> 17-03-22 ZY-LD 046
                        if recItem."Volume (cm3)" <> 0 then
                            recItem."Unit Volume" := recItem."Volume (cm3)"
                        else
                            if recItem."Volume (ctn)" <> 0 then
                                recItem."Unit Volume" := recItem."Volume (ctn)";
                        //<< 17-03-22 ZY-LD 046
                        recItem."SVHC > 1000 ppm" := pItemTmp."SVHC > 1000 ppm";  // 02-11-22 ZY-LD 057
                        recItem."Product use Battery" := pItemTmp."Product use Battery";  // 17-05-23 ZY-LD 064
                        recItem."WEEE Category" := pItemTmp."WEEE Category";  // 17-05-23 ZY-LD 064
                        recItem.Modify(true);

                        //>> 24-03-23 ZY-LD 062
                        recReworkItem.SetRange("Update PLMS from Item No.", recItem."No.");
                        if recReworkItem.FindSet(true) then
                            repeat
                                recReworkItem.TransferPlmsFields;
                            until recReworkItem.Next() = 0;
                        //<< 24-03-23 ZY-LD 062

                        WebServiceLogEntry."Quantity Modified" += 1;
                    end;
                end else begin  // Insert
                    if ItemNoList <> '' then
                        ItemNoList += '; ';
                    ItemNoList += pItemTmp."No.";
                end;
            until pItemTmp.Next() = 0;

            CloseWebServiceLog;

            if ItemNoList <> '' then begin
                EmailAddMgt.CreateEmailWithBodytext('PLMSUPDATE', ItemNoList, '');
                EmailAddMgt.Send;
            end;

            exit(true);
        end;
    end;*/
    //<< 16-04-24 ZY-LD 071
    procedure Category(var pItemTmp: Record Item temporary; var pHqDimTmp: Record SBU temporary): Boolean
    var
        recItem: Record Item;
        recHqDimension: Record SBU;
        ItemNoList: Text;
        lText001: Label 'Category';
    begin
        // Updates categories into item table
        //>> 13-01-19 ZY-LD 024
        if pItemTmp.FindSet() then begin
            CreateWebServiceLog(lText001, '');

            recItem.LockTable;
            repeat
                if recItem.Get(pItemTmp."No.") then begin
                    if (recItem."Category 1 Code" <> pItemTmp."Category 1 Code") or
                       (recItem."Category 2 Code" <> pItemTmp."Category 2 Code") or
                       (recItem."Category 3 Code" <> pItemTmp."Category 3 Code") or
                       (recItem."Business Center" <> pItemTmp."Business Center") or
                       (recItem.SBU <> pItemTmp.SBU) or
                       (recItem."SBU Company" <> pItemTmp."SBU Company")
                    then begin
                        recItem."Category 1 Code" := pItemTmp."Category 1 Code";
                        recItem."Category 2 Code" := pItemTmp."Category 2 Code";
                        recItem."Category 3 Code" := pItemTmp."Category 3 Code";
                        recItem."Business Center" := pItemTmp."Business Center";
                        recItem.SBU := pItemTmp.SBU;
                        recItem."SBU Company" := pItemTmp."SBU Company";
                        recItem.Modify(true);

                        WebServiceLogEntry."Quantity Modified" += 1;
                    end;
                end;
            until pItemTmp.Next() = 0;

            if pHqDimTmp.FindSet() then
                repeat
                    recHqDimension := pHqDimTmp;
                    if not recHqDimension.Modify() then
                        recHqDimension.Insert();
                until pHqDimTmp.Next() = 0;

            CloseWebServiceLog;

            exit(true);
        end;
        //<< 13-01-19 ZY-LD 024
    end;

    procedure Forecast(pBudgetName: Code[10]; pPeriodStartDate: Date; pPeriodEndDate: Date; pLastUpdate: Boolean; var pItemBudgetEntry: Record "Item Budget Entry" temporary): Boolean
    var
        recItemBudgetName: Record "Item Budget Name";
        recItemBudgetEntry: Record "Item Budget Entry";
        recItemBudgetEntry2: Record "Item Budget Entry";
        EntryNo: Integer;
        QtyImported: Integer;
        QtyDeleted: Integer;
        ImportForecast: Boolean;
        lText001: Label '%1, Deleted: %2, Inserted: %3.<br>';
        lText002: Label 'Budget Name: %1, Start Date: %2, End Date: %3.';
        lText003: Label 'FORECAST';
        lText004: Label 'ORIGINAL';
    begin
        // Import forecast entries into item budget entry
        if pItemBudgetEntry.FindSet() then begin
            CreateWebServiceLog(lText003, StrSubstNo(lText002, pBudgetName, Format(pPeriodStartDate, 0, 3), Format(pPeriodEndDate, 0, 3)));

            //>> 21-08-19 ZY-LD 016
            if pPeriodStartDate <> 0D then begin
                if (Date2dmy(pPeriodStartDate, 2) <> Date2dmy(Today, 2)) or
                    (Date2dmy(pPeriodStartDate, 3) <> Date2dmy(Today, 3))
                then
                    ImportForecast := true;
            end else
                ImportForecast := true;

            if ImportForecast then begin  //<< 21-08-19 ZY-LD 016
                recItemBudgetEntry.LockTable;
                // Delete existing records
                if pPeriodStartDate <> 0D then begin
                    recItemBudgetEntry.SetCurrentkey("Budget Name", Date);
                    recItemBudgetEntry.SetRange("Budget Name", pBudgetName);
                    recItemBudgetEntry.SetRange(Date, pPeriodStartDate, pPeriodEndDate);
                    if recItemBudgetEntry.FindSet(true) then
                        repeat
                            recItemBudgetEntry.Delete();
                            QtyDeleted += 1;
                        until recItemBudgetEntry.Next() = 0;

                    WebServiceLogEntry."Quantity Deleted" += QtyDeleted;
                end;

                // Find last entry no.
                recItemBudgetEntry.SetCurrentkey("Entry No.");
                recItemBudgetEntry.SetRange("Budget Name");
                recItemBudgetEntry.SetRange(Date);
                if recItemBudgetEntry.FindLast() then
                    EntryNo := recItemBudgetEntry."Entry No.";

                repeat
                    EntryNo += 1;

                    recItemBudgetEntry := pItemBudgetEntry;
                    recItemBudgetEntry."Entry No." := EntryNo;
                    recItemBudgetEntry."Budget Name" := pBudgetName;
                    recItemBudgetEntry."Modification Date" := Today;
                    recItemBudgetEntry.Insert(true);

                    //>> 14-02-23 ZY-LD 060
                    /*IF pBudgetName = 'MASTER' THEN BEGIN
                      recItemBudgetEntry2.SetCurrentKey("Budget Name",Date);
                      recItemBudgetEntry2.SETRANGE("Budget Name",lText004);
                      recItemBudgetEntry2.SETRANGE(Date,pPeriodStartDate,pPeriodEndDate);
                      IF NOT recItemBudgetEntry2.FINDFIRST THEN BEGIN
                        recItemBudgetEntry2 := recItemBudgetEntry;
                        recItemBudgetEntry2."Entry No." := 0;
                        recItemBudgetEntry2."Budget Name" := lText004;
                        recItemBudgetEntry2.INSERT(TRUE);
                      END;
                    END;*/
                    //<< 14-02-23 ZY-LD 060

                    QtyImported += 1;
                until pItemBudgetEntry.Next() = 0;
                WebServiceLogEntry."Quantity Inserted" := QtyImported;
            end;

            CloseWebServiceLog;

            //>> 23-02-24 ZY-LD 068
            /*recItemBudgetName.get(pBudgetName);
            if not recItemBudgetName."Block Email on Forecast" then  //<< 23-02-24 ZY-LD 068
                if pLastUpdate and (pBudgetName <> 'PREVIOUS') then begin
                    WebServiceLogEntry.SetRange("Web Service Function", lText003);
                    WebServiceLogEntry.SetFilter("Start Time", '%1..', CreateDatetime(Today, 0T));
                    if WebServiceLogEntry.FindSet() then
                        repeat
                            if StrPos(WebServiceLogEntry.filter, 'PREVIOUS') = 0 then  // 26-02-19 ZY-LD 009
                                SI.SetMergeText(SI.GetMergeText + StrSubstNo(lText001, WebServiceLogEntry.filter, WebServiceLogEntry."Quantity Deleted", WebServiceLogEntry."Quantity Inserted"));
                        until WebServiceLogEntry.Next() = 0;

                    EmailAddMgt.CreateEmailWithBodytext('HQFORECAST', SI.GetMergeText, '');
                    EmailAddMgt.Send;
                    SI.SetMergeText('');
                end;*/

            exit(true);
        end;

    end;

    procedure ContainerDetail(var TempContainerDetail: Record "VCK Shipping Detail" temporary): Boolean
    var
        PurchLine: Record "Purchase Line";
        ShipmentMethod: Record "Shipment Method";
        Item: Record Item;
        TransLine: Record "Transfer Line";
        ContainerDetail: Record "VCK Shipping Detail";
        SrvEnviron: Record "Server Environment";
        Vessel: Record Vessel;
        WhseInboundHeader: Record "Warehouse Inbound Header";
        FileMgt: Codeunit "File Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        ContainerDetailReport: Report "Container Details";
        BatchNo: Code[20];
        SaveBatchNo: Code[20];
        SaveDocumentNo: Code[20];
        ServerFilename: Text;
        ReportFilter: Text;
        HqInvoiceNo: Text;
        ItemMissingText: Text;
        PalletNo: Integer;
        CDT: DateTime;
        PurchOrderLineNo: Integer;
        SaveLineNo: Integer;
        SaveEntryNo: Integer;
        SendEmail: Boolean;
        SendFraightWarning: Boolean;
        SendContainerNoIsMissing: Boolean;
        ContainerNoIsExisting: Boolean;
        ExcelFileNameLbl: Label 'Zyxel Container Details, Batch No. %1.xlsx';
        ContainerDetailsLbl: Label 'CONTAINER DETAILS';
        BacthNoLbl: Label 'Batch No.: %1';
        ItemNotCreatedLbl: Label '"Item No." %1 is not created in our system "%2" %3, "%4" %5.<br>';
        ContainerNoMustOnlyNumbersErr: Label '"Container No." must only contain one number "%1".';
        LinesBothWithWithoutContainerNoErr: Label 'For the shipment "%1" we have received lines both with and without "Container No.".';
    begin
        // Update container details
        TempContainerDetail.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.", "Invoice No.");
        TempContainerDetail.Ascending(false);
        if TempContainerDetail.FindSet() then begin
            BatchNo := NoSeriesMgt.GetNextNo('CDTBATCH', Today(), true);
            CreateWebServiceLog(ContainerDetailsLbl, StrSubstNo(BacthNoLbl, BatchNo));

            CDT := CurrentDatetime();
            ContainerDetail.LockTable();

            // Container Details is always sent in batches by invoice no. If we receive an update, we archive the old lines before inserting the new lines.
            ContainerDetail.SetRange("Invoice No.", TempContainerDetail."Invoice No.");
            ContainerDetail.SetRange(Archive, false);
            if ContainerDetail.FindFirst() then begin
                WhseInboundHeader.SetRange("Invoice No.", TempContainerDetail."Invoice No.");
                if WhseInboundHeader.FindSet(true) then
                    repeat
                        WhseInboundHeader.Delete(true);
                    until WhseInboundHeader.Next() = 0;

                ContainerDetail.ModifyAll(Archive, true);
            end;

            repeat
                // Validate Container No.
                if (TempContainerDetail."Container No." <> '') and ((StrPos(TempContainerDetail."Container No.", ',') <> 0) or (StrPos(TempContainerDetail."Container No.", ';') <> 0)) then
                    Error(ContainerNoMustOnlyNumbersErr, TempContainerDetail."Container No.");

                // Locate correct Purchase Order Line No. if we receive zero
                PurchOrderLineNo := TempContainerDetail."Purchase Order Line No.";
                if (PurchOrderLineNo = 0) or
                   ((TempContainerDetail."Order Type" = TempContainerDetail."Order Type"::"Purchase Order") and
                   (not PurchLine.Get(PurchLine."document type"::Order, TempContainerDetail."Purchase Order No.", TempContainerDetail."Purchase Order Line No.")))
                then begin
                    PurchOrderLineNo := GetPurchaseOrderLineNo(TempContainerDetail."Purchase Order No.", TempContainerDetail."Item No.", TempContainerDetail.Quantity);
                    TempContainerDetail."P.O. Line No. Found by Us" := PurchOrderLineNo <> 0;
                end;

                if TempContainerDetail."Invoice No." <> '' then
                    if StrPos(HqInvoiceNo, TempContainerDetail."Invoice No.") = 0 then
                        if HqInvoiceNo = '' then
                            HqInvoiceNo := TempContainerDetail."Invoice No."
                        else
                            HqInvoiceNo := HqInvoiceNo + ', ' + TempContainerDetail."Invoice No.";

                ContainerDetail := TempContainerDetail;
                ContainerDetail."Entry No." := 0;
                ContainerDetail."Purchase Order Line No." := PurchOrderLineNo;
                ContainerDetail."Batch No." := BatchNo;
                if PurchLine.Get(PurchLine."Document Type"::Order, ContainerDetail."Purchase Order No.", ContainerDetail."Purchase Order Line No.") then begin
                    UpdatePurchaseOrderLine(PurchLine, TempContainerDetail);

                    ContainerDetail."Expected Receipt Date" := PurchLine."Expected Receipt Date";
                    if PurchLine.OriginalLocationCode <> '' then
                        ContainerDetail.Location := PurchLine.OriginalLocationCode
                    else
                        ContainerDetail.Location := PurchLine."Location Code";
                end;

                if ContainerDetail."Main Warehouse" then begin
                    ContainerDetail.Location := ItemLogisticEvent.GetMainWarehouseLocation();

                    if ContainerDetail."Shipping Method" = 'SEA' then
                        if ContainerDetail."Container No." = '' then
                            SendContainerNoIsMissing := true
                        else
                            ContainerNoIsExisting := true;

                    if ContainerNoIsExisting and SendContainerNoIsMissing then
                        Error(LinesBothWithWithoutContainerNoErr, TempContainerDetail."Invoice No.");
                end;

                ContainerDetail."Data Received Created" := CDT;
                ContainerDetail.Validate("Original ETA Date", ContainerDetail.ETA);
                ContainerDetail.Insert(true);

                WebServiceLogEntry."Quantity Inserted" += 1;

                if TempContainerDetail."Vessel Code" <> Vessel.Code then
                    if not Vessel.Get(TempContainerDetail."Vessel Code") then begin
                        Clear(Vessel);
                        Vessel.Init();
                        Vessel.Code := TempContainerDetail."Vessel Code";
                        Vessel.Description := TempContainerDetail."Vessel Code";
                        Vessel.Insert();
                    end;

                if ContainerDetail."Purchase Order Line No." = 0 then
                    SendEmail := true;

                if not SendFraightWarning then
                    if ShipmentMethod.Get(ContainerDetail."Shipping Method") and (Format(ShipmentMethod."Send Warning for Freight Time") <> '') then begin
                        if ContainerDetail.ETA - ContainerDetail.ETD < ShipmentMethod."Send Warning for Freight Time" then begin
                            SI.SetMergefield(102, Format(ShipmentMethod."Send Warning for Freight Time"));
                            SI.SetMergefield(103, Format(ContainerDetail.ETA));
                            SI.SetMergefield(104, Format(ContainerDetail.ETD));
                            SI.SetMergefield(105, Format(ContainerDetail.ETA - ContainerDetail.ETD));
                            SendFraightWarning := true;
                        end;
                    end;

                if not Item.Get(TempContainerDetail."Item No.") then begin
                    ItemMissingText +=
                      StrSubstNo(ItemNotCreatedLbl,
                        TempContainerDetail."Item No.",
                        TempContainerDetail.FieldCaption("Purchase Order No."), TempContainerDetail."Purchase Order No.",
                        TempContainerDetail.FieldCaption("Purchase Order Line No."), TempContainerDetail."Purchase Order Line No.");
                end;

                if ContainerDetail."Expected Receipt Date" <> 0D then begin
                    TransLine.SetRange(PurchaseOrderNo, ContainerDetail."Purchase Order No.");
                    TransLine.SetRange(PurchaseOrderLineNo, ContainerDetail."Purchase Order Line No.");
                    //>> 26-09-24 ZY-LD 073
                    //TransLine.ModifyAll(ExpectedReceiptDate, ContainerDetail."Expected Receipt Date");
                    if TransLine.FindSet() then
                        repeat
                            TransLine.ExpectedReceiptDate := ContainerDetail."Expected Receipt Date";
                            If not TransLine.Modify() then;
                        until TransLine.next() = 0;
                    //<< 26-09-24 ZY-LD 073
                end;
            until TempContainerDetail.Next() = 0;

            CloseWebServiceLog;

            if SrvEnviron.ProductionEnvironment then begin
                // Send an e-mail if purchase order line no. are blank.
                if SendEmail then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateSimpleEmail('HQCONTDETE', '', '');
                    EmailAddMgt.Send;
                end;

                // Send e-mail with attached document to VCK
                Commit();

                ServerFilename := FileMgt.ServerTempFileName('xlsx');
                ReportFilter := StrSubstNo('*%1*', BatchNo);
                ContainerDetail.Reset();
                ContainerDetail.SetFilter("Batch No.", ReportFilter);
                ContainerDetail.SetRange("Data Received Created", CDT);
                ContainerDetailReport.SetTableView(ContainerDetail);
                ContainerDetailReport.SaveAsExcel(ServerFilename);

                Clear(EmailAddMgt);
                SI.SetMergefield(100, BatchNo);
                SI.SetMergefield(101, HqInvoiceNo);
                EmailAddMgt.CreateEmailWithAttachment('HQCONTDET', '', '', ServerFilename, StrSubstNo(ExcelFileNameLbl, BatchNo), false);
                EmailAddMgt.Send();

                if SendFraightWarning then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateSimpleEmail('LOGFRAWARN', '', '');
                    EmailAddMgt.Send();
                end;

                if ItemMissingText <> '' then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateEmailWithBodytext2('LOGITEMMIS', '', ItemMissingText, '');
                    EmailAddMgt.Send();
                end;

                if SendContainerNoIsMissing then begin
                    Clear(EmailAddMgt);
                    SI.SetMergefield(100, TempContainerDetail."Invoice No.");
                    EmailAddMgt.CreateSimpleEmail('HQNOCONTNO', '', '');
                    EmailAddMgt.Send();
                end;
            end;

            exit(true);
        end;
    end;

    procedure ContainerDetail_OLD(var pContainerDetail: Record "VCK Shipping Detail" temporary): Boolean
    var
        recContainerDetail: Record "VCK Shipping Detail";
        recPurchLine: Record "Purchase Line";
        recServEnviron: Record "Server Environment";
        recShipMethod: Record "Shipment Method";
        recItem: Record Item;
        recVessel: Record Vessel;
        PalletNo: Integer;
        CDT: DateTime;
        SendEmail: Boolean;
        repContainerDetail: Report "Container Details";
        FileMgt: Codeunit "File Management";
        ServerFilename: Text;
        lText001: Label 'Zyxel Container Details, Batch No. %1.xlsx';
        lText002: Label 'CONTAINER DETAILS';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        BatchNo: Code[20];
        lText003: Label 'Batch No.: %1';
        ReportFilter: Text;
        HqInvoiceNo: Text;
        ItemMissingText: Text;
        PurchOrderLineNo: Integer;
        SaveBatchNo: Code[20];
        SaveDocumentNo: Code[20];
        SaveLineNo: Integer;
        SaveEntryNo: Integer;
        SendFraightWarning: Boolean;
        lText004: Label '"Item No." %1 is not created in our system "%2" %3, "%4" %5.<br>';
        lText006: Label '"Container No." must only contain one number "%1".';
        SendContainerNoIsMissing: Boolean;
    begin
        // Update container details
        pContainerDetail.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.", "Invoice No.");  // 19-03-19 ZY-LD 014
        pContainerDetail.Ascending(false);  // 19-03-19 ZY-LD 014
        if pContainerDetail.FindSet() then begin
            BatchNo := NoSeriesMgt.GetNextNo('CDTBATCH', Today, true);
            CreateWebServiceLog(lText002, StrSubstNo(lText003, BatchNo));

            CDT := CurrentDatetime;
            recContainerDetail.LockTable;
            repeat
                //>> 10-05-22 ZY-LD 048
                if (pContainerDetail."Container No." <> '') and
                   ((StrPos(pContainerDetail."Container No.", ',') <> 0) or
                    (StrPos(pContainerDetail."Container No.", ';') <> 0))
                then
                    Error(lText006, pContainerDetail."Container No.");
                //<< 10-05-22 ZY-LD 048
                //>> 19-11-18 ZY-LD 004
                PurchOrderLineNo := pContainerDetail."Purchase Order Line No.";
                if (PurchOrderLineNo = 0) or
                   ((pContainerDetail."Order Type" = pContainerDetail."order type"::"Purchase Order") and  // 03-07-20 ZY-LD 029
                    (not recPurchLine.Get(recPurchLine."document type"::Order, pContainerDetail."Purchase Order No.", pContainerDetail."Purchase Order Line No.")))  // 03-07-20 ZY-LD 029
                then begin
                    PurchOrderLineNo := GetPurchaseOrderLineNo(pContainerDetail."Purchase Order No.", pContainerDetail."Item No.", pContainerDetail.Quantity);
                    pContainerDetail."P.O. Line No. Found by Us" := PurchOrderLineNo <> 0;
                end;
                //<< 19-11-18 ZY-LD 004
                //>> 11-02-19 ZY-LD 008
                if pContainerDetail."Invoice No." <> '' then
                    if StrPos(HqInvoiceNo, pContainerDetail."Invoice No.") = 0 then
                        if HqInvoiceNo = '' then
                            HqInvoiceNo := pContainerDetail."Invoice No."
                        else
                            HqInvoiceNo := HqInvoiceNo + ', ' + pContainerDetail."Invoice No.";
                //<< 11-02-19 ZY-LD 008

                recContainerDetail.Reset();  // 22-10-20 ZY-LD 034
                recContainerDetail.SetRange("Container No.", pContainerDetail."Container No.");
                recContainerDetail.SetRange("Invoice No.", pContainerDetail."Invoice No.");
                recContainerDetail.SetRange("Purchase Order No.", pContainerDetail."Purchase Order No.");
                recContainerDetail.SetRange("Purchase Order Line No.", PurchOrderLineNo);  // 19-11-18 ZY-LD 004
                recContainerDetail.SetRange("Item No.", pContainerDetail."Item No.");
                recContainerDetail.SetRange("Pallet No.", pContainerDetail."Pallet No.");
                recContainerDetail.SetRange("Shipping Method", pContainerDetail."Shipping Method");
                recContainerDetail.SetRange("Order No.", pContainerDetail."Order No.");
                recContainerDetail.SetRange(Archive, false);
                if recContainerDetail.FindFirst() then begin
                    //>> 22-10-20 ZY-LD 034
                    if BatchNo = recContainerDetail."Batch No." then begin
                        recContainerDetail.Quantity := recContainerDetail.Quantity + pContainerDetail.Quantity;
                        recContainerDetail.Modify();
                    end else begin
                        recContainerDetail.SetRange("Batch No.", BatchNo);
                        if recContainerDetail.FindFirst() then begin
                            recContainerDetail.Quantity := recContainerDetail.Quantity + pContainerDetail.Quantity;
                            recContainerDetail.Modify();
                        end else begin  //<< 22-10-20 ZY-LD 034
                            SaveBatchNo := recContainerDetail."Batch No.";  // 15-03-19 ZY-LD 013
                            SaveDocumentNo := recContainerDetail."Document No.";  // 23-04-20 ZY-LD 027
                            SaveLineNo := recContainerDetail."Line No.";  // 23-04-20 ZY-LD 027
                            SaveEntryNo := recContainerDetail."Entry No.";  // 25-01-22 ZY-LD 043
                            recContainerDetail := pContainerDetail;
                            recContainerDetail."Document No." := SaveDocumentNo;  // 23-04-20 ZY-LD 027
                            recContainerDetail."Line No." := SaveLineNo;  // 23-04-20 ZY-LD 027
                            recContainerDetail."Entry No." := SaveEntryNo;  // 25-01-22 ZY-LD 043
                            recContainerDetail."Purchase Order Line No." := PurchOrderLineNo;  // 19-11-18 ZY-LD 004
                            recContainerDetail."Batch No." := BatchNo;  // 15-03-19 ZY-LD 013
                            recContainerDetail."Previous Batch No." := DelChr(recContainerDetail."Previous Batch No." + '; ' + SaveBatchNo, '<', '; ');  // 15-03-19 ZY-LD 013
                            if recPurchLine.Get(recPurchLine."document type"::Order, recContainerDetail."Purchase Order No.", recContainerDetail."Purchase Order Line No.") then begin
                                UpdatePurchaseOrderLine(recPurchLine, pContainerDetail);

                                recContainerDetail."Expected Receipt Date" := recPurchLine."Expected Receipt Date";
                                recContainerDetail.Location := recPurchLine."Location Code";
                            end;
                            //>> 20-01-21 ZY-LD 042
                            if recContainerDetail."Main Warehouse" then
                                recContainerDetail.Location := ItemLogisticEvent.GetMainWarehouseLocation;
                            //<< 20-01-21 ZY-LD 042
                            recContainerDetail."Data Received Updated" := CDT;
                            recContainerDetail.Modify();
                            WebServiceLogEntry."Quantity Modified" += 1;

                            if recContainerDetail."Purchase Order Line No." = 0 then
                                SendEmail := true;
                        end;
                        recContainerDetail.SetRange("Batch No.");  // 22-10-20 ZY-LD 034
                    end;
                end else begin
                    recContainerDetail.SetRange(Archive, true);
                    if not recContainerDetail.FindFirst() then begin
                        recContainerDetail := pContainerDetail;
                        recContainerDetail."Entry No." := 0;  // 15-11-21 ZY-LD 040
                        recContainerDetail."Purchase Order Line No." := PurchOrderLineNo;  // 19-11-18 ZY-LD 004
                        recContainerDetail."Batch No." := BatchNo;
                        if recPurchLine.Get(recPurchLine."document type"::Order, recContainerDetail."Purchase Order No.", recContainerDetail."Purchase Order Line No.") then begin
                            UpdatePurchaseOrderLine(recPurchLine, pContainerDetail);

                            recContainerDetail."Expected Receipt Date" := recPurchLine."Expected Receipt Date";
                            recContainerDetail.Location := recPurchLine."Location Code";
                        end;
                        //>> 20-01-21 ZY-LD 042
                        if recContainerDetail."Main Warehouse" then begin
                            recContainerDetail.Location := ItemLogisticEvent.GetMainWarehouseLocation;

                            if (recContainerDetail."Shipping Method" = 'SEA') and (recContainerDetail."Container No." = '') then  // 18-05-22 ZY-LD 042  Moved to this part of the code
                                SendContainerNoIsMissing := true;  // 23-05-22 ZY-LD 050
                        end;
                        //<< 20-01-21 ZY-LD 042

                        //<< 20-01-21 ZY-LD 042
                        recContainerDetail."Data Received Created" := CDT;
                        recContainerDetail.Validate("Original ETA Date", recContainerDetail.ETA);  // 24-11-21 ZY-LD 041
                        recContainerDetail.Insert(true);  // 15-11-21 ZY-LD 040 - TRUE is added.
                        WebServiceLogEntry."Quantity Inserted" += 1;

                        //>> 19-05-22 ZY-LD 049
                        if pContainerDetail."Vessel Code" <> recVessel.Code then
                            if not recVessel.Get(pContainerDetail."Vessel Code") then begin
                                Clear(recVessel);
                                recVessel.Init();
                                recVessel.Code := pContainerDetail."Vessel Code";
                                recVessel.Description := pContainerDetail."Vessel Code";
                                recVessel.Insert();
                            end;
                        //<< 19-05-22 ZY-LD 049

                        if recContainerDetail."Purchase Order Line No." = 0 then
                            SendEmail := true;

                        //>> 25-11-19 ZY-LD 022
                        if not SendFraightWarning then
                            if recShipMethod.Get(recContainerDetail."Shipping Method") and (Format(recShipMethod."Send Warning for Freight Time") <> '') then begin
                                if recContainerDetail.ETA - recContainerDetail.ETD < recShipMethod."Send Warning for Freight Time" then begin
                                    SI.SetMergefield(102, Format(recShipMethod."Send Warning for Freight Time"));
                                    SI.SetMergefield(103, Format(recContainerDetail.ETA));
                                    SI.SetMergefield(104, Format(recContainerDetail.ETD));
                                    SI.SetMergefield(105, Format(recContainerDetail.ETA - recContainerDetail.ETD));
                                    SendFraightWarning := true;
                                end;
                            end;
                        //<< 25-11-19 ZY-LD 022
                    end;
                end;

                //>> 14-10-21 ZY-LD 039
                if not recItem.Get(pContainerDetail."Item No.") then begin
                    ItemMissingText +=
                      StrSubstNo(lText004,
                        pContainerDetail."Item No.",
                        pContainerDetail.FieldCaption("Purchase Order No."), pContainerDetail."Purchase Order No.",
                        pContainerDetail.FieldCaption("Purchase Order Line No."), pContainerDetail."Purchase Order Line No.");
                end;
            //<< 14-10-21 ZY-LD 039

            //IF recContainerDetail."Purchase Order Line No." = 0 THEN
            //  SendEmail := TRUE;
            until pContainerDetail.Next() = 0;
            CloseWebServiceLog;

            if recServEnviron.ProductionEnvironment then begin
                // Send an e-mail if purchase order line no. are blank.
                if SendEmail then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateSimpleEmail('HQCONTDETE', '', '');
                    EmailAddMgt.Send;
                end;

                // Send e-mail with attached document to VCK
                Commit();
                ServerFilename := FileMgt.ServerTempFileName('xlsx');
                ReportFilter := StrSubstNo('*%1*', BatchNo);
                recContainerDetail.Reset();
                recContainerDetail.SetFilter("Batch No.", ReportFilter);
                recContainerDetail.SetRange("Data Received Created", CDT);
                repContainerDetail.SetTableView(recContainerDetail);
                repContainerDetail.SaveAsExcel(ServerFilename);
                Clear(EmailAddMgt);
                SI.SetMergefield(100, BatchNo);
                SI.SetMergefield(101, HqInvoiceNo);  // 11-02-19 ZY-LD 008
                EmailAddMgt.CreateEmailWithAttachment('HQCONTDET', '', '', ServerFilename, StrSubstNo(lText001, BatchNo), false);
                EmailAddMgt.Send;

                //>> 25-11-19 ZY-LD 022
                if SendFraightWarning then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateSimpleEmail('LOGFRAWARN', '', '');
                    EmailAddMgt.Send;
                end;
                //<< 25-11-19 ZY-LD 022

                //>> 14-10-21 ZY-LD 039
                if ItemMissingText <> '' then begin
                    Clear(EmailAddMgt);
                    EmailAddMgt.CreateEmailWithBodytext2('LOGITEMMIS', '', ItemMissingText, '');
                    EmailAddMgt.Send;
                end;
                //<< 14-10-21 ZY-LD 039

                //>> 23-05-22 ZY-LD 050
                if SendContainerNoIsMissing then begin
                    Clear(EmailAddMgt);
                    SI.SetMergefield(100, BatchNo);
                    EmailAddMgt.CreateSimpleEmail('HQNOCONTNO', '', '');
                    EmailAddMgt.Send;
                end;
                //<< 23-05-22 ZY-LD 050
            end;

            exit(true);
        end;
    end;

    local procedure UpdatePurchaseOrderLine(var PurchaseLine: Record "Purchase Line"; ContainerDetail: Record "VCK Shipping Detail")
    var
        InvtSetup: Record "Inventory Setup";
        ContainerDist: Record "Container Distances";
        PurchHeader: Record "Purchase Header";
        UnknownInCodeErr: Label '"%1" %2 is unknown in the code.';
    begin
        begin
            PurchaseLine."Qty. to Receive" := PurchaseLine."Qty. to Receive" + ContainerDetail.Quantity;
            if PurchaseLine."Qty. to Receive" + PurchaseLine."Quantity Received" <> PurchaseLine.Quantity then
                PurchaseLine."Vendor Status" := PurchaseLine."Vendor Status"::"Partialy Dispatched"
            else
                PurchaseLine."Vendor Status" := PurchaseLine."Vendor Status"::Dispatched;

            PurchaseLine."Actual shipment date" := ContainerDetail.ETD;
            PurchaseLine."Promised Receipt Date" := ContainerDetail.ETA;
            PurchaseLine."Planned Receipt Date" := ContainerDetail.ETA;
            PurchaseLine."Expected Receipt Date" := ContainerDetail.ETA;

            PurchHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            ContainerDist.SetFilter("Customer No.", '%1|%2', PurchHeader."Sell-to Customer No.", '');
            ContainerDist.SetFilter("Ship-to Code", '%1|%2', PurchHeader."Ship-to Code", '');
            ContainerDist.FindLast();
            case ContainerDetail."Shipping Method" of
                'AIR':
                    PurchaseLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date" + ContainerDist."Air Days";
                'RAIL':
                    PurchaseLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date" + ContainerDist."Rail Days";
                'SEA':
                    PurchaseLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date" + ContainerDist."Sea Days";
                else
                    if ContainerDist."Other Days" > 0 then
                        PurchaseLine."Expected Receipt Date" := PurchaseLine."Expected Receipt Date" + ContainerDist."Other Days"
                    else
                        Error(UnknownInCodeErr, ContainerDetail.FieldCaption("Shipping Method"), ContainerDetail."Shipping Method");
            end;

            PurchaseLine."Transport Method" := ContainerDetail."Shipping Method";

            PurchaseLine.Modify();
        end;
    end;

    procedure HQSalesDocument(var pHQSalesHead: Record "HQ Invoice Header" temporary; var pHQSalesLine: Record "HQ Invoice Line" temporary): Boolean
    var
        lText001: Label 'HQ Sales Document';
        recHQSalesHead: Record "HQ Invoice Header";
        recHQSalesLine: Record "HQ Invoice Line";
        recPurchHead: Record "Purchase Header";
        BodyText: Text;
    begin
        CreateWebServiceLog(lText001, '');
        if pHQSalesHead.FindSet() then
            repeat
                recHQSalesHead := pHQSalesHead;
                recHQSalesHead.Insert();

                pHQSalesLine.SetRange("Document Type", pHQSalesHead."Document Type");
                pHQSalesLine.SetRange("Document No.", pHQSalesHead."No.");
                if pHQSalesLine.FindSet() then begin
                    BodyText := '';  // 25-09-19 ZY-LD 018
                    if recPurchHead.Get(recPurchHead."document type"::Order, pHQSalesLine."Purchase Order No.") then
                        if recPurchHead.IsEICard then begin
                            recHQSalesHead.Type := recHQSalesHead.Type::EiCard;
                            recHQSalesHead.Modify();
                        end;

                    repeat
                        recHQSalesLine := pHQSalesLine;
                        recHQSalesLine.Validate("Total Price");
                        //>> 17-02-21 ZY-LD 036
                        if recHQSalesLine."Purchase Order Line No." = 0 then
                            recHQSalesLine."Purchase Order Line No." := GetPurchOrdLineNoEiCard(recHQSalesLine."Purchase Order No.", recHQSalesLine."No.", recHQSalesLine.Quantity);
                        /*IF recHQSalesLine."Purchase Order Line No." = 0 THEN
                          recHQSalesLine."Purchase Order Line No." := GetPurchOrdLineNo(recHQSalesLine."Purchase Order No.",recHQSalesLine."No.",recHQSalesLine.Quantity);*/
                        //<< 17-02-21 ZY-LD 036
                        recHQSalesLine.Insert();

                        //>> 25-09-19 ZY-LD 018
                        if recHQSalesLine."Overhead Price" < 0 then begin
                            BodyText +=
                              StrSubstNo('Item No.: %1, %2: %3, %4: %5, %6: %7, %8: %9<br>',
                                recHQSalesLine."No.",
                                recHQSalesLine.FieldCaption("Document No."), recHQSalesLine."Document No.",
                                recHQSalesLine.FieldCaption("Unit Price"), recHQSalesLine."Unit Price",
                                recHQSalesLine.FieldCaption("Last Bill of Material Price"), recHQSalesLine."Last Bill of Material Price",
                                recHQSalesLine.FieldCaption("Overhead Price"), recHQSalesLine."Overhead Price");
                        end;
                    //<< 25-09-19 ZY-LD 018
                    until pHQSalesLine.Next() = 0;
                end;

                //>> 25-09-19 ZY-LD 018
                if BodyText <> '' then begin
                    //>> 12-08-22 ZY-LD 055
                    /*SI.SetMergefield(100,recHQSalesHead."No.");
                    //SI.SetMergefield(101,BodyText);  // 30-12-19 ZY-LD Moved to next line.
                    EmailAddMgt.CreateEmailWithBodytext2('HQOVERHEAD','',BodyText,'');
                    EmailAddMgt.Send;*/
                    //<< 12-08-22 ZY-LD 055
                end;
                //<< 25-09-19 ZY-LD 018

                WebServiceLogEntry."Quantity Inserted" += 1;
            until pHQSalesHead.Next() = 0;

        CloseWebServiceLog;

        exit(true);
    end;

    procedure UpdateEMEAPurchaseOrder(var pPurchHead: Record "Purchase Header" temporary; var pPurchLine: Record "Purchase Line"): Boolean
    var
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        MailText: Text;
        lText001: Label 'Purchase Order No. %1<br>';
        lText002: Label 'Deleted lines:<br>';
        lText003: Label 'Line No. %1; Item No. %2, Quantity %3; Unit Price %4<br>';
        lText004: Label '<br>Inserted lines:<br>';
        lText005: Label 'Purchase Order: "%1" was not found.';
    begin
        // IF pPurchHead.FINDSET THEN BEGIN
        //  REPEAT
        //    SI.SetMergefield(100,pPurchHead."No.");
        //
        //    IF recPurchHead.GET(recPurchHead."Document Type"::Order,pPurchHead."No.") THEN BEGIN
        //      MailText := STRSUBSTNO(lText001,recPurchHead."No.");
        //      MailText += lText002;
        //
        //      recPurchHist.INIT;
        //      recPurchHist.VALIDATE("Purchase Order No.",recPurchHead."No.");
        //      recPurchHist.INSERT(TRUE);
        //      UpdatePurchaseLineHistory(recPurchHead."No.",recPurchHist."Entry No.",1,MailText);
        //
        //      recPurchLine.SETRANGE("Document Type",recPurchHead."Document Type");
        //      recPurchLine.SETRANGE("Document No.",recPurchHead."No.");
        //      recPurchLine.SETRANGE("Qty. Rcd. Not Invoiced",0);
        //      recPurchLine.SETRANGE("Qty. Invoiced (Base)",0);
        //      IF recPurchLine.FINDSET(TRUE) THEN
        //        REPEAT
        //          recPurchLine.DELETE(TRUE);
        //        UNTIL recPurchLine.Next() = 0;
        //
        //      MailText += lText004;
        //      recPurchLine.RESET;
        //      pPurchLine.SETRANGE("Document No.",recPurchHead."No.");
        //      IF pPurchLine.FINDSET THEN
        //        REPEAT
        //          recPurchLine.VALIDATE("Document Type",recPurchLine."Document Type"::Order);
        //          recPurchLine.VALIDATE("Document No.",recPurchHead."No.");
        //          recPurchLine.VALIDATE("Line No.",pPurchLine."Line No.");
        //          recPurchLine.VALIDATE(Type,recPurchLine.Type::Item);
        //          recPurchLine.VALIDATE("No.",pPurchLine."No.");
        //          recPurchLine.VALIDATE(Quantity,pPurchLine.Quantity);
        //          recPurchLine.VALIDATE("Direct Unit Cost",pPurchLine."Unit Cost");
        //          recPurchLine.INSERT;
        //        UNTIL pPurchLine.Next() = 0;
        //      UpdatePurchaseLineHistory(recPurchHead."No.",recPurchHist."Entry No.",2,MailText);  // History update has moved
        //
        //      EmailAddMgt.CreateEmailWithBodytext('HQPURCHUPD',MailText,'');
        //      EmailAddMgt.Send;
        //    END ELSE BEGIN
        //      EmailAddMgt.CreateEmailWithBodytext('HQPURCHUPD',STRSUBSTNO(lText005,pPurchHead."No."),'');
        //      EmailAddMgt.Send;
        //      ERROR(STRSUBSTNO(lText005,pPurchHead."No."));
        //    END;
        //  UNTIL pPurchHead.Next() = 0;
        //
        //  EXIT(TRUE);
        // END;
    end;

    procedure UnshippedPurchaseOrder(var TempUnshipPurchOrder: Record "Unshipped Purchase Order"; VendorType: Enum VendorType): Boolean
    var
        recUnshipPurchder: Record "Unshipped Purchase Order";
        recPurchLine: Record "Purchase Line";
        recAutoSetup: Record "Automation Setup";
        recWhseSetup: Record "Warehouse Setup";
        SendEmail: Boolean;
        lText001: Label 'Purchase Order No. must not be blank. "%1".';
        lText002: Label 'UNSHIPPEDQUANTITY';
        lText003: Label 'EMPTY';
    begin
        recAutoSetup.GET;  // 03-01-19 ZY-LD 023
        recWhseSetup.GET;
        TempUnshipPurchOrder.SETCURRENTKEY("Purchase Order No.", "Purchase Order Line No.");  // 19-03-19 ZY-LD 014
        TempUnshipPurchOrder.ASCENDING(FALSE);  // 19-03-19 ZY-LD 014
        //>> 15-01-24 ZY-LD 067
        CreateWebServiceLog(lText002, '');
        recUnshipPurchder.SETRANGE("Vendor Type", VendorType);  // 28-06-19 ZY-LD 015
        WebServiceLogEntry.Filter := recUnshipPurchder.GETFILTERS;  // 28-06-19 ZY-LD 015
        WebServiceLogEntry."Quantity Deleted" := recUnshipPurchder.COUNT;

        recUnshipPurchder.DELETEALL;
        //<< 15-01-24 ZY-LD 067

        IF TempUnshipPurchOrder.FINDSET THEN BEGIN
            //>> 15-01-24 ZY-LD 067
            /*CreateWebServiceLog(lText002, '');
            recUnshipPurchder.SETRANGE("Vendor Type", VendorType);  // 28-06-19 ZY-LD 015
            WebServiceLogEntry.Filter := recUnshipPurchder.GETFILTERS;  // 28-06-19 ZY-LD 015
            WebServiceLogEntry."Quantity Deleted" := recUnshipPurchder.COUNT;

            recUnshipPurchder.DELETEALL;*/
            //<< 15-01-24 ZY-LD 067
            IF (TempUnshipPurchOrder."Purchase Order No." <> lText003) THEN  // 16-01-23 ZY-LD 059
                REPEAT
                    IF TempUnshipPurchOrder."Purchase Order No." = '' THEN
                        ERROR(lText001, TempUnshipPurchOrder);

                    recUnshipPurchder := TempUnshipPurchOrder;
                    recUnshipPurchder."Sales Order Line ID" := StrSubstNo('%1_%2', recUnshipPurchder."Sales Order Line ID", VendorType);
                    //>> 19-11-18 ZY-LD 004
                    IF recUnshipPurchder."Purchase Order Line No." = 0 THEN
                        recUnshipPurchder."Purchase Order Line No." := GetPurchaseOrderLineNo(recUnshipPurchder."Purchase Order No.", recUnshipPurchder."Item No.", recUnshipPurchder.Quantity);
                    //<< 19-11-18 ZY-LD 004
                    //recUnshipPurchder."Last Update Date" := TODAY;
                    recUnshipPurchder."Vendor Type" := VendorType;  // 28-06-19 ZY-LD 015
                    if recUnshipPurchder."ETA Date" = 0D then
                        recUnshipPurchder."ETA Date" := 20991231D;
                    recUnshipPurchder.INSERT;

                    //>> 04-05-22 ZY-LD 047
                    IF FORMAT(recWhseSetup."Expected Shipment Period") <> '' THEN BEGIN
                        IF recUnshipPurchder."Shipping Order ETD Date" <> 0D THEN
                            recUnshipPurchder."Expected receipt date" := CALCDATE(recWhseSetup."Expected Shipment Period", recUnshipPurchder."Shipping Order ETD Date")
                        ELSE
                            IF recUnshipPurchder."ETD Date" <> 0D THEN
                                recUnshipPurchder."Expected receipt date" := CALCDATE(recWhseSetup."Expected Shipment Period", recUnshipPurchder."ETD Date")
                            ELSE
                                recUnshipPurchder."Expected receipt date" := 0D;
                        recUnshipPurchder.MODIFY(TRUE);
                    END;
                    //<< 04-05-22 ZY-LD 047

                    IF recAutoSetup."Upd. Unit Price on Purch.Order" THEN  // 03-01-19 ZY-LD 023
                                                                           //>> 31-01-19 ZY-LD 006
                        IF recUnshipPurchder."Unit Price" > 0 THEN
                            IF recPurchLine.GET(recPurchLine."Document Type"::Order, recUnshipPurchder."Purchase Order No.", recUnshipPurchder."Purchase Order Line No.") THEN
                                IF (recPurchLine.Type = recPurchLine.Type::Item) AND (recPurchLine."Direct Unit Cost" <> recUnshipPurchder."Unit Price") THEN BEGIN
                                    recPurchLine.SuspendStatusCheck(TRUE);
                                    recPurchLine.VALIDATE("Direct Unit Cost", recUnshipPurchder."Unit Price");
                                    recPurchLine.MODIFY;
                                    recPurchLine.SuspendStatusCheck(FALSE);
                                END;
                    //<< 31-01-19 ZY-LD 006

                    //>> 02-04-24 ZY-LD 070
                    if (recUnshipPurchder."Purchase Order No." <> recPurchLine."Document No.") OR (recUnshipPurchder."Purchase Order Line No." <> recPurchLine."Line No.") then
                        IF recPurchLine.GET(recPurchLine."Document Type"::Order, recUnshipPurchder."Purchase Order No.", recUnshipPurchder."Purchase Order Line No.") THEN begin
                            recUnshipPurchder."Location Code" := recPurchLine."Location Code";
                            recUnshipPurchder.Modify(true);
                        end;
                    //<< 02-04-24 ZY-LD 070

                    //>> 13-03-19 Zy-LD 011
                    IF recUnshipPurchder."Purchase Order Line No." = 0 THEN BEGIN
                        //>> 23-08-19 ZY-LD 017
                        //SendEmail := TRUE;
                        IF ServerEnvironment.ProductionEnvironment THEN BEGIN
                            Clear(EmailAddMgt);
                            Clear(SI);
                            SI.SetMergefield(100, TempUnshipPurchOrder."Purchase Order No.");  // 23-08-19
                            SI.SetMergefield(101, FORMAT(VendorType));  // 23-08-19 ZY-LD 017
                            SI.SetMergefield(102, FORMAT(TempUnshipPurchOrder.Quantity));
                            SI.SetMergefield(103, TempUnshipPurchOrder."Item No.");
                            EmailAddMgt.CreateSimpleEmail('HQUNSHQTY', '', '');
                            EmailAddMgt.Send;
                        END;
                        //<< 23-08-19 ZY-LD 017
                    END;
                    //<< 13-03-19 Zy-LD 011

                    WebServiceLogEntry."Quantity Inserted" += 1;
                UNTIL TempUnshipPurchOrder.NEXT = 0;
            CloseWebServiceLog;

            //EXIT(TRUE);  // 15-01-24 ZY-LD 067
        END;
        EXIT(TRUE);  // 15-01-24 ZY-LD 067
    end;

    procedure OLDUnshippedPurchaseOrder(var TempPurchaseLine: Record "Purchase Line" temporary; VendorType: Enum VendorType): Boolean
    var
        recUnshipPurchder: Record "Unshipped Purchase Order";
        recPurchLine: Record "Purchase Line";
        recAutoSetup: Record "Automation Setup";
        recWhseSetup: Record "Warehouse Setup";
        SendEmail: Boolean;
        lText001: Label 'Purchase Order No. must not be blank. "%1".';
        lText002: Label 'UNSHIPPEDQUANTITY';
        lText003: Label 'EMPTY';

    /*
    AutoSetup: Record "Automation Setup";
    WhseSetup: Record "Warehouse Setup";
    PurchHeader: Record "Purchase Header";
    PurchLine: Record "Purchase Line";
    PurchLine2: Record "Purchase Line";
    WhseRcptHead: Record "Warehouse Receipt Header";  // LD
    ReleasePurchDoc: Codeunit "Release Purchase Document";
    ExpectedReceiptDate: Date;
    SendEmail: Boolean;
    DocumentIsReleased: Boolean;
    UnshippedQuantityLbl: Label 'UNSHIPPEDQUANTITY';
    EmptyLbl: Label 'EMPTY';
    OrderNoNotBlankErr: Label 'Purchase Order No. must not be blank. "%1".';
    CouldNotGetPurchaseOrderErr: Label 'Could not get purchase order no. %1.';
    */
    begin
        recAutoSetup.GET;  // 03-01-19 ZY-LD 023
        recWhseSetup.GET;
        TempPurchaseLine.SETCURRENTKEY("Document No.", "Line No.");  // 19-03-19 ZY-LD 014
        TempPurchaseLine.ASCENDING(FALSE);  // 19-03-19 ZY-LD 014
        IF TempPurchaseLine.FINDSET THEN BEGIN
            CreateWebServiceLog(lText002, '');
            recUnshipPurchder.SETRANGE("Vendor Type", VendorType);  // 28-06-19 ZY-LD 015
            WebServiceLogEntry.Filter := recUnshipPurchder.GETFILTERS;  // 28-06-19 ZY-LD 015
            WebServiceLogEntry."Quantity Deleted" := recUnshipPurchder.COUNT;

            recUnshipPurchder.DELETEALL;
            IF (TempPurchaseLine."Document No." <> lText003) THEN  // 16-01-23 ZY-LD 059
                REPEAT
                    IF TempPurchaseLine."Document No." = '' THEN
                        ERROR(lText001, TempPurchaseLine);

                    //recUnshipPurchder := TempPurchaseLine;
                    recUnshipPurchder."Sales Order Line ID" := TempPurchaseLine."Sales Order Line ID";
                    recUnshipPurchder."Item No." := TempPurchaseLine."No.";
                    recUnshipPurchder."Purchase Order No." := TempPurchaseLine."Document No.";
                    recUnshipPurchder."Purchase Order Line No." := TempPurchaseLine."Line No.";
                    recUnshipPurchder."ETA Date" := TempPurchaseLine.ETA;
                    recUnshipPurchder."ETD Date" := TempPurchaseLine."ETD Date";
                    recUnshipPurchder."Shipping Order ETD Date" := TempPurchaseLine."Planned Receipt Date";
                    recUnshipPurchder."Expected Receipt Date" := TempPurchaseLine."Expected Receipt Date";
                    recUnshipPurchder.Quantity := TempPurchaseLine.Quantity;
                    recUnshipPurchder."Unit Price" := TempPurchaseLine."Direct Unit Cost";
                    //>> 19-11-18 ZY-LD 004
                    IF recUnshipPurchder."Purchase Order Line No." = 0 THEN
                        recUnshipPurchder."Purchase Order Line No." := GetPurchaseOrderLineNo(recUnshipPurchder."Purchase Order No.", recUnshipPurchder."Item No.", recUnshipPurchder.Quantity);
                    //<< 19-11-18 ZY-LD 004
                    recUnshipPurchder."Vendor Type" := VendorType;  // 28-06-19 ZY-LD 015
                    recUnshipPurchder.INSERT(true);

                    //>> 04-05-22 ZY-LD 047
                    IF FORMAT(recWhseSetup."Expected Shipment Period") <> '' THEN BEGIN
                        IF recUnshipPurchder."Shipping Order ETD Date" <> 0D THEN
                            recUnshipPurchder."Expected receipt date" := CALCDATE(recWhseSetup."Expected Shipment Period", recUnshipPurchder."Shipping Order ETD Date")
                        ELSE
                            IF recUnshipPurchder."ETD Date" <> 0D THEN
                                recUnshipPurchder."Expected receipt date" := CALCDATE(recWhseSetup."Expected Shipment Period", recUnshipPurchder."ETD Date")
                            ELSE
                                recUnshipPurchder."Expected receipt date" := 0D;
                        recUnshipPurchder.MODIFY(TRUE);
                    END;
                    //<< 04-05-22 ZY-LD 047

                    IF recAutoSetup."Upd. Unit Price on Purch.Order" THEN  // 03-01-19 ZY-LD 023
                                                                           //>> 31-01-19 ZY-LD 006
                        IF recUnshipPurchder."Unit Price" > 0 THEN
                            IF recPurchLine.GET(recPurchLine."Document Type"::Order, recUnshipPurchder."Purchase Order No.", recUnshipPurchder."Purchase Order Line No.") THEN
                                IF (recPurchLine.Type = recPurchLine.Type::Item) AND (recPurchLine."Direct Unit Cost" <> recUnshipPurchder."Unit Price") THEN BEGIN
                                    recPurchLine.SuspendStatusCheck(TRUE);
                                    recPurchLine.VALIDATE("Direct Unit Cost", recUnshipPurchder."Unit Price");
                                    recPurchLine.MODIFY;
                                    recPurchLine.SuspendStatusCheck(FALSE);
                                END;
                    //<< 31-01-19 ZY-LD 006

                    //>> 13-03-19 Zy-LD 011
                    IF recUnshipPurchder."Purchase Order Line No." = 0 THEN BEGIN
                        //>> 23-08-19 ZY-LD 017
                        //SendEmail := TRUE;
                        IF ServerEnvironment.ProductionEnvironment THEN BEGIN
                            Clear(EmailAddMgt);
                            Clear(SI);
                            SI.SetMergefield(100, TempPurchaseLine."Document No.");  // 23-08-19
                            SI.SetMergefield(101, FORMAT(VendorType));  // 23-08-19 ZY-LD 017
                            SI.SetMergefield(102, FORMAT(TempPurchaseLine.Quantity));
                            SI.SetMergefield(103, TempPurchaseLine."No.");
                            EmailAddMgt.CreateSimpleEmail('HQUNSHQTY', '', '');
                            EmailAddMgt.Send;
                        END;
                        //<< 23-08-19 ZY-LD 017
                    END;
                    //<< 13-03-19 Zy-LD 011

                    WebServiceLogEntry."Quantity Inserted" += 1;
                UNTIL TempPurchaseLine.NEXT = 0;
            CloseWebServiceLog;

            EXIT(TRUE);
        END;





        /*
                AutoSetup.Get();
                WhseSetup.Get();

                if TempPurchaseLine.FindSet() then begin
                    CreateWebServiceLog(UnshippedQuantityLbl, '');

                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SetRange(Type, PurchLine.Type::Item);
                    PurchLine.SetFilter("No.", '<>''''');
                    PurchLine.SetRange(VendorType, VendorType);

                    WebServiceLogEntry.filter := CopyStr(PurchLine.GetFilters(), 1, MaxStrLen(WebServiceLogEntry.filter));

                    if TempPurchaseLine."Document No." <> EmptyLbl then
                        repeat
                            if TempPurchaseLine."Document No." <> EmptyLbl then begin
                                if TempPurchaseLine."Document No." = '' then
                                    Error(OrderNoNotBlankErr, TempPurchaseLine."Document No.");

                                ExpectedReceiptDate := 0D;
                                if Format(WhseSetup."Expected Shipment Period") <> '' then begin
                                    if TempPurchaseLine."Planned Receipt Date" <> 0D then
                                        ExpectedReceiptDate := CalcDate(WhseSetup."Expected Shipment Period", TempPurchaseLine."Planned Receipt Date")
                                    else
                                        if TempPurchaseLine."ETD Date" <> 0D then
                                            ExpectedReceiptDate := CalcDate(WhseSetup."Expected Shipment Period", TempPurchaseLine."ETD Date");
                                end;

                                if PurchHeader.Get(TempPurchaseLine."Document Type", TempPurchaseLine."Document No.") then begin
                                    DocumentIsReleased := PurchHeader.Status = PurchHeader.Status::Released;
                                    if DocumentIsReleased then begin
                                        ReleasePurchDoc.PerformManualReopen(PurchHeader);
                                        //>> LD
                                        WhseRcptHead.SETRANGE("Purchase Order No.", TempPurchaseLine."Document No.");
                                        IF WhseRcptHead.FINDFIRST THEN
                                            WhseRcptHead.DELETE(TRUE);
                                        //<< LD                                    
                                    End;
                                end;

                                if TempPurchaseLine."Line No." = 0 then
                                    if PurchHeader.Get(TempPurchaseLine."Document Type", TempPurchaseLine."Document No.") then begin
                                        Clear(PurchLine);
                                        PurchLine := TempPurchaseLine;
                                        PurchLine."Line No." := GetPurchaseOrderLineNo(TempPurchaseLine."Document No.", TempPurchaseLine."No.", TempPurchaseLine.Quantity);
                                        PurchLine.Validate(Type, PurchLine.Type::Item);
                                        PurchLine.Validate("No.");
                                        PurchLine.Validate(Quantity);
                                        PurchLine.Validate("Direct Unit Cost");
                                        if ExpectedReceiptDate <> 0D then
                                            PurchLine."Expected Receipt Date" := ExpectedReceiptDate;
                                        PurchLine.Validate("Expected Receipt Date");
                                        PurchLine.OriginalLineNo := PurchLine."Line No.";
                                        PurchLine.VendorType := VendorType;
                                        if not PurchLine.Insert(true) then
                                            PurchLine.Modify(true);

                                        WebServiceLogEntry."Quantity Inserted" += 1;
                                    end else
                                        Error(CouldNotGetPurchaseOrderErr, TempPurchaseLine."Document No.")
                                else
                                    if PurchLine.Get(TempPurchaseLine."Document Type", TempPurchaseLine."Document No.", TempPurchaseLine."Line No.") then
                                        if (PurchLine."Expected Receipt Date" <> ExpectedReceiptDate) or (PurchLine.Type <> TempPurchaseLine.Type) or (PurchLine."No." <> TempPurchaseLine."No.") then begin
                                            PurchLine.SuspendStatusCheck(true);
                                            PurchLine.Validate(Quantity, PurchLine.Quantity - TempPurchaseLine.Quantity);
                                            if AutoSetup."Upd. Unit Price on Purch.Order" and (TempPurchaseLine."Direct Unit Cost" > 0) and (PurchLine."Direct Unit Cost" <> TempPurchaseLine."Direct Unit Cost") then
                                                PurchLine.Validate("Direct Unit Cost", TempPurchaseLine."Direct Unit Cost");
                                            PurchLine.OriginalLineNo := PurchLine."Line No.";
                                            PurchLine.Modify(true);
                                            PurchLine.SuspendStatusCheck(false);

                                            WebServiceLogEntry."Quantity Modified" += 1;

                                            PurchLine2.SetRange("Document Type", PurchLine."Document Type"::Order);
                                            PurchLine2.SetRange("Document No.", PurchLine."Document No.");
                                            PurchLine2.SetFilter("Line No.", '<>%1', PurchLine."Line No.");
                                            PurchLine2.SetRange(Type, PurchLine2.Type::Item);
                                            PurchLine2.SetRange("No.", TempPurchaseLine."No.");
                                            PurchLine2.SetRange(OriginalLineNo, PurchLine."Line No.");
                                            PurchLine2.SetRange("Expected Receipt Date", ExpectedReceiptDate);
                                            if PurchLine2.FindFirst() then begin
                                                PurchLine2.SuspendStatusCheck(true);
                                                PurchLine2.Validate(Quantity, PurchLine2.Quantity + TempPurchaseLine.Quantity);
                                                if AutoSetup."Upd. Unit Price on Purch.Order" and (TempPurchaseLine."Direct Unit Cost" > 0) and (PurchLine."Direct Unit Cost" <> TempPurchaseLine."Direct Unit Cost") then
                                                    PurchLine.Validate("Direct Unit Cost", TempPurchaseLine."Direct Unit Cost");
                                                PurchLine2.Modify(true);
                                                PurchLine2.SuspendStatusCheck(false);

                                                WebServiceLogEntry."Quantity Modified" += 1;
                                            end else begin
                                                Clear(PurchLine);
                                                PurchLine := TempPurchaseLine;

                                                PurchLine2.SetRange("Expected Receipt Date");
                                                if PurchLine2.FindLast() then
                                                    PurchLine."Line No." := PurchLine2."Line No." + 1
                                                else
                                                    PurchLine."Line No." := PurchLine."Line No." + 1;

                                                PurchLine.Validate(Type, PurchLine.Type::Item);
                                                PurchLine.Validate("No.");
                                                PurchLine.Validate(Quantity);
                                                PurchLine.Validate("Direct Unit Cost");
                                                if ExpectedReceiptDate <> 0D then
                                                    PurchLine."Expected Receipt Date" := ExpectedReceiptDate;
                                                PurchLine.Validate("Expected Receipt Date");
                                                PurchLine.OriginalLineNo := TempPurchaseLine."Line No.";
                                                PurchLine.VendorType := VendorType;
                                                if not PurchLine.Insert(true) then
                                                    PurchLine.Modify(true);

                                                WebServiceLogEntry."Quantity Inserted" += 1;
                                            end;
                                        end else begin
                                            if (PurchLine.Quantity <> TempPurchaseLine.Quantity) or (AutoSetup."Upd. Unit Price on Purch.Order" and (TempPurchaseLine."Direct Unit Cost" > 0) and (PurchLine."Direct Unit Cost" <> TempPurchaseLine."Direct Unit Cost")) then begin
                                                PurchLine.SuspendStatusCheck(true);
                                                if TempPurchaseLine.Quantity > 0 then
                                                    PurchLine.Validate(Quantity, TempPurchaseLine.Quantity);
                                                if AutoSetup."Upd. Unit Price on Purch.Order" and (TempPurchaseLine."Direct Unit Cost" > 0) and (PurchLine."Direct Unit Cost" <> TempPurchaseLine."Direct Unit Cost") then
                                                    PurchLine.Validate("Direct Unit Cost", TempPurchaseLine."Direct Unit Cost");
                                                PurchLine.OriginalLineNo := PurchLine."Line No.";
                                                PurchLine.Modify(true);
                                                PurchLine.SuspendStatusCheck(false);

                                                WebServiceLogEntry."Quantity Modified" += 1;
                                            end;
                                        end
                                    else begin
                                        Clear(PurchLine);
                                        PurchLine := TempPurchaseLine;
                                        PurchLine.Validate(Type, PurchLine.Type::Item);
                                        PurchLine.Validate("No.");
                                        PurchLine.Validate(Quantity);
                                        PurchLine.Validate("Direct Unit Cost");
                                        if ExpectedReceiptDate <> 0D then
                                            PurchLine."Expected Receipt Date" := ExpectedReceiptDate;
                                        PurchLine.Validate("Expected Receipt Date");
                                        PurchLine.OriginalLineNo := PurchLine."Line No.";
                                        PurchLine.VendorType := VendorType;
                                        if not PurchLine.Insert(true) then
                                            PurchLine.Modify(true);

                                        WebServiceLogEntry."Quantity Inserted" += 1;
                                    end;

                                if DocumentIsReleased then
                                    ReleasePurchDoc.PerformManualRelease(PurchHeader);

                                if TempPurchaseLine."Line No." = 0 then begin
                                    if ServerEnvironment.ProductionEnvironment then begin
                                        SI.SetMergefield(100, TempPurchaseLine."Document No.");
                                        SI.SetMergefield(101, Format(VendorType));
                                        SI.SetMergefield(102, Format(TempPurchaseLine.Quantity));
                                        SI.SetMergefield(103, TempPurchaseLine."No.");

                                        EmailAddMgt.CreateSimpleEmail('HQUNSHQTY', '', '');
                                        EmailAddMgt.Send();
                                    end;
                                end;
                            end;
                        until TempPurchaseLine.Next() = 0;

                    CloseWebServiceLog();

                    exit(true);
                end;
                */
    end;

    procedure EiCardLinks(var recEicardQueueTmp: Record "EiCard Queue" temporary; var recEiCardLinkLineTmp: Record "EiCard Link Line" temporary): Boolean
    var
        lText001: Label 'EiCard Links';
        recEiCardLinkLine: Record "EiCard Link Line";
        recEiCardLinkLine2: Record "EiCard Link Line";
        recPurchLine: Record "Purchase Line";
        recPurchLineTmp: Record "Purchase Line" temporary;
        recEiCardQueue: Record "EiCard Queue";
        LiNo: Integer;
        lText002: Label 'eCommerce';
        LineNoInserted: Boolean;
    begin
        CreateWebServiceLog(lText001, '');
        //IF recEiCardLinkHeadTmp.FINDSET THEN BEGIN  // 09-06-23 ZY-LD 065
        if recEicardQueueTmp.FindSet() then begin  // 09-06-23 ZY-LD 065
            recEiCardQueue.LockTable;
            //recEiCardLinkHead.LOCKTABLE;  // 09-06-23 ZY-LD 065
            recEiCardLinkLine.LockTable;
            recEiCardLinkLine.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.", "Line No.");
            repeat
                //>> 09-06-23 ZY-LD 065
                /*recEiCardLinkHead := recEiCardLinkHeadTmp;
                recEiCardLinkHead.UID := 0;
                recEiCardLinkHead.INSERT(TRUE);*/
                //<< 09-06-23 ZY-LD 065

                //recEiCardQueue.SETRANGE("Purchase Order No.",recEiCardLinkHead."Order No.");  // 09-06-23 ZY-LD 065
                recEiCardQueue.SetRange("Purchase Order No.", recEicardQueueTmp."Purchase Order No.");  // 09-06-23 ZY-LD 065
                if recEiCardQueue.FindFirst() then begin
                    recEiCardQueue.Validate("Purchase Order Status", recEiCardQueue."purchase order status"::"EiCard Order Accepted");
                    recEiCardQueue.Modify(true);
                end;

                //recEiCardLinkLineTmp.SETRANGE("Purchase Order No.",recEiCardLinkHead."Order No.");  // 09-06-23 ZY-LD 065
                recEiCardLinkLineTmp.SetRange("Purchase Order No.", recEicardQueueTmp."Purchase Order No.");  // 09-06-23 ZY-LD 065
                if recEiCardLinkLineTmp.FindSet() then begin
                    recPurchLineTmp.DeleteAll();  // 04-07-22 ZY-LD 053
                    repeat
                        recEiCardLinkLine := recEiCardLinkLineTmp;
                        recEiCardLinkLine.UID := 0;

                        recPurchLine.Reset();
                        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
                        recPurchLine.SetRange("Document No.", recEiCardLinkLine."Purchase Order No.");
                        recPurchLine.SetRange("No.", recEiCardLinkLine."Item No.");
                        //recPurchLine.SETRANGE(Quantity,recEiCardLinkLine.Quantity);  // 04-07-22 ZY-LD 053
                        if recPurchLine.FindFirst() then begin
                            //>> 04-07-22 ZY-LD 053
                            //recEiCardLinkLine."Purchase Order Line No." := recPurchLine."Line No.";
                            LineNoInserted := false;
                            repeat
                                if not recPurchLineTmp.Get(recPurchLine."Document Type", recPurchLine."Document No.", recPurchLine."Line No.") then begin
                                    recEiCardLinkLine."Purchase Order Line No." := recPurchLine."Line No.";
                                    recPurchLineTmp := recPurchLine;
                                    if not recPurchLineTmp.Insert() then;
                                    LineNoInserted := true;
                                end;
                            until (recPurchLine.Next() = 0) or LineNoInserted;
                            //<< 04-07-22 ZY-LD 053
                        end;

                        recEiCardLinkLine2.SetRange("Purchase Order No.", recEiCardLinkLine."Purchase Order No.");
                        recEiCardLinkLine2.SetRange("Purchase Order Line No.", recEiCardLinkLine."Purchase Order Line No.");
                        if recEiCardLinkLine2.FindLast() then
                            recEiCardLinkLine."Line No." := recEiCardLinkLine2."Line No." + 1
                        else
                            recEiCardLinkLine."Line No." := 1;
                        recEiCardLinkLine.Insert(true);

                        WebServiceLogEntry."Quantity Inserted" += 1;
                    until recEiCardLinkLineTmp.Next() = 0;
                end else
                    //>> 07-02-22 ZY-LD 044
                    if recEiCardQueue."Eicard Type" = recEiCardQueue."eicard type"::eCommerce then begin
                        recPurchLine.Reset();
                        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
                        recPurchLine.SetRange("Document No.", recEiCardQueue."Purchase Order No.");
                        if recPurchLine.FindSet() then
                            repeat
                                LiNo += 1;

                                Clear(recEiCardLinkLine);
                                recEiCardLinkLine."Purchase Order No." := recPurchLine."Document No.";
                                recEiCardLinkLine."Purchase Order Line No." := recPurchLine."Line No.";
                                recEiCardLinkLine."Item No." := recPurchLine."No.";
                                recEiCardLinkLine."Line No." := LiNo;
                                recEiCardLinkLine.Quantity := recPurchLine.Quantity;
                                recEiCardLinkLine.Link := lText002;
                                recEiCardLinkLine.Insert(true);
                            until recPurchLine.Next() = 0;

                        WebServiceLogEntry."Quantity Inserted" += 1;
                    end;
            //<< 07-02-22 ZY-LD 044
            until recEicardQueueTmp.Next() = 0;
            //UNTIL recEiCardLinkHeadTmp.Next() = 0;
        end;

        CloseWebServiceLog();

        exit(true);
    end;

    procedure EiCardRejections(var recEiCardQueueTmp: Record "EiCard Queue" temporary; var recEiCardLinkLineTmp: Record "EiCard Link Line" temporary): Boolean
    var
        lText001: Label 'EiCard Links';
        recEiCardLinkLine: Record "EiCard Link Line";
        recEiCardLinkLine2: Record "EiCard Link Line";
        recPurchLine: Record "Purchase Line";
    begin
        CreateWebServiceLog(lText001, '');
        if recEiCardQueueTmp.FindSet() then begin
            recEiCardLinkLine.LockTable;
            recEiCardLinkLine.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.", "Line No.");
            repeat
                recEiCardLinkLineTmp.SetRange("Purchase Order No.", recEiCardQueueTmp."Purchase Order No.");
                if recEiCardLinkLineTmp.FindSet() then
                    repeat
                        recEiCardLinkLine := recEiCardLinkLineTmp;
                        recEiCardLinkLine.UID := 0;

                        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
                        recPurchLine.SetRange("Document No.", recEiCardLinkLine."Purchase Order No.");
                        recPurchLine.SetRange("No.", recEiCardLinkLine."Item No.");
                        if recPurchLine.FindFirst() then
                            recEiCardLinkLine."Purchase Order Line No." := recPurchLine."Line No.";

                        recEiCardLinkLine2.SetRange("Purchase Order No.", recEiCardLinkLine."Purchase Order No.");
                        recEiCardLinkLine2.SetRange("Purchase Order Line No.", recEiCardLinkLine."Purchase Order Line No.");
                        if recEiCardLinkLine2.FindLast() then
                            recEiCardLinkLine."Line No." := recEiCardLinkLine2."Line No." + 1
                        else
                            recEiCardLinkLine."Line No." := 1;
                        recEiCardLinkLine.Insert(true);

                        WebServiceLogEntry."Quantity Inserted" += 1;
                    until recEiCardLinkLineTmp.Next() = 0;
            until recEiCardQueueTmp.Next() = 0;
        end;
        CloseWebServiceLog;
        exit(true);
    end;

    procedure PurchasePrice(var recPurchPriceTmp: Record "Price List Line" temporary) rValue: Boolean
    var
        PriceListHeader: Record "Price List Header";
        recPurchPrice: Record "Price List Line";
        recVend: Record Vendor;
        recItem: Record Item;
        PriceListManagement: Codeunit "Price List Management";
        lText001: Label 'Purchase Price';
    begin
        CreateWebServiceLog(lText001, '');
        if recPurchPriceTmp.FindSet() then
            repeat
                if recVend.Get(recPurchPriceTmp."Source No.") and recItem.Get(recPurchPriceTmp."Asset No.") then begin
                    recPurchPrice.SetRange("Asset No.", recPurchPriceTmp."Asset No.");
                    recPurchPrice.SetRange("Source No.", recPurchPriceTmp."Source No.");
                    recPurchPrice.SetRange("Starting Date", recPurchPriceTmp."Starting Date");
                    recPurchPrice.SetRange("Currency Code", recPurchPriceTmp."Currency Code");
                    recPurchPrice.SetRange("Variant Code", recPurchPriceTmp."Variant Code");
                    recPurchPrice.SetRange("Unit of Measure Code", recPurchPriceTmp."Unit of Measure Code");
                    if recPurchPriceTmp."Minimum Quantity" in [0, 1] then
                        recPurchPrice.SetRange("Minimum Quantity", 0, 1)
                    else
                        recPurchPrice.SetRange("Minimum Quantity", recPurchPriceTmp."Minimum Quantity");
                    if recPurchPrice.FindLast() then begin
                        if recPurchPrice."Direct Unit Cost" <> recPurchPriceTmp."Direct Unit Cost" then begin
                            recPurchPrice.Validate("Direct Unit Cost", recPurchPriceTmp."Direct Unit Cost");
                            if (not recItem.IsEICard) and (not recItem."Non ZyXEL License") then
                                recPurchPrice."New Price" := true;

                            WebServiceLogEntry."Quantity Modified" += 1;
                            recPurchPrice.Modify(true);
                        end;
                    end else begin
                        recPurchPrice := recPurchPriceTmp;
                        recPurchPrice.SetNextLineNo;  // 25-03-24 ZY-LD 069
                        if recItem.IsEICard or recItem."Non ZyXEL License" then
                            recPurchPrice."New Price" := false;
                        recPurchPrice.Insert(true);

                        WebServiceLogEntry."Quantity Inserted" += 1;
                    end;

                    if PriceListHeader.Get(recPurchPrice."Price List Code") then
                        PriceListManagement.ActivateDraftLines(PriceListHeader);

                    rValue := true;
                end;
            until recPurchPriceTmp.Next() = 0;
        CloseWebServiceLog;
        exit(true);
    end;

    procedure PurchaseOrderLine(var recPurchLineTmp: Record "Purchase Line" temporary) rValue: Boolean
    var
        recPurchLine: Record "Purchase Line";
        lText001: Label 'Purchase Price Order';
    begin
        //>> 10-02-20 ZY-LD 025
        CreateWebServiceLog(lText001, '');
        if recPurchLineTmp.FindSet() then
            repeat
                if recPurchLine.Get(recPurchLine."document type"::Order, recPurchLineTmp."Document No.", recPurchLineTmp."Line No.") then begin
                    recPurchLine.SuspendStatusCheck(true);
                    recPurchLine.Validate("Direct Unit Cost", recPurchLineTmp."Direct Unit Cost");
                    recPurchLine.Modify(true);
                    recPurchLine.SuspendStatusCheck(false);

                    WebServiceLogEntry."Quantity Inserted" += 1;
                end;
            until recPurchLineTmp.Next() = 0;
        CloseWebServiceLog;
        rValue := true;
        //<< 10-02-20 ZY-LD 025
    end;

    procedure SalesPrice(var recSalesPriceTmp: Record "Price List Line" temporary) rValue: Boolean
    var
        PriceListHeader: Record "Price List Header";
        recSalesPrice: Record "Price List Line";
        recCust: Record Customer;
        recVend: Record Vendor;
        recCustPriceGrp: Record "Customer Price Group";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        PriceListManagement: Codeunit "Price List Management";
    begin
        if recSalesPriceTmp.FindSet() then
            repeat
                if ((recSalesPriceTmp."Source Type" = recSalesPriceTmp."Source type"::Customer) and recCust.Get(recSalesPriceTmp."Source No.")) or
                   ((recSalesPriceTmp."Source Type" = recSalesPriceTmp."Source type"::"Customer Price Group") and recCustPriceGrp.Get(recSalesPriceTmp."Source No."))
                then begin
                    recSalesPrice.SetRange("Asset Type", recSalesPriceTmp."Asset Type");
                    recSalesPrice.SetRange("Asset No.", recSalesPriceTmp."Asset No.");
                    recSalesPrice.SetRange("Source Type", recSalesPriceTmp."Source Type");
                    recSalesPrice.SetRange("Source No.", recSalesPriceTmp."Source No.");
                    recSalesPrice.SetRange("Starting Date", recSalesPriceTmp."Starting Date");
                    recSalesPrice.SetRange("Currency Code", recSalesPriceTmp."Currency Code");
                    recSalesPrice.SetRange("Variant Code", recSalesPriceTmp."Variant Code");
                    recSalesPrice.SetRange("Unit of Measure Code", recSalesPriceTmp."Unit of Measure Code");
                    if recSalesPriceTmp."Minimum Quantity" in [0, 1] then
                        recSalesPrice.SetRange("Minimum Quantity", 0, 1)
                    else
                        recSalesPrice.SetRange("Minimum Quantity", recSalesPriceTmp."Minimum Quantity");
                    if recSalesPrice.FindLast() then begin
                        if recSalesPrice."Unit Price" <> recSalesPriceTmp."Unit Price" then begin
                            recSalesPrice.Validate("Unit Price", recSalesPriceTmp."Unit Price");
                            recSalesPrice.Modify(true);
                        end;
                        ItemLogisticEvent.UpdateSalesPriceEndDate(recSalesPrice);  // 06-07-22 ZY-LD 054
                    end else begin
                        recSalesPrice := recSalesPriceTmp;
                        recSalesPrice.Insert(true);
                        ItemLogisticEvent.UpdateSalesPriceEndDate(recSalesPrice);  // 06-07-22 ZY-LD 054
                    end;

                    if PriceListHeader.Get(recSalesPrice."Price List Code") then
                        PriceListManagement.ActivateDraftLines(PriceListHeader);

                    rValue := true;
                end;
            until recSalesPriceTmp.Next() = 0;
    end;

    procedure BatteryCertificate(var pBatCertTmp: Record "Battery Certificate" temporary): Boolean
    var
        lText001: Label 'Battery Certificate';
        recBatCert: Record "Battery Certificate";
    begin
        CreateWebServiceLog(lText001, '');
        if pBatCertTmp.FindSet() then
            repeat
                recBatCert := pBatCertTmp;
                recBatCert."Entry No." := 0;
                recBatCert.Insert(true);

                WebServiceLogEntry."Quantity Inserted" += 1;
            until pBatCertTmp.Next() = 0;

        CloseWebServiceLog;
        exit(true);
    end;

    procedure CurrencyExchangeRate(var pCurrExchRate: Record "Currency Exchange Rate" temporary): Boolean
    var
        recCurrExchRate: Record "Currency Exchange Rate";
        recCurrExchRate2: Record "Currency Exchange Rate";
        recCurrency: Record Currency;
        lText001: Label 'Exchange rate %1 is not setup to be updated via the web service.';
        ReplicateExchangeRate: Codeunit "Replicate Exchange Rate";
    begin
        if pCurrExchRate.FindSet() then
            repeat
                if recCurrency.Get(pCurrExchRate."Currency Code") and not recCurrency."Update via HQ Web Service" then
                    Error(lText001, pCurrExchRate."Currency Code");

                //>> 06-09-24 ZY-LD 072
                //pCurrExchRate."Exchange Rate Amount" := Round(1 / pCurrExchRate."Exchange Rate Amount", 0.00001, '=');
                if format(recCurrency."Start Date Calculation HQ") <> '' then
                    pCurrExchRate."Starting Date" := CalcDate(recCurrency."Start Date Calculation HQ", pCurrExchRate."Starting Date");
                //<< 06-09-24 ZY-LD 072

                if recCurrExchRate.Get(pCurrExchRate."Currency Code", pCurrExchRate."Starting Date") then begin
                    recCurrExchRate.Validate("Exchange Rate Amount", pCurrExchRate."Exchange Rate Amount");
                    recCurrExchRate.Validate("Adjustment Exch. Rate Amount", recCurrExchRate."Exchange Rate Amount");
                    recCurrExchRate.Modify(true);
                end else begin
                    recCurrExchRate.Init();
                    recCurrExchRate.Validate("Currency Code", pCurrExchRate."Currency Code");
                    recCurrExchRate.Validate("Starting Date", pCurrExchRate."Starting Date");
                    recCurrExchRate.Validate("Exchange Rate Amount", pCurrExchRate."Exchange Rate Amount");
                    recCurrExchRate.Validate("Adjustment Exch. Rate Amount", recCurrExchRate."Exchange Rate Amount");
                    recCurrExchRate.Validate("Relational Exch. Rate Amount", 1);
                    recCurrExchRate.Validate("Relational Adjmt Exch Rate Amt", recCurrExchRate."Relational Exch. Rate Amount");
                    recCurrExchRate.Insert(true);
                end;

                recCurrExchRate2.SetRange("Currency Code", recCurrExchRate."Currency Code");
                recCurrExchRate2.SetRange("Starting Date", CalcDate('<1M>', recCurrExchRate."Starting Date"));
                if recCurrExchRate2.FindFirst() then
                    recCurrExchRate2.Delete(true);

                Commit();
                ReplicateExchangeRate.Run;

                // Due to Precision Point we need next month´s exchange rate
                if recCurrency."Copy Last Months Exch. Rate" then begin
                    recCurrExchRate.Validate("Starting Date", CalcDate('<1M>', recCurrExchRate."Starting Date"));
                    if not recCurrExchRate.Insert(true) then
                        recCurrExchRate.Modify(true);

                    Commit();
                    ReplicateExchangeRate.Run;
                end;
            until pCurrExchRate.Next() = 0;

        exit(true);
    end;

    procedure eCommerceOrder(var pAmzHeadTmp: Record "eCommerce Order Header" temporary; var pAmzLineTmp: Record "eCommerce Order Line" temporary): Boolean
    var
        recAmzHead: Record "eCommerce Order Header";
        recAmzLine: Record "eCommerce Order Line";
        recAmzMktPlace: Record "eCommerce Market Place";
        recWebSerLogEntry: Record "Web Service Log Entry";
        lText001: Label 'HQ-MAGENTO';
        recAmzCountryMap: Record "eCommerce Country Mapping";
        NewLineNo: Integer;
        lText002: Label 'eCommerce Order';
    begin
        if pAmzHeadTmp.FindSet() then begin
            CreateWebServiceLog(lText002, '');

            //>> 16-06-23 ZY-LD 066
            /*IF NOT recAmzMktPlace.GET(lText001) THEN BEGIN
              recAmzMktPlace.INIT;
              recAmzMktPlace.VALIDATE("Marketplace ID",lText001);
              recAmzMktPlace.INSERT(TRUE);
            END;
            recAmzMktPlace.TESTFIELD("VAT Prod. Posting Group");

            //>> 12-10-22 ZY-LD 056
            IF NOT recAmzCountryMap.GET(recAmzMktPlace."Customer No.",pAmzHeadTmp."Ship To Country") THEN
              recAmzCountryMap.InsertCountryMapping(recAmzMktPlace."Marketplace ID",pAmzHeadTmp."Ship To Country");
            //<< 12-10-22 ZY-LD 056*/
            //<< 16-06-23 ZY-LD 066

            repeat
                //>> 16-06-23 ZY-LD 066
                if recAmzMktPlace."Market Place Name" <> pAmzHeadTmp."Marketplace ID" then begin
                    recAmzMktPlace.SetRange("Market Place Name", pAmzHeadTmp."Marketplace ID");
                    recAmzMktPlace.FindFirst()
                end;
                recAmzMktPlace.TestField("VAT Prod. Posting Group");

                if not recAmzCountryMap.Get(recAmzMktPlace."Customer No.", pAmzHeadTmp."Ship To Country") then
                    recAmzCountryMap.InsertCountryMapping(recAmzMktPlace."Marketplace ID", pAmzHeadTmp."Ship To Country");
                //<< 16-06-23 ZY-LD 066

                Clear(recAmzHead);
                recAmzHead.Init();
                recAmzHead.SetVatProdPostingGroup(recAmzMktPlace."VAT Prod. Posting Group");
                recAmzHead.Validate("eCommerce Order Id", pAmzHeadTmp."eCommerce Order Id");
                recAmzHead.Validate("Invoice No.", pAmzHeadTmp."Invoice No.");
                recAmzHead.Validate("Marketplace ID", recAmzMktPlace."Marketplace ID");
                recAmzHead.Validate("Purchaser VAT No.", pAmzHeadTmp."Purchaser VAT No.");
                recAmzHead.Validate("Export Outside EU", pAmzHeadTmp."Export Outside EU");
                recAmzHead.Validate("Transaction Type", pAmzHeadTmp."Transaction Type");
                recAmzHead.Validate("Tax Type", pAmzHeadTmp."Tax Type");
                recAmzHead.Validate("Tax Calculation Reason Code", pAmzHeadTmp."Tax Calculation Reason Code");
                recAmzHead.Validate("Tax Address Role", pAmzHeadTmp."Tax Address Role");
                recAmzHead.Validate("Buyer Tax Reg. Country", pAmzHeadTmp."Buyer Tax Reg. Country");
                recAmzHead.Validate("Tax Rate", pAmzHeadTmp."Tax Rate");

                //recAmzHead.VALIDATE("Merchant ID",MerchantID);
                recAmzHead.Validate("Transaction ID", pAmzHeadTmp."Transaction ID");
                recAmzHead.Validate("Shipment ID", pAmzHeadTmp."Shipment ID");
                recAmzHead.Validate("Order Date", pAmzHeadTmp."Order Date");
                recAmzHead.Validate("Shipment Date", pAmzHeadTmp."Shipment Date");
                recAmzHead.Validate("Invoice No.", pAmzHeadTmp."Invoice No.");
                recAmzHead.Validate("Ship To City", pAmzHeadTmp."Ship To City");
                recAmzHead.Validate("Ship To State", pAmzHeadTmp."Ship To State");
                recAmzHead.Validate("Ship To Country", pAmzHeadTmp."Ship To Country");
                recAmzHead.Validate("Ship To Postal Code", pAmzHeadTmp."Ship To Postal Code");
                recAmzHead.Validate("Ship From City", pAmzHeadTmp."Ship From City");
                recAmzHead.Validate("Ship From State", pAmzHeadTmp."Ship From State");
                recAmzHead.Validate("Ship From Country", pAmzHeadTmp."Ship From Country");
                recAmzHead.Validate("Ship From Postal Code", pAmzHeadTmp."Ship From Postal Code");
                recAmzHead.Validate("Ship From Tax Location Code", pAmzHeadTmp."Ship From Tax Location Code");
                recAmzHead.Validate("VAT Registration No. Zyxel", pAmzHeadTmp."VAT Registration No. Zyxel");
                recAmzHead.Validate("Currency Code", pAmzHeadTmp."Currency Code");
                recAmzHead.Insert(true);

                NewLineNo := 0;
                pAmzLineTmp.SetRange("eCommerce Order Id", pAmzHeadTmp."eCommerce Order Id");
                pAmzLineTmp.SetRange("Invoice No.", pAmzHeadTmp."Invoice No.");
                if pAmzLineTmp.FindSet() then
                    repeat
                        NewLineNo += 10000;
                        Clear(recAmzLine);
                        recAmzLine.Init();

                        recAmzLine.Validate("Transaction Type", recAmzHead."Transaction Type");  // 01-03-23 ZY-LD 061
                        recAmzLine.Validate("eCommerce Order Id", recAmzHead."eCommerce Order Id");
                        recAmzLine.Validate("Invoice No.", recAmzHead."Invoice No.");
                        recAmzLine.Validate("Line No.", NewLineNo);
                        recAmzLine.Validate("Item No.", pAmzLineTmp."Item No.");
                        recAmzLine.Validate(Quantity, pAmzLineTmp.Quantity);
                        recAmzLine.Validate("VAT Prod. Posting Group", recAmzMktPlace."VAT Prod. Posting Group");
                        recAmzLine.Validate("Item Price (Exc. Tax)", pAmzLineTmp."Item Price (Exc. Tax)");
                        recAmzLine.Validate("Item Price (Inc. Tax)", pAmzLineTmp."Item Price (Inc. Tax)");
                        recAmzLine.Validate("Total (Exc. Tax)", pAmzLineTmp."Total (Exc. Tax)");
                        recAmzLine.Validate("Total (Inc. Tax)", pAmzLineTmp."Total (Inc. Tax)");
                        recAmzLine.Validate("Total Tax Amount", pAmzLineTmp."Total Tax Amount");
                        recAmzLine.Validate("Line Discount Pct.", pAmzLineTmp."Line Discount Pct.");
                        recAmzLine.Validate("Line Discount Excl. Tax", pAmzLineTmp."Line Discount Excl. Tax");
                        recAmzLine.Validate("Line Discount Incl. Tax", pAmzLineTmp."Line Discount Incl. Tax");
                        recAmzLine.VALIDATE("Line Discount Tax Amount", pAmzLineTmp."Line Discount Tax Amount");
                        recAmzLine.Validate(Amount);
                        recAmzLine.Insert(true);
                    until pAmzLineTmp.Next = 0;

                recAmzHead."Completely Imported" := true;
                recAmzHead.ValidateDocument;
                recAmzHead.Modify(true);
                recWebSerLogEntry."Quantity Inserted" += 1;
            until pAmzHeadTmp.Next = 0;

            CloseWebServiceLog;
            exit(true);
        end;
    end;

    procedure eCommercePayment(var pAmzHeadTmp: Record "eCommerce Payment Header" temporary; var pAmzLineTmp: Record "eCommerce Payment" temporary): Boolean
    var
        recAmzHead: Record "eCommerce Payment Header";
        recAmzLine: Record "eCommerce Payment";
        recWebSerLogEntry: Record "Web Service Log Entry";
        lText001: Label 'HQ-MAGENTO';
        NewLineNo: Integer;
        lText002: Label 'eCommerce Payment';
    begin
        if pAmzHeadTmp.FindSet() then begin
            CreateWebServiceLog(lText002, '');

            pAmzLineTmp.FindFirst();

            //recAmzHead.SETRANGE("Market Place ID",lText001);  // 01-08-23 ZY-LD 066
            //>> 04-08-23 ZY-LD 066
            /*recAmzHead.SETRANGE("Market Place ID", pAmzHeadTmp."Market Place ID");  // 01-08-23 ZY-LD 066
            recAmzHead.SETRANGE(Date, CALCDATE('<-CM>', TODAY), CALCDATE('<CM>', TODAY));
            recAmzHead.SETRANGE("Currency Code", pAmzLineTmp."Currency Code");
            recAmzHead.SETRANGE(Open, TRUE);
            IF NOT recAmzHead.FINDFIRST THEN BEGIN
                recAmzHead.INIT;
                recAmzHead.Date := pAmzHeadTmp.Date;
                recAmzHead."Transfered Amount" := pAmzHeadTmp."Transfered Amount";
                recAmzHead."Market Place ID" := lText001;
                recAmzHead."Currency Code" := pAmzLineTmp."Currency Code";
                recAmzHead."Transaction Summary" := STRSUBSTNO('%1: %2..', lText001, TODAY);
                recAmzHead.Period := recAmzHead."Transaction Summary";
                recAmzHead.INSERT(TRUE);
            END;*/
            //<< 04-08-23 ZY-LD 066

            if recAmzLine.FindLast() then
                NewLineNo := recAmzLine.UID;

            repeat
                if pAmzLineTmp.FindSet() then
                    repeat
                        NewLineNo += 1;

                        //>> 04-08-23 ZY-LD 066
                        recAmzHead.SetRange("Market Place ID", UPPERCASE(pAmzLineTmp."eCommerce Market Place"));
                        recAmzHead.SetRange(Date, CalcDate('<-CM>', TODAY), CalcDate('<CM>', TODAY));
                        recAmzHead.SetRange("Currency Code", pAmzLineTmp."Currency Code");
                        recAmzHead.SetRange(Open, true);
                        if not recAmzHead.FindFirst() then begin
                            recAmzHead.Init();
                            recAmzHead.Date := pAmzHeadTmp.Date;
                            //recAmzHead."Transfered Amount" := pAmzHeadTmp."Transfered Amount";
                            recAmzHead."Market Place ID" := UPPERCASE(pAmzLineTmp."eCommerce Market Place");
                            recAmzHead."Currency Code" := pAmzLineTmp."Currency Code";
                            recAmzHead."Transaction Summary" := StrSubstNo('%1: %2..', UPPERCASE(pAmzLineTmp."eCommerce Market Place"), TODAY);
                            recAmzHead.Period := recAmzHead."Transaction Summary";
                            recAmzHead.Insert(true);
                        end;
                        //<< 04-08-23 ZY-LD 066

                        Clear(recAmzLine);
                        recAmzLine.Init();
                        recAmzLine.Validate(UID, NewLineNo);
                        recAmzLine.Validate("Journal Batch No.", recAmzHead."No.");
                        recAmzLine.Validate(Date, recAmzLine.Date);
                        recAmzLine.Validate("Order ID", pAmzLineTmp."Order ID");
                        recAmzLine.Validate("eCommerce Invoice No.", pAmzLineTmp."eCommerce Invoice No.");
                        //>> 14-12-22 ZY-LD 058
                        /*recAmzLine.VALIDATE("Transaction Type", pAmzLineTmp."Transaction Type");
                        recAmzLine.VALIDATE("Payment Type", pAmzLineTmp."Payment Type");
                        recAmzLine.VALIDATE("Payment Detail", pAmzLineTmp."Payment Detail");
                        recAmzLine.VALIDATE("Payment Detail Text", pAmzLineTmp."Payment Detail Text");*/
                        recAmzLine.Validate("New Transaction Type", pAmzLineTmp."New Transaction Type");
                        recAmzLine.Validate("Amount Type", pAmzLineTmp."Amount Type");
                        recAmzLine.Validate("Amount Description", pAmzLineTmp."Amount Description");
                        //<< 14-12-22 ZY-LD 058
                        recAmzLine.Validate("Currency Code", pAmzLineTmp."Currency Code");
                        recAmzLine.Validate(Amount, pAmzLineTmp.Amount);
                        recAmzLine.Insert(true);
                        recWebSerLogEntry."Quantity Inserted" += 1;
                    until pAmzLineTmp.Next = 0;
            until pAmzHeadTmp.Next = 0;

            CloseWebServiceLog;
            exit(true);
        end;
    end;

    procedure eRMADeliveryNote(pDelNoteHeadTmp: Record "Sales Shipment Header" temporary; pDelNoteLineTmp: Record "Sales Shipment Line" temporary): Boolean
    begin
        //>> 11-06-20 028
        if pDelNoteHeadTmp.FindSet() then
            repeat
                // Insert Header here.

                pDelNoteLineTmp.SetRange("Document No.", pDelNoteHeadTmp."No.");
                if pDelNoteLineTmp.FindSet() then
                    repeat
                    // Insert Lines Here
                    until pDelNoteLineTmp.Next() = 0;
            until pDelNoteHeadTmp.Next() = 0;
        exit(true);
        //<< 11-06-20 028
    end;

    procedure CreateSalesOrder(var recSalesHeadTmp: Record "Sales Header" temporary; var recSalesLineTmp: Record "Sales Line" temporary) rValue: Boolean
    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesSetup: Record "Sales & Receivables Setup";
        recShipToAdd: Record "Ship-to Address";
        LiNo: Integer;
        lText001: Label 'Sales Order';
    begin
        if recSalesHeadTmp.FindSet() then begin
            CreateWebServiceLog(lText001, '');

            recSalesHead.LockTable;
            recSalesLine.LockTable;
            repeat
                Clear(recSalesHead);
                recSalesHead.Init();
                recSalesHead."Document Type" := recSalesHead."document type"::Order;
                recSalesSetup.Get();
                if recSalesHeadTmp."Location Code" = recSalesSetup."All-In Logistics Location" then
                    recSalesHead."Sales Order Type" := recSalesHead."sales order type"::Normal
                else
                    recSalesHead."Sales Order Type" := recSalesHead."sales order type"::EICard;
                recSalesHead.Insert(true);

                recSalesHead.Validate("Sell-to Customer No.", recSalesHeadTmp."Sell-to Customer No.");
                recSalesHead.Validate("Location Code", recSalesHeadTmp."Location Code");
                recSalesHead.Validate("External Document No.", recSalesHeadTmp."External Document No.");

                if (recSalesHeadTmp."Ship-to Name" <> '') and (recSalesHeadTmp."Ship-to Address" <> '') then begin
                    recShipToAdd.Reset();
                    recShipToAdd.SetRange("Customer No.", recSalesHead."Sell-to Customer No.");
                    recShipToAdd.SetRange(Address, recSalesHeadTmp."Ship-to Address");
                    recShipToAdd.SetRange("Post Code", recSalesHeadTmp."Ship-to Post Code");
                    recShipToAdd.SetRange("Country/Region Code", recSalesHeadTmp."Ship-to Country/Region Code");
                    if recShipToAdd.FindFirst() then
                        recSalesHead.Validate("Ship-to Code", recShipToAdd.Code)
                    else begin
                        recSalesHead."Ship-to Name" := recSalesHeadTmp."Ship-to Name";
                        recSalesHead."Ship-to Address" := recSalesHeadTmp."Ship-to Address";
                        recSalesHead."Ship-to Post Code" := recSalesHeadTmp."Ship-to Post Code";
                        recSalesHead."Ship-to City" := recSalesHeadTmp."Ship-to City";
                        recSalesHead."Ship-to Country/Region Code" := recSalesHeadTmp."Ship-to Country/Region Code";
                    end;
                end;
                recSalesHead.Modify(true);

                recSalesLineTmp.SetRange("Document Type", recSalesHeadTmp."Document Type");
                recSalesLineTmp.SetRange("Document No.", recSalesHeadTmp."No.");
                if recSalesLineTmp.FindSet() then
                    repeat
                        LiNo += 10000;
                        Clear(recSalesLine);
                        recSalesLine.Init();
                        recSalesLine.Validate("Document Type", recSalesHead."Document Type");
                        recSalesLine.Validate("Document No.", recSalesHead."No.");
                        recSalesLine.Validate("Line No.", LiNo);
                        recSalesLine.Validate(Type, recSalesLine.Type::Item);
                        recSalesLine.Validate("No.", recSalesLineTmp."No.");
                        recSalesLine.Validate(Quantity, recSalesLineTmp.Quantity);
                        recSalesLine.Validate("Unit of Measure Code", recSalesLineTmp."Unit of Measure Code");
                        recSalesLine.Validate("Unit Price", recSalesLineTmp."Unit Price");
                        recSalesLine.Insert(true);
                    until recSalesLineTmp.Next() = 0;

                WebServiceLogEntry."Quantity Inserted" += 1;
            until recSalesHeadTmp.Next() = 0;

            rValue := true;
            CloseWebServiceLog;
        end;
    end;

    local procedure CreateWebServiceLog(FunctionName: Text; FilterText: Text)
    begin
        Clear(WebServiceLogEntry);
        WebServiceLogEntry.LockTable;
        WebServiceLogEntry."Web Service Name" := 'HQWEBSERVICE';
        WebServiceLogEntry."Web Service Function" := CopyStr(FunctionName, 1, MaxStrLen(WebServiceLogEntry."Web Service Function"));
        WebServiceLogEntry.filter := CopyStr(FilterText, 1, MaxStrLen(WebServiceLogEntry.filter));
        WebServiceLogEntry."Start Time" := CurrentDateTime();
        WebServiceLogEntry."User ID" := UserId();
        WebServiceLogEntry.Insert();
    end;

    local procedure CloseWebServiceLog()
    begin
        WebServiceLogEntry."End Time" := CurrentDatetime;
        WebServiceLogEntry.Modify();
    end;

    local procedure GetPurchaseOrderLineNo(OrderNo: Code[20]; ItemNo: Code[20]; Quantity: Integer): Integer
    var
        PurchLine: Record "Purchase Line";
        ContDetail: Record "VCK Shipping Detail";
        QtyContDetail: Integer;
    begin
        PurchLine.SetRange("Document Type", PurchLine."document type"::Order);
        PurchLine.SetRange("Document No.", OrderNo);
        PurchLine.SetRange("No.", ItemNo);
        if PurchLine.Count() = 1 then begin
            if PurchLine.FindFirst() then
                exit(PurchLine."Line No.");
        end else begin
            if PurchLine.FindSet() then
                repeat
                    ContDetail.SetCurrentkey("Purchase Order No.", "Purchase Order Line No.");
                    ContDetail.SetRange("Purchase Order No.", PurchLine."Document No.");
                    ContDetail.SetRange("Purchase Order Line No.", PurchLine."Line No.");
                    ContDetail.SetRange(Archive, false);
                    ContDetail.CalcSums(Quantity);

                    if Quantity <= PurchLine."Outstanding Quantity" - ContDetail.Quantity then
                        exit(PurchLine."Line No.");
                until PurchLine.Next() = 0;
        end;
    end;

    local procedure GetPurchOrdLineNoEiCard(pOrderNo: Code[20]; pItemNo: Code[20]; pQuantity: Integer): Integer
    var
        recPurchLine: Record "Purchase Line";
        recHQInvLine: Record "HQ Invoice Line";
        QtyContDetail: Integer;
    begin
        //>> 17-02-21 ZY-LD 036
        recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
        recPurchLine.SetRange("Document No.", pOrderNo);
        recPurchLine.SetRange("No.", pItemNo);
        recPurchLine.SetRange(Quantity, pQuantity);  // 17-04-23 ZY-LD 063
        if recPurchLine.Count = 1 then begin
            if recPurchLine.FindFirst() then
                exit(recPurchLine."Line No.");
        end else begin
            if recPurchLine.FindSet() then
                repeat
                    recHQInvLine.SetRange("Document Type", recHQInvLine."document type"::Invoice);
                    recHQInvLine.SetRange("Purchase Order No.", recPurchLine."Document No.");
                    recHQInvLine.SetRange("Purchase Order Line No.", recPurchLine."Line No.");
                    //recHQInvLine.SETRANGE(Quantity,pQuantity);  // 17-04-23 ZY-LD 063
                    if not recHQInvLine.FindFirst() then
                        exit(recPurchLine."Line No.");
                until recPurchLine.Next() = 0;
        end;
        //<< 17-02-21 ZY-LD 036
    end;
}
