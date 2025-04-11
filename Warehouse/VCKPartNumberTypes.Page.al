Page 50128 "VCK Part Number Types"
{
    PageType = List;
    SourceTable = "VCK Part Number Types";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("CODE"; Rec.CODE)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
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
