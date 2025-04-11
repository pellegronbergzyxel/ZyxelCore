tableextension 50128 SalesShipmentLineZX extends "Sales Shipment Line"
{
    fields
    {
        field(50022; "External Document Position No."; Code[10])
        {
            Caption = 'External Document Position No.';
            Description = '04-08-21 ZY-LD 010';
        }
        field(50025; "Ext Vend Purch. Order No."; Code[20])
        {
            Caption = 'External Vendor Purch. Order No.';
            Description = '11-07-19 ZY-LD 004';
        }
        field(50026; "Ext Vend Purch. Order Line No."; Integer)
        {
            Caption = 'External Vendor Purch. Order Line No.';
            Description = '11-07-19 ZY-LD 004';
        }
        field(50100; "BOM Line No."; Integer)
        {
            Caption = 'BOM Line No.';
            Description = 'DT1.00';
            Editable = false;
        }
        field(50101; "Hide Line"; Boolean)
        {
            Description = 'DT1.00';
            Editable = false;
        }
        field(62000; "Picking List No."; Code[20])
        {
            Caption = 'Picking List No';
            Description = 'Tectura Taiwan';
            Editable = true;
        }
        field(62001; "Packing List No."; Text[50])
        {
            Caption = 'Packing List No.';
            Description = 'Tectura Taiwan';
            Editable = true;
        }
        field(62005; Status; Option)
        {
            Caption = 'Status';
            Description = 'Tectura Taiwan';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(62006; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Description = 'Tectura Taiwan';
        }
        field(62017; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            Description = 'Tectura Taiwan';
            Editable = false;
            OptionCaption = ' ,Normal,EICard,Drop Shipment,Other,Spec. Order,G/L Account,HaaS,eCommerce';  // 15-07-24 ZY-LD 000 - eCommerce is added.
            OptionMembers = " ",Normal,EICard,"Drop Shipment",Other,"Spec. Order","G/L Account",HaaS,eCommerce;

            trigger OnValidate()
            var
                LEMSG000: Label 'Sales Order Type can not be change!';
                LocationRec: Record Location;
                LEMSG001: Label 'Sales Order Type %1 can not match with Location %2!';
                LEMSG002: Label 'Location %1 not exist!';
                LEMSG003: Label 'Can not find default location for Sales Order Type %1!';
                SOLine: Record "Sales Line";
                Item: Record Item;
                LEMSG004: Label 'Item %1 is not match %2!';
            begin
            end;
        }
        field(62047; "Ship-to Code"; Code[10])
        {
            CalcFormula = lookup("Sales Shipment Header"."Ship-to Code" where("No." = field("Document No.")));
            Caption = 'Ship-to Code';
            FieldClass = FlowField;
        }
    }
}
