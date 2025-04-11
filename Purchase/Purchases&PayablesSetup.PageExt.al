pageextension 50186 PurchasesPayablesSetupZX extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Default Accounts")
        {
            group(Zyxel)
            {
                group(EiCards)
                {
                    field("EiCard HQ Invoice Folder"; Rec."EiCard HQ Invoice Folder")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EiCard Vendor No."; Rec."EiCard Vendor No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EiCard Vendor No. CH"; Rec."EiCard Vendor No. CH")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EiCard Lead Time"; Rec."EiCard Lead Time")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EiCard PO Lead Time"; Rec."EiCard PO Lead Time")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EiCar Default Transport Method"; Rec."EiCar Default Transport Method")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(EShop)
                {
                    field("Send Orders To EShop"; Rec."Send Orders To EShop")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EShop Vendor No."; Rec."EShop Vendor No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("SBU Filter SP"; Rec."SBU Filter SP")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EShop Vendor No. CH"; Rec."EShop Vendor No. CH")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("SBU Filter CH"; Rec."SBU Filter CH")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("EShop Default Transport Method"; Rec."EShop Default Transport Method")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Purchase Prices")
                {
                    Caption = 'Purchase Prices';
                    field("Block Last Direct Cost"; Rec."Block Last Direct Cost")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(NLtoDK)
                {
                    Caption = 'NL to DK VAT Posting';
                    field("NL to DK Vendor No."; Rec."NL to DK Vendor No.")
                    {
                        ToolTip = 'Specifies which vendor account the invoice should be posted on.';
                    }
                    field("NL to DK Debit Account No."; Rec."NL to DK Debit Account No.")
                    {
                        ToolTip = 'Specifies the debit account no.';
                    }
                    field("NL to DK Credit Account No."; Rec."NL to DK Credit Account No.")
                    {
                        ToolTip = 'Specifies the credit account no.';
                    }
                    field("NL to DK VAT Prod. Post. Grp."; Rec."NL to DK VAT Prod. Post. Grp.")
                    {
                        ToolTip = 'Specifies the "VAT Prod. Posting Group" the reverse line will be posted with.';
                    }
                }
                group(other)
                {
                    Caption = 'Other';
                    field(AllowLocationchange; Rec.AllowLocationchange)
                    {

                    }
                }

            }
        }
    }
}
