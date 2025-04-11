pageextension 50180 PhysInventoryJournalZX extends "Phys. Inventory Journal"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part(Control9; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("Item No.");
            }
        }
    }

    actions
    {
        modify(Card)
        {
            ShortCutKey = 'Shift+Ctrl+e';
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("Ledger E&ntries")
        {
            Promoted = true;
        }
        addafter("Bin Contents")
        {
            action("Inventory pr. Date")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Inventory pr. Date';
                Image = DateRange;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //>> 16-01-19 ZY-LD 001
                    Clear(WhseInvDate);
                    WhseInvDate.InitPage(Rec."Item No.", Rec."Location Code");
                    WhseInvDate.RunModal;
                    //<< 16-01-19 ZY-LD 001
                end;
            }
        }
        addafter("Phys. In&ventory Ledger Entries")
        {
            action("Physical Whse. Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Physical Whse. Ledger Entries';
                Image = Warehouse;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Whse. Item Ledger Entry";
                RunPageLink = "Item No." = field("Item No."),
                              "Location Code" = field("Location Code"),
                              "Quanty Type" = const("On Hand");
                ShortCutKey = 'Shift+F7';
            }
        }
    }

    var
        WhseInvDate: Page "Warehouse Inventory Date";
}
