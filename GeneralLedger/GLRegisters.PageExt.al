pageextension 50142 GLRegistersZX extends "G/L Registers"
{
    Caption = 'G/L Registers';
    actions
    {
        modify("&Register")
        {
            Caption = '&Register';
        }
        modify("General Ledger")
        {
            Caption = 'General Ledger';
        }
        modify("Customer &Ledger")
        {
            Caption = 'Customer &Ledger';
        }
        modify("Ven&dor Ledger")
        {
            Caption = 'Ven&dor Ledger';
        }
        modify("Bank Account Ledger")
        {
            Caption = 'Bank Account Ledger';
        }
        modify("Fixed &Asset Ledger")
        {
            Caption = 'Fixed &Asset Ledger';
        }
        modify("Maintenance Ledger")
        {
            Caption = 'Maintenance Ledger';
        }
        modify("VAT Entries")
        {
            Caption = 'VAT Entries';
        }
        modify("Item Ledger Relation")
        {
            Caption = 'Item Ledger Relation';
        }
        modify("F&unctions")
        {
            Caption = 'F&unctions';
        }
        modify(ReverseRegister)
        {
            Caption = 'Reverse Register';
        }
        modify("Detail Trial Balance")
        {
            Caption = 'Detail Trial Balance';
        }
        modify("Trial Balance")
        {
            Caption = 'Trial Balance';
        }
        modify("Trial Balance by Period")
        {
            Caption = 'Trial Balance by Period';
        }
        modify("G/L Register")
        {
            Caption = 'G/L Register';
        }
        addafter(ReverseRegister)
        {
            action("Reverse Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reverse Entries';
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ReverseEntries;  // 07-02-18 ZY-LD 001
                end;
            }
        }
    }

    local procedure ReverseEntries()
    var
        recGLRegister: Record "G/L Register";
    begin
        //>> 07-02-18 ZY-LD 001
        recGLRegister.SetRange("No.", Rec."No.");
        Report.RunModal(Report::"Reverse G/L Register", true, false, recGLRegister);
        //<< 07-02-18 ZY-LD 001
    end;
}
