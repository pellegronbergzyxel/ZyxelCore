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
        //25-09-2026 BK #596378
        addafter(IncomingDocAttachFactBox)
        {
            part(HQInvoices; "Posted HQ Invoice ListPart")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("External Document No.");
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
        addlast("Ent&ry")
        {
            action(FindApprovalEntries)
            {
                ApplicationArea = All;
                Caption = 'Find Approval Entries';
                Image = Approval;

                // 01-10-2026 BK 595844
                trigger OnAction()
                var
                    GLEvent: Codeunit "General Ledger Event";
                begin
                    GLEvent.FindPaymentApprovalEntres(Rec.RecordId.TableNo, Rec."Document No.", Rec."Entry No.", Rec.RecordId);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;
    end;
}
