Report 50051 "Reconcile Sales Documents"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Reconcile Sales Documents.rdlc';
    Caption = 'Reconcile Sales Documents';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter("G/L Account" | Item));
            RequestFilterFields = "Posting Date";
            column(PostingDate; "Sales Invoice Line"."Posting Date")
            {
            }
            column(GenBusPostingGroup; "Sales Invoice Line"."Gen. Bus. Posting Group")
            {
            }
            column(GenProdPostingGroup; "Sales Invoice Line"."Gen. Prod. Posting Group")
            {
            }
            column(SalesAccount; SalesAccount)
            {
            }
            column(CurrencyCode; "Sales Invoice Line".GetCurrencyCode)
            {
            }
            column(Amount; "Sales Invoice Line".Amount)
            {
            }
            column(AmountEUR; AmountEUR)
            {
            }
            column(VATBusPostingGroup; "Sales Invoice Line"."VAT Bus. Posting Group")
            {
            }
            column(VATProdPostingGroup; "Sales Invoice Line"."VAT Prod. Posting Group")
            {
            }
            column(SalesVATAccount; SalesVATAccount)
            {
            }
            column(VATAmount; "Sales Invoice Line"."Amount Including VAT" - "Sales Invoice Line".Amount)
            {
            }
            column(VATAmountEUR; VATAmountEUR)
            {
            }
            column(DocumentNo; "Sales Invoice Line"."Document No.")
            {
            }
            column(DocumentType; CopyStr("Sales Invoice Line".TableCaption, 1, 13))
            {
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Sales Invoice Line".TableCaption, 0, true);

                if "Sales Invoice Line".Amount = 0 then
                    CurrReport.Skip;

                if recSalesInvHead."No." <> "Sales Invoice Line"."Document No." then begin
                    recSalesInvHead.Get("Sales Invoice Line"."Document No.");
                    if recSalesInvHead."Currency Factor" = 0 then
                        recSalesInvHead."Currency Factor" := 1;
                end;
                AmountEUR := "Sales Invoice Line".Amount / recSalesInvHead."Currency Factor";
                VATAmountEUR := ("Sales Invoice Line"."Amount Including VAT" - "Sales Invoice Line".Amount) / recSalesInvHead."Currency Factor";

                SalesAccount := '';
                SalesVATAccount := '';
                if "Sales Invoice Line".Type = "Sales Invoice Line".Type::"G/L Account" then
                    SalesAccount := "Sales Invoice Line"."No."
                else begin
                    if (recGenPostSetup."Gen. Bus. Posting Group" <> "Sales Invoice Line"."Gen. Bus. Posting Group") or
                       (recGenPostSetup."Gen. Prod. Posting Group" <> "Sales Invoice Line"."Gen. Prod. Posting Group")
                    then
                        if not recGenPostSetup.Get("Sales Invoice Line"."Gen. Bus. Posting Group", "Sales Invoice Line"."Gen. Prod. Posting Group") then
                            Clear(recGenPostSetup);
                    SalesAccount := recGenPostSetup."Sales Account";
                end;

                if (recVATPostSetup."VAT Bus. Posting Group" <> "Sales Invoice Line"."VAT Bus. Posting Group") or
                    (recVATPostSetup."VAT Prod. Posting Group" <> "Sales Invoice Line"."VAT Prod. Posting Group")
                then
                    if not recVATPostSetup.Get("Sales Invoice Line"."VAT Bus. Posting Group", "Sales Invoice Line"."VAT Prod. Posting Group") then
                        Clear(recVATPostSetup);
                SalesVATAccount := recVATPostSetup."Sales VAT Account";
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "Sales Invoice Line".Count);
            end;
        }
        dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
        {
            DataItemTableView = sorting("Document No.", "Line No.") where(Type = filter("G/L Account" | Item));
            column(PostingDate_CR; "Sales Cr.Memo Line"."Posting Date")
            {
            }
            column(GenBusPostingGroup_CR; "Sales Cr.Memo Line"."Gen. Bus. Posting Group")
            {
            }
            column(GenProdPostingGroup_CR; "Sales Cr.Memo Line"."Gen. Prod. Posting Group")
            {
            }
            column(SalesAccount_CR; SalesAccount)
            {
            }
            column(CurrencyCode_CR; "Sales Cr.Memo Line".GetCurrencyCode)
            {
            }
            column(Amount_CR; -"Sales Cr.Memo Line".Amount)
            {
            }
            column(AmountEUR_CR; -AmountEUR)
            {
            }
            column(VATBusPostingGroup_CR; "Sales Cr.Memo Line"."VAT Bus. Posting Group")
            {
            }
            column(VATProdPostingGroup_CR; "Sales Cr.Memo Line"."VAT Prod. Posting Group")
            {
            }
            column(SalesVATAccount_CR; SalesVATAccount)
            {
            }
            column(VATAmount_CR; -("Sales Cr.Memo Line"."Amount Including VAT" - "Sales Cr.Memo Line".Amount))
            {
            }
            column(VATAmountEUR_CR; -VATAmountEUR)
            {
            }
            column(DocumentNo_CR; "Sales Cr.Memo Line"."Document No.")
            {
            }
            column(DocumentType_CR; CopyStr("Sales Cr.Memo Line".TableCaption, 1, 13))
            {
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Sales Cr.Memo Line".TableCaption, 0, true);

                if "Sales Cr.Memo Line".Amount = 0 then
                    CurrReport.Skip;

                if recSalesCrMemoHead."No." <> "Sales Cr.Memo Line"."Document No." then begin
                    recSalesCrMemoHead.Get("Sales Cr.Memo Line"."Document No.");
                    if recSalesCrMemoHead."Currency Factor" = 0 then
                        recSalesCrMemoHead."Currency Factor" := 1;
                end;
                AmountEUR := "Sales Cr.Memo Line".Amount / recSalesCrMemoHead."Currency Factor";
                VATAmountEUR := ("Sales Cr.Memo Line"."Amount Including VAT" - "Sales Cr.Memo Line".Amount) / recSalesCrMemoHead."Currency Factor";

                SalesAccount := '';
                SalesVATAccount := '';
                if "Sales Cr.Memo Line".Type = "Sales Cr.Memo Line".Type::"G/L Account" then
                    SalesAccount := "Sales Cr.Memo Line"."No."
                else begin
                    if (recGenPostSetup."Gen. Bus. Posting Group" <> "Sales Cr.Memo Line"."Gen. Bus. Posting Group") or
                       (recGenPostSetup."Gen. Prod. Posting Group" <> "Sales Cr.Memo Line"."Gen. Prod. Posting Group")
                    then
                        if not recGenPostSetup.Get("Sales Cr.Memo Line"."Gen. Bus. Posting Group", "Sales Cr.Memo Line"."Gen. Prod. Posting Group") then
                            Clear(recGenPostSetup);
                    SalesAccount := recGenPostSetup."Sales Credit Memo Account";
                end;

                if (recVATPostSetup."VAT Bus. Posting Group" <> "Sales Cr.Memo Line"."VAT Bus. Posting Group") or
                   (recVATPostSetup."VAT Prod. Posting Group" <> "Sales Cr.Memo Line"."VAT Prod. Posting Group")
                then
                    if not recVATPostSetup.Get("Sales Cr.Memo Line"."VAT Bus. Posting Group", "Sales Cr.Memo Line"."VAT Prod. Posting Group") then
                        Clear(recVATPostSetup);
                SalesVATAccount := recVATPostSetup."Sales VAT Account";
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                "Sales Invoice Line".Copyfilter("Posting Date", "Sales Cr.Memo Line"."Posting Date");
                ZGT.OpenProgressWindow('', "Sales Cr.Memo Line".Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        recGenSetup.Get;
    end;

    var
        recGenSetup: Record "General Ledger Setup";
        recGenPostSetup: Record "General Posting Setup";
        recVATPostSetup: Record "VAT Posting Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
        ZGT: Codeunit "ZyXEL General Tools";
        SalesAccount: Code[20];
        SalesVATAccount: Code[20];
        AmountEUR: Decimal;
        VATAmountEUR: Decimal;
}
