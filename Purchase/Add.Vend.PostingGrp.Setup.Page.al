Page 50221 "Add. Vend. Posting Grp. Setup"
{
    Caption = 'Additional Vend. Posting Grp. Setup';
    DataCaptionFields = "Ship-to Country/Region Code", "Location Code", "Customer No.";
    PageType = List;
    SourceTable = "Add. Vend. Posting Grp. Setup";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'If the "Vendor No." is left blank, that line will work for all vendors that haven´t been created in a specific line.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'If the "Location Code" is left blank, that will line will work for all locations that haven´t been created in a specific line.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the line will work for a specific customer no. It will only word if the "Sell-to Customer No." is mentioned on the purchase header.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = '"Gen. Bus. Posting Group" needs only to be filled if the value is different from the vendor card. If the field is left blank, the value from the vendor card will be used.';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = '"VAT Bus. Posting Group" needs only to be filled if the value is different from the vendor card. If the field is left blank, the value from the vendor card will be used.';
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = '"Vendor Posting Group" needs only to be filled if the value is different from the vendor card. If the field is left blank, the value from the vendor card will be used.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = '"VAT Prod. Posting Group" needs only to be filled if the value is different from the vendor card. If the field is left blank, the value from the vendor card will be used.';
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(processing)
        {
            action("Copy from Main Company")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy from Main Company';
                Image = Copy;
            }
        }
    }
}
