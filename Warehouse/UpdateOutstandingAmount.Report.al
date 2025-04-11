Report 50085 "Update Outstanding Amount"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("VCK Delivery Document Line"; "VCK Delivery Document Line")
        {
            DataItemTableView = where("Warehouse Status" = const(New), "Document Type" = const(Sales), Quantity = filter(> 0));

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("VCK Delivery Document Line"."Document No.", 0, true);

                if "VCK Delivery Document Line".Quantity > 0 then begin
                    if recSalesLine.Get(recSalesLine."document type"::Order, "VCK Delivery Document Line"."Sales Order No.", "VCK Delivery Document Line"."Sales Order Line No.") then begin
                        "VCK Delivery Document Line"."Outstanding Amount (LCY)" := recSalesLine."Outstanding Amount (LCY)";
                        "VCK Delivery Document Line".Modify(true);
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "VCK Delivery Document Line".Count);
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

    var
        recSalesLine: Record "Sales Line";
        ZGT: Codeunit "ZyXEL General Tools";
}
