page 50255 "eCommerce Location Code"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Location Code';
    PageType = List;
    SourceTable = "eCommerce Location Code";
    UsageCategory = Administration;
    AdditionalSearchTerms = 'ecommerce setup';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Ship-from Country Code"; Rec."Ship-from Country Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-from Post Code"; Rec."Ship-from Post Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
