page 50239 "eCommerce Order Card"
{
    // 001. 24-05-23 ZY-LD 000 - Give Away orders.
    // 002. 08-08-23 ZY-LD 000 - "Tax Address Role" is set to editable.

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
                field("Country Dimension"; Rec."Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
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
                    Editable = true;  // 08-08-23 ZY-LD 002
                }
                field("Tax Rate"; Rec."Tax Rate")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = Rec."Tax Rate" = 0;
                }
                field("Alt. Tax Rate"; Rec."Alt. Tax Rate")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                group(Control37)
                {
                    field("Buyer Tax Reg. Type"; Rec."Buyer Tax Reg. Type")
                    {
                        ApplicationArea = Basic, Suite;
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
                    field("Sales Document Type"; Rec."Sales Document Type")
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
                    field("Ship From City"; Rec."Ship From City")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship From State"; Rec."Ship From State")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship From Country"; Rec."Ship From Country")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                    }
                    field("Ship From Postal Code"; Rec."Ship From Postal Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship From Tax Location Code"; Rec."Ship From Tax Location Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Ship To")
                {
                    Caption = 'Ship-to';
                    Editable = false;
                    field("Ship To City"; Rec."Ship To City")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship To State"; Rec."Ship To State")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship To Country"; Rec."Ship To Country")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                    }
                    field("Ship To Postal Code"; Rec."Ship To Postal Code")
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
            group(Application)
            {
                Caption = 'Application';
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
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
            action("Mark the Order as ""Give Away""")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Mark Order as "Give Away"';
                Image = Apply;
                Visible = MarkGiveAwayVisible;

                trigger OnAction()
                begin
                    //>> 24-05-23 ZY-LD 001
                    if Confirm(Text001) then begin
                        Rec.UpdateGiveAwayOrder;
                        SetActions;
                    end;
                    //<< 24-05-23 ZY-LD 001
                end;
            }
            action("Unmark the Order as ""Give Away""")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unmark Order as "Give Away"';
                Image = Apply;
                Visible = UnmarkGiveAwayVisible;

                trigger OnAction()
                begin
                    //>> 24-05-23 ZY-LD 001
                    if Confirm(Text001) then begin
                        Rec.UpdateGiveAwayOrder;
                        SetActions;
                    end;
                    //<< 24-05-23 ZY-LD 001
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
        Text001: Label 'Do you want to update "Give Away Order"?';
        GiveAwayVisible: Boolean;
        MarkGiveAwayVisible: Boolean;
        UnmarkGiveAwayVisible: Boolean;

    local procedure SetActions()
    begin
        //>> 24-05-23 ZY-LD 001
        Rec.CalcFields(Rec."Amount Including VAT");
        GiveAwayVisible := Rec."Amount Including VAT" = 0;
        MarkGiveAwayVisible := (Rec."Amount Including VAT" = 0) and (not Rec."Give Away Order");
        UnmarkGiveAwayVisible := (Rec."Amount Including VAT" = 0) and Rec."Give Away Order";
        //<< 24-05-23 ZY-LD 001
    end;
}
