XmlPort 50058 "Send Delivery Document"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 13-02-20 ZY-LD 2020021210000051 - Only packing is a posibility for comments on the item line. Comments moved from line to header.
    // 003. 20-04-20 ZY-LD P0388 - Set "Receiver Reference" for local transfer.
    // 004. 26-08-20 ZY-LD 000 - Cross Reference must be opened for the lines, otherwise it will show a wrong number.
    // 005. 26-01-22 ZY-LD 2022012610000032 - "Delivery Terms City" was not correct for all "Shipment Methods".
    // 006. 22-02-22 ZY-LD P0767 - Namespace is changed.
    // 007. 18-05-22 ZY-LD 2022011110000088 - "Freight Cost Item" added as a filter on DD-Line.
    // 008. 23-05-22 ZY-LD 000 - Due to e-mail from VCK. When it´s DAMAGE location, the warehouse location must be the main warehouse location.
    // 009. 01-08-22 ZY-LD 000 - After VCK upgrade it must be "SO" for transfer orders as well.

    Caption = 'Send Delivery Document';
    DefaultNamespace = 'http://schemas.allincontrol.com/BizTalk/2013';
    Direction = Export;
    Encoding = UTF8;
    Format = Xml;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;
    UseRequestPage = true;

    schema
    {
        tableelement("VCK Delivery Document Header"; "VCK Delivery Document Header")
        {
            RequestFilterFields = "No.";
            XmlName = 'OutgoingFile';
            textelement(MessageNo)
            {
            }
            fieldelement(CustomerMessageNo; "VCK Delivery Document Header"."No.")
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
            textelement(Addresses)
            {
                textelement("<shipfrom>")
                {
                    XmlName = 'ShipFrom';
                    textelement(addressid1)
                    {
                        XmlName = 'AddressID';
                    }
                    fieldelement(Name; "VCK Delivery Document Header"."Ship-From Name")
                    {
                    }
                    fieldelement(Name2; "VCK Delivery Document Header"."Ship-From Name 2")
                    {
                    }
                    fieldelement(Contact; "VCK Delivery Document Header"."Ship-From Contact")
                    {
                    }
                    fieldelement(Phone; "VCK Delivery Document Header"."Ship-From Phone")
                    {
                    }
                    fieldelement(Email; "VCK Delivery Document Header"."Ship-From Email")
                    {
                    }
                    fieldelement(Address; "VCK Delivery Document Header"."Ship-From Address")
                    {
                    }
                    fieldelement(Address2; "VCK Delivery Document Header"."Ship-From Address 2")
                    {
                    }
                    fieldelement(PostalCode; "VCK Delivery Document Header"."Ship-From Post Code")
                    {
                    }
                    fieldelement(City; "VCK Delivery Document Header"."Ship-From City")
                    {
                    }
                    fieldelement(State; "VCK Delivery Document Header"."Ship-From County")
                    {
                    }
                    fieldelement(CountryID; "VCK Delivery Document Header"."Ship-From Country/Region Code")
                    {
                    }
                    fieldelement(TaxID; "VCK Delivery Document Header"."Ship-From TaxID")
                    {
                    }
                    textelement(CarrierAccountNo)
                    {
                    }
                }
                textelement(ShipTo)
                {
                    fieldelement(AddressID; "VCK Delivery Document Header"."Ship-to Code")
                    {
                    }
                    fieldelement(Name; "VCK Delivery Document Header"."Ship-to Name")
                    {
                    }
                    fieldelement(Name2; "VCK Delivery Document Header"."Ship-to Name 2")
                    {
                    }
                    fieldelement(Contact; "VCK Delivery Document Header"."Ship-to Contact")
                    {
                    }
                    fieldelement(Phone; "VCK Delivery Document Header"."Ship-to Phone")
                    {
                    }
                    fieldelement(Email; "VCK Delivery Document Header"."Ship-to Email")
                    {
                    }
                    fieldelement(Address; "VCK Delivery Document Header"."Ship-to Address")
                    {
                    }
                    fieldelement(Address2; "VCK Delivery Document Header"."Ship-to Address 2")
                    {
                    }
                    fieldelement(PostalCode; "VCK Delivery Document Header"."Ship-to Post Code")
                    {
                    }
                    fieldelement(City; "VCK Delivery Document Header"."Ship-to City")
                    {
                    }
                    fieldelement(State; "VCK Delivery Document Header"."Ship-to County")
                    {
                    }
                    fieldelement(CountryID; "VCK Delivery Document Header"."Ship-to Country/Region Code")
                    {
                    }
                    fieldelement(TaxID; "VCK Delivery Document Header"."Ship-to TaxID")
                    {
                    }
                    textelement(carrieraccountno1)
                    {
                        XmlName = 'CarrierAccountNo';
                    }
                }
                textelement(BillTo)
                {
                    fieldelement(AddressID; "VCK Delivery Document Header"."Bill-to Customer No.")
                    {
                    }
                    fieldelement(Name; "VCK Delivery Document Header"."Bill-to Name")
                    {
                    }
                    fieldelement(Name2; "VCK Delivery Document Header"."Bill-to Name 2")
                    {
                    }
                    fieldelement(Contact; "VCK Delivery Document Header"."Bill-to Contact")
                    {
                    }
                    fieldelement(Phone; "VCK Delivery Document Header"."Bill-to Phone")
                    {
                    }
                    fieldelement(Email; "VCK Delivery Document Header"."Bill-to Email")
                    {
                    }
                    fieldelement(Address; "VCK Delivery Document Header"."Bill-to Address")
                    {
                    }
                    fieldelement(Address2; "VCK Delivery Document Header"."Bill-to Address 2")
                    {
                    }
                    fieldelement(PostalCode; "VCK Delivery Document Header"."Bill-to Post Code")
                    {
                    }
                    fieldelement(City; "VCK Delivery Document Header"."Bill-to City")
                    {
                    }
                    fieldelement(State; "VCK Delivery Document Header"."Bill-to County")
                    {
                    }
                    fieldelement(CountryID; "VCK Delivery Document Header"."Bill-to Country/Region Code")
                    {
                    }
                    fieldelement(TaxID; "VCK Delivery Document Header"."Bill-to TaxID")
                    {
                    }
                    textelement(carrieraccountno2)
                    {
                        XmlName = 'CarrierAccountNo';
                    }
                }
                textelement(ShippingPoint)
                {
                    textelement(AddressID)
                    {
                    }
                    textelement(Name)
                    {
                    }
                    textelement(Name2)
                    {
                    }
                    textelement(Contact)
                    {
                    }
                    textelement(Phone)
                    {
                    }
                    textelement(email3)
                    {
                        XmlName = 'Email';
                    }
                    textelement(Address)
                    {
                    }
                    textelement(Address2)
                    {
                    }
                    textelement(postalcode1)
                    {
                        XmlName = 'PostalCode';
                    }
                    textelement(City)
                    {
                    }
                    textelement(State)
                    {
                    }
                    textelement(CountryID)
                    {
                    }
                    textelement(TaxID)
                    {
                    }
                    textelement(carrieraccountno3)
                    {
                        XmlName = 'CarrierAccountNo';
                    }
                }
            }
            textelement(EmailAddresses)
            {
                tableelement(emailconfirmation; "Delivery Document Action Code")
                {
                    LinkFields = "Delivery Document No." = field("No.");
                    LinkTable = "VCK Delivery Document Header";
                    XmlName = 'Confirmation';
                    SourceTableView = sorting("Delivery Document No.", "Comment Type", Sequence) where("Header / Line" = const(Header), "Comment Type" = const("E-mail Confirmation"));
                    textelement(nameconfirmation)
                    {
                        MinOccurs = Zero;
                        XmlName = 'Name';
                    }
                    fieldelement(Email; EmailConfirmation."Action Description")
                    {
                    }
                }
                tableelement(emailnotification; "Delivery Document Action Code")
                {
                    LinkFields = "Delivery Document No." = field("No.");
                    LinkTable = "VCK Delivery Document Header";
                    XmlName = 'Notification';
                    SourceTableView = sorting("Delivery Document No.", "Comment Type", Sequence) where("Header / Line" = const(Header), "Comment Type" = const("E-mail Notification"));
                    textelement(namenotification)
                    {
                        MinOccurs = Zero;
                        XmlName = 'Name';
                    }
                    fieldelement(Email; EmailNotification."Action Description")
                    {
                    }
                }
                tableelement(exception; "Delivery Document Action Code")
                {
                    LinkFields = "Delivery Document No." = field("No.");
                    LinkTable = "VCK Delivery Document Header";
                    XmlName = 'Exception';
                    SourceTableView = sorting("Delivery Document No.", "Comment Type", Sequence) where("Header / Line" = const(Header), "Comment Type" = const("E-mail Exceptation"));
                    textelement(nameexception)
                    {
                        MinOccurs = Zero;
                        XmlName = 'Name';
                    }
                    fieldelement(Email; Exception."Action Description")
                    {
                    }
                }
                tableelement(prealert; "Delivery Document Action Code")
                {
                    LinkFields = "Delivery Document No." = field("No.");
                    LinkTable = "VCK Delivery Document Header";
                    XmlName = 'Pre-Alert';
                    SourceTableView = sorting("Delivery Document No.", "Comment Type", Sequence) where("Header / Line" = const(Header), "Comment Type" = const("E-mail Pre-Alert"));
                    textelement(nameprealert)
                    {
                        MinOccurs = Zero;
                        XmlName = 'Name';
                    }
                    fieldelement(Email; PreAlert."Action Description")
                    {
                    }
                }
                tableelement(readyforpickup; "Delivery Document Action Code")
                {
                    LinkFields = "Delivery Document No." = field("No.");
                    LinkTable = "VCK Delivery Document Header";
                    XmlName = 'ReadyForPickup';
                    SourceTableView = sorting("Delivery Document No.", "Comment Type", Sequence) where("Header / Line" = const(Header), "Comment Type" = const("Ready for Pickup"));
                    textelement(namereadyforpickup)
                    {
                        MinOccurs = Zero;
                        XmlName = 'Name';
                    }
                    fieldelement(Email; ReadyForPickup."Action Description")
                    {
                    }
                }
                tableelement(slotrequest; "Delivery Document Action Code")
                {
                    LinkFields = "Delivery Document No." = field("No.");
                    LinkTable = "VCK Delivery Document Header";
                    XmlName = 'Slot-Request';
                    SourceTableView = sorting("Delivery Document No.", "Comment Type", Sequence) where("Header / Line" = const(Header), "Comment Type" = const("E-mail Slot-Request"));
                    textelement(nameslotrequest)
                    {
                        MinOccurs = Zero;
                        XmlName = 'Name';
                    }
                    fieldelement(Email; SlotRequest."Action Description")
                    {
                    }
                }
            }
            textelement(UrgentOrder)
            {
            }
            textelement(PriorityCode)
            {
            }
            fieldelement(RequestedShipDate; "VCK Delivery Document Header"."Requested Ship Date")
            {
            }
            fieldelement(RequestedDeliveryDate; "VCK Delivery Document Header"."Requested Delivery Date")
            {
            }
            fieldelement(ForwarderService; "VCK Delivery Document Header"."Shipment Agent Service")
            {
            }
            fieldelement(Forwarder; "VCK Delivery Document Header"."Shipment Agent Code")
            {
            }
            textelement(DeliveryTerms)
            {
                fieldelement(Terms; "VCK Delivery Document Header"."Delivery Terms Terms")
                {
                }
                textelement(deliverytermscity)
                {
                    XmlName = 'City';
                }
            }
            fieldelement(ModeOfTransport; "VCK Delivery Document Header"."Mode Of Transport")
            {
            }
            textelement(References)
            {
                fieldelement(CustomerReference; "VCK Delivery Document Header"."No.")
                {
                    Width = 80;
                }
                textelement(ReceiverReference)
                {
                    Width = 80;

                    trigger OnBeforePassVariable()
                    begin
                        //>> 20-04-20 ZY-LD 003
                        if "VCK Delivery Document Header"."Sell-to Customer No." = recSalesSetup."Customer No. on Sister Company" then
                            ReceiverReference := "VCK Delivery Document Header"."No.";
                        //<< 20-04-20 ZY-LD 003

                        //>> 06-04-22 ZY-LD 007
                        if StrLen(ReceiverReference) > 80 then
                            ReceiverReference := CopyStr(ReceiverReference, 1, 80);
                        //<< 06-04-22 ZY-LD 007
                    end;
                }
            }
            textelement(Comments)
            {
                textelement(general1)
                {
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General1 := HeadGenArr[1];
                    end;
                }
                textelement(general2)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General2 := HeadGenArr[2];
                        if General2 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general3)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General3 := HeadGenArr[3];
                        if General3 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general4)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General4 := HeadGenArr[4];
                        if General4 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general5)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General5 := HeadGenArr[5];
                        if General5 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general6)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General6 := HeadGenArr[6];
                        if General6 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general7)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General7 := HeadGenArr[7];
                        if General7 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general8)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General8 := HeadGenArr[8];
                        if General8 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general9)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General9 := HeadGenArr[9];
                        if General9 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general10)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General10 := HeadGenArr[10];
                        if General10 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general11)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General11 := HeadGenArr[11];
                        if General11 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general12)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General12 := HeadGenArr[12];
                        if General12 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general13)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General13 := HeadGenArr[13];
                        if General13 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general14)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General14 := HeadGenArr[14];
                        if General14 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general15)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General15 := HeadGenArr[15];
                        if General15 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general16)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General16 := HeadGenArr[16];
                        if General16 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general17)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General17 := HeadGenArr[17];
                        if General17 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general18)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General18 := HeadGenArr[18];
                        if General18 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general19)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General19 := HeadGenArr[19];
                        if General19 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(general20)
                {
                    MinOccurs = Zero;
                    XmlName = 'General';

                    trigger OnBeforePassVariable()
                    begin
                        General20 := HeadGenArr[20];
                        if General20 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking1)
                {
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking1 := HeadPickArr[1];
                    end;
                }
                textelement(picking2)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking2 := HeadPickArr[2];
                        if Picking2 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking3)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking3 := HeadPickArr[3];
                        if Picking3 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking4)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking4 := HeadPickArr[4];
                        if Picking4 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking5)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking5 := HeadPickArr[5];
                        if Picking5 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking6)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking6 := HeadPickArr[6];
                        if Picking6 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking7)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking7 := HeadPickArr[7];
                        if Picking7 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking8)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking8 := HeadPickArr[8];
                        if Picking8 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking9)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking9 := HeadPickArr[9];
                        if Picking9 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking10)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking10 := HeadPickArr[10];
                        if Picking10 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking11)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking11 := HeadPickArr[11];
                        if Picking11 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking12)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking12 := HeadPickArr[12];
                        if Picking12 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking13)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking13 := HeadPickArr[13];
                        if Picking13 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking14)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking14 := HeadPickArr[14];
                        if Picking14 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking15)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking15 := HeadPickArr[15];
                        if Picking15 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking16)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking16 := HeadPickArr[16];
                        if Picking16 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking17)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking17 := HeadPickArr[17];
                        if Picking17 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking18)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking18 := HeadPickArr[18];
                        if Picking18 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking19)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking19 := HeadPickArr[19];
                        if Picking19 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(picking20)
                {
                    MinOccurs = Zero;
                    XmlName = 'Picking';

                    trigger OnBeforePassVariable()
                    begin
                        Picking20 := HeadPickArr[20];
                        if Picking20 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack1)
                {
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack1 := HeadPackArr[1];
                    end;
                }
                textelement(pack2)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack2 := HeadPackArr[2];
                        if Pack2 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack3)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack3 := HeadPackArr[3];
                        if Pack3 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack4)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack4 := HeadPackArr[4];
                        if Pack4 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack5)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack5 := HeadPackArr[5];
                        if Pack5 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack6)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack6 := HeadPackArr[6];
                        if Pack6 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack7)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack7 := HeadPackArr[7];
                        if Pack7 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack8)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack8 := HeadPackArr[8];
                        if Pack8 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack9)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack9 := HeadPackArr[9];
                        if Pack9 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack10)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack10 := HeadPackArr[10];
                        if Pack10 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack11)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack11 := HeadPackArr[11];
                        if Pack11 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack12)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack12 := HeadPackArr[12];
                        if Pack12 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack13)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack13 := HeadPackArr[13];
                        if Pack13 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack14)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack14 := HeadPackArr[14];
                        if Pack14 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack15)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack15 := HeadPackArr[15];
                        if Pack15 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack16)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack16 := HeadPackArr[16];
                        if Pack16 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack17)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack17 := HeadPackArr[17];
                        if Pack17 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack18)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack18 := HeadPackArr[18];
                        if Pack18 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack19)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack19 := HeadPackArr[19];
                        if Pack19 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(pack20)
                {
                    MinOccurs = Zero;
                    XmlName = 'Packing';

                    trigger OnBeforePassVariable()
                    begin
                        Pack20 := HeadPackArr[20];
                        if Pack20 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport1)
                {
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport1 := HeadTransArr[1];
                    end;
                }
                textelement(transport2)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport2 := HeadTransArr[2];
                        if Transport2 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport3)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport3 := HeadTransArr[3];
                        if Transport3 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport4)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport4 := HeadTransArr[4];
                        if Transport4 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport5)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport5 := HeadTransArr[5];
                        if Transport5 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport6)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport6 := HeadTransArr[6];
                        if Transport6 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport7)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport7 := HeadTransArr[7];
                        if Transport7 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport8)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport8 := HeadTransArr[8];
                        if Transport8 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport9)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport9 := HeadTransArr[9];
                        if Transport9 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport10)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport10 := HeadTransArr[10];
                        if Transport10 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport11)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport11 := HeadTransArr[11];
                        if Transport11 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport12)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport12 := HeadTransArr[12];
                        if Transport12 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport13)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport13 := HeadTransArr[13];
                        if Transport13 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport14)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport14 := HeadTransArr[14];
                        if Transport14 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport15)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport15 := HeadTransArr[15];
                        if Transport15 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport16)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport16 := HeadTransArr[16];
                        if Transport16 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport17)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport17 := HeadTransArr[17];
                        if Transport17 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport18)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport18 := HeadTransArr[18];
                        if Transport18 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport19)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport19 := HeadTransArr[19];
                        if Transport19 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(transport20)
                {
                    MinOccurs = Zero;
                    XmlName = 'Transport';

                    trigger OnBeforePassVariable()
                    begin
                        Transport20 := HeadTransArr[20];
                        if Transport20 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export1)
                {
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export1 := HeadExpArr[1];
                    end;
                }
                textelement(export2)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export2 := HeadExpArr[2];
                        if Export2 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export3)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export3 := HeadExpArr[3];
                        if Export3 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export4)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export4 := HeadExpArr[4];
                        if Export4 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export5)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export5 := HeadExpArr[5];
                        if Export5 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export6)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export6 := HeadExpArr[6];
                        if Export6 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export7)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export7 := HeadExpArr[7];
                        if Export7 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export8)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export8 := HeadExpArr[8];
                        if Export8 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export9)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export9 := HeadExpArr[9];
                        if Export9 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export10)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export10 := HeadExpArr[10];
                        if Export10 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export11)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export11 := HeadExpArr[11];
                        if Export11 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export12)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export12 := HeadExpArr[12];
                        if Export12 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export13)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export13 := HeadExpArr[13];
                        if Export13 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export14)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export14 := HeadExpArr[14];
                        if Export14 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export15)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export15 := HeadExpArr[15];
                        if Export15 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export16)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export16 := HeadExpArr[16];
                        if Export16 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export17)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export17 := HeadExpArr[17];
                        if Export17 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export18)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export18 := HeadExpArr[18];
                        if Export18 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export19)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export19 := HeadExpArr[19];
                        if Export19 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(export20)
                {
                    MinOccurs = Zero;
                    XmlName = 'Export';

                    trigger OnBeforePassVariable()
                    begin
                        Export20 := HeadExpArr[20];
                        if Export20 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer1)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer1 := HeadCustArr[1];
                    end;
                }
                textelement(customer2)
                {
                    MinOccurs = Zero;
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer2 := HeadCustArr[2];
                        if Customer2 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer3)
                {
                    MinOccurs = Zero;
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer3 := HeadCustArr[3];
                        if Customer3 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer4)
                {
                    MinOccurs = Zero;
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer4 := HeadCustArr[4];
                        if Customer4 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer5)
                {
                    MinOccurs = Zero;
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer5 := HeadCustArr[5];
                        if Customer5 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer6)
                {
                    MinOccurs = Zero;
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer6 := HeadCustArr[6];
                        if Customer6 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer7)
                {
                    MinOccurs = Zero;
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer7 := HeadCustArr[7];
                        if Customer7 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer8)
                {
                    MinOccurs = Zero;
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer8 := HeadCustArr[8];
                        if Customer8 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer9)
                {
                    MinOccurs = Zero;
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer9 := HeadCustArr[9];
                        if Customer9 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer10)
                {
                    MinOccurs = Zero;
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer10 := HeadCustArr[10];
                        if Customer10 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer11)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer11 := HeadCustArr[11];
                        if Customer11 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer12)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer12 := HeadCustArr[12];
                        if Customer12 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer13)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer13 := HeadCustArr[13];
                        if Customer13 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer14)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer14 := HeadCustArr[14];
                        if Customer14 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer15)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer15 := HeadCustArr[15];
                        if Customer15 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer16)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer16 := HeadCustArr[16];
                        if Customer16 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer17)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer17 := HeadCustArr[17];
                        if Customer17 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer18)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer18 := HeadCustArr[18];
                        if Customer18 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer19)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer19 := HeadCustArr[19];
                        if Customer19 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(customer20)
                {
                    XmlName = 'Customer';

                    trigger OnBeforePassVariable()
                    begin
                        Customer20 := HeadCustArr[20];
                        if Customer20 = '' then
                            currXMLport.Skip;
                    end;
                }
                textelement(saphead)
                {
                    XmlName = 'SAP';
                }
            }
            textelement(Items)
            {
                tableelement("VCK Delivery Document Line"; "VCK Delivery Document Line")
                {
                    CalcFields = "External Document No. End Cust";
                    LinkFields = "Document No." = field("No.");
                    LinkTable = "VCK Delivery Document Header";
                    XmlName = 'Item';
                    SourceTableView = where("Freight Cost Item" = const(false));
                    fieldelement(ItemNo; "VCK Delivery Document Line"."Item No.")
                    {
                    }
                    textelement(Barcode)
                    {
                    }
                    textelement(ItemNoReceiver)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            ItemNoReceiver := recItemCrossRef."Reference No.";  // 16-01-20 ZY-LD 002
                        end;
                    }
                    fieldelement(Description; "VCK Delivery Document Line".Description)
                    {
                    }
                    fieldelement(Quantity; "VCK Delivery Document Line".Quantity)
                    {
                    }
                    fieldelement(UnitPrice; "VCK Delivery Document Line"."Unit Price")
                    {
                    }
                    fieldelement(CurrencyCode; "VCK Delivery Document Line"."Currency Code")
                    {
                    }
                    textelement(CountryOfOrigin)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            CountryOfOrigin := recItem."Country/Region of Origin Code";  // 16-01-20 ZY-LD 002
                        end;
                    }
                    textelement(Warehouse)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            Warehouse := ItemLogisticEvent.GetMainWarehouseLocation;  // 23-05-22 ZY-LD 008
                        end;
                    }
                    fieldelement(Location; "VCK Delivery Document Line".Location)
                    {
                    }
                    textelement(Bin)
                    {
                    }
                    fieldelement(OrderNo; "VCK Delivery Document Header"."No.")
                    {
                    }
                    fieldelement(LineNo; "VCK Delivery Document Line"."Line No.")
                    {
                    }
                    textelement(InvoiceNo)
                    {
                    }
                    textelement(InvoiceDate)
                    {
                    }
                    textelement(Tracking)
                    {
                    }
                    textelement(references1)
                    {
                        XmlName = 'References';
                        fieldelement(CustomerReference; "VCK Delivery Document Line"."Document No.")
                        {
                            Width = 80;
                        }
                        fieldelement(ReceiverReference; "VCK Delivery Document Line"."Customer Order No.")
                        {
                            Width = 80;
                        }
                    }
                    textelement(commentsline)
                    {
                        XmlName = 'Comments';
                        textelement(packing1)
                        {
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing1 := LinePackArr[1];
                            end;
                        }
                        textelement(packing2)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing2 := LinePackArr[2];
                                if Packing2 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing3)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing3 := LinePackArr[3];
                                if Packing3 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing4)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing4 := LinePackArr[4];
                                if Packing4 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing5)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing5 := LinePackArr[5];
                                if Packing5 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing6)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing6 := LinePackArr[6];
                                if Packing6 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing7)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing7 := LinePackArr[7];
                                if Packing7 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing8)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing8 := LinePackArr[8];
                                if Packing8 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing9)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing9 := LinePackArr[9];
                                if Packing9 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing10)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing10 := LinePackArr[10];
                                if Packing10 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing11)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing11 := LinePackArr[11];
                                if Packing11 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing12)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing12 := LinePackArr[12];
                                if Packing12 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing13)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing13 := LinePackArr[13];
                                if Packing13 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing14)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing14 := LinePackArr[14];
                                if Packing14 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing15)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing15 := LinePackArr[15];
                                if Packing15 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing16)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing16 := LinePackArr[16];
                                if Packing16 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing17)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing17 := LinePackArr[17];
                                if Packing17 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing18)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing18 := LinePackArr[18];
                                if Packing18 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing19)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing19 := LinePackArr[19];
                                if Packing19 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                        textelement(packing20)
                        {
                            MinOccurs = Zero;
                            XmlName = 'Packing';

                            trigger OnBeforePassVariable()
                            begin
                                Packing20 := LinePackArr[20];
                                if Packing20 = '' then
                                    currXMLport.Skip;
                            end;
                        }
                    }
                    textelement(SerialNumbers)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        ActionCodeLine: Text;
                        CountLine: Integer;
                        WorkString: Text;
                        i: Integer;
                        ThisCode: Code[10];
                        "Count": Integer;
                    begin
                        Clear(LinePackArr);
                        recDelDocAction.Reset;
                        recDelDocAction.SetCurrentkey("Delivery Document No.", "Comment Type", Sequence);
                        recDelDocAction.SetRange("Delivery Document No.", "VCK Delivery Document Header"."No.");
                        recDelDocAction.SetRange("Header / Line", recDelDocAction."header / line"::Line);
                        recDelDocAction.SetAutocalcFields("Action Description");
                        for i := 0 to 6 do begin  // Looping "Comment Type"
                            recDelDocAction.SetRange("Comment Type", i);
                            if recDelDocAction.FindSet then begin
                                repeat
                                    case recDelDocAction."Comment Type" of
                                        //recDelDocAction."Comment Type"::Picking : InsertIntoArray(LinePickArr,recDelDocAction."Action Description",recDelDocAction."Insert Blank After This Line");  // 13-02-20 ZY-LD 002
                                        recDelDocAction."comment type"::Packing:
                                            InsertIntoArray(LinePackArr, recDelDocAction."Action Description", recDelDocAction."Insert Blank After This Line");
                                    //recDelDocAction."Comment Type"::Transport : InsertIntoArray(LineTransArr,recDelDocAction."Action Description",recDelDocAction."Insert Blank After This Line");  // 13-02-20 ZY-LD 002
                                    //recDelDocAction."Comment Type"::Customer : InsertIntoArray(LineCustArr,recDelDocAction."Action Description",recDelDocAction."Insert Blank After This Line");  // 13-02-20 ZY-LD 002
                                    end;
                                until recDelDocAction.Next() = 0;
                            end;
                        end;

                        recItem.Get("VCK Delivery Document Line"."Item No.");

                        //>> 13-02-20 ZY-LD 002
                        //>> 26-08-20 ZY-LD 004
                        recItemCrossRef.SetRange("Item No.", "VCK Delivery Document Line"."Item No.");
                        recItemCrossRef.SetFilter("Unit of Measure", '%1|%2', recItem."Base Unit of Measure", '');
                        recItemCrossRef.SetRange("Reference Type", recItemCrossRef."reference type"::Customer);
                        recItemCrossRef.SetRange("Reference Type No.", "VCK Delivery Document Header"."Sell-to Customer No.");
                        if not recItemCrossRef.FindLast then
                            Clear(recItemCrossRef);
                        //<< 26-08-20 ZY-LD 004

                        /*IF recItemCrossRef."Cross-Reference No." <> '' THEN
                          InsertIntoArray(LineCustArr,STRSUBSTNO('Your Item No.: %1',recItemCrossRef."Cross-Reference No."),FALSE);
                        
                        IF recItemCrossRef."Add EAN Code to Delivery Note" AND (recItemCrossRef."Cross-Reference EAN Code" <> '') THEN
                          InsertIntoArray(LineCustArr,STRSUBSTNO('EAN Code: %1',recItemCrossRef."Cross-Reference EAN Code"),FALSE);
                        
                        IF "VCK Delivery Document Line"."External Document No. End Cust" <> '' THEN
                          InsertIntoArray(LineCustArr,STRSUBSTNO('Your Reference: %1',"VCK Delivery Document Line"."External Document No. End Cust"),FALSE)*/
                        //<< 13-02-20 ZY-LD 002

                        // IF STRLEN(LineActionCode) > 0 THEN BEGIN
                        //  CountLine := VCKXML.CountActionCode(LineActionCode);
                        //  IF CountLine = 0 THEN AddLineActionCode(LineActionCode);
                        //  IF CountLine > 0 THEN BEGIN
                        //    WorkString := CONVERTSTR(LineActionCode,'-',',');
                        //    FOR i := 1 TO CountLine + 1 DO BEGIN
                        //      ThisCode := SELECTSTR(i,WorkString);
                        //      AddLineActionCode(ThisCode);
                        //    END;
                        //  END;
                        // END;
                        //
                        // ActionCodeLine := VCKXML.ReplaceString("VCK Delivery Document Line"."Action Code",';',',');
                        // IF STRLEN(ActionCodeLine) > 0 THEN BEGIN
                        //  ActionCodeLine := UPPERCASE(ActionCodeLine);
                        //  Count := VCKXML.CountActionCode(ActionCodeLine);
                        //  IF Count = 0 THEN BEGIN
                        //    IF VCKXML.GetActionCodeType(ActionCodeLine) = 2 THEN
                        //      AddHeaderActionCode(ActionCodeLine);
                        //    IF VCKXML.GetActionCodeType(ActionCodeLine) = 1 THEN
                        //      AddLineActionCode(ActionCodeLine);
                        //  END;
                        //  IF Count > 0 THEN BEGIN
                        //    WorkString := CONVERTSTR(ActionCodeLine,'-',',');
                        //    FOR i := 1 TO Count + 1 DO BEGIN
                        //      ThisCode := SELECTSTR(i,WorkString);
                        //      IF VCKXML.GetActionCodeType(ThisCode) = 2 THEN
                        //        AddHeaderActionCode(ThisCode);
                        //      IF VCKXML.GetActionCodeType(ThisCode) = 1 THEN
                        //        AddLineActionCode(ThisCode);
                        //    END;
                        //  END;
                        // END;

                    end;
                }
            }
            textelement(PackingDetails)
            {
                MinOccurs = Zero;
                textelement(items1)
                {
                    XmlName = 'Items';
                }
            }
            textelement(Handling)
            {
                textelement(Alarm)
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                recVCKDeliveryNoteComments: Record "VCK Delivery Note Comments";
                ActionCodeHeader: Text;
                "Count": Integer;
                WorkString: Text;
                ThisCode: Text[20];
                CommentType: Option General,Picking,Packing,Transport,Export,Customer,SAP;
                FirstLineNo: Integer;
                LineNumber: Integer;
            begin
                UrgentOrder := 'False';
                LineActionCode := '';

                //>> 01-08-22 ZY-LD 009
                /*IF "VCK Delivery Document Header"."Document Type" = "VCK Delivery Document Header"."Document Type"::Sales THEN
                  OrderType := 'SO'
                ELSE
                  OrderType := 'TO';*/
                OrderType := 'SO';
                //<< 01-08-22 ZY-LD 009

                Clear(HeadCustArr);
                Clear(HeadGenArr);
                recDelDocAction.Reset;
                recDelDocAction.SetCurrentkey("Delivery Document No.", "Comment Type", Sequence);
                recDelDocAction.SetRange("Delivery Document No.", "VCK Delivery Document Header"."No.");
                recDelDocAction.SetRange("Header / Line", recDelDocAction."header / line"::Header);
                recDelDocAction.SetAutocalcFields("Action Description");
                for CommentType := Commenttype::General to Commenttype::SAP do begin  // Looping "Comment Type"
                    recDelDocAction.SetRange("Comment Type", CommentType);
                    if recDelDocAction.FindSet then
                        repeat
                            case recDelDocAction."Comment Type" of
                                recDelDocAction."comment type"::General:
                                    InsertIntoArray(HeadGenArr, StrSubstNo(recDelDocAction."Action Description", "VCK Delivery Document Header"."Spec. Order No."), recDelDocAction."Insert Blank After This Line");
                                recDelDocAction."comment type"::Picking:
                                    InsertIntoArray(HeadPickArr, StrSubstNo(recDelDocAction."Action Description", "VCK Delivery Document Header"."Spec. Order No."), recDelDocAction."Insert Blank After This Line");
                                recDelDocAction."comment type"::Packing:
                                    InsertIntoArray(HeadPackArr, StrSubstNo(recDelDocAction."Action Description", "VCK Delivery Document Header"."Spec. Order No."), recDelDocAction."Insert Blank After This Line");
                                recDelDocAction."comment type"::Transport:
                                    InsertIntoArray(HeadTransArr, StrSubstNo(recDelDocAction."Action Description", "VCK Delivery Document Header"."Spec. Order No."), recDelDocAction."Insert Blank After This Line");
                                recDelDocAction."comment type"::Export:
                                    InsertIntoArray(HeadExpArr, StrSubstNo(recDelDocAction."Action Description", "VCK Delivery Document Header"."Spec. Order No."), recDelDocAction."Insert Blank After This Line");
                                recDelDocAction."comment type"::Customer:
                                    InsertIntoArray(HeadCustArr, recDelDocAction."Action Description", recDelDocAction."Insert Blank After This Line");
                            end;
                        until recDelDocAction.Next() = 0;

                    if CommentType = Commenttype::Customer then begin
                        recVCKDeliveryNoteComments.SetRange("Delivery Document No.", "VCK Delivery Document Header"."No.");
                        if recVCKDeliveryNoteComments.FindSet then begin
                            InsertIntoArray(HeadCustArr, recVCKDeliveryNoteComments."Delivery Comment 1", false);
                            InsertIntoArray(HeadCustArr, recVCKDeliveryNoteComments."Delivery Comment 2", false);
                            InsertIntoArray(HeadCustArr, recVCKDeliveryNoteComments."Delivery Comment 3", false);
                            InsertIntoArray(HeadCustArr, recVCKDeliveryNoteComments."Delivery Comment 4", false);
                            InsertIntoArray(HeadCustArr, recVCKDeliveryNoteComments."Delivery Comment 5", false);
                            InsertIntoArray(HeadCustArr, recVCKDeliveryNoteComments."Delivery Comment 6", false);
                            InsertIntoArray(HeadCustArr, recVCKDeliveryNoteComments."Delivery Comment 7", false);
                            InsertIntoArray(HeadCustArr, recVCKDeliveryNoteComments."Delivery Comment 8", false);
                            InsertIntoArray(HeadCustArr, recVCKDeliveryNoteComments."Delivery Comment 9", false);
                            InsertIntoArray(HeadCustArr, recVCKDeliveryNoteComments."Delivery Comment 10", false);
                        end;
                    end;
                end;

                //>> 13-02-20 ZY-LD 002
                recDelDocLine.SetRange("Document No.", "VCK Delivery Document Header"."No.");
                recDelDocLine.SetAutocalcFields("External Document No. End Cust", "External Document No.");
                if recDelDocLine.FindSet then begin
                    ReceiverReference := '';  // 06-04-22 ZY-LD 007
                    repeat
                        LineNumber := recDelDocLine."Line No." / 10000;
                        if recDelDocLine."External Document No. End Cust" <> '' then begin
                            if recDelDocLine."External Document No. End Cust" <> PrevYourRef then begin
                                if FirstLineNo <> 0 then
                                    InsertIntoArray(HeadCustArr, StrSubstNo('#%1..#%2', FirstLineNo, LineNumber - 1), false);
                                InsertIntoArray(HeadCustArr, StrSubstNo('Your Ref.: %1', recDelDocLine."External Document No. End Cust"), false);
                                PrevYourRef := recDelDocLine."External Document No. End Cust";
                                FirstLineNo := LineNumber;
                            end;
                        end else begin
                            if FirstLineNo <> 0 then
                                InsertIntoArray(HeadCustArr, StrSubstNo('#%1..#%2', FirstLineNo, LineNumber - 1), false);
                            FirstLineNo := 0;
                        end;

                        //>> 06-04-22 ZY-LD 007
                        if StrPos(ReceiverReference, recDelDocLine."External Document No.") = 0 then
                            if ReceiverReference = '' then
                                ReceiverReference := recDelDocLine."External Document No."
                            else
                                ReceiverReference += StrSubstNo(',%1', recDelDocLine."External Document No.");
                    //<< 06-04-22 ZY-LD 007
                    until recDelDocLine.Next() = 0;

                    if FirstLineNo <> 0 then
                        InsertIntoArray(HeadCustArr, StrSubstNo('#%1..#%2', FirstLineNo, LineNumber), false);
                end;

                if recDelDocLine.FindSet then
                    repeat
                        LineNumber := recDelDocLine."Line No." / 10000;
                        recItem.Get(recDelDocLine."Item No.");
                        recItemCrossRef.SetRange("Item No.", recItem."No.");
                        recItemCrossRef.SetFilter("Unit of Measure", '%1|%2', recItem."Base Unit of Measure", '');
                        recItemCrossRef.SetRange("Reference Type", recItemCrossRef."reference type"::Customer);
                        recItemCrossRef.SetRange("Reference Type No.", "VCK Delivery Document Header"."Sell-to Customer No.");
                        if recItemCrossRef.FindLast then begin
                            if recItemCrossRef."Reference No." <> '' then
                                InsertIntoArray(HeadCustArr, StrSubstNo('#%1: Your Item No.: %2', LineNumber, recItemCrossRef."Reference No."), false);

                            if recItemCrossRef."Add EAN Code to Delivery Note" and (recItemCrossRef."Cross-Reference EAN Code" <> '') then
                                InsertIntoArray(HeadCustArr, StrSubstNo('#%1: EAN: %2', LineNumber, recItemCrossRef."Cross-Reference EAN Code"), false);
                        end;
                    until recDelDocLine.Next() = 0;
                //<< 13-02-20 ZY-LD 002

                // ActionCodeHeader := VCKXML.ReplaceString("VCK Delivery Document Header"."Action Code",';',',');
                // IF STRLEN(ActionCodeHeader) > 0 THEN BEGIN
                //  ActionCodeHeader := UPPERCASE(ActionCodeHeader);
                //  Count := VCKXML.CountActionCode(ActionCodeHeader);
                //  IF Count = 0 THEN BEGIN
                //    IF VCKXML.GetActionCodeType(ActionCodeHeader) = 2 THEN
                //      General1 := VCKXML.GetActionCodeDescription(ActionCodeHeader);
                //    IF VCKXML.GetActionCodeType(ActionCodeHeader) = 1 THEN
                //      LineActionCode := ActionCodeHeader;
                //  END;
                //  IF Count > 0 THEN BEGIN
                //    WorkString := CONVERTSTR(ActionCodeHeader,'-',',');
                //    FOR i := 1 TO Count + 1 DO BEGIN
                //      ThisCode := SELECTSTR(i,WorkString);
                //      IF VCKXML.GetActionCodeType(ThisCode) = 2 THEN
                //        AddHeaderActionCode(ThisCode);
                //      IF VCKXML.GetActionCodeType(ThisCode) = 1 THEN
                //        LineActionCode := LineActionCode + ActionCodeHeader + ',';
                //    END;
                //    LineActionCode := DELCHR(LineActionCode,'>',',');
                //  END;
                // END;

                //>> 26-01-22 ZY-LD 005
                DeliveryTermsCity := '';
                recShipMeth.Get("VCK Delivery Document Header"."Delivery Terms Terms");
                case recShipMeth."Read Incoterms City From" of
                    recShipMeth."read incoterms city from"::"Ship-to City":
                        DeliveryTermsCity := "VCK Delivery Document Header"."Ship-to City";
                    recShipMeth."read incoterms city from"::"Location City":
                        begin
                            recLocation.Get("VCK Delivery Document Header"."Ship-From Code");
                            DeliveryTermsCity := recLocation.City;
                        end;
                end;
                //<< 26-01-22 ZY-LD 005

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
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        recSalesSetup.Get;  // 20-04-20 ZY-LD 003
    end;

    var
        recDelDocAction: Record "Delivery Document Action Code";
        recItem: Record Item;
        recItemCrossRef: Record "Item Reference";
        recDelDocLine: Record "VCK Delivery Document Line";
        recSalesSetup: Record "Sales & Receivables Setup";
        recShipMeth: Record "Shipment Method";
        recLocation: Record Location;
        LineActionCode: Text;
        VCKXML: Codeunit "VCK Communication Management";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        HeadGenArr: array[20] of Text[150];
        HeadPickArr: array[20] of Text[150];
        HeadPackArr: array[20] of Text[150];
        HeadTransArr: array[20] of Text[150];
        HeadExpArr: array[20] of Text[150];
        HeadCustArr: array[20] of Text[150];
        LinePackArr: array[20] of Text[150];
        i: Integer;
        PrevYourRef: Code[20];

    local procedure AddHeaderActionCode(ActionCode: Code[20])
    var
        Description: Text;
    begin
        Description := VCKXML.GetActionCodeDescription(ActionCode);
        if StrLen(Description) > 0 then begin
            if General1 = Description then
                exit;
            if General2 = Description then
                exit;
            if General3 = Description then
                exit;
            if General4 = Description then
                exit;
            if General5 = Description then
                exit;
            if General6 = Description then
                exit;
            if General7 = Description then
                exit;
            if General8 = Description then
                exit;
            if General9 = Description then
                exit;
            if General10 = Description then
                exit;
            if General11 = Description then
                exit;
            if General12 = Description then
                exit;
            if General13 = Description then
                exit;
            if General14 = Description then
                exit;
            if General15 = Description then
                exit;
            if General16 = Description then
                exit;
            if General17 = Description then
                exit;
            if General18 = Description then
                exit;
            if General19 = Description then
                exit;
            if General20 = Description then
                exit;
            if StrLen(General1) = 0 then begin
                General1 := Description;
                exit;
            end;
            if StrLen(General2) = 0 then begin
                General2 := Description;
                exit;
            end;
            if StrLen(General3) = 0 then begin
                General3 := Description;
                exit;
            end;
            if StrLen(General4) = 0 then begin
                General4 := Description;
                exit;
            end;
            if StrLen(General5) = 0 then begin
                General5 := Description;
                exit;
            end;
            if StrLen(General6) = 0 then begin
                General6 := Description;
                exit;
            end;
            if StrLen(General7) = 0 then begin
                General7 := Description;
                exit;
            end;
            if StrLen(General8) = 0 then begin
                General8 := Description;
                exit;
            end;
            if StrLen(General9) = 0 then begin
                General9 := Description;
                exit;
            end;
            if StrLen(General10) = 0 then begin
                General10 := Description;
                exit;
            end;
            if StrLen(General11) = 0 then begin
                General11 := Description;
                exit;
            end;
            if StrLen(General12) = 0 then begin
                General12 := Description;
                exit;
            end;
            if StrLen(General13) = 0 then begin
                General13 := Description;
                exit;
            end;
            if StrLen(General14) = 0 then begin
                General14 := Description;
                exit;
            end;
            if StrLen(General15) = 0 then begin
                General15 := Description;
                exit;
            end;
            if StrLen(General16) = 0 then begin
                General16 := Description;
                exit;
            end;
            if StrLen(General17) = 0 then begin
                General17 := Description;
                exit;
            end;
            if StrLen(General18) = 0 then begin
                General18 := Description;
                exit;
            end;
            if StrLen(General19) = 0 then begin
                General19 := Description;
                exit;
            end;
            if StrLen(General20) = 0 then begin
                General20 := Description;
                exit;
            end;
        end;
    end;

    local procedure AddLineActionCode(ActionCode: Code[20])
    var
        Description: Text;
    begin
        Description := VCKXML.GetActionCodeDescription(ActionCode);
        if StrLen(Description) > 0 then begin
            if Packing1 = Description then
                exit;
            if Packing2 = Description then
                exit;
            if Packing3 = Description then
                exit;
            if Packing4 = Description then
                exit;
            if Packing5 = Description then
                exit;
            if Packing6 = Description then
                exit;
            if Packing7 = Description then
                exit;
            if Packing8 = Description then
                exit;
            if Packing9 = Description then
                exit;
            if Packing10 = Description then
                exit;
            if Packing11 = Description then
                exit;
            if Packing12 = Description then
                exit;
            if Packing13 = Description then
                exit;
            if Packing14 = Description then
                exit;
            if Packing15 = Description then
                exit;
            if Packing16 = Description then
                exit;
            if Packing17 = Description then
                exit;
            if Packing18 = Description then
                exit;
            if Packing19 = Description then
                exit;
            if Packing20 = Description then
                exit;
            if StrLen(Packing1) = 0 then begin
                Packing1 := Description;
                exit;
            end;
            if StrLen(Packing2) = 0 then begin
                Packing2 := Description;
                exit;
            end;
            if StrLen(Packing3) = 0 then begin
                Packing3 := Description;
                exit;
            end;
            if StrLen(Packing4) = 0 then begin
                Packing4 := Description;
                exit;
            end;
            if StrLen(Packing5) = 0 then begin
                Packing5 := Description;
                exit;
            end;
            if StrLen(Packing6) = 0 then begin
                Packing6 := Description;
                exit;
            end;
            if StrLen(Packing7) = 0 then begin
                Packing7 := Description;
                exit;
            end;
            if StrLen(Packing8) = 0 then begin
                Packing8 := Description;
                exit;
            end;
            if StrLen(Packing9) = 0 then begin
                Packing9 := Description;
                exit;
            end;
            if StrLen(Packing10) = 0 then begin
                Packing10 := Description;
                exit;
            end;
            if StrLen(Packing11) = 0 then begin
                Packing11 := Description;
                exit;
            end;
            if StrLen(Packing12) = 0 then begin
                Packing12 := Description;
                exit;
            end;
            if StrLen(Packing13) = 0 then begin
                Packing13 := Description;
                exit;
            end;
            if StrLen(Packing14) = 0 then begin
                Packing14 := Description;
                exit;
            end;
            if StrLen(Packing15) = 0 then begin
                Packing15 := Description;
                exit;
            end;
            if StrLen(Packing16) = 0 then begin
                Packing16 := Description;
                exit;
            end;
            if StrLen(Packing17) = 0 then begin
                Packing17 := Description;
                exit;
            end;
            if StrLen(Packing18) = 0 then begin
                Packing18 := Description;
                exit;
            end;
            if StrLen(Packing19) = 0 then begin
                Packing19 := Description;
                exit;
            end;
            if StrLen(Packing20) = 0 then begin
                Packing20 := Description;
                exit;
            end;
        end;
    end;


    procedure SetParameters(Customer: Text[20]; Project: Code[20]; Message: Code[20])
    begin
        CustomerID := Customer;
        ProjectID := Project;
        //CustomerMessageNo := Message;
    end;

    local procedure InsertIntoArray(var pArray: array[20] of Text[150]; pValue: Text[150]; pInsertBlankLine: Boolean)
    var
        j: Integer;
    begin
        if pValue <> '' then
            for j := 1 to ArrayLen(pArray) do
                if pArray[j] = '' then begin
                    pArray[j] := pValue;
                    if pInsertBlankLine then
                        InsertBlankArray(pArray);
                    j := ArrayLen(pArray) + 1;
                end;
    end;

    local procedure InsertBlankArray(var pArray: array[20] of Text[150])
    var
        lText001: label '---';
        j: Integer;
    begin
        for j := 1 to ArrayLen(pArray) do
            if pArray[j] = '' then begin
                pArray[j] := lText001;
                j := ArrayLen(pArray) + 1;
            end;
    end;
}
