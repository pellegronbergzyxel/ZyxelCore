pageextension 50112 GeneralLedgerEntriesZX extends "General Ledger Entries"
{
    // 001. 11-03-24 ZY-LD 000 - Comment is added.
    layout
    {
        modify("Global Dimension 1 Code")
        {
            Caption = 'Division';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Department';
        }
        addafter("Document No.")
        {
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = Basic, Suite;
                tooltip = 'Specifies the date of the document that is associated with the entry.';
            }
        }
        addafter("G/L Account Name")
        {
            field("Return Reason Code"; Rec."Return Reason Code")
            {
                ApplicationArea = Basic, Suite;
                tooltip = 'Specifies the return reason code of the item that is associated with the entry.';
                Visible = false;
            }
        }
        /*addafter("Global Dimension 2 Code") //06-08-2026 BK Performance issue.
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = Basic, Suite;
                tooltip = 'Should be deleted'; //04-08-2026 BK Performance issue.
            }
        }
        {
            field(Country; Rec.Country)
            {
                ApplicationArea = Basic, Suite;
                tooltip = 'Should be deleted'; //04-08-2026 BK Performance issue.
            }
            field("Cost Type"; Rec."Cost Type")
            {
                ApplicationArea = Basic, Suite;
                tooltip = 'Should be deleted'; //04-08-2026 BK Performance issue.
            }
        } */
        addafter("Gen. Prod. Posting Group")
        {
            field("System-Created Entry"; Rec."System-Created Entry")
            {
                ApplicationArea = Basic, Suite;
                tooltip = 'Specifies whether the entry was created by the system.';
            }
        }
        addlast(Control1)
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                tooltip = 'Specifies the comment for the entry.';
            }

        }

    }
    actions
    {
        modify(ChangeDimensions)
        {
            Enabled = false;
            Visible = false;
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;
    end;
}
