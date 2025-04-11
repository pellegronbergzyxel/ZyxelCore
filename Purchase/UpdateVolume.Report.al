Report 50069 "Update Volume"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "Unit Volume";
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("Document Type", Type, "No.", Quantity) where("Document Type" = const(Order), Type = const(Item), "Outstanding Quantity" = filter(<> 0), "Unit Volume" = const(0));

                trigger OnAfterGetRecord()
                begin
                    recPurchLine := "Purchase Line";
                    recPurchLine."Unit Volume" := Item."Unit Volume" * "Purchase Line"."Qty. per Unit of Measure";
                    recPurchLine.Modify;
                end;
            }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "No." = field("No.");
                DataItemTableView = sorting("Order No.", "Order Line No.") where(Type = const(Item), "Qty. Rcd. Not Invoiced" = filter(<> 0), "Unit Volume" = const(0));

                trigger OnAfterGetRecord()
                begin
                    recPurchRcptLine := "Purch. Rcpt. Line";
                    recPurchRcptLine."Unit Volume" := Item."Unit Volume" * "Purch. Rcpt. Line"."Qty. per Unit of Measure";
                    recPurchRcptLine.Modify;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(Item."No.", 0, true);

                if Item."Volume (cm3)" <> 0 then
                    Item."Unit Volume" := Item."Volume (cm3)"
                else
                    Item."Unit Volume" := Item."Volume (ctn)";
                Item.Modify(true);
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', Item.Count);
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
        recPurchLine: Record "Purchase Line";
        recPurchRcptLine: Record "Purch. Rcpt. Line";
        ZGT: Codeunit "ZyXEL General Tools";
}
