pageextension 50245 ItemReferencesZX extends "Item References"
{
    layout
    {
        modify("Variant Code")
        {
            Visible = false;
        }
        addafter(Description)
        {
            field("Add EAN Code to Delivery Note"; Rec."Add EAN Code to Delivery Note")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cross-Reference EAN Code"; Rec."Cross-Reference EAN Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    trigger OnClosePage()
    begin
        if ChangeHasBeenMade then
            if Rec."Reference Type" = Rec."Reference Type"::Customer then
                ZyWebSrvMgt.ReplicateCustomers('', Rec."Reference Type No.", false);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ChangeHasBeenMade := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ChangeHasBeenMade := true;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ChangeHasBeenMade := true;
    end;

    var
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        ChangeHasBeenMade: Boolean;
}
