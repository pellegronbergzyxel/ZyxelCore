tableextension 50129 SalesInvoiceHeaderZX extends "Sales Invoice Header"
{
    fields
    {
        field(50005; "Sell-to VAT Registration Code"; Code[20])
        {
            Caption = 'Sell-to VAT Registration Code';
            Description = '30-10-17 ZY-LD 003';
        }
        field(50006; "Company VAT Registration Code"; Code[20])
        {
            Caption = 'VAT Registration No. Zyxel';
            Description = '30-10-17 ZY-LD 003';
            Editable = false;
        }
        field(50007; "VAT Registration Code"; Code[10])
        {
            TableRelation = "IC Vendors";
        }
        field(50008; "Total Quantity"; Decimal)
        {
            CalcFormula = sum("Sales Invoice Line".Quantity where("Document No." = field("No."),
                                                                  Type = const(Item),
                                                                  "Hide Line" = const(false)));
            Caption = 'Total Quantity';
            Description = '07-03-18 ZY-LD 004';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50028; "Invoice No. for End Customer"; Code[20])
        {
            Caption = 'Invoice No. for End Customer';
            Description = '11-04-19 ZY-LD 009';
        }
        field(50029; "Serial Numbers Status"; Option)
        {
            Caption = 'Serial Numbers Status';
            Description = '11-04-19 ZY-LD 009';
            OptionMembers = " ",Attached,Sent,Rejected,Accepted;
        }
        field(50030; "Currency Code Sales Doc SUB"; Code[10])
        {
            Caption = 'Currency Code on Sales Invoice SUB';
            Description = '09-12-19 ZY-LD 013';
            TableRelation = Currency;
        }
        field(50032; "Eicard Type"; Option)  // 28-06-24 ZY-LD 000
        {
            Caption = 'Eicard Type';
            OptionCaption = ' ,Normal,Consignment,eCommerce';
            OptionMembers = " ",Normal,Consignment,eCommerce;
        }
        field(50033; "Customer Document No."; Code[4])
        {
            Caption = 'Customer Document No.';
            Description = '14-01-21 ZY-LD 017';
        }
        field(50034; "SAP No."; Code[10])
        {
            Caption = 'SAP No.';
            Description = '14-01-21 ZY-LD 017';
        }
        field(50038; "External Invoice No."; Code[35])
        {
            Caption = 'External Invoice No.';
        }
        field(50040; "Intercompany Purchase"; Code[10])
        {
            TableRelation = "Intercompany Purchase Code";
        }
        field(50041; "Intercompany Currency Code"; Code[10])
        {
        }
        field(50042; "InterCompany VAT"; Decimal)
        {
        }
        field(50043; "Cust. Ledger Entry"; Text[30])
        {
            CalcFormula = lookup("Cust. Ledger Entry"."Document No." where("Document No." = field("No."),
                                                                           "Customer No." = field("Bill-to Customer No.")));
            FieldClass = FlowField;
        }
        field(50046; "Ship-to VAT"; Text[50])
        {
            Caption = 'VAT Registration No. (Ship-to)';
            Description = '06-06-19 ZY-LD 010';
            Editable = false;
        }
        field(50047; "Send E-mail at"; DateTime)
        {
            CalcFormula = lookup("Sales Document E-mail Entry"."Send E-mail at" where("Document Type" = const("Posted Sales Invoice"),
                                                                                      "Document No." = field("No.")));
            Caption = 'Send E-mail at';
            Description = '07-11-19 ZY-LD 012';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50048; "Mark Invoice as Printed"; Boolean)
        {
            CalcFormula = lookup(Customer."Mark Inv. and Cr.M as Printed" where("No." = field("Bill-to Customer No.")));
            Caption = 'Mark Invoice as Printed';
            Description = '07-11-19 ZY-LD 012';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "CZ Sales Order No."; Code[20])
        {
            Description = 'ZY2.0 Used in Auto Routine when sales orde/Credit memo is created in RHQ Live from CZ';
        }
        field(50051; "Deleted Document"; Boolean)
        {
            CalcFormula = exist("Sales Invoice Line" where("Document No." = field("No."),
                                                           "Line No." = const(10000),
                                                           Description = const('Deleted Document')));
            Caption = 'Deleted Document';
            Description = '07-11-19 ZY-LD 012';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50053; "SII Spain - Document Sent"; Boolean)
        {
            Caption = 'SII Spain - Document Sent';
        }
        field(50054; "NL to DK Rev. Charge Posted"; Boolean)  // 13-03-24 ZY-LD 000  // Can be deleted.
        {
            Caption = 'NL to DK Reverse Charge Posted';
        }
        field(50055; "NL to DK Rev. Charge Doc No."; Boolean)  // 13-03-24 ZY-LD 000  // Wrong Type. Can be deleted.
        {
            Caption = 'Not Used.';
        }
        field(50056; "NL to DK Reverse Chg. Doc No."; Code[20])  // 13-03-24 ZY-LD 000
        {
            Caption = 'NL to DK Rev. Charge Document No.';
        }
        field(50060; "Created by Company"; Text[30])
        {
            Description = 'ZY2.0 Used in Auto Routine when sales order is created in RHQ Live from CZ';
        }
        field(50061; "eCommerce Order"; Boolean)
        {
            Description = 'eCommerce';
        }
        field(50062; "Reference 2"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(50063; "Line Discount Amount"; Decimal)
        {
            CalcFormula = sum("Sales Invoice Line"."Line Discount Amount" where("Document No." = field("No.")));
            Caption = 'Line Discount Amount';
            Description = '12-04-18 ZY-LD 005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50064; "Specification is Sent"; Boolean)
        {
            Caption = 'Specification is Sent';
            Description = '17-02-22 ZY-LD 019';
        }
        field(50066; "Chemical Report Sent"; Boolean)
        {
            Description = '02-06-22 ZY-LD 020';
        }
        field(50067; "Total Amount on eCommerce"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Total (Inc. Tax)" where("eCommerce Order Id" = field("External Document No."),
                                                                                      "Invoice No." = field("External Invoice No.")));
            Caption = 'Total Amount on eCommerce';
            Description = '17-10-22 ZY-LD 021';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50068; "Order Desk Resposible Code"; Code[20])
        {
            Caption = 'Order Desk Resposible';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50069; "Cust. Ledg. Entry Open"; Boolean)
        {
            CalcFormula = lookup("Cust. Ledger Entry".Open where("Document Type" = const(Invoice),
                                                                 "Document No." = field("No.")));
            Caption = 'Cust. Ledg. Entry Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50071; "Ship-to Code Del. Doc"; Code[20])  // 06-05-24 ZY-LD 000
        {
            Caption = 'Ship-to Code - Rework';
            Description = 'For samples we sometime ship products to Denmark to rework, but due to intrastat the item ledger entry must still be the receiving country.';
            TableRelation = "Ship-to Address" where("Customer No." = field("Sell-to Customer No."));
        }
        field(61300; "E-Invoice Comment"; Text[25])
        {
            Caption = 'E-Invoice Comment';
            Description = '01-02-19 ZY-LD 008';
        }
        field(62000; "Picking List No."; Code[20])
        {
            CalcFormula = lookup("Sales Invoice Line"."Picking List No." where("Document No." = field("No."),
                                                                               "Picking List No." = filter(<> '')));
            Caption = 'Picking List No';
            Description = '01-11-19 ZY-LD 011';
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
        field(62025; "RHQ Invoice No"; Code[30])
        {
        }
        field(62033; "Dist. PO#"; Text[50])
        {
            Description = 'Tectura Taiwan';
        }
        field(62034; "Dist. E-mail"; Text[50])
        {
            Description = 'Tectura Taiwan';
        }
        field(62100; "Registration No."; Text[20])
        {
            Description = 'CO4.20';
        }
        field(62105; "Variable Symbol"; Code[10])
        {
            Description = 'CO4.20';
        }
        field(62106; "Constant Symbol"; Code[10])
        {
            Description = 'CO4.20';
        }
        field(67003; "Ship-to E-Mail"; Text[50])
        {
            Description = 'eCommerce';
        }
        field(70000; "EDI Invoice"; Boolean)
        {
            Caption = 'EDI Invoice';
            Description = 'PAB 1.0';
        }
        field(70001; "EDI Processed"; Boolean)
        {
            Caption = 'EDI Processed';
            Description = 'PAB 1.0';
        }
        field(70002; "EDI Acknowledged"; Boolean)
        {
            Caption = 'EDI Acknowledged';
            Description = 'PAB 1.0';
        }
    }

    keys
    {
        key(Key50000; "Your Reference")
        {
        }
        key(Key50001; "Serial Numbers Status", "Invoice No. for End Customer")
        {
        }
    }
}
