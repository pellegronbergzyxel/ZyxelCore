XmlPort 50068 "WS Unshipped Quantity"
{
    // 001. 16-01-23 ZY-LD 2023011610000059 - When there are no lines, the unshipped quantity in the sister company doesn´t get deleted.

    Caption = 'WS Unshipped Quantity';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/uq';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement(UnshippedPurchaseOrder; "Unshipped Purchase Order")
            {
                XmlName = 'UnshippedQuantity';
                MinOccurs = Zero;
                UseTemporary = true;
                fieldelement(DocumentNo; UnshippedPurchaseOrder."Purchase Order No.")
                {
                }
                fieldelement(DocumentLineNo; UnshippedPurchaseOrder."Purchase Order Line No.")
                {
                }
                fieldelement(ItemNo; UnshippedPurchaseOrder."Item No.")
                {
                }
                fieldelement(EtdDate; UnshippedPurchaseOrder."ETD Date")
                {
                }
                fieldelement(EtaDate; UnshippedPurchaseOrder."ETA Date")
                {
                }
                fieldelement(ShippingOrderEtd; UnshippedPurchaseOrder."Shipping Order ETD Date")
                {
                }
                fieldelement(ExpectedReceiptDate; UnshippedPurchaseOrder."Expected Receipt Date")
                {
                }
                fieldelement(Quantity; UnshippedPurchaseOrder.Quantity)
                {
                }
                fieldelement(UnitPrice; UnshippedPurchaseOrder."Unit Price")
                {
                }
                fieldelement(HQSalesOrderLineID; UnshippedPurchaseOrder."Sales Order Line ID")  // 03-11-23 ZY-LD 001
                {
                }
            }
            // Unshipped quantity has more than one line with the same Purchase Order Line No. therefore can purchase line not be used.            
            /*            tableelement(PurchaseLine; "Purchase Line")
                        {
                            MinOccurs = Zero;
                            XmlName = 'UnshippedQuantity';
                            UseTemporary = true;
                            fieldelement(DocumentNo; PurchaseLine."Document No.")
                            {
                            }
                            fieldelement(DocumentLineNo; PurchaseLine."Line No.")
                            {
                            }
                            fieldelement(ItemNo; PurchaseLine."No.")
                            {
                            }
                            fieldelement(EtdDate; PurchaseLine."ETD Date")
                            {
                            }
                            fieldelement(EtaDate; PurchaseLine.ETA)
                            {
                            }
                            fieldelement(ExpectedReceiptDate; PurchaseLine."Expected Receipt Date")
                            {
                            }
                            fieldelement(Quantity; PurchaseLine.Quantity)
                            {
                            }
                            fieldelement(UnitPrice; PurchaseLine."Direct Unit Cost")
                            {
                            }

                            trigger OnBeforeInsertRecord()
                            begin
                                PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                                PurchaseLine.Type := PurchaseLine.Type::Item;
                            end;
                        }*/
        }
    }

    procedure SetData(pCustomerNo: Code[20]): Boolean
    var
        recSalesLine: Record "Sales Line";
        EntryNo: Integer;
        lText001: label 'EMPTY';
    begin
        recSalesLine.SetRange("Document Type", recSalesLine."document type"::Order);
        recSalesLine.SetRange("Sell-to Customer No.", pCustomerNo);
        recSalesLine.SetRange(Type, recSalesLine.Type::Item);
        recSalesLine.SetFilter("No.", '<>%1', '');
        recSalesLine.SetRange("Completely Invoiced", false);
        recSalesLine.SetFilter("Ext Vend Purch. Order No.", '<>%1', '');
        if recSalesLine.FindFirst then begin
            repeat
                EntryNo += 1;
                UnshippedPurchaseOrder."Sales Order Line ID" := StrSubstNo('%1_%2', recSalesLine."Document No.", recSalesLine."Line No.");
                UnshippedPurchaseOrder."Purchase Order No." := recSalesLine."Ext Vend Purch. Order No.";
                UnshippedPurchaseOrder."Purchase Order Line No." := recSalesLine."Ext Vend Purch. Order Line No.";
                UnshippedPurchaseOrder."Item No." := recSalesLine."No.";
                UnshippedPurchaseOrder."ETD Date" := recSalesLine."Shipment Date";
                UnshippedPurchaseOrder."ETA Date" := recSalesLine."Shipment Date";
                UnshippedPurchaseOrder."Expected receipt date" := recSalesLine."Shipment Date";
                UnshippedPurchaseOrder.Quantity := recSalesLine.Quantity;
                UnshippedPurchaseOrder."Unit Price" := 0;
                UnshippedPurchaseOrder.Insert;
            until recSalesLine.Next() = 0;
        end else begin
            //>> 16-01-23 ZY-LD 001
            UnshippedPurchaseOrder."Sales Order Line ID" := '999';
            UnshippedPurchaseOrder."Purchase Order No." := lText001;
            UnshippedPurchaseOrder.Insert;
            //<< 16-01-23 ZY-LD 001
        end;
        exit(true);
    end;

    procedure GetData(var TempUnshipPurchOrder: Record "Unshipped Purchase Order" temporary)
    begin
        if UnshippedPurchaseOrder.FindSet() then
            repeat
                TempUnshipPurchOrder := UnshippedPurchaseOrder;
                TempUnshipPurchOrder.Insert();
            until UnshippedPurchaseOrder.Next() = 0;
    end;
}
