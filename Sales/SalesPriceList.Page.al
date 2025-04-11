Page 50244 "Sales Price List ZX"
{
    // 001. 23-04-24 ZY-LD 000 - Harry is using this.

    ApplicationArea = Basic, Suite;
    Caption = 'Sales Price List - Zyxel';
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    Description = 'Sales Price List';
    PageType = List;
    SourceTable = "Price List Line";
    SourceTableView = where("Asset Type" = filter("Price Source Type"::"All Customers" | "Price Source Type"::Customer | "Price Source Type"::"Customer Price Group"), "Price Type" = const(Sale));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Price List Code"; Rec."Price List Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sales Code"; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Asset Type"; Rec."Asset Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(OpenPriceList)
            {
                ApplicationArea = All;
                Caption = 'Open Price List';
                Image = EditLines;
                //Visible = LineExists;
                ToolTip = 'View or edit the price list.';

                trigger OnAction()
                var
                    PriceUXManagement: Codeunit "Price UX Management";
                begin
                    PriceUXManagement.EditPriceList(Rec."Price List Code");
                end;
            }
        }
    }
}