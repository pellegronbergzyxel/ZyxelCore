Report 50132 "Create Purchase Order"
{
    // 001. 02-06-21 ZY-LD 2021060110000107 - Only item lines can be sent to purchase order.
    // 002. 08-12-23 ZY-LD 000 - Delete service items.

    Caption = 'Create Purchase Order';
    Permissions = TableData "Req. Wksh. Template" = ri,
                  TableData "Requisition Wksh. Name" = ri,
                  TableData "Requisition Line" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                if recReqWkshLine.FindFirst then
                    recReqWkshLine.DeleteAll(true);

                Commit;
                recSalesLine.SetRange("Document Type", "Sales Header"."Document Type");
                recSalesLine.SetRange("Document No.", "Sales Header"."No.");
                recSalesLine.SetRange(Type, recSalesLine.Type::Item);  // 02-06-21 ZY-LD 001
                case "Sales Header"."Sales Order Type" of
                    "Sales Header"."sales order type"::"Drop Shipment":
                        GetSalesOrders.SetReqWkshLine(recReqWkshLine, 0);
                    "Sales Header"."sales order type"::"Spec. Order":
                        GetSalesOrders.SetReqWkshLine(recReqWkshLine, 1);
                end;
                GetSalesOrders.SetTableview(recSalesLine);
                GetSalesOrders.UseRequestPage(false);
                GetSalesOrders.RunModal;

                if ZGT.IsZNetCompany then
                    recVend.SetRange("SBU Company", recVend."sbu company"::"ZNet HQ")
                else
                    recVend.SetRange("SBU Company", recVend."sbu company"::"ZCom HQ");
                recVend.FindFirst;

                if recReqWkshLine.FindSet(true) then
                    repeat
                        recReqWkshLine.Validate("Vendor No.", recVend."No.");
                        recReqWkshLine.Modify(true);
                    until recReqWkshLine.Next() = 0;

                if not UpdatePurchaseOrder then
                    recReqWkshLine.DeleteAll(true);
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

    trigger OnPostReport()
    begin
        if Confirm(Text004, false) then begin
            ReleasePurchDoc.PerformManualRelease(recPurchHead);
            Message(Text005);
        end else
            Message(Text003, recPurchHead."No.");
    end;

    trigger OnPreReport()
    begin
        recReqWkshTempl.Get('REQ.');
        if not recReqWkshName.Get(recReqWkshTempl.Name, Text001) then begin
            recReqWkshName."Worksheet Template Name" := recReqWkshTempl.Name;
            recReqWkshName.Name := Text001;
            recReqWkshName.Description := Text001;
            recReqWkshName."Template Type" := recReqWkshName."template type"::"Req.";
            recReqWkshName.Insert(true);
        end;
        recReqWkshLine."Worksheet Template Name" := recReqWkshTempl.Name;
        recReqWkshLine."Journal Batch Name" := recReqWkshName.Name;
        recReqWkshLine.SetRange("Worksheet Template Name", recReqWkshName."Worksheet Template Name");
        recReqWkshLine.SetRange("Journal Batch Name", recReqWkshName.Name);

        SI.UseOfReport(3, 50132, 2);  // 14-10-20 ZY-LD 000
    end;

    var
        recReqWkshTempl: Record "Req. Wksh. Template";
        recReqWkshName: Record "Requisition Wksh. Name";
        recReqWkshLine: Record "Requisition Line";
        recSalesLine: Record "Sales Line";
        recVend: Record Vendor;
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        GetSalesOrders: Report "Get Sales Orders";
        CarryOutActionMsgReq: Report "Carry Out Action Msg. - Req.";
        Text001: label 'AUTOMATION';
        ZGT: Codeunit "ZyXEL General Tools";
        Text002: label 'DAS No.: %1. Do not unpack the pallet.';
        Text003: label 'Purchase Order %1 is created.\The purchase order must be released manually.';
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        Text004: label 'Do you want to release purchase order %1, and send it to eShop?';
        Text005: label 'Purchase Order %1 is created, released and sent to eShop.';
        SI: Codeunit "Single Instance";

    local procedure UpdatePurchaseOrder(): Boolean
    var
        Item: Record Item;
    begin
        Commit;
        CarryOutActionMsgReq.SetReqWkshLine(recReqWkshLine);
        CarryOutActionMsgReq.InitializeRequest(0D, Today, Today, Today + 30, '');
        CarryOutActionMsgReq.UseRequestPage(false);
        CarryOutActionMsgReq.RunModal;

        recPurchHead.SetRange("Special Order Sales No.", "Sales Header"."No.");
        recPurchHead.FindFirst;
        recPurchHead."Shipping Request Notes" := StrSubstNo(Text002, "Sales Header"."No.");
        recPurchHead.Modify(true);

        recPurchLine.SetRange("Document Type", recPurchHead."Document Type");
        recPurchLine.SetRange("Document No.", recPurchHead."No.");
        recPurchLine.SetRange(Type, recPurchLine.Type::Item);
        if recPurchLine.FindSet(true) then
            repeat
                //>> 08-12-23 ZY-LD 002
                Item.get(recPurchLine."No.");
                if Item.Type = Item.Type::Service then
                    recPurchLine.Delete(true)
                else begin  //<< 08-12-23 ZY-LD 002
                    recPurchLine.Validate("Requested Date From Factory", Today);
                    recPurchLine.Modify(true);
                end;
            until recPurchLine.Next() = 0;

        exit(true);
    end;
}
