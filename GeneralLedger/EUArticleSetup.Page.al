Page 50192 "EU Article Setup"
{
    Caption = 'EU Article Setup';
    PageType = List;
    SourceTable = "EU Article Setup";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("EU Article Code"; Rec."EU Article Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EU Article Description"; Rec."EU Article Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }
}
