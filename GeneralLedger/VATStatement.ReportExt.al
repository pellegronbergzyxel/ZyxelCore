reportextension 50000 VATStatementZX extends "VAT Statement"
{
    dataset
    {
        add("VAT Statement Line")
        {
            column(VatStmtLineBoxNo; "VAT Statement Line"."Box No.")
            {
            }
            column(VatStmtLineBoxNoCaption; VatStmtLineBoxNoCaption)
            {
            }
        }
    }

    var
        VatStmtLineBoxNoCaption: Label 'Box No.';
}
