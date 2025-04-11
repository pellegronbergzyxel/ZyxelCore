tableextension 50202 SalesHeaderArchiveZX extends "Sales Header Archive"
{
    fields
    {
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        field(50006; "VAT Registration No. Zyxel"; Code[20])
        {
            Caption = 'VAT Registration No. Zyxel';
            Description = '27-04-20 ZY-LD 001';
        }
        field(50028; "Shipping Request Notes"; Text[96])
        {
            Caption = 'Shipping Request Notes';
            Description = '16-08-19 ZY-LD 023';
        }
        field(50030; "Currency Code Sales Doc SUB"; Code[10])
        {
            Caption = 'Currency Code on Sales Document SUB';
            Description = '27-04-20 ZY-LD 001';
            TableRelation = Currency;
        }
        field(50031; "External Document No. End Cust"; Code[20])
        {
            Caption = 'External Document No. for End Cust.';
            Description = '29-01-20 ZY-LD 029';
        }
        field(50032; "Eicard Type"; Option)
        {
            Caption = 'Eicard Type';
            Description = '18-02-20 ZY-LD 030';
            OptionCaption = ' ,Normal,Consignment,eCommerce';
            OptionMembers = " ",Normal,Consignment,eCommerce;
        }
        field(50033; "Customer Document No."; Code[4])
        {
            Caption = 'Customer Document No.';
            Description = '25-01-21 ZY-LD 003';
        }
        field(50034; "SAP No."; Code[10])
        {
            Caption = 'SAP No.';
            Description = '25-01-21 ZY-LD 003';
        }
        field(50036; "Skip Posting Group Validation"; Boolean)
        {
            Caption = 'Skip Posting Group Validation';
            Description = '22-06-21 ZY-LD 043';
        }
        field(50046; "Ship-to VAT"; Text[50])
        {
            Caption = 'VAT Registration No. (Sell-to)';
        }
        field(50051; "No. of Lines"; Integer)
        {
            CalcFormula = Count("Sales Line Archive" where("Document Type" = field("Document Type"),
                                                           "Document No." = field("No."),
                                                           "Version No." = field("Version No.")));
            FieldClass = FlowField;
            Editable = false;
        }
        field(50062; "Reference 2"; Text[50])
        {
            Caption = 'Reference 2';
            Description = 'eCommerce';
        }
        field(62004; "Send Mail"; Boolean)
        {
            Caption = 'Send Automatic E-mail';
            Description = '27-04-20 ZY-LD 001';
        }
        field(62017; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            Description = '27-04-20 ZY-LD 001';
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
                LEMSG005: Label 'Document Type should be Order or Invoice!';
            begin
            end;
        }
        field(62022; "Completely Invoiced"; Boolean)
        {
            CalcFormula = min("Sales Line Archive"."Completely Invoiced" where("Document Type" = field("Document Type"),
                                                                               "Document No." = field("No."),
                                                                               Type = filter(<> " ")));
            Caption = 'Completely Invoiced';
            Description = 'Tectura Taiwan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62080; "Create User ID"; Code[30])
        {
            Caption = 'Create User ID';
            Description = 'ZL111213A';
            Editable = false;
        }
        field(62081; "Create Date"; Date)
        {
            Caption = 'Create Date';
            Description = 'ZL111213A';
            Editable = false;
        }
    }
}
