XmlPort 50003 "Send Inbound Order Request"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 02-05-19 ZY-LD "Due Date" is used as "Expected Receipt Date" on the header. We don't know why.
    // 003. 14-06-19 ZY-LD 2019061410000043 - Purchase order can contain more than one location code on the lines.
    // 004. 17-06-19 ZY-LD 2019061710000056 - Filter lines only on Type = Item. "DeliveryTerms/Terms" is left blank instead of Warehouse Inbound Header::Shipping Method, which was wrong. It was blank on PO´s.
    // 005. 05-02-21 ZY-LD 000 - TO was missing.
    // 006. 08-09-21 ZY-LD 2021090810000072 - ShipmentNo is changed from "Warehouse Inbound Header::Shipment No." to "Warehouse Inbound Header::Invoice No.".
    // 007. 22-02-22 ZY-LD P0767 - Namespace is changed.
    // 008. 13-03-23 ZY-LD 000 - Wrong warehouse was set.

    Caption = 'Send Inbound Order Request';
    DefaultNamespace = 'http://schemas.allincontrol.com/BizTalk/2013';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;
    UseRequestPage = true;

    schema
    {
        tableelement("Warehouse Inbound Header"; "Warehouse Inbound Header")
        {
            RequestFilterFields = "No.";
            XmlName = 'InboundOrder';
            SourceTableView = sorting("No.");
            textelement(MessageNo)
            {
            }
            fieldelement(CustomerMessageNo; "Warehouse Inbound Header"."Message No.")
            {
            }
            textelement(CustomerID)
            {
            }
            textelement(ProjectID)
            {
            }
            textelement(OrderType)
            {
            }
            textelement(CostCenter)
            {
            }
            fieldelement(ExpectedReceiptDate; "Warehouse Inbound Header"."Expected Receipt Date")
            {
            }
            textelement("<deliveryterms>")
            {
                XmlName = 'DeliveryTerms';
                textelement(Terms)
                {
                }
                textelement(city2)
                {
                    XmlName = 'City';
                }
            }
            textelement(Addresses)
            {
                textelement(ShippedFrom)
                {
                    fieldelement(AddressID; "Warehouse Inbound Header"."Sender No.")
                    {
                    }
                    fieldelement(Name; "Warehouse Inbound Header"."Sender Name")
                    {
                    }
                    fieldelement(Name2; "Warehouse Inbound Header"."Sender Name 2")
                    {
                    }
                    fieldelement(Contact; "Warehouse Inbound Header"."Sender Contact")
                    {
                    }
                    textelement(Phone)
                    {
                    }
                    textelement(Email)
                    {
                    }
                    fieldelement(Address; "Warehouse Inbound Header"."Sender Address")
                    {
                    }
                    fieldelement(Address2; "Warehouse Inbound Header"."Sender Address 2")
                    {
                    }
                    fieldelement(PostalCode; "Warehouse Inbound Header"."Sender Post Code")
                    {
                    }
                    fieldelement(City; "Warehouse Inbound Header"."Sender City")
                    {
                    }
                    fieldelement(State; "Warehouse Inbound Header"."Sender County")
                    {
                    }
                    fieldelement(CountryID; "Warehouse Inbound Header"."Sender Country/Region Code")
                    {
                    }
                    textelement(TaxID)
                    {
                    }
                    textelement(CarrierAccountNo)
                    {
                    }
                }
                textelement(ShippedTo)
                {
                    textelement(shiptoaddressid)
                    {
                        XmlName = 'AddressID';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToAddressID := recWarehouse.Code;
                        end;
                    }
                    textelement(shiptoname)
                    {
                        XmlName = 'Name';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToName := recWarehouse.Name;
                        end;
                    }
                    textelement(shiptoname2)
                    {
                        XmlName = 'Name2';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToName2 := recWarehouse."Name 2";
                        end;
                    }
                    textelement(shiptocontact)
                    {
                        XmlName = 'Contact';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToContact := recWarehouse.Contact;
                        end;
                    }
                    textelement(shiptophone)
                    {
                        XmlName = 'Phone';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToPhone := recWarehouse."Phone No.";
                        end;
                    }
                    textelement(shiptoemail)
                    {
                        XmlName = 'Email';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToEmail := recWarehouse."E-Mail";
                        end;
                    }
                    textelement(shiptoaddress)
                    {
                        XmlName = 'Address';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToAddress := recWarehouse.Address;
                        end;
                    }
                    textelement(shiptoaddress2)
                    {
                        XmlName = 'Address2';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToAddress2 := recWarehouse."Address 2";
                        end;
                    }
                    textelement(shiptopostcode)
                    {
                        XmlName = 'PostalCode';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToPostCode := recWarehouse."Post Code";
                        end;
                    }
                    textelement(shiptocity)
                    {
                        XmlName = 'City';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToCity := recWarehouse.City;
                        end;
                    }
                    textelement(shiptocounty)
                    {
                        XmlName = 'State';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToCounty := recWarehouse.County;
                        end;
                    }
                    textelement(shiptocountry)
                    {
                        XmlName = 'CountryID';

                        trigger OnBeforePassVariable()
                        begin
                            ShipToCountry := recWarehouse."Country/Region Code";
                        end;
                    }
                    textelement(taxid1)
                    {
                        XmlName = 'TaxID';
                    }
                    textelement(carrieraccountno1)
                    {
                        XmlName = 'CarrierAccountNo';
                    }
                }
            }
            textelement(EmailAddresses)
            {
            }
            textelement("<references>")
            {
                XmlName = 'References';
                fieldelement(CustomerReference; "Warehouse Inbound Header"."No.")
                {
                }
                fieldelement(ShipperReference; "Warehouse Inbound Header"."Shipper Reference")
                {
                }
                fieldelement(ShipmentNo; "Warehouse Inbound Header"."Invoice No.")
                {
                    MinOccurs = Zero;
                }
            }
            textelement(Comments)
            {
            }
            textelement(Invoicing)
            {
                textelement(CostCode1)
                {
                }
                textelement(CostCode2)
                {
                }
            }
            tableelement("VCK Shipping Detail"; "VCK Shipping Detail")
            {
                LinkFields = "Document No." = field("No.");
                LinkTable = "Warehouse Inbound Header";
                XmlName = 'Items';
                SourceTableView = sorting("Document No.", "Pallet No. 2");
                textelement(Item)
                {
                    fieldelement(ItemNo; "VCK Shipping Detail"."Item No.")
                    {
                    }
                    textelement(ItemNoShipper)
                    {
                    }
                    fieldelement(Description; "VCK Shipping Detail"."Item Description")
                    {
                    }
                    fieldelement(Quantity; "VCK Shipping Detail".Quantity)
                    {
                    }
                    textelement(UnitPrice)
                    {
                    }
                    textelement(CurrencyCode)
                    {
                    }
                    textelement(Warehouse)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            Warehouse := ItemLogisticEvent.GetMainWarehouseLocation;  // 13-03-23 ZY-LD 008
                        end;
                    }
                    fieldelement(Location; "Warehouse Inbound Header"."Location Code")
                    {
                    }
                    textelement(Bin)
                    {
                    }
                    fieldelement(OrderNo; "VCK Shipping Detail"."Document No.")
                    {
                    }
                    fieldelement(LineNo; "VCK Shipping Detail"."Line No.")
                    {
                    }
                    fieldelement(ExpectedReceiptDate; "Warehouse Inbound Header"."Expected Receipt Date")
                    {
                    }
                    textelement(invoicing1)
                    {
                        XmlName = 'Invoicing';
                        textelement(costcode11)
                        {
                            XmlName = 'CostCode1';
                        }
                        textelement(costcode21)
                        {
                            XmlName = 'CostCode2';
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    case "VCK Shipping Detail"."Order Type" of
                        "VCK Shipping Detail"."order type"::"Purchase Order":
                            begin
                                recPurchHead.Get(recPurchHead."document type"::Order, "VCK Shipping Detail"."Purchase Order No.");
                                CurrencyCode := recPurchHead."Currency Code";
                                if recPurchLine.Get(recPurchHead."Document Type", recPurchHead."No.", "VCK Shipping Detail"."Purchase Order Line No.") then
                                    UnitPrice := Format(recPurchLine."Unit Price (LCY)")
                                else begin
                                    //>> 03-07-20 ZY-LD 005
                                    UnitPrice := '';
                                    SI.SetMergefield(100, "VCK Shipping Detail"."Batch No.");
                                    SI.SetMergefield(101, recPurchHead."No.");
                                    SI.SetMergefield(102, Format("VCK Shipping Detail"."Purchase Order Line No."));
                                    EmailAddMgt.CreateSimpleEmail('HQCONTDETE', '', '');
                                    EmailAddMgt.Send;
                                    //<< 03-07-20 ZY-LD 005
                                end;
                            end;
                        "VCK Shipping Detail"."order type"::"Sales Return Order":
                            begin
                                recSalesHead.Get(recSalesHead."document type"::"Return Order", "VCK Shipping Detail"."Purchase Order No.");
                                CurrencyCode := recSalesHead."Currency Code";
                                recSalesLine.Get(recSalesHead."Document Type", recSalesHead."No.", "VCK Shipping Detail"."Purchase Order Line No.");
                                UnitPrice := Format(recSalesLine."Unit Cost (LCY)");
                            end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                recWarehouse.Get("Warehouse Inbound Header"."Location Code");
                recWarehouse.TestField("Customer ID");
                recWarehouse.TestField("Project ID");
                CustomerID := recWarehouse."Customer ID";
                ProjectID := recWarehouse."Project ID";

                case "Warehouse Inbound Header"."Order Type" of
                    "Warehouse Inbound Header"."order type"::"Purchase Order":
                        begin
                            recVend.Get("Warehouse Inbound Header"."Sender No.");
                            Phone := recVend."Phone No.";
                            Email := recVend."E-Mail";
                            OrderType := 'PO';
                        end;
                    "Warehouse Inbound Header"."order type"::"Sales Return Order":
                        begin
                            recCust.Get("Warehouse Inbound Header"."Sender No.");
                            Phone := recCust."Phone No.";
                            Email := recCust."E-Mail";
                            OrderType := 'SR';
                        end;
                    //>> 05-02-21 ZY-LD 005
                    "Warehouse Inbound Header"."order type"::"Transfer Order":
                        begin
                            recLocation.Get("Warehouse Inbound Header"."Sender No.");
                            Phone := recLocation."Phone No.";
                            Email := recLocation."E-Mail";
                            OrderType := 'TO';
                        end;
                //<< 05-02-21 ZY-LD 005
                end;
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

    trigger OnInitXmlPort()
    var
        recItem: Record Item;
    begin
    end;

    trigger OnPreXmlPort()
    begin
        recSalesSetup.Get;
    end;

    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recWarehouse: Record Location;
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recCust: Record Customer;
        recVend: Record Vendor;
        Text001: label 'Container No.: %1';
        Text002: label 'Invoice No.: %1';
        recLocation: Record Location;
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
}
