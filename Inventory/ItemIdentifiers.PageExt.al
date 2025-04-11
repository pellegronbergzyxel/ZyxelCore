pageextension 50283 ItemIdentifiersZX extends "Item Identifiers"
{
    layout
    {
        addafter(Code)
        {
            field(ExtendedCodeZX; Rec.ExtendedCodeZX)
            {
                ApplicationArea = Basic, Suite, ADCS;
                ToolTip = 'Specifies a unique extended code for a particular item -- used with eCommerce.';
            }
        }
    }

    trigger OnClosePage()
    begin
        //>> 31-03-20 ZY-LD 001
        if ChangeHasBeenMade then
            ZyWebSrvMgt.ReplicateItems('', Rec."Item No.", false, false);
        //<< 31-03-20 ZY-LD 001
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ChangeHasBeenMade := true;  // 31-03-20 ZY-LD 001
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ChangeHasBeenMade := true;  // 31-03-20 ZY-LD 001
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ChangeHasBeenMade := true;  // 31-03-20 ZY-LD 001
    end;

    var
        ChangeHasBeenMade: Boolean;
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
}
