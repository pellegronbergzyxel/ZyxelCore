Page 50252 "Convert Characters"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Convert Characters';
    PageType = List;
    SourceTable = "Convert Characters";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("From Character"; Rec."From Character")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("To Charracter"; Rec."To Charracter")
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
