pageextension 50309 SalesQuoteArchivesZX extends "Sales Quote Archives"
{
    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 11-11-20 ZY-LD 001
    end;
}
