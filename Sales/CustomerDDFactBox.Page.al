Page 50291 "Customer / DD FactBox"
{
    // 001. 16-03-21 ZY-LD 2021031610000121 - ZNet is not using this anymore.

    Caption = 'Customer / DD FactBox';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Name; Rec.Name)
            {
                ApplicationArea = Basic, Suite;
            }
            field(CalcOverdueBalanceSubFld; CalcOverdueBalanceSub)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Overdue Balance';
                Visible = false;
            }
            field(CalcOpenPaymentsSubFld; CalcOpenPaymentsSub)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Payments';
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        SI.SetHideSalesDialog(false);
    end;

    trigger OnOpenPage()
    begin
        SI.SetHideSalesDialog(true);
    end;

    var
        SI: Codeunit "Single Instance";


    procedure CalcOverdueBalanceSub() OverDueBalance: Decimal
    var
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
    begin
        //OverDueBalance := ZyWebServMgt.GetCustomerOverdueBalance("No.",WORKDATE,FALSE);  // 16-03-21 ZY-LD 001
    end;


    procedure CalcOpenPaymentsSub() OverDueBalance: Decimal
    var
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
    begin
        //OverDueBalance := ZyWebServMgt.GetCustomerOverdueBalance("No.",WORKDATE,TRUE);  // 16-03-21 ZY-LD 001
    end;
}
