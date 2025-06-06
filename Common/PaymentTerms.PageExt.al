pageextension 50102 PaymentTermsZX extends "Payment Terms"
{
    layout
    {
        addafter(Description)
        {
            field("Concur Vendor"; Rec."Concur Vendor")
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
                              where("Table No." = const(3));
            }
        }
    }
}
