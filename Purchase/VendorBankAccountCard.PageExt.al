pageextension 50016 "Vendor Bank Account Card" extends "Vendor Bank Account Card"
{
    layout
    {
        addafter("Bank Account No.")
        {
            field("Sort Code"; Rec."Sort Code")
            {
                ToolTip = 'Specifies the sort code. A sort code is a 6 digit number that identifies your bank. It is usually split up into pairs. The first two digits identify which bank it is and the last four digits refer to the specific branch of the bank, where you opened the account.';
            }
        }
    }
}
