pageextension 50173 GenBusinessPostingGroupsZX extends "Gen. Business Posting Groups"
{
    layout
    {
        addafter("Auto Insert Default")
        {
            field("Sample / Test Equipment"; Rec."Sample / Test Equipment")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sample G/L Account No."; Rec."Sample G/L Account No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        addfirst(navigation)
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
            }
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Change Log Entries";
                RunPageLink = "Primary Key Field 1 Value" = field(Code);
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(250));
            }
        }
    }
}
