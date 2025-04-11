pageextension 50122 ItemLedgerEntriesZX extends "Item Ledger Entries"
{
    layout
    {
        addafter("Source Type")
        {
            field("Source Description"; Rec."Source Description")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Source Description';
                Visible = false;
            }
        }
        addafter("Cost Amount (Non-Invtbl.)(ACY)")
        {
            field("Cost Posted to G/L"; Rec."Cost Posted to G/L")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Job Task No.")
        {
            field("Country/Region Code"; Rec."Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Buy-from/Ship-to Country Code';
                Visible = false;
            }
            field("Last Applying Date"; Rec."Last Applying Date")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(ExistInEiCardQueue; ExistInEiCardQue)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        addafter("&Application")
        {
            group(Documents)
            {
                Caption = 'Documents';
                action("Delivery Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delivery Document';
                    Image = Document;

                    trigger OnAction()
                    begin
                        ShowDeliveryDocument;  // 27-01-20 ZY-LD 006
                    end;
                }
            }
        }
        addafter("&Navigate")
        {
            action("Filter on Order No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Filter on Order No.';
                Image = Filter;

                trigger OnAction()
                begin
                    //>> 23-01-20 ZY-LD 005
                    Rec.SetRange(Rec."Order Type", Rec."Order Type");
                    Rec.SetRange(Rec."Order No.", Rec."Order No.");
                    //<< 23-01-20 ZY-LD 005
                end;
            }
            action(UpdateEntry)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Entry';
                Image = UpdateDescription;
                RunObject = Page "Update Item Ledger Entry";
                RunPageLink = "Entry No." = field("Entry No.");
            }
        }
        addlast("F&unctions")
        {
            group(Correction)
            {
                Caption = 'Correction';
                action(QTYError)
                {
                    Caption = 'QTY Base error correction';
                    ApplicationArea = all;
                    Image = Warning;
                    trigger OnAction()
                    var
                        tempcorrection: codeunit TempCorrection;
                    begin
                        if confirm('Do want to check and correct qty<>qty (base) for this PI and posted ledgers') then begin
                            tempcorrection.correctionItemledgerqty(rec);
                            CurrPage.Update(false);
                        end
                    end;
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Location Code", '<>PP');
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 02-11-17 ZY-LD 001
    end;

    trigger OnAfterGetRecord()
    var
        recCust: Record Customer;
        recVend: Record Vendor;
        recItem: Record Item;

    begin
        //>> 31-10-19 ZY-LD 003
        /*SourceDescription := '';
        case Rec."Source Type" of
            Rec."Source Type"::Customer:
                if recCust.Get(Rec."Source No.") then
                    SourceDescription := recCust.Name;
            Rec."Source Type"::Vendor:
                if recVend.Get(Rec."Source No.") then
                    SourceDescription := recVend.Name;
            Rec."Source Type"::Item:
                if recitem.Get(Rec."Source No.") then
                    SourceDescription := recItem.Description;
        end;*/
        //<< 31-10-19 ZY-LD 003

        ExistInEiCardQue := ExistInEicardQueue;
    end;

    var
        //SourceDescription: Text[50];
        ExistInEiCardQue: Boolean;

    local procedure ExistInEicardQueue(): Boolean
    var
        recSalesShipLine: Record "Sales Shipment Line";
        recEiCardQueue: Record "EiCard Queue";
    begin
        if (Rec."Entry Type" = Rec."entry type"::Sale) and
           (Rec."Document Type" = Rec."document type"::"Sales Shipment")
        then begin
            recSalesShipLine.SetRange("Document No.", Rec."Document No.");
            recSalesShipLine.SetRange("No.", Rec."Item No.");
            if recSalesShipLine.FindFirst() then
                exit(recEiCardQueue.Get(recSalesShipLine."Order No."));
        end;
    end;

    local procedure ShowDeliveryDocument()
    var
        recSaleShipLine: Record "Sales Shipment Line";
        recDelDocHead: Record "VCK Delivery Document Header";
    begin
        //>> 27-01-20 ZY-LD 006
        if Rec."Document Type" = Rec."document type"::"Sales Shipment" then begin
            recSaleShipLine.SetRange("Document No.", Rec."Document No.");
            recSaleShipLine.SetRange("No.", Rec."Item No.");
            if recSaleShipLine.FindFirst() then
                if recDelDocHead.Get(recSaleShipLine."Picking List No.") then
                    Page.RunModal(Page::"VCK Delivery Document", recDelDocHead);
        end;
        //<< 27-01-20 ZY-LD 006
    end;
}
