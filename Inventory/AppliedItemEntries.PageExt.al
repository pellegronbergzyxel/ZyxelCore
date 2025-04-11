pageextension 50261 AppliedItemEntriesZX extends "Applied Item Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field(CostAmountActual; CostAmountActual)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Applied Cost Amount Actual';
                Visible = false;
            }
            field(CostAmountExpected; CostAmountExpected)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Applied Cost Amount (Expected)';
                Visible = false;
            }
            field(CostAmountGL; CostAmountGL)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Applied Cost Posted to G/L';
                Visible = false;
            }
            field("Source Type"; Rec."Source Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Freight Cost per Unit"; Rec."Freight Cost per Unit")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Freight Cost Amount"; Rec."Freight Cost Amount")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetApplyQty();
    end;

    var
        CostAmountActual: Decimal;
        CostAmountExpected: Decimal;
        CostAmountGL: Decimal;

    local procedure GetApplyQty()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        ApplQty: Decimal;
        Qty: Decimal;
    begin
        ItemLedgEntry.Get(Rec."Entry No.");
        ApplQty := Rec.Quantity;
        Qty := ItemLedgEntry.Quantity;

        ValueEntry.SetRange("Item Ledger Entry No.", Rec."Entry No.");
        ValueEntry.SetFilter("Posting Date", Format(Rec."Date Filter"));
        ValueEntry.CalcSums("Cost Amount (Actual)", "Cost Amount (Expected)", "Cost Posted to G/L");

        CostAmountActual := ValueEntry."Cost Amount (Actual)" / Abs(Qty) * Abs(ApplQty);
        CostAmountExpected := ValueEntry."Cost Amount (Expected)" / Abs(Qty) * Abs(ApplQty);

        Rec."Cost Posted to G/L" := ItemLedgEntry."Cost Posted to G/L" / Abs(Qty) * Abs(ApplQty);
    end;
}
