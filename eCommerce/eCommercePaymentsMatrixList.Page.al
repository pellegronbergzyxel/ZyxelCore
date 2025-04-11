page 50261 "eCommerce Payments Matrix List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Payments Matrix';
    Description = 'eCommerce Payments Matrix';
    PageType = List;
    SourceTable = "eCommerce Payment Matrix";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Detail"; Rec."Payment Detail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
