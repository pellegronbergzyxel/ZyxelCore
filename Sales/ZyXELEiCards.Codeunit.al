Codeunit 50001 "ZyXEL EiCards"
{
    // 
    // EiCard Integration
    // Created By: Paul Bowden
    // Date:       Feb 2014
    // 
    // 001. 06-02-19 ZY-LD 000 - Code has been reviewed, and ftp-upload added.
    // 002. 31-03-19 ZY-LD 000 - Found out in the last moment, that we created the eicard on the wrong vendor.
    // 003. 01-04-19 ZY-LD 2019032610000026 - It was not possible to resend the order.
    // 004. 16-08-19 ZY-LD 2019071810000061 - Fields are deleted due to lack of space in table 36. Fields were never used.
    // 005. 03-09-19 ZY-LD P0290 - Changes to the EiCard Creation.
    // 006. 20-09-19 ZY-LD 2019092010000044 - Validate is set.
    // 007. 15-10-19 ZY-LD 000 - Some how the machine code was lost in the recode of the function.
    // 008. 31-10-19 ZY-LD 000 - Convertstring is added.
    // 009. 04-11-14 ZY-LD P0334 - Order Split.
    // 010. 07-01-20 ZY-LD P0368 - Send to eShop with delay.
    // 011. 17-02-20 ZY-LD 000 - If purchase price
    // 012. 18-02-20 ZY-LD P0395 - Eicard Type.
    // 013. 23-03-20 ZY-LD 000 - We have to commit after upload.
    // 014. 30-06-20 ZY-LD 000 - We don´t receive links on eCommerce, so purchase status must be "Accepted" to be posted.
    // 015. 18-09-20 ZY-LD 000 - Cleaning up for upgrade.
    // 016. 15-12-20 ZY-LD 2020121510000054 - Update Error Description.
    // 017. 21-01-21 ZY-LD 000 - Illigal character.
    // 018. 19-04-21 ZY-LD 000 - Distributor Reference comes from the Eicard table.
    // 019. 12-09-22 ZY-LD 000 - Quantity must not be decimal.
    // 020. 23-02-23 ZY-LD 000 - Handling GLC License.
    // 021. 10-07-24 ZY-LD 000 - eConsignments can be merged into one line per item.

    trigger OnRun()
    begin
    end;

    var
        recPurchSetup: Record "Purchases & Payables Setup";
        PurchLineNo: Integer;
        ZGT: Codeunit "ZyXEL General Tools";
        Text005: label 'The Sales Order has been successfully added to the EiCard Queue.\\\There is a %1 min. delay before the Eicard is sent to eShop.\Go to the Eicard queue if you want send it right away.\\If you delete the sales order before the Eicard Links is sent to the customer, the Eicard links will not be sent.\If the Eicard have not been sent to eShop, the purchase order will also be deleted when the sales order is deleted.';
        Text014: label 'Are you sure that you want to add this order to the EiCard Queue. \The Order cannot be changed once queued.';


    procedure CreatePO(var pSalesOrder: Record "Sales Header")
    var
        recVend: Record Vendor;
        recPurchHead: Record "Purchase Header";
        recItem: Record Item;
        recSalesLine: Record "Sales Line";
        recAutoSetup: Record "Automation Setup";
        recAddEicardOrderInfo: Record "Add. Eicard Order Info";
        Cust: Record Customer;
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        ArchiveManagement: Codeunit ArchiveManagement;
        recEiCardQueue: Record "EiCard Queue";
        ReleaseDocument: Boolean;
        lText002: label 'Customer No. in the EiCard Queue is wrong.';
        lText003: label 'Location Code on purchase is wrong. Please contact navsupport.';
        lText004: label '"%1" is an illigal charcter.';
        lText005: label 'Quantity %1 is wrong on %2 %3.';
        lText006: label 'Quantity %1 and "%2" %3 does not match.';
    begin
        if Confirm(Text014) then begin
            recPurchSetup.Get;
            recPurchSetup.TestField("EiCar Default Transport Method");

            // Check
            pSalesOrder.TestField("Sell-to Customer Name");
            pSalesOrder.TestField("External Document No.");
            if StrPos(pSalesOrder."External Document No.", '°') <> 0 then  // 21-01-21 ZY-LD 017
                Error(lText004, '°');  // 21-01-21 ZY-LD 017
            pSalesOrder."Requested Delivery Date" := CalcDate('+' + Format(recPurchSetup."EiCard Lead Time") + 'D', Today);

            Cust.get(pSalesOrder."Sell-to Customer No.");
            recEiCardQueue.Get(pSalesOrder."No.");
            recEiCardQueue.TestField("From E-Mail Address");
            recEiCardQueue.TestField(recEiCardQueue."Distributor E-mail");
            if Cust."End User Email Expected" then
                recEiCardQueue.TestField("End User E-mail");
            if recEiCardQueue."Customer No." <> pSalesOrder."Sell-to Customer No." then
                Error(lText002);

            // Create Purchase Header
            recPurchHead.Init;
            recPurchHead.Validate("Document Type", recPurchHead."document type"::Order);
            recPurchHead.Insert(true);

            recSalesLine.SetRange("Document Type", pSalesOrder."Document Type");
            recSalesLine.SetRange("Document No.", pSalesOrder."No.");
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            recSalesLine.SetFilter("No.", '<>%1', '');
            recSalesLine.FindFirst;
            recItem.Get(recSalesLine."No.");
            recItem.TestField("SBU Company");
            recVend.SetRange("SBU Company", recItem."SBU Company");
            recVend.FindFirst;

            recPurchHead.Validate("Buy-from Vendor No.", recVend."No.");
            recPurchHead.Validate("Location Code", pSalesOrder."Location Code");
            recPurchHead.Validate("Posting Date", Today);
            recPurchHead.Validate("Order Date", Today);
            recPurchHead.Validate(IsEICard, true);
            recPurchHead.Validate("Transport Method", recPurchSetup."EiCar Default Transport Method");
            recPurchHead.Validate("EiCard Sales Order", pSalesOrder."No.");

            recPurchHead.Validate("From SO No.", pSalesOrder."No.");
            recPurchHead.Validate("SO Sell-to Customer Name", pSalesOrder."Sell-to Customer Name");
            recPurchHead.Validate("Purchaser Code", pSalesOrder."Salesperson Code");
            recPurchHead.Validate("Dist. Purch. Order No.", pSalesOrder."External Document No.");
            recPurchHead.Validate("EiCard Sales Order", pSalesOrder."No.");
            //recPurchHead.VALIDATE("EiCard Distributor Reference",pSalesOrder."EiCard Distributor Reference");  // 19-04-21 ZY-LD 018
            recPurchHead.Validate("EiCard Distributor Reference", recEiCardQueue."Distributor Reference");  // 19-04-21 ZY-LD 018
            recPurchHead.Validate("Create User ID", UserId());
            recPurchHead.Validate("Doc. No. Occurrence",
              ArchiveManagement.GetNextOccurrenceNo(Database::"Purchase Header", recPurchHead."Document Type".AsInteger(), recPurchHead."No."));
            recPurchHead.Modify(true);

            if recPurchHead."Location Code" <> 'EICARD' then
                Error(lText003);

            // Create Purchase Lines
            recSalesLine.Reset;
            recSalesLine.SetRange("Document Type", pSalesOrder."Document Type");
            recSalesLine.SetRange("Document No.", pSalesOrder."No.");
            recSalesLine.SetRange("Quantity Shipped", 0);
            if recSalesLine.FindSet(true) then
                repeat
                    //>> 12-09-22 ZY-LD 019
                    if recSalesLine.Quantity MOD 1 <> 0 then
                        Error(lText005, recSalesLine.Quantity, recSalesLine."Document No.", recSalesLine."Line No.");
                    //<< 12-09-22 ZY-LD 019

                    case recSalesLine.Type of
                        recSalesLine.Type::" ":
                            InsertPurchLine(pSalesOrder, recSalesLine, recPurchHead, recAddEicardOrderInfo, 0);  // 10-07-24 ZY-LD 021
                        recSalesLine.Type::Item:
                            begin
                                recItem.Get(recSalesLine."No.");
                                if recItem."Enter Security for Eicard on" > recItem."enter security for eicard on"::" " then begin
                                    recAddEicardOrderInfo.SetRange("Document Type", recSalesLine."Document Type");
                                    recAddEicardOrderInfo.SetRange("Document No.", recSalesLine."Document No.");
                                    recAddEicardOrderInfo.SetRange("Sales Line Line No.", recSalesLine."Line No.");
                                    recAddEicardOrderInfo.SetRange(Validated, true);
                                    if recSalesLine.Quantity = recAddEicardOrderInfo.Count then begin
                                        if recAddEicardOrderInfo.FindSet then
                                            repeat
                                                InsertPurchLine(pSalesOrder, recSalesLine, recPurchHead, recAddEicardOrderInfo, 1);  // 10-07-24 ZY-LD 021
                                            until recAddEicardOrderInfo.Next() = 0;
                                    end else
                                        Error(lText006, recSalesLine.Quantity, recAddEicardOrderInfo.TableCaption, recAddEicardOrderInfo.Count);
                                end else begin
                                    Clear(recAddEicardOrderInfo);
                                    InsertPurchLine(pSalesOrder, recSalesLine, recPurchHead, recAddEicardOrderInfo, recSalesLine.Quantity);
                                end;
                            end;
                    end;

                    recSalesLine."Lock by Ref Document" := true;
                    recSalesLine."Planned Delivery Date" := pSalesOrder."Requested Delivery Date";
                    recSalesLine."Planned Shipment Date" := pSalesOrder."Requested Delivery Date";
                    recSalesLine."Shipment Date" := pSalesOrder."Requested Delivery Date";
                    recSalesLine."Shipment Date Confirmed" := true;
                    recSalesLine.Modify;

                    ReleaseDocument := true;
                until (recSalesLine.Next() = 0);

            if ReleaseDocument then
                ReleasePurchDoc.PerformManualRelease(recPurchHead);

            recEiCardQueue.Get(pSalesOrder."No.");  // We need to
            recEiCardQueue."Purchase Order No." := recPurchHead."No.";
            recEiCardQueue."External Document No." := pSalesOrder."External Document No.";
            recEiCardQueue."External Document No." := ConvertStr(recEiCardQueue."External Document No.", '°', 'o');  // 21-01-21 ZY-LD 017
            recEiCardQueue."Customer No." := pSalesOrder."Sell-to Customer No.";
            recEiCardQueue."Customer Name" := pSalesOrder."Sell-to Customer Name";
            recEiCardQueue.Validate("Sales Order Status", recEiCardQueue."sales order status"::"Purchase Order Created");
            recEiCardQueue.Validate(Active, true);  // 07-01-19 ZY-LD 010
            recEiCardQueue."Eicard Type" := pSalesOrder."Eicard Type";  // 18-02-20 ZY-LD 012
            recEiCardQueue.Modify(true);

            recAutoSetup.Get;
            Message(Text005, recAutoSetup."Delay Between Create and eShop");
        end;
    end;

    local procedure InsertPurchLine(pSalesHead: record "Sales Header"; pSalesLine: Record "Sales Line"; pPurchHead: Record "Purchase Header"; pAddEicardInfo: Record "Add. Eicard Order Info"; pQuantity: Decimal)
    var
        recPurchLine: Record "Purchase Line";
    begin
        PurchLineNo := PurchLineNo + 10000;

        //>> 10-07-24 ZY-LD 021
        recPurchLine.SetRange("Document Type", pPurchHead."Document Type");
        recPurchLine.SetRange("Document No.", pPurchHead."No.");
        recPurchLine.SetRange(Type, recPurchLine.Type::Item);
        recPurchLine.SetRange("No.", pSalesLine."No.");
        if (pSalesHead."Eicard Type" = pSalesHead."Eicard Type"::eCommerce) and recPurchLine.FindFirst then begin
            recPurchLine.Validate(Quantity, recPurchLine.Quantity + pQuantity);
            recPurchLine.Modify(true);
        end else begin  //<< 10-07-24 ZY-LD 021
            Clear(recPurchLine);
            recPurchLine.Validate("Document Type", pPurchHead."Document Type");
            recPurchLine.Validate("Document No.", pPurchHead."No.");
            recPurchLine."Line No." := PurchLineNo;
            recPurchLine.Insert(true);

            if (pSalesLine.Type = pSalesLine.Type::Item) then begin
                recPurchLine.Validate(Type, pSalesLine.Type);
                recPurchLine.Validate("No.", pSalesLine."No.");
                recPurchLine.Validate(Quantity, pQuantity);
                recPurchLine.Validate("Requested Date From Factory", CalcDate('+' + Format(recPurchSetup."EiCard PO Lead Time") + 'D', Today));
                recPurchLine.Validate("Expected Receipt Date", recPurchLine."Requested Date From Factory");
                recPurchLine."EMS Machine Code" := pAddEicardInfo."EMS Machine Code";
                recPurchLine."GLC Serial No." := pAddEicardInfo."GLC Serial No.";
                recPurchLine."GLC Mac Address" := pAddEicardInfo."GLC Mac Address";
            end else begin
                recPurchLine.Description := pSalesLine.Description;
                recPurchLine."Description 2" := pSalesLine."Description 2";
            end;
            recPurchLine."Sales Order Number" := pSalesLine."Document No.";
            recPurchLine."Sales Line Number" := pSalesLine."Line No.";
            recPurchLine."Lock by Ref Document" := true;
            recPurchLine.Modify(true);
        end;
    end;


    procedure SendToHQ(var pEiCardQueue: Record "EiCard Queue"; ReSend: Boolean) rValue: Boolean
    var
        CurrFile: File;
        recPurchSetup: Record "Purchases & Payables Setup";
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        recServEnviron: Record "Server Environment";
        recPurchPrice: Record "Price List Line";
        recUserSetup: Record "User Setup";
        recConvChar: Record "Convert Characters";
        ServerFilename: Text;
        RemoteFilename: Text;
        FileMgt: Codeunit "File Management";
        FTPMgt: Codeunit "VisionFTP Management";
        lText001: label 'Order %1 could not upload to eShop.';
        lText002: label 'Do you want to send "%1" to eShop from "%2"?';
        ConvCodePage: Codeunit "Convert Codepage";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        SendFromTest: Boolean;
        PurchasePriceIsEmpty: Boolean;
        lText003: label 'Purchase Price is empty.';
        PurchasePriceIsEmptyItemNo: Text;
    begin
        recPurchSetup.Get;
        if not recServEnviron.ProductionEnvironment then begin
            recServEnviron.Get;
            if recPurchSetup."Send Orders To EShop" then
                SendFromTest := Confirm(lText002, false, pEiCardQueue."Purchase Order No.", recServEnviron.Environment);
        end;

        if (recServEnviron.ProductionEnvironment and recPurchSetup."Send Orders To EShop") or
           (not recServEnviron.ProductionEnvironment and recPurchSetup."Send Orders To EShop" and SendFromTest)
        then begin
            if recPurchHead.Get(recPurchHead."document type"::Order, pEiCardQueue."Purchase Order No.") and
              (recPurchHead.IsEICard) and
              ((not recPurchHead."EShop Order Sent") or (ReSend)) and  // 01-04-19 ZY-LD 003 - ReSend is added.
              (not recPurchHead."Sent to HQ")  // The field name should have been "Do not Sent to HQ".
            then begin
                recPurchHead.TestField("FTP Code");
                pEiCardQueue."Error Description" := '';  // 15-12-20 ZY-LD 016

                ServerFilename := FileMgt.ServerTempFileName('');
                RemoteFilename := StrSubstNo('%1.txt', recPurchHead."No.");
                CurrFile.TextMode(true);
                CurrFile.Create(ServerFilename);
                CurrFile.Write('Order Header,,');
                CurrFile.Write(recPurchSetup."EiCar Default Transport Method");
                CurrFile.Write(',');

                CurrFile.Write(StrSubstNo('Purchase Order No (*),%1,', recPurchHead."No."));
                CurrFile.Write(StrSubstNo('Shipping Mark,"SO#%1 / %2, %3",', recPurchHead."From SO No.", recPurchHead."SO Sell-to Customer Name", recConvChar.ConvertCharacters(recPurchHead."Dist. Purch. Order No.")));
                //>> 18-02-20 ZY-LD 012
                //CurrFile.WRITE(STRSUBSTNO('Special Instruction,"%1 %2",',recPurchHead."SO Sell-to Customer No",recPurchHead."SO Sell-to Customer Name"));
                case pEiCardQueue."Eicard Type" of
                    pEiCardQueue."eicard type"::Consignment:
                        case pEiCardQueue."Customer No." of
                            '200001':
                                CurrFile.Write(StrSubstNo('Special Instruction,"%1 %2",', '', 'Studerus AG (licenses)'));
                        end;
                    pEiCardQueue."eicard type"::eCommerce:
                        //>> 30-04-24 ZY-LD 021 
                        CurrFile.Write(StrSubstNo('Special Instruction,$B!H(B%1 EC order$B!I(B),', pEiCardQueue."Customer No."));
                    /*case pEiCardQueue."Customer No." of
                        '200001':
                            CurrFile.Write(StrSubstNo('Special Instruction,"%1 %2",', '', 'Studerus EC order'));
                    end;*/
                    //<< 30-04-24 ZY-LD 021
                    else
                        CurrFile.Write(StrSubstNo('Special Instruction,"%1 %2",', '', pEiCardQueue."Customer Name"));
                end;
                //<< 18-02-20 ZY-LD 012
                CurrFile.Write(StrSubstNo('Additional E-mail List,%1,', ''));
                CurrFile.Write(StrSubstNo('Distributor PO#,%1,', recConvChar.ConvertCharacters(recPurchHead."Dist. Purch. Order No.")));
                CurrFile.Write(',,');
                CurrFile.Write('Order Line,,');
                CurrFile.Write('Part Number (*),Quantity (*),Request Date (*)');

                recPurchLine.SetRange("Document Type", recPurchHead."Document Type");
                recPurchLine.SetRange("Document No.", recPurchHead."No.");
                recPurchLine.SetRange(Type, recPurchLine.Type::Item);
                if recPurchLine.FindSet(true) then
                    repeat
                        //>> 17-02-20 ZY-LD 011
                        recPurchPrice.SetRange("Source Type", recPurchPrice."Source Type"::Vendor);
                        recPurchPrice.SetRange("Source No.", recPurchHead."Buy-from Vendor No.");
                        recPurchPrice.SetRange("Asset Type", recPurchPrice."Asset Type"::Item);
                        recPurchPrice.SetRange("Asset No.", recPurchLine."No.");
                        if recPurchPrice.IsEmpty then begin
                            PurchasePriceIsEmptyItemNo += recPurchLine."No." + ', ';  // 15-12-20 ZY-LD 016
                            PurchasePriceIsEmpty := true;
                        end;
                        //<< 17-02-20 ZY-LD 011

                        if recPurchLine."Requested Date From Factory" <> 0D then begin
                            if recPurchLine."Requested Date From Factory" < Today then begin
                                recPurchLine."Requested Date From Factory" := Today;
                                recPurchLine.Modify;
                            end;
                            CurrFile.Write(
                              StrSubstNo('%1,%2,%3,%4,%5,%6',
                                recPurchLine."No.",
                                Format(recPurchLine.Quantity, 0, 9),
                                Format(recPurchLine."Requested Date From Factory", 0, 9),
                                recPurchLine."EMS Machine Code",  // 15-10-19 ZY-LD 007
                                recPurchLine."GLC Serial No.",  // 23-02-23 ZY-LD 020
                                recPurchLine."GLC Mac Address"));  // 23-02-23 ZY-LD 020
                        end;
                    until recPurchLine.Next() = 0;
                CurrFile.Close;
                ConvCodePage.ConvertCodepage(ServerFilename, '', '', ConvCodePage.CodepageUTF8);

                if PurchasePriceIsEmpty then begin  // 17-02-20 ZY-LD 011
                                                    //>> 15-12-20 ZY-LD 016
                    if not pEiCardQueue."Purchase Price Reminder Sent" then begin
                        if not recUserSetup.Get(pEiCardQueue."Created By") then;
                        SI.SetMergefield(100, CopyStr(DelChr(PurchasePriceIsEmptyItemNo, '>', ', '), 1, 250));
                        EmailAddMgt.CreateSimpleEmail('HQMISSPP', '', recUserSetup."E-Mail");
                        EmailAddMgt.Send;
                        pEiCardQueue."Purchase Price Reminder Sent" := true;
                    end;
                    pEiCardQueue."Error Description" := lText003;
                    pEiCardQueue.Modify(true);
                    //<< 15-12-20 ZY-LD 016
                    FileMgt.DeleteServerFile(ServerFilename)  // 17-02-20 ZY-LD 011
                end else
                    if FTPMgt.UploadFile(recPurchHead."FTP Code", ServerFilename, RemoteFilename) then begin  // 04-11-19 ZY-LD 009
                        pEiCardQueue.Validate("Purchase Order Status", pEiCardQueue."purchase order status"::"EiCard Order Sent to HQ");
                        //pEiCardQueue.VALIDATE(Active,TRUE);  // 07-01-19 ZY-LD 010
                        pEiCardQueue.Modify(true);

                        //>> 20-11-20 ZY-LD 012
                        if pEiCardQueue."Eicard Type" = pEiCardQueue."eicard type"::eCommerce then begin
                            //pEiCardQueue.VALIDATE("Purchase Order Status",pEiCardQueue."Purchase Order Status"::"EiCard Order Sent to HQ");  // 30-06-20 ZY-LD 014
                            pEiCardQueue.Validate("Purchase Order Status", pEiCardQueue."purchase order status"::"EiCard Order Accepted");  // 30-06-20 ZY-LD 014
                            pEiCardQueue.Validate("Sales Order Status", pEiCardQueue."sales order status"::"EiCard Sent to Customer");
                            pEiCardQueue.Modify(true);  // This is made with an extra modify, so the first status change is added to change log.
                        end;
                        //<< 20-11-20 ZY-LD 012

                        rValue := true;
                        Commit;  // 23-03-20 ZY-LD 013
                    end else
                        Error(lText001, recPurchHead."No.");
            end;
        end;
        //<< 06-02-19 ZY-LD 001
    end;


    procedure OLD_CreatePO(var pSalesOrder: Record "Sales Header")
    var
        recVend: Record Vendor;
        recPurchSetup: Record "Purchases & Payables Setup";
        recPurchHead: Record "Purchase Header";
        recItem: Record Item;
        recSalesLine: Record "Sales Line";
        recPurchLine: Record "Purchase Line";
        recAutoSetup: Record "Automation Setup";
        PurchLineNo: Integer;
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        ArchiveManagement: Codeunit ArchiveManagement;
        recEiCardQueue: Record "EiCard Queue";
        lText002: label 'Customer No. in the EiCard Queue is wrong.';
        lText003: label 'Location Code on purchase is wrong. Please contact navsupport.';
        ReleaseDocument: Boolean;
        lText004: label '"%1" is an illigal charcter.';
        lText005: label 'Quantity %1 is wrong on %2 %3.';
    begin
        /*
        IF CONFIRM(Text014) THEN BEGIN
          // Check
          pSalesOrder.TESTFIELD("Sell-to Customer Name");
          pSalesOrder.TESTFIELD("External Document No.");
          IF StrPos(pSalesOrder."External Document No.",'°') <> 0 THEN  // 21-01-21 ZY-LD 017
            ERROR(lText004,'°');  // 21-01-21 ZY-LD 017
          pSalesOrder."Requested Delivery Date" := CALCDATE('+' + FORMAT(recPurchSetup."EiCard Lead Time") + 'D',TODAY);
        
          recPurchSetup.GET;
          recPurchSetup.TESTFIELD("EiCar Default Transport Method");
        
          recEiCardQueue.GET(pSalesOrder."No.");
          recEiCardQueue.TESTFIELD("From E-Mail Address");
          recEiCardQueue.TESTFIELD(recEiCardQueue."Distributor E-mail");
          recEiCardQueue.TESTFIELD("End User E-mail");
          IF recEiCardQueue."Customer No." <> pSalesOrder."Sell-to Customer No." THEN
            ERROR(lText002);
        
          // Create Purchase Header
          recPurchHead.INIT;
          recPurchHead.VALIDATE("Document Type",recPurchHead."Document Type"::Order);
          recPurchHead.INSERT(TRUE);
        
          recSalesLine.SETRANGE("Document Type",pSalesOrder."Document Type");
          recSalesLine.SETRANGE("Document No.",pSalesOrder."No.");
          recSalesLine.SETRANGE(Type,recSalesLine.Type::Item);
          recSalesLine.SETFILTER("No.",'<>%1','');
          recSalesLine.FINDFIRST;
          recItem.GET(recSalesLine."No.");
          recItem.TESTFIELD("SBU Company");
          recVend.SETRANGE("SBU Company",recItem."SBU Company");
          recVend.FINDFIRST;
        
          recPurchHead.VALIDATE("Buy-from Vendor No.",recVend."No.");
          recPurchHead.VALIDATE("Location Code",pSalesOrder."Location Code");
          recPurchHead.VALIDATE("Posting Date",TODAY);
          recPurchHead.VALIDATE("Order Date",TODAY);
          recPurchHead.VALIDATE(IsEICard,TRUE);
          recPurchHead.VALIDATE("Transport Method",recPurchSetup."EiCar Default Transport Method");
          recPurchHead.VALIDATE("EiCard Sales Order",pSalesOrder."No.");
        
          recPurchHead.VALIDATE("From SO No.",pSalesOrder."No.");
          recPurchHead.VALIDATE("SO Sell-to Customer Name",pSalesOrder."Sell-to Customer Name");
          recPurchHead.VALIDATE("Purchaser Code",pSalesOrder."Salesperson Code");
          recPurchHead.VALIDATE("Dist. PO#",pSalesOrder."External Document No.");
          recPurchHead.VALIDATE("EiCard Sales Order",pSalesOrder."No.");
          //recPurchHead.VALIDATE("EiCard Distributor Reference",pSalesOrder."EiCard Distributor Reference");  // 19-04-21 ZY-LD 018
          recPurchHead.VALIDATE("EiCard Distributor Reference",recEiCardQueue."Distributor Reference");  // 19-04-21 ZY-LD 018
          recPurchHead.VALIDATE("Create User ID",UserId());
          recPurchHead.VALIDATE("Doc. No. Occurrence",
            ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header",recPurchHead."Document Type",recPurchHead."No."));
          recPurchHead.MODIFY(TRUE);
        
          IF recPurchHead."Location Code" <> 'EICARD' THEN
            ERROR(lText003);
        
          // Create Purchase Lines
          recSalesLine.RESET;
          recSalesLine.SETRANGE("Document Type",pSalesOrder."Document Type");
          recSalesLine.SETRANGE("Document No.",pSalesOrder."No.");
          recSalesLine.SETRANGE("Quantity Shipped",0);
          IF recSalesLine.FINDSET(TRUE) THEN
            REPEAT
              //>> 12-09-22 ZY-LD 019
              IF recSalesLine.Quantity MOD 1 <> 0 THEN
                ERROR(lText005,recSalesLine.Quantity,recSalesLine."Document No.",recSalesLine."Line No.");
              //<< 12-09-22 ZY-LD 019
        
              PurchLineNo := PurchLineNo + 10000;
        
              CLEAR(recPurchLine);
              recPurchLine.VALIDATE("Document Type",recPurchHead."Document Type");
              recPurchLine.VALIDATE("Document No.",recPurchHead."No.");
              recPurchLine."Line No.":= PurchLineNo;
              recPurchLine.INSERT(TRUE);
        
              IF (recSalesLine.Type <> recSalesLine.Type::" ") THEN BEGIN
                recPurchLine.VALIDATE(Type,recSalesLine.Type);
                recPurchLine.VALIDATE("No.",recSalesLine."No.");
                recPurchLine.VALIDATE(Quantity,recSalesLine.Quantity);
                recPurchLine.VALIDATE("Requested Date From Factory",CALCDATE('+' + FORMAT(recPurchSetup."EiCard PO Lead Time") + 'D',TODAY));
                recPurchLine.VALIDATE("Expected Receipt Date",recPurchLine."Requested Date From Factory");
                recPurchLine."EMS Machine Code" := recSalesLine."EMS Machine Code";
                recPurchLine."GLC Serial No." := recSalesLine."GLC Serial No.";  // 23-02-23 ZY-LD 020
                recPurchLine."GLC Mac Address" := recSalesLine."GLC Mac Address";  // 23-02-23 ZY-LD 020
              END ELSE BEGIN
                recPurchLine.Description := recSalesLine.Description;
                recPurchLine."Description 2":= recSalesLine."Description 2";
              END;
              recPurchLine."Sales Order Number":= recSalesLine."Document No.";
              recPurchLine."Sales Line Number":= recSalesLine."Line No.";
              recPurchLine."Lock by Ref Document" := TRUE;
              recPurchLine.MODIFY(TRUE);
        
              recSalesLine."Lock by Ref Document":=TRUE;
              recSalesLine."Planned Delivery Date" := pSalesOrder."Requested Delivery Date";
              recSalesLine."Planned Shipment Date" := pSalesOrder."Requested Delivery Date";
              recSalesLine."Shipment Date" := pSalesOrder."Requested Delivery Date";
              recSalesLine."Shipment Date Confirmed" := TRUE;
              recSalesLine.MODIFY;
        
              ReleaseDocument := TRUE;
            UNTIL (recSalesLine.Next() = 0);
        
          IF ReleaseDocument THEN
            ReleasePurchDoc.PerformManualRelease(recPurchHead);
        
          recEiCardQueue.GET(pSalesOrder."No.");  // We need to
          recEiCardQueue."Purchase Order No." :=  recPurchHead."No.";
          recEiCardQueue."External Document No." := pSalesOrder."External Document No.";
          recEiCardQueue."External Document No." := CONVERTSTR(recEiCardQueue."External Document No.",'°','o');  // 21-01-21 ZY-LD 017
          recEiCardQueue."Customer No." := pSalesOrder."Sell-to Customer No.";
          recEiCardQueue."Customer Name" := pSalesOrder."Sell-to Customer Name";
          recEiCardQueue.VALIDATE("Sales Order Status",recEiCardQueue."Sales Order Status"::"Purchase Order Created");
          recEiCardQueue.VALIDATE(Active,TRUE);  // 07-01-19 ZY-LD 010
          recEiCardQueue."Eicard Type" := pSalesOrder."Eicard Type";  // 18-02-20 ZY-LD 012
          recEiCardQueue.MODIFY(TRUE);
        
          // 07-01-19 ZY-LD 010
          {SendToHQ(recEiCardQueue,FALSE);
        
          pSalesOrder."EiCard Sent" := TRUE;
          pSalesOrder.MODIFY;}
          recAutoSetup.GET;
          // 07-01-19 ZY-LD 010
        
          MESSAGE(Text005,recAutoSetup."Delay Between Create and eShop");
        END;
        */

    end;
}
