page 50245 "eComm. Pay Amount Desc. List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Amz. Pay Amount Descript. List';
    PageType = List;
    SourceTable = "eComm. Pay. Amount Descript.";
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
                RunPageLink = "Amount Description" = field(Code);
            }
        }
    }
}
