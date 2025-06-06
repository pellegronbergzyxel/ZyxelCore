tableextension 50185 HandledICOutboxSalesLineZX extends "Handled IC Outbox Sales Line"
{
    fields
    {
        field(50000; "Return Reason Code"; Code[10])  // 16-09-24 ZY-LD 000
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
        }
        field(50022; "External Document Position No."; Code[10])
        {
            Caption = 'External Document Position No.';
            Description = '04-08-21 ZY-LD 001';
        }
        field(50101; "Hide Line"; Boolean)
        {
        }
        field(62000; "Picking List No."; Code[20])
        {
            Caption = 'Picking List No';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(62001; "Packing List No."; Text[50])
        {
            Caption = 'Packing List No.';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(62036; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                LocationRec: Record Location;
                LEMSG000: Label 'Location %1 can not match Sales Order Type %2!';
                LEMSG001: Label 'Can not find location %1!';
            begin
            end;
        }
        field(62037; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(62038; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            Description = '30-11-21 ZY-LD 004';
            TableRelation = "VAT Product Posting Group";
        }
    }
}
