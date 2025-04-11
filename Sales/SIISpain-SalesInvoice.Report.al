Report 50103 "SII Spain - Sales Invoice"
{
    // 001. 07-03-24 ZY-LD 000 - Makes it possible to update the posted table.

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SII Spain - Sales Invoice.rdlc';
    Caption = 'SII Spain - Sales Invoice';
    UsageCategory = ReportsandAnalysis;
    Permissions = TableData "Sales Invoice Header" = rm;  // 07-03-24 ZY-LD 001

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            CalcFields = Amount, "Amount Including VAT";
            RequestFilterFields = "No.", "Posting Date", "SII Spain - Document Sent";
            column(No; "Sales Invoice Header"."No.")
            {
            }
            column(DocumentDate; "Sales Invoice Header"."Posting Date")
            {
            }
            column(SelltoCustName; "Sales Invoice Header"."Sell-to Customer Name")
            {
            }
            column(SelltoCustNo; "Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(ShiptoCountry; "Sales Invoice Header"."Ship-to Country/Region Code")
            {
            }
            column(VatRegNo; "Sales Invoice Header"."VAT Registration No.")
            {
            }
            column(Amount; "Sales Invoice Header".Amount)
            {
            }
            column(VatPct; recSalesInvLine."VAT %")
            {
            }
            column(VatAmount; "Sales Invoice Header"."Amount Including VAT" - "Sales Invoice Header".Amount)
            {
            }
            column(AmountInclVAT; "Sales Invoice Header"."Amount Including VAT")
            {
            }
            column(NationalSale; TypeOfSale)
            {
            }
            column(Caption_No; Text002)
            {
            }
            column(Caption_DocumentDate; Text003)
            {
            }
            column(Caption_SelltoCustName; Text004)
            {
            }
            column(Caption_SelltoCustNo; Text005)
            {
            }
            column(Caption_ShiptoCountry; Text015)
            {
            }
            column(Caption_VatRegNo; Text016)
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
            column(Caption_NationalSale; Text014)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Sales Invoice Header"."Ship-to Country/Region Code" in ['ES', ''] then
                    TypeOfSale := Text001
                else
                    TypeOfSale := Text017;

                recSalesInvLine.SetRange("Document No.", "Sales Invoice Header"."No.");
                recSalesInvLine.SetRange(Type, recSalesInvLine.Type::Item);
                recSalesInvLine.SetFilter("No.", '<>%1', '');
                if not recSalesInvLine.FindFirst then
                    Clear(recSalesInvLine);

                "Sales Invoice Header"."SII Spain - Document Sent" := true;
                "Sales Invoice Header".Modify;
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
        Text001: label 'NATIONAL SALE';
        recSalesInvLine: Record "Sales Invoice Line";
        Text002: label 'INVOICE NUMBER';
        Text003: label 'DATE OF INVOICE';
        Text004: label 'CUSTOMER';
        Text005: label 'ID';
        Text006: label '1 BASE IMPONIBLE';
        Text007: label 'VAT %';
        Text008: label 'VAT';
        Text009: label 'TOTAL FACTURA';
        Text010: label '2 BASE';
        Text011: label '2 VAT';
        Text012: label '2 TOTAL';
        Text013: label 'TOTAL INVOICE';
        Text014: label 'TYPE OF INVOICE';
        Text015: label 'SHIP-TO COUNTRY';
        Text016: label 'VAT REG. NO.';
        Text017: label 'INTERNATIONAL SALE';
        TypeOfSale: Code[30];
}
