Page 50114 "Payment Header FactBox2"
{
    PageType = CardPart;
    SourceTable = "eCommerce Payment Header";

    layout
    {
        area(content)
        {
            group(Reconciliation)
            {
                Caption = 'Reconciliation';
                field(GetSRETotal; Rec.GetSRETotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Dashboard: Sales + Refunds + Expenses';
                }
                field(GetPostingTotal; Rec.GetPostingTotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting: Cash Rcpt. + Purch. Inv.';
                }
                field("GetSRETotal - GetPostingTotal"; Rec.GetSRETotal - Rec.GetPostingTotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total';
                    StyleExpr = StyleExp;
                }
            }
            group("Sales Reimbursement")
            {
                Caption = 'Sales Reimbursement';
                Visible = false;
                field("RRB Sales Other"; Rec."RRB Sales Other")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Other';
                    DrillDownPageID = "eCommerce Payment Journal";
                    Visible = false;
                }
                field(RRBTotal; Rec.GetSalesInvTotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total';
                    Style = Strong;
                    StyleExpr = true;
                    Visible = false;
                }
            }
            group("Cash Receipt Journal")
            {
                Caption = 'Cash Receipt Journal';
                field("CRJ Sales Product Charge"; Rec."CRJ Sales Product Charge")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Product Charge';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("CRJ Sales Tax"; Rec."CRJ Sales Tax")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Tax';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("CRJ Sales Shipping"; Rec."CRJ Sales Shipping")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Shipping';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("CRJ Sales Other"; Rec."CRJ Sales Other")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Other';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field(xx; Rec."RRB Sales Other")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Other (Reimbursement)';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("CRJ Refunded Expense"; Rec."CRJ Refunded Expense")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Refunded Expense';
                }
                field("CRJ Refunded Sales"; Rec."CRJ Refunded Sales")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Refunded Sales';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Expense Promo Rebates"; Rec."Expense Promo Rebates")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expenses Promo Rebates';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field(GetCahsRcptTotal; Rec.GetCahsRcptTotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total';
                    Style = Strong;
                    StyleExpr = true;
                }
            }
            group("Purchase Invoice")
            {
                Caption = 'Purchase Invoice';
                field("PI Sales Tax"; Rec."PI Sales Tax")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Tax';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("PI Sales Other"; Rec."PI Sales Other")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Other';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("PI Refunded Expense"; Rec."PI Refunded Expense")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Refunded Expense';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("PI Refunded Sales"; Rec."PI Refunded Sales")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Refunded Sales';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Expense FBA Fee"; Rec."Expense FBA Fee")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expenses FBA Fee';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Expense Cost of Advertising"; Rec."Expense Cost of Advertising")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expenses Cost of Advertising';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Expense eCommerce Fee"; Rec."Expense eCommerce Fee")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expenses eCommerce Fee';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field("Expense Other"; Rec."Expense Other")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expenses Other';
                    DrillDownPageID = "eCommerce Payment Journal";
                }
                field(GetPurchInvTotal; Rec.GetPurchInvTotal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total';
                    Style = Strong;
                    StyleExpr = true;
                }
            }
            group("Total Posted")
            {
                Caption = 'Total Posted';
                field(Total; Rec.GetPostingTotal)
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
        Rec.CalculateTotal(1);

        if Rec.GetSRETotal - Rec.GetPostingTotal <> 0 then
            StyleExp := 'Unfavorable'
        else
            StyleExp := 'Strong';
    end;

    var
        StyleExp: Text;
}
