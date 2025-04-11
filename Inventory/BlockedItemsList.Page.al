Page 62019 "Blocked Items List"
{
    PageType = List;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Blocked Reason';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        xRec.SetRange(xRec.Blocked, true);
    end;
}
