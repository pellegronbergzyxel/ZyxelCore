XmlPort 50062 "Send Transfer Order Request"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML

    Caption = 'Send Transfer Order Request';
    Direction = Export;
    Encoding = UTF8;
    FileName = 'C:\tmp\test.xml';
    Format = Xml;
    FormatEvaluate = Xml;
    UseDefaultNamespace = false;
    UseRequestPage = true;

    schema
    {
        tableelement("Transfer Header"; "Transfer Header")
        {
            XmlName = 'OutgoingFile';
            textelement(MessageNo)
            {
            }
            textelement(CustomerMessageNo)
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
            fieldelement(ExpectedReceiptDate; "Transfer Header"."Receipt Date")
            {
            }
            textelement(DeliveryTerms)
            {
                textelement(Terms)
                {
                }
                textelement(City)
                {
                }
            }
            textelement(Addresses)
            {
                textelement(ShippedFrom)
                {
                    fieldelement(AddressID; "Transfer Header"."Transfer-from Code")
                    {
                    }
                    fieldelement(Name; "Transfer Header"."Transfer-from Name")
                    {
                    }
                    fieldelement(Name2; "Transfer Header"."Transfer-from Name 2")
                    {
                    }
                    fieldelement(Contact; "Transfer Header"."Transfer-from Contact")
                    {
                    }
                    textelement(Phone)
                    {
                    }
                    textelement(Email)
                    {
                    }
                    fieldelement(Address; "Transfer Header"."Transfer-from Address")
                    {
                    }
                    fieldelement(Address2; "Transfer Header"."Transfer-from Address 2")
                    {
                    }
                    fieldelement(PostalCode; "Transfer Header"."Transfer-from Post Code")
                    {
                    }
                    fieldelement(City; "Transfer Header"."Transfer-from City")
                    {
                    }
                    fieldelement(State; "Transfer Header"."Transfer-from County")
                    {
                    }
                    fieldelement(CountryID; "Transfer Header"."Trsf.-from Country/Region Code")
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
                    fieldelement(AddressID; "Transfer Header"."Transfer-to Code")
                    {
                    }
                    fieldelement(Name; "Transfer Header"."Transfer-to Name")
                    {
                    }
                    fieldelement(Name2; "Transfer Header"."Transfer-to Name 2")
                    {
                    }
                    fieldelement(Contact; "Transfer Header"."Transfer-to Contact")
                    {
                    }
                    textelement(phone1)
                    {
                        XmlName = 'Phone';
                    }
                    textelement(email2)
                    {
                        XmlName = 'Email';
                    }
                    fieldelement(Address; "Transfer Header"."Transfer-to Address")
                    {
                    }
                    fieldelement(Address2; "Transfer Header"."Transfer-to Address 2")
                    {
                    }
                    fieldelement(PostalCode; "Transfer Header"."Transfer-to Post Code")
                    {
                    }
                    fieldelement(City; "Transfer Header"."Transfer-to City")
                    {
                    }
                    fieldelement(State; "Transfer Header"."Transfer-to County")
                    {
                    }
                    fieldelement(CountryID; "Transfer Header"."Trsf.-to Country/Region Code")
                    {
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
            textelement(References)
            {
                fieldelement(CustomerReference; "Transfer Header"."No.")
                {
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
            tableelement("<transfer line>"; "Transfer Line")
            {
                LinkFields = "Document No." = field("No.");
                LinkTable = "Transfer Header";
                XmlName = 'Items';
                textelement(Item)
                {
                    fieldelement(ItemNo; "<Transfer Line>"."Item No.")
                    {
                    }
                    textelement(ItemNoShipper)
                    {
                    }
                    fieldelement(Description; "<Transfer Line>".Description)
                    {
                    }
                    fieldelement(Quantity; "<Transfer Line>".Quantity)
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
                    }
                    textelement(Location)
                    {
                    }
                    textelement(Bin)
                    {
                    }
                    fieldelement(OrderNo; "Transfer Header"."No.")
                    {
                    }
                    fieldelement(LineNo; "<Transfer Line>"."Line No.")
                    {
                    }
                    fieldelement(ExpectedReceiptDate; "<Transfer Line>"."Receipt Date")
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

    trigger OnInitXmlPort()
    var
        recItem: Record Item;
    begin
    end;

    trigger OnPreXmlPort()
    var
        recSalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
    end;

    var
        Text001: label 'TO';


    procedure SetParameters(Customer: Text[20]; Project: Code[20]; Message: Code[20]; Warehouse: Code[20])
    begin
        CustomerID := Customer;
        ProjectID := Project;
        CustomerMessageNo := Message;
        Warehouse := Warehouse;
        Location := Warehouse;
    end;
}
