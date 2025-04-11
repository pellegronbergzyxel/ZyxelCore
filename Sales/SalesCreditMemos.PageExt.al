pageextension 50300 SalesCreditMemosZX extends "Sales Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field("Order Desk Resposible Code"; Rec."Order Desk Resposible Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
    actions
    {
        addafter("Remove From Job Queue")
        {
            action("Skip Posting Group Validation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Skip Posting Group Validation';
                Image = ChangeTo;

                trigger OnAction()
                begin
                    SkipPostGrpValidation;  // 28-06-21 ZY-LD 004
                end;
            }
            action("Count")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Count';
                Image = Calculate;

                trigger OnAction()
                begin
                    Message('eCommerce Orders: %1', Rec.Count());
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 27-10-17 ZY-LD 001
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 002
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 002
    end;

    var
        SI: Codeunit "Single Instance";

    local procedure SkipPostGrpValidation()
    var
        recSalesHead: Record "Sales Header";
        SalesHeaderEvent: Codeunit "Sales Header/Line Events";
    begin
        //>> 28-06-21 ZY-LD 003
        CurrPage.SetSelectionFilter(recSalesHead);
        SalesHeaderEvent.SkipPostGrpValidationWithConfirm(recSalesHead, CurrPage.Caption);
        //<< 28-06-21 ZY-LD 003
    end;
}
