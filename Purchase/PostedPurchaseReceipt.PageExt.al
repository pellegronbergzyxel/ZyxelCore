pageextension 50152 PostedPurchaseReceiptZX extends "Posted Purchase Receipt"
{
    layout
    {
        moveafter("No. Printed"; "Order No.")
        addafter("Order No.")
        {
            field("Warehouse Inbound No."; Rec."Warehouse Inbound No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addfirst(FactBoxes)
        {
            part(Control5; "Item Warehouse FactBox")
            {
                Provider = PurchReceiptLines;
                SubPageLink = "No." = field("No."),
                              "Location Filter" = field("Location Code");
                Visible = true;
            }
        }
        moveafter("No. Printed"; "Order No.")
    }

    actions
    {
        addafter("&Receipt")
        {
            action("Purchase Order Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Order Response';
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowWarehouseResponse();  // 25-09-20 ZY-LD 002
                end;
            }
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
                        if confirm('Do want to chekc and correct qty<>qty (base) for this PPR and posted ledgers') then begin
                            tempcorrection.CorrectPurchrcptHeader(rec);
                            CurrPage.Update(false);
                        end
                    end;
                }

            }
        }
    }

    local procedure ShowWarehouseResponse()
    var
        recRcptRespHead: Record "Rcpt. Response Header";
    begin
        //>> 25-09-20 ZY-LD 002
        recRcptRespHead.SetFilter("Customer Reference", '%1|%2', Rec."Order No.", Rec."Warehouse Inbound No.");
        Page.Run(Page::"Rcpt. Response List", recRcptRespHead);
        //<< 25-09-20 ZY-LD 002
    end;
}
