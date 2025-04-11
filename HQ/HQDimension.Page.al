Page 50270 "HQ Dimension"
{
    ApplicationArea = Basic, Suite;
    Caption = 'HQ Dimension';
    DataCaptionFields = Type, "Code", Description;
    PageType = List;
    SourceTable = SBU;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Business to"; Rec."Business to")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
