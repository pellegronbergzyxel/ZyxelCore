pageextension 50164 ApplyCustomerEntriesZX extends "Apply Customer Entries"
{
    layout
    {
        addafter("Posting Date")
        {
            field("External Order No."; Rec."External Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Global Dimension 2 Code")
        {
            field(eCommerceOrderID; eCommerceOrderID)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce Order ID';
                Editable = false;
                Visible = false;
            }
        }
    }

    /* IR 052: Not possible to apply G/L entry to open invoice in Cash receipt journal trough shift F11
    actions
    {
        addafter("&Navigate")
        {
            action("Search eCommerce Order-id")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Search eCommerce Order-id';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SearcheCommerceOrderID();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GeteCommerceOrderID();  // 07-11-17 ZY-LD 001
    end;
    */

    var
        eCommerceOrderID: Code[50];

    procedure GetAppliedAmount() AppliedAmount2: Decimal
    begin
        // <PM>
        // GetAppliedAmount
        CalcApplnAmount();
        AppliedAmount2 := AppliedAmount - PmtDiscAmount;
        // </PM>
    end;

    /* IR 052: Not possible to apply G/L entry to open invoice in Cash receipt journal trough shift F11
    local procedure GeteCommerceOrderID()
    var
        lSalesInvoiceHeader: Record "Sales Invoice Header";
        lSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        leCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
    begin
        //>> 07-11-17 ZY-LD 001
        if (Rec."Document Type" in [Rec."document type"::Invoice, Rec."document type"::"Credit Memo"]) and
           (Rec."External Document No." <> '') and
           (StrLen(Rec."External Document No.") <= MaxStrLen(leCommerceSalesHeaderBuffer."RHQ Invoice No"))
        then begin
            leCommerceSalesHeaderBuffer.ChangeCompany('ZyXEL (RHQ) Go LIVE');
            leCommerceSalesHeaderBuffer.SetRange("RHQ Invoice No", Rec."External Document No.");
            if leCommerceSalesHeaderBuffer.FindFirst() then
                eCommerceOrderID := leCommerceSalesHeaderBuffer."eCommerce Order Id"
            else
                eCommerceOrderID := '';
        end;
        //<< 07-11-17 ZY-LD 001
    end;

    local procedure SearcheCommerceOrderID()
    var
        leCommerceSalesHeaderBuffer: Record "eCommerce Order Header";
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        GenericInputPage: Page "Generic Input Page";
        lText001: Label 'Search eCommerce Order-id';
        lText002: Label 'eCommerce Order-id';
        eCommerceOrderID: Code[20];
    begin
        GenericInputPage.SetPageCaption(lText001);
        GenericInputPage.SetFieldCaption(lText002);
        GenericInputPage.SetVisibleField(3);
        GenericInputPage.SetCode20('');
        if GenericInputPage.RunModal = Action::OK then begin
            eCommerceOrderID := GenericInputPage.GetCode20;
            leCommerceSalesHeaderBuffer.ChangeCompany('ZyXEL (RHQ) Go LIVE');
            leCommerceSalesHeaderBuffer.SetRange("eCommerce Order Id", eCommerceOrderID);
            if leCommerceSalesHeaderBuffer.FindFirst() then begin
                lCustLedgerEntry.SetRange("External Document No.", leCommerceSalesHeaderBuffer."RHQ Invoice No");
                lCustLedgerEntry.FindFirst();
                Rec.Get(lCustLedgerEntry."Entry No.");
                CurrPage.Update(false);
            end;
        end;
    end;
    */
}
