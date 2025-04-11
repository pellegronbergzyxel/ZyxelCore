tableextension 50203 SalesLineArchiveZX extends "Sales Line Archive"
{
    fields
    {
        field(50007; "Delivery Document No."; Code[20])
        {
            Description = '27-04-20 ZY-LD 001';
        }
        field(50018; "Additional Item Line No."; Integer)
        {
            Caption = 'Additional Item Line No.';
            Description = '27-04-20 ZY-LD 001';
        }
        field(50019; "EMS Machine Code"; Text[64])
        {
            Description = '27-04-20 ZY-LD 001';
        }
        field(50020; "Additional Item Quantity"; Decimal)
        {
            Caption = 'Additional Item Quantity';
            Description = '27-04-20 ZY-LD 001';
            MinValue = 0;
        }
        field(50021; "Warehouse Inbound No."; Code[20])
        {
            Caption = 'Warehouse Inbound No.';
            Description = '27-04-20 ZY-LD 001';
        }
        field(50022; "External Document Position No."; Code[10])
        {
            Caption = 'External Document Position No.';
            Description = '04-08-21 ZY-LD 044';
        }
        field(50025; "Ext Vend Purch. Order No."; Code[20])
        {
            Caption = 'External Vendor Purch. Order No.';
            Description = '27-04-20 ZY-LD 001';
        }
        field(50026; "Ext Vend Purch. Order Line No."; Integer)
        {
            Caption = 'External Vendor Purch. Order Line No.';
            Description = '27-04-20 ZY-LD 001';
        }
        field(50100; "BOM Line No."; Integer)
        {
            Caption = 'BOM Line No.';
            Description = '27-04-20 ZY-LD 001';
        }
        field(50101; "Hide Line"; Boolean)
        {
            Description = '27-04-20 ZY-LD 001';
        }
        field(62000; "Picking List No."; Code[20])
        {
            Caption = 'Picking List No';
            Description = '27-04-20 ZY-LD 001';
            Editable = false;
        }
        field(62006; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Description = '27-04-20 ZY-LD 001';
        }
        field(62022; "Completely Invoiced"; Boolean)
        {
            Description = '27-04-20 ZY-LD 001';
            Editable = false;
        }
        field(62023; "Shipment Date Confirmed"; Boolean)
        {
            Caption = 'Picking Date Confirmed';
            Description = '27-04-20 ZY-LD 001';

            trigger OnValidate()
            var
                qty: Integer;
                recSalesHeader: Record "Sales Header";
                AllInLocation: Code[20];
                NewShipmentDate: Date;
                Now: Text[20];
                ShipTime: Text[2];
            begin
            end;
        }
    }
}
