page 50065 "eCommerce Order Archive Card"
{
    Caption = 'eCommerce Order Archive Card';
    DeleteAllowed = false;
    Editable = false;
    SourceTable = "eCommerce Order Archive";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control44)
                {
                    group(Control51)
                    {
                        field("Transaction Type"; Rec."Transaction Type")
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                        }
                        field("eCommerce Order Id"; Rec."eCommerce Order Id")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Order ID';
                            Editable = false;
                        }
                        field("Invoice No."; Rec."Invoice No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Editable = false;
                        }
                        field("Give Away Order"; Rec."Give Away Order")
                        {
                            ApplicationArea = Basic, Suite;
                        }
                    }
                    field("Sales Shipment No."; Rec."Sales Shipment No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                field("Marketplace ID"; Rec."Marketplace ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            part(Control38; "eComm. Order Archive Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Transaction Type" = field("Transaction Type"),
                              "eCommerce Order Id" = field("eCommerce Order Id"),
                              "Invoice No." = field("Invoice No.");
            }
            group(Invoice)
            {
                Caption = 'Invoice';
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                Field("Alt. VAT Bus. Posting Group"; Rec."Alt. VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                Field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Sell-to Type"; Rec."Sell-to Type")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("Tax Type"; Rec."Tax Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax Calculation Reason Code"; Rec."Tax Calculation Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax Reporting Scheme"; Rec."Tax Reporting Scheme")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Tax Collection Respons."; Rec."Tax Collection Respons.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax Address Role"; Rec."Tax Address Role")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tax Rate"; Rec."Tax Rate")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Alt. Tax Rate"; Rec."Alt. Tax Rate")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                group(Control41)
                {
                    field("Buyer Tax Reg. Type"; Rec."Buyer Tax Reg. Type")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Buyer Tax Reg. Country"; Rec."Buyer Tax Reg. Country")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Purchaser VAT No."; Rec."Purchaser VAT No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field("Alt. VAT Reg. No. Zyxel"; Rec."Alt. VAT Reg. No. Zyxel")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Invoice Download"; Rec."Invoice Download")
                    {
                        ApplicationArea = Basic, Suite;
                        ExtendedDatatype = URL;
                        Importance = Additional;
                    }
                    field("Reversed By"; Rec."Reversed By")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                group("Ship From")
                {
                    Caption = 'Ship-from';
                    Editable = false;
                    field("Ship-from City"; Rec."Ship-from City")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-from State"; Rec."Ship-from State")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-from Country"; Rec."Ship-from Country")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                    }
                    field("Ship-from Postal Code"; Rec."Ship-from Postal Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-from Tax Location Code"; Rec."Ship-from Tax Location Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Ship To")
                {
                    Caption = 'Ship-to';
                    Editable = false;
                    field("Ship-to City"; Rec."Ship-to City")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-to State"; Rec."Ship-to State")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-to Country"; Rec."Ship-to Country")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                    }
                    field("Ship-to Postal Code"; Rec."Ship-to Postal Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(PurchaserVATNo2; Rec."Purchaser VAT No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
            }
        }
        area(factboxes)
        {
            part(Control45; "eCommerce Order Arch. FactBox")
            {
                SubPageLink = "eCommerce Order Id" = field("eCommerce Order Id"),
                              "Invoice No." = field("Invoice No.");
            }
            part(Control46; "eCommerce Arch. Line FaxtBox")
            {
                Provider = Control38;
                SubPageLink = "eCommerce Order Id" = field("eCommerce Order Id"),
                              "Invoice No." = field("Invoice No."),
                              "Line No." = field("Line No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Documents)
            {
                Caption = 'Documents';
                action("Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Invoice';
                    Image = PostedOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "External Document No." = field("eCommerce Order Id");
                }
                action("Sales Cr. Memo")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Cr. Memo';
                    Image = PostedCreditMemo;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "External Document No." = field("eCommerce Order Id");
                }
            }
        }
        area(processing)
        {
            action("Download eCommerce Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Download eCommerce Document';
                Image = Document;

                trigger OnAction()
                var
                    ClientFilename: Text;
                    ServerFilename: Text;
                    FileMgt: Codeunit "File Management";

                begin
                    ServerFilename := FileMgt.ServerTempFileName('.pdf');
                    WebClient := WebClient.WebClient;
                    ServicePointManager.SecurityProtocol := SecurityProtocolType.Tls12;
                    WebClient.DownloadFile(Rec."Invoice Download", ServerFilename);
                    if FileMgt.ServerFileExists(ServerFilename) then begin
                        ClientFilename := StrSubstNo('%1.pdf', Rec."Invoice No.");
                        FileMgt.DownloadHandler(ServerFilename, '', '', 'PDF(*.pdf)|*.pdf|All files(*.*)|*.*', ClientFilename);
                        FileMgt.DeleteServerFile(ServerFilename);
                    end;
                end;
            }
        }
    }

    var
        WebClient: dotnet WebClient;
        ServicePointManager: dotnet ServicePointManager;
        SecurityProtocolType: dotnet SecurityProtocolType;
}
