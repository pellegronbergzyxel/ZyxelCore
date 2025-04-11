pageextension 50294 MyCustomersZX extends "My Customers"
{
    layout
    {
        addafter("Phone No.")
        {
            field(OverDueBalance; OverDueBalance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Over Due Balance';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Cust: Record Customer;
    begin
        OverDueBalance := 0;  // 20-11-20 ZY-LD 001
        if Cust.Get(Rec."Customer No.") then begin
            Cust.CalcFields(Balance);
            OverDueBalance := Cust.CalcOverdueBalance;  // 20-11-20 ZY-LD 001
        end;
    end;

    var
        OverDueBalance: Decimal;
}
