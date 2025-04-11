reportextension 50003 PurchaseCreditMemoZX extends "Purchase - Credit Memo"
{

    dataset
    {
        modify("Purch. Cr. Memo Hdr.")
        {
            trigger OnBeforeAfterGetRecord()
            var
                CompInfo: Record "Company Information";
            begin
                if "Purch. Cr. Memo Hdr."."VAT Registration No. Zyxel" <> '' then
                    VatRegNo := "Purch. Cr. Memo Hdr."."VAT Registration No. Zyxel"
                else begin
                    CompInfo.Get();
                    VatRegNo := CompInfo."VAT Registration No.";
                end;
            end;

        }
        add("Purch. Cr. Memo Hdr.")
        {
            column(CompanyInfoVATRegNoZyxel; VatRegNo)
            {
            }
        }
    }

    rendering
    {
        layout("./Layouts/PurchaseCreditMemoZyxel.rdlc")
        {
            Type = RDLC;
            LayoutFile = './Layouts/PurchaseCreditMemoZyxel.rdlc';
        }
    }

    var
        VatRegNo: Text;
}