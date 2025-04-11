Report 50131 "Create Whse. Inbound Order"
{
    // 001. 03-08-20 ZY-LD 2020080310000263 - There can be products for two different locations in the same container.
    // 002. 16-11-20 ZY-LD 2020111610000063 - Notice on inbounds. 08-02-21 ZY-LD - Deleted again.
    // 003. 29-01-21 ZY-LD 2021012910000154 - We received a container no., which we previous have received on a posted document. Steven couldn´t tell why.
    // 004. 14-10-21 ZY-LD 2021101210000089 - Handling Error.
    // 005. 19-05-22 ZY-LD 2022051910000119 - Update Vessel Code.
    // 006. 19-08-22 ZY-LD 2022081910000051 - If "Document Status" is blank, we can attach lines with another item no.

    Caption = 'Create Whse. Inbound Order';
    ProcessingOnly = true;

    dataset
    {
        dataitem("VCK Shipping Detail"; "VCK Shipping Detail")
        {
            DataItemTableView = sorting("Container No.", "Bill of Lading No.", "Invoice No.", Archive) where(Archive = const(false), "Document No." = filter(''), "Purchase Order No." = filter(<> ''));

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("VCK Shipping Detail"."Container No.", 0, true);

                if "VCK Shipping Detail"."Container No." <> '' then
                    CreateOnValue := "VCK Shipping Detail"."Container No."
                else
                    if "VCK Shipping Detail"."Bill of Lading No." <> '' then
                        CreateOnValue := "VCK Shipping Detail"."Bill of Lading No."
                    else
                        CreateOnValue := "VCK Shipping Detail"."Invoice No.";

                if ZGT.IsZNetCompany then
                    CreateOnValue := 'ZNET-' + CreateOnValue
                else
                    CreateOnValue := 'ZCOM-' + CreateOnValue;

                if CreateOnValue <> '' then begin
                    if CreateOnValue <> recWhseInbHead."Shipper Reference" then begin
                        CreateHeader("VCK Shipping Detail", CreateOnValue);
                        //>> 02-02-23 ZY-LD 007
                        //LiNo := 0;
                        recWhseInbLine2.SetCurrentkey("Document No.", "Line No.");
                        recWhseInbLine2.SetRange("Document No.", recWhseInbHead."No.");
                        if recWhseInbLine2.FindLast then
                            LiNo := recWhseInbLine2."Line No."
                        else
                            LiNo := 0;
                        //<< 02-02-23 ZY-LD 007
                    end;

                    LiNo += 10000;
                    recWhseInbLine := "VCK Shipping Detail";
                    recWhseInbLine."Document No." := recWhseInbHead."No.";
                    recWhseInbLine."Line No." := LiNo;
                    if "VCK Shipping Detail"."Pallet No." <> '' then
                        Evaluate(recWhseInbLine."Pallet No. 2", DelChr("VCK Shipping Detail"."Pallet No.", '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'));
                    recWhseInbLine.Modify;
                end else
                    Error('');

                PrevValue := CreateOnValue;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "VCK Shipping Detail".Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 50131, 2);  // 14-10-20 ZY-LD 000
    end;

    var
        recWhseInbHead: Record "Warehouse Inbound Header";
        recWhseInbLine: Record "VCK Shipping Detail";
        recWhseInbLine2: Record "VCK Shipping Detail";
        CreateOnValue: Code[50];
        PrevValue: Code[50];
        LiNo: Integer;
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";

    local procedure CreateHeader(pWhseInbLine: Record "VCK Shipping Detail"; pCreatedOnValue: Code[50])
    var
        recPurchHead: Record "Purchase Header";
        recSalesHead: Record "Sales Header";
        recTransHead: Record "Transfer Header";
        recWhseInbHead2: Record "Warehouse Inbound Header";
        lText001: label 'A document is already created on "%1".';
        recLocation: Record Location;
    begin
        recWhseInbHead2.SetCurrentkey("Shipper Reference");
        recWhseInbHead2.SetRange("Shipper Reference", pCreatedOnValue);
        recWhseInbHead2.SetRange("Location Code", pWhseInbLine.Location);  // 03-08-20 ZY-LD 001
        //recWhseInbHead2.SETFILTER("Document Status",'<%1',recWhseInbHead2."Document Status"::Posted);  // 29-01-21 ZY-LD 003
        //>> 19-08-22 ZY-LD 006
        recWhseInbHead2.SetRange("Document Status", recWhseInbHead2."document status"::Open);
        if recWhseInbHead2.FindFirst then
            recWhseInbHead := recWhseInbHead2
        else begin  //<< 19-08-22 ZY-LD 006
            recWhseInbHead2.SetFilter("Document Status", '<%1|%2', recWhseInbHead2."document status"::Posted, recWhseInbHead2."document status"::Error);  // 14-10-21 ZY-LD 004
            if recWhseInbHead2.FindFirst then
                Error(lText001, pCreatedOnValue);

            Clear(recWhseInbHead);
            recWhseInbHead.Insert(true);

            case pWhseInbLine."Order Type" of
                pWhseInbLine."order type"::"Purchase Order":
                    begin
                        recPurchHead.Get(recPurchHead."document type"::Order, pWhseInbLine."Purchase Order No.");
                        recWhseInbHead."Sender No." := recPurchHead."Buy-from Vendor No.";
                        recWhseInbHead."Sender Name" := recPurchHead."Buy-from Vendor Name";
                        recWhseInbHead."Sender Name 2" := recPurchHead."Buy-from Vendor Name 2";
                        recWhseInbHead."Sender Address" := recPurchHead."Buy-from Address";
                        recWhseInbHead."Sender Address 2" := recPurchHead."Buy-from Address 2";
                        recWhseInbHead."Sender Post Code" := recPurchHead."Buy-from Post Code";
                        recWhseInbHead."Sender City" := recPurchHead."Buy-from City";
                        recWhseInbHead."Sender Country/Region Code" := recPurchHead."Buy-from Country/Region Code";
                        recWhseInbHead."Sender County" := recPurchHead."Buy-from County";
                        recWhseInbHead."Sender Contact" := recPurchHead."Buy-from Contact";
                        recWhseInbHead."Location Code" := recPurchHead."Location Code";
                    end;
                pWhseInbLine."order type"::"Sales Return Order":
                    begin
                        recSalesHead.Get(recSalesHead."document type"::"Return Order", pWhseInbLine."Purchase Order No.");
                        recWhseInbHead."Sender No." := recSalesHead."Sell-to Customer No.";
                        recWhseInbHead."Sender Name" := recSalesHead."Sell-to Customer Name";
                        recWhseInbHead."Sender Name 2" := recSalesHead."Sell-to Customer Name 2";
                        recWhseInbHead."Sender Address" := recSalesHead."Sell-to Address";
                        recWhseInbHead."Sender Address 2" := recSalesHead."Sell-to Address 2";
                        recWhseInbHead."Sender Post Code" := recSalesHead."Sell-to Post Code";
                        recWhseInbHead."Sender City" := recSalesHead."Sell-to City";
                        recWhseInbHead."Sender Country/Region Code" := recSalesHead."Sell-to Country/Region Code";
                        recWhseInbHead."Sender County" := recSalesHead."Sell-to County";
                        recWhseInbHead."Sender Contact" := recSalesHead."Sell-to Contact";
                        recWhseInbHead."Location Code" := recSalesHead."Location Code";
                    end;
                pWhseInbLine."order type"::"Transfer Order":
                    begin
                        recTransHead.Get(pWhseInbLine."Purchase Order No.");
                        recLocation.Get(recTransHead."Transfer-from Code");
                        recWhseInbHead."Sender No." := recTransHead."Transfer-from Code";
                        recWhseInbHead."Sender Name" := recLocation.Name;
                        recWhseInbHead."Sender Name 2" := recLocation."Name 2";
                        recWhseInbHead."Sender Address" := recLocation.Address;
                        recWhseInbHead."Sender Address 2" := recLocation."Address 2";
                        recWhseInbHead."Sender Post Code" := recLocation."Post Code";
                        recWhseInbHead."Sender City" := recLocation.City;
                        recWhseInbHead."Sender Country/Region Code" := recLocation."Country/Region Code";
                        recWhseInbHead."Sender County" := recLocation.County;
                        recWhseInbHead."Sender Contact" := recLocation.Contact;
                        recWhseInbHead."Location Code" := recTransHead."Transfer-to Code";
                    end;
            end;

            recWhseInbHead."Bill of Lading No." := pWhseInbLine."Bill of Lading No.";
            recWhseInbHead."Container No." := pWhseInbLine."Container No.";
            recWhseInbHead."Estimated Date of Departure" := pWhseInbLine.ETD;
            recWhseInbHead."Estimated Date of Arrival" := pWhseInbLine.ETA;
            recWhseInbHead."Expected Receipt Date" := pWhseInbLine."Expected Receipt Date";
            recWhseInbHead."Shipping Method" := pWhseInbLine."Shipping Method";
            recWhseInbHead."Shipment No." := pWhseInbLine."Order No.";
            recWhseInbHead."Creation Date" := CurrentDatetime;
            recWhseInbHead."Order Type" := pWhseInbLine."Order Type";
            recWhseInbHead."Batch No." := pWhseInbLine."Batch No.";
            recWhseInbHead."Shipper Reference" := pCreatedOnValue;
            recWhseInbHead."Automatic Created" := true;
            recWhseInbHead."Vessel Code" := pWhseInbLine."Vessel Code";  // 19-05-22 ZY-LD 005
            recWhseInbHead.Modify(true);
        end;
    end;
}
