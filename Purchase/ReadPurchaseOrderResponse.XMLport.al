XmlPort 50059 "Read Purchase Order Response"
{


    Caption = 'Read Purchase Order Response';
    DefaultNamespace = 'http://Allin.BizTalk.Schemas.ZyXELSP_BTS_Response_PO';
    Direction = Import;
    Encoding = UTF8;
    Format = Xml;
    FormatEvaluate = Xml;  // 28-08-24 ZY-LD Changed from Legacy to Xml, because of wrong digits at import.
    PreserveWhiteSpace = false;
    UseDefaultNamespace = false;
    UseLax = false;
    UseRequestPage = false;

    schema
    {
        tableelement("Rcpt. Response Header"; "Rcpt. Response Header")
        {
            XmlName = 'PurchaseOrderResponse';
            fieldelement(OrderNo; "Rcpt. Response Header"."Order No.")
            {
            }
            fieldelement(Status; "Rcpt. Response Header".Status)
            {
            }
            fieldelement(CostCenter; "Rcpt. Response Header"."Cost Center")
            {
                MaxOccurs = Unbounded;
                MinOccurs = Zero;
            }
            fieldelement(OrderType; "Rcpt. Response Header"."Order Type")
            {

                trigger OnAfterAssignField()
                begin
                    case "Rcpt. Response Header"."Order Type" of
                        'PO':
                            "Rcpt. Response Header"."Order Type Option" := "Rcpt. Response Header"."order type option"::"Purchase Order";
                        'SR':
                            "Rcpt. Response Header"."Order Type Option" := "Rcpt. Response Header"."order type option"::"Sales Return Order";
                        'TO':
                            "Rcpt. Response Header"."Order Type Option" := "Rcpt. Response Header"."order type option"::"Transfer Order";
                    end;
                end;
            }
            textelement(ShipmentNo)
            {
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    "Rcpt. Response Header"."Shipment No." := CopyStr(ShipmentNo, 1, MaxStrLen("Rcpt. Response Header"."Shipment No."));
                end;
            }
            textelement(ShipperReference)
            {
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    "Rcpt. Response Header"."Shipper Reference" := CopyStr(ShipperReference, 1, MaxStrLen(recRcptRespHead."Shipper Reference"));
                end;
            }
            fieldelement(CustomerReference; "Rcpt. Response Header"."Customer Reference")
            {
            }
            fieldelement(CustomerMessageNo; "Rcpt. Response Header"."Customer Message No.")
            {
            }
            textelement(SystemDateTime)
            {

                trigger OnAfterAssignVariable()
                begin
                    "Rcpt. Response Header"."System Date Time" := VCKXML.ConvertTextToDateTime(SystemDateTime);
                end;
            }
            textelement(ReceiptDateTime)
            {
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    "Rcpt. Response Header"."Receipt Date Time" := VCKXML.ConvertTextToDateTime(ReceiptDateTime);
                end;
            }
            textelement(PostingDateTime)
            {
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    "Rcpt. Response Header"."Posting Date Time" := VCKXML.ConvertTextToDateTime(PostingDateTime);
                end;
            }
            textelement(costcenter1)
            {
                MinOccurs = Zero;
                XmlName = 'CostCenter';
            }
            textelement("<deliveryterms>")
            {
                MinOccurs = Zero;
                XmlName = 'DeliveryTerms';
                fieldelement(Incoterm; "Rcpt. Response Header".Incoterm)
                {
                    MinOccurs = Zero;
                }
                fieldelement(City; "Rcpt. Response Header".City)
                {
                    MinOccurs = Zero;
                }
            }
            fieldelement(ModeOfTransport; "Rcpt. Response Header"."Mode of Transport")
            {
                MinOccurs = Zero;
            }
            fieldelement(Connote; "Rcpt. Response Header".Connote)
            {
                MinOccurs = Zero;
            }
            fieldelement(Carrier; "Rcpt. Response Header".Carrier)
            {
                MinOccurs = Zero;
            }
            fieldelement(Colli; "Rcpt. Response Header".Colli)
            {
                MinOccurs = Zero;
            }
            fieldelement(Weight; "Rcpt. Response Header".Weight)
            {
            }
            fieldelement(Volume; "Rcpt. Response Header".Volume)
            {
                MinOccurs = Zero;
            }
            textelement(CustomerData)
            {
                fieldelement(Value1; "Rcpt. Response Header"."Value 1")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value2; "Rcpt. Response Header"."Value 2")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value3; "Rcpt. Response Header"."Value 3")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value4; "Rcpt. Response Header"."Value 4")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value5; "Rcpt. Response Header"."Value 5")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value6; "Rcpt. Response Header"."Value 6")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value7; "Rcpt. Response Header"."Value 7")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value8; "Rcpt. Response Header"."Value 8")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value9; "Rcpt. Response Header"."Value 9")
                {
                    MinOccurs = Zero;
                }
            }
            textelement("<items>")
            {
                XmlName = 'Items';
                tableelement("Rcpt. Response Line"; "Rcpt. Response Line")
                {
                    LinkFields = "Response No." = field("No.");
                    LinkTable = "Rcpt. Response Header";
                    MinOccurs = Zero;
                    XmlName = 'Item';
                    textelement(Index)
                    {
                    }
                    fieldelement(LineNo; "Rcpt. Response Line"."Line No.")
                    {
                    }
                    fieldelement(ItemNo; "Rcpt. Response Line"."Item No.")
                    {
                    }
                    fieldelement(ProductNo; "Rcpt. Response Line"."Product No.")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(Warehouse; "Rcpt. Response Line".Warehouse)
                    {
                        FieldValidate = no;
                    }
                    fieldelement(Location; "Rcpt. Response Line".Location)
                    {
                        FieldValidate = no;
                    }
                    fieldelement(Grade; "Rcpt. Response Line".Grade)
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(OrderedQty; "Rcpt. Response Line"."Ordered Qty")
                    {
                    }
                    fieldelement(Quantity; "Rcpt. Response Line".Quantity)
                    {
                    }
                    fieldelement(CustomerOrderNo; "Rcpt. Response Line"."Customer Order No.")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(CustomerOrderLineNo; "Rcpt. Response Line"."Customer Order Line No.")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(PurchaseOrderNo; "Rcpt. Response Line"."Source Order No.")
                    {

                        trigger OnAfterAssignField()
                        begin
                            //>> 10-12-20 ZY-LD 005
                            if "Rcpt. Response Line"."Source Order No." <> "Rcpt. Response Header"."Customer Reference" then
                                "Rcpt. Response Line"."Source Order No." := "Rcpt. Response Header"."Customer Reference";
                            //<< 10-12-20 ZY-LD 005
                        end;
                    }
                    fieldelement(PurchaseOrderLineNo; "Rcpt. Response Line"."Source Order Line No.")
                    {
                    }
                    textelement(customerdata1)
                    {
                        XmlName = 'CustomerData';
                        fieldelement(Value1; "Rcpt. Response Line"."Value 1")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value2; "Rcpt. Response Line"."Value 2")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value3; "Rcpt. Response Line"."Value 3")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value4; "Rcpt. Response Line"."Value 4")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value5; "Rcpt. Response Line"."Value 5")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value6; "Rcpt. Response Line"."Value 6")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value7; "Rcpt. Response Line"."Value 7")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value8; "Rcpt. Response Line"."Value 8")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value9; "Rcpt. Response Line"."Value 9")
                        {
                            MinOccurs = Zero;
                        }
                    }
                    textelement(SerialNumbers)
                    {
                        MinOccurs = Zero;
                        textelement(SerialNumber)
                        {
                            MinOccurs = Zero;
                        }
                    }

                    trigger OnAfterInitRecord()
                    begin
                        "Rcpt. Response Line"."Response No." := "Rcpt. Response Header"."No.";
                        "Rcpt. Response Line"."Response Line No." := LineNo;
                        LineNo += 10000;
                    end;
                }
            }

            trigger OnBeforeInsertRecord()
            begin

                Evaluate(StatusInt, "Rcpt. Response Header".Status);
                "Rcpt. Response Header"."Warehouse Status" := StatusInt / 10;
                "Rcpt. Response Header"."File Management Entry No." := gFileMgtEntryNo;

                if "Rcpt. Response Header"."Customer Message No." <> '' then begin
                    recWhseIndbHead.SetRange("Message No.", "Rcpt. Response Header"."Customer Message No.");
                    if recWhseIndbHead.FindFirst() then
                        if ("Rcpt. Response Header"."Customer Reference" <> recWhseIndbHead."No.") then
                            "Rcpt. Response Header"."After Post Description" :=
                              StrSubstNo(Text003,
                                "Rcpt. Response Header".FieldCaption("Customer Message No."),
                                "Rcpt. Response Header"."Customer Message No.",
                                recWhseIndbHead.TableCaption,
                                recWhseIndbHead."No.")
                        else
                            "Rcpt. Response Header"."Customer Reference" := recWhseIndbHead."No.";
                end else begin
                    recWhseIndbHead.SetRange("Shipper Reference", "Rcpt. Response Header"."Shipper Reference");
                    if recWhseIndbHead.FindFirst() then begin
                        "Rcpt. Response Header"."Customer Reference" := recWhseIndbHead."No.";
                        "Rcpt. Response Header"."Customer Message No." := recWhseIndbHead."Message No.";
                    end;
                end;

                if "Rcpt. Response Header"."Order Type Option" = "Rcpt. Response Header"."order type option"::"Sales Return Order" then begin
                    recWhseIndbHead.Reset();
                    if not recWhseIndbHead.Get("Rcpt. Response Header"."Customer Reference") then begin
                        "Rcpt. Response Header".TestField("Shipment No.");
                        recWhseIndbHead.SetRange("Shipment No.", "Rcpt. Response Header"."Shipment No.");
                        if recWhseIndbHead.FindFirst() then
                            "Rcpt. Response Header"."Customer Reference" := recWhseIndbHead."No.";
                    end;
                end;

                recRcptRespHead.SetRange("Customer Message No.", "Rcpt. Response Header"."Customer Message No.");
                recRcptRespHead.SetRange(Status, "Rcpt. Response Header".Status);
                recRcptRespHead.SetRange(Open, true);
                if recRcptRespHead.FindLast() then begin
                    recRcptRespLine.SetRange("Response No.", recRcptRespHead."No.");
                    if recRcptRespLine.FindSet(true) then
                        repeat
                            recRcptRespLine.Open := false;
                            recRcptRespLine.Modify(true);
                        until recRcptRespLine.Next() = 0;

                    recRcptRespHead."After Post Description" := Text004;
                end;

            end;
        }
    }

    trigger OnInitXmlPort()
    begin
    end;

    trigger OnPreXmlPort()
    begin
        recWhseSetup.Get();
        recWhseSetup.TestField("Whse. Ship Response Nos.");
        LineNo := 10000;
    end;

    var
        recWhseSetup: Record "Warehouse Setup";
        recWhseIndbHead: Record "Warehouse Inbound Header";
        recRcptRespHead: Record "Rcpt. Response Header";
        recRcptRespLine: Record "Rcpt. Response Line";
        VCKXML: Codeunit "VCK Communication Management";
        StatusInt: Integer;
        gFileMgtEntryNo: Integer;
        LineNo: Integer;
        Text003: label '"%1" "%2" refers to "%3" %4.';
        Text004: label 'Response is closed/replaced by next document with same status.';


    procedure Init(FileMgtEntryNo: Integer)
    begin
        gFileMgtEntryNo := FileMgtEntryNo;
    end;
}
