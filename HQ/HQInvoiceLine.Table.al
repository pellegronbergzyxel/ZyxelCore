Table 76151 "HQ Invoice Line"
{
    // 001. 24-09-19 ZY-LD P0307 - New fields.
    // 002. 19-08-21 ZY-LD 000 - New field. "No Charge" it happens that we don´t have to pay.

    Caption = 'HQ Sales Document Line';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Description = 'PAB 1.0';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Description = 'PAB 1.0';
        }
        field(4; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            Description = 'PAB 1.0';
            Editable = true;
            TableRelation = Vendor;
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            Description = 'PAB 1.0';
            TableRelation = Item;

            trigger OnValidate()
            var
                PrepmtMgt: Codeunit "Prepayment Mgt.";
                LMSG000: label 'Locked by reference sales document!';
            begin
            end;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
            Description = 'PAB 1.0';
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            Description = 'PAB 1.0';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            Description = 'PAB 1.0';

            trigger OnValidate()
            var
                LMSG000: label 'Locked by reference sales document!';
            begin
            end;
        }
        field(9; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            Description = 'PAB 1.0';
        }
        field(10; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
            Description = 'PAB 1.0';
            Editable = false;

            trigger OnValidate()
            begin
                "Total Price" := ROUND(Quantity * "Unit Price");
            end;
        }
        field(11; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Description = 'PAB 1.0';
            TableRelation = "Purchase Header"."No.";
        }
        field(12; "Purchase Order Line No."; Integer)
        {
            Caption = 'Purchase Order Line No.';
            Description = 'PAB 1.0';
        }
        field(13; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            Description = 'PAB 1.0';
        }
        field(14; "Invoice Line No."; Integer)
        {
            Caption = 'Invoice Line No.';
            Description = 'PAB 1.0';
        }
        field(15; "Details Updated"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(16; "Last Bill of Material Price"; Decimal)
        {
            Caption = 'Last Bill of Material Price (LBOM)';
            Description = '24-09-19 ZY-LD 001';
        }
        field(17; "Overhead Price"; Decimal)
        {
            Caption = 'Overhead Price (OH)';
            Description = '24-09-19 ZY-LD 001';
        }
        field(18; "No Charge (n/c)"; Boolean)
        {
            Caption = 'No Charge (n/c)';
            Description = '19-08-21 ZY-LD 002';
        }
        field(19; "Qty. on Container Detail"; Decimal)
        {
            CalcFormula = sum("VCK Shipping Detail".Quantity where("Invoice No." = field("Document No."),
                                                                    "Purchase Order No." = field("Purchase Order No."),
                                                                    "Purchase Order Line No." = field("Purchase Order Line No."),
                                                                    Archive = const(false)));
            Caption = 'Qty. on Container Detail';
            DecimalPlaces = 0 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "VCK Shipping Handled"; Boolean)
        {
            Caption = 'VCK Shipping Handled';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
