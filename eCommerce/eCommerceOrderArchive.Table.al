table 50010 "eCommerce Order Archive"
{
    Caption = 'eCommerce Order Archive';
    DrillDownPageID = "eCommerce Order Archive List";
    LookupPageID = "eCommerce Order Archive List";

    fields
    {
        field(1; "eCommerce Order Id"; Code[30])
        {
            Caption = 'eCommerce Order Id';
            TableRelation = "eCommerce Order Archive"."eCommerce Order Id";
        }
        field(2; "Marketplace ID"; Code[20])
        {
            Caption = 'Marketplace ID';
            TableRelation = "eCommerce Market Place";
        }
        field(3; "Merchant ID"; Code[20])
        {
            Caption = 'Merchant ID';
        }
        field(4; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(5; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = 'Order,Refund';
            OptionMembers = "Order",Refund;
        }
        field(6; "Invoice No."; Code[35])
        {
            Caption = 'Inv.-/Ship. No.';
        }
        field(7; "Ship-to City"; Text[50])
        {
            Caption = 'Ship-to City';
        }
        field(8; "Ship-to State"; Text[50])
        {
            Caption = 'Ship-to State';
        }
        field(9; "Ship-to Country"; Code[10])
        {
            Caption = 'Ship-to Country';
            TableRelation = "Country/Region";
        }
        field(10; "Ship-to Postal Code"; Code[20])
        {
            Caption = 'Ship-to Postal Code';
        }
        field(11; "Ship-from City"; Text[50])
        {
            Caption = 'Ship-from City';
        }
        field(12; "Ship-from State"; Text[50])
        {
            Caption = 'Ship-from State';
        }
        field(13; "Ship-from Country"; Code[10])
        {
            Caption = 'Ship-from Country';
            TableRelation = "Country/Region";
        }
        field(14; "Ship-from Postal Code"; Code[20])
        {
            Caption = 'Ship-from Postal Code';
        }
        field(15; "Ship-from Tax Location Code"; Code[20])
        {
            Caption = 'Ship-from Tax Location Code';
        }
        field(16; "Total (Inc. Tax)"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Total (Inc. Tax)" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                      "Invoice No." = field("Invoice No.")));
            Caption = 'Total (Inc. Tax)';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Total Tax Amount"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Total Tax Amount" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                      "Invoice No." = field("Invoice No.")));
            Caption = 'Total Tax Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Total (Exc. Tax)"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Total (Exc. Tax)" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                      "Invoice No." = field("Invoice No.")));
            Caption = 'Total (Exc. Tax)';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Purchaser VAT No."; Code[20])
        {
            Caption = 'Buyer VAT Reg. No.';
        }
        field(22; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            Editable = false;
        }
        field(24; "Invoice Download"; Text[250])
        {
            Caption = 'Invoice Download';
        }
        field(26; "Total EUR (Inc. Tax)"; Decimal)
        {
            Caption = 'Total EUR (Inc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(27; "Total EUR Tax Amount"; Decimal)
        {
            Caption = 'Total EUR Tax Amount';
            DecimalPlaces = 2 : 2;
        }
        field(28; "Total EUR (Exc. Tax)"; Decimal)
        {
            Caption = 'Total EUR (Exc. Tax)';
            DecimalPlaces = 2 : 2;
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(30; "RHQ Creation Date"; Date)
        {
            Caption = 'RHQ Creation Date';
        }
        field(32; Quantity; Integer)
        {
            CalcFormula = sum("eCommerce Order Line Archive".Quantity where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                            "Invoice No." = field("Invoice No.")));
            Caption = 'Quantity';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Export Outside EU"; Boolean)
        {
            Caption = 'Export Outside EU';
        }
        field(36; "Tax Type"; Option)
        {
            Caption = 'Tax Type';
            OptionCaption = ' ,VAT';
            OptionMembers = " ",VAT;
        }
        field(37; "Tax Calculation Reason Code"; Option)
        {
            Caption = 'Tax Calculation Reason Code';
            OptionCaption = 'Not Taxable,Taxable';
            OptionMembers = "Not Taxable",Taxable;
        }
        field(38; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(39; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(40; "Country Dimension"; Code[10])
        {
            Caption = 'Country Dimension';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                         "Dimension Value Type" = const(Standard),
                                                         Blocked = const(false));
        }
        field(41; "Sell-to Type"; Option)
        {
            Caption = 'Sell-to Type';
            OptionCaption = 'Consumer,Business';
            OptionMembers = Consumer,Business;
        }
        field(45; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(46; "VAT Registration No. Zyxel"; Code[20])
        {
            Caption = 'VAT Registration No. Zyxel';
        }
        field(47; "Date Archived"; Date)
        {
            Caption = 'Date Archived';
        }
        field(48; "Transaction ID"; Code[50])
        {
            Caption = 'Transaction ID';
        }
        field(49; "Shipment ID"; Code[50])
        {
            Caption = 'Shipment ID';
        }
        field(50; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(52; "Tax Address Role"; Option)
        {
            Caption = 'Tax Address Role';
            OptionMembers = " ","Ship-from","Ship-to";
        }
        field(53; "Tax Rate"; Decimal)
        {
            BlankZero = true;
            Caption = 'Tax Rate';
            Editable = false;
        }
        field(54; "Buyer Tax Reg. Country"; Code[10])
        {
            Caption = 'Buyer VAT Reg. Country';
            TableRelation = "Shipment Method";
        }
        field(55; "Buyer Tax Reg. Type"; Option)
        {
            Caption = 'Buyer VAT Reg. Type';
            OptionMembers = " ",VAT,"Citizen ID","Business Registration";
        }
        field(56; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(57; "Sales Shipment No."; Code[20])
        {
            Caption = 'Sales Shipment No.';
            Editable = false;
            TableRelation = "Sales Shipment Header";
        }
        field(58; "Seller Tax Reg. Country"; Code[10])
        {
            Caption = 'Seller VAT Reg. Country';
            TableRelation = "Shipment Method";
        }
        field(59; "Ship-to Tax Location Code"; Code[30])
        {
            Caption = 'Ship-to Tax Location Code';
        }
        field(60; "German VAT Reg. No."; Boolean)
        {
            Caption = 'German VAT Reg. No.';
        }
        field(61; Amount; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive".Amount where("Transaction Type" = field("Transaction Type"),
                                                                          "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                          "Invoice No." = field("Invoice No.")));
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Tax Amount"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Tax Amount" where("Transaction Type" = field("Transaction Type"),
                                                                                "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                "Invoice No." = field("Invoice No.")));
            Caption = 'Tax Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Amount Including VAT"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Amount Including VAT" where("Transaction Type" = field("Transaction Type"),
                                                                                          "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                          "Invoice No." = field("Invoice No.")));
            Caption = 'Amount Including VAT';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Item Excl. VAT"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Total (Exc. Tax)" where("Transaction Type" = field("Transaction Type"),
                                                                                      "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                      "Invoice No." = field("Invoice No.")));
            Caption = 'Item Excl. VAT';
            FieldClass = FlowField;
        }
        field(65; "Shipping Excl. VAT"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Total Shipping (Exc. Tax)" where("Transaction Type" = field("Transaction Type"),
                                                                                               "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                               "Invoice No." = field("Invoice No.")));
            Caption = 'Shipping Excl. VAT';
            FieldClass = FlowField;
        }
        field(66; "Promotion Excl. VAT"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Total Promo (Exc. Tax)" where("Transaction Type" = field("Transaction Type"),
                                                                                            "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                            "Invoice No." = field("Invoice No.")));
            Caption = 'Promotion Excl. VAT';
            FieldClass = FlowField;
        }
        field(67; Corrected; Boolean)
        {
            Caption = 'Corrected';
        }
        field(68; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(69; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(70; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';
        }
        field(72; "Import Source Type"; Option)
        {
            Caption = 'Import Source Type';
            OptionCaption = ' ,Tax Library Document,eCommerce Fulfilled Shipment,FBA Customer Return';
            OptionMembers = " ","Tax Library Document","eCommerce Fulfilled Shipment","FBA Customer Return";
        }
        field(73; "Sales Document Type"; Option)
        {
            Caption = 'Sales Document Type';
            Editable = false;
            OptionCaption = ' ,,Invoice,Credit Memo';
            OptionMembers = " ",,Invoice,"Credit Memo";
        }
        field(74; "Item Amount Incl. VAT"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Total (Inc. Tax)" where("Transaction Type" = field("Transaction Type"),
                                                                                    "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                    "Invoice No." = field("Invoice No.")));
            Caption = 'Item Amount Incl. VAT';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(75; "Reversed By"; Code[50])
        {
            Caption = 'Reversed By';
        }
        field(76; "Give Away Order"; Boolean)
        {
            Caption = 'Give Away Order';
            Editable = false;
        }
        field(77; "Tax Collection Respons."; Option)
        {
            Caption = 'Tax Collection Responsibility';
            OptionCaption = ' ,Seller,Marketplace';
            OptionMembers = " ",Seller,Marketplace;
        }
        field(78; "Tax Reporting Scheme"; Code[20])
        {
            Caption = 'Tax Reporting Scheme';
        }
        field(79; "Alt. VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Alt. VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(80; "Alt. Tax Rate"; Decimal)
        {
            Caption = 'Alt. Tax Rate';
            Editable = false;
        }
        field(81; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(82; Marked; Boolean)
        {
            Caption = 'Marked';
        }
        field(83; "Alt. VAT Reg. No. Zyxel"; Code[20])
        {
            Caption = 'Alt. VAT Registration No. Zyxel';
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "eCommerce Order Id", "Invoice No.")
        {
            Clustered = true;
        }
        key(Key2; "Order Date")
        {
        }
        key(Key3; "Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.")
        {
        }
        key(Key4; "Sales Document Type", "eCommerce Order Id", "Invoice No.")
        {
        }
    }

    trigger OnDelete()
    var
        eCommerceOrderLineArchive: Record "eCommerce Order Line Archive";
    begin
        eCommerceOrderLineArchive.SetRange("Transaction Type", "Transaction Type");
        eCommerceOrderLineArchive.SetRange("eCommerce Order Id", "eCommerce Order Id");
        eCommerceOrderLineArchive.SetRange("Invoice No.", "Invoice No.");
        eCommerceOrderLineArchive.DeleteAll(true);
    end;

    procedure TransferOldeCommerceOrders()
    var
        recAmzonOrderHead: Record "eCommerce Order Header";
        recAmzOrderLine: Record "eCommerce Order Line";
        recAmzOrderArc: Record "eCommerce Order Archive";
        recAmzOrderLineArc: Record "eCommerce Order Line Archive";
        ZGT: Codeunit "ZyXEL General Tools";
        LineNo: Integer;
    begin
        recAmzonOrderHead.SetRange(Open, false);
        if recAmzonOrderHead.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recAmzonOrderHead.Count());
            repeat
                ZGT.UpdateProgressWindow(recAmzonOrderHead."eCommerce Order Id", 0, true);

                Clear(recAmzOrderArc);
                recAmzOrderArc."eCommerce Order Id" := recAmzonOrderHead."eCommerce Order Id";
                recAmzOrderArc."Invoice No." := recAmzonOrderHead."Invoice No.";
                recAmzOrderArc."Marketplace ID" := recAmzonOrderHead."Marketplace ID";
                recAmzOrderArc."Merchant ID" := recAmzonOrderHead."Merchant ID";
                recAmzOrderArc."Order Date" := recAmzonOrderHead."Order Date";
                recAmzOrderArc."Transaction Type" := recAmzonOrderHead."Transaction Type";
                recAmzOrderArc."Ship-to City" := recAmzonOrderHead."Ship To City";
                recAmzOrderArc."Ship-to State" := recAmzonOrderHead."Ship To State";
                recAmzOrderArc."Ship-to Country" := recAmzonOrderHead."Ship To Country";
                recAmzOrderArc."Ship-to Postal Code" := recAmzonOrderHead."Ship To Postal Code";
                recAmzOrderArc."Ship-from City" := recAmzonOrderHead."Ship From City";
                recAmzOrderArc."Ship-from State" := recAmzonOrderHead."Ship From State";
                recAmzOrderArc."Ship-from Country" := recAmzonOrderHead."Ship From Country";
                recAmzOrderArc."Ship-from Postal Code" := recAmzonOrderHead."Ship From Postal Code";
                recAmzOrderArc."Ship-from Tax Location Code" := recAmzonOrderHead."Ship From Tax Location Code";
                recAmzOrderArc."Purchaser VAT No." := recAmzonOrderHead."Purchaser VAT No.";
                recAmzOrderArc."Invoice Download" := recAmzonOrderHead."Invoice Download";
                recAmzOrderArc."Currency Code" := recAmzonOrderHead."Currency Code";
                recAmzOrderArc."RHQ Creation Date" := recAmzonOrderHead."RHQ Creation Date";
                recAmzOrderArc."Export Outside EU" := recAmzonOrderHead."Export Outside EU";
                recAmzOrderArc."Tax Type" := recAmzonOrderHead."Tax Type";
                recAmzOrderArc."Tax Calculation Reason Code" := recAmzonOrderHead."Tax Calculation Reason Code";
                recAmzOrderArc."VAT Bus. Posting Group" := recAmzonOrderHead."VAT Bus. Posting Group";
                recAmzOrderArc."Location Code" := recAmzonOrderHead."Location Code";
                recAmzOrderArc."Country Dimension" := recAmzonOrderHead."Country Dimension";
                recAmzOrderArc."Sell-to Type" := recAmzonOrderHead."Sell-to Type";
                recAmzOrderArc."Customer No." := recAmzonOrderHead."Customer No.";
                recAmzOrderArc."VAT Registration No. Zyxel" := recAmzonOrderHead."VAT Registration No. Zyxel";
                recAmzOrderArc."Total (Inc. Tax)" := recAmzonOrderHead."Total (Inc. Tax)";
                recAmzOrderArc."Total Tax Amount" := recAmzonOrderHead."Total Tax Amount";
                recAmzOrderArc."Total (Exc. Tax)" := recAmzonOrderHead."Total (Exc. Tax)";
                recAmzOrderArc."Requested Delivery Date" := recAmzonOrderHead."Requested Delivery Date";
                recAmzOrderArc.Quantity := recAmzonOrderHead.Quantity;

                recAmzOrderArc."Date Archived" := Today;
                recAmzOrderArc.Insert(true);

                LineNo := 0;
                recAmzOrderLine.SetRange("eCommerce Order Id", recAmzonOrderHead."eCommerce Order Id");
                recAmzOrderLine.SetRange("Invoice No.", recAmzonOrderHead."Invoice No.");
                if recAmzOrderLine.FindSet() then begin
                    repeat
                        LineNo += 10000;
                        Clear(recAmzOrderLineArc);
                        recAmzOrderLineArc."eCommerce Order Id" := recAmzOrderLine."eCommerce Order Id";
                        recAmzOrderLineArc."Invoice No." := recAmzOrderLine."Invoice No.";
                        recAmzOrderLineArc."Line No." := LineNo;
                        recAmzOrderLineArc.ASIN := recAmzOrderLine.ASIN;
                        recAmzOrderLineArc."Item No." := recAmzOrderLine."Item No.";
                        recAmzOrderLineArc.Description := recAmzOrderLine.Description;
                        recAmzOrderLineArc.Quantity := recAmzOrderLine.Quantity;
                        recAmzOrderLineArc."Total (Inc. Tax)" := recAmzOrderLine."Total (Inc. Tax)";
                        recAmzOrderLineArc."Total Tax Amount" := recAmzOrderLine."Total Tax Amount";
                        recAmzOrderLineArc."Total (Exc. Tax)" := recAmzOrderLine."Total (Exc. Tax)";
                        recAmzOrderLineArc."Total Promo (Inc. Tax)" := recAmzOrderLine."Total Promo (Inc. Tax)";
                        recAmzOrderLineArc."Total Promo Tax Amount" := recAmzOrderLine."Total Promo Tax Amount";
                        recAmzOrderLineArc."Total Promo (Exc. Tax)" := recAmzOrderLine."Total Promo (Exc. Tax)";
                        recAmzOrderLineArc."Total Shipping (Inc. Tax)" := recAmzOrderLine."Total Shipping (Inc. Tax)";
                        recAmzOrderLineArc."Total Shipping Tax Amount" := recAmzOrderLine."Total Shipping Tax Amount";
                        recAmzOrderLineArc."Total Shipping (Exc. Tax)" := recAmzOrderLine."Total Shipping (Exc. Tax)";
                        recAmzOrderLineArc."Item Price (Inc. Tax)" := recAmzOrderLine."Item Price (Inc. Tax)";
                        recAmzOrderLineArc."Item Price (Exc. Tax)" := recAmzOrderLine."Item Price (Exc. Tax)";
                        recAmzOrderLineArc."Ship-to Country Code" := recAmzOrderLine."Ship-to Country Code";
                        recAmzOrderLineArc."VAT Prod. Posting Group" := recAmzOrderLine."VAT Prod. Posting Group";
                        recAmzOrderLineArc.Insert(true);
                    until recAmzOrderLine.Next() = 0;

                    recAmzOrderArc."Transaction ID" := recAmzOrderLine."Invoice No.";
                    //recAmzOrderArc."Shipment ID" := recAmzOrderLine."Shipment ID";
                    //recAmzOrderArc."Shipment Date" := recAmzOrderLine."Shipment Date";
                    recAmzOrderArc.Modify();

                end;

                recAmzonOrderHead.Delete(true);
            until recAmzonOrderHead.Next() = 0;
            ZGT.CloseProgressWindow;
        end;
    end;

    procedure RestoreeCommerceOrder(Type: Option Restore,Reverse; NewCorrection: Boolean; NewTransactionType: Option "Order",Refund)
    var
        lAmzOrderHead: Record "eCommerce Order Header";
        lAmzOrderLine: Record "eCommerce Order Line";
        lAmzOrderLineArch: Record "eCommerce Order Line Archive";
    begin
        lAmzOrderHead.TransferFields(Rec);
        lAmzOrderHead.Correction := NewCorrection;
        lAmzOrderHead."Completely Imported" := true;
        if Type = Type::Reverse then begin
            lAmzOrderHead."Transaction Type" := NewTransactionType;
            lAmzOrderHead."Reversed By" := UserId();
        end;
        lAmzOrderHead.Insert(true);

        lAmzOrderLineArch.SetRange("Transaction Type", "Transaction Type");
        lAmzOrderLineArch.SetRange("eCommerce Order Id", "eCommerce Order Id");
        lAmzOrderLineArch.SetRange("Invoice No.", "Invoice No.");
        if lAmzOrderLineArch.FindSet() then begin
            repeat
                lAmzOrderLine.TransferFields(lAmzOrderLineArch);
                if Type = Type::Reverse then
                    lAmzOrderLine."Transaction Type" := NewTransactionType;
                lAmzOrderLine.Insert(true);
            until lAmzOrderLineArch.Next() = 0;

            lAmzOrderHead.CalcFields("Amount Including VAT");
            lAmzOrderHead.Validate("Sales Document Type", lAmzOrderHead."sales document type"::Quote);
            lAmzOrderHead.Validate("VAT Bus. Posting Group");
            lAmzOrderHead.Modify();
        end;

        if Type = Type::Restore then
            Delete(true);
    end;

    procedure CopyToEcomOrder(var pAmzOrderHead: Record "eCommerce Order Header"; NewTransactionType: Option "Order",Refund; NewInvoiceNo: Code[50])
    var
        lAmzOrderLine: Record "eCommerce Order Line";
        lAmzOrderLineArch: Record "eCommerce Order Line Archive";
    begin
        pAmzOrderHead.TransferFields(Rec);
        pAmzOrderHead.Validate("Transaction Type", NewTransactionType);
        if NewInvoiceNo <> '' then
            pAmzOrderHead.Validate("Invoice No.", NewInvoiceNo);
        pAmzOrderHead.Insert(true);
        pAmzOrderHead.Validate("VAT Bus. Posting Group");
        pAmzOrderHead.Modify();

        lAmzOrderLineArch.SetRange("Transaction Type", "Transaction Type");
        lAmzOrderLineArch.SetRange("eCommerce Order Id", "eCommerce Order Id");
        lAmzOrderLineArch.SetRange("Invoice No.", "Invoice No.");
        if lAmzOrderLineArch.FindSet() then
            repeat
                lAmzOrderLine.TransferFields(lAmzOrderLineArch);
                lAmzOrderLine.Validate("Transaction Type", NewTransactionType);
                if NewInvoiceNo <> '' then
                    lAmzOrderLine.Validate("Invoice No.", NewInvoiceNo);
                lAmzOrderLine.Insert(true);
            until lAmzOrderLineArch.Next() = 0;
    end;
}
