page 50239 "eCommerce Order Card"
{

    Caption = 'eCommerce Order Card';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "eCommerce Order Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                group(Control51)
                {
                    Caption = 'General';

                    field("Transaction Type"; Rec."Transaction Type")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Transaction Type';
                        Editable = false;
                    }
                    field("eCommerce Order Id"; Rec."eCommerce Order Id")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Order ID';
                        ToolTip = 'Specifies Order ID';
                        Editable = false;
                    }
                    field("Invoice No."; Rec."Invoice No.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Invoice No.';
                        Editable = false;
                    }
                    field("Give Away Order"; Rec."Give Away Order")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Give Away Order';
                    }
                }
                field("Marketplace ID"; Rec."Marketplace ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies MarketPlace ID';
                    Editable = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Order Date';
                    Editable = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Requested Delivery Date';
                    Editable = false;
                }
            }
            part(Control25; "eCommerce Order Subform")
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
                    ToolTip = 'Specifies VAT Bus. Posting Group';
                    Importance = Promoted;
                }
                Field("Alt. VAT Bus. Posting Group"; Rec."Alt. VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Alt. VAT Bus. Posting Group';
                    Importance = Additional;
                }
                Field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Prices Including VAT';
                    Importance = Additional;
                }
                field("Country Dimension"; Rec."Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Country Dimension';
                }
                field("Sell-to Type"; Rec."Sell-to Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Sell-To Type';
                    Importance = Promoted;
                }
                field("Tax Type"; Rec."Tax Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Tax Type';
                }
                field("Tax Calculation Reason Code"; Rec."Tax Calculation Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Tax Calculation Reason Code';
                }
                field("Tax Reporting Scheme"; Rec."Tax Reporting Scheme")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Tax Reporting Scheme';
                    Importance = Additional;
                }
                field("Tax Collection Respons."; Rec."Tax Collection Respons.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Tax Collection Respons';
                }
                field("Tax Address Role"; Rec."Tax Address Role")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Tax Address Role';
                    Editable = true;
                }
                field("Tax Rate"; Rec."Tax Rate")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Tax Rate';
                    Editable = Rec."Tax Rate" = 0;
                }
                field("Alt. Tax Rate"; Rec."Alt. Tax Rate")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Alt. Tax Rate';
                    Importance = Additional;
                }
                group(Control37)
                {
                    field("Buyer Tax Reg. Type"; Rec."Buyer Tax Reg. Type")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Buyer Tax Reg. Type';
                    }
                    field("Purchaser VAT No."; Rec."Purchaser VAT No.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Purchase VAT No.';
                    }
                    field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies VAT Registation No. Zyxel';
                        Editable = ForceUser; //20-05-2025 BK #503059
                    }
                    field("Alt. VAT Reg. No. Zyxel"; Rec."Alt. VAT Reg. No. Zyxel")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Alt. VAT Reg. No. Zyxel';
                    }

                    field("Invoice Download"; Rec."Invoice Download")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Invoice Download';
                        ExtendedDatatype = URL;
                        Importance = Additional;
                    }
                    field("Sales Document Type"; Rec."Sales Document Type")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Sales Document Type';
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
                    field("Ship From City"; Rec."Ship From City")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Ship From City';
                    }
                    field("Ship From State"; Rec."Ship From State")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Shi From State';
                    }
                    field("Ship From Country"; Rec."Ship From Country")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Ship From Country';
                        Importance = Promoted;
                    }
                    field("Ship From Postal Code"; Rec."Ship From Postal Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Ship From Postal Code';
                    }
                    field("Ship From Tax Location Code"; Rec."Ship From Tax Location Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies ';
                    }
                }
                group("Ship To")
                {
                    Caption = 'Ship-to';
                    Editable = false;
                    field("Ship To City"; Rec."Ship To City")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Ship To City';
                    }
                    field("Ship To State"; Rec."Ship To State")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Ship To State';
                    }
                    field("Ship To Country"; Rec."Ship To Country")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Ship To Country';
                        Importance = Promoted;
                    }
                    field("Ship To Postal Code"; Rec."Ship To Postal Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Ship To Postal Code';
                    }
                    field(PurchaserVATNo2; Rec."Purchaser VAT No.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies Purchase VAT No. 2';
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Currency Code';
                    Importance = Promoted;
                }
            }
            group(Application)
            {
                Caption = 'Application';
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Applies To Doc. Type';
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Applies To Doc. No.';
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Applies To ID';
                }
            }
        }
        area(factboxes)
        {
            part(Control30; "eCommerce Order FactBox2")
            {
                SubPageLink = "eCommerce Order Id" = field("eCommerce Order Id"),
                              "Invoice No." = field("Invoice No.");
            }
            part(Control31; "eCommerce Ship Details FactBox")
            {
                SubPageLink = "eCommerce Order Id" = field("eCommerce Order Id"),
                              "Invoice No." = field("Invoice No.");
            }
            part(Control29; "Item Warehouse FactBox")
            {
                Provider = Control25;
                SubPageLink = "No." = field("Item No."),
                              "Location Filter" = field("Location Code");
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Mark the Order as Give Away")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Mark Order as "Give Away"';
                ToolTip = 'Please mark if the order is a Give Away order.';
                Image = Apply;
                Visible = MarkGiveAwayVisible;

                trigger OnAction()
                begin
                    //>> 24-05-23 ZY-LD 001
                    if Confirm(Text001) then begin
                        Rec.UpdateGiveAwayOrder();
                        SetActions();
                    end;
                end;
            }
            action("Unmark the Order as Give Away")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unmark Order as "Give Away"';
                ToolTip = 'Undo marking the Order as Give away';
                Image = Apply;
                Visible = UnmarkGiveAwayVisible;

                trigger OnAction()
                begin
                    if Confirm(Text001) then begin
                        Rec.UpdateGiveAwayOrder();
                        SetActions();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions();
    end;

    trigger OnOpenPage()
    begin
        SetActions();
    end;

    var
        UserSetup: Record "User Setup"; //20-05-2025 BK #503059
        GiveAwayVisible: Boolean;
        MarkGiveAwayVisible: Boolean;
        UnmarkGiveAwayVisible: Boolean;
        ForceUser: Boolean; //20-05-2025 BK #503059
        Text001: Label 'Do you want to update "Give Away Order"?';

    local procedure SetActions()
    begin
        //>> 24-05-23 ZY-LD 001
        Rec.CalcFields(Rec."Amount Including VAT");
        GiveAwayVisible := Rec."Amount Including VAT" = 0;
        MarkGiveAwayVisible := (Rec."Amount Including VAT" = 0) and (not Rec."Give Away Order");
        UnmarkGiveAwayVisible := (Rec."Amount Including VAT" = 0) and Rec."Give Away Order";

        //20-05-2025 BK #503059
        ForceUser := False;
        IF UserSetup.get(UserId) then
            If UserSetup."Allow Force Validation" then
                ForceUser := true;

        //<< 24-05-23 ZY-LD 001
    end;
}
