table 50101 "eCommerce Order Line"
{
    // 001. 17-07-24 ZY-LD 000 - Zyxel Store ship from VCK.
    // 002. 13-09-24 ZY-LD 000 - VAT Prod. Posting Group GB.

    Caption = 'eCommerce Order Line';
    DataPerCompany = true;

    fields
    {
        field(1; "eCommerce Order Id"; Code[30])
        {
            Caption = 'eCommerce Order Id';
        }
        field(2; "Invoice No."; Code[35])
        {
            Caption = 'Invoice No.';
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
            Caption = 'Line Amount Incl. VAT';
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if Quantity <> 0 then
                    "Item Price (Inc. Tax)" := "Total (Inc. Tax)" / Quantity
                else
                    "Item Price (Inc. Tax)" := "Total (Inc. Tax)";
            end;
        }
        field(9; "Total Tax Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            DecimalPlaces = 2 : 2;
        }
        field(10; "Total (Exc. Tax)"; Decimal)
        {
            Caption = 'Line Amount Excl. VAT';
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if Quantity <> 0 then
                    "Item Price (Exc. Tax)" := "Total (Exc. Tax)" / Quantity
                else
                    "Item Price (Exc. Tax)" := "Total (Exc. Tax)";
            end;
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
            Caption = 'Unit Price Price Incl. VAT';
            DecimalPlaces = 2 : 2;
        }
        field(20; "Item Price (Exc. Tax)"; Decimal)
        {
            Caption = 'Unit Price Excl. VAT';
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
        field(24; "Unexpected Item"; Boolean)
        {
            Caption = 'Unexpected Item';
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
            Description = '26-09-18 ZY-LD 001';
            Editable = false;
            OptionCaption = 'Order,Refund';
            OptionMembers = "Order",Refund;
        }
        field(29; "Customer No."; Code[20])
        {
            CalcFormula = lookup("eCommerce Order Header"."Customer No." where("Invoice No." = field("Invoice No."),
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
            Description = '23-02-21 ZY-LD 004';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            var
                recAmzMktPlace: Record "eCommerce Market Place";
                VatBusPostGrp: Code[20];
                VatProdPostGrp: Code[20];
                TaxRate: Decimal;
            begin
                recAmzHead.GET("Transaction Type", "eCommerce Order Id", "Invoice No.");
                recAmzMktPlace.GET(recAmzHead."Marketplace ID");

                IF recAmzHead."Alt. VAT Bus. Posting Group" <> '' THEN BEGIN
                    VatBusPostGrp := recAmzHead."Alt. VAT Bus. Posting Group";
                    TaxRate := recAmzHead."Alt. Tax Rate";
                END ELSE BEGIN
                    VatBusPostGrp := recAmzHead."VAT Bus. Posting Group";
                    TaxRate := recAmzHead."Tax Rate";
                END;
                //>> 13-09-24 ZY-LD 002
                VatProdPostGrp := "VAT Prod. Posting Group";
                if (recAmzHead."Ship To Country" = recAmzMktPlace."Country/Region Code (GB)") and (recAmzMktPlace."VAT Prod. Posting Group (GB)" <> '') then
                    VatProdPostGrp := recAmzMktPlace."VAT Prod. Posting Group (GB)";
                //<< 13-09-24 ZY-LD 002

                IF recVatPostSetup.GET(VatBusPostGrp, VatProdPostGrp) THEN BEGIN
                    IF (recVatPostSetup."VAT %" <> TaxRate) AND
                       (recVatPostSetup."VAT Calculation Type" <> recVatPostSetup."VAT Calculation Type"::"Reverse Charge VAT")
                    THEN BEGIN
                        //>> 16-06-22 ZY-LD 005
                        IF recAmzHead."Tax Rate" = 0 THEN
                            "VAT Prod. Posting Group" := FORMAT(recAmzHead."Tax Rate")  //<< 16-06-22 ZY-LD 005
                        ELSE
                            "VAT Prod. Posting Group" := VatProdPostGrp + FORMAT(recAmzHead."Tax Rate");
                    END ELSE BEGIN
                        "VAT Prod. Posting Group" := VatProdPostGrp;
                    END;
                END ELSE
                    //>> 16-06-22 ZY-LD 005
                    IF recAmzHead."Tax Rate" = 0 THEN
                        "VAT Prod. Posting Group" := FORMAT(recAmzHead."Tax Rate")  //<< 16-06-22 ZY-LD 005
            end;
        }
        field(38; "VAT Bus. Posting Group"; Code[10])
        {
            CalcFormula = lookup("eCommerce Order Header"."VAT Bus. Posting Group" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                       "Invoice No." = field("Invoice No.")));
            Caption = 'VAT Bus. Posting Group';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(39; "Location Code"; Code[10])
        {
            CalcFormula = lookup("eCommerce Order Header"."Location Code" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                              "Invoice No." = field("Invoice No.")));
            Caption = 'Location Code';
            Description = '10-08-22 ZY-LD 006';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Location;
        }
        field(40; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                Amount :=
                  "Total (Exc. Tax)" +
                  "Total Shipping (Exc. Tax)" + "Shipping Promo (Exc. Tax)" +
                  "Total Promo (Exc. Tax)" +
                  "Gift Wrap (Exc. Tax)" + "Gift Wrap Promo (Exc. Tax)" +
                  "Line Discount Excl. Tax";
                Validate("Tax Amount");
                Validate("Amount Including VAT");
            end;
        }
        field(41; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';

            trigger OnValidate()
            begin
                "Tax Amount" :=
                  "Total Tax Amount" +
                  "Total Shipping Tax Amount" + "Shipping Promo Tax Amount" +
                  "Total Promo Tax Amount" +
                  "Gift Wrap Tax Amount" + "Gift Wrap Promo Tax Amount" +
                  "Line Discount Tax Amount";
            end;
        }
        field(42; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';

            trigger OnValidate()
            begin
                "Amount Including VAT" :=
                  "Total (Inc. Tax)" +
                  "Total Shipping (Inc. Tax)" + "Shipping Promo (Inc. Tax)" +
                  "Total Promo (Inc. Tax)" +
                  "Gift Wrap (Inc. Tax)" + "Gift Wrap Promo (Inc. Tax)" +
                  "Line Discount Incl. Tax";
            end;
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
            CalcFormula = lookup("eCommerce Order Header"."Order Date" where("Transaction Type" = field("Transaction Type"),
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

    var
        recAmzHead: Record "eCommerce Order Header";
        recVatPostSetup: Record "VAT Posting Setup";

    procedure ValidateVATProdPostingGroup(pVatProdPostGrp: Code[10]; pEcomHead: Record "eCommerce Order Header"; var pEcomLine: Record "eCommerce Order Line"; pEcomMktPlace: Record "eCommerce Market Place")
    var
        VatBusPostGrp: Code[10];
        TaxRate: Decimal;
    begin
        //>> 17-07-24 ZY-LD 001
        IF pEcomHead."Alt. VAT Bus. Posting Group" <> '' THEN BEGIN
            VatBusPostGrp := pEcomHead."Alt. VAT Bus. Posting Group";
            TaxRate := pEcomHead."Alt. Tax Rate";
        END ELSE BEGIN
            VatBusPostGrp := pEcomHead."VAT Bus. Posting Group";
            TaxRate := pEcomHead."Tax Rate";
        END;
        IF recVatPostSetup.GET(VatBusPostGrp, pVatProdPostGrp) THEN BEGIN
            IF (recVatPostSetup."VAT %" <> TaxRate) AND
               (recVatPostSetup."VAT Calculation Type" <> recVatPostSetup."VAT Calculation Type"::"Reverse Charge VAT")
            THEN BEGIN
                //>> 16-06-22 ZY-LD 005
                IF pEcomHead."Tax Rate" = 0 THEN
                    pEcomLine."VAT Prod. Posting Group" := FORMAT(pEcomHead."Tax Rate")  //<< 16-06-22 ZY-LD 005
                ELSE
                    pEcomLine."VAT Prod. Posting Group" := pVatProdPostGrp + FORMAT(pEcomHead."Tax Rate");
            END ELSE
                pEcomLine."VAT Prod. Posting Group" := pEcomMktPlace."VAT Prod. Posting Group";
        END ELSE
            //>> 16-06-22 ZY-LD 005
            IF pEcomHead."Tax Rate" = 0 THEN
                pEcomLine."VAT Prod. Posting Group" := FORMAT(pEcomHead."Tax Rate")  //<< 16-06-22 ZY-LD 005
        //<< 17-07-24 ZY-LD 001                
    end;


    procedure EditLine()
    var
        recAmzOrdLineTmp: Record "eCommerce Order Line" temporary;
    begin
        recAmzOrdLineTmp := Rec;
        recAmzOrdLineTmp.Insert();
        if Page.RunModal(Page::"Edit eCommerce Order Line", recAmzOrdLineTmp) = Action::LookupOK then begin
            Validate("Total (Exc. Tax)", recAmzOrdLineTmp."Total (Exc. Tax)");
            Validate("Total Tax Amount", recAmzOrdLineTmp."Total Tax Amount");
            Validate("Total (Inc. Tax)", recAmzOrdLineTmp."Total (Inc. Tax)");
            Validate("Total Promo (Exc. Tax)", recAmzOrdLineTmp."Total Promo (Exc. Tax)");
            Validate("Total Promo Tax Amount", recAmzOrdLineTmp."Total Promo Tax Amount");
            Validate("Total Promo (Inc. Tax)", recAmzOrdLineTmp."Total Promo (Inc. Tax)");
            Validate("Total Shipping (Exc. Tax)", recAmzOrdLineTmp."Total Shipping (Exc. Tax)");
            Validate("Total Shipping Tax Amount", recAmzOrdLineTmp."Total Shipping Tax Amount");
            Validate("Total Shipping (Inc. Tax)", recAmzOrdLineTmp."Total Shipping (Inc. Tax)");
            Validate("Line Discount Excl. Tax", recAmzOrdLineTmp."Line Discount Excl. Tax");
            Validate("Line Discount Tax Amount", recAmzOrdLineTmp."Line Discount Tax Amount");
            Validate("Line Discount Incl. Tax", recAmzOrdLineTmp."Line Discount Incl. Tax");
            validate("VAT Prod. Posting Group", recAmzOrdLineTmp."VAT Prod. Posting Group");
            Validate(Amount);
            Modify(true);
        end;
    end;
}
