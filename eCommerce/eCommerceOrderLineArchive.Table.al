table 50011 "eCommerce Order Line Archive"
{
    Caption = 'eCommerce Order Line Archive';

    fields
    {
        field(1; "eCommerce Order Id"; Code[30])
        {
            Caption = 'eCommerce Order Id';
            TableRelation = "eCommerce Order Archive"."eCommerce Order Id";
        }
        field(2; "Invoice No."; Code[35])
        {
            Caption = 'Invoice No.';
            TableRelation = "eCommerce Order Archive"."Invoice No.";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; ASIN; Code[20])
        {
            Caption = 'ASIN';
        }
        field(5; "Item No."; Code[30])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ValidateTableRelation = false;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(8; "Total (Inc. Tax)"; Decimal)
        {
            Caption = 'Total (Inc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(9; "Total Tax Amount"; Decimal)
        {
            Caption = 'Total Tax Amount';
            DecimalPlaces = 2 : 2;
        }
        field(10; "Total (Exc. Tax)"; Decimal)
        {
            Caption = 'Total (Exc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(11; "Total Promo (Inc. Tax)"; Decimal)
        {
            Caption = 'Promo (Inc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(12; "Total Promo Tax Amount"; Decimal)
        {
            Caption = 'Promo Tax Amount';
            DecimalPlaces = 2 : 2;
        }
        field(13; "Total Promo (Exc. Tax)"; Decimal)
        {
            Caption = 'Promo (Exc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(14; "Total Shipping (Inc. Tax)"; Decimal)
        {
            Caption = 'Shipping (Inc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(15; "Total Shipping Tax Amount"; Decimal)
        {
            Caption = 'Shipping Tax Amount';
            DecimalPlaces = 2 : 2;
        }
        field(16; "Total Shipping (Exc. Tax)"; Decimal)
        {
            Caption = 'Shipping (Exc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(19; "Item Price (Inc. Tax)"; Decimal)
        {
            Caption = 'Item Price (Inc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(20; "Item Price (Exc. Tax)"; Decimal)
        {
            Caption = 'Item Price (Exc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(21; "Line Discount Pct."; Decimal)
        {
            Caption = 'Line Discount Pct.';
            MaxValue = 100;
            MinValue = 0;
        }
        field(22; "Line Discount Excl. Tax"; Decimal)
        {
            Caption = 'Line Discount Excl. Tax';
        }
        field(23; "Line Discount Incl. Tax"; Decimal)
        {
            Caption = 'Line Discount Incl. Tax';
        }
        field(26; "Ship-to Country Code"; Code[10])
        {
            CalcFormula = lookup("eCommerce Order Header"."Ship To Country" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                  "Invoice No." = field("Invoice No.")));
            Caption = 'Ship-to Country Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Country/Region";
        }
        field(27; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            Editable = false;
            OptionCaption = 'Order,Refund';
            OptionMembers = "Order",Refund;
        }
        field(29; "Customer No."; Code[20])
        {
            CalcFormula = lookup("eCommerce Order Archive"."Customer No." where("Invoice No." = field("Invoice No."),
                                                                                "eCommerce Order Id" = field("eCommerce Order Id")));
            Caption = 'Customer No.';
            Description = '10-04-19 ZY-LD 003';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Customer;
        }
        field(30; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(38; "VAT Bus. Posting Group"; Code[10])
        {
            CalcFormula = lookup("eCommerce Order Archive"."VAT Bus. Posting Group" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                          "Invoice No." = field("Invoice No.")));
            Caption = 'VAT Bus. Posting Group';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(40; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(41; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
        }
        field(42; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
        }
        field(43; "Line Discount Tax Amount"; Decimal)
        {
            Caption = 'Line Discount Tax Amount';
        }
        field(44; "Gift Wrap (Inc. Tax)"; Decimal)
        {
            Caption = 'Gift Wrap (Inc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(45; "Gift Wrap Tax Amount"; Decimal)
        {
            Caption = 'Gift Wrap Tax Amount';
            DecimalPlaces = 2 : 2;
        }
        field(46; "Gift Wrap (Exc. Tax)"; Decimal)
        {
            Caption = 'Gift Wrap (Exc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(47; "Gift Wrap Promo (Inc. Tax)"; Decimal)
        {
            Caption = 'Gift Wrap Promo (Inc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(48; "Gift Wrap Promo Tax Amount"; Decimal)
        {
            Caption = 'Gift Wrap Promo Tax Amount';
            DecimalPlaces = 2 : 2;
        }
        field(49; "Gift Wrap Promo (Exc. Tax)"; Decimal)
        {
            Caption = 'Gift Wrap Promo (Exc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(50; "Shipping Promo (Inc. Tax)"; Decimal)
        {
            Caption = 'Shipping Promo (Inc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(51; "Shipping Promo Tax Amount"; Decimal)
        {
            Caption = 'Shipping Promo Tax Amount';
            DecimalPlaces = 2 : 2;
        }
        field(52; "Shipping Promo (Exc. Tax)"; Decimal)
        {
            Caption = 'Shipping Promo (Exc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(53; "Order Date"; Date)
        {
            CalcFormula = lookup("eCommerce Order Archive"."Order Date" where("Transaction Type" = field("Transaction Type"),
                                                                              "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                              "Invoice No." = field("Invoice No.")));
            Caption = 'Order Date';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "eCommerce Order Id", "Invoice No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
