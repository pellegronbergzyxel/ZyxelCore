pageextension 50018 "Sales Price List" extends "Sales Price List"
{
    actions
    {
        modify(VerifyLines)
        {
            Enabled = VeryfyLinesEnabled;
        }
    }
    var
        MarginApprovalVisible: Boolean;
        VeryfyLinesEnabled: Boolean;

    trigger OnOpenPage()
    var
        MarginApp: Record "Margin Approval";
        PriceListHead: Record "Price List Header";
    begin
        MarginApprovalVisible := MarginApp.MarginApprovalActive();

        VeryfyLinesEnabled := true;
        if Rec."Amount Type" <> Rec."Amount Type"::Discount then
            VeryfyLinesEnabled := not MarginApp.MarginApprovalActive()
    end;
}
