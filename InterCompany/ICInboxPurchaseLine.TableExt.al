tableextension 50190 ICInboxPurchaseLineZX extends "IC Inbox Purchase Line"
{
    fields
    {
        field(50000; "Return Reason Code"; Code[10])
        {
            Caption = 'Return Reason Code';
            TableRelation = "Return Reason";
        }
        field(50022; "External Document Position No."; Code[10])
        {
            Caption = 'External Document Position No.';
            Description = '04-08-21 ZY-LD 004';
        }
        field(50101; "Hide Line"; Boolean)
        {
        }
        field(50103; "IC Payment Terms"; Code[10])
        {
            Caption = 'IC Payment Terms';
            Description = '20-09-18 ZY-LD 001';
            TableRelation = "Payment Terms";
        }
        field(62006; "External Document No."; Code[35])
        {
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
        field(62050; "Picking List No."; Code[20])
        {
            Caption = 'Picking List No';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(62051; "Packing List No."; Text[50])
        {
            Caption = 'Packing List No.';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
    }
}
