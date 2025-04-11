Report 50104 "SII Spain - Purchase Invoice"
{
    // 001. 07-03-24 ZY-LD 000 - Makes it possible to update the posted table.

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SII Spain - Purchase Invoice.rdlc';
    Caption = 'SII Spain - Purchase Invoice';
    UsageCategory = ReportsandAnalysis;
    Permissions = TableData "Purch. Inv. Header" = rm;  // 07-03-24 ZY-LD 001

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            CalcFields = Amount, "Amount Including VAT";
            DataItemTableView = where("Buy-from Country/Region Code" = const('ES'));
            RequestFilterFields = "No.", "Posting Date", "SII Spain - Document Sent";
            column(No; "Purch. Inv. Header"."No.")
            {
            }
            column(DocumentDate; "Purch. Inv. Header"."Posting Date")
            {
            }
            column(SelltoCustName; "Purch. Inv. Header"."Buy-from Vendor Name")
            {
            }
            column(SelltoCustNo; "Purch. Inv. Header"."Buy-from Vendor No.")
            {
            }
            column(VatRegNo; "Purch. Inv. Header"."VAT Registration No.")
            {
            }
            column(Amount; "Purch. Inv. Header".Amount)
            {
            }
            column(VatPct; recPurchInvLine."VAT %")
            {
            }
            column(VatAmount; "Purch. Inv. Header"."Amount Including VAT" - "Purch. Inv. Header".Amount)
            {
            }
            column(AmountInclVAT; "Purch. Inv. Header"."Amount Including VAT")
            {
            }
            column(NationalSale; Text001)
            {
            }
            column(Caption_No; Text002)
            {
            }
            column(Caption_DocumentDate; Text003)
            {
            }
            column(Caption_BuyfromVendName; Text004)
            {
            }
            column(Caption_BuyfromVendNo; Text005)
            {
            }
            column(Caption_VatRegNo; Text015)
            {
            }
            column(Caption_Amount; Text006)
            {
            }
            column(Caption_VatPct; Text007)
            {
            }
            column(Caption_VatAmount; Text008)
            {
            }
            column(Caption_AmountInclVAT; Text009)
            {
            }
            column(Caption_NationalPurchase; Text014)
            {
            }

            trigger OnAfterGetRecord()
            begin
                recPurchInvLine.SetRange("Document No.", "Purch. Inv. Header"."No.");
                recPurchInvLine.SetRange(Type, recPurchInvLine.Type::Item);
                recPurchInvLine.SetFilter("No.", '<>%1', '');
                if not recPurchInvLine.FindFirst then
                    Clear(recPurchInvLine);

                "Purch. Inv. Header"."SII Spain - Document Sent" := true;
                "Purch. Inv. Header".Modify;
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

    var
        Text001: label 'NATIONAL PURCHASE';
        recPurchInvLine: Record "Purch. Inv. Line";
        Text002: label 'INVOICE NUMBER';
        Text003: label 'DATE OF INVOICE';
        Text004: label 'SUPPLIERS';
        Text005: label 'ID';
        Text006: label '1 BASE';
        Text007: label 'VAT %';
        Text008: label 'VAT';
        Text009: label 'TOTAL FACTURA';
        Text014: label 'TYPE OF INVOICE';
        Text015: label 'VAT REG. NO.';
}
