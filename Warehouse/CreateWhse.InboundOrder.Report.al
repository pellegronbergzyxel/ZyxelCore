Report 50131 "Create Whse. Inbound Order"
{
    Caption = 'Create Whse. Inbound Order';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    //12-09-2025 BK #527899
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

                if ZGT.IsZNetCompany() then
                    CreateOnValue := copystr('ZNET-' + CreateOnValue, 1, 50)
                else
                    CreateOnValue := copystr('ZCOM-' + CreateOnValue, 1, 50);

                if CreateOnValue <> '' then begin
                    if CreateOnValue <> recWhseInbHead."Shipper Reference" then begin
                        CreateHeader("VCK Shipping Detail", CreateOnValue);

                        recWhseInbLine2.SetCurrentkey("Document No.", "Line No.");
                        recWhseInbLine2.SetRange("Document No.", recWhseInbHead."No.");
                        if recWhseInbLine2.FindLast() then
                            LiNo := recWhseInbLine2."Line No."
                        else
                            LiNo := 0;

                    end;

                    LiNo += 10000;
                    recWhseInbLine := "VCK Shipping Detail";
                    recWhseInbLine."Document No." := recWhseInbHead."No.";
                    recWhseInbLine."Line No." := LiNo;
                    if "VCK Shipping Detail"."Pallet No." <> '' then
                        Evaluate(recWhseInbLine."Pallet No. 2", DelChr("VCK Shipping Detail"."Pallet No.", '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'));
                    recWhseInbLine.Modify();
                end else
                    Error('');
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow();
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "VCK Shipping Detail".Count());
            end;
        }
    }

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 50131, 2);
    end;

    var
        recWhseInbHead: Record "Warehouse Inbound Header";
        recWhseInbLine: Record "VCK Shipping Detail";
        recWhseInbLine2: Record "VCK Shipping Detail";
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
        CreateOnValue: Code[50];
        LiNo: Integer;

    local procedure CreateHeader(pWhseInbLine: Record "VCK Shipping Detail"; pCreatedOnValue: Code[50])
    var
        recPurchHead: Record "Purchase Header";
        recSalesHead: Record "Sales Header";
        recTransHead: Record "Transfer Header";
        recWhseInbHead2: Record "Warehouse Inbound Header";
        recLocation: Record Location;
        lText001: label 'A document is already created on "%1".';

    begin
        recWhseInbHead2.SetCurrentkey("Shipper Reference");
        recWhseInbHead2.SetRange("Shipper Reference", pCreatedOnValue);
        recWhseInbHead2.SetRange("Location Code", pWhseInbLine.Location);
        recWhseInbHead2.SetRange("Document Status", recWhseInbHead2."document status"::Open);
        if recWhseInbHead2.FindFirst() then
            recWhseInbHead := recWhseInbHead2
        else begin
            recWhseInbHead2.SetFilter("Document Status", '<%1|%2', recWhseInbHead2."document status"::Posted, recWhseInbHead2."document status"::Error);
            if recWhseInbHead2.FindFirst() then
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
                        recWhseInbHead."Sender County" := copystr(recPurchHead."Buy-from County", 1, 10);
                        recWhseInbHead."Sender Contact" := copystr(recPurchHead."Buy-from Contact", 1, 50);
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
                        recWhseInbHead."Sender County" := copystr(recSalesHead."Sell-to County", 1, 10);
                        recWhseInbHead."Sender Contact" := copystr(recSalesHead."Sell-to Contact", 1, 50);
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
                        recWhseInbHead."Sender County" := copystr(recLocation.County, 1, 10);
                        recWhseInbHead."Sender Contact" := copystr(recLocation.Contact, 1, 50);
                        recWhseInbHead."Location Code" := recTransHead."Transfer-to Code";
                    end;
            end;

            recWhseInbHead."Bill of Lading No." := pWhseInbLine."Bill of Lading No.";
            recWhseInbHead."Container No." := Copystr(pWhseInbLine."Container No.", 1, 20);
            recWhseInbHead."Estimated Date of Departure" := pWhseInbLine.ETD;
            recWhseInbHead."Estimated Date of Arrival" := pWhseInbLine.ETA;
            recWhseInbHead."Expected Receipt Date" := pWhseInbLine."Expected Receipt Date";
            recWhseInbHead."Shipping Method" := Copystr(pWhseInbLine."Shipping Method", 1, 10);
            recWhseInbHead."Shipment No." := copystr(pWhseInbLine."Order No.", 1, 20);
            recWhseInbHead."Creation Date" := CurrentDatetime();
            recWhseInbHead."Order Type" := pWhseInbLine."Order Type";
            recWhseInbHead."Batch No." := copystr(pWhseInbLine."Batch No.", 1, 20);
            recWhseInbHead."Shipper Reference" := copystr(pCreatedOnValue, 1, 30);
            recWhseInbHead."Automatic Created" := true;
            recWhseInbHead."Vessel Code" := pWhseInbLine."Vessel Code";
            recWhseInbHead.Modify(true);
        end;
    end;
}
