Page 50312 "VAT Reg. No. pr. Country List"
{
    // 001. 01-10-18 ZY-LD 2018100110000338 - Created.

    Caption = 'VAT Registration No. pr. Country List';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = "Country/Region";

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
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EORI No."; Rec."EORI No.")
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
