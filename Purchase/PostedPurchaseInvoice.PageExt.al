pageextension 50316 PostedPurchaseInvoiceZX extends "Posted Purchase Invoice"
{
    layout
    {
        //25-09-2026 BK #596378 
        addafter(IncomingDocAttachFactBox)
        {
            part(HQInvoices; "Posted HQ Invoice ListPart")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Vendor Invoice No.");
            }

        }
    }
}