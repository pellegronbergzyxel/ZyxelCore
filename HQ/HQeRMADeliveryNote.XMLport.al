XmlPort 50007 "HQ eRMA Delivery Note"
{
    Caption = 'HQ eRMA Delivery Note';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/eRMA';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Sales Shipment Header"; "Sales Shipment Header")
            {
                XmlName = 'DeliveryNote';
                fieldelement(No; "Sales Shipment Header"."No.")
                {
                }
                fieldelement(SellToName; "Sales Shipment Header"."Sell-to Customer Name")
                {
                }
                fieldelement(SellToContact; "Sales Shipment Header"."Sell-to Contact")
                {
                }
                fieldelement(SellToAddress; "Sales Shipment Header"."Sell-to Address")
                {
                }
                fieldelement(SellToPostCode; "Sales Shipment Header"."Sell-to Post Code")
                {
                }
                fieldelement(SellToCity; "Sales Shipment Header"."Sell-to City")
                {
                }
                textelement("<selltophone>")
                {
                    XmlName = 'SellToPhone';
                }
                textelement(SellToFax)
                {
                }
                textelement(SellToEmail)
                {
                }
                textelement(SellToHomepage)
                {
                }
                fieldelement(SellToTaxOfficeCode; "Sales Shipment Header"."Campaign No.")
                {
                }
                fieldelement(SellToVatID; "Sales Shipment Header"."Campaign No.")
                {
                }
                fieldelement(OrderDate; "Sales Shipment Header"."Order Date")
                {
                }
                fieldelement(PostingDate; "Sales Shipment Header"."Posting Date")
                {
                }
                fieldelement(DocumentDate; "Sales Shipment Header"."Document Date")
                {
                }
                fieldelement(ShippingAgentCode; "Sales Shipment Header"."Shipping Agent Code")
                {
                }
                fieldelement(ActualDespatchDateTime; "Sales Shipment Header"."Due Date")
                {
                }
                textelement(Note)
                {
                }
                tableelement("Sales Shipment Line"; "Sales Shipment Line")
                {
                    LinkFields = "Document No." = field("No.");
                    LinkTable = "Sales Shipment Header";
                    MinOccurs = Zero;
                    XmlName = 'DeliveryLine';
                    UseTemporary = true;
                    fieldelement(DocumentNo; "Sales Shipment Line"."Document No.")
                    {
                    }
                    fieldelement(ItemNo; "Sales Shipment Line"."No.")
                    {
                    }
                    fieldelement(ItemDescription; "Sales Shipment Line".Description)
                    {
                    }
                    textelement(SerialNo)
                    {
                    }
                    textelement(MACAddress)
                    {
                    }
                    textelement(ModelName)
                    {
                    }
                    textelement(ProblemCode)
                    {
                    }

                    trigger OnBeforeInsertRecord()
                    begin
                        LineNo += 10000;
                        "Sales Shipment Line"."Line No." := LineNo;
                    end;
                }
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
        LineNo: Integer;


    procedure GetData(var pDelNoteHeadTmp: Record "Sales Shipment Header" temporary; var pDelNoteLineTmp: Record "Sales Shipment Line" temporary)
    begin
        if "Sales Shipment Header".FindSet then
            repeat
                pDelNoteHeadTmp := "Sales Shipment Header";
                pDelNoteHeadTmp.Insert;
            until "Sales Shipment Header".Next() = 0;

        if "Sales Shipment Line".FindSet then
            repeat
                pDelNoteLineTmp := "Sales Shipment Line";
                pDelNoteLineTmp.Insert;
            until "Sales Shipment Line".Next() = 0;
    end;
}
