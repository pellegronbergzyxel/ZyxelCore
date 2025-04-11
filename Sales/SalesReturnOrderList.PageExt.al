pageextension 50302 SalesReturnOrderListZX extends "Sales Return Order List"
{
    layout
    {
        addlast(Control1)
        {
            field("No of Lines"; Rec."No of Lines")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
    actions
    {
        modify("&Print")
        {
            Caption = '&Print Confirmation';
        }
        addafter("Whse. Receipt Lines")
        {
            action("Warehouse Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Response';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Rcpt. Response List";
                RunPageLink = "Shipment No." = field("No.");
            }
        }
        addfirst(Processing)
        {
            action("Email Confirmation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Email Confirmation';
                Ellipsis = true;
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.EmailSalesHeader(Rec);
                end;
            }
        }
        addafter("Send IC Return Order Cnfmn.")
        {
            action("Skip Posting Group Validation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Skip Posting Group Validation';
                Image = ChangeTo;

                trigger OnAction()
                begin
                    SkipPostGrpValidation();  // 28-06-21 ZY-LD 003
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 02-04-20 ZY-LD 001
    end;

    local procedure SkipPostGrpValidation()
    var
        recSalesHead: Record "Sales Header";
        SalesHeaderEvent: Codeunit "Sales Header/Line Events";
        lText001: Label 'Do you want to skip posting group validation for %1 Sales Return Order(s)?';
    begin
        //>> 28-06-21 ZY-LD 003
        CurrPage.SetSelectionFilter(recSalesHead);
        if Confirm(lText001, false, recSalesHead.Count(), CurrPage.Caption) then
            SalesHeaderEvent.SkipPostGrpValidation(recSalesHead);
        //<< 28-06-21 ZY-LD 003
    end;
}
