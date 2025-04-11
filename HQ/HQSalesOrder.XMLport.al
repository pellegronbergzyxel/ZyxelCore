XmlPort 50064 "HQ Sales Order"
{
    Caption = 'HQ Sales Order';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/so';
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Sales Header"; "Sales Header")
            {
                MinOccurs = Zero;
                XmlName = 'SalesHeader';
                UseTemporary = true;
                fieldelement(CustomerNo; "Sales Header"."Sell-to Customer No.")
                {
                }
                fieldelement(OrderDate; "Sales Header"."Order Date")
                {
                }
                fieldelement(CurrencyCode; "Sales Header"."Currency Code")
                {
                }
                fieldelement(ExternalDocumentNo; "Sales Header"."External Document No.")
                {
                }
                textelement(iseicard)
                {
                    XmlName = 'IsEiCard';

                    trigger OnAfterAssignVariable()
                    begin
                        if (UpperCase(IsEiCard) = 'YES') or (UpperCase(IsEiCard) = 'TRUE') or (IsEiCard = '1') then
                            "Sales Header"."Location Code" := 'EICARD'
                        else begin
                            recInvSetup.Get;
                            recInvSetup.TestField("AIT Location Code");
                            "Sales Header"."Location Code" := recInvSetup."AIT Location Code";
                        end;
                    end;
                }
                fieldelement(ShipToName; "Sales Header"."Ship-to Name")
                {
                }
                fieldelement(ShipToAddress; "Sales Header"."Ship-to Address")
                {
                }
                fieldelement(ShipToPostCode; "Sales Header"."Ship-to Post Code")
                {
                }
                fieldelement(ShipToCity; "Sales Header"."Ship-to City")
                {
                }
                fieldelement(ShipToCountryCode; "Sales Header"."Ship-to Country/Region Code")
                {
                }
                tableelement("Sales Line"; "Sales Line")
                {
                    MinOccurs = Zero;
                    XmlName = 'SalesLine';
                    UseTemporary = true;
                    fieldelement(ItemNo; "Sales Line"."No.")
                    {
                    }
                    fieldelement(Quantity; "Sales Line".Quantity)
                    {
                    }
                    fieldelement(UnitOfMeasure; "Sales Line"."Unit of Measure Code")
                    {
                    }
                    fieldelement(UnitPrice; "Sales Line"."Unit Price")
                    {
                    }

                    trigger OnAfterInitRecord()
                    begin
                        DummyLineNo += 10000;
                        "Sales Line"."Document Type" := "Sales Header"."Document Type";
                        "Sales Line"."Document No." := "Sales Header"."No.";
                        "Sales Line"."Line No." := DummyLineNo;
                    end;
                }

                trigger OnAfterInitRecord()
                begin
                    DummyNo := IncStr(DummyNo);
                    "Sales Header"."Document Type" := "Sales Header"."document type"::Order;
                    "Sales Header"."No." := DummyNo;
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

    trigger OnPreXmlPort()
    begin
        DummyNo := '0';
    end;

    var
        recInvSetup: Record "Inventory Setup";
        DummyNo: Code[10];
        DummyLineNo: Integer;


    procedure GetData(var recSalesHeadTmp: Record "Sales Header" temporary; var recSalesLineTmp: Record "Sales Line" temporary)
    begin
        if "Sales Header".FindSet then
            repeat
                recSalesHeadTmp := "Sales Header";
                recSalesHeadTmp.Insert;
            until "Sales Header".Next() = 0;

        if "Sales Line".FindSet then
            repeat
                recSalesLineTmp := "Sales Line";
                recSalesLineTmp.Insert;
            until "Sales Line".Next() = 0;
    end;
}
