page 50317 "eComm. Pay. Detail FactBox"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "eCommerce Payment";
    SourceTableView = sorting("New Transaction Type", "Amount Type", "Amount Description");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("New Transaction Type"; Rec."New Transaction Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount Posting Type"; Rec."Amount Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Amount Description"; Rec."Amount Description")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Open Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Journal';
                Image = Journal;
                RunObject = Page "eComm. Payment Journal Batches";
                RunPageLink = "No." = field("Journal Batch No.");
            }
        }
    }
}
