tableextension 50130 SalesInvoiceLineZX extends "Sales Invoice Line"
{
    fields
    {
        field(50000; "Order Date"; Date)
        {
            CalcFormula = lookup("Sales Invoice Header"."Posting Date" where("No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50001; Country; Code[10])
        {
            CalcFormula = lookup(Customer."Country/Region Code" where("No." = field("Bill-to Customer No.")));
            FieldClass = FlowField;
        }
        field(50002; "Forecast Territory"; Code[20])
        {
            CalcFormula = lookup(Customer."Forecast Territory" where("No." = field("Sell-to Customer No.")));
            Caption = 'Forecast Territory';
            Description = '13-11-19 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Forecast Territory";
        }
        field(50003; "Sell-to Customer Name"; Text[100])
        {
            CalcFormula = lookup("Sales Invoice Header"."Sell-to Customer Name" where("No." = field("Document No.")));
            FieldClass = FlowField;
            Caption = 'Sell-to Customer Name';
        }
        field(50004; "Bill-to Country/Region"; Code[10])
        {
            CalcFormula = Lookup("Sales Invoice Header"."Bill-to Country/Region Code" where("No." = field("Document No.")));
            FieldClass = Flowfield;
            Caption = 'Bill-to Country/Region';
        }
        field(50006; "Cost Split Type"; Code[20])
        {
        }
        field(50013; "Customer Profile Code"; Code[20])
        {
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where("Table ID" = const(18),
                                                                                  "Dimension Code" = const('CUSTOMERPROFILE'),
                                                                                  "No." = field("Sell-to Customer No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50014; "Department Code"; Code[20])
        {
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where("Table ID" = const(18),
                                                                                  "Dimension Code" = const('DEPARTMENT'),
                                                                                  "No." = field("Sell-to Customer No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50015; "Country Code"; Code[20])
        {
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where("Table ID" = const(18),
                                                                                  "Dimension Code" = const('COUNTRY'),
                                                                                  "No." = field("Sell-to Customer No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50016; "Division Code"; Code[20])
        {
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where("Table ID" = const(18),
                                                                                  "Dimension Code" = const('DIVISION'),
                                                                                  "No." = field("Sell-to Customer No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50017; "Related Delivery Document"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "VCK Delivery Document Header"."No.";
        }
        field(50022; "External Document Position No."; Code[10])
        {
            Caption = 'External Document Position No.';
            Description = '04-08-21 ZY-LD 011';
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
            Editable = true;
        }
        field(50103; "IC Payment Terms"; Code[10])
        {
            Caption = 'IC Payment Terms';
            Description = '20-09-18 ZY-LD 006';
            TableRelation = "Payment Terms";
        }
        field(50130; "Currency Code"; Code[10])
        {
            CalcFormula = lookup("Sales Invoice Header"."Currency Code" where("No." = field("Document No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Currency;
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
        field(62042; "Special Order No. on SO Line"; Code[20])
        {
            Editable = false;
        }
        field(62043; "Sell-To Customer country"; Code[20])
        {
            CalcFormula = lookup(Customer."Territory Code" where("No." = field("Sell-to Customer No.")));
            Caption = 'Sell-To Customer Territory';
            Description = '20-08-18 ZY-LD 005';
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key50000; "External Document No.")
        {
        }
        key(Key50001; Type, "No.", "Posting Date", "Location Code", "Shortcut Dimension 1 Code")
        {
        }
        key(Key50002; "Picking List No.")
        {
        }
    }
}
