tableextension 50127 SalesShipmentHeaderZX extends "Sales Shipment Header"
{
    fields
    {
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }

        field(55015; AmazonePoNo; Code[35])
        {
            Caption = 'Amazon PO No.';
            DataClassification = ToBeClassified;
        }

        field(55016; AmazonpurchaseOrderState; text[20])
        {
            Caption = 'Amazon purchaseOrderState';
            DataClassification = ToBeClassified;
        }
        field(55017; AmazonSellpartyid; text[20])
        {
            Caption = 'Amazon AmazonSellpartyid';
            DataClassification = ToBeClassified;
        }

        field(55019; AmazconfirmationStatus; text[20])
        {
            Caption = 'Amazon confirmationStatus';
            DataClassification = ToBeClassified;
        }

        field(61999; "Picking List No. Filter"; Code[20])
        {
            Caption = 'Picking List No. Filter';
            Description = '01-11-19 ZY-LD 002';
            FieldClass = FlowFilter;
        }
        field(62000; "Picking List No."; Code[20])
        {
            CalcFormula = lookup("Sales Shipment Line"."Picking List No." where("Document No." = field("No."),
                                                                                "Picking List No." = filter(<> '')));
            Caption = 'Picking List No';
            Description = '01-11-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62004; "Send Mail"; Boolean)
        {
            Description = 'Tectura Taiwan';
        }
        field(62008; "ZBO Document No."; Text[50])
        {
            Description = 'Tectura Taiwan';
        }
        field(62009; "Special Remark"; Text[150])
        {
            Description = 'Tectura Taiwan';
        }
        field(62010; "Shipping Instruction"; Text[150])
        {
            Description = 'Tectura Taiwan';
        }
        field(62017; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            Description = 'Tectura Taiwan';
            Editable = false;
            OptionCaption = ' ,Normal,EICard,Drop Shipment,Other,Spec. Order,G/L Account,HaaS,eCommerce';  // 15-07-24 ZY-LD 000 - eCommerce is added.';
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
        field(62033; "Dist. PO#"; Text[50])
        {
            Description = 'Tectura Taiwan';
        }
        field(62034; "Dist. E-mail"; Text[50])
        {
            Description = 'Tectura Taiwan';
        }
    }
}
