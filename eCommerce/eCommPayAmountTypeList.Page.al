page 50237 "eComm. Pay. Amount Type List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Pay. Amount Type List';
    PageType = List;
    SourceTable = "eCommerce Payment Amount Type";
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Payment Matrix")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment Matrix';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "eCommerce Pay. Matrix List";
                RunPageLink = "Amount Type" = field(Code);
            }
        }
    }
}
