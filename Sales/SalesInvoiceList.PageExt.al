pageextension 50299 SalesInvoiceListZX extends "Sales Invoice List"
{
    layout
    {
        addafter("Job Queue Status")
        {
            field("Send Mail"; Rec."Send Mail")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
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
        addafter("P&osting")
        {
            group("Function")
            {
                Caption = 'Function';
                action("Create Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Invoices';
                    Ellipsis = true;
                    Image = "Action";

                    trigger OnAction()
                    begin
                        ProcessInvoice();  // 11-11-19 ZY-LD 003
                    end;
                }
                action("Skip Posting Group Validation")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Skip Posting Group Validation';
                    Image = ChangeTo;

                    trigger OnAction()
                    begin
                        SkipPostGrpValidation();  // 28-06-21 ZY-LD 004
                    end;
                }
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

    local procedure ProcessInvoice()
    var
        CreateNormalSalesInvoice: Codeunit "Create Normal Sales Invoice";
    begin
        CreateNormalSalesInvoice.ProcessInvoice('', false, true);  // 11-11-19 ZY-LD 003
        CurrPage.Update(false);  // 11-11-19 ZY-LD 003
    end;

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
