Page 50077 "Picking Dates Cue"
{
    PageType = CardPart;
    SourceTable = "ZY Logistics Cue";

    layout
    {
        area(content)
        {
            cuegroup(Picking)
            {
                ShowCaption = false;
                field("Marked Picking Date"; Rec."Marked Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New/Marked Picking Date';
                    Image = Receipt;
                }
                field("Unconfirmed Picking Date"; Rec."Unconfirmed Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unconfirmed Picking Date';
                    Image = Receipt;
                }
                field("Confirmed Picking Date"; Rec."Confirmed Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Confirmed Picking Date';
                    Image = Receipt;
                }
            }
        }
    }
}