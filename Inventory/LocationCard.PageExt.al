pageextension 50240 LocationCardZX extends "Location Card"
{
    layout
    {
        addafter("Code")
        {
            field("In Use"; Rec."In Use")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Use As In-Transit")
        {
            group(Control54)
            {
                ShowCaption = false;
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Order Type 2"; Rec."Sales Order Type 2")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            field("Default Order Type Location"; Rec."Default Order Type Location")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Include in Item Availability"; Rec."Include in Item Availability")
            {
                ApplicationArea = Basic, Suite;
            }
            field("VAT Registration No"; Rec."VAT Registration No")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Comp Name for Return SInvNo"; Rec."Comp Name for Return SInvNo")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Forecast Territory"; Rec."Forecast Territory")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'On transfer orders "Forecast Territory" is normally taken from the "Location Country/Region Code", but in special cases "Forecast Territory" is different.';
            }
            field("Default Return Reason Code"; Rec."Default Return Reason Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the return reason code that is used on a sales return order that has damaged products.';
            }
        }
        addafter("Home Page")
        {
            field("Notification Email"; Rec."Notification Email")
            {
                ApplicationArea = Basic, Suite;
                ExtendedDatatype = EMail;
            }
            field("Confirmation Email"; Rec."Confirmation Email")
            {
                ApplicationArea = Basic, Suite;
                ExtendedDatatype = EMail;
            }
        }
        addafter("Cross-Dock Due Date Calc.")
        {
            group(Zyxel)
            {
                Caption = 'Zyxel';
                field("Main Warehouse"; Rec."Main Warehouse")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Control67; Rec.Warehouse)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Outbound FTP Code"; Rec."Warehouse Outbound FTP Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Inbound FTP Code"; Rec."Warehouse Inbound FTP Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer ID"; Rec."Customer ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Project ID"; Rec."Project ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Message Number Series"; Rec."Message Number Series")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Prevent Negative Inventory"; Rec."Prevent Negative Inventory")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Post Transf. Rcpt on Transit"; Rec."Post Transf. Rcpt on Transit")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Post Transf. Ship on Transit"; Rec."Post Transf. Rcpt on Transit")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Use Ship-to Ctry on VAT Entry"; Rec."Use Ship-to Ctry on VAT Entry")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Unit Cost is Zero"; Rec."Allow Unit Cost is Zero")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that it´s allowed to post a sales invoice without "Unit Cost (LCY)" is filled.';
                }
                field("RMA Location"; Rec."RMA Location")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the location the warehouse is using as RMA Location.';
                }
            }
        }
        addafter("Bin Policies")
        {
            group(Control38)
            {
                Caption = 'Shipment';
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Control17)
            {
                Caption = 'Delivery Zone';
                field(DeliveryDays; DeliveryDays)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delivery Days';
                    Editable = false;
                }
                field(SuggestedZone; SuggestedZone)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suggested Zone';
                    Editable = false;
                }
            }
            group("Postal Codes")
            {
                Caption = 'Postal Codes';
                Label(Control27)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = TextLabel1;
                }
            }
            group(Intrastat)
            {
                Caption = 'Intrastat';
                field("Exclude from Intrastat Report"; Rec."Exclude from Intrastat Report")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the location will be excluded from the Intrastat Report.';
                }
                field("eCommerce Location"; Rec."eCommerce Location")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies eCommerce Location. If it is true, intrastat will look for the "Ship-from Country/Region Code" in the eCommerce order.';
                }
                field("Ship-from Country/Region Code"; Rec."Ship-from Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = ShipFromVisible;
                    ToolTip = 'Specifies the physical country/region code for the warehouse. In the subsidaries will the "Country/Region Code" be the country code for the local country. But from the purchase invoice we also need to know which country/region the products has been shipped from.';
                }
            }
            group(Dimension)
            {
                Caption = 'Dimension';
                field("Dimension Country Code"; Rec."Dimension Country Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        addfirst(factboxes)
        {
            part(SalesOrderTypeRelation; "Sales Order Type Rel. FactBox")
            {
                Caption = 'Sales Order Type';
                SubPageLink = "Location Code" = field(Code);
            }
        }
    }

    actions
    {
        addafter("&Location")
        {
            action("VAT Registration No. Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT Registration No. Setup';
                Image = VATPostingSetup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "VAT Reg. No. pr. Locations";
                RunPageLink = "Location Code" = field(Code);
            }
            action("Sales Order Type Relation")
            {
                ApplicationArea = Basic, Suite;
                Image = SocialSecurityLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Sales Order Type Relation";
                RunPageLink = "Location Code" = field(Code);
            }
            action("Transfer-&to Addresses")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Transfer-&to Addresses';
                Image = ShipAddress;
                RunObject = Page "Transfer-to Address List";
                RunPageLink = "Location Code" = field(Code);
            }
            action("Action Codes")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Action Codes';
                Image = "Action";

                trigger OnAction()
                var
                    DelDocMgt: Codeunit "Delivery Document Management";
                begin
                    DelDocMgt.EnterActionCode(Rec.Code, '', 4);
                end;
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field(Code);
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(14));
                }
            }
            group("Delivery Zone")
            {
                Caption = 'Delivery Zone';
                Visible = false;
                action(UseSuggested)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Use Suggested';
                    Visible = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //CurrPage.Editable(ZGT.UserIsDeveloper);  // 19-02-19 ZY-LD 002  // 29-08-24 ZY-LD 000 - Handled by BC permissions now.
        SetActions();
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();
    end;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        ShipFromVisible := not ZGT.IsRhq();
    end;

    var
        DeliveryDays: Integer;
        SuggestedZone: Text[30];
        ShipFromVisible: Boolean;
        TextLabel1: Label 'These are pre-defined post codes for the selected delivery zone. Please note that other post codes may be covered by this zone.';
        ZGT: Codeunit "ZyXEL General Tools";
}
