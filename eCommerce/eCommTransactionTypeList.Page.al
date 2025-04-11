page 50220 "eComm. Transaction Type List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Transaction Type List';
    PageType = List;
    SourceTable = "eCommerce Transaction Type";
    UsageCategory = Administration;
    AdditionalSearchTerms = 'ecommerce setup';

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Document Type"; Rec."Sales Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
