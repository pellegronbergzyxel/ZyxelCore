Codeunit 50088 "Post Rcpt. Response Mgt."
{

    trigger OnRun()
    begin
        DownloadVCK(0, true);
        PostInboundOrderResp('');
    end;

    var
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";


    procedure DownloadAndPostPurchaseOrderResponse(ForcePosting: Boolean)
    var
        recAutoSetup: Record "Automation Setup";
    begin
        DownloadVCK(1, true);
        recAutoSetup.Get();
        if recAutoSetup.WhseIndbPostingAllowed() or
           (recAutoSetup."Post Inbound Response" and ForcePosting)
        then
            PostPurchaseOrderResponse('');
    end;


    procedure PostPurchaseOrderResponse(pRespNo: Code[20])
    begin
        PostInboundOrderResp(pRespNo);
    end;


    procedure PurchOrderRespImport(pEntryNo: Integer)
    var
        recZyFileMgt: Record "Zyxel File Management";
        recAutoSetup: Record "Automation Setup";
        EmailAddMgt: Codeunit "E-mail Address Management";
        xmlPurchOrderResp: XmlPort "Read Purchase Order Response";
        ArchiveFile: File;
        InStream: InStream;
        LastErrorText: Text;
        lText001: label 'Import VCK Response';
        lText002: label 'Document could not open.';

    begin
        recZyFileMgt.SetRange(Type, recZyFileMgt.Type::"VCK Purch. Response");
        recZyFileMgt.SetRange(Open, true);
        recZyFileMgt.SetFilter("On Hold", '%1', '');
        if pEntryNo <> 0 then
            recZyFileMgt.SetRange("Entry No.", pEntryNo);
        if recZyFileMgt.FindSet() then begin
            ZGT.OpenProgressWindow(lText001, recZyFileMgt.Count);
            repeat
                ZGT.UpdateProgressWindow(lText001, 0, true);
                if ArchiveFile.Open(recZyFileMgt.Filename) then begin
                    ArchiveFile.CreateInstream(InStream);
                    Clear(xmlPurchOrderResp);
                    xmlPurchOrderResp.SetSource(InStream);
                    xmlPurchOrderResp.Init(recZyFileMgt."Entry No.");
                    LastErrorText := '';
                    ClearLastError();

                    if xmlPurchOrderResp.Import() then begin
                        recZyFileMgt.Open := false;
                        recZyFileMgt."Error Text" := '';
                    end else
                        recZyFileMgt."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(recZyFileMgt."Error Text"));
                    recZyFileMgt.Modify();
                    ArchiveFile.Close();
                end else begin
                    recZyFileMgt."Error Text" := lText002;
                    recZyFileMgt.Modify();
                end;

                if recZyFileMgt."Error Text" <> '' then begin
                    recAutoSetup.Get();
                    if (recAutoSetup."Warehouse Import Error Date" = 0D) or (recAutoSetup."Warehouse Import Error Date" < Today) then begin
                        EmailAddMgt.CreateSimpleEmail('VCKIMPDOC', '', '');
                        EmailAddMgt.Send();

                        recAutoSetup."Warehouse Import Error Date" := Today;
                        recAutoSetup.Modify();
                    end;
                end;

                Commit();
            until recZyFileMgt.Next() = 0;
            ZGT.CloseProgressWindow();
        end;

    end;

    local procedure PostInboundOrderResp(pRespNo: Code[20])
    var
        recRespHead: Record "Rcpt. Response Header";
        recRespHead2: Record "Rcpt. Response Header";
        recRespHead3: Record "Rcpt. Response Header";
        recRespLine: Record "Rcpt. Response Line";
        recWhseInbHead: Record "Warehouse Inbound Header";
        recWhseSetup: Record "Warehouse Setup";
        recLocation: Record Location;
        recAutoSetup: Record "Automation Setup";
        PostResult: Boolean;
        lText001: label 'Posting Shipment Response';
        lText002: label '"%1" is not setup in "%2".';
        lText004: label 'Check "%1" on the response lines.';
    begin
        recRespHead2.SetCurrentkey("Customer Reference", "Warehouse Status");
        recRespHead3.SetCurrentkey("Customer Reference", "Warehouse Status");
        recRespHead.SetCurrentkey("Customer Reference", "Warehouse Status");
        recRespHead.SetRange(Open, true);
        recRespHead.SetFilter("On Hold", '%1', '');
        if pRespNo <> '' then
            recRespHead.SetRange("No.", pRespNo);
        if recRespHead.FindSet(true) then begin
            SI.SetWarehouseManagement(true);
            SI.SetHideSalesDialog(true);
            ZGT.OpenProgressWindow(lText001, recRespHead.Count);
            repeat
                ZGT.UpdateProgressWindow(lText001, 0, true);

                recWhseSetup.Get();
                if recWhseSetup."When Can We Post I-Resp. VCK" = recWhseSetup."when can we post i-resp. vck"::" " then
                    Error(lText002, recWhseSetup.FieldCaption("When Can We Post I-Resp. VCK"), recWhseSetup.TableCaption);

                recRespHead3.SetRange("Customer Reference", recRespHead."Customer Reference");
                recRespHead3.SetFilter("Warehouse Status", '<%1', recRespHead."Warehouse Status");
                recRespHead3.SetRange(Open, true);
                if recRespHead3.IsEmpty then begin
                    recRespHead2.SetRange("Customer Reference", recRespHead."Customer Reference");
                    recRespHead2.SetFilter("No.", '<>%1', recRespHead."No.");
                    recRespHead2.SetRange("Receipt Posted", true);

                    if (recRespHead."Warehouse Status" >= recWhseSetup."When Can We Post I-Resp. VCK") and
                       not recRespHead2.FindFirst()  // Searching for previous posted responce.
                    then begin
                        case recRespHead."Order Type Option" of
                            recRespHead."order type option"::"Purchase Order":
                                recRespLine.SetCurrentkey(Open, "Response No.", "Source Order No.", "Source Order Line No.");
                            recRespHead."order type option"::"Sales Return Order":
                                recRespLine.SetCurrentkey(Open, "Response No.", "Source Order No.", Location, "Source Order Line No.");
                        end;
                        //<< 13-08-20 ZY-LD 012
                        recRespLine.SetRange(Open, true);
                        recRespLine.SetRange("Response No.", recRespHead."No.");
                        recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.", "Warehouse Status", "Invoice No.");
                        if recRespLine.FindSet() then begin
                            recRespHead."After Post Description" := '';
                            if recWhseInbHead.Get(recRespHead."Customer Reference") then  // If it´s an old response, we don´t want receipt posted set.
                                recRespHead."Receipt Posted" := true;

                            repeat
                                recRespLine.SetRange("Source Order No.", recRespLine."Source Order No.");
                                recRespLine.SetRange("Real Source Order No.", recRespLine."Real Source Order No.");
                                if recRespHead."Order Type Option" = recRespHead."order type option"::"Purchase Order" then
                                    recRespLine.SetRange("Invoice No.", recRespLine."Invoice No.");
                                if recRespHead."Order Type Option" = recRespHead."order type option"::"Sales Return Order" then
                                    recRespLine.SetRange(Location, recRespLine.Location);
                                case recRespHead."Order Type Option" of
                                    recRespHead."order type option"::"Purchase Order":
                                        PostResult := PostPurchOrderRespDoc(recRespHead, recRespLine);
                                    recRespHead."order type option"::"Sales Return Order":
                                        begin
                                            EmailSalesReturnOrderInbound(recRespHead);
                                            UpdateSalesReturnOrderInbound(recRespHead, recRespLine);
                                            PostResult := PostSalesReturnOrderRespDoc(recRespHead, recRespLine);
                                            PostSalesReturnOrderRespDoc_Damage(recRespHead, recRespLine);
                                        end;
                                    recRespHead."order type option"::"Transfer Order":
                                        begin
                                            if (recLocation.get(recWhseInbHead."Sender No.") and recLocation."Post Transf. Ship. on Transit") and
                                               ((recRespHead."Warehouse Status" >= recAutoSetup."Ship. Post Transf Whse. Status") OR (recRespHead."Warehouse Status" = recRespHead."Warehouse Status"::"On Stock"))
                                            then
                                                PostInboundOrderRespShip(recRespHead, recRespLine);
                                            PostResult := PostTransferOrderRespDoc(recRespHead, recRespLine);
                                        end;
                                end;

                                if not PostResult then begin
                                    recRespHead."Receipt Posted" := false;
                                    recRespHead.CalcFields("Lines With Error");
                                    if recRespHead."Lines With Error" and (recRespHead."After Post Description" = '') then
                                        recRespHead."After Post Description" := StrSubstNo(lText004, recRespLine.FieldCaption("Error Text"));
                                end;
                                recRespHead.Modify(true);

                                if not recRespLine.FindLast() then;
                                recRespLine.SetRange("Source Order No.");
                                recRespLine.SetRange("Real Source Order No.");
                                recRespLine.SetRange(Location);
                                recRespLine.SetRange("Invoice No.");
                            until recRespLine.Next() = 0;
                        end;
                    end else begin
                        recRespLine.SetCurrentkey(Open, "Response No.", "Source Order No.", "Source Order Line No.");
                        recRespLine.SetRange("Response No.", recRespHead."No.");
                        recRespLine.SetRange(Open, true);
                        if recRespLine.FindSet() then
                            repeat
                                recRespLine.Validate(Open, false);
                                recRespLine.Modify(true);
                            until recRespLine.Next() = 0;
                    end;

                    UpdateInboundDocument(recRespHead);
                    recRespHead.Modify();
                    Commit();
                end;
            until recRespHead.Next() = 0;

            ZGT.CloseProgressWindow();
            SI.SetHideSalesDialog(false);
            SI.SetWarehouseManagement(false);
        end;
    end;

    local procedure PostPurchOrderRespDoc(var precRespHead: Record "Rcpt. Response Header"; precRespLine: Record "Rcpt. Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Rcpt. Response Line";
        recRespLineTmp: Record "Rcpt. Response Line" temporary;
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        recWhseRcptHead: Record "Warehouse Receipt Header";
        recWhseRcptLine: Record "Warehouse Receipt Line";
        recVend: Record Vendor;
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        PostWhseReceipt: Boolean;
        WhseRequestFound: Boolean;
        lText002: label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        lText004: label 'Warehouse Request was not found.';
        lText005: label 'You cannot handle more than the outstanding %1 units.';
        lText006: label 'Purchase Order "%1" was not found.';
        lText007: label 'Vendor No. %1 is blocked with "%2".';
    begin
        // Find Warehouse request
        SetWhseRcptLineFilter(precRespHead."Order Type Option", precRespLine, recWhseRcptLine, false);
        if recWhseRcptLine.FindFirst() then begin
            recWhseRcptHead.Get(recWhseRcptLine."No.");
            WhseRequestFound := true;
        end else begin
            recPurchHead.SetAutocalcFields("Completely Received");
            if not recPurchHead.Get(recPurchHead."document type"::Order, precRespLine."Real Source Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Real Source Order No.");
                precRespHead.Modify();
            end else
                if not recPurchHead."Completely Received" then
                    if recVend.Get(recPurchHead."Buy-from Vendor No.") and (recVend.Blocked = recVend.Blocked::" ") then begin
                        if recPurchHead.Status = recPurchHead.Status::Open then
                            ReleasePurchaseDocument.PerformManualRelease(recPurchHead);
                        if GetSourceDocInbound.CreateFromPurchOrderHideDialog(recPurchHead) then begin
                            recWhseRcptHead.SetRange("Purchase Order No.", recPurchHead."No.");
                            WhseRequestFound := recWhseRcptHead.FindLast();
                        end else
                            if precRespHead."After Post Description" = '' then begin
                                precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                precRespHead.Modify();
                            end;
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := StrSubstNo(lText007, recVend."No.", recVend.Blocked);
                            precRespHead.Modify();
                        end;
        end;

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseRcptHead."Posting Date" := Today;
            recWhseRcptHead.Modify();

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseRcptLine.SetRange("No.", recWhseRcptHead."No.");
            if recWhseRcptLine.FindSet(true) then
                repeat
                    recWhseRcptLine.Validate("Qty. to Receive", 0);
                    recWhseRcptLine.Modify(true);
                until recWhseRcptLine.Next() = 0;

            // Update and post values
            recWhseRcptLine.Reset();
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange("Real Source Order No.", precRespLine."Real Source Order No.");
            recRespLine.SetRange(Open, true);
            recRespLine.SetRange("Invoice No.", precRespLine."Invoice No.");  // 19-05-22 ZY-LD 019
            recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.", "Invoice No.");
            if recRespLine.FindSet(true) then begin
                recRespLine.ModifyAll("Error Text", '');

                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    SetWhseRcptLineFilter(precRespHead."Order Type Option", recRespLine, recWhseRcptLine, true);
                    if recWhseRcptLine.FindFirst() then begin
                        if recRespLine."Product No." = recWhseRcptLine."Item No." then begin
                            if (recWhseRcptLine."Qty. to Receive" + recRespLine.Quantity) <= recWhseRcptLine."Qty. Outstanding" then begin
                                recWhseRcptLine.Validate("Qty. to Receive", recWhseRcptLine."Qty. to Receive" + recRespLine.Quantity);
                                if recRespLine."Invoice No." <> '' then begin
                                    recWhseRcptLine.Validate("Warehouse Inbound No.", copystr(precRespHead."Customer Reference", 1, 20)); //04-07-2025 BK #515662
                                    recWhseRcptLine.Validate("Vendor Invoice No.", COpystr(recRespLine."Invoice No.", 1, 20)); //04-07-2025 BK #515662
                                end else
                                    recWhseRcptLine.Validate("Vendor Invoice No.", copystr(recRespLine."Value 1", 1, 20)); //04-07-2025 BK #515662
                                recWhseRcptLine.Modify(true);

                                recRespLineTmp := recRespLine;
                                recRespLineTmp.Insert();

                                PostWhseReceipt := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseRcptLine."Qty. Outstanding");
                                recRespLine.Modify();
                            end;
                        end else begin
                            recRespLine."Error Text" := StrSubstNo(lText003, recWhseRcptLine.FieldCaption("Item No."), recRespLine.TableCaption, recWhseRcptLine.TableCaption, recRespLine."Line No.");
                            recRespLine.Modify();
                        end;
                    end else
                        if recPurchLine.get(recPurchLine."Document Type"::Order, recRespLine."Real Source Order No.", recRespLine."Real Source Order Line No.") and
                           (recPurchLine."Outstanding Quantity" = 0)
                            then begin
                            recRespLine."Previously Posted" := true;
                            recRespLine.Open := false;
                            recRespLine."Error Text" := '';
                        end else
                            recRespLine."Error Text" :=
                              StrSubstNo(lText002,
                                recWhseRcptLine.TableCaption,
                                recWhseRcptLine.FieldCaption("Source No."), precRespLine."Source Order No.",
                                recWhseRcptLine.FieldCaption("Source Line No."), recRespLine."Source Order Line No.");
                    recRespLine.Modify();
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseReceipt then begin
                    Commit();
                    WhsePostReceipt.SetHideValidationDialog(true);
                    if WhsePostReceipt.Run(recWhseRcptLine) then
                        PostResultOK := WhsePostReceipt.GetCounterSourceDocOK() = 1;

                    // Update response lines
                    recRespLine.Reset();
                    if recRespLineTmp.FindSet() then
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false;
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify();
                            end;
                        until recRespLineTmp.Next() = 0;
                    Clear(WhsePostReceipt);
                end;
            end else
                PostResultOK := true;
        end else begin
            recRespLine.SetAutocalcFields("Warehouse Status", "Real Source Order No.", "Real Source Order Line No.");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange(Open, true);
            if recRespLine.FindSet(true) then
                repeat
                    if recPurchLine.get(recPurchLine."Document Type"::Order, recRespLine."Real Source Order No.", recRespLine."Real Source Order Line No.") and
                       (recPurchLine."Outstanding Quantity" = 0)  //<< 19-06-24 ZY-LD 025
                    then begin
                        recRespLine."Previously Posted" := true;
                        recRespLine.Open := false;
                        recRespLine."Error Text" := '';
                    end else
                        recRespLine."Error Text" := lText004;
                    recRespLine.Modify();
                until recRespLine.Next() = 0;
        end;
    end;

    local procedure PostSalesReturnOrderRespDoc(var precRespHead: Record "Rcpt. Response Header"; precRespLine: Record "Rcpt. Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Rcpt. Response Line";
        recRespLineTmp: Record "Rcpt. Response Line" temporary;
        recSalesHead: Record "Sales Header";
        recWhseRcptHead: Record "Warehouse Receipt Header";
        recWhseRcptLine: Record "Warehouse Receipt Line";
        recCust: Record Customer;
        recInvSetup: Record "Inventory Setup";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        PostWhseReceipt: Boolean;
        WhseRequestFound: Boolean;
        lText002: label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        lText004: label 'Warehouse Request was not found.';
        lText005: label 'You cannot handle more than the outstanding %1 units.';
        lText006: label 'Sales Return Order "%1" was not found.';
        lText007: label 'Customer No. %1 is blocked with "%2".';
        lText008: Label 'Quantity on response is zero.';
    begin
        // Find Warehouse request
        SetWhseRcptLineFilter(precRespHead."Order Type Option", precRespLine, recWhseRcptLine, false);
        if recWhseRcptLine.FindFirst() then begin
            recWhseRcptHead.Get(recWhseRcptLine."No.");
            WhseRequestFound := true;
        end else begin
            recSalesHead.SetAutocalcFields("Completely Shipped");
            if not recSalesHead.Get(recSalesHead."document type"::"Return Order", precRespLine."Real Source Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Real Source Order No.");
                precRespHead.Modify();
            end else
                if not recSalesHead."Completely Shipped" then
                    if recCust.Get(recSalesHead."Sell-to Customer No.") and (recCust.Blocked = recCust.Blocked::" ") then begin
                        if recSalesHead.Status = recSalesHead.Status::Open then
                            ReleaseSalesDocument.PerformManualRelease(recSalesHead);

                        if GetSourceDocInbound.CreateFromSalesReturnOrderHideDialog(recSalesHead) then begin
                            recWhseRcptHead.SetRange("Sales Return Order No.", recSalesHead."No.");
                            WhseRequestFound := recWhseRcptHead.FindLast();
                        end else
                            if precRespHead."After Post Description" = '' then begin
                                precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                precRespHead.Modify();
                            end;
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := StrSubstNo(lText007, recCust."No.", recCust.Blocked);
                            precRespHead.Modify();
                        end;
        end;

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseRcptHead."Posting Date" := Today;
            recWhseRcptHead.Modify();

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseRcptLine.SetRange("No.", recWhseRcptHead."No.");
            if recWhseRcptLine.FindSet(true) then
                repeat
                    recWhseRcptLine.Validate("Qty. to Receive", 0);
                    recWhseRcptLine.Modify(true);
                until recWhseRcptLine.Next() = 0;

            // Update and post values
            recWhseRcptLine.Reset();
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange("Real Source Order No.", precRespLine."Real Source Order No.");
            recRespLine.SetRange(Open, true);
            recRespLine.SetRange(Location, ItemLogisticEvent.GetMainWarehouseLocation()); //We will only post main warehouse locations.
            recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.");
            if recRespLine.FindSet(true) then begin
                recRespLine.ModifyAll("Error Text", '');
                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    SetWhseRcptLineFilter(precRespHead."Order Type Option", recRespLine, recWhseRcptLine, true);
                    if recWhseRcptLine.FindFirst() then begin
                        if recRespLine."Product No." = recWhseRcptLine."Item No." then begin
                            if recWhseRcptLine."Location Code" = recRespLine.Location then begin  // 06-05-22 ZY-LD 018
                                if (recWhseRcptLine."Qty. to Receive" + recRespLine.Quantity) <= recWhseRcptLine."Qty. Outstanding" then begin
                                    if recRespLine.Quantity <> 0 then begin  // 28-05-24 ZY-LD 024
                                        recWhseRcptLine.Validate("Qty. to Receive", recWhseRcptLine."Qty. to Receive" + recRespLine.Quantity);
                                        recWhseRcptLine.Validate("Warehouse Inbound No.", Copystr(precRespHead."Customer Reference", 1, 20)); //04-07-2025 BK #515662
                                        recWhseRcptLine.Modify(true);

                                        recRespLineTmp := recRespLine;
                                        recRespLineTmp.Insert();

                                        PostWhseReceipt := true;
                                    end else begin
                                        recRespLine.Open := false;
                                        recRespLine.Modify();
                                    end;
                                end else begin
                                    if recRespLine.Quantity = 0 then
                                        recRespLine."Error Text" := lText008
                                    else
                                        recRespLine."Error Text" := StrSubstNo(lText005, recWhseRcptLine."Qty. Outstanding");
                                    recRespLine.Modify();
                                end;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText003, recWhseRcptLine.FieldCaption("Location Code"), recRespLine.TableCaption, recWhseRcptLine.TableCaption, recRespLine."Line No.");
                                recRespLine.Modify();
                            end;
                        end else begin
                            recRespLine."Error Text" := StrSubstNo(lText003, recWhseRcptLine.FieldCaption("Item No."), recRespLine.TableCaption, recWhseRcptLine.TableCaption, recRespLine."Line No.");
                            recRespLine.Modify();
                        end;
                    end else
                        if (recRespLine.Quantity = recRespLine."Purchase Order Qty. Received") or
                           (recRespLine.Quantity = recRespLine."Purchase Order Qty. Invoiced")
                        then begin
                            recRespLine."Previously Posted" := true;
                            recRespLine.Open := false;
                        end else
                            recRespLine."Error Text" :=
                              StrSubstNo(lText002,
                                recWhseRcptLine.TableCaption,
                                recWhseRcptLine.FieldCaption("Source No."), precRespLine."Source Order No.",
                                recWhseRcptLine.FieldCaption("Source Line No."), recRespLine."Source Order Line No.");
                    recRespLine.Modify();
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseReceipt then begin
                    Commit();
                    recWhseRcptLine.SetRange("Source Line No.");  // 08-07-22 ZY-LD 020
                    WhsePostReceipt.SetHideValidationDialog(true);
                    if WhsePostReceipt.Run(recWhseRcptLine) then
                        PostResultOK := WhsePostReceipt.GetCounterSourceDocOK() = 1;

                    //>> 10-06-20 ZY-LD 009
                    if PostResultOK then begin
                        recInvSetup.Get();
                        if recWhseRcptHead."Location Code" = recInvSetup."AIT Location Code" then begin
                            recWhseRcptHead.DeleteUnpostedSalesReturnOrderLines();
                            if recWhseRcptHead.Get(recWhseRcptHead."No.") then  // 29-06-20 ZY-LD 010
                                if not recWhseRcptHead.Delete() then;
                        end;
                    end;
                    //<< 10-06-20 ZY-LD 009

                    // Update response lines
                    recRespLine.Reset();
                    if recRespLineTmp.FindSet() then begin
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false;
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify();
                            end;
                        until recRespLineTmp.Next() = 0;
                        Commit();
                    end;
                    Clear(WhsePostReceipt);
                end;
            end else
                PostResultOK := true;
        end else begin
            recRespLine.SetAutocalcFields("Warehouse Status", "Purchase Order Qty. Received", "Purchase Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange(Open, true);
            recRespLine.SetRange(Location, ItemLogisticEvent.GetMainWarehouseLocation());
            if recRespLine.FindSet(true) then
                repeat
                    if (recRespLine.Quantity = recRespLine."Purchase Order Qty. Received") or
                       (recRespLine.Quantity = recRespLine."Purchase Order Qty. Invoiced") or
                        recSalesHead."Completely Shipped"
                    then begin
                        recRespLine."Previously Posted" := true;
                        recRespLine.Open := false;
                    end else
                        recRespLine."Error Text" := lText004;
                    recRespLine.Modify();
                until recRespLine.Next() = 0;
        end;

    end;

    local procedure PostSalesReturnOrderRespDoc_Damage(var precRespHead: Record "Rcpt. Response Header"; precRespLine: Record "Rcpt. Response Line")
    var
        recRespLine: Record "Rcpt. Response Line";
        recRespLine2: Record "Rcpt. Response Line";
        recSalesHead: Record "Sales Header";
        recSalesHead2: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recCredMemoHead: Record "Sales Cr.Memo Header";
        recSalesOrderHead: Record "Sales Header";
        recSalesOrderLine: Record "Sales Line";
        recWhseIndbHead: Record "Warehouse Inbound Header";
        recLocation: Record Location;
        SalesPost: Codeunit "Sales-Post";
        LogisticEvent: Codeunit "Item / Logistic Events";
        SI: Codeunit "Single Instance";
        EmailAddMgt: Codeunit "E-mail Address Management";
        FileMgt: Codeunit "File Management";
        NewLineNo: Integer;
        ServerFilename: Text;
        ClientFilename: Text;
        Recipents: Text;
        lText001: label 'Sales Credit Memo %1.pdf';
        lText002: label 'tim.may@zyxel.eu';

    begin
        // Post items to other locations
        recRespLine.SetCurrentkey("Response No.", Location, Open);
        recRespLine.SetRange("Response No.", precRespHead."No.");
        recRespLine.SetRange(Open, true);
        if recRespLine.FindSet(true) then begin
            recWhseIndbHead.Get(precRespHead."Customer Reference");
            recSalesHead2.Get(recSalesHead2."document type"::"Return Order", recWhseIndbHead."Shipment No.");

            SI.SetHideSalesDialog(true);
            SI.SetKeepLocationCode(true);
            SI.SetSkipErrorOnBlockOnOrder(true);
            SI.SetPostDamage(true);
            SI.SetSkipErrorOnBlockOnOrder(true);

            repeat

                if ((recRespLine.Location <> LogisticEvent.GetMainWarehouseLocation()) and (recRespLine.Location <> '')) or
                   ((recRespLine.Location = LogisticEvent.GetMainWarehouseLocation()) and (recRespLine."Real Source Order Line No." = 0))
                then begin
                    recRespLine.SetRange(Location, recRespLine.Location);
                    if recRespLine.Location = LogisticEvent.GetMainWarehouseLocation() then
                        recRespLine.SetRange("Real Source Order Line No.", 0);
                    if recRespLine.FindSet(true) then begin
                        Clear(recSalesHead);
                        recSalesHead.SetHideValidationDialog(true);
                        recSalesHead.Init();
                        recSalesHead.Validate("Document Type", recSalesHead."document type"::"Credit Memo");
                        recSalesHead.Insert(true);
                        recSalesHead.Validate("Sell-to Customer No.", recSalesHead2."Sell-to Customer No.");
                        recSalesHead.Validate("Posting Date", Today);
                        recSalesHead.Validate("Location Code", recRespLine.Location);
                        recSalesHead.Modify(true);

                        Clear(recSalesOrderHead);
                        recSalesOrderHead.SetHideValidationDialog(true);
                        recSalesOrderHead.Init();
                        recSalesOrderHead.Validate("Document Type", recSalesOrderHead."document type"::Order);
                        recSalesOrderHead.Insert(true);
                        recSalesOrderHead.Validate("Sales Order Type", recSalesOrderHead."sales order type"::Normal);
                        recSalesOrderHead.Validate("Sell-to Customer No.", recSalesHead2."Sell-to Customer No.");
                        recSalesOrderHead.Validate("Posting Date", Today);
                        recSalesOrderHead.Validate("Location Code", recRespLine.Location);
                        recSalesOrderHead.Validate("External Document No.", StrSubstNo('%1 - %2', recWhseIndbHead."Shipment No.", recSalesOrderHead."Location Code"));
                        recSalesOrderHead.Validate("Send Mail", false);
                        recSalesOrderHead.Modify(true);

                        NewLineNo := 0;
                        recLocation.get(recRespLine.Location);
                        recLocation.TestField("Default Return Reason Code");
                        repeat
                            NewLineNo += 10000;

                            Clear(recSalesLine);
                            recSalesLine.SetHideValidationDialog(true);
                            recSalesLine.Init();
                            recSalesLine.Validate("Document Type", recSalesHead."Document Type");
                            recSalesLine.Validate("Document No.", recSalesHead."No.");
                            recSalesLine.Validate("Line No.", NewLineNo);
                            recSalesLine.Validate(Type, recSalesLine.Type::Item);
                            recSalesLine.Validate("No.", recRespLine."Product No.");
                            recSalesLine.Validate("Location Code", recRespLine.Location);
                            recSalesLine.Validate(Quantity, recRespLine.Quantity);
                            recSalesLine.Validate("Return Reason Code", recLocation."Default Return Reason Code");
                            recSalesLine.Validate("Unit Price", 0);
                            recSalesLine.Validate("Zero Unit Price Accepted", true);
                            recSalesLine.Insert(true);

                            Clear(recSalesOrderLine);
                            recSalesOrderLine.SetHideValidationDialog(true);
                            recSalesOrderLine.Init();
                            recSalesOrderLine.Validate("Document Type", recSalesOrderHead."Document Type");
                            recSalesOrderLine.Validate("Document No.", recSalesOrderHead."No.");
                            recSalesOrderLine.Validate("Line No.", NewLineNo);
                            recSalesOrderLine.Validate(Type, recSalesOrderLine.Type::Item);
                            recSalesOrderLine.Validate("No.", recRespLine."Product No.");
                            recSalesOrderLine.Validate("Location Code", recRespLine.Location);
                            recSalesOrderLine.Validate(Quantity, recRespLine.Quantity);
                            recSalesOrderLine.Validate("Unit Price", 0);
                            recSalesOrderLine.Validate("Zero Unit Price Accepted", true);
                            recSalesOrderLine.Insert(true);

                            recRespLine2 := recRespLine;
                            recRespLine2.Open := false;
                            recRespLine2."Error Text" := '';
                            recRespLine2.Modify();
                        until recRespLine.Next() = 0;

                        recRespLine.SetRange(Location);
                        recRespLine.SetRange("Real Source Order Line No.");

                        SalesPost.Run(recSalesHead);
                        if recCredMemoHead.Get(recSalesHead."No.") then begin
                            ServerFilename := FileMgt.ServerTempFileName('');
                            ClientFilename := StrSubstNo(lText001, recCredMemoHead."No.");
                            SI.SetMergefield(100, recRespLine.Location);
                            if recRespLine.Location = LogisticEvent.GetMainWarehouseLocation() then
                                Recipents := lText002;

                            recCredMemoHead.SetRange("No.", recCredMemoHead."No.");
                            Report.SaveAsPdf(Report::"Sales - Credit Memo RHQ", ServerFilename, recCredMemoHead);
                            Clear(EmailAddMgt);
                            EmailAddMgt.SetSalesHeaderMergeFields(recSalesOrderHead."Document Type", recSalesOrderHead."No.");
                            EmailAddMgt.SetCustomerMergefields(recSalesOrderHead."Sell-to Customer No.");
                            EmailAddMgt.CreateEmailWithAttachment('VCKDAMCRM', '', Recipents, ServerFilename, ClientFilename, false);  //  Recipents added.
                            EmailAddMgt.Send();
                            FileMgt.DeleteServerFile(ServerFilename);
                        end;
                    end;
                end;
            until recRespLine.Next() = 0;

            SI.SetHideSalesDialog(false);
            SI.SetKeepLocationCode(false);
            SI.SetSkipErrorOnBlockOnOrder(false);
            SI.SetPostDamage(false);
            SI.SetSkipErrorOnBlockOnOrder(false);
        end;
    end;

    local procedure UpdateSalesReturnOrderInbound(var precRespHead: Record "Rcpt. Response Header"; precRespLine: Record "Rcpt. Response Line")
    var
        recRespLine: Record "Rcpt. Response Line";
        recRespLineTmp: Record "Rcpt. Response Line" temporary;
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recWhseIndbHead: Record "Warehouse Inbound Header";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        ArchiveMgt: Codeunit ArchiveManagement;
        EmailAddMgt: Codeunit "E-mail Address Management";
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
        //SI: Codeunit "Single Instance"; also defined globally
        SalesQtyIsChanged: Boolean;
    begin
        //>> 02-06-22 ZY-LD 015
        // The Sales Return Order is updated with the quantity from the warehouse response. Only main warehouse location counts.
        if not precRespHead."Order has been Updated" then begin
            recWhseIndbHead.Get(precRespHead."Customer Reference");

            recRespLine.SetCurrentkey("Response No.", "Response Line No.");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange("Real Source Order No.", recWhseIndbHead."Shipment No.");
            recRespLine.SetFilter("Real Source Order Line No.", '<>0');
            recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.");
            if recRespLine.FindSet() then
                repeat
                    recRespLineTmp.SetRange("Source Order No.", recRespLine."Source Order No.");
                    recRespLineTmp.SetRange("Source Order Line No.", recRespLine."Source Order Line No.");
                    if not recRespLineTmp.FindFirst() then begin
                        recRespLineTmp := recRespLine;
                        if recRespLine.Location <> ItemLogisticEvent.GetMainWarehouseLocation() then
                            recRespLineTmp.Quantity := 0;
                        recRespLineTmp.Insert();
                    end else
                        if recRespLine.Location = ItemLogisticEvent.GetMainWarehouseLocation() then begin
                            recRespLineTmp.Quantity := recRespLineTmp.Quantity + recRespLine.Quantity;
                            recRespLineTmp.Modify();
                        end;
                until recRespLine.Next() = 0;

            recRespLineTmp.SetCurrentkey("Response No.", "Response Line No.");
            recRespLineTmp.SetAutocalcFields("Real Source Order No.");
            if recRespLineTmp.FindSet() then begin
                recSalesHead.Get(recSalesHead."document type"::"Return Order", recRespLineTmp."Real Source Order No.");
                repeat
                    if recSalesLine.Get(recSalesHead."Document Type", recRespLineTmp."Real Source Order No.", recRespLineTmp."Real Source Order Line No.") then
                        if recSalesLine.Quantity <> recRespLineTmp.Quantity then begin
                            if recSalesHead.Status = recSalesHead.Status::Released then begin
                                ReleaseSalesDocument.Reopen(recSalesHead);
                                SalesHeadEvent.DeleteWarehouseReceipt(recSalesHead, false);
                                ArchiveMgt.ArchSalesDocumentNoConfirm(recSalesHead);
                            end;

                            recSalesLine.SuspendStatusCheck(true);
                            recSalesLine.Validate(Quantity, recRespLineTmp.Quantity);
                            recSalesLine.Modify(true);
                            recSalesLine.SuspendStatusCheck(false);
                            SalesQtyIsChanged := true;
                        end;

                until recRespLineTmp.Next() = 0;

                if SalesQtyIsChanged then begin
                    ReleaseSalesDocument.PerformManualRelease(recSalesHead);
                    SalesHeadEvent.CreateWarehouseReceipt(recSalesHead);

                    ArchiveMgt.ArchSalesDocumentNoConfirm(recSalesHead);
                    EmailAddMgt.SetSalesHeaderMergeFields(recSalesHead."Document Type", recSalesHead."No.");
                    EmailAddMgt.CreateSimpleEmail('VCKCNGQTY', '', '');
                    EmailAddMgt.Send();
                end;
            end;

            precRespHead."Order has been Updated" := true;
            precRespHead.Modify();
        end;
    end;

    local procedure EmailSalesReturnOrderInbound(var precRespHead: Record "Rcpt. Response Header")
    var
        recSalesHead: Record "Sales Header";
        recRcptRespHead: Record "Rcpt. Response Header";
        recWhseIndbHead: Record "Warehouse Inbound Header";
        FileMgt: Codeunit "File Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        ServerFilename: Text;
        ClientFilename: Text;
        Str: Text;
        FileLabel: label 'Sales Return Order %1.xlsx';
    begin
        if not precRespHead."Response Document Send" then begin
            recWhseIndbHead.Get(precRespHead."Customer Reference");
            recSalesHead.Get(recSalesHead."document type"::"Return Order", recWhseIndbHead."Shipment No.");

            ServerFilename := FileMgt.ServerTempFileName('');
            str := FileLabel;
            ClientFilename := StrSubstNo(Str, precRespHead."Shipment No.");
            recRcptRespHead.SetRange("No.", precRespHead."No.");
            Report.SaveAsExcel(Report::"Rcpt. Inbound Document", ServerFilename, recRcptRespHead);

            EmailAddMgt.SetSalesHeaderMergeFields(recSalesHead."Document Type", recSalesHead."No.");
            EmailAddMgt.CreateEmailWithAttachment('VCKRESPONS', '', '', ServerFilename, ClientFilename, false);
            EmailAddMgt.Send();

            FileMgt.DeleteServerFile(ServerFilename);

            precRespHead."Response Document Send" := true;
            precRespHead.Modify();
        end;
    end;

    local procedure PostTransferOrderRespDoc(var precRespHead: Record "Rcpt. Response Header"; precRespLine: Record "Rcpt. Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Rcpt. Response Line";
        recRespLineTmp: Record "Rcpt. Response Line" temporary;
        recTransHead: Record "Transfer Header";
        recWhseRcptHead: Record "Warehouse Receipt Header";
        recWhseRcptLine: Record "Warehouse Receipt Line";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        WhseRequestFound: Boolean;
        PostWhseReceipt: Boolean;
        lText002: label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        lText004: label 'Warehouse Request was not found.';
        lText005: label 'You cannot handle more than the outstanding %1 units.';
        lText006: label 'Transfer Order "%1" was not found.';
    begin
        // Find Warehouse request
        SetWhseRcptLineFilter(precRespHead."Order Type Option", precRespLine, recWhseRcptLine, false);
        if recWhseRcptLine.FindFirst() then begin
            recWhseRcptHead.Get(recWhseRcptLine."No.");
            WhseRequestFound := true;
        end else begin
            recTransHead.SetAutocalcFields("Completely Received");
            if not recTransHead.Get(precRespLine."Real Source Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Real Source Order No.");
                precRespHead.Modify();
            end else
                if not recTransHead."Completely Received" then begin
                    if recTransHead.Status = recTransHead.Status::Open then
                        ReleaseTransferDocument.Run(recTransHead);
                    if GetSourceDocInbound.CreateFromInbndTransferOrderHideDialog(recTransHead) then begin
                        recWhseRcptHead.SetRange("Transfer Order No.", recTransHead."No.");
                        WhseRequestFound := recWhseRcptHead.FindLast();
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                            precRespHead.Modify();
                        end;
                end;
        end;

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseRcptHead."Posting Date" := Today;
            recWhseRcptHead.Modify();

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseRcptLine.SetRange("No.", recWhseRcptHead."No.");
            if recWhseRcptLine.FindSet(true) then
                repeat
                    recWhseRcptLine.Validate("Qty. to Receive", 0);
                    recWhseRcptLine.Modify(true);
                until recWhseRcptLine.Next() = 0;

            // Update and post values
            recWhseRcptLine.Reset();
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange("Real Source Order No.", precRespLine."Real Source Order No.");
            recRespLine.SetRange(Open, true);
            recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.", "Invoice No.");
            if recRespLine.FindSet(true) then begin
                recRespLine.ModifyAll("Error Text", '');

                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    SetWhseRcptLineFilter(precRespHead."Order Type Option", recRespLine, recWhseRcptLine, true);
                    if recWhseRcptLine.FindFirst() then begin
                        if recRespLine."Product No." = recWhseRcptLine."Item No." then begin
                            if (recWhseRcptLine."Qty. to Receive" + recRespLine.Quantity) <= recWhseRcptLine."Qty. Outstanding" then begin
                                recWhseRcptLine.Validate("Qty. to Receive", recWhseRcptLine."Qty. to Receive" + recRespLine.Quantity);
                                if recRespLine."Invoice No." <> '' then begin
                                    recWhseRcptLine.Validate("Warehouse Inbound No.", precRespHead."Customer Reference");
                                    recWhseRcptLine.Validate("Vendor Invoice No.", recRespLine."Invoice No.");
                                end else
                                    recWhseRcptLine.Validate("Vendor Invoice No.", recRespLine."Value 1");
                                recWhseRcptLine.Modify(true);

                                recRespLineTmp := recRespLine;
                                recRespLineTmp.Insert();

                                PostWhseReceipt := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseRcptLine."Qty. Outstanding");
                                recRespLine.Modify();
                            end;
                        end else begin
                            recRespLine."Error Text" := StrSubstNo(lText003, recWhseRcptLine.FieldCaption("Item No."), recRespLine.TableCaption, recWhseRcptLine.TableCaption, recRespLine."Line No.");
                            recRespLine.Modify();
                        end;
                    end else
                        if (recRespLine.Quantity = recRespLine."Purchase Order Qty. Received") or
                           (recRespLine.Quantity = recRespLine."Purchase Order Qty. Invoiced")
                        then begin
                            recRespLine."Previously Posted" := true;
                            recRespLine.Open := false;
                        end else
                            recRespLine."Error Text" :=
                              StrSubstNo(lText002,
                                recWhseRcptLine.TableCaption,
                                recWhseRcptLine.FieldCaption("Source No."), precRespLine."Source Order No.",
                                recWhseRcptLine.FieldCaption("Source Line No."), recRespLine."Source Order Line No.");
                    recRespLine.Modify();
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseReceipt then begin
                    Commit();
                    WhsePostReceipt.SetHideValidationDialog(true);
                    if WhsePostReceipt.Run(recWhseRcptLine) then
                        PostResultOK := WhsePostReceipt.GetCounterSourceDocOK() = 1;
                    recRespLine.Reset();
                    if recRespLineTmp.FindSet() then
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false;
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify();
                            end;
                        until recRespLineTmp.Next() = 0;
                    Clear(WhsePostReceipt);
                end;
            end else
                PostResultOK := true;
        end else begin
            recRespLine.SetAutocalcFields("Warehouse Status", "Purchase Order Qty. Received", "Purchase Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange(Open, true);
            if recRespLine.FindSet(true) then
                repeat
                    if (recRespLine.Quantity = recRespLine."Purchase Order Qty. Received") or
                        (recRespLine.Quantity = recRespLine."Purchase Order Qty. Invoiced")
                    then begin
                        recRespLine."Previously Posted" := true;
                        recRespLine.Open := false;
                    end else
                        recRespLine."Error Text" := lText004;
                    recRespLine.Modify();
                until recRespLine.Next() = 0;
        end;
    end;

    local procedure PostInboundOrderRespShip(var precRespHead: Record "Rcpt. Response Header"; precRespLine: Record "Rcpt. Response Line") PostResultOK: Boolean
    var
        recRespHead2: Record "Rcpt. Response Header";
        recRespLine: Record "Rcpt. Response Line";
        lText001: Label 'Check "%1" on the response lines"';

    begin
        //>> 02-11-23 ZY-LD 022
        recRespHead2.SETRANGE("Customer Reference", precRespHead."Customer Reference");
        recRespHead2.SETFILTER("No.", '<>%1', precRespHead."No.");
        recRespHead2.SETRANGE("Ship Posted", TRUE);
        IF NOT recRespHead2.FINDFIRST() THEN BEGIN  // Searching for previous posted responce.
            recRespLine.RESET();
            recRespLine.SETCURRENTKEY("Response No.", "Customer Order No.", "Customer Order Line No.");
            recRespLine.SETAUTOCALCFIELDS("Warehouse Status");
            recRespLine.SETRANGE("Response No.", precRespHead."No.");
            recRespLine.SETRANGE("Open - Shipment", TRUE);
            IF recRespLine.FINDSET() THEN BEGIN
                precRespHead."After Post Description" := '';
                precRespHead."Ship Posted" := TRUE;

                REPEAT
                    recRespLine.SETRANGE("Customer Order No.", recRespLine."Customer Order No.");
                    PostResultOK := PostTransferOrderRespDocShip(precRespHead, precRespLine);

                    IF NOT PostResultOK THEN BEGIN
                        precRespHead."Receipt Posted" := FALSE;
                        precRespHead.CALCFIELDS("Lines With Error");
                        IF precRespHead."Lines With Error" AND (precRespHead."After Post Description" = '') THEN
                            precRespHead."After Post Description" := STRSUBSTNO(lText001, recRespLine.FIELDCAPTION("Error Text"));
                    END;

                    IF NOT recRespLine.FINDLAST() THEN;
                    recRespLine.SETRANGE("Customer Order No.");
                UNTIL recRespLine.NEXT() = 0;
            end;
        end;
    end;

    local procedure PostTransferOrderRespDocShip(var precRespHead: Record "Rcpt. Response Header"; precRespLine: Record "Rcpt. Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Rcpt. Response Line";
        recRespLineTmp: Record "Rcpt. Response Line" temporary;
        recTransHead: Record "Transfer Header";
        recWhseShipHead: Record "Warehouse Shipment Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        PostWhseReceipt: Boolean;
        WhseRequestFound: Boolean;
        lText002: label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        lText004: label 'Warehouse Request was not found.';
        lText005: label 'You cannot handle more than the outstanding %1 units.';
        lText006: label 'Transfer Order "%1" was not found.';
    begin
        // Find Warehouse request
        recWhseShipLine.SETRANGE("Source Type", DATABASE::"Transfer Line");
        recWhseShipLine.SETRANGE("Source Document", recWhseShipLine."Source Document"::"Inbound Transfer");
        recWhseShipLine.SetRange("Source No.", precRespLine."Real Source Order No.");
        recWhseShipLine.SetRange("Source Line No.", precRespLine."Real Source Order Line No.");

        if recWhseShipLine.FindFirst() then begin
            recWhseShipHead.Get(recWhseShipLine."No.");
            WhseRequestFound := true;
        end else begin
            recTransHead.SetAutocalcFields("Completely Shipped");
            if not recTransHead.Get(precRespLine."Real Source Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Real Source Order No.");
                precRespHead.Modify();
            end else
                if not recTransHead."Completely Shipped" then begin
                    if recTransHead.Status = recTransHead.Status::Open then
                        ReleaseTransferDocument.Run(recTransHead);
                    if GetSourceDocOutbound.CreateFromOutbndTransferOrderHideDialog(recTransHead) then begin
                        recWhseShipHead.SetRange("Transfer Order No.", recTransHead."No.");
                        WhseRequestFound := recWhseShipHead.FindLast();
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                            precRespHead.Modify();
                        end;
                end;
        end;

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseShipHead."Posting Date" := Today;
            recWhseShipHead.Modify();

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseShipLine.SetRange("No.", recWhseShipHead."No.");
            if recWhseShipLine.FindSet(true) then
                repeat
                    recWhseShipLine.Validate("Qty. to Ship", 0);
                    recWhseShipLine.Modify(true);
                until recWhseShipLine.Next() = 0;

            // Update and post values
            recWhseShipLine.Reset();
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange("Real Source Order No.", precRespLine."Real Source Order No.");
            recRespLine.SetRange("Open - Shipment", true);
            recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.", "Invoice No.");
            if recRespLine.FindSet(true) then begin
                recRespLine.ModifyAll("Error Text", '');

                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    recWhseShipLine.SETRANGE("Source Type", DATABASE::"Transfer Line");
                    recWhseShipLine.SETRANGE("Source Document", recWhseShipLine."Source Document"::"Inbound Transfer");
                    recWhseShipLine.SETRANGE("Source No.", precRespLine."Customer Order No.");
                    recWhseShipLine.SETRANGE("Source Line No.", precRespLine."Customer Order Line No.");  // 17-08-22 ZY-LD 021
                    if recWhseShipLine.FindFirst() then begin
                        if recRespLine."Product No." = recWhseShipLine."Item No." then begin
                            if (recWhseShipLine."Qty. to Ship" + recRespLine.Quantity) <= recWhseShipLine."Qty. Outstanding" then begin
                                recWhseShipLine.Validate("Qty. to Ship", recWhseShipLine."Qty. to Ship" + recRespLine.Quantity);
                                recRespLineTmp := recRespLine;
                                recRespLineTmp.Insert();

                                PostWhseReceipt := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseShipLine."Qty. Outstanding");
                                recRespLine.Modify();
                            end;
                        end else begin
                            recRespLine."Error Text" := StrSubstNo(lText003, recWhseShipLine.FieldCaption("Item No."), recRespLine.TableCaption, recWhseShipLine.TableCaption, recRespLine."Line No.");
                            recRespLine.Modify();
                        end;
                    end else
                        if (recRespLine.Quantity = recRespLine."Purchase Order Qty. Received") or
                           (recRespLine.Quantity = recRespLine."Purchase Order Qty. Invoiced")
                        then begin
                            recRespLine."Previously Posted" := true;
                            recRespLine.Open := false;
                        end else
                            recRespLine."Error Text" :=
                              StrSubstNo(lText002,
                                recWhseShipLine.TableCaption,
                                recWhseShipLine.FieldCaption("Source No."), precRespLine."Source Order No.",
                                recWhseShipLine.FieldCaption("Source Line No."), recRespLine."Source Order Line No.");
                    recRespLine.Modify();
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseReceipt then begin
                    Commit();
                    WhsePostShipment.SetPostingSettings(false);
                    if WhsePostShipment.Run(recWhseShipLine) then
                        PostResultOK := WhsePostShipment.GetCounterSourceDocOK() = 1;
                    recRespLine.Reset();
                    if recRespLineTmp.FindSet() then
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false;
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify();
                            end;
                        until recRespLineTmp.Next() = 0;
                    Clear(WhsePostShipment);
                end;
            end else
                PostResultOK := true;
        end else begin
            recRespLine.SetAutocalcFields("Warehouse Status", "Purchase Order Qty. Received", "Purchase Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange(Open, true);
            if recRespLine.FindSet(true) then
                repeat
                    if (recRespLine.Quantity = recRespLine."Purchase Order Qty. Received") or
                        (recRespLine.Quantity = recRespLine."Purchase Order Qty. Invoiced")
                    then begin
                        recRespLine."Previously Posted" := true;
                        recRespLine.Open := false;
                    end else
                        recRespLine."Error Text" := lText004;
                    recRespLine.Modify();
                until recRespLine.Next() = 0;
        end;
    end;

    local procedure SetWhseRcptLineFilter(OrderType: Option "Purchase Order","Sales Return Order","Transfer Order"; precRespLine: Record "Rcpt. Response Line"; var pWhseRcptLine: Record "Warehouse Receipt Line"; FilterLineNo: Boolean)
    begin
        case OrderType of
            Ordertype::"Purchase Order":
                begin
                    pWhseRcptLine.SetRange("Source Type", Database::"Purchase Line");
                    pWhseRcptLine.SetRange("Source Document", pWhseRcptLine."source document"::"Purchase Order");
                    if precRespLine."Real Source Order No." <> '' then begin
                        pWhseRcptLine.SetRange("Source No.", precRespLine."Real Source Order No.");
                        if FilterLineNo then
                            pWhseRcptLine.SetRange("Source Line No.", precRespLine."Real Source Order Line No.");
                    end else begin
                        pWhseRcptLine.SetRange("Source No.", precRespLine."Source Order No.");
                        if FilterLineNo then
                            pWhseRcptLine.SetRange("Source Line No.", precRespLine."Source Order Line No.");
                    end;
                end;
            Ordertype::"Sales Return Order":
                begin
                    pWhseRcptLine.SetRange("Source Type", Database::"Sales Line");
                    pWhseRcptLine.SetRange("Source Document", pWhseRcptLine."source document"::"Sales Return Order");
                    pWhseRcptLine.SetRange("Source No.", precRespLine."Real Source Order No.");
                    if FilterLineNo then
                        pWhseRcptLine.SetRange("Source Line No.", precRespLine."Real Source Order Line No.");
                end;
            Ordertype::"Transfer Order":
                begin
                    pWhseRcptLine.SetRange("Source Type", Database::"Transfer Line");
                    pWhseRcptLine.SetRange("Source Document", pWhseRcptLine."source document"::"Inbound Transfer");
                    pWhseRcptLine.SetRange("Source No.", precRespLine."Real Source Order No.");
                    if FilterLineNo then
                        pWhseRcptLine.SetRange("Source Line No.", precRespLine."Real Source Order Line No.");
                end;
        end;
    end;

    procedure UpdateInboundDocument(var recRespHead: Record "Rcpt. Response Header") rValue: Boolean
    var
        recRespLine: Record "Rcpt. Response Line";
        recWhseInbHead: Record "Warehouse Inbound Header";
        recSalesLine: Record "Sales Line";
        SI: Codeunit "Single Instance";
        FileMgt: Codeunit "File Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        lText001: label 'Warehouse Status on WI is %1, and therefore not updated.';
    begin
        if not recRespHead."Lines With Error" then
            if recWhseInbHead.Get(recRespHead."Customer Reference") and (recRespHead."Warehouse Status" > recWhseInbHead."Warehouse Status") then begin
                recWhseInbHead.Validate("Warehouse Status", recRespHead."Warehouse Status");
                recWhseInbHead.Modify();
            end else begin
                recRespHead."After Post Description" := StrSubstNo(lText001, recWhseInbHead."Warehouse Status");

                recRespLine.SetRange("Response No.", recRespHead."No.");
                recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.");
                if recRespLine.FindSet(true) then
                    repeat
                        if recRespHead."Order Type Option" = recRespHead."order type option"::"Sales Return Order" then
                            if recSalesLine.Get(recSalesLine."document type"::"Return Order", recRespLine."Real Source Order No.", recRespLine."Real Source Order Line No.") and
                               (recSalesLine."Location Code" <> recRespLine.Location) and
                               (recSalesLine."Return Qty. Received" <> 0)
                            then begin
                                Clear(SI);
                                Clear(EmailAddMgt);
                                SI.SetMergefield(100, recSalesLine."No.");
                                SI.SetMergefield(101, Format(recSalesLine."Line No."));
                                SI.SetMergefield(102, recSalesLine."Location Code");
                                SI.SetMergefield(103, recRespLine.Location);
                                SI.SetMergefield(104, recRespLine."Response No.");
                                SI.SetMergefield(105, Format(recRespLine."Response Line No."));
                                EmailAddMgt.CreateEmailWithAttachment('VCKCNGLOC', '', '', recRespHead.Filename, FileMgt.GetFileName(recRespHead.Filename), false);
                                EmailAddMgt.Send();
                            end;

                        recRespLine.Open := false;
                        recRespLine.Modify();
                    until recRespLine.Next() = 0;
            end;
    end;

    procedure DownloadVCK(Type: Option " ","VCK Purch. Response","VCK Ship. Response","VCK Inventory",LMR; Import: Boolean)
    var
        recWhseSetup: Record "Warehouse Setup";
        recWarehouse: Record Location;
        FtpMgt: Codeunit "VisionFTP Management";
        lText001: label 'Downloading from VCK';
    begin
        recWhseSetup.Get();
        if GuiAllowed() or recWhseSetup.WhsePostingAllowed() then begin
            ZGT.OpenProgressWindow(lText001, 1);
            ZGT.UpdateProgressWindow(lText001, 0, true);
            recWarehouse.SetRange(Warehouse, recWarehouse.Warehouse::VCK);
            recWarehouse.FindFirst();
            recWarehouse.TestField("Warehouse Outbound FTP Code");
            FtpMgt.DownloadFolder(recWarehouse."Warehouse Outbound FTP Code");
            ZGT.CloseProgressWindow();

            if Import then
                case Type of
                    Type::"VCK Purch. Response":
                        PurchOrderRespImport(0);
                    else
                        PurchOrderRespImport(0);

                end;
        end;
    end;
}
