pageextension 50172 IntrastatReportSubformZX extends "Intrastat Report Subform"
{
    layout
    {
        addafter(Date)
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = Basic, Suite;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        modify("Country/Region Code")
        {
            Caption = 'Buy-from/Ship-to Country Code';
            ToolTip = 'Receipt = "Buy-from Country/Region", Shipment = "Ship-to Country/Region Code"';
        }
        addafter("Country/Region Code")
        {
            field("Opposite Country/Region Code"; Rec."Opposite Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Receipt = "Ship-to Country/Region", Shipment = "Buy-from Country/Region Code"';
            }
            field("Item Entry Ship-To Co/Reg Code"; Rec."Item Entry Ship-To Co/Reg Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Internal Ref. No.")
        {
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action("Posted Sales Shipment")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted Sales Shipment';
                Image = PostedShipment;
                RunObject = Page "Posted Sales Shipment";
                RunPageLink = "No." = field("Document No.");
            }

            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Find entries';
                Image = Navigate;
                ShortcutKey = 'ctrl+alt+q';
                ToolTip = 'Find entries and documents that exist for the document number and posting date on a selected document.';

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    //>> 05-04-18 ZY-LD 001
                    Navigate.SetDoc(Rec.Date, Rec."Document No.");
                    Navigate.Run;
                    //<< 05-04-18 ZY-LD 001
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        UpdateTariffs(); //15-51643
    end;

    var
        Navigate: Page Navigate;

    procedure UpdateTariffs()
    var
        recItem: Record Item;
        recTariffNo: Record "Tariff Number";
    begin
        if recItem.FindFirst() then begin
            repeat
                recTariffNo.SetFilter("No.", recItem."Tariff No.");
                if not recTariffNo.FindFirst() then begin
                    recTariffNo.Init();
                    recTariffNo."No." := recItem."Tariff No.";
                    recTariffNo.Description := recItem.Description;
                    recTariffNo.Insert();

                end;
            until recItem.Next() = 0;
        end;
    end;
}
