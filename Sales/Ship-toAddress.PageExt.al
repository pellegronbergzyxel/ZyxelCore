pageextension 50169 ShipToAddressZX extends "Ship-to Address"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter(Contact)
        {
            field("Search Name"; Rec."Search Name")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Service Zone Code")
        {
            field("NCTS No."; Rec."NCTS No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(General)
        {
            group("Postal Codes")
            {
                Caption = 'Postal Codes';
                Label(Control19)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = TextLabel1;
                }
            }
        }
    }

    actions
    {
        addfirst(Navigation)
        {
            action("Action Codes")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Action Codes';
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    DelDocMgt.EnterActionCode(Rec.Code, Rec."Customer No.", 2);
                end;
            }
            action("Delivery Documents")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Documents';
                Image = Delivery;

                trigger OnAction()
                var
                    recDelDocHead: Record "VCK Delivery Document Header";
                begin
                    recDelDocHead.FilterGroup(0);
                    recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Open);
                    recDelDocHead.FilterGroup(2);
                    recDelDocHead.SetRange("Sell-to Customer No.", Rec."Customer No.");
                    recDelDocHead.SetRange("Ship-to Code", StrSubstNo('%1.%2', Rec."Customer No.", Rec.Code));
                    Page.RunModal(Page::"VCK Delivery Document List", recDelDocHead);
                end;
            }
        }
        addafter("&Address")
        {
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
                    RunPageLink = "Primary Key Field 1 Value" = field("Customer No."),
                                  "Primary Key Field 2 Value" = field(Code);
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(222));
                }
            }
        }
    }

    trigger OnClosePage()
    begin
        //>> 17-10-18 ZY-LD 002
        if ChangeHasBeenMade then
            ZyWebSrvMgt.ReplicateCustomers('', Rec."Customer No.", false);
        //<< 17-10-18 ZY-LD 002
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ChangeHasBeenMade := true;  // 17-10-18 ZY-LD 002
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ChangeHasBeenMade := true;  // 17-10-18 ZY-LD 002
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ChangeHasBeenMade := true;  // 17-10-18 ZY-LD 002
    end;

    var
        DeliveryDays: Integer;
        SuggestedZone: Text[30];
        TextLabel1: Label 'These are pre-defined post codes for the selected delivery zone. Please note that other post codes may be covered by this zone.';
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        ChangeHasBeenMade: Boolean;
        DelDocMgt: Codeunit "Delivery Document Management";
}
