pageextension 50175 GeneralPostingSetupZX extends "General Posting Setup"
{
    actions
    {
        addfirst(navigation)
        {
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Change Log Entries";
                RunPageLink = "Primary Key Field 1 Value" = field("Gen. Bus. Posting Group"),
                              "Primary Key Field 2 Value" = field("Gen. Prod. Posting Group");
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(252));
            }
        }
    }
}
