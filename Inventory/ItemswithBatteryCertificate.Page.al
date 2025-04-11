Page 50344 "Items with Battery Certificate"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Items with Battery Certificate';
    Editable = false;
    PageType = List;
    SourceTable = Item;
    SourceTableView = where("Battery Certificate" = const(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Category 1 Code"; Rec."Category 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Category 2 Code"; Rec."Category 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Category 3 Code"; Rec."Category 3 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Category 4 Code"; Rec."Category 4 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Business Center"; Rec."Business Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(SBU; Rec.SBU)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            part(Control12; "Battery Certificate FactBoc")
            {
                Caption = 'Battery Certificate Details';
                SubPageLink = "Item No." = field("No.");
            }
        }
    }

    actions
    {
    }
}
