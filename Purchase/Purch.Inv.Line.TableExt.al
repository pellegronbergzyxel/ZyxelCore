tableextension 50136 PurchInvLineZX extends "Purch. Inv. Line"
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
        field(50005; "Vendor Invoice No"; Text[30])
        {
            Description = 'HQ';
        }
        field(50028; "GLC Serial No."; Code[20])
        {
            Caption = 'GLC Serial No.';
            Description = '23-02-23 ZY-LD 009';
        }
        field(50029; "GLC Mac Address"; Code[20])
        {
            Caption = 'GLC Mac Address';
            Description = '23-02-23 ZY-LD 009';
        }
        field(50036; "Original No."; Code[20])  // 01-05-24 ZY-LD 000
        {
            Caption = 'Original No.';
            Description = 'In case of samples we need to store the original item no. so we can use it in intrastat reporting.';
        }
        field(50102; "EMS Machine Code"; Code[35])
        {
            Caption = 'EMS Machine Code';
            Description = 'PAB 1.0';
        }
        field(62000; Sales_Order_No; Code[20])
        {
        }
        field(62001; Sales_Line_No; Integer)
        {
            Description = 'Unused';
        }
        field(62006; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Description = 'Unused';
        }
        field(62050; "Picking List No."; Code[20])
        {
            Caption = 'Picking List No';
            Description = 'Unused';
            Editable = false;
        }
        field(62051; "Packing List No."; Text[50])
        {
            Caption = 'Packing List No.';
            Description = 'Unused';
            Editable = false;
        }
    }
}
