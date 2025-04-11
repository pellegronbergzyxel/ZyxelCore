page 50294 "eCommerce Pay. Matrix List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Pay. Matrix List';
    PageType = List;
    SourceTable = "eCommerce Pay. Matrix";
    UsageCategory = Administration;
    AdditionalSearchTerms = 'ecommerce setup';

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount Description"; Rec."Amount Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount Incl. VAT"; Rec."Amount Incl. VAT")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("No of Payments"; Rec."No of Payments")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "eCommerce Payment Journal";
                    Visible = false;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Document Type"; Rec."Sales Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Statement Type"; Rec."Payment Statement Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Statement Description"; Rec."Payment Statement Description")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
