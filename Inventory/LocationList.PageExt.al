pageextension 50108 LocationListZX extends "Location List"
{
    layout
    {
        addafter(Name)
        {
            field("In Use"; Rec."In Use")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Include in Item Availability"; Rec."Include in Item Availability")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addfirst(factboxes)
        {
            part(SalesOrderTypeRelation; "Sales Order Type Rel. FactBox")
            {
                Caption = 'Sales Order Type';
                SubPageLink = "Location Code" = field(Code);
            }
        }
    }


    actions
    {
        addafter("&Location")
        {
            action("VAT Registration No. Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT Registration No. Setup';
                Image = VATPostingSetup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "VAT Reg. No. pr. Locations";
                RunPageLink = "Location Code" = field(Code);
            }
            action("Sales Order Type Relation")
            {
                ApplicationArea = Basic, Suite;
                Image = SocialSecurityLines;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Sales Order Type Relation";
                RunPageLink = "Location Code" = field(Code);
            }
            action("Transfer-&to Addresses")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Transfer-&to Addresses';
                Image = ShipAddress;
                RunObject = Page "Transfer-to Address List";
                RunPageLink = "Location Code" = field(Code);
            }
            action("Action Codes")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Action Codes';
                Image = "Action";

                trigger OnAction()
                var
                    DelDocMgt: Codeunit "Delivery Document Management";
                begin
                    DelDocMgt.EnterActionCode(Rec.Code, '', 4);
                end;
            }
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
                    RunPageLink = "Primary Key Field 1 Value" = field(Code);
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(14));
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        xxx: Page "Location List";
    begin
        Rec.SetRange("In Use", true);  // 11-06-19 ZY-LD 001
    end;
}
