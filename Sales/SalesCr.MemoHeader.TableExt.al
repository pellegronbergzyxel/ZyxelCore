tableextension 50131 SalesCrMemoHeaderZX extends "Sales Cr.Memo Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            Caption = 'Sell-to Customer No.';
        }
        modify("No.")
        {
            Caption = 'No.';
        }
        modify("Bill-to Customer No.")
        {
            Caption = 'Bill-to Customer No.';
        }
        modify("Bill-to Name")
        {
            Caption = 'Bill-to Name';
        }
        modify("Posting Date")
        {
            Caption = 'Posting Date';
        }
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        modify(Amount)
        {
            Caption = 'Amount';
        }
        modify("Amount Including VAT")
        {
            Caption = 'Amount Including VAT';
        }
        modify("VAT Country/Region Code")
        {
            Caption = 'VAT Country/Region Code';
        }
        modify("Bill-to Country/Region Code")
        {
            Caption = 'Bill-to Country/Region Code';
        }
        modify("Ship-to Country/Region Code")
        {
            Caption = 'Ship-to Country/Region Code';
        }
        field(50005; "Sell-to VAT Registration Code"; Code[20])
        {
            Caption = 'Sell-to VAT Registration Code';
            Description = 'Unused';
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
        field(50021; "Warehouse Inbound No."; Code[20])
        {
            CalcFormula = lookup("Sales Cr.Memo Line"."Warehouse Inbound No." where("Document No." = field("No."),
                                                                                    "Warehouse Inbound No." = filter(<> '')));
            Caption = 'Warehouse Inbound No.';
            Description = '04-05-20 ZY-LD 011';
            FieldClass = FlowField;
        }
        field(50030; "Currency Code Sales Doc SUB"; Code[10])
        {
            Caption = 'Currency Code on Sales Cred. Memo SUB';
            Description = 'Unused';
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
            Description = '14-01-21 ZY-LD 013';
        }
        field(50034; "SAP No."; Code[10])
        {
            Caption = 'SAP No.';
            Description = '14-01-21 ZY-LD 013';
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
            Description = 'Unused';
        }
        field(50042; "InterCompany VAT"; Decimal)
        {
            Description = 'Unused';
        }
        field(50046; "Ship-to VAT"; Text[50])
        {
            Caption = 'VAT Registration No. (Ship-to)';
            Description = '27-12-17 ZY-LD 004 06-06-19 ZY-LD 008';
            Editable = false;
        }
        field(50050; "CZ Sales Order No."; Code[20])
        {
            Description = 'Unused';
        }
        field(50054; "NL to DK Rev. Charge Posted"; Boolean)  // 13-03-24 ZY-LD 000
        {
            Caption = 'Not Used';
        }
        field(50055; "NL to DK Rev. Charge Doc No."; Boolean)  // 13-03-24 ZY-LD 000  // Wrong type - Can be deleted.
        {
            Caption = 'NL to DK Rev. Charge Document No.';
        }
        field(50056; "NL to DK Reverse Chg. Doc No."; Code[20])  // 13-03-24 ZY-LD 000
        {
            Caption = 'NL to DK Rev. Charge Document No.';
        }
        field(50060; "Created by Company"; Text[30])
        {
            Description = 'Unused';
        }
        field(50061; "eCommerce Order"; Boolean)
        {
            Description = 'eCommerce 27-12-17 ZY-LD 004';
        }
        field(50062; "Reference 2"; Text[50])
        {
            Description = 'eCommerce 27-12-17 ZY-LD 004';
        }
        field(50063; "Line Discount Amount"; Decimal)
        {
            CalcFormula = sum("Sales Cr.Memo Line"."Line Discount Amount" where("Document No." = field("No.")));
            Caption = 'Line Discount Amount';
            Description = 'Unused';
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
            CalcFormula = lookup("Cust. Ledger Entry".Open where("Document Type" = const("Credit Memo"),
                                                                 "Document No." = field("No.")));
            Caption = 'Cust. Ledg. Entry Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50070; "Return Reason Code"; Code[10])
        {
            CalcFormula = lookup("Sales Cr.Memo Line"."Return Reason Code" where("Document No." = field("No.")));
            Caption = 'Return Reason Code';
            Description = '02-03-23 ZY-LD 014';
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
            Description = '01-02-19 ZY-LD 007';
        }
        field(62004; "Send Mail"; Boolean)
        {
            Description = 'Tectura Taiwan';
        }
        field(62008; "ZBO Document No."; Text[50])
        {
            Description = 'Unused';
        }
        field(62009; "Special Remark"; Text[150])
        {
            Description = 'Unused';
        }
        field(62010; "Shipping Instruction"; Text[150])
        {
            Description = 'Unused';
        }
        field(62026; "RHQ Credit Memo No"; Code[20])
        {
        }
        field(62033; "Dist. PO#"; Text[50])
        {
            Description = 'Unused';
        }
        field(62034; "Dist. E-mail"; Text[50])
        {
            Description = 'Unused';
        }
        field(70000; "EDI Invoice"; Boolean)
        {
            Caption = 'EDI Invoice';
            Description = 'Unused';
        }
        field(70001; "EDI Processed"; Boolean)
        {
            Caption = 'EDI Processed';
            Description = 'Unused';
        }
        field(70002; "EDI Document No."; Code[20])
        {
            Caption = 'EDI Document No.';
            Description = 'Unused';
        }
    }

    keys
    {
        key(Key50000; "Your Reference")
        {
        }
    }
}
