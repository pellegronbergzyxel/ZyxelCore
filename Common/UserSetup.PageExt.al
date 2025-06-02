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
                ToolTip = 'Specifies Confirm hipment Date on SL';
            }
            field("Block Change of Line Discount"; Rec."Block Change of Line Discount")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Block Change of Line Discount';
            }
        }
        addafter("Register Time")
        {
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Spcifies E-Mail';
            }
            field("Head Quarter"; Rec."Head Quarter")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Head Quater';
            }
            field("Show Picking Date"; Rec."Show Picking Date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Show Picking Date';
            }
        }
        moveafter("User ID"; "Time Sheet Admin.")
        addlast(Control1)
        {
            field("Do Not Show Selected Fields"; Rec."Do Not Show Selected Fields")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies Do Not Show Selected Fields';
            }
            field("Use User E-mail on Documents"; Rec."Use User E-mail on Documents")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies Use User E-mail on Documents';
            }
            field("E-Mail Footer Name"; Rec."E-Mail Footer Name")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ToolTip = 'Specifies E-Mail Footer Name';
            }
            field("E-mail Footer Address"; Rec."E-mail Footer Address")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies E-mail Footer Address';
                Visible = false;
            }
            field("E-mail Footer Address 2"; Rec."E-mail Footer Address 2")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies E-mail Footer Address 2';
                Visible = false;
            }
            field("E-mail Footer Address 3"; Rec."E-mail Footer Address 3")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies E-Mail Footer Address 3';
                Visible = false;
            }
            field("E-mail Footer Phone No."; Rec."E-mail Footer Phone No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies E-Mail Footer Phone No.';
                Visible = false;
            }
            field("E-mail Footer Mobile Phone No."; Rec."E-mail Footer Mobile Phone No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies E-Mail Footer Mobile Phone No.';
                Visible = false;
            }
            field("E-mail Footer Skype"; Rec."E-mail Footer Skype")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies E-mail Footer Skype';
                Visible = false;
            }
            field("Sort Sales Order by Prim. Key"; Rec."Sort Sales Order by Prim. Key")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Sort Sales Order by Prim. Key';
                Visible = false;
            }
            field(MDM; Rec.MDM)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies MDM';
                Visible = false;
            }
            field(SCM; Rec.SCM)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies SCM';
                Visible = false;
            }
            field("Show Goods in Transit as"; Rec."Show Goods in Transit as")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Show Goods in Transit as';
                Visible = false;
            }
            field("EMail Signature"; Rec."EMail Signature")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Email Signature';
                Visible = false;
            }
            field("EICard User"; Rec."EICard User")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Eicard User';
                Visible = false;
            }
            field(AllInPurchaseOrders; Rec.AllInPurchaseOrders)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies All in Purchase Orders';
                Visible = false;
            }
            field(AllInSalesOrders; Rec.AllInSalesOrders)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies All in Sales Orders';
                Visible = false;
            }
            field("Can Block Items"; Rec."Can Block Items")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Can Block Items';
                Visible = false;
            }
            field(Department; Rec.Department)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Departments';
                Visible = false;
            }
            field("Show Customer Contracts"; Rec."Show Customer Contracts")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies Show Customer Contracts';
                Visible = false;
            }
            field("Allow Force Validation"; Rec."Allow Force Validation")
            {
                ApplicationArea = Basic, Suite; //05-05-2025 BK #485255
                ToolTip = 'Specifies Allow Froce Validation of eCommerse Orders';
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
                ToolTip = 'Show Card';
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
                ToolTip = 'Specifies changelog ';
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
