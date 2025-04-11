pageextension 50111 GLAccountListZX extends "G/L Account List"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        addafter("&Balance")
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field("No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(15));
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Blocked, false);
    end;
}
