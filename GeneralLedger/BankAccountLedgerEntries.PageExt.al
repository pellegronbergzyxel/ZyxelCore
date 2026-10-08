pageextension 50317 BankAccountLedgerEntriesZX extends "Bank Account Ledger Entries"
{
    actions
    {
        addlast("Ent&ry")
        {
            action(FindApprovalEntries)
            {
                ApplicationArea = All;
                Caption = 'Find Approval Entries';
                Image = Approval;

                // 01-10-2026 BK #595844
                trigger OnAction()
                var
                    GLEvent: Codeunit "General Ledger Event";
                begin
                    GLEvent.FindPaymentApprovalEntres(Rec.RecordId.TableNo, Rec."Document No.", Rec."Entry No.", Rec.RecordId);
                end;
            }
        }
    }
}