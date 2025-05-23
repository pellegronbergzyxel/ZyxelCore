Codeunit 50001 "ZyXEL EiCards"
{

    trigger OnRun()
    begin
    end;

    var
        recPurchSetup: Record "Purchases & Payables Setup";
        PurchLineNo: Integer;
        //ZGT: Codeunit "ZyXEL General Tools";
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
        recEiCardQueue: Record "EiCard Queue";
        EiCardLocation: Record Location;
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        ArchiveManagement: Codeunit ArchiveManagement;
        ReleaseDocument: Boolean;
        lText002: label 'Customer No. in the EiCard Queue is wrong.';
        lText003: label 'Location Code on purchase is wrong. Please contact navsupport.';
        lText004: label '"%1" is an illigal charcter.';
        lText005: label 'Quantity %1 is wrong on %2 %3.';
        lText006: label 'Quantity %1 and "%2" %3 does not match.';
        lText007: label 'Location for EiCards is not found';
    begin
        if Confirm(Text014) then begin
            recPurchSetup.Get();
            recPurchSetup.TestField("EiCar Default Transport Method");

            // Check
            pSalesOrder.TestField("Sell-to Customer Name");
            pSalesOrder.TestField("External Document No.");
            if StrPos(pSalesOrder."External Document No.", '°') <> 0 then
                Error(lText004, '°');
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
            recPurchHead.Init();
            recPurchHead.Validate("Document Type", recPurchHead."document type"::Order);
            recPurchHead.Insert(true);

            recSalesLine.SetRange("Document Type", pSalesOrder."Document Type");
            recSalesLine.SetRange("Document No.", pSalesOrder."No.");
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            recSalesLine.SetFilter("No.", '<>%1', '');
            recSalesLine.FindFirst();
            recItem.Get(recSalesLine."No.");
            recItem.TestField("SBU Company");
            recVend.SetRange("SBU Company", recItem."SBU Company");
            recVend.FindFirst();

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

            recPurchHead.Validate("EiCard Distributor Reference", recEiCardQueue."Distributor Reference");
            recPurchHead.Validate("Create User ID", UserId());
            recPurchHead.Validate("Doc. No. Occurrence",
              ArchiveManagement.GetNextOccurrenceNo(Database::"Purchase Header", recPurchHead."Document Type".AsInteger(), recPurchHead."No."));
            recPurchHead.Modify(true);

            //22-05-2025 BK #505159
            EiCardLocation.Setrange(EiCardLocation."Sales Order Type", EiCardLocation."Sales Order Type"::EICard);
            If EiCardLocation.FindFirst() then begin
                if recPurchHead."Location Code" <> EiCardLocation.Code then
                    Error(lText003);
            End else
                Error(lText007);
            //22-05-2025 BK #505159

            // Create Purchase Lines
            recSalesLine.Reset();
            recSalesLine.SetRange("Document Type", pSalesOrder."Document Type");
            recSalesLine.SetRange("Document No.", pSalesOrder."No.");
            recSalesLine.SetRange("Quantity Shipped", 0);
            if recSalesLine.FindSet(true) then
                repeat
                    if recSalesLine.Quantity MOD 1 <> 0 then
                        Error(lText005, recSalesLine.Quantity, recSalesLine."Document No.", recSalesLine."Line No.");

                    case recSalesLine.Type of
                        recSalesLine.Type::" ":
                            InsertPurchLine(pSalesOrder, recSalesLine, recPurchHead, recAddEicardOrderInfo, 0);
                        recSalesLine.Type::Item:
                            begin
                                recItem.Get(recSalesLine."No.");
                                if recItem."Enter Security for Eicard on" > recItem."enter security for eicard on"::" " then begin
                                    recAddEicardOrderInfo.SetRange("Document Type", recSalesLine."Document Type");
                                    recAddEicardOrderInfo.SetRange("Document No.", recSalesLine."Document No.");
                                    recAddEicardOrderInfo.SetRange("Sales Line Line No.", recSalesLine."Line No.");
                                    recAddEicardOrderInfo.SetRange(Validated, true);
                                    if recSalesLine.Quantity = recAddEicardOrderInfo.Count then begin
                                        if recAddEicardOrderInfo.FindSet() then
                                            repeat
                                                InsertPurchLine(pSalesOrder, recSalesLine, recPurchHead, recAddEicardOrderInfo, 1);
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
                    recSalesLine.Modify();

                    ReleaseDocument := true;
                until (recSalesLine.Next() = 0);

            if ReleaseDocument then
                ReleasePurchDoc.PerformManualRelease(recPurchHead);

            recEiCardQueue.Get(pSalesOrder."No.");  // We need to
            recEiCardQueue."Purchase Order No." := recPurchHead."No.";
            recEiCardQueue."External Document No." := pSalesOrder."External Document No.";
            recEiCardQueue."External Document No." := ConvertStr(recEiCardQueue."External Document No.", '°', 'o');
            recEiCardQueue."Customer No." := pSalesOrder."Sell-to Customer No.";
            recEiCardQueue."Customer Name" := CopyStr(pSalesOrder."Sell-to Customer Name", 1, 50); //22-05-225 BK #
            recEiCardQueue.Validate("Sales Order Status", recEiCardQueue."sales order status"::"Purchase Order Created");
            recEiCardQueue.Validate(Active, true);
            recEiCardQueue."Eicard Type" := pSalesOrder."Eicard Type";
            recEiCardQueue.Modify(true);

            recAutoSetup.Get();
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
        if (pSalesHead."Eicard Type" = pSalesHead."Eicard Type"::eCommerce) and recPurchLine.FindFirst() then begin
            recPurchLine.Validate(Quantity, recPurchLine.Quantity + pQuantity);
            recPurchLine.Modify(true);
        end else begin
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

        recPurchSetup: Record "Purchases & Payables Setup";
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        recServEnviron: Record "Server Environment";
        recPurchPrice: Record "Price List Line";
        recUserSetup: Record "User Setup";
        recConvChar: Record "Convert Characters";
        ConvCodePage: Codeunit "Convert Codepage";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";

        FileMgt: Codeunit "File Management";
        FTPMgt: Codeunit "VisionFTP Management";

        lText001: label 'Order %1 could not upload to eShop.';
        lText002: label 'Do you want to send "%1" to eShop from "%2"?';
        HQMISSPP: label 'HQMISSPP';
        CurrFile: File;

        SendFromTest: Boolean;
        PurchasePriceIsEmpty: Boolean;
        ServerFilename: Text;
        RemoteFilename: Text;
        PurchasePriceIsEmptyItemNo: Text;
        lText003: label 'Purchase Price is empty.';

    begin
        recPurchSetup.Get();
        if not recServEnviron.ProductionEnvironment() then begin
            recServEnviron.Get();
            if recPurchSetup."Send Orders To EShop" then
                SendFromTest := Confirm(lText002, false, pEiCardQueue."Purchase Order No.", recServEnviron.Environment);
        end;

        if (recServEnviron.ProductionEnvironment() and recPurchSetup."Send Orders To EShop") or
           (not recServEnviron.ProductionEnvironment() and recPurchSetup."Send Orders To EShop" and SendFromTest)
        then begin
            if recPurchHead.Get(recPurchHead."document type"::Order, pEiCardQueue."Purchase Order No.") and
              (recPurchHead.IsEICard) and
              ((not recPurchHead."EShop Order Sent") or (ReSend)) and  // ReSend is added.
              (not recPurchHead."Sent to HQ")  // The field name should have been "Do not Sent to HQ".
            then begin
                recPurchHead.TestField("FTP Code");
                pEiCardQueue."Error Description" := '';

                ServerFilename := FileMgt.ServerTempFileName('');
                RemoteFilename := StrSubstNo('%1.txt', recPurchHead."No.");
                CurrFile.TextMode(true);
                CurrFile.Create(ServerFilename);
                CurrFile.Write('Order Header,,');
                CurrFile.Write(recPurchSetup."EiCar Default Transport Method");
                CurrFile.Write(',');

                CurrFile.Write(StrSubstNo('Purchase Order No (*),%1,', recPurchHead."No."));
                CurrFile.Write(StrSubstNo('Shipping Mark,"SO#%1 / %2, %3",', recPurchHead."From SO No.", recPurchHead."SO Sell-to Customer Name", recConvChar.ConvertCharacters(recPurchHead."Dist. Purch. Order No.")));

                case pEiCardQueue."Eicard Type" of
                    pEiCardQueue."eicard type"::Consignment:
                        case pEiCardQueue."Customer No." of
                            '200001':
                                CurrFile.Write(StrSubstNo('Special Instruction,"%1 %2",', '', 'Studerus AG (licenses)'));
                        end;
                    pEiCardQueue."eicard type"::eCommerce:
                        CurrFile.Write(StrSubstNo('Special Instruction,$B!H(B%1 EC order$B!I(B),', pEiCardQueue."Customer No."));
                    else
                        CurrFile.Write(StrSubstNo('Special Instruction,"%1 %2",', '', pEiCardQueue."Customer Name"));
                end;

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

                        recPurchPrice.SetRange("Source Type", recPurchPrice."Source Type"::Vendor);
                        recPurchPrice.SetRange("Source No.", recPurchHead."Buy-from Vendor No.");
                        recPurchPrice.SetRange("Asset Type", recPurchPrice."Asset Type"::Item);
                        recPurchPrice.SetRange("Asset No.", recPurchLine."No.");
                        if recPurchPrice.IsEmpty then begin
                            PurchasePriceIsEmptyItemNo += recPurchLine."No." + ', ';
                            PurchasePriceIsEmpty := true;
                        end;


                        if recPurchLine."Requested Date From Factory" <> 0D then begin
                            if recPurchLine."Requested Date From Factory" < Today then begin
                                recPurchLine."Requested Date From Factory" := Today;
                                recPurchLine.Modify();
                            end;
                            CurrFile.Write(
                              StrSubstNo('%1,%2,%3,%4,%5,%6',
                                recPurchLine."No.",
                                Format(recPurchLine.Quantity, 0, 9),
                                Format(recPurchLine."Requested Date From Factory", 0, 9),
                                recPurchLine."EMS Machine Code",
                                recPurchLine."GLC Serial No.",
                                recPurchLine."GLC Mac Address"));
                        end;
                    until recPurchLine.Next() = 0;
                CurrFile.Close();
                ConvCodePage.ConvertCodepage(ServerFilename, '', '', ConvCodePage.CodepageUTF8());

                if PurchasePriceIsEmpty then begin

                    if not pEiCardQueue."Purchase Price Reminder Sent" then begin
                        if not recUserSetup.Get(pEiCardQueue."Created By") then;
                        SI.SetMergefield(100, CopyStr(DelChr(PurchasePriceIsEmptyItemNo, '>', ', '), 1, 250));
                        EmailAddMgt.CreateSimpleEmail(HQMISSPP, '', recUserSetup."E-Mail");
                        EmailAddMgt.Send();
                        pEiCardQueue."Purchase Price Reminder Sent" := true;
                    end;
                    pEiCardQueue."Error Description" := lText003;
                    pEiCardQueue.Modify(true);

                    FileMgt.DeleteServerFile(ServerFilename)
                end else
                    if FTPMgt.UploadFile(recPurchHead."FTP Code", ServerFilename, RemoteFilename) then begin
                        pEiCardQueue.Validate("Purchase Order Status", pEiCardQueue."purchase order status"::"EiCard Order Sent to HQ");
                        pEiCardQueue.Modify(true);

                        if pEiCardQueue."Eicard Type" = pEiCardQueue."eicard type"::eCommerce then begin
                            pEiCardQueue.Validate("Purchase Order Status", pEiCardQueue."purchase order status"::"EiCard Order Accepted");
                            pEiCardQueue.Validate("Sales Order Status", pEiCardQueue."sales order status"::"EiCard Sent to Customer");
                            pEiCardQueue.Modify(true);  // This is made with an extra modify, so the first status change is added to change log.
                        end;

                        rValue := true;
                        Commit();
                    end else
                        Error(lText001, recPurchHead."No.");
            end;
        end;
    end;


    procedure OLD_CreatePO(var pSalesOrder: Record "Sales Header")
    var

    begin

    end;
}
