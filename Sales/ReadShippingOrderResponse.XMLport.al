xmlport 50060 "Read Shipping Order Response"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 18-06-19 ZY-LD 2019061810000027 - It has happend once that serial no. is registered more that once.
    // 003. 25-10-19 ZY-LD 000 - MinOccurs is set to Zero on the tag Items and Item.
    // 004. 10-01-20 ZY-LD 000 - MinOccurs is set to Zero on Item.
    // 005. 01-04-22 ZY-LD 000 - Adjustments meade for VCK upgrade.
    // 006. 07-04-22 ZY-LD 000 - ShipmentNo and ReceiverReference has been changed from field to text. We don´t need this information on the response.
    // 007. 07-02-23 ZY-LD 000 - We have seen that "SN:" is entered as a part of the seria no.

    Caption = 'Read Shipping Order Response';
    DefaultNamespace = 'http://Allin.BizTalk.Schemas.ZyXELSP_BTS_Response_SO';
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
        tableelement("Ship Response Header"; "Ship Response Header")
        {
            XmlName = 'ShippingOrderResponse';
            fieldelement(OrderNo; "Ship Response Header"."Order No.")
            {
            }
            fieldelement(Status; "Ship Response Header".Status)
            {
            }
            textelement(ShipmentNo)
            {
                MinOccurs = Zero;
            }
            textelement(ReceiverReference)
            {
                MinOccurs = Zero;
            }
            fieldelement(CustomerReference; "Ship Response Header"."Customer Reference")
            {
            }
            fieldelement(CustomerMessageNo; "Ship Response Header"."Customer Message No.")
            {
            }
            textelement(PickingDateTime)
            {
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    "Ship Response Header"."Picking Date Time" := VCKXML.ConvertTextToDateTime(PickingDateTime);
                end;
            }
            textelement(LoadingDateTime)
            {
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    "Ship Response Header"."Loading Date Time" := VCKXML.ConvertTextToDateTime(LoadingDateTime);
                end;
            }
            textelement(PlannedShipmentDateTime)
            {
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    "Ship Response Header"."Planned Shipment Date Time" := VCKXML.ConvertTextToDateTime(PlannedShipmentDateTime);
                end;
            }
            textelement(ActualShipmentDateTime)
            {
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    "Ship Response Header"."Actual Shipment Date Time" := VCKXML.ConvertTextToDateTime(ActualShipmentDateTime);
                end;
            }
            textelement(DeliveryDateTime)
            {
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    "Ship Response Header"."Delivery Date Time" := VCKXML.ConvertTextToDateTime(DeliveryDateTime);
                end;
            }
            textelement(SystemDateTime)
            {
                MinOccurs = Zero;

                trigger OnAfterAssignVariable()
                begin
                    "Ship Response Header"."System Date Time" := VCKXML.ConvertTextToDateTime(SystemDateTime);
                end;
            }
            textelement(PostingDateTime)
            {
                trigger OnAfterAssignVariable()
                begin
                    "Ship Response Header"."Posting Date Time" := VCKXML.ConvertTextToDateTime(PostingDateTime);
                end;
            }
            fieldelement(CostCenter; "Ship Response Header"."Cost Center")
            {
                MinOccurs = Zero;
            }
            fieldelement(OrderType; "Ship Response Header"."Order Type")
            {
            }
            textelement("<deliveryterms>")
            {
                XmlName = 'DeliveryTerms';
                fieldelement(Incoterm; "Ship Response Header".Incoterm)
                {
                }
                fieldelement(City; "Ship Response Header".City)
                {
                    MinOccurs = Zero;
                }
            }
            fieldelement(ModeOfTransport; "Ship Response Header"."Mode of Transport 2")
            {
                MinOccurs = Zero;
            }
            fieldelement(Connote; "Ship Response Header".Connote)
            {
                MinOccurs = Zero;
            }
            fieldelement(Carrier; "Ship Response Header".Carrier)
            {
                MinOccurs = Zero;
            }
            fieldelement(CarrierService; "Ship Response Header"."Carrier Service")
            {
                MinOccurs = Zero;
            }
            fieldelement(Colli; "Ship Response Header".Colli)
            {
            }
            fieldelement(Weight; "Ship Response Header".Weight)
            {
                trigger OnAfterAssignField()
                begin
                    "Ship Response Header".Weight := "Ship Response Header".Weight / 100;
                end;
            }
            fieldelement(Volume; "Ship Response Header".Volume)
            {
            }
            fieldelement(SignedBy; "Ship Response Header"."Signed By")
            {
                MinOccurs = Zero;
            }
            fieldelement(DeliveryRemark; "Ship Response Header"."Delivery Remark")
            {
                MinOccurs = Zero;
            }
            fieldelement(DeliveryStatus; "Ship Response Header"."Delivery Status")
            {
                MinOccurs = Zero;
            }
            textelement(Comments)
            {
                MinOccurs = Zero;
                textelement(Text)
                {
                    textattribute(type)
                    {
                    }
                }
            }
            textelement(CustomerData)
            {
                MinOccurs = Zero;
                fieldelement(Value1; "Ship Response Header"."Value 1")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value2; "Ship Response Header"."Value 2")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value3; "Ship Response Header"."Value 3")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value4; "Ship Response Header"."Value 4")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value5; "Ship Response Header"."Value 5")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value6; "Ship Response Header"."Value 6")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value7; "Ship Response Header"."Value 7")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value8; "Ship Response Header"."Value 8")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Value9; "Ship Response Header"."Value 9")
                {
                    MinOccurs = Zero;
                }
            }
            textelement("<items>")
            {
                MinOccurs = Zero;
                XmlName = 'Items';
                tableelement("Ship Response Line"; "Ship Response Line")
                {
                    LinkFields = "Response No." = field("No.");
                    LinkTable = "Ship Response Header";
                    MinOccurs = Zero;
                    XmlName = 'Item';
                    fieldelement(Index; "Ship Response Line"."Index No.")
                    {
                    }
                    fieldelement(LineNo; "Ship Response Line"."Line No.")
                    {
                    }
                    fieldelement(ItemNo; "Ship Response Line"."Item No.")
                    {
                    }
                    fieldelement(ProductNo; "Ship Response Line"."Product No.")
                    {
                    }
                    fieldelement(Description; "Ship Response Line".Description)
                    {
                    }
                    fieldelement(Warehouse; "Ship Response Line".Warehouse)
                    {
                    }
                    fieldelement(Location; "Ship Response Line".Location)
                    {
                    }
                    fieldelement(Grade; "Ship Response Line".Grade)
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(OrderedQty; "Ship Response Line"."Ordered Quantity")
                    {
                    }
                    fieldelement(Quantity; "Ship Response Line".Quantity)
                    {
                    }
                    fieldelement(CustomerOrderNo; "Ship Response Line"."Customer Order No.")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(CustomerOrderLineNo; "Ship Response Line"."Customer Order Line No.")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(SalesOrderNo; "Ship Response Line"."Sales Order No.")
                    {
                    }
                    fieldelement(SalesOrderLineNo; "Ship Response Line"."Sales Order Line No.")
                    {
                    }
                    textelement(customerdata1)
                    {
                        MinOccurs = Zero;
                        XmlName = 'CustomerData';
                        fieldelement(Value1; "Ship Response Line"."Value 1")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value2; "Ship Response Line"."Value 2")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value3; "Ship Response Line"."Value 3")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value4; "Ship Response Line"."Value 4")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value5; "Ship Response Line"."Value 5")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value6; "Ship Response Line"."Value 6")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value7; "Ship Response Line"."Value 7")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value8; "Ship Response Line"."Value 8")
                        {
                            MinOccurs = Zero;
                        }
                        fieldelement(Value9; "Ship Response Line"."Value 9")
                        {
                            MinOccurs = Zero;
                        }
                    }
                    textelement(SerialNumbers)
                    {
                        MinOccurs = Zero;
                        textelement(serialnumber1)
                        {
                            XmlName = 'SerialNumber';
                            MinOccurs = Zero;

                            trigger OnAfterAssignVariable()
                            begin
                                if SerialNumber1 <> '' then begin
                                    //>> 07-02-23 ZY-LD 007
                                    if StrPos(SerialNumber1, 'SN:') <> 0 then
                                        SerialNumber1 := DelStr(SerialNumber1, StrPos(SerialNumber1, 'SN:'), StrLen('SN:'));
                                    //<< 07-02-23 ZY-LD 007
                                    Clear(recVCKShipResponceSerialNos);
                                    recVCKShipResponceSerialNos.Init();
                                    recVCKShipResponceSerialNos."Response No." := "Ship Response Header"."No.";
                                    recVCKShipResponceSerialNos."Response Line No." := "Ship Response Line"."Response Line No.";
                                    recVCKShipResponceSerialNos."Serial No." := SerialNumber1;
                                    //recVCKShipResponceSerialNos."Item No." := "Ship Response Line"."Item No.";
                                    recVCKShipResponceSerialNos."Item No." := "Ship Response Line"."Product No.";
                                    recVCKShipResponceSerialNos."Sales Order No." := "Ship Response Line"."Sales Order No.";
                                    recVCKShipResponceSerialNos."Sales Order Line No." := "Ship Response Line"."Sales Order Line No.";
                                    //  recVCKShipResponceSerialNos."Order No." := "Ship Response Header"."Order No.";
                                    //  recVCKShipResponceSerialNos."Entry No." := "Ship Response Header"."Entry No.";
                                    //  recVCKShipResponceSerialNos."Index No." := "VCK Ship Response Line"."Index No.";
                                    if not recVCKShipResponceSerialNos.Insert() then begin
                                        ErrorOnSerialNo += StrSubstNo('Response No.:%1 Line No.: %2 Serial No.: %3<br>', "Ship Response Header"."No.", "Ship Response Line"."Response Line No.", SerialNumber1);
                                    end;
                                end;
                            end;
                        }
                    }
                    textelement(BatchNumbers)
                    {
                        MinOccurs = Zero;
                        textelement(BatchNumber)
                        {
                        }
                    }

                    trigger OnAfterInitRecord()
                    begin
                        "Ship Response Line"."Response No." := "Ship Response Header"."No.";
                        "Ship Response Line"."Response Line No." := LineNo;
                        LineNo += 10000;
                        // "VCK Ship Response Line"."Order No." := "Ship Response Header"."Order No.";
                        // "VCK Ship Response Line"."Entry No." := "Ship Response Header"."Entry No.";
                    end;

                    trigger OnBeforeInsertRecord()
                    begin
                        recDelDocLine.SetAutoCalcFields("Document Type");
                        recDelDocLine.SetRange("Document No.", "Ship Response Line"."Sales Order No.");
                        recDelDocLine.SetRange("Line No.", "Ship Response Line"."Sales Order Line No.");
                        if recDelDocLine.FindFirst() then begin
                            if recDelDocLine."Document Type" = recDelDocLine."document type"::Sales then begin
                                "Ship Response Line"."Customer Order No." := recDelDocLine."Sales Order No.";
                                "Ship Response Line"."Customer Order Line No." := recDelDocLine."Sales Order Line No.";
                            end else begin
                                "Ship Response Line"."Customer Order No." := recDelDocLine."Transfer Order No.";
                                "Ship Response Line"."Customer Order Line No." := recDelDocLine."Transfer Order Line No.";
                            end;
                        end else begin
                            "Ship Response Line"."Error Text" := StrSubstNo(Text004, recDelDocLine.TableCaption(), "Ship Response Line"."Sales Order No.", "Ship Response Line"."Sales Order Line No.");  // 18-06-19 ZY-LD 002
                        end;
                    end;
                }
            }
            textelement(PackingDetails)
            {
                MinOccurs = Zero;
                fieldelement(Pallets; "Ship Response Header".Pallets)
                {
                    MinOccurs = Zero;
                }
                fieldelement(Cartons; "Ship Response Header".Cartons)
                {
                    MinOccurs = Zero;
                }
                fieldelement(GrossWeight; "Ship Response Header"."Gross Weight")
                {
                    MinOccurs = Zero;
                }
                fieldelement(NettWeight; "Ship Response Header"."Nett Weight")
                {
                    MinOccurs = Zero;
                }
                textelement(Container)
                {
                    MinOccurs = Zero;
                    fieldelement(ID; "Ship Response Header"."Container ID")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(Type; "Ship Response Header"."Container Type")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(Height; "Ship Response Header"."Container Height")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(Width; "Ship Response Header"."Container Width")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(Depth; "Ship Response Header"."Container Depth")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(Volume; "Ship Response Header"."Container Volume")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(GrossWeight; "Ship Response Header"."Container Gross Weight")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(NetWeight; "Ship Response Header"."Container New Weight")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(CustomerReference; "Ship Response Header"."Container Customer Reference")
                    {
                    }
                }
            }
            textelement(Invoicing)
            {
                MinOccurs = Zero;
                fieldelement(LogisticHandling; "Ship Response Header"."Invoicing Logistic Handling")
                {
                }
                fieldelement(HandlingCharges; "Ship Response Header"."Invoicing Handling Charges")
                {
                }
                fieldelement(TransportCost; "Ship Response Header"."Invoicing Transport Cost")
                {
                }
                fieldelement(FuelSurcharge; "Ship Response Header"."Invocing Fuel Surcharge")
                {
                }
                fieldelement(Airfreight; "Ship Response Header"."Invoicing Air freight")
                {
                }
                fieldelement(ThirdPartyCost; "Ship Response Header"."Invoicing Third Party Cost")
                {
                }
                fieldelement(MiscellaneousCost; "Ship Response Header"."Invoicing Miscellaneous Cost")
                {
                }
            }

            trigger OnBeforeInsertRecord()
            begin
                //recRespHead."No." := NoSeriesMgt.GetNextNo(recWhseSetup."Whse. Ship Response Nos.",TODAY,TRUE);

                // recRespHead.SETRANGE("Order No.","Ship Response Header"."Order No.");
                // IF recRespHead.FINDLAST THEN
                //  "Ship Response Header"."Entry No." := recRespHead."Entry No." + 1
                // ELSE
                //  "Ship Response Header"."Entry No." := 1;

                case "Ship Response Header".Status of
                    '00', '10':
                        "Ship Response Header"."Warehouse Status" := "Ship Response Header"."warehouse status"::New;
                    '20':
                        "Ship Response Header"."Warehouse Status" := "Ship Response Header"."warehouse status"::"Ready to Pick";
                    '30':
                        "Ship Response Header"."Warehouse Status" := "Ship Response Header"."warehouse status"::Picking;
                    '50':
                        "Ship Response Header"."Warehouse Status" := "Ship Response Header"."warehouse status"::Packed;
                    '60':
                        "Ship Response Header"."Warehouse Status" := "Ship Response Header"."warehouse status"::"Waiting for invoice";
                    '65':
                        "Ship Response Header"."Warehouse Status" := "Ship Response Header"."warehouse status"::"Invoice Received";
                    '70':
                        "Ship Response Header"."Warehouse Status" := "Ship Response Header"."warehouse status"::Posted;
                    '80':
                        "Ship Response Header"."Warehouse Status" := "Ship Response Header"."warehouse status"::"In Transit";
                    '90':
                        "Ship Response Header"."Warehouse Status" := "Ship Response Header"."warehouse status"::Delivered;
                end;

                "Ship Response Header"."File Management Entry No." := gFileMgtEntryNo;
            end;
        }
    }

    trigger OnPostXmlPort()
    begin
        if ErrorOnSerialNo <> '' then
            EmailAddMgt.CreateEmailWithBodytext('LOGSHIPRES', ErrorOnSerialNo, '');  // 18-06-19 ZY-LD 002
    end;

    trigger OnPreXmlPort()
    begin
        recWhseSetup.Get();
        recWhseSetup.TestField("Whse. Ship Response Nos.");
        LineNo := 10000;
        ErrorOnSerialNo := '';  // 18-06-19 ZY-LD 002
    end;

    var
        Text001a: Label 'The location code of the VCK warehouse has not been set in the Sales & Receivables Setup.';
        Text002a: Label 'VCK Integration has not been setup correctly in Inventory Setup.';
        recVCKShipResponceSerialNos: Record "Ship Responce Serial Nos.";
        recDelDocLine: Record "VCK Delivery Document Line";
        recWhseSetup: Record "Warehouse Setup";
        VCKXML: Codeunit "VCK Communication Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recRespHead: Record "Ship Response Header";
        Text003: Label 'Status not found.';
        gFileMgtEntryNo: Integer;
        Text004: Label '"%1" was not found %2 %3.';
        LineNo: Integer;
        EmailAddMgt: Codeunit "E-mail Address Management";
        ErrorOnSerialNo: Text;

    procedure Init(FileMgtEntryNo: Integer)
    begin
        gFileMgtEntryNo := FileMgtEntryNo;
    end;
}
