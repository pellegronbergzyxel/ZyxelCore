pageextension 50123 PstdSalesCrMemoUpdate extends "Pstd. Sales Cr. Memo - Update"
{
    layout
    {
        addafter(Payment)
        {
            group("Zyxel")
            {
                Caption = 'Zyxel';
                group(GeneralZX)
                {
                    Caption = 'General';
                    field("Document Date"; Rec."Document Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = DocumentDateEditable;
                        ToolTip = 'If the "Default VAT Date" is calculated based on the "Document Date" you are not allowed to change the date here.';
                    }
                }
                group(PaymentZX)
                {
                    Caption = 'Payment';
                    field("Payment Method Code"; Rec."Payment Method Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Visible = PaymentMethodCodeVisible;
                    }
                }
                group(NLtoDK)
                {
                    Caption = 'NL to DK Reverse Charge';
                    field("NL to DK Rev. Charge Posted"; Rec."NL to DK Rev. Charge Posted")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("NL to DK Reverse Chg. Doc No."; Rec."NL to DK Reverse Chg. Doc No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                Group(BillToZX)
                {
                    Caption = 'Bill-to';
                    field("Bill-to Name";
                    Rec."Bill-to Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Bill-to Name 2"; Rec."Bill-to Name 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Bill-to Address"; Rec."Bill-to Address")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Bill-to Address 2"; Rec."Bill-to Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Bill-to Post Code"; Rec."Bill-to Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Bill-to City"; Rec."Bill-to City")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Bill-to County"; Rec."Bill-to County")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        GenLedgSetup: Record "General Ledger Setup";
    begin
        UserSetup.Get(UserId);
        PaymentMethodCodeVisible := UserSetup."User Type" = UserSetup."User Type"::"Accounting Manager";

        GenLedgSetup.get;
        DocumentDateEditable := GenLedgSetup."VAT Reporting Date" = GenLedgSetup."VAT Reporting Date"::"Posting Date";
    end;

    var
        PaymentMethodCodeVisible: Boolean;
        DocumentDateEditable: Boolean;
        xx: Page "Pstd. Sales Cr. Memo - Update";
        yyy: Codeunit "Sales Credit Memo Hdr. - Edit";
}