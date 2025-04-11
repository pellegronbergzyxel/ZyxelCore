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
            }
        }
        addafter("G/L Account Name")
        {
            field("Return Reason Code"; Rec."Return Reason Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Global Dimension 2 Code")
        {
            field(Country; Rec.Country)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cost Type"; Rec."Cost Type")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Gen. Prod. Posting Group")
        {
            field("System-Created Entry"; Rec."System-Created Entry")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addlast(Control1)
        {
            field(Comment; Rec.Comment)  // 11-03-24 ZY-LD 001
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
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
        if not Rec.FindFirst() then;  // 09-01-18 ZY-LD 004
    end;
}
