pageextension 50255 PostedTransferReceiptsZX extends "Posted Transfer Receipts"
{
    layout
    {
        addafter("Receipt Date")
        {
            field("Transfer Order No."; Rec."Transfer Order No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Serial Numbers Status"; Rec."Serial Numbers Status")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Serial No. Attached"; Rec."Serial No. Attached")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        addafter("&Receipt")
        {
            action("Show Serial No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Serial No.';
                Image = SerialNo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowSerialNo();  // 23-04-19 ZY-LD 006
                end;
            }
        }
        addafter("&Navigate")
        {
            action("Set to Attached")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set to Attached';

                trigger OnAction()
                begin
                    Rec."Serial Numbers Status" := Rec."serial numbers status"::Attached;
                    Rec.Modify();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 27-10-17 ZY-LD 001
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";

    local procedure ShowSerialNo()
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        recSerialNo: Record "VCK Delivery Document SNos";
        recSerialNoTmp: Record "VCK Delivery Document SNos" temporary;
    begin
        //>> 03-05-19 ZY-LD 002
        recDelDocLine.SetRange("Transfer Order No.", Rec."Transfer Order No.");
        if recDelDocLine.FindSet() then begin
            recSerialNo.SetCurrentkey("Delivery Document No.", "Delivery Document Line No.");
            ZGT.OpenProgressWindow('', recDelDocLine.Count());
            repeat
                ZGT.UpdateProgressWindow(recDelDocLine."Document No.", 0, true);

                recSerialNo.SetRange("Delivery Document No.", recDelDocLine."Document No.");
                recSerialNo.SetRange("Delivery Document Line No.", recDelDocLine."Line No.");
                if recSerialNo.FindSet() then
                    repeat
                        recSerialNoTmp := recSerialNo;
                        recSerialNoTmp.Insert();
                    until recSerialNo.Next() = 0;
            until recDelDocLine.Next() = 0;

            ZGT.CloseProgressWindow;
        end;

        if not recSerialNoTmp.IsEmpty() then
            Page.RunModal(Page::"VCK Delivery Document SNos", recSerialNoTmp);
        //<< 03-05-19 ZY-LD 002
    end;
}
