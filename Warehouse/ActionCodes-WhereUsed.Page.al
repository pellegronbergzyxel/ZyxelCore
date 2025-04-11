Page 50257 "Action Codes - Where Used"
{
    Caption = 'Action Codes - Where Used';
    DataCaptionFields = "Action Code";
    Editable = false;
    PageType = List;
    SourceTable = "Default Action";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Action Description"; Rec."Action Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Header / Line"; Rec."Header / Line")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Comment Type"; Rec."Comment Type")
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
            action(Card)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Card';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Def. Action Code";
                RunPageLink = "Source Type" = field("Source Type"),
                              "Source Code" = field("Source Code"),
                              "Customer No." = field("Customer No.");
            }
            action("Customer Card")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer Card';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Customer Card";
                RunPageLink = "No." = field("Customer No.");
            }
        }
    }
}
