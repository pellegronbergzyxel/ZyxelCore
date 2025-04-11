pageextension 50190 VATPostingSetupZX extends "VAT Posting Setup"
{
    layout
    {
        addafter("Tax Category")
        {
            field("EU Article Code"; Rec."EU Article Code")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Visible = false;
            }
            field(Control9; Rec."EU Article")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        addfirst(navigation)
        {
            action("EU Article")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EU Article';
                Image = Migration;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "EU Article Setup";
                RunPageLink = "VAT Bus. Posting Group" = field("VAT Bus. Posting Group"),
                              "VAT Prod. Posting Group" = field("VAT Prod. Posting Group");
            }
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Change Log Entries";
                RunPageLink = "Primary Key Field 1 Value" = field("VAT Bus. Posting Group"),
                              "Primary Key Field 2 Value" = field("VAT Prod. Posting Group");
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(325));
            }
        }
    }
}
