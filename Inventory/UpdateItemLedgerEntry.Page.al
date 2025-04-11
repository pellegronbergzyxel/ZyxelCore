page 50108 "Update Item Ledger Entry"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    ApplicationArea = Basic, Suite;
    Caption = 'Update Item Ledger Entry';
    PageType = Card;
    SourceTable = "Item Ledger Entry";
    Permissions = tabledata "Item Ledger Entry" = m;
    ShowFilter = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                }
                field("Original No."; Rec."Original No.")
                {
                    Editable = OriginalNoEditable;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ICSetup.get;
        SetActions();
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();
    end;

    local procedure SetActions()
    var
    begin
        OriginalNoEditable := (Rec."Item No." = ICSetup."Sample Item") and (ICSetup."Sample Item" <> '');
    end;

    var
        ICSetup: Record "IC Setup";
        OriginalNoEditable: Boolean;
}
