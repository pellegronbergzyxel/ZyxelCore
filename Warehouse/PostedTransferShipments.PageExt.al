pageextension 50254 PostedTransferShipmentsZX extends "Posted Transfer Shipments"
{
    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 27-10-17 ZY-LD 001
    end;
}
