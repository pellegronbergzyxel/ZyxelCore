pageextension 50234 SalespersonPurchaserCardZX extends "Salesperson/Purchaser Card"
{
    actions
    {
        addlast(History)
        {
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
                              where("Table No." = const(13));
            }
        }
    }
}