pageextension 50170 ShipToAddressListZX extends "Ship-to Address List"
{
    layout
    {
        modify("Location Code")
        {
            ShowMandatory = true;
        }
        addfirst(Control1)
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Contact)
        {
            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Used Date"; Rec."Last Used Date")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Action Code"; Rec."Action Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        moveafter("Code"; "Location Code")
    }

    actions
    {
        addfirst(Navigation)
        {
            action("Delivery Documents")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Documents';
                Image = Delivery;

                trigger OnAction()
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
            group("Delivery Zone")
            {
                Caption = 'Delivery Zone';
                action("Action Codes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Action Codes';
                    Image = "Action";
                    RunObject = Page "Default Action Code";
                    RunPageLink = "Source Type" = const("Ship-to Address"),
                                  "Customer No." = field("Customer No."),
                                  "Source Code" = field(Code);
                    Visible = false;
                }
                action(Action9)
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
                    RunPageLink = "Primary Key Field 1 Value" = field("Customer No."),
                                  "Primary Key Field 2 Value" = field(Code);
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(222));
                }
            }
        }
    }

    var
        recDelDocHead: Record "VCK Delivery Document Header";
        DelDocMgt: Codeunit "Delivery Document Management";
}
