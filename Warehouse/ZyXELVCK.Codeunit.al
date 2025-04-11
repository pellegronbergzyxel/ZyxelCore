Codeunit 50004 "ZyXEL VCK"
{
    // 
    // Name:       All In Logistics
    // Written By: Paul Bowden
    // Date:       5/7/14
    // Purpose:    Write Orders to File to be picked up by EShop
    // 
    // 001. 14-12-18 ZY-LD 2018121410000042 - It was possible to send files to eShop from test when releasing an purchase order.
    // 002. 08-01-19 PAB CheckDeliveryDocumentLines created to compare the sales order lines to the delivery document lines.
    // 003. 06-02-19 ZY-LD 000 - Code has been reviewed, and FTP upload has been added.
    // 004. 11-04-19 ZY-LD 2019041010000125 - We only want to check on invoices.
    // 005. 30-04-19 ZY-LD P0223 - We need a commit right after the upload.
    // 006. 08-11-19 ZY-LD P0334 - Convert Codepage.
    // 007. 26-05-20 ZY-LD 2020052210000036 - Changed from if to a validation.
    // 008. 17-04-24 ZY-LD 000 - We have an issue when posting purchase responses from the warehouse where "Qty. to Receive (Base)" is zero. This is a try to avoid this.

    trigger OnRun()
    begin
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        Text002: label 'The number of Sales Order Lines %1 and the Number of Lines on the Delivery Document %2 do not match.';


    procedure SendToHQ(PurchaseOrderNo: Code[20]; Override: Boolean) rValue: Boolean
    var
        CurrFile: File;
        recPurchSetup: Record "Purchases & Payables Setup";
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        recServEnviron: Record "Server Environment";
        ServerFilename: Text;
        RemoteFilename: Text;
        FileMgt: Codeunit "File Management";
        FTPMgt: Codeunit "VisionFTP Management";
        lText001: label 'Order %1 could not upload to eShop.';
        lText002: label 'Do you want to send "%1" to eShop from "%2"?';
        ConvCodePage: Codeunit "Convert Codepage";
        SendFromTest: Boolean;
        lText003: label '"%1" must be larger or equal than today. (%2).';
    begin
        //>> 06-02-19 ZY-LD 003
        recPurchSetup.Get;
        if not recServEnviron.ProductionEnvironment then begin
            recServEnviron.Get;
            if recPurchSetup."Send Orders To EShop" then
                if Confirm(lText002, false, PurchaseOrderNo, recServEnviron.Environment) then
                    SendFromTest := true
                else
                    exit(true);
        end;

        if (recServEnviron.ProductionEnvironment and recPurchSetup."Send Orders To EShop") or
           (not recServEnviron.ProductionEnvironment and recPurchSetup."Send Orders To EShop" and SendFromTest)
        then begin
            if recPurchHead.Get(recPurchHead."document type"::Order, PurchaseOrderNo) and
              (not recPurchHead.IsEICard) and
              (not recPurchHead."EShop Order Sent") and
              (not recPurchHead."Sent to HQ") and  // The field name should have been "Do not Sent to HQ".
              (recPurchHead."Vendor Status" <> recPurchHead."vendor status"::Dispatched) and
              (recPurchHead."Vendor Status" <> recPurchHead."vendor status"::"Order Sent")
            then begin
                //>> 04-11-19 ZY-LD 006
                //    CASE recPurchHead."Buy-from Vendor No." OF
                //      recPurchSetup."EShop Vendor No." :
                //        BEGIN
                //          recPurchSetup.TESTFIELD("EShop Vendor No.");
                //          recPurchSetup.TESTFIELD("EShop FTP Folder");
                //          FTPFolder := recPurchSetup."EShop FTP Folder";
                //        END;
                //      recPurchSetup."EShop Vendor No. CH" :
                //        BEGIN
                //          recPurchSetup.TESTFIELD("EShop Vendor No. CH");
                //          recPurchSetup.TESTFIELD("EShop FTP Folder CH");
                //          FTPFolder := recPurchSetup."EShop FTP Folder CH";
                //        END;
                //    END;
                recPurchHead.TestField("FTP Code");
                //<< 04-11-19 ZY-LD 006


                ServerFilename := FileMgt.ServerTempFileName('');
                RemoteFilename := StrSubstNo('%1.txt', recPurchHead."No.");
                CurrFile.TextMode(true);
                CurrFile.Create(ServerFilename);
                CurrFile.Write('Order Header,,');
                CurrFile.Write(recPurchHead."Transport Method");
                CurrFile.Write(',');
                CurrFile.Write(StrSubstNo('Purchase Order No (*),%1,', recPurchHead."No."));
                CurrFile.Write(StrSubstNo('Shipping Mark,"%1 SO#%2 / %3, %4"', recPurchHead."Shipping Request Notes", recPurchHead."From SO No.", recPurchHead."SO Sell-to Customer Name", recPurchHead."Dist. Purch. Order No."));
                CurrFile.Write(StrSubstNo('Special Instruction,,%1 %2', recPurchHead."SO Sell-to Customer No", recPurchHead."SO Sell-to Customer Name"));
                CurrFile.Write('Additional E-mail List,,');
                CurrFile.Write(StrSubstNo('Distributor PO#,%1,', recPurchHead."Dist. Purch. Order No."));
                CurrFile.Write(',,');
                CurrFile.Write('Order Line,,');
                CurrFile.Write('Line Number (*),Part Number (*),Quantity (*),Request Date (*)');

                recPurchLine.SetRange("Document Type", recPurchLine."document type"::Order);
                recPurchLine.SetRange("Document No.", recPurchHead."No.");
                recPurchLine.SetRange(Type, recPurchLine.Type::Item);
                if recPurchLine.FindSet(true) then begin
                    recPurchLine.SuspendStatusCheck(true);  // 17-04-24 ZY-LD 008 
                    repeat
                        //>> 26-05-20 ZY-LD 007
                        //IF recPurchLine."Requested Date From Factory" <> 0D THEN BEGIN
                        if recPurchLine."Requested Date From Factory" < Today then
                            Error(lText003, recPurchLine.FieldCaption("Requested Date From Factory"), recPurchLine."Requested Date From Factory");
                        //<< 26-05-20 ZY-LD 007

                        recPurchLine.Validate("Qty. to Receive", 0);  // 17-04-24 ZY-LD 008
                        recPurchLine."Vendor Status" := recPurchLine."vendor status"::"Order Created";
                        recPurchLine.Modify;

                        CurrFile.Write(
                          StrSubstNo('%1,%2,%3,%4',
                            recPurchLine."Line No.",
                            recPurchLine."No.",
                            Format(recPurchLine.Quantity, 0, 9),
                            Format(recPurchLine."Requested Date From Factory", 0, 9)));
                    //END;
                    until recPurchLine.Next() = 0;
                    recPurchLine.SuspendStatusCheck(false);  // 17-04-24 ZY-LD 008
                end;
                CurrFile.Close;
                ConvCodePage.ConvertCodepage(ServerFilename, '', '', ConvCodePage.CodepageUTF8);  // 08-11-19 ZY-LD 006

                //IF FTPMgt.UploadFile(FTPFolder,ServerFilename,RemoteFilename) THEN BEGIN  // 04-11-19 ZY-LD 006
                if FTPMgt.UploadFile(recPurchHead."FTP Code", ServerFilename, RemoteFilename) then begin  // 04-11-19 ZY-LD 006
                    recPurchHead."Vendor Status" := recPurchHead."vendor status"::"Order Created";
                    recPurchHead."EShop Order Sent" := true;
                    recPurchHead.Modify;
                    Commit;  // 30-04-19 ZY-LD 005
                    rValue := true;
                end else
                    Error(lText001, recPurchHead."No.");
            end;
        end;
        //<< 06-02-19 ZY-LD 003
    end;


    procedure GetTransportMethod(IsEiCard: Boolean) TransportCode: Code[10]
    var
        recSetup: Record "Purchases & Payables Setup";
    begin
        if recSetup.FindFirst then begin
            if IsEiCard then
                TransportCode := recSetup."EiCar Default Transport Method";
            if not IsEiCard then
                TransportCode := recSetup."EShop Default Transport Method";
        end;
    end;


    procedure CheckRequestedDate(PurchaseOrderNo: Code[20]) OK: Boolean
    var
        recPurchaseHeader: Record "Purchase Header";
        recSetup: Record "Purchases & Payables Setup";
        VendorNo: Code[20];
        CanCheck: Boolean;
    begin
        CanCheck := true;
        recPurchaseHeader.SetFilter("No.", PurchaseOrderNo);
        if recPurchaseHeader.FindFirst then begin
            if recSetup.FindFirst then begin
                VendorNo := recSetup."EShop Vendor No.";
            end;
        end;
        if not recPurchaseHeader.FindFirst then begin
            CanCheck := false;
        end;
        if recPurchaseHeader.IsEICard then
            CanCheck := false;
        if VendorNo <> recPurchaseHeader."Buy-from Vendor No." then
            CanCheck := false;
        if CanCheck = false then begin
            exit(true);
        end;
        /*
        recPurchaseLine.SETFILTER("Document No.",recPurchaseHeader."No.");
        recPurchaseLine.SETRANGE(Type,recPurchaseLine.Type::Item);
        IF recPurchaseLine.FINDFIRST THEN BEGIN
          REPEAT
            IF FORMAT(recPurchaseLine."Requested Date From Factory")='' THEN
              EXIT(FALSE);
          UNTIL recPurchaseLine.Next() = 0;
        END;
        */
        exit(true);

    end;


    procedure CheckTransportType(PurchaseHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        //>> 26-03-24 ZY-LD 000
        if ZGT.IsRhq and (not PurchaseHeader.IsEICard) then begin
            PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
            PurchLine.SetRange("Document No.", PurchaseHeader."No.");
            PurchLine.SetRange(Type, PurchLine.Type::Item);
            if PurchLine.FindFirst() then
                PurchaseHeader.TestField("Transport Method");
        end;

        /*CanCheck := true;
        recPurchaseHeader.SetFilter("No.", PurchaseOrderNo);
        if recPurchaseHeader.FindFirst then begin
            if recSetup.FindFirst then begin
                VendorNo := recSetup."EShop Vendor No.";
            end;
        end;
        if not recPurchaseHeader.FindFirst then begin
            CanCheck := false;
        end;
        if recPurchaseHeader.IsEICard then
            CanCheck := false;
        if VendorNo <> recPurchaseHeader."Buy-from Vendor No." then
            CanCheck := false;
        if CanCheck = false then begin
            exit(true);
        end;

        if recPurchaseHeader."Transport Method" = '' then
            exit(false);
        if recPurchaseHeader."Transport Method" <> '' then
            exit(true);*/
        //<< 26-03-24 ZY-LD 000            
    end;


    procedure GetCountryDeliveryDaysCountrie()
    var
        recCountryDeliveryDays: Record "VCK Country Shipment Days";
        recCountryRegion: Record "Country/Region";
    begin
        if recCountryRegion.FindFirst then begin
            repeat
                recCountryDeliveryDays.SetFilter("Country Code", recCountryRegion.Code);
                if not recCountryDeliveryDays.FindFirst then begin
                    recCountryDeliveryDays.Init;
                    recCountryDeliveryDays."Country Code" := recCountryRegion.Code;
                    recCountryDeliveryDays.Insert;
                end;
            until recCountryRegion.Next() = 0;
        end;
    end;


    procedure CheckDeliveryDocumentLines(SalesInvoiceNo: Code[20])
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        SalesLineCount: Integer;
        recVCKDeliveryDocumentLine: Record "VCK Delivery Document Line";
        DDLineCount: Integer;
    begin
        // PAB 08-01-19
        if ZGT.IsRhq then begin
            recSalesHeader.SetRange("Document Type", recSalesHeader."document type"::Invoice);  // 11-04-19 ZY-LD 004
            recSalesHeader.SetRange("No.", SalesInvoiceNo);
            recSalesHeader.SetRange("Sales Order Type", recSalesHeader."sales order type"::Normal);
            if recSalesHeader.FindFirst then begin
                recSalesLine.SetRange("Document Type", recSalesHeader."Document Type");  // 11-04-19 ZY-LD 004
                recSalesLine.SetRange("Document No.", SalesInvoiceNo);
                recSalesLine.SetFilter(Quantity, '>0');
                if recSalesLine.FindFirst then
                    SalesLineCount := recSalesLine.Count;
                recVCKDeliveryDocumentLine.SetFilter("Sales Order No.", SalesInvoiceNo);
                if recVCKDeliveryDocumentLine.FindFirst then
                    DDLineCount := recVCKDeliveryDocumentLine.Count;
                if SalesLineCount <> DDLineCount then
                    Error(Text002, SalesLineCount, DDLineCount);
            end;
        end;
    end;
}
