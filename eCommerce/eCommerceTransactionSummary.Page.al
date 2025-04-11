page 50262 "eCommerce Transaction Summary"
{
    Caption = 'eCommerce Transaction Summary';
    DeleteAllowed = false;
    Description = 'eCommerce Transaction Summary';
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "eCommerce Transaction Summary";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Summary"; Rec."Transaction Summary")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Fee Purchase Invoice No."; Rec."Fee Purchase Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Fee Purchase Invoice No.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
