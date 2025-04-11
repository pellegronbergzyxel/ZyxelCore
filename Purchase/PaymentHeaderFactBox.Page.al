Page 50316 "Payment Header FactBox"
{
    PageType = CardPart;
    SourceTable = "eCommerce Payment Header";

    layout
    {
        area(content)
        {
            field(Period; Rec.Period)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field(GetDashboardTotal; Rec.GetDashboardTotal)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Total';
                Style = Strong;
                StyleExpr = true;
            }
            group("Beginning Balance")
            {
                Caption = 'Beginning Balance';
                field("Cash Beginning Balance"; Rec."Cash Beginning Balance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Beginning Balance';
                    DrillDownPageID = "eCommerce Payment Journal";
                    Style = Strong;
                    StyleExpr = true;
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                field("Sales Product Charge"; Rec."Sales Product Charge")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Product Charge';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Sales Tax"; Rec."Sales Tax")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Tax';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Sales Shipping"; Rec."Sales Shipping")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Shipping';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Sales Other"; Rec."Sales Other")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Other';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field(GetSalesTotal; Rec.GetSalesTotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total';
                    Style = Strong;
                    StyleExpr = true;
                }
            }
            group(Refunds)
            {
                Caption = 'Refunds';
                field("Refund Refunded Expenses"; Rec."Refund Refunded Expenses")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expenses';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Refund Refunded Sales"; Rec."Refund Refunded Sales")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field(GetRefundTotal; Rec.GetRefundTotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total';
                    Style = Strong;
                    StyleExpr = true;
                }
            }
            group(Expenses)
            {
                Caption = 'Expenses';
                field("Expense Promo Rebates"; Rec."Expense Promo Rebates")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Promo Rebates';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Expense FBA Fee"; Rec."Expense FBA Fee")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'FBA Fee';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Expense Cost of Advertising"; Rec."Expense Cost of Advertising")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cost of Advertising';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Expense eCommerce Fee"; Rec."Expense eCommerce Fee")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'eCommerce Fee';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Expense Other"; Rec."Expense Other")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Other';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field(GetExpenseTotal; Rec.GetExpenseTotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total';
                    Style = Strong;
                    StyleExpr = true;
                }
            }
            group("Account Level Reserve")
            {
                Caption = 'Account Level Reserve';
                field("Cash Account Level Reserve"; Rec."Cash Account Level Reserve")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Level Reserve';
                    DrillDownPageID = "eCommerce Payment Journal";
                    Style = Strong;
                    StyleExpr = true;
                }
            }
            group("Not Inplaced")
            {
                Caption = 'Not Inplaced';
                Visible = NotInPlacedVisible;
                field("Not Inplaced Type"; Rec."Not Inplaced Type")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Not Inplaced Description"; Rec."Not Inplaced Description")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Not Inplaced Both"; Rec."Not Inplaced Both")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Both';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field(GetNotInplacedTotal; Rec.GetNotInplacedTotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total';
                    Style = Strong;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalculateTotal(0);
        NotInPlacedVisible := (Rec."Not Inplaced Type" <> 0) and (Rec."Not Inplaced Description" <> 0) and (Rec."Not Inplaced Both" <> 0);
    end;

    var
        SalesTotal: Decimal;
        RefundTotal: Decimal;
        ExpenseTotal: Decimal;
        CashTotal: Decimal;
        NotInPlacedVisible: Boolean;
}
