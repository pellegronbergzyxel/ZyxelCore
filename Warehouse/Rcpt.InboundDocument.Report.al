Report 50065 "Rcpt. Inbound Document"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Rcpt. Inbound Document.rdlc';
    Caption = 'Rcpt. Inbound Document';

    dataset
    {
        dataitem("Rcpt. Response Header"; "Rcpt. Response Header")
        {
            RequestFilterFields = "No.";
            column(No; "Rcpt. Response Header"."No.")
            {
            }
            column(ShipmentNo; "Rcpt. Response Header"."Shipment No.")
            {
            }
            column(ShipperReference; "Rcpt. Response Header"."Shipper Reference")
            {
            }
            column(CustomerReferenct; "Rcpt. Response Header"."Customer Reference")
            {
            }
            column(WarehouseStatus; "Rcpt. Response Header"."Warehouse Status")
            {
            }
            column(OrderType; "Rcpt. Response Header"."Order Type Option")
            {
            }
            dataitem("Rcpt. Response Line"; "Rcpt. Response Line")
            {
                CalcFields = "Real Source Order No.", "Real Source Order Line No.";
                DataItemLink = "Response No." = field("No.");
                column(ItemNo; "Rcpt. Response Line"."Product No.")
                {
                }
                column(LocationCode; "Rcpt. Response Line".Location)
                {
                }
                column(OrderedQuantity; "Rcpt. Response Line"."Ordered Qty")
                {
                }
                column(Quantity; "Rcpt. Response Line".Quantity)
                {
                }
                column(OutstandingQuantity; OutStQty)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    OutStQty := 0;
                    case "Rcpt. Response Header"."Order Type Option" of
                        "Rcpt. Response Header"."order type option"::"Sales Return Order":
                            begin
                                if recSalesLine.Get(recSalesLine."document type"::"Return Order", "Rcpt. Response Line"."Real Source Order No.", "Rcpt. Response Line"."Real Source Order Line No.") then
                                    OutStQty := recSalesLine."Outstanding Quantity";
                            end;
                        "Rcpt. Response Header"."order type option"::"Purchase Order":
                            begin
                                if recPurchLine.Get(recPurchLine."document type"::Order, "Rcpt. Response Line"."Real Source Order No.", "Rcpt. Response Line"."Real Source Order Line No.") then
                                    OutStQty := recPurchLine."Outstanding Quantity";
                            end;
                        "Rcpt. Response Header"."order type option"::"Transfer Order":
                            begin
                                if recTransLine.Get("Rcpt. Response Line"."Real Source Order No.", "Rcpt. Response Line"."Real Source Order Line No.") then
                                    OutStQty := recTransLine."Outstanding Quantity";
                            end;
                    end;
                end;
            }
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
        recPurchLine: Record "Purchase Line";
        recTransLine: Record "Transfer Line";
        OutStQty: Decimal;
}
