Page 66004 "Added Info Table"
{
    PageType = List;
    SourceTable = "Ship Response Header";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order No."; Rec."Order No.")
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
