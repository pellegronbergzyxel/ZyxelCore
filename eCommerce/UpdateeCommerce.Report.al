report 50074 "Update eCommerce"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("eCommerce Order Archive"; "eCommerce Order Archive")
        {
            RequestFilterFields = "Order Date", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("eCommerce Order Archive"."eCommerce Order Id", 0, true);

                if "eCommerce Order Archive"."Transaction Type" = "eCommerce Order Archive"."transaction type"::Order then begin
                    Clear(recSalesInvHead);
                    recSalesInvHead.SetRange("External Document No.", "eCommerce Order Archive"."eCommerce Order Id");
                    recSalesInvHead.SetRange("External Invoice No.", "eCommerce Order Archive"."Invoice No.");
                    if not recSalesInvHead.FindFirst() then begin
                        recSalesInvHead.SetRange("External Invoice No.");
                        if not recSalesInvHead.FindFirst() then;
                    end;

                    //>> 13-04-22 ZY-LD 059
                    recValueEntry.SetRange("Document Type", recValueEntry."document type"::"Sales Invoice");
                    recValueEntry.SetRange("Document No.", recSalesInvHead."No.");
                    recValueEntry.FindFirst();

                    recItemLedgEntry.Get(recValueEntry."Item Ledger Entry No.");

                    "eCommerce Order Archive"."Sales Shipment No." := recItemLedgEntry."Document No.";
                    "eCommerce Order Archive".Modify(true);
                    //<< 13-04-22 ZY-LD 059
                end else begin
                    Clear(recSalesCrMemoHead);
                    recSalesCrMemoHead.SetRange("External Document No.", "eCommerce Order Archive"."eCommerce Order Id");
                    recSalesCrMemoHead.SetRange("External Invoice No.", "eCommerce Order Archive"."Invoice No.");
                    if not recSalesCrMemoHead.FindFirst() then begin
                        recSalesCrMemoHead.SetRange("External Invoice No.");
                        if not recSalesCrMemoHead.FindFirst() then;
                    end;

                    //>> 13-04-22 ZY-LD 059
                    recValueEntry.SetCurrentkey("Document Type", "Document No.");
                    recValueEntry.SetRange("Document Type", recValueEntry."document type"::"Sales Credit Memo");
                    recValueEntry.SetRange("Document No.", recSalesCrMemoHead."No.");
                    if recValueEntry.FindFirst() then begin
                        recItemLedgEntry.Get(recValueEntry."Item Ledger Entry No.");

                        "eCommerce Order Archive"."Sales Shipment No." := recItemLedgEntry."Document No.";
                        "eCommerce Order Archive".Modify(true);
                    end;
                    //<< 13-04-22 ZY-LD 059
                end;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "eCommerce Order Archive".Count());
                recValueEntry.SetCurrentkey("Document Type", "Document No.");
            end;
        }
    }

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 50074, 2);  // 14-10-20 ZY-LD 000
    end;

    var
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
        recValueEntry: Record "Value Entry";
        recItemLedgEntry: Record "Item Ledger Entry";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
}
