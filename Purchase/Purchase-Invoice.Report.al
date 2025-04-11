reportextension 50004 PurchaseInvoiceZX extends "Purchase - Invoice"
{
    dataset
    {
        modify("Purch. Inv. Header")
        {
            trigger OnBeforeAfterGetRecord()
            var
                CompInfo: Record "Company Information";
            begin
                if "Purch. Inv. Header"."VAT Registration No. Zyxel" <> '' then
                    VatRegNo := "Purch. Inv. Header"."VAT Registration No. Zyxel"
                else begin
                    CompInfo.Get();
                    VatRegNo := CompInfo."VAT Registration No.";
                end;
            end;

        }
        add("Purch. Inv. Header")
        {
            column(CompanyInfoVATRegNoZyxel; VatRegNo)
            {
            }
            column(CompanyInfoEMailZyxel; EMailZyxelLbl)
            {
            }
        }
    }

    rendering
    {
        layout("./Layouts/PurchaseInvoiceZyxel.rdlc")
        {
            Type = RDLC;
            LayoutFile = './Layouts/PurchaseInvoiceZyxel.rdlc';
        }
    }


    var
        VatRegNo: Text;
        EMailZyxelLbl: label 'apinvoices@zyxel.dk', Locked = true;
}