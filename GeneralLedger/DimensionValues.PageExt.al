pageextension 50208 DimensionValuesZX extends "Dimension Values"
{
    layout
    {
        addafter("Consolidation Code")
        {
            field("Global Dimension No."; Rec."Global Dimension No.")
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
                RunPageLink = "Primary Key Field 1 Value" = field("Dimension Code"),
                              "Primary Key Field 2 Value" = field(Code);
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(349));
            }
        }
    }
}
