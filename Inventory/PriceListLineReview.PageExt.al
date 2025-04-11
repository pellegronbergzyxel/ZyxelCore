pageextension 50012 "Price List Line Review" extends "Price List Line Review"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part("Margin Approval FacxBox"; "Margin Approval FacxBox")
            {
                Visible = MarginApprovalVisible;
                SubPageLink = "Source Type" = const("Price Book"),
                              "Source No." = field("Price List Code"),
                              "Source Line No." = field("Line No.");
            }
        }
    }

    actions
    {
        modify(VerifyLines)
        {
            Enabled = VeryfyLinesEnabled;
        }
        addafter(SalesJobPriceLists)
        {
            action(AddNewPrice)
            {
                Caption = 'Add New Price';
                Image = NewRow;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    Rec.EnterNewSalesPrice();
                    Commit;
                    Error('');
                    //Update();
                end;
            }
        }
    }
    Var
        MarginApprovalVisible: Boolean;
        VeryfyLinesEnabled: Boolean;

    trigger OnOpenPage()
    var
        MarginApp: Record "Margin Approval";
    Begin
        MarginApprovalVisible := MarginApp.MarginApprovalActive();
        VeryfyLinesEnabled := not MarginApp.MarginApprovalActive();
    End;
}
