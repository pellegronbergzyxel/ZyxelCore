xmlport 50063 "HQ Serial No."
{
    // 001. 04-08-20 ZY-LD 2020080410000074 - COPYSTR is added.
    // 002. 05-03-21 ZY-LD 000 - If a sales invoice line is splitted into two lines, both lines will point to the same serial no., and we only need to send it once.
    Permissions = tabledata "Sales Invoice Header" = m;

    Caption = 'HQ Serial No.';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/sno';
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("VCK Delivery Document SNos"; "VCK Delivery Document SNos")
            {
                MinOccurs = Zero;
                XmlName = 'SerialNo';
                SourceTableView = sorting("Sales Order No.", "Sales Order Line No.");
                UseTemporary = true;
                fieldelement(No; "VCK Delivery Document SNos"."Serial No.")
                {
                }
                fieldelement(DeliveryDocumentNo; "VCK Delivery Document SNos"."Delivery Document No.")
                {
                }
                fieldelement(ItemNo; "VCK Delivery Document SNos"."Item No.")
                {
                }
                fieldelement(ShipmentDate; "VCK Delivery Document SNos"."Shipment Date (Tmp)")
                {
                }
                fieldelement(InvoiceNo; "VCK Delivery Document SNos"."Invoice No. (Tmp)")
                {
                }
                fieldelement(InvoiceNoEndCustomer; "VCK Delivery Document SNos"."Invoice No. for End Cust.(Tmp)")
                {
                }
                fieldelement(ExternalDocumentNo; "VCK Delivery Document SNos"."External Document No. (Tmp)")
                {
                }
                fieldelement(CustomerNo; "VCK Delivery Document SNos"."Customer No. (Tmp)")
                {
                }
                fieldelement(CustomerName; "VCK Delivery Document SNos"."Customer Name (Tmp)")
                {
                }
                fieldelement(DivisionCode; "VCK Delivery Document SNos"."Division Code (Tmp)")
                {
                }
                textelement(RMAPaidBy)
                {
                    MaxOccurs = Once;

                    trigger OnBeforePassVariable()
                    begin
                        RMAPaidBy := Format("VCK Delivery Document SNos"."RMA is Paid By (Tmp)");
                    end;
                }
            }
            textelement(AllRecordsSent)
            {
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

    var
        recWebSerLogEntry: Record "Web Service Log Entry";
        ZGT: Codeunit "ZyXEL General Tools";


    procedure GetData(SourceType: Code[10]; SourceNo: Code[20])
    var
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesInvLine: Record "Sales Invoice Line";
        recSalesShipLine: Record "Sales Shipment Line";
        recSerialNo: Record "VCK Delivery Document SNos";
        recTransRcptHead: Record "Transfer Receipt Header";
        recDelDocLine: Record "VCK Delivery Document Line";
        recLocation: Record Location;
        recItem: Record Item;
    begin
        AllRecordsSent := 'Yes';

        if SourceType in ['SALE', 'BLANK'] then begin
            recSalesInvHead.SetCurrentkey("Serial Numbers Status", "Invoice No. for End Customer");
            recSalesInvHead.SetRange("Serial Numbers Status", recSalesInvHead."serial numbers status"::Attached);
            recSalesInvHead.SetFilter("Invoice No. for End Customer", '<>%1', '');
            if SourceNo <> 'BLANK' then begin
                recSalesInvHead.SetRange("No.", SourceNo);
                recSalesInvHead.SetRange("Serial Numbers Status", recSalesInvHead."serial numbers status"::Rejected);
            end;
            if recSalesInvHead.FindFirst() then begin
                CreateWebServiceLog(recSalesInvHead."No.");
                recSerialNo.SetCurrentkey("Sales Order No.", "Sales Order Line No.");

                recSalesInvLine.SetRange("Document No.", recSalesInvHead."No.");
                if recSalesInvLine.FindSet() then
                    repeat
                        if recSalesShipLine.Get(recSalesInvLine."Shipment No.", recSalesInvLine."Shipment Line No.") then begin
                            recSerialNo.SetRange("Sales Order No.", recSalesShipLine."Order No.");
                            recSerialNo.SetRange("Sales Order Line No.", recSalesShipLine."Order Line No.");
                            if recSerialNo.FindSet() then begin
                                recItem.Get(recSalesShipLine."No.");
                                repeat
                                    "VCK Delivery Document SNos" := recSerialNo;
                                    "VCK Delivery Document SNos"."Shipment Date (Tmp)" := recSalesShipLine."Posting Date";
                                    "VCK Delivery Document SNos"."Invoice No. (Tmp)" := recSalesInvHead."No.";
                                    "VCK Delivery Document SNos"."Invoice No. for End Cust.(Tmp)" := recSalesInvHead."Invoice No. for End Customer";
                                    "VCK Delivery Document SNos"."External Document No. (Tmp)" := recSalesInvHead."External Document No.";
                                    "VCK Delivery Document SNos"."Customer No. (Tmp)" := recSalesInvHead."Sell-to Customer No.";
                                    "VCK Delivery Document SNos"."Customer Name (Tmp)" := recSalesInvHead."Sell-to Customer Name";
                                    "VCK Delivery Document SNos"."Division Code (Tmp)" := CopyStr(recSalesInvHead."Shortcut Dimension 1 Code", 1, 2);  // 04-08-20 ZY-LD 001
                                    if ZGT.IsZNetCompany then
                                        "VCK Delivery Document SNos"."RMA is Paid By (Tmp)" := "VCK Delivery Document SNos"."rma is paid by (tmp)"::ZNet
                                    else
                                        "VCK Delivery Document SNos"."RMA is Paid By (Tmp)" := "VCK Delivery Document SNos"."rma is paid by (tmp)"::Zyxel;
                                    //"VCK Delivery Document SNos".INSERT;  // 05-03-21 ZY-LD 002
                                    if "VCK Delivery Document SNos".Insert() then  // 05-03-21 ZY-LD 002
                                        recWebSerLogEntry."Quantity Sent" += 1;
                                until recSerialNo.Next() = 0;
                            end;
                        end;
                    until recSalesInvLine.Next() = 0;

                recSalesInvHead."Serial Numbers Status" := recSalesInvHead."serial numbers status"::Sent;
                recSalesInvHead.Modify();

                recSalesInvHead.SetFilter("No.", '<>%1', recSalesInvHead."No.");
                if recSalesInvHead.FindFirst() then
                    AllRecordsSent := 'No';

                CloseWebServiceLog;
            end;
        end;

        if (SourceType in ['TRANSFER', 'BLANK']) and "VCK Delivery Document SNos".IsEmpty() then begin
            recTransRcptHead.SetCurrentkey("Serial Numbers Status");
            recTransRcptHead.SetRange("Serial Numbers Status", recTransRcptHead."serial numbers status"::Attached);
            if SourceNo <> 'BLANK' then begin
                recTransRcptHead.SetRange("No.", SourceNo);
                recTransRcptHead.SetRange("Serial Numbers Status", recTransRcptHead."serial numbers status"::Rejected);
            end;
            if recTransRcptHead.FindFirst() then begin
                CreateWebServiceLog(recTransRcptHead."No.");
                recDelDocLine.SetCurrentkey("Transfer Order No.");
                recSerialNo.SetCurrentkey("Delivery Document No.", "Delivery Document Line No.");

                recDelDocLine.SetRange("Transfer Order No.", recTransRcptHead."Transfer Order No.");
                if recDelDocLine.FindFirst() then
                    repeat
                        recSerialNo.SetRange("Delivery Document No.", recDelDocLine."Document No.");
                        recSerialNo.SetRange("Delivery Document Line No.", recDelDocLine."Line No.");
                        if recSerialNo.FindSet() then
                            repeat
                                recLocation.Get(recTransRcptHead."Transfer-to Code");
                                "VCK Delivery Document SNos" := recSerialNo;
                                "VCK Delivery Document SNos"."Shipment Date (Tmp)" := recTransRcptHead."Posting Date";
                                "VCK Delivery Document SNos"."Invoice No. (Tmp)" := recTransRcptHead."No.";
                                "VCK Delivery Document SNos"."Invoice No. for End Cust.(Tmp)" := recTransRcptHead."No.";
                                "VCK Delivery Document SNos"."External Document No. (Tmp)" := recTransRcptHead."External Document No.";
                                "VCK Delivery Document SNos"."Customer No. (Tmp)" := recTransRcptHead."Transfer-to Code";
                                "VCK Delivery Document SNos"."Customer Name (Tmp)" := recLocation.Name;
                                "VCK Delivery Document SNos"."Division Code (Tmp)" := recSalesInvHead."Shortcut Dimension 1 Code";
                                //"VCK Delivery Document SNos".INSERT;  // 05-03-21 ZY-LD 002
                                if "VCK Delivery Document SNos".Insert() then  // 05-03-21 ZY-LD 002
                                    recWebSerLogEntry."Quantity Sent" += 1;
                            until recSerialNo.Next() = 0;
                    until recDelDocLine.Next() = 0;

                recTransRcptHead."Serial Numbers Status" := recTransRcptHead."serial numbers status"::Sent;
                recTransRcptHead.Modify();

                recTransRcptHead.SetFilter("No.", '<>%1', recTransRcptHead."No.");
                if recTransRcptHead.FindFirst() then
                    AllRecordsSent := 'No';

                CloseWebServiceLog;
            end;
        end;
    end;

    local procedure CreateWebServiceLog(pFilter: Text[250])
    begin
        Clear(recWebSerLogEntry);
        recWebSerLogEntry."Web Service Name" := 'HQWEBSERVICE';
        recWebSerLogEntry."Web Service Function" := 'Get Serial No.';
        recWebSerLogEntry.filter := pFilter;
        recWebSerLogEntry."Start Time" := CurrentDatetime;
        recWebSerLogEntry."User ID" := UserId();
        recWebSerLogEntry.Insert();
    end;

    local procedure CloseWebServiceLog()
    begin
        recWebSerLogEntry."End Time" := CurrentDatetime;
        recWebSerLogEntry.Modify();
    end;
}
