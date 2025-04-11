tableextension 50134 PurchRcptLineZX extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50001; "Requested Date From Factory"; Date)
        {
            Description = 'DT1.0';
            Editable = false;
        }
        field(50002; "ETD Date"; Date)
        {
            Caption = 'Factory Schedule Date';
            Description = 'DT1.0';
            Editable = false;

            trigger OnValidate()
            var
                lrShipmentMethod: Record "Shipment Method";
            begin
            end;
        }
        field(50003; ETA; Date)
        {
            Description = 'DT1.0';
            Editable = false;
        }
        field(50004; "Actual shipment date"; Date)
        {
            Description = 'DT1.0';
            Editable = false;

            trigger OnValidate()
            var
                lrShipmentMethod: Record "Shipment Method";
            begin
            end;
        }
        field(50005; "Vendor Invoice No"; Text[250])
        {
            Caption = 'Vendor Invoice No.';
            Description = 'HQ';
        }
        field(50010; "Container No."; Text[20])
        {
            Caption = 'Container No.';
            DataClassification = CustomerContent;
        }
        field(50021; "Warehouse Inbound No."; Code[20])
        {
            Caption = 'Warehouse Inbound No.';
            Description = '23-03-20 ZY-LD 004';
        }
        field(62000; Sales_Order_No; Code[20])
        {
        }
        field(62001; Sales_Line_No; Integer)
        {
        }
        field(70002; OriginalLocationCode; Code[10])
        {
            Caption = 'Original Location Code';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(ZXKey1; "Pay-to Vendor No.", "Buy-from Vendor No.", "Qty. Rcd. Not Invoiced")
        {
        }
        key(key70000; OriginalLocationCode)
        {
        }
    }
}
