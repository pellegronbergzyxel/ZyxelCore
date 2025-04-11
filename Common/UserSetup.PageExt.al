pageextension 50144 UserSetupZX extends "User Setup"
{
    layout
    {
        modify("Allow Posting To")
        {
            Visible = false;
        }
        modify("Sales Resp. Ctr. Filter")
        {
            Visible = false;
        }
        modify("Purchase Resp. Ctr. Filter")
        {
            Visible = false;
        }
        modify("Service Resp. Ctr. Filter")
        {
            Visible = false;
        }
        addafter("Allow Posting From")
        {
            field("Confirm Shipment Date on SL"; Rec."Confirm Shipment Date on SL")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Block Change of Line Discount"; Rec."Block Change of Line Discount")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Register Time")
        {
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Head Quarter"; Rec."Head Quarter")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Show Picking Date"; Rec."Show Picking Date")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        moveafter("User ID"; "Time Sheet Admin.")
        addlast(Control1)
        {
            field("Do Not Show Selected Fields"; Rec."Do Not Show Selected Fields")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Use User E-mail on Documents"; Rec."Use User E-mail on Documents")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("E-Mail Footer Name"; Rec."E-Mail Footer Name")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("E-mail Footer Address"; Rec."E-mail Footer Address")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("E-mail Footer Address 2"; Rec."E-mail Footer Address 2")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("E-mail Footer Address 3"; Rec."E-mail Footer Address 3")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("E-mail Footer Phone No."; Rec."E-mail Footer Phone No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("E-mail Footer Mobile Phone No."; Rec."E-mail Footer Mobile Phone No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("E-mail Footer Skype"; Rec."E-mail Footer Skype")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Sort Sales Order by Prim. Key"; Rec."Sort Sales Order by Prim. Key")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(MDM; Rec.MDM)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(SCM; Rec.SCM)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Show Goods in Transit as"; Rec."Show Goods in Transit as")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("EMail Signature"; Rec."EMail Signature")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("EICard User"; Rec."EICard User")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(AllInPurchaseOrders; Rec.AllInPurchaseOrders)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(AllInSalesOrders; Rec.AllInSalesOrders)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Can Block Items"; Rec."Can Block Items")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(Department; Rec.Department)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Show Customer Contracts"; Rec."Show Customer Contracts")
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
            action(Card)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Card';
                Image = UserSetup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "ZyXEL User Setup Card";
                RunPageLink = "User ID" = field("User ID");
            }
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Change Log Entries";
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(91));
            }
        }
    }
}
