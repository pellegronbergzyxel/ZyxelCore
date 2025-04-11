Codeunit 50088 "Post Rcpt. Response Mgt."
{
    // 001. 20-05-19 ZY-LD 000 - Test for Warehouse request is created.
    // 002. 14-06-19 ZY-LD 2019061410000025 - Clear XML before import to avoid use of the same number.
    // 003. 02-09-19 ZY-LD Automation has to take care of posting period.
    // 004. 23-10-19 ZY-LD 000 - Don't import "On Hold".
    // 005. 08-01-20 ZY-LD P0361 - Commit before post.
    // 006. 09-01-20 ZY-LD 2020010910000032 - Release if status is open.
    // 007. 10-01-20 ZY-LD 000 - Send e-mail when error.
    // 008. 22-04-20 ZY-LD 000 - We will always download and import, but not always post it.
    // 009. 10-06-20 ZY-LD 2020051910000079 - We don´t always receive all quantity on stock return. We just delete the document, because we don´t receive anymore.
    // 010. 29-06-20 ZY-LD 2020062510000225 - An error "An attempt was made to change an old version of a Warehouse Receipt Header record." occured in the automation. I assume that this GET will solve the issue.
    // 011. 03-07-20 ZY-LD 2020070210000089 - It happens some times that we see a response on the same document twice.
    // 012. 01-12-20 ZY-LD 000 - Post Transfer Order.
    // 014. 21-12-21 ZY-LD 000 - On the old way, it send an e-mail every 5 min, and that was a problem in the weekend.
    // 015. 19-04-22 ZY-LD 2022032910000051 - We change the sales return order due to the quantity we receive on the response from the warehouse.
    // 016. 20-04-22 ZY-LD 000 - It can happen that we receive responses with the same warehouse status. If there are changes we will send an e-mail to order desk.
    // 017. 06-05-22 ZY-LD 000 - Don´t post when it´s "On Hold".
    // 018. 06-05-22 ZY-LD 000 - VCK has changed the process after upgrading, so we need to post to DAMAGE.
    // 019. 19-05-22 ZY-LD 2022051810000068 - A response can contain more that one invoice no.
    // 020. 08-07-22 ZY-LD 000 - If the last line was zero it could not post.
    // 021. 08-09-22 ZY-LD 000 - The previous value could be zero.
    // 022. 04-04-24 ZY-LD 000 - Set Return Reason Code on c
    // 023. 28-05-24 ZY-LD 000 - It happens that "Quantity Received" is zero, therefore we only validate on "Quantity Invoiced".
    // 024. 10-06-24 ZY-LD 000 - On sales return order it must be allowed to post damaged items.
    // 025. 19-06-24 ZY-LD 000 - The calculated fields didn´t work.
    // 026. 22-08-24 ZY-LD 000 - Found out that the response was imported twice. Don´t know why.

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
        //>> 22-04-20 ZY-LD 008
        recAutoSetup.Get;
        if recAutoSetup.WhseIndbPostingAllowed or
           (recAutoSetup."Post Inbound Response" and ForcePosting)
        then  //<< 22-04-20 ZY-LD 008
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
        ArchiveFile: File;
        InStream: InStream;
        xmlPurchOrderResp: XmlPort "Read Purchase Order Response";
        LastErrorText: Text;
        lText001: label 'Import VCK Response';
        lText002: label 'Document could not open.';
        ImportErrorOccured: Boolean;
    begin
        recZyFileMgt.SetRange(Type, recZyFileMgt.Type::"VCK Purch. Response");
        recZyFileMgt.SetRange(Open, true);
        recZyFileMgt.SetFilter("On Hold", '%1', '');  // 23-10-19 ZY-LD 004
        if pEntryNo <> 0 then
            recZyFileMgt.SetRange("Entry No.", pEntryNo);
        if recZyFileMgt.FindSet then begin
            ZGT.OpenProgressWindow(lText001, recZyFileMgt.Count);
            repeat
                ZGT.UpdateProgressWindow(lText001, 0, true);
                if ArchiveFile.Open(recZyFileMgt.Filename) then begin
                    ArchiveFile.CreateInstream(InStream);
                    Clear(xmlPurchOrderResp);  // 14-06-19 ZY-LD 002
                    xmlPurchOrderResp.SetSource(InStream);
                    xmlPurchOrderResp.Init(recZyFileMgt."Entry No.");
                    LastErrorText := '';
                    ClearLastError();
                    //if not xmlPurchOrderResp.Import then  // 22-08-24 ZY-LD 026
                    //    LastErrorText := GetLastErrorText();  // 22-08-24 ZY-LD 026

                    if xmlPurchOrderResp.Import then begin
                        recZyFileMgt.Open := false;
                        recZyFileMgt."Error Text" := '';
                    end else
                        recZyFileMgt."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(recZyFileMgt."Error Text"));
                    recZyFileMgt.Modify;
                    ArchiveFile.Close;
                end else begin
                    recZyFileMgt."Error Text" := lText002;  // 14-06-19 ZY-LD 002
                    recZyFileMgt.Modify;  // 14-06-19 ZY-LD 002
                end;

                //>> 21-12-21 ZY-LD 014
                //ImportErrorOccured := recZyFileMgt."Error Text" <> '';  // 10-01-20 ZY-LD 007
                if recZyFileMgt."Error Text" <> '' then begin
                    recAutoSetup.Get;
                    if (recAutoSetup."Warehouse Import Error Date" = 0D) or (recAutoSetup."Warehouse Import Error Date" < Today) then begin
                        EmailAddMgt.CreateSimpleEmail('VCKIMPDOC', '', '');
                        EmailAddMgt.Send;

                        recAutoSetup."Warehouse Import Error Date" := Today;
                        recAutoSetup.Modify;
                    end;
                end;

                Commit;
            //<< 21-12-21 ZY-LD 014
            until recZyFileMgt.Next() = 0;
            ZGT.CloseProgressWindow;

            //>> 21-12-21 ZY-LD 014
            //>> 10-01-20 ZY-LD 007
            /*IF ImportErrorOccured THEN BEGIN
              EmailAddMgt.CreateSimpleEmail('VCKIMPDOC','','');
              EmailAddMgt.Send;
            END;*/
            //<< 10-01-20 ZY-LD 007
            //<< 21-12-21 ZY-LD 014
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
        recLocation: Record Location;  // 02-11-23 ZY-LD 022
        recAutoSetup: Record "Automation Setup";  // 02-11-23 ZY-LD 022
        PostResult: Boolean;
        lText001: label 'Posting Shipment Response';
        lText002: label '"%1" is not setup in "%2".';
        lText003: label 'Error: %1.';
        lText004: label 'Check "%1" on the response lines.';
    begin
        recRespHead2.SetCurrentkey("Customer Reference", "Warehouse Status");
        recRespHead3.SetCurrentkey("Customer Reference", "Warehouse Status");
        recRespHead.SetCurrentkey("Customer Reference", "Warehouse Status");
        recRespHead.SetRange(Open, true);
        recRespHead.SetFilter("On Hold", '%1', '');  // 06-05-22 ZY-LD 017
        if pRespNo <> '' then
            recRespHead.SetRange("No.", pRespNo);
        if recRespHead.FindSet(true) then begin
            SI.SetWarehouseManagement(true);
            SI.SetHideSalesDialog(true);
            ZGT.OpenProgressWindow(lText001, recRespHead.Count);
            repeat
                ZGT.UpdateProgressWindow(lText001, 0, true);

                recWhseSetup.Get;
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
                       not recRespHead2.FindFirst  // Searching for previous posted responce.
                    then begin
                        //>> 13-08-20 ZY-LD 012
                        //recRespLine.SetCurrentKey("Response No.","Source Order No.","Source Order Line No.");
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
                        if recRespLine.FindSet then begin
                            recRespHead."After Post Description" := '';
                            if recWhseInbHead.Get(recRespHead."Customer Reference") then  // If it´s an old response, we don´t want receipt posted set.
                                recRespHead."Receipt Posted" := true;

                            repeat
                                recRespLine.SetRange("Source Order No.", recRespLine."Source Order No.");
                                recRespLine.SetRange("Real Source Order No.", recRespLine."Real Source Order No.");
                                if recRespHead."Order Type Option" = recRespHead."order type option"::"Purchase Order" then  //
                                    recRespLine.SetRange("Invoice No.", recRespLine."Invoice No.");  // 19-05-22 ZY-LD 019
                                if recRespHead."Order Type Option" = recRespHead."order type option"::"Sales Return Order" then  // 13-08-20 ZY-LD 012
                                    recRespLine.SetRange(Location, recRespLine.Location);  // 13-08-20 ZY-LD 012
                                case recRespHead."Order Type Option" of
                                    recRespHead."order type option"::"Purchase Order":
                                        PostResult := PostPurchOrderRespDoc(recRespHead, recRespLine);
                                    recRespHead."order type option"::"Sales Return Order":
                                        begin
                                            //>> 06-05-22 ZY-LD 018
                                            EmailSalesReturnOrderInbound(recRespHead);
                                            UpdateSalesReturnOrderInbound(recRespHead, recRespLine);
                                            PostResult := PostSalesReturnOrderRespDoc(recRespHead, recRespLine);
                                            PostSalesReturnOrderRespDoc_Damage(recRespHead, recRespLine);
                                            //<< 06-05-22 ZY-LD 018
                                        end;
                                    recRespHead."order type option"::"Transfer Order":
                                        begin
                                            //>> 02-11-23 ZY-LD 022
                                            if (recLocation.get(recWhseInbHead."Sender No.") and recLocation."Post Transf. Ship. on Transit") and
                                               ((recRespHead."Warehouse Status" >= recAutoSetup."Ship. Post Transf Whse. Status") OR (recRespHead."Warehouse Status" = recRespHead."Warehouse Status"::"On Stock"))
                                            then begin
                                                PostInboundOrderRespShip(recRespHead, recRespLine);
                                            end;
                                            //<< 02-11-23 ZY-LD 022
                                            PostResult := PostTransferOrderRespDoc(recRespHead, recRespLine);  // 01-12-20 ZY-LD 012
                                        end;
                                end;

                                if not PostResult then begin
                                    recRespHead."Receipt Posted" := false;
                                    recRespHead.CalcFields("Lines With Error");
                                    if recRespHead."Lines With Error" and (recRespHead."After Post Description" = '') then
                                        recRespHead."After Post Description" := StrSubstNo(lText004, recRespLine.FieldCaption("Error Text"));
                                end;
                                recRespHead.Modify(true);

                                if not recRespLine.FindLast then;
                                recRespLine.SetRange("Source Order No.");
                                recRespLine.SetRange("Real Source Order No.");
                                recRespLine.SetRange(Location);  // 13-08-20 ZY-LD 012
                                recRespLine.SetRange("Invoice No.");  // 19-05-22 ZY-LD 019
                            until recRespLine.Next() = 0;
                        end;
                    end else begin
                        recRespLine.SetCurrentkey(Open, "Response No.", "Source Order No.", "Source Order Line No.");
                        recRespLine.SetRange("Response No.", recRespHead."No.");
                        recRespLine.SetRange(Open, true);
                        if recRespLine.FindSet then
                            repeat
                                recRespLine.Validate(Open, false);
                                recRespLine.Modify(true);
                            until recRespLine.Next() = 0;
                    end;

                    UpdateInboundDocument(recRespHead);
                    recRespHead.Modify;
                    Commit;
                end;
            until recRespHead.Next() = 0;

            ZGT.CloseProgressWindow;
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
        RespBodyInStream: InStream;
        ResponseXmlDoc: dotnet XmlDocument;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        SerialNodes: dotnet XmlNodeList;
        SerialNode: dotnet XmlNode;
        i: Integer;
        ArchiveFile: File;
        XmlHeadStatus: Text[10];
        XmlHeadLocation: Text[10];
        XmlHeadOrderNo: Code[20];
        XmlPurchOrderNo: Code[20];
        XmlPurchOrderLineNo: Integer;
        XmlQuantity: Integer;
        XmlItemNo: Code[20];
        XmlVendInvNo: Code[20];
        lText001: label 'There are differences on Purchase Order No. in document "%1".';
        lText002: label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        PostWhseReceipt: Boolean;
        lText004: label 'Warehouse Request was not found.';
        lText005: label 'You cannot handle more than the outstanding %1 units.';
        WhseRequestFound: Boolean;
        lText006: label 'Purchase Order "%1" was not found.';
        lText007: label 'Vendor No. %1 is blocked with "%2".';
    begin
        // Find Warehouse request
        SetWhseRcptLineFilter(precRespHead."Order Type Option", precRespLine, recWhseRcptLine, false);
        if recWhseRcptLine.FindFirst then begin
            recWhseRcptHead.Get(recWhseRcptLine."No.");
            WhseRequestFound := true;
        end else begin
            recPurchHead.SetAutocalcFields("Completely Received");
            if not recPurchHead.Get(recPurchHead."document type"::Order, precRespLine."Real Source Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Real Source Order No.");
                precRespHead.Modify;
            end else
                if not recPurchHead."Completely Received" then
                    if recVend.Get(recPurchHead."Buy-from Vendor No.") and (recVend.Blocked = recVend.Blocked::" ") then begin
                        if recPurchHead.Status = recPurchHead.Status::Open then
                            ReleasePurchaseDocument.PerformManualRelease(recPurchHead);
                        if GetSourceDocInbound.CreateFromPurchOrderHideDialog(recPurchHead) then begin
                            recWhseRcptHead.SetRange("Purchase Order No.", recPurchHead."No.");
                            WhseRequestFound := recWhseRcptHead.FindLast;
                        end else
                            if precRespHead."After Post Description" = '' then begin
                                precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                precRespHead.Modify;
                            end;
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := StrSubstNo(lText007, recVend."No.", recVend.Blocked);
                            precRespHead.Modify;
                        end;
        end;

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseRcptHead."Posting Date" := Today;
            recWhseRcptHead.Modify;

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseRcptLine.SetRange("No.", recWhseRcptHead."No.");
            if recWhseRcptLine.FindSet(true) then
                repeat
                    recWhseRcptLine.Validate("Qty. to Receive", 0);
                    recWhseRcptLine.Modify(true);
                until recWhseRcptLine.Next() = 0;

            // Update and post values
            recWhseRcptLine.Reset;
            //recRespLine.SETAUTOCALCFIELDS("Warehouse Status","Sales Order Qty. Shipped","Sales Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange("Real Source Order No.", precRespLine."Real Source Order No.");
            //recRespLine.SETRANGE("Delivery Document Line Posted",FALSE);
            recRespLine.SetRange(Open, true);
            recRespLine.SetRange("Invoice No.", precRespLine."Invoice No.");  // 19-05-22 ZY-LD 019
            recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.", "Invoice No.");
            if recRespLine.FindSet(true) then begin
                recRespLine.ModifyAll("Error Text", '');

                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    SetWhseRcptLineFilter(precRespHead."Order Type Option", recRespLine, recWhseRcptLine, true);
                    //recWhseRcptLine.SETRANGE("Source Line No.",recRespLine."Source Order Line No.");
                    if recWhseRcptLine.FindFirst then begin
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
                                recRespLineTmp.Insert;

                                PostWhseReceipt := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseRcptLine."Qty. Outstanding");
                                recRespLine.Modify;
                            end;
                        end else begin
                            recRespLine."Error Text" := StrSubstNo(lText003, recWhseRcptLine.FieldCaption("Item No."), recRespLine.TableCaption, recWhseRcptLine.TableCaption, recRespLine."Line No.");
                            recRespLine.Modify;
                        end;
                    end else
                        //>> 19-06-24 ZY-LD 025
                        //if (recRespLine.Quantity = recRespLine."Purchase Order Qty. Received") or
                        //   (recRespLine.Quantity = recRespLine."Purchase Order Qty. Invoiced")
                        if recPurchLine.get(recPurchLine."Document Type"::Order, recRespLine."Real Source Order No.", recRespLine."Real Source Order Line No.") and
                           (recPurchLine."Outstanding Quantity" = 0)  //<< 19-06-24 ZY-LD 025
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
                    recRespLine.Modify;
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseReceipt then begin
                    Commit;
                    WhsePostReceipt.SetHideValidationDialog(true);
                    if WhsePostReceipt.Run(recWhseRcptLine) then
                        PostResultOK := WhsePostReceipt.GetCounterSourceDocOK() = 1;

                    // Update response lines
                    recRespLine.Reset;
                    if recRespLineTmp.FindSet then
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false;
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify;
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
                    //>> 19-06-24 ZY-LD 025
                    //if (recRespLine.Quantity = recRespLine."Purchase Order Qty. Received") or (recRespLine.Quantity = recRespLine."Purchase Order Qty. Invoiced")
                    if recPurchLine.get(recPurchLine."Document Type"::Order, recRespLine."Real Source Order No.", recRespLine."Real Source Order Line No.") and
                       (recPurchLine."Outstanding Quantity" = 0)  //<< 19-06-24 ZY-LD 025
                    then begin
                        recRespLine."Previously Posted" := true;
                        recRespLine.Open := false;
                        recRespLine."Error Text" := '';
                    end else
                        recRespLine."Error Text" := lText004;
                    recRespLine.Modify;
                until recRespLine.Next() = 0;
        end;
    end;

    local procedure PostSalesReturnOrderRespDoc(var precRespHead: Record "Rcpt. Response Header"; precRespLine: Record "Rcpt. Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Rcpt. Response Line";
        recRespLineTmp: Record "Rcpt. Response Line" temporary;
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recWhseRcptHead: Record "Warehouse Receipt Header";
        recWhseRcptLine: Record "Warehouse Receipt Line";
        recCust: Record Customer;
        recInvSetup: Record "Inventory Setup";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        ArchiveMgt: Codeunit ArchiveManagement;
        EmailAddMgt: Codeunit "E-mail Address Management";
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        RespBodyInStream: InStream;
        ResponseXmlDoc: dotnet XmlDocument;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        SerialNodes: dotnet XmlNodeList;
        SerialNode: dotnet XmlNode;
        PostWhseReceipt: Boolean;
        WhseRequestFound: Boolean;
        SalesQtyIsChanged: Boolean;
        XmlHeadOrderNo: Code[20];
        XmlPurchOrderNo: Code[20];
        XmlItemNo: Code[20];
        XmlVendInvNo: Code[20];
        ArchiveFile: File;
        i: Integer;
        XmlPurchOrderLineNo: Integer;
        XmlQuantity: Integer;
        XmlHeadStatus: Text[10];
        XmlHeadLocation: Text[10];
        lText001: label 'There are differences on Purchase Order No. in document "%1".';
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
        if recWhseRcptLine.FindFirst then begin
            recWhseRcptHead.Get(recWhseRcptLine."No.");
            WhseRequestFound := true;
        end else begin
            recSalesHead.SetAutocalcFields("Completely Shipped");
            if not recSalesHead.Get(recSalesHead."document type"::"Return Order", precRespLine."Real Source Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Real Source Order No.");
                precRespHead.Modify;
            end else
                if not recSalesHead."Completely Shipped" then
                    if recCust.Get(recSalesHead."Sell-to Customer No.") and (recCust.Blocked = recCust.Blocked::" ") then begin
                        if recSalesHead.Status = recSalesHead.Status::Open then
                            ReleaseSalesDocument.PerformManualRelease(recSalesHead);

                        if GetSourceDocInbound.CreateFromSalesReturnOrderHideDialog(recSalesHead) then begin
                            recWhseRcptHead.SetRange("Sales Return Order No.", recSalesHead."No.");
                            WhseRequestFound := recWhseRcptHead.FindLast;
                        end else
                            if precRespHead."After Post Description" = '' then begin
                                precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                precRespHead.Modify;
                            end;
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := StrSubstNo(lText007, recCust."No.", recCust.Blocked);
                            precRespHead.Modify;
                        end;
        end;

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseRcptHead."Posting Date" := Today;
            recWhseRcptHead.Modify;

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseRcptLine.SetRange("No.", recWhseRcptHead."No.");
            if recWhseRcptLine.FindSet(true) then
                repeat
                    recWhseRcptLine.Validate("Qty. to Receive", 0);
                    recWhseRcptLine.Modify(true);
                until recWhseRcptLine.Next() = 0;

            // Update and post values
            recWhseRcptLine.Reset;
            //recRespLine.SETAUTOCALCFIELDS("Warehouse Status","Sales Order Qty. Shipped","Sales Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange("Real Source Order No.", precRespLine."Real Source Order No.");
            //recRespLine.SETRANGE("Delivery Document Line Posted",FALSE);
            recRespLine.SetRange(Open, true);
            recRespLine.SetRange(Location, ItemLogisticEvent.GetMainWarehouseLocation);  // 06-05-22 ZY-LD 018 - We will only post main warehouse locations.
            recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.");
            if recRespLine.FindSet(true) then begin
                recRespLine.ModifyAll("Error Text", '');

                //>> 19-04-22 ZY-LD 015 - Moved to seperate function.
                /*recSalesHead.GET(recSalesHead."Document Type"::"Return Order",precRespLine."Real Source Order No.");
                REPEAT
                  IF recSalesLine.GET(recSalesHead."Document Type",recRespLine."Real Source Order No.",recRespLine."Real Source Order Line No.") THEN BEGIN
                    IF recSalesLine.Quantity <> recRespLine.Quantity THEN BEGIN
                      IF recSalesHead.Status = recSalesHead.Status::Released THEN BEGIN
                        ReleaseSalesDocument.Reopen(recSalesHead);
                        SalesHeadEvent.DeleteWarehouseReceipt(recSalesHead,FALSE);
                        ArchiveMgt.ArchSalesDocumentNoConfirm(recSalesHead);
                      END;

                      recSalesLine.SuspendStatusCheck(TRUE);
                      recSalesLine.VALIDATE(Quantity,recRespLine.Quantity);
                      recSalesLine.MODIFY(TRUE);
                      recSalesLine.SuspendStatusCheck(FALSE);
                      SalesQtyIsChanged := TRUE;
                    END;
                  END;
                UNTIL recRespLine.Next() = 0;

                IF SalesQtyIsChanged THEN BEGIN
                  ReleaseSalesDocument.PerformManualRelease(recSalesHead);
                  SalesHeadEvent.CreateWarehouseReceipt(recSalesHead);

                  ArchiveMgt.ArchSalesDocumentNoConfirm(recSalesHead);
                  EmailAddMgt.SetSalesHeaderMergeFields(recSalesHead."Document Type",recSalesHead."No.");
                  EmailAddMgt.CreateSimpleEmail('VCKCNGQTY','','');
                  EmailAddMgt.Send;
                END;

                recRespLine.FINDSET(TRUE);*/  //<< 19-04-22 ZY-LD 015
                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    SetWhseRcptLineFilter(precRespHead."Order Type Option", recRespLine, recWhseRcptLine, true);
                    //recWhseRcptLine.SETRANGE("Source Line No.",recRespLine."Source Order Line No.");
                    if recWhseRcptLine.FindFirst then begin
                        if recRespLine."Product No." = recWhseRcptLine."Item No." then begin
                            if recWhseRcptLine."Location Code" = recRespLine.Location then begin  // 06-05-22 ZY-LD 018
                                if (recWhseRcptLine."Qty. to Receive" + recRespLine.Quantity) <= recWhseRcptLine."Qty. Outstanding" then begin
                                    if recRespLine.Quantity <> 0 then begin  // 28-05-24 ZY-LD 024
                                        recWhseRcptLine.Validate("Qty. to Receive", recWhseRcptLine."Qty. to Receive" + recRespLine.Quantity);
                                        recWhseRcptLine.Validate("Warehouse Inbound No.", precRespHead."Customer Reference");
                                        recWhseRcptLine.Modify(true);

                                        recRespLineTmp := recRespLine;
                                        recRespLineTmp.Insert;

                                        PostWhseReceipt := true;
                                    end else begin
                                        //>> 28-05-24 ZY-LD 024
                                        recRespLine.Open := false;
                                        recRespLine.Modify;
                                        //<< 28-05-24 ZY-LD 024
                                    end;
                                end else begin
                                    if recRespLine.Quantity = 0 then
                                        recRespLine."Error Text" := lText008  // 28-05-24 ZY-LD 024
                                    else
                                        recRespLine."Error Text" := StrSubstNo(lText005, recWhseRcptLine."Qty. Outstanding");
                                    recRespLine.Modify;
                                end;
                            end else begin
                                //>> 06-05-22 ZY-LD 018
                                recRespLine."Error Text" := StrSubstNo(lText003, recWhseRcptLine.FieldCaption("Location Code"), recRespLine.TableCaption, recWhseRcptLine.TableCaption, recRespLine."Line No.");
                                recRespLine.Modify;
                                //<< 06-05-22 ZY-LD 018
                            end;
                        end else begin
                            recRespLine."Error Text" := StrSubstNo(lText003, recWhseRcptLine.FieldCaption("Item No."), recRespLine.TableCaption, recWhseRcptLine.TableCaption, recRespLine."Line No.");
                            recRespLine.Modify;
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
                    recRespLine.Modify;
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseReceipt then begin
                    Commit;
                    recWhseRcptLine.SetRange("Source Line No.");  // 08-07-22 ZY-LD 020
                    WhsePostReceipt.SetHideValidationDialog(true);
                    if WhsePostReceipt.Run(recWhseRcptLine) then
                        PostResultOK := WhsePostReceipt.GetCounterSourceDocOK() = 1;

                    //>> 10-06-20 ZY-LD 009
                    if PostResultOK then begin
                        recInvSetup.Get;
                        if recWhseRcptHead."Location Code" = recInvSetup."AIT Location Code" then begin
                            recWhseRcptHead.DeleteUnpostedSalesReturnOrderLines;
                            if recWhseRcptHead.Get(recWhseRcptHead."No.") then  // 29-06-20 ZY-LD 010
                                if not recWhseRcptHead.Delete then;
                        end;
                    end;
                    //<< 10-06-20 ZY-LD 009

                    // Update response lines
                    recRespLine.Reset;
                    if recRespLineTmp.FindSet then begin
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false;
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify;
                            end;
                        until recRespLineTmp.Next() = 0;
                        Commit;
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
            recRespLine.SetRange(Location, ItemLogisticEvent.GetMainWarehouseLocation);  // 06-05-22 ZY-LD 018
            if recRespLine.FindSet(true) then
                repeat
                    if (recRespLine.Quantity = recRespLine."Purchase Order Qty. Received") or
                       (recRespLine.Quantity = recRespLine."Purchase Order Qty. Invoiced") or
                        recSalesHead."Completely Shipped"  // 03-07-20 ZY-LD 011
                    then begin
                        recRespLine."Previously Posted" := true;
                        recRespLine.Open := false;
                    end else
                        recRespLine."Error Text" := lText004;
                    recRespLine.Modify;
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
        //>> 06-05-22 ZY-LD 018
        // Post items to other locations
        recRespLine.SetCurrentkey("Response No.", Location, Open);
        recRespLine.SetRange("Response No.", precRespHead."No.");
        //recRespLine.SETFILTER(Location,'<>%1',LogisticEvent.GetMainWarehouseLocation);  // 04-08-22 ZY-LD 021
        recRespLine.SetRange(Open, true);
        if recRespLine.FindSet(true) then begin
            //>> 04-08-22 ZY-LD 021
            //recSalesHead2.GET(recSalesHead2."Document Type"::"Return Order",precRespLine."Real Source Order No.");
            recWhseIndbHead.Get(precRespHead."Customer Reference");
            recSalesHead2.Get(recSalesHead2."document type"::"Return Order", recWhseIndbHead."Shipment No.");
            //<< 04-08-22 ZY-LD 021

            SI.SetHideSalesDialog(true);
            SI.SetKeepLocationCode(true);
            SI.SetSkipErrorOnBlockOnOrder(true);  // 17-08-22 ZY-LD 021
            SI.SetPostDamage(true);  // 19-04-24 ZY-LD 023
            SI.SetSkipErrorOnBlockOnOrder(true);  // 10-06-24 ZY-LD 024

            repeat
                //>> 04-08-22 ZY-LD 021
                if ((recRespLine.Location <> LogisticEvent.GetMainWarehouseLocation) and (recRespLine.Location <> '')) or
                   ((recRespLine.Location = LogisticEvent.GetMainWarehouseLocation) and (recRespLine."Real Source Order Line No." = 0))
                then begin  //<< 04-08-22 ZY-LD 021
                    recRespLine.SetRange(Location, recRespLine.Location);
                    //>> 04-08-22 ZY-LD 021
                    if recRespLine.Location = LogisticEvent.GetMainWarehouseLocation then
                        recRespLine.SetRange("Real Source Order Line No.", 0);
                    //<< 04-08-22 ZY-LD 021
                    if recRespLine.FindSet(true) then begin
                        Clear(recSalesHead);
                        recSalesHead.SetHideValidationDialog(true);
                        recSalesHead.Init;
                        recSalesHead.Validate("Document Type", recSalesHead."document type"::"Credit Memo");
                        recSalesHead.Insert(true);
                        recSalesHead.Validate("Sell-to Customer No.", recSalesHead2."Sell-to Customer No.");
                        recSalesHead.Validate("Posting Date", Today);
                        recSalesHead.Validate("Location Code", recRespLine.Location);
                        recSalesHead.Modify(true);

                        Clear(recSalesOrderHead);
                        recSalesOrderHead.SetHideValidationDialog(true);
                        recSalesOrderHead.Init;
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
                        recLocation.get(recRespLine.Location);  // 04-04-24 ZY-LD 022
                        recLocation.TestField("Default Return Reason Code");  // 04-04-24 ZY-LD 022
                        repeat
                            NewLineNo += 10000;

                            Clear(recSalesLine);
                            recSalesLine.SetHideValidationDialog(true);
                            recSalesLine.Init;
                            recSalesLine.Validate("Document Type", recSalesHead."Document Type");
                            recSalesLine.Validate("Document No.", recSalesHead."No.");
                            recSalesLine.Validate("Line No.", NewLineNo);
                            recSalesLine.Validate(Type, recSalesLine.Type::Item);
                            recSalesLine.Validate("No.", recRespLine."Product No.");
                            recSalesLine.Validate("Location Code", recRespLine.Location);
                            recSalesLine.Validate(Quantity, recRespLine.Quantity);
                            recSalesLine.Validate("Return Reason Code", recLocation."Default Return Reason Code");  // 04-04-24 ZY-LD 022
                            recSalesLine.Validate("Unit Price", 0);
                            recSalesLine.Validate("Zero Unit Price Accepted", true);
                            recSalesLine.Insert(true);

                            Clear(recSalesOrderLine);
                            recSalesOrderLine.SetHideValidationDialog(true);
                            recSalesOrderLine.Init;
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
                            recRespLine2.Modify;
                        until recRespLine.Next() = 0;
                        //>> 04-08-22 ZY-LD 021
                        //recRespLine.SETFILTER(Location,'<>%1',LogisticEvent.GetMainWarehouseLocation);
                        recRespLine.SetRange(Location);
                        recRespLine.SetRange("Real Source Order Line No.");
                        //<< 04-08-22 ZY-LD 021 

                        SalesPost.Run(recSalesHead);
                        if recCredMemoHead.Get(recSalesHead."No.") then begin
                            ServerFilename := FileMgt.ServerTempFileName('');
                            ClientFilename := StrSubstNo(lText001, recCredMemoHead."No.");
                            //>> 04-08-22 ZY-LD 021
                            SI.SetMergefield(100, recRespLine.Location);
                            if recRespLine.Location = LogisticEvent.GetMainWarehouseLocation then
                                Recipents := lText002;
                            //<< 04-08-22 ZY-LD 021

                            recCredMemoHead.SetRange("No.", recCredMemoHead."No.");
                            Report.SaveAsPdf(Report::"Sales - Credit Memo RHQ", ServerFilename, recCredMemoHead);
                            Clear(EmailAddMgt);
                            EmailAddMgt.SetSalesHeaderMergeFields(recSalesOrderHead."Document Type", recSalesOrderHead."No.");
                            EmailAddMgt.SetCustomerMergefields(recSalesOrderHead."Sell-to Customer No.");
                            EmailAddMgt.CreateEmailWithAttachment('VCKDAMCRM', '', Recipents, ServerFilename, ClientFilename, false);  // 04-08-22 ZY-LD 021 - Recipents added.
                            EmailAddMgt.Send;
                            FileMgt.DeleteServerFile(ServerFilename);
                        end;
                    end;
                end;  // 04-08-22 ZY-LD 021
            until recRespLine.Next() = 0;

            SI.SetHideSalesDialog(false);
            SI.SetKeepLocationCode(false);
            SI.SetSkipErrorOnBlockOnOrder(false);  // 17-08-22 ZY-LD 021
            SI.SetPostDamage(false);  // 19-04-24 ZY-LD 023
            SI.SetSkipErrorOnBlockOnOrder(false);  // 10-06-24 ZY-LD 024
        end;
        //<< 06-05-22 ZY-LD 018
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
        SI: Codeunit "Single Instance";
        SalesQtyIsChanged: Boolean;
    begin
        //>> 02-06-22 ZY-LD 015
        // The Sales Return Order is updated with the quantity from the warehouse response. Only main warehouse location counts.
        if not precRespHead."Order has been Updated" then begin
            recWhseIndbHead.Get(precRespHead."Customer Reference");

            recRespLine.SetCurrentkey("Response No.", "Response Line No.");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            //recRespLine.SETRANGE("Real Source Order No.",precRespLine."Real Source Order No.");  // 04-08-22 ZY-LD 021
            recRespLine.SetRange("Real Source Order No.", recWhseIndbHead."Shipment No.");  // 04-08-22 ZY-LD 021
            recRespLine.SetFilter("Real Source Order Line No.", '<>0');  // 04-08-22 ZY-LD 021
            recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.");
            if recRespLine.FindSet then
                repeat
                    recRespLineTmp.SetRange("Source Order No.", recRespLine."Source Order No.");
                    recRespLineTmp.SetRange("Source Order Line No.", recRespLine."Source Order Line No.");
                    if not recRespLineTmp.FindFirst then begin
                        recRespLineTmp := recRespLine;
                        if recRespLine.Location <> ItemLogisticEvent.GetMainWarehouseLocation then
                            recRespLineTmp.Quantity := 0;
                        recRespLineTmp.Insert;
                    end else
                        if recRespLine.Location = ItemLogisticEvent.GetMainWarehouseLocation then begin
                            recRespLineTmp.Quantity := recRespLineTmp.Quantity + recRespLine.Quantity;
                            recRespLineTmp.Modify;
                        end;
                until recRespLine.Next() = 0;

            recRespLineTmp.SetCurrentkey("Response No.", "Response Line No.");
            recRespLineTmp.SetAutocalcFields("Real Source Order No.");  // 08-09-22 ZY-LD 021
            if recRespLineTmp.FindSet then begin
                //recSalesHead.GET(recSalesHead."Document Type"::"Return Order",precRespLine."Real Source Order No.");  // 08-09-22 ZY-LD 021
                recSalesHead.Get(recSalesHead."document type"::"Return Order", recRespLineTmp."Real Source Order No.");  // 08-09-22 ZY-LD 021
                repeat
                    if recSalesLine.Get(recSalesHead."Document Type", recRespLineTmp."Real Source Order No.", recRespLineTmp."Real Source Order Line No.") then begin
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
                    end;
                until recRespLineTmp.Next() = 0;

                if SalesQtyIsChanged then begin
                    ReleaseSalesDocument.PerformManualRelease(recSalesHead);
                    SalesHeadEvent.CreateWarehouseReceipt(recSalesHead);

                    ArchiveMgt.ArchSalesDocumentNoConfirm(recSalesHead);
                    EmailAddMgt.SetSalesHeaderMergeFields(recSalesHead."Document Type", recSalesHead."No.");
                    EmailAddMgt.CreateSimpleEmail('VCKCNGQTY', '', '');
                    EmailAddMgt.Send;
                end;
            end;

            precRespHead."Order has been Updated" := true;
            precRespHead.Modify;
        end;
        //<< 02-06-22 ZY-LD 015
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
    begin
        //>> 19-04-22 ZY-LD 015
        if not precRespHead."Response Document Send" then begin
            recWhseIndbHead.Get(precRespHead."Customer Reference");
            recSalesHead.Get(recSalesHead."document type"::"Return Order", recWhseIndbHead."Shipment No.");

            ServerFilename := FileMgt.ServerTempFileName('');
            ClientFilename := StrSubstNo('Sales Return Order %1.xlsx', precRespHead."Shipment No.");
            recRcptRespHead.SetRange("No.", precRespHead."No.");
            Report.SaveAsExcel(Report::"Rcpt. Inbound Document", ServerFilename, recRcptRespHead);

            EmailAddMgt.SetSalesHeaderMergeFields(recSalesHead."Document Type", recSalesHead."No.");
            EmailAddMgt.CreateEmailWithAttachment('VCKRESPONS', '', '', ServerFilename, ClientFilename, false);
            EmailAddMgt.Send;

            FileMgt.DeleteServerFile(ServerFilename);

            precRespHead."Response Document Send" := true;
            precRespHead.Modify;
        end;
        //<< 19-04-22 ZY-LD 015
    end;

    local procedure PostTransferOrderRespDoc(var precRespHead: Record "Rcpt. Response Header"; precRespLine: Record "Rcpt. Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Rcpt. Response Line";
        recRespLineTmp: Record "Rcpt. Response Line" temporary;
        recTransHead: Record "Transfer Header";
        recWhseRcptHead: Record "Warehouse Receipt Header";
        recWhseRcptLine: Record "Warehouse Receipt Line";
        recVend: Record Vendor;
        RespBodyInStream: InStream;
        ResponseXmlDoc: dotnet XmlDocument;
        XMLNsMgr: dotnet XmlNamespaceManager;
        WorkNodes: dotnet XmlNodeList;
        WorkNode: dotnet XmlNode;
        SerialNodes: dotnet XmlNodeList;
        SerialNode: dotnet XmlNode;
        i: Integer;
        ArchiveFile: File;
        XmlHeadStatus: Text[10];
        XmlHeadLocation: Text[10];
        XmlHeadOrderNo: Code[20];
        XmlPurchOrderNo: Code[20];
        XmlPurchOrderLineNo: Integer;
        XmlQuantity: Integer;
        XmlItemNo: Code[20];
        XmlVendInvNo: Code[20];
        lText001: label 'There are differences on Purchase Order No. in document "%1".';
        lText002: label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        PostWhseReceipt: Boolean;
        lText004: label 'Warehouse Request was not found.';
        lText005: label 'You cannot handle more than the outstanding %1 units.';
        WhseRequestFound: Boolean;
        lText006: label 'Transfer Order "%1" was not found.';
    begin
        // Find Warehouse request
        SetWhseRcptLineFilter(precRespHead."Order Type Option", precRespLine, recWhseRcptLine, false);
        if recWhseRcptLine.FindFirst then begin
            recWhseRcptHead.Get(recWhseRcptLine."No.");
            WhseRequestFound := true;
        end else begin
            recTransHead.SetAutocalcFields("Completely Received");
            if not recTransHead.Get(precRespLine."Real Source Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Real Source Order No.");
                precRespHead.Modify;
            end else
                if not recTransHead."Completely Received" then begin
                    if recTransHead.Status = recTransHead.Status::Open then
                        ReleaseTransferDocument.Run(recTransHead);
                    if GetSourceDocInbound.CreateFromInbndTransferOrderHideDialog(recTransHead) then begin
                        recWhseRcptHead.SetRange("Transfer Order No.", recTransHead."No.");
                        WhseRequestFound := recWhseRcptHead.FindLast;
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                            precRespHead.Modify;
                        end;
                end;
        end;

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseRcptHead."Posting Date" := Today;
            recWhseRcptHead.Modify;

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseRcptLine.SetRange("No.", recWhseRcptHead."No.");
            if recWhseRcptLine.FindSet(true) then
                repeat
                    recWhseRcptLine.Validate("Qty. to Receive", 0);
                    recWhseRcptLine.Modify(true);
                until recWhseRcptLine.Next() = 0;

            // Update and post values
            recWhseRcptLine.Reset;
            //recRespLine.SETAUTOCALCFIELDS("Warehouse Status","Sales Order Qty. Shipped","Sales Order Qty. Invoiced");
            recRespLine.SetRange("Response No.", precRespLine."Response No.");
            recRespLine.SetRange("Source Order No.", precRespLine."Source Order No.");
            recRespLine.SetRange("Real Source Order No.", precRespLine."Real Source Order No.");
            //recRespLine.SETRANGE("Delivery Document Line Posted",FALSE);
            recRespLine.SetRange(Open, true);
            recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.", "Invoice No.");
            if recRespLine.FindSet(true) then begin
                recRespLine.ModifyAll("Error Text", '');

                repeat
                    // Handle records here
                    // Find out if the line has been previous posted
                    SetWhseRcptLineFilter(precRespHead."Order Type Option", recRespLine, recWhseRcptLine, true);
                    //recWhseRcptLine.SETRANGE("Source Line No.",recRespLine."Source Order Line No.");
                    if recWhseRcptLine.FindFirst then begin
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
                                recRespLineTmp.Insert;

                                PostWhseReceipt := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseRcptLine."Qty. Outstanding");
                                recRespLine.Modify;
                            end;
                        end else begin
                            recRespLine."Error Text" := StrSubstNo(lText003, recWhseRcptLine.FieldCaption("Item No."), recRespLine.TableCaption, recWhseRcptLine.TableCaption, recRespLine."Line No.");
                            recRespLine.Modify;
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
                    recRespLine.Modify;
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseReceipt then begin
                    Commit;
                    WhsePostReceipt.SetHideValidationDialog(true);
                    if WhsePostReceipt.Run(recWhseRcptLine) then
                        PostResultOK := WhsePostReceipt.GetCounterSourceDocOK() = 1;
                    recRespLine.Reset;
                    if recRespLineTmp.FindSet then
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false;
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify;
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
                    recRespLine.Modify;
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
        IF NOT recRespHead2.FINDFIRST THEN BEGIN  // Searching for previous posted responce.
            recRespLine.RESET;
            recRespLine.SETCURRENTKEY("Response No.", "Customer Order No.", "Customer Order Line No.");
            recRespLine.SETAUTOCALCFIELDS("Warehouse Status");
            recRespLine.SETRANGE("Response No.", precRespHead."No.");
            recRespLine.SETRANGE("Open - Shipment", TRUE);
            IF recRespLine.FINDSET THEN BEGIN
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

                    IF NOT recRespLine.FINDLAST THEN;
                    recRespLine.SETRANGE("Customer Order No.");
                UNTIL recRespLine.NEXT = 0;


            end;
        end;
        //<< 02-11-23 ZY-LD 022
    end;

    local procedure PostTransferOrderRespDocShip(var precRespHead: Record "Rcpt. Response Header"; precRespLine: Record "Rcpt. Response Line") PostResultOK: Boolean
    var
        recRespLine: Record "Rcpt. Response Line";
        recRespLineTmp: Record "Rcpt. Response Line" temporary;
        recTransHead: Record "Transfer Header";
        recWhseShipHead: Record "Warehouse Shipment Header";
        recWhseShipLine: Record "Warehouse Shipment Line";
        recVend: Record Vendor;
        i: Integer;
        ArchiveFile: File;
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        PostWhseReceipt: Boolean;
        WhseRequestFound: Boolean;
        lText001: label 'There are differences on Purchase Order No. in document "%1".';
        lText002: label '"%1" was not found. "%2": %3; "%4": %5.';
        lText003: label 'The "%1" is different on "%2" and "%3". "Line No." %4';
        lText004: label 'Warehouse Request was not found.';
        lText005: label 'You cannot handle more than the outstanding %1 units.';
        lText006: label 'Transfer Order "%1" was not found.';
    begin
        //>> 02-11-23 ZY-LD 022
        // Find Warehouse request
        recWhseShipLine.SETRANGE("Source Type", DATABASE::"Transfer Line");
        recWhseShipLine.SETRANGE("Source Document", recWhseShipLine."Source Document"::"Inbound Transfer");
        recWhseShipLine.SetRange("Source No.", precRespLine."Real Source Order No.");
        recWhseShipLine.SetRange("Source Line No.", precRespLine."Real Source Order Line No.");
        //recWhseShipLine.SETRANGE("Source No.",precRespLine."Customer Order No.");
        //recWhseShipLine.SETRANGE("Source Line No.",precRespLine."Customer Order Line No.");  // 17-08-22 ZY-LD 021

        if recWhseShipLine.FindFirst then begin
            recWhseShipHead.Get(recWhseShipLine."No.");
            WhseRequestFound := true;
        end else begin
            recTransHead.SetAutocalcFields("Completely Shipped");
            if not recTransHead.Get(precRespLine."Real Source Order No.") then begin
                precRespHead."After Post Description" := StrSubstNo(lText006, precRespLine."Real Source Order No.");
                precRespHead.Modify;
            end else
                if not recTransHead."Completely Shipped" then begin
                    if recTransHead.Status = recTransHead.Status::Open then
                        ReleaseTransferDocument.Run(recTransHead);
                    if GetSourceDocOutbound.CreateFromOutbndTransferOrderHideDialog(recTransHead) then begin
                        recWhseShipHead.SetRange("Transfer Order No.", recTransHead."No.");
                        WhseRequestFound := recWhseShipHead.FindLast;
                    end else
                        if precRespHead."After Post Description" = '' then begin
                            precRespHead."After Post Description" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                            precRespHead.Modify;
                        end;
                end;
        end;

        if WhseRequestFound then begin
            // Prepare Warehouse request for posting
            recWhseShipHead."Posting Date" := Today;
            recWhseShipHead.Modify;

            // Reset values - We need to do this every time, because a user can have entered manually in the fields.
            recWhseShipLine.SetRange("No.", recWhseShipHead."No.");
            if recWhseShipLine.FindSet(true) then
                repeat
                    recWhseShipLine.Validate("Qty. to Ship", 0);
                    recWhseShipLine.Modify(true);
                until recWhseShipLine.Next() = 0;

            // Update and post values
            recWhseShipLine.Reset;
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
                    //recWhseShipLine.SetRange("Source No.", precRespLine."Real Source Order No.");
                    //recWhseShipLine.SetRange("Source Line No.", precRespLine."Real Source Order Line No.");
                    recWhseShipLine.SETRANGE("Source No.", precRespLine."Customer Order No.");
                    recWhseShipLine.SETRANGE("Source Line No.", precRespLine."Customer Order Line No.");  // 17-08-22 ZY-LD 021
                    if recWhseShipLine.FindFirst then begin
                        if recRespLine."Product No." = recWhseShipLine."Item No." then begin
                            if (recWhseShipLine."Qty. to Ship" + recRespLine.Quantity) <= recWhseShipLine."Qty. Outstanding" then begin
                                recWhseShipLine.Validate("Qty. to Ship", recWhseShipLine."Qty. to Ship" + recRespLine.Quantity);
                                /*if recRespLine."Invoice No." <> '' then begin  // Not sure if we need this code.
                                    recWhseShipLine.Validate("Warehouse Inbound No.", precRespHead."Customer Reference");
                                    recWhseShipLine.Validate("Vendor Invoice No.", recRespLine."Invoice No.");
                                end else
                                    recWhseShipLine.Validate("Vendor Invoice No.", recRespLine."Value 1");
                                recWhseShipLine.Modify(true);*/

                                recRespLineTmp := recRespLine;
                                recRespLineTmp.Insert;

                                PostWhseReceipt := true;
                            end else begin
                                recRespLine."Error Text" := StrSubstNo(lText005, recWhseShipLine."Qty. Outstanding");
                                recRespLine.Modify;
                            end;
                        end else begin
                            recRespLine."Error Text" := StrSubstNo(lText003, recWhseShipLine.FieldCaption("Item No."), recRespLine.TableCaption, recWhseShipLine.TableCaption, recRespLine."Line No.");
                            recRespLine.Modify;
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
                    recRespLine.Modify;
                until recRespLine.Next() = 0;

                // Post warehouse request
                if PostWhseReceipt then begin
                    Commit;
                    WhsePostShipment.SetPostingSettings(false);
                    if WhsePostShipment.Run(recWhseShipLine) then
                        PostResultOK := WhsePostShipment.GetCounterSourceDocOK() = 1;
                    recRespLine.Reset;
                    if recRespLineTmp.FindSet then
                        repeat
                            if recRespLine.Get(recRespLineTmp."Response No.", recRespLineTmp."Response Line No.") then begin
                                if PostResultOK then begin
                                    recRespLine."Error Text" := '';
                                    recRespLine.Open := false;
                                end else
                                    recRespLine."Error Text" := CopyStr(GetLastErrorText, 1, MaxStrLen(precRespHead."After Post Description"));
                                recRespLine.Modify;
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
                    recRespLine.Modify;
                until recRespLine.Next() = 0;
        end;
        //<< 02-11-23 ZY-LD 022
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
            //>> 01-12-20 ZY-LD 012
            Ordertype::"Transfer Order":
                begin
                    pWhseRcptLine.SetRange("Source Type", Database::"Transfer Line");
                    pWhseRcptLine.SetRange("Source Document", pWhseRcptLine."source document"::"Inbound Transfer");
                    pWhseRcptLine.SetRange("Source No.", precRespLine."Real Source Order No.");
                    if FilterLineNo then
                        pWhseRcptLine.SetRange("Source Line No.", precRespLine."Real Source Order Line No.");
                end;
        //<< 01-12-20 ZY-LD 012
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
                recWhseInbHead.Modify;
            end else begin
                recRespHead."After Post Description" := StrSubstNo(lText001, recWhseInbHead."Warehouse Status");

                recRespLine.SetRange("Response No.", recRespHead."No.");
                recRespLine.SetAutocalcFields("Real Source Order No.", "Real Source Order Line No.");  // 20-04-22 ZY-LD 016
                if recRespLine.FindSet(true) then
                    repeat
                        //>> 20-04-22 ZY-LD 016
                        if recRespHead."Order Type Option" = recRespHead."order type option"::"Sales Return Order" then begin
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
                                EmailAddMgt.Send;
                            end;
                        end;
                        //<< 20-04-22 ZY-LD 016

                        recRespLine.Open := false;
                        recRespLine.Modify;
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
        recWhseSetup.Get;
        if GuiAllowed or recWhseSetup.WhsePostingAllowed then begin
            ZGT.OpenProgressWindow(lText001, 1);
            ZGT.UpdateProgressWindow(lText001, 0, true);
            recWarehouse.SetRange(Warehouse, recWarehouse.Warehouse::VCK);
            recWarehouse.FindFirst;
            recWarehouse.TestField("Warehouse Outbound FTP Code");
            FtpMgt.DownloadFolder(recWarehouse."Warehouse Outbound FTP Code");
            ZGT.CloseProgressWindow;

            if Import then
                case Type of
                    Type::"VCK Purch. Response":
                        PurchOrderRespImport(0);
                    else begin
                        PurchOrderRespImport(0);
                    end;
                end;
        end;
    end;
}
