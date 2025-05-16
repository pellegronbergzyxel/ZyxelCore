table 50103 "eCommerce Order Header"
{
    // 001. 19-12-17 ZY-LD New fields.
    // 002. 16-01-18 ZY-LD 2017121810000224 - New field.
    // 003. 01-02-18 ZY-LD - Invoice No. was missing, so too many lines was deleted.
    // 004. 13-02-18 ZY-LD New fields.
    // 005. 04-05-18 ZY-LD P0042 - New field.
    // 006. 05-12-18 ZY-LD 2018031910000238 - Field 16, 17, 18 has changed to flowfields.
    // 007. 10-04-19 ZY-LD PO213 - Customer No. is added.
    // 008. 30-05-19 ZY-LD P0236 - New field.
    // 009. 21-04-22 ZY-LD 2022042110000072 - We have seen data from Amazon where "Ship-to Country" = IT and "Export Outside EU" = Yes. Therefore the test has changed.
    // 010. 10-05-22 ZY-LD 000 - Prevent Negative Inventory.
    // 011. 24-05-22 ZY-LD 000 - We did not find the item based on item identifier.
    // 012. 14-06-22 ZY-LD 000 - Validation on Zyxel VAT Registration No.
    // 013. 24-06-22 ZY-LD 000 - Validation of "VAT Bus. Posting Group". can also set errors.
    // 014. 18-08-22 ZY-LD 000 - Magento send "SHIPPING FEE" that we have to take care of on the invoice.
    // 015. 21-09-22 ZY-LD 000 - Ben and Mie has decided to post the orders with "German" VAT in ZNet DK. We mark the orders.
    // 016. 22-09-22 ZY-LD 000 - We will also setup "VAT Posting Setup".
    // 017. 17-10-22 ZY-LD 000 - "Purchaser VAT No. can also contain "Citizen ID".
    // 018. 19-10-22 ZY-LD 000 - Change in "VAT Bus. Posting Group" setup.
    // 019. 04-01-23 ZY-LD 000 - Code has moved from header to lines.
    // 020. 03-03-23 ZY-LD 000 - If an import gets an error, the order is not marked as completely imported. Therefore this extra check.
    // 021. 09-03-23 ZY-LD 000 - Monaco VAT is linked to France.
    // 022. 02-05-23 ZY-LD 000 - GB splie between RHQ and ZNet.
    // 023. 24-05-23 ZY-LD 000 - Give Away Products.
    // 024. 08-06-23 ZY-LD 000 - New fields.
    // 025. 04-08-23 ZY-LD 000 - "Seller Tax Reg. Country" is extended to 30 characters.
    // 026. 15-08-23 ZY-LD 000 - Validation on "Ship-to VAT No.";
    // 027. 17-08-23 ZY-LD 000 - Test of double orders from magento.
    // 028. 30-11-23 ZY-LD 000 - Compensation fee.
    // 029. 14-03-24 ZY-LD 000 - Invoices with "N/A" must wait on the correct invoice. If they are the same it will be deleted. After 7 days it will be posted.
    // 030. 09-09-24 ZY-LD 000 - In some countries there is a domestic reverge charge.

    Caption = 'eCommerce Order Header';
    DataPerCompany = true;
    DrillDownPageID = "eCommerce Orders";
    LookupPageID = "eCommerce Orders";

    fields
    {
        field(1; "eCommerce Order Id"; Code[30])
        {
            Caption = 'eCommerce Order Id';
        }
        field(2; "Marketplace ID"; Code[20])
        {
            Caption = 'Marketplace ID';
            TableRelation = "eCommerce Market Place";

            trigger OnValidate()
            begin
                GetMarketPlace;
                recAmzMktPlace.TestField("Customer No.");
                Validate("Customer No.", recAmzMktPlace."Customer No.");
            end;
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
        field(7; "Ship To City"; Text[50])
        {
            Caption = 'Ship-to City';
        }
        field(8; "Ship To State"; Text[50])
        {
            Caption = 'Ship-to State';
        }
        field(9; "Ship To Country"; Code[10])
        {
            Caption = 'Ship-to Country';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                if "Ship From Country" <> '' then
                    Validate("VAT Bus. Posting Group");
            end;
        }
        field(10; "Ship To Postal Code"; Code[20])
        {
            Caption = 'Ship-to Postal Code';
        }
        field(11; "Ship From City"; Text[50])
        {
            Caption = 'Ship-from City';
        }
        field(12; "Ship From State"; Text[50])
        {
            Caption = 'Ship-from State';
        }
        field(13; "Ship From Country"; Code[10])
        {
            Caption = 'Ship-from Country';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                Validate("Location Code");
                if "Ship To Country" <> '' then
                    Validate("VAT Bus. Posting Group");
            end;
        }
        field(14; "Ship From Postal Code"; Code[20])
        {
            Caption = 'Ship-from Postal Code';

            trigger OnValidate()
            begin
                Validate("Location Code");
            end;
        }
        field(15; "Ship From Tax Location Code"; Code[20])
        {
            Caption = 'Ship-from Tax Location Code';
        }
        field(16; "Total (Inc. Tax)"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line"."Total (Inc. Tax)" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                            "Invoice No." = field("Invoice No.")));
            Caption = 'Total (Inc. Tax)';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Total Tax Amount"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line"."Total Tax Amount" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                            "Invoice No." = field("Invoice No.")));
            Caption = 'Total Tax Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Total (Exc. Tax)"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line"."Total (Exc. Tax)" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                            "Invoice No." = field("Invoice No.")));
            Caption = 'Total (Exc. Tax)';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Purchaser VAT No."; Code[20])
        {
            Caption = 'Buyer VAT Reg. No.';
            Editable = false;

            trigger OnValidate()
            begin
                if ("Purchaser VAT No." <> '') or
                   ("Buyer Tax Reg. Type" = "buyer tax reg. type"::"Business Registration")  // 17-10-22 ZY-LD 017
                then
                    "Sell-to Type" := "sell-to type"::Business
                else
                    "Sell-to Type" := "sell-to type"::Consumer;

                //>> 17-10-22 ZY-LD 017
                if "Buyer Tax Reg. Type" = "buyer tax reg. type"::"Citizen ID" then
                    "Sell-to Type" := "sell-to type"::Consumer;
                //<< 17-10-22 ZY-LD 017
            end;
        }
        field(21; "Sent To Intercompany"; Boolean)
        {
            Caption = 'Sent To Intercompany';
        }
        field(22; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            Editable = false;
        }
        field(23; "RHQ Invoice No"; Code[20])
        {
            Caption = 'RHQ Document No.';
            Editable = false;
        }
        field(24; "Invoice Download"; Text[250])
        {
            Caption = 'Invoice Download';
            Editable = false;
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(30; "RHQ Creation Date"; Date)
        {
            Caption = 'Import Date';
        }
        field(31; Open; Boolean)
        {
            Caption = 'Open';
            InitValue = true;
        }
        field(32; Quantity; Integer)
        {
            CalcFormula = sum("eCommerce Order Line".Quantity where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                  "Invoice No." = field("Invoice No.")));
            Caption = 'Quantity';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Unexpected Item"; Boolean)
        {
            CalcFormula = lookup("eCommerce Order Line"."Unexpected Item" where("eCommerce Order Id" = field("eCommerce Order Id"),
                                                                              "Invoice No." = field("Invoice No.")));
            Caption = 'Unexpected Item';
            Description = '19-12-17 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "Error Description"; Text[250])
        {
            Caption = 'Error Description';
            Description = '19-12-17 ZY-LD 001';
        }
        field(35; "Export Outside EU"; Boolean)
        {
            Caption = 'Export Outside EU';
            Description = '19-12-17 ZY-LD 001';
        }
        field(36; "Tax Type"; Option)
        {
            Caption = 'Tax Type';
            Description = '19-12-17 ZY-LD 001';
            Editable = false;
            OptionCaption = ' ,VAT';
            OptionMembers = " ",VAT;
        }
        field(37; "Tax Calculation Reason Code"; Option)
        {
            Caption = 'Tax Calculation Reason Code';
            Description = '19-12-17 ZY-LD 001';
            Editable = false;
            OptionCaption = 'Not Taxable,Taxable';
            OptionMembers = "Not Taxable",Taxable;
        }
        field(38; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            Description = 'PAB 1.0';
            TableRelation = "VAT Business Posting Group".Code;

            trigger OnValidate()
            var
                recAmzCtryMapTo: Record "eCommerce Country Mapping";
                recAmzCtryMapFrom: Record "eCommerce Country Mapping";
                recVatPostSetup: Record "VAT Posting Setup";
                recVatBusPostGrp: Record "VAT Business Posting Group";
                recCountry: Record "Country/Region";
                recAmzOrderLine: Record "eCommerce Order Line";
            begin
                // We have skipped our own "VAT Bus. Posting Group" setup, and follow eCommerce, wether it right or not.
                if recAmzCtryMapTo.Get("Customer No.", "Ship To Country") and
                    (recAmzCtryMapTo."Country Dimension" <> '') and
                    (recAmzCtryMapTo."VAT Bus. Posting Group" <> '')
                then begin
                    Validate("Country Dimension", recAmzCtryMapTo."Country Dimension");

                    recAmzCtryMapFrom.Get("Customer No.", "Ship From Country");
                    recAmzCtryMapFrom.TestField("Country Dimension");
                    recAmzCtryMapFrom.TestField("VAT Bus. Posting Group");

                    GetMarketPlace;
                    recCountry.Get("Ship To Country");
                    if recCountry."EU Country/Region Code" <> '' then begin  //<< 21-04-22 ZY-LD 009
                        if "Sell-to Type" = "sell-to type"::Consumer then begin
                            case "Tax Address Role" of
                                "tax address role"::"Ship-from":
                                    "VAT Bus. Posting Group" := recAmzCtryMapFrom."VAT Bus. Posting Group";
                                "tax address role"::"Ship-to":
                                    "VAT Bus. Posting Group" := recAmzCtryMapTo."VAT Bus. Posting Group";
                            end;

                            if "Tax Calculation Reason Code" = "tax calculation reason code"::"Not Taxable" then begin
                                recAmzOrderLine.SetRange("Transaction Type", "Transaction Type");  // 17-04-23 ZY-LD 000
                                recAmzOrderLine.SetRange("eCommerce Order Id", "eCommerce Order Id");
                                recAmzOrderLine.SetRange("Invoice No.", "Invoice No.");
                                if recAmzOrderLine.FindSet(true) then
                                    repeat
                                        recAmzOrderLine.Validate("VAT Prod. Posting Group", '0');
                                        recAmzOrderLine.Modify(true);
                                    until recAmzOrderLine.Next() = 0;
                            end;
                        end else begin  // Business
                            //>> 09-09-24 ZY-LD 030
                            if (recAmzCtryMapFrom."Ship-to Country Code" = recAmzCtryMapFrom."Ship-to Country Code") and
                               (recAmzCtryMapFrom."Domestic Reverse Charge")
                            then
                                "VAT Bus. Posting Group" := recAmzMktPlace."VAT Bus Posting Group (EU)"
                            else begin  //<< 09-09-24 ZY-LD 030
                                if "Ship To Country" = "Ship From Country" then begin
                                    case "Tax Address Role" of
                                        "tax address role"::"Ship-from":
                                            "VAT Bus. Posting Group" := recAmzCtryMapFrom."VAT Bus. Posting Group";
                                        "tax address role"::"Ship-to":
                                            "VAT Bus. Posting Group" := recAmzCtryMapTo."VAT Bus. Posting Group";
                                    end;
                                end else
                                    if "Tax Rate" = 0 then
                                        "VAT Bus. Posting Group" := recAmzMktPlace."VAT Bus Posting Group (EU)"
                                    else
                                        case "Tax Address Role" of
                                            "tax address role"::"Ship-from":
                                                "VAT Bus. Posting Group" := recAmzCtryMapFrom."VAT Bus. Posting Group";
                                            "tax address role"::"Ship-to":
                                                "VAT Bus. Posting Group" := recAmzCtryMapTo."VAT Bus. Posting Group";
                                        end;
                            end;
                        end;
                    end else begin  // Export outside of EU
                                    //>> 09-03-23 ZY-LD 021
                        if recAmzCtryMapTo."Use Country VAT Bus. Post Grp." then
                            "VAT Bus. Posting Group" := recAmzCtryMapTo."VAT Bus. Posting Group"
                        else  //<< 09-03-23 ZY-LD 021
                            "VAT Bus. Posting Group" := recAmzMktPlace."VAT Bus Posting Group (No VAT)";
                    end;
                end;

                // VAT Bus. Posting Group
                /*IF ("Customer No." <> '') AND ("Ship To Country" <> '') AND ("Ship From Country" <> '') THEN BEGIN
                  recAmzCtryMapTo.SETAUTOCALCFIELDS("Threshold Posted","Threshold Posted Archive");
                  IF recAmzCtryMapTo.GET("Customer No.","Ship To Country") AND
                     (recAmzCtryMapTo."Country Dimension" <> '') AND
                     (recAmzCtryMapTo."VAT Bus. Posting Group" <> '')
                  THEN BEGIN
                    VALIDATE("Country Dimension",recAmzCtryMapTo."Country Dimension");
                
                    recAmzCtryMapFrom.GET("Customer No.","Ship From Country");
                    recAmzCtryMapFrom.TESTFIELD("Country Dimension");
                    recAmzCtryMapFrom.TESTFIELD("VAT Bus. Posting Group");
                
                    GetMarketPlace;
                    //>> 21-04-22 ZY-LD 009
                    //IF NOT "Export Outside EU" THEN BEGIN
                    recCountry.GET("Ship To Country");
                    IF recCountry."EU Country/Region Code" <> '' THEN BEGIN  //<< 21-04-22 ZY-LD 009
                      IF "Sell-to Type" = "Sell-to Type"::Consumer THEN BEGIN
                        IF "Ship To Country" = "Ship From Country" THEN BEGIN
                          IF "Ship From Country" <> recAmzMktPlace."Main Market Place ID" THEN
                            "VAT Bus. Posting Group" := recAmzCtryMapFrom."VAT Bus. Posting Group"
                          ELSE
                            "VAT Bus. Posting Group" := recAmzMktPlace."VAT Bus Post. Grp. (Ship-From)"  // Is the same as (Ship-to)
                        END ELSE BEGIN
                          IF recAmzCtryMapTo."Ship-to VAT No." <> '' THEN BEGIN  // ZNet has a VAT No. in the country
                            //>> 20-10-22 ZY-LD xxx
                            "VAT Bus. Posting Group" := recAmzCtryMapTo."VAT Bus. Posting Group";
                            {IF "Ship To Country" = recAmzMktPlace."Main Market Place ID" THEN
                              "VAT Bus. Posting Group" := recAmzCtryMapTo."VAT Bus. Posting Group"
                            ELSE BEGIN
                              "VAT Bus. Posting Group" := recAmzCtryMapFrom."VAT Bus. Posting Group"
                            END;}
                            //<< 20-10-22 ZY-LD xxx
                          END ELSE BEGIN
                            IF (recAmzCtryMapTo."Threshold Posted" + recAmzCtryMapTo."Threshold Posted Archive") <= recAmzCtryMapTo."Threshold Amount" THEN BEGIN
                              IF "Ship From Country" <> recAmzMktPlace."Main Market Place ID" THEN BEGIN
                                recAmzCtryMapFrom.TESTFIELD("VAT Bus. Posting Group");
                                "VAT Bus. Posting Group" := recAmzCtryMapFrom."VAT Bus. Posting Group"
                              END ELSE BEGIN
                                //>> 19-10-22 ZY-LD 018
                                //"VAT Bus. Posting Group" := recAmzMktPlace."VAT Bus Post. Grp. (Ship-From)"
                                CASE "Tax Address Role" OF
                                  "Tax Address Role"::"Ship-from" : "VAT Bus. Posting Group" := recAmzCtryMapFrom."VAT Bus. Posting Group";
                                  "Tax Address Role"::"Ship-to" : "VAT Bus. Posting Group" := recAmzCtryMapTo."VAT Bus. Posting Group";
                                END;
                                //<< 19-10-22 ZY-LD 018
                              END;
                            END ELSE BEGIN
                              recAmzCtryMapTo."Threshold Reached" := TRUE;
                              recAmzCtryMapTo."Threshold Reached Date" := TODAY;
                              recAmzCtryMapTo.MODIFY;
                              "Error Description" := STRSUBSTNO(Text002,"Ship To Country");
                            END;
                          END;
                        END;
                      END ELSE BEGIN  // Business
                        IF ("Ship To Country" <> "Ship From Country") OR
                            (("Ship To Country" = "Ship From Country") AND recAmzCtryMapTo."Use Reverce Charge - DOM Bus")
                        THEN
                          "VAT Bus. Posting Group" := recAmzMktPlace."VAT Bus Posting Group (EU)"
                        ELSE
                          IF "Ship From Country" <> recAmzMktPlace."Main Market Place ID" THEN BEGIN
                            recAmzCtryMapFrom.TESTFIELD("VAT Bus. Posting Group");
                            "VAT Bus. Posting Group" := recAmzCtryMapFrom."VAT Bus. Posting Group"
                          END ELSE
                            "VAT Bus. Posting Group" := recAmzMktPlace."VAT Bus Post. Grp. (Ship-From)"  // Is the same as (Ship-to)
                      END;
                    END ELSE BEGIN  // ExportOutsideEU
                      CASE "Sell-to Type" OF
                        "Sell-to Type"::Consumer : "VAT Bus. Posting Group" := recAmzMktPlace."VAT Bus Posting Group (No VAT)";
                        "Sell-to Type"::Business : "VAT Bus. Posting Group" := recAmzMktPlace."VAT Bus Posting Group (No VAT)";
                      END;
                    END;
                
                    IF recVatPostSetup.GET("VAT Bus. Posting Group",gVATProdPostingGroup) THEN
                      IF (recVatPostSetup."VAT %" <> "Tax Rate") AND
                          (recVatPostSetup."VAT Calculation Type" <> recVatPostSetup."VAT Calculation Type"::"Reverse Charge VAT")
                      THEN
                        CASE "Tax Address Role" OF
                          "Tax Address Role"::"Ship-to" : "VAT Bus. Posting Group" := recAmzCtryMapTo."VAT Bus. Posting Group";
                          "Tax Address Role"::"Ship-from" : "VAT Bus. Posting Group" := recAmzCtryMapFrom."VAT Bus. Posting Group";
                        END;
                
                    IF ("VAT Bus. Posting Group" <> '') AND
                       NOT recVatBusPostGrp.GET("VAT Bus. Posting Group")
                    THEN BEGIN
                      recVatBusPostGrp.INIT;
                      recVatBusPostGrp.Code := "VAT Bus. Posting Group";
                      recVatBusPostGrp.Description := Text003;
                      recVatBusPostGrp.INSERT(TRUE);
                
                      //>> 22-09-22 ZY-LD 016
                      recVatPostSetup.INIT;
                      recVatPostSetup.VALIDATE("VAT Bus. Posting Group","VAT Bus. Posting Group");
                      recVatPostSetup.VALIDATE("VAT Prod. Posting Group",'0');
                      recVatPostSetup.VALIDATE("VAT Identifier",'VAT0');
                      recVatPostSetup.INSERT(TRUE);
                
                      recVatPostSetup.RESET;
                      recVatPostSetup.INIT;
                      recVatPostSetup.VALIDATE("VAT Bus. Posting Group","VAT Bus. Posting Group");
                      recVatPostSetup.VALIDATE("VAT Prod. Posting Group",'VAT');
                      recVatPostSetup.INSERT(TRUE);
                      //<< 22-09-22 ZY-LD 016
                    END;
                  END;
                
                  IF ("VAT Bus. Posting Group" <> xRec."VAT Bus. Posting Group") AND (xRec."VAT Bus. Posting Group" <> '') THEN BEGIN
                    recAmzLine.SETRANGE("eCommerce Order Id","eCommerce Order Id");
                    recAmzLine.SETRANGE("Invoice No.","Invoice No.");
                    IF recAmzLine.FINDSET(TRUE) THEN BEGIN
                      MODIFY;
                      REPEAT
                        recAmzLine.VALIDATE("VAT Prod. Posting Group",recAmzMktPlace."VAT Prod. Posting Group");
                        recAmzLine.MODIFY(TRUE);
                      UNTIL recAmzLine.Next() = 0;
                    END;
                
                    ValidateDocument;
                    Modify(true);
                  END;
                END;*/
            end;
        }
        field(39; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Description = '16-01-18 ZY-LD 002';
            TableRelation = Location;

            trigger OnValidate()
            begin
                GetMarketPlace;
                if recAmzLocation.Get("Ship From Country", "Ship From Postal Code") then begin
                    recAmzLocation.TestField("Location Code");
                    "Location Code" := recAmzLocation."Location Code";

                    if recAmzLocation."Customer No." <> '' then
                        Validate("Customer No.", recAmzLocation."Customer No.")
                    else
                        Validate("Customer No.", recAmzMktPlace."Customer No.");
                end else begin
                    "Location Code" := recAmzMktPlace."Location Code";
                    Validate("Customer No.", recAmzMktPlace."Customer No.");
                end;
            end;
        }
        field(40; "Country Dimension"; Code[10])
        {
            Caption = 'Country Dimension';
            Description = '26-01-18 ZY-LD 002';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          "Dimension Value Type" = const(Standard),
                                                          Blocked = const(false));
        }
        field(41; "Sell-to Type"; Option)
        {
            Caption = 'Sell-to Type';
            Description = '26-01-18 ZY-LD 002';
            Editable = false;
            OptionCaption = 'Consumer,Business';
            OptionMembers = Consumer,Business;
        }
        field(45; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = '10-04-19 ZY-LD 006';
            Editable = false;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                Validate("VAT Bus. Posting Group");
            end;
        }
        field(46; "VAT Registration No. Zyxel"; Code[20])
        {
            Caption = 'VAT Registration No. Zyxel';
            Description = '30-05-19 ZY-LD 008';
            Editable = false;

            trigger OnValidate()
            begin
                if "VAT Registration No. Zyxel" = '' then
                    if ("Customer No." <> '') and ("VAT Bus. Posting Group" <> '') then begin
                        recAmzCountryMap.SetRange("Customer No.", "Customer No.");
                        recAmzCountryMap.SetRange("VAT Bus. Posting Group", "VAT Bus. Posting Group");
                        if recAmzCountryMap.FindFirst() then
                            "VAT Registration No. Zyxel" := recAmzCountryMap."Ship-to VAT No."
                        else
                            if "VAT Bus. Posting Group" = 'EU' then begin
                                recAmzCountryMap.Reset();
                                if recAmzCountryMap.Get("Customer No.", "Ship From Country") then
                                    "VAT Registration No. Zyxel" := recAmzCountryMap."Ship-to VAT No.";
                            end;

                    end;
            end;
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
        field(51; "Completely Imported"; Boolean)
        {
            Caption = 'Completely Imported';
        }
        field(52; "Tax Address Role"; Option)
        {
            Caption = 'Tax Address Role';
            Editable = false;
            OptionMembers = " ","Ship-from","Ship-to";
            trigger OnValidate()
            begin
                VALIDATE("VAT Bus. Posting Group");
            end;
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
            TableRelation = "Country/Region";
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
        field(58; "Seller Tax Reg. Country"; Code[10])
        {
            Caption = 'Seller VAT Reg. Country';
            TableRelation = "Country/Region";
        }
        field(59; "Ship-to Tax Location Code"; Code[30])
        {
            Caption = 'Ship-to Tax Location Code';
        }
        field(60; "German VAT Reg. No."; Boolean)
        {
            Caption = 'Foreign VAT Reg. No.';
        }
        field(61; Amount; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line".Amount where("Transaction Type" = field("Transaction Type"),
                                                                "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                "Invoice No." = field("Invoice No.")));
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Tax Amount"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line"."Tax Amount" where("Transaction Type" = field("Transaction Type"),
                                                                      "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                      "Invoice No." = field("Invoice No.")));
            Caption = 'Tax Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Amount Including VAT"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line"."Amount Including VAT" where("Transaction Type" = field("Transaction Type"),
                                                                                "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                "Invoice No." = field("Invoice No.")));
            Caption = 'Amount Including VAT';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Item Excl. VAT"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line"."Total (Exc. Tax)" where("Transaction Type" = field("Transaction Type"),
                                                                            "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                            "Invoice No." = field("Invoice No.")));
            Caption = 'Item Excl. VAT';
            FieldClass = FlowField;
        }
        field(65; "Shipping Excl. VAT"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line"."Total Shipping (Exc. Tax)" where("Transaction Type" = field("Transaction Type"),
                                                                                     "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                     "Invoice No." = field("Invoice No.")));
            Caption = 'Shipping Excl. VAT';
            FieldClass = FlowField;
        }
        field(66; "Promotion Excl. VAT"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line"."Total Promo (Exc. Tax)" where("Transaction Type" = field("Transaction Type"),
                                                                                  "eCommerce Order Id" = field("eCommerce Order Id"),
                                                                                  "Invoice No." = field("Invoice No.")));
            Caption = 'Promotion Excl. VAT';
            FieldClass = FlowField;
        }
        field(67; Correction; Boolean)
        {
            Caption = 'Correction';
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
        field(71; "Warehouse Code"; Code[10])
        {
            Caption = 'Warehouse Code';
            TableRelation = "eCommerce Warehouse";
        }
        field(72; "Import Source Type"; Option)
        {
            Caption = 'Import Source Type';
            OptionCaption = ' ,Tax Library Document,eCommerce Fulfilled Shipment,FBA Customer Return';
            OptionMembers = " ","Tax Library Document","eCommerce Fulfilled Shipment","FBA Customer Return";
        }
        field(73; "Sales Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Sales Document Type';
            Editable = false;

            trigger OnValidate()
            begin
                if "Sales Document Type" = "sales document type"::Quote then begin
                    case "Transaction Type" of
                        "Transaction Type"::Order:
                            "Sales Document Type" := "Sales Document Type"::Invoice;
                        "Transaction Type"::Refund:
                            "Sales Document Type" := "Sales Document Type"::"Credit Memo";
                    end;

                    if ("Transaction Type" = "transaction type"::Order) and ("Amount Including VAT" < 0) then
                        "Sales Document Type" := "sales document type"::"Credit Memo";
                    if not Modify() then;
                end;
            end;
        }
        field(74; "Item Amount Incl. VAT"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line"."Total (Inc. Tax)" where("Transaction Type" = field("Transaction Type"),
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
            Description = '08-06-23 ZY-LD 024';
            Editable = false;
            OptionCaption = ' ,Seller,Marketplace';
            OptionMembers = " ",Seller,Marketplace;

            trigger OnValidate()
            var
                recEcomOrderLine: Record "eCommerce Order Line";
                recVatPosingSetup: Record "VAT Posting Setup";

            begin
                recEcomOrderLine.SETRANGE("Transaction Type", "Transaction Type");
                recEcomOrderLine.SETRANGE("eCommerce Order Id", "eCommerce Order Id");
                recEcomOrderLine.SETRANGE("Invoice No.", "Invoice No.");
                IF recEcomOrderLine.FINDFIRST THEN BEGIN
                    IF recVatPosingSetup.GET("Alt. VAT Bus. Posting Group", recEcomOrderLine."VAT Prod. Posting Group") THEN
                        VALIDATE("Alt. Tax Rate", recVatPosingSetup."VAT %")
                    ELSE
                        VALIDATE("Alt. Tax Rate", 0);

                    recAmzMktPlace.GET("Marketplace ID");
                    REPEAT
                        recEcomOrderLine."VAT Prod. Posting Group" := recAmzMktPlace."VAT Prod. Posting Group";
                        recEcomOrderLine.MODIFY(TRUE);
                    UNTIL recEcomOrderLine.NEXT = 0;
                END;
                VALIDATE("Prices Including VAT", "Alt. VAT Bus. Posting Group" <> '');
                IF "Alt. VAT Bus. Posting Group" <> '' THEN BEGIN
                    recAmzCountryMap.GET(recAmzMktPlace."Customer No.", "Ship From Country");
                    VALIDATE("Alt. VAT Reg. No. Zyxel", recAmzCountryMap."Ship-to VAT No.");
                END ELSE
                    VALIDATE("Alt. VAT Reg. No. Zyxel", '');
            end;
        }
        field(78; "Tax Reporting Scheme"; Code[20])
        {
            Caption = 'Tax Reporting Scheme';
            Description = '08-06-23 ZY-LD 024';
            Editable = false;
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
        key(Key2; "RHQ Creation Date", "Marketplace ID", "Transaction Type", Open, "Completely Imported")
        {
        }
        key(Key3; "Transaction Type", "Import Source Type", "eCommerce Order Id", "Invoice No.", "Completely Imported")
        {
        }
        key(Key4; "Sales Document Type", "eCommerce Order Id", "Invoice No.")
        {
        }
    }

    trigger OnDelete()
    var
        receCommerceSalesLineBuffer: Record "eCommerce Order Line";
    begin
        receCommerceSalesLineBuffer.SetRange("Transaction Type", "Transaction Type");
        receCommerceSalesLineBuffer.SetRange("eCommerce Order Id", "eCommerce Order Id");
        receCommerceSalesLineBuffer.SetRange("Invoice No.", "Invoice No.");  // 01-02-18 ZY-LD 003
        if receCommerceSalesLineBuffer.FindSet then begin
            repeat
                receCommerceSalesLineBuffer.Delete(true);
            until receCommerceSalesLineBuffer.Next() = 0;
        end;
    end;

    trigger OnInsert()
    begin
        "RHQ Creation Date" := Today;
        //>> 10-04-19 ZY-LD 007
        if "Customer No." = '' then begin
            GetMarketPlace;
            recAmzMktPlace.TestField("Customer No.");
            Validate("Customer No.", recAmzMktPlace."Customer No.");
        end;
        //<< 10-04-19 ZY-LD 007
    end;

    var
        recAmzMktPlace: Record "eCommerce Market Place";
        recAmzLocation: Record "eCommerce Location Code";
        Text001: Label '"%1" %2 does not exist.';
        Text002: Label 'Treshold has been reached, but we hav no VAT-no. in %1.';
        recAmzLine: Record "eCommerce Order Line";
        recVatBusPostGrp: Record "VAT Business Posting Group";
        recAmzCountryMap: Record "eCommerce Country Mapping";
        gVATProdPostingGroup: Code[10];
        Text003: Label 'New eCommerce Grp.';

    procedure ValidateDocument()
    var
        recAmzOrderHead: Record "eCommerce Order Header";
        recAmzOrderLine: Record "eCommerce Order Line";
        recAmzOrderLine2: Record "eCommerce Order Line";
        prevAmzOrderLine: Record "eCommerce Order Line";
        recAmzArchHead: Record "eCommerce Order Archive";
        recAmzOrderLineArch: Record "eCommerce Order Line Archive";
        recItem: Record Item;
        recItemIdent: Record "Item Identifier";
        recVatPostSetup: Record "VAT Posting Setup";
        recSalesHead: Record "Sales Header";
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
        recAmzCtryMapTo: Record "eCommerce Country Mapping";
        recGenLedgSetup: Record "General Ledger Setup";
        recAmzCtryMap: Record "eCommerce Country Mapping";
        recEcomSetup: Record "eCommerce Setup";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        ZGT: Codeunit "ZyXEL General Tools";
        VatBusPostGrp: Code[20];
        NAPeriod: Integer;
        lText001: Label '"%1" must not be blank.';
        lText002: Label '"%1" %2 (ASIN: %3) should be created as "Item Identifier".\Please contact the eCommerce Team.';
        lText003: Label '"%1" %2 was not found.';
        lText004: Label 'Unknown Transaction Type on Order ID: %1.';
        lText005: Label 'Marketplace "%1" is inactive.';
        lText006: Label '"%1" has been posted as %2 %3.';
        lText007: Label '"%1" has been created as %2, but not posted.';
        lText008: Label 'Invoice';
        lText009: Label 'Cr. Memo';
        lText010: Label 'Due to the "Market Place Setup" it is only allowed to export to the countries "%1" outside of EU.';
        lText011: Label 'Export outside EU is not allowed.';
        lText012: Label '"%1" is zero.';
        lText013: Label 'The %1 does not exist."%2": %3; "%4": %5';
        lText014: Label 'The value in "%1.%2" is missing.';
        lText015: Label 'Posting date %1 is not allowed. Only dates in the period %2..%3 is allowed.';
        lText016: Label 'Item No. %1 has negative inventory.';
        lText017: Label 'Item No. %1 was not found based on "Item Identifiers".';
        lText018: Label '"%1" %2 belongs to %3 and must be posted there.';
        lText019: Label 'Blank "%1" with a date before 01-06-22 must be posted in %2.';
        lText020: Label '"%1"."%2" must not be blank.';
        lText021: Label '"%1" is inactive on the Market Place.';
        lText022: Label 'The order is not completely imported.';
        lText023: Label '"%1" %2 must not be negative.';
        lText024: Label 'Possibility of duplicate lines.';
        lText025: Label 'Blank "%1" with a date before 26-05-23 must be posted in %2.';
        lText026: Label 'The order has been posted in "%1".';
        lText027: Label 'The order has previous been posted as %3 "%1" %2. Posting date %4 with same invoice no.';
        lText028: Label 'Identical order has been located as "%1" %2.';
        lText029: Label '"%1" must not be zero.';
        lText030: Label 'N/A document is waiting for a real invoice. The invoice will be released and posted on %1. ("N/A Retention Period2 calculation, see setup)';
        lText031: Label 'Document has been deleted.';
    begin
        recAmzMktPlace.Get("Marketplace ID");
        CalcFields("Amount Including VAT", "Tax Amount");
        "Error Description" := '';

        if not "Completely Imported" then
            "Error Description" := lText022;

        //>> 17-08-23 ZY-LD 027
        IF "Error Description" = '' THEN
            IF STRPOS("Marketplace ID", 'MAGENTO') <> 0 THEN BEGIN
                recAmzArchHead.SETRANGE("Transaction Type", "Transaction Type");
                recAmzArchHead.SETRANGE("ecommerce Order Id", "ecommerce Order Id");
                IF recAmzArchHead.FINDSET THEN
                    REPEAT
                        IF STRPOS(recAmzArchHead."Invoice No.", "Invoice No.") <> 0 THEN
                            "Error Description" := STRSUBSTNO(lText027, FIELDCAPTION("Invoice No."), recAmzArchHead."Invoice No.", "Transaction Type", recAmzArchHead."Posting Date");
                    UNTIL recAmzArchHead.NEXT = 0;

                recAmzOrderHead.SETRANGE("Transaction Type", "Transaction Type");
                recAmzOrderHead.SETRANGE("ecommerce Order Id", "ecommerce Order Id");
                recAmzOrderHead.SETFILTER("Invoice No.", '<>%1', "Invoice No.");
                IF recAmzOrderHead.FINDSET THEN
                    REPEAT
                        IF STRPOS(recAmzOrderHead."Invoice No.", "Invoice No.") <> 0 THEN
                            "Error Description" := STRSUBSTNO(lText028, FIELDCAPTION("Invoice No."), recAmzOrderHead."Invoice No.");
                    UNTIL recAmzOrderHead.NEXT = 0;
            END;
        //<< 17-08-23 ZY-LD 027

        if "Error Description" = '' then
            if not recAmzMktPlace.Active then
                "Error Description" := StrSubstNo(lText005, "Marketplace ID");

        if "Error Description" = '' then
            if not recAmzMktPlace."Settle eCommerce Documents" then
                "Error Description" := StrSubstNo(lText021, recAmzMktPlace.FieldCaption("Settle eCommerce Documents"), "Marketplace ID");

        //>> 14-06-22 ZY-LD 012
        if "Error Description" = '' then
            IF ("VAT Registration No. Zyxel" = '') AND ("Tax Collection Respons." = "Tax Collection Respons."::Seller) THEN BEGIN
                //"Error Description" := STRSUBSTNO(lText001,FIELDCAPTION("VAT Registration No. Zyxel"))
                //>> 15-08-23 ZY-LD 026
                IF "Tax Amount" <> 0 THEN
                    "Error Description" := STRSUBSTNO(lText001, FIELDCAPTION("VAT Registration No. Zyxel"))
                ELSE BEGIN
                    IF NOT recAmzCtryMapTo.GET("Customer No.", "Ship To Country") THEN
                        CLEAR(recAmzCtryMapTo);

                    IF NOT recAmzCtryMapTo."Post Without Zyxel VAT Reg. No" THEN
                        "Error Description" := STRSUBSTNO(lText001, FIELDCAPTION("VAT Registration No. Zyxel"))
                END;
                //<< 15-08-23 ZY-LD 026
            END;

        //>> 13-11-23 ZY-LD 028
        IF "Error Description" = '' THEN
            IF ((recAmzMktPlace."Tax Exception Start Date" = 0D) OR (recAmzMktPlace."Tax Exception End Date" = 0D)) OR
               ((WORKDATE < recAmzMktPlace."Tax Exception Start Date") OR (WORKDATE > recAmzMktPlace."Tax Exception End Date"))
            THEN
                IF "Sell-to Type" = "Sell-to Type"::Consumer THEN BEGIN
                    IF ("Tax Amount" = 0) AND (NOT "Prices Including VAT") THEN
                        "Error Description" := STRSUBSTNO(lText029, FIELDCAPTION("Tax Amount"));
                END ELSE BEGIN
                    IF ("Ship From Country" = "Ship To Country") AND ("Tax Amount" = 0) AND (NOT "Prices Including VAT") THEN BEGIN
                        IF "Tax Address Role" = "Tax Address Role"::"Ship-from" THEN
                            recAmzCtryMap.GET("Customer No.", "Ship From Country")
                        ELSE
                            recAmzCtryMap.GET("Customer No.", "Ship To Country");
                        IF NOT recAmzCtryMap."Domestic Reverse Charge" THEN
                            "Error Description" := STRSUBSTNO(lText029, FIELDCAPTION("Tax Amount"));
                    END;
                END;
        //<< 13-11-23 ZY-LD 028

        IF "Error Description" = '' THEN  // This is not in NAV. Not sure if it´s relevant.
            if ("VAT Registration No. Zyxel" = '') and ("Tax Collection Respons." = "tax collection respons."::Seller) then
                "Error Description" := StrSubstNo(lText001, FieldCaption("VAT Registration No. Zyxel"));

        if "Error Description" = '' then
            if ZGT.IsZNetCompany then begin
                if "VAT Registration No. Zyxel" in ['686640822', 'ATU76537534', 'ATU86640822', 'BE0691804097', 'CZ684340226', 'DE812743356', 'ESN2764659E', 'FR43834569063', 'IT00203809991', 'NL825611349B01', 'PL5263207801'] then
                    "German VAT Reg. No." := true;  // 21-09-22 ZY-LD 015
                                                    //"Error Description" := STRSUBSTNO(lText018,FieldCaption("VAT Registration No. Zyxel"),"VAT Registration No. Zyxel",ZGT.GetSistersCompanyName(11));
                                                    //>> 02-05-23 ZY-LD 022
                if "VAT Registration No. Zyxel" = 'GB837922400' then begin
                    "German VAT Reg. No." := true;
                    //"Error Description" := STRSUBSTNO(lText018,FieldCaption("VAT Registration No. Zyxel"),"VAT Registration No. Zyxel",ZGT.GetSistersCompanyName(2));

                    recAmzArchHead.ChangeCompany(ZGT.GetSistersCompanyName(1));
                    if recAmzArchHead.Get("Transaction Type", "eCommerce Order Id", "Invoice No.") then
                        "Error Description" := StrSubstNo(lText026, recAmzArchHead.CurrentCompany);
                end;
                //<< 02-05-23 ZY-LD 022

                if "Error Description" = '' then
                    if (("VAT Registration No. Zyxel" = '') and ("Order Date" < 20220601D) and ("Marketplace ID" <> 'TR') and (ZGT.GetSistersCompanyName(11) = 'ZyND DE')) then
                        "Error Description" := StrSubstNo(lText019, FieldCaption("VAT Registration No. Zyxel"), ZGT.GetSistersCompanyName(11));
                // We don´t need this, because we now check in the GB archive.
                //IF (("VAT Registration No. Zyxel" = '') AND ("Order Date" < 20232705D) AND ("Marketplace ID" <> 'TR') AND (ZGT.GetSistersCompanyName(2) = 'ZyND UK')) THEN
                //  "Error Description" := STRSUBSTNO(lText019,FieldCaption("VAT Registration No. Zyxel"),ZGT.GetSistersCompanyName(2));
            end else //>> 02-05-23 ZY-LD 022
                if "VAT Registration No. Zyxel" = 'GB344658576' then begin
                    "German VAT Reg. No." := true;
                    "Error Description" := StrSubstNo(lText018, FieldCaption("VAT Registration No. Zyxel"), "VAT Registration No. Zyxel", ZGT.GetSistersCompanyName(2));
                end;
        //<< 02-05-23 ZY-LD 022
        //<< 14-06-22 ZY-LD 012

        if "Error Description" = '' then
            if "Ship To Country" = '' then
                "Error Description" := StrSubstNo(lText001, FieldCaption("Ship To Country"));

        if "Error Description" = '' then
            if "Ship From Country" = '' then
                "Error Description" := StrSubstNo(lText001, FieldCaption("Ship From Country"));

        //>> 24-06-22 ZY-LD 013
        if "Error Description" = '' then
            if "VAT Bus. Posting Group" = '' then
                Validate("VAT Bus. Posting Group");
        //<< 24-06-22 ZY-LD 013

        if "Error Description" = '' then begin
            recGenLedgSetup.Get();
            if (WorkDate < recGenLedgSetup."Allow Posting From") or
               ((WorkDate > recGenLedgSetup."Allow Posting To") or (recGenLedgSetup."Allow Posting To" = 0D))
            then
                "Error Description" := StrSubstNo(lText015, WorkDate, recGenLedgSetup."Allow Posting From", recGenLedgSetup."Allow Posting To");
        end;

        if "Error Description" = '' then begin
            if not recAmzCtryMapTo.Get("Customer No.", "Ship To Country") then
                recAmzCtryMapTo.InsertCountryMapping("Marketplace ID", "Ship To Country");

            if recAmzCtryMapTo."Country Dimension" = '' then
                "Error Description" := StrSubstNo(lText014, recAmzCtryMapTo.TableCaption(), recAmzCtryMapTo.FieldCaption("Country Dimension"));
            if recAmzCtryMapTo."VAT Bus. Posting Group" = '' then
                "Error Description" := StrSubstNo(lText014, recAmzCtryMapTo.TableCaption(), recAmzCtryMapTo.FieldCaption("VAT Bus. Posting Group"));
        end;

        if "Error Description" = '' then
            if "Export Outside EU" then
                if recAmzMktPlace."Export Outside EU" then begin
                    if recAmzMktPlace."Export Outside Country Code" <> '' then
                        if StrPos(recAmzMktPlace."Export Outside Country Code", "Ship To Country") = 0 then
                            "Error Description" := StrSubstNo(lText010, recAmzMktPlace."Export Outside Country Code");
                end else
                    "Error Description" := lText011;

        if "Error Description" = '' then
            if "Currency Code" = '' then
                "Error Description" := StrSubstNo(lText001, FieldCaption("Currency Code"));

        if "Error Description" = '' then
            if "Country Dimension" = '' then
                "Error Description" := StrSubstNo(lText001, FieldCaption("Country Dimension"));

        if "Error Description" = '' then
            if ("Transaction Type" <> "transaction type"::Order) and
                ("Transaction Type" <> "transaction type"::Refund)
            then
                "Error Description" := StrSubstNo(lText004, "eCommerce Order Id");

        if not Correction and ("Error Description" = '') then
            if "Transaction Type" = "transaction type"::Order then begin
                recSalesInvHead.SetCurrentkey("Sell-to Customer No.", "External Document No.");
                recSalesInvHead.SetRange("External Document No.", "eCommerce Order Id");
                recSalesInvHead.SetRange("External Invoice No.", "Invoice No.");
                recSalesInvHead.SetRange(Correction, false);
                if recSalesInvHead.FindFirst() then
                    "Error Description" := StrSubstNo(lText006, FieldCaption("eCommerce Order Id"), lText008, recSalesInvHead."No.");
            end;

        if not Correction and ("Error Description" = '') then
            if "Transaction Type" = "transaction type"::Refund then begin
                recSalesCrMemoHead.SetCurrentkey("Sell-to Customer No.", "External Document No.");
                recSalesCrMemoHead.SetRange("External Document No.", "eCommerce Order Id");
                recSalesCrMemoHead.SetRange("External Invoice No.", "Invoice No.");
                recSalesCrMemoHead.SetRange(Correction, false);
                if recSalesCrMemoHead.FindFirst() then
                    "Error Description" := StrSubstNo(lText006, FieldCaption("eCommerce Order Id"), lText009, recSalesCrMemoHead."No.")
            end;

        if "Error Description" = '' then begin
            if "Transaction Type" = "transaction type"::Order then
                recSalesHead.SetRange("Document Type", recSalesHead."document type"::Invoice)
            else
                recSalesHead.SetRange("Document Type", recSalesHead."document type"::"Credit Memo");
            recSalesHead.SetRange("External Document No.", "eCommerce Order Id");
            recSalesHead.SetRange("External Invoice No.", "Invoice No.");
            if recSalesHead.FindFirst() then
                "Error Description" := StrSubstNo(lText007, FieldCaption("eCommerce Order Id"), recSalesHead."Document Type");
        end;

        if "Error Description" = '' then
            if ("Amount Including VAT" = 0) and (not "Give Away Order") then  // 24-05-23 ZY-LD 023
                "Error Description" := StrSubstNo(lText012, FieldCaption("Amount Including VAT"));

        //>> 14-03-24 ZY-LD 029
        if "Error Description" = '' then begin
            if "Invoice No." = 'N/A' then begin
                recAmzArchHead.SetAutoCalcFields("Amount Including VAT");
                recAmzArchHead.SetRange("Transaction Type", "Transaction Type");
                recAmzArchHead.SetRange("eCommerce Order Id", "eCommerce Order Id");
                recAmzArchHead.SetFilter("Invoice No.", '<>%1', 'N/A');
                if recAmzArchHead.FindFirst and (recAmzArchHead."Amount Including VAT" = "Amount Including VAT") then begin
                    Delete(true);
                    Commit;
                    "Error Description" := lText031;
                end else begin
                    recAmzOrderHead.SetAutoCalcFields("Amount Including VAT");
                    recAmzOrderHead.SetRange("Transaction Type", "Transaction Type");
                    recAmzOrderHead.SetRange("eCommerce Order Id", "eCommerce Order Id");
                    recAmzOrderHead.SetFilter("Invoice No.", '<>%1', 'N/A');
                    If recAmzOrderHead.FindFirst and (recAmzOrderHead."Amount Including VAT" = "Amount Including VAT") then begin
                        Delete(true);
                        Commit;
                        "Error Description" := lText031;
                    end else begin
                        recEcomSetup.get;
                        recEcomSetup.testfield("N/A Retention Period");
                        NAPeriod := CalcDate(recEcomSetup."N/A Retention Period", today) - today;
                        if (today - "RHQ Creation Date" <= NAPeriod) or (today - "Order Date" <= NAPeriod) then begin
                            if (today - "RHQ Creation Date") < (today - "Order Date") then
                                "Error Description" := StrSubstNo(lText030, "RHQ Creation Date" + NAPeriod)
                            else
                                "Error Description" := StrSubstNo(lText030, "Order Date" + NAPeriod);
                        end;
                    end;
                end;
            end
        end;
        //<< 14-03-24 ZY-LD 029

        // Line
        if "Error Description" = '' then begin
            recAmzOrderLine.SetRange("eCommerce Order Id", "eCommerce Order Id");
            recAmzOrderLine.SetRange("Invoice No.", "Invoice No.");
            recAmzOrderLine.SetAutoCalcFields("VAT Bus. Posting Group");
            if recAmzOrderLine.FindSet() then
                repeat
                    recItem.SetRange("Location Filter", "Location Code");  // 10-05-22 ZY-LD 010
                    recItem.SetAutoCalcFields(Inventory);  // 10-05-22 ZY-LD 010

                    //>> 18-08-22 ZY-LD 014
                    if "Error Description" = '' then
                        if (recAmzOrderLine."Item No." <> recAmzMktPlace."Code for Shipping Fee") and
                           (recAmzOrderLine."Item No." <> recAmzMktPlace."Code for Compensation Fee") and  // 30-11-23 ZY-LD 028
                           (recAmzOrderLine."Item No." <> recAmzMktPlace."Code for Discount")
                        then  //<< 18-08-22 ZY-LD 014
                            if StrLen(recAmzOrderLine."Item No.") > MaxStrLen(recItem."No.") then begin
                                recItemIdent.SetRange(ExtendedCodeZX, recAmzOrderLine."Item No.");
                                if recItemIdent.FindFirst() then begin
                                    if not recItem.Get(recItemIdent."Item No.") then  // 24-05-22 ZY-LD 011
                                        "Error Description" := StrSubstNo(lText017, recItemIdent."Item No.");  // 24-05-22 ZY-LD 011
                                end else
                                    "Error Description" := StrSubstNo(lText002, recAmzOrderLine.FieldCaption("Item No."), recAmzOrderLine."Item No.", recAmzOrderLine.ASIN)
                            end else begin
                                recItemIdent.SetRange(ExtendedCodeZX, recAmzOrderLine."Item No.");
                                if recItemIdent.FindFirst() then begin
                                    if not recItem.Get(recItemIdent."Item No.") then  // 24-05-22 ZY-LD 011
                                        "Error Description" := StrSubstNo(lText017, recItemIdent."Item No.");  // 24-05-22 ZY-LD 011
                                end else
                                    if not recItem.Get(recAmzOrderLine."Item No.") then
                                        "Error Description" := StrSubstNo(lText002, recAmzOrderLine.FieldCaption("Item No."), recAmzOrderLine."Item No.", recAmzOrderLine.ASIN);
                            end;

                    if "Error Description" = '' then
                        if "Tax Calculation Reason Code" = "tax calculation reason code"::Taxable then begin
                            IF "Alt. VAT Bus. Posting Group" <> '' THEN
                                VatBusPostGrp := "Alt. VAT Bus. Posting Group"
                            ELSE
                                VatBusPostGrp := "VAT Bus. Posting Group";
                            if not recVatPostSetup.Get(VatBusPostGrp, recAmzOrderLine."VAT Prod. Posting Group") then begin
                                "Error Description" :=
                                  StrSubstNo(lText013,
                                    recVatPostSetup.TableCaption(),
                                    FieldCaption("VAT Bus. Posting Group"), VatBusPostGrp,
                                    recAmzOrderLine.FieldCaption("VAT Prod. Posting Group"), recAmzOrderLine."VAT Prod. Posting Group");
                            end else begin
                                if recVatPostSetup."Sales VAT Account" = '' then
                                    "Error Description" := StrSubstNo(lText020, recVatPostSetup.TableCaption(), recVatPostSetup.FieldCaption("Sales VAT Account"));
                                /*ELSE
                                  IF recVatPostSetup."Purchase VAT Account" = '' THEN
                                    "Error Description" := STRSUBSTNO(lText020,recVatPostSetup.TABLECAPTION,recVatPostSetup.FieldCaption("Purchase VAT Account"));*/
                            end;
                        end;

                    //>> 10-05-22 ZY-LD 010
                    if "Error Description" = '' then
                        if ("Transaction Type" = "transaction type"::Order) and (recItem."No." <> '') then
                            if (recItem.PreventNegativeInventory or ItemLogisticEvent.PreventNegativeInventory(recItem."No.", "Location Code", true)) and
                               (recItem.Inventory - recAmzOrderLine.Quantity < 0)
                            then
                                "Error Description" := StrSubstNo(lText016, recItem."No.");
                    //<< 10-05-22 ZY-LD 010

                    //>> 04-01-23 ZY-LD 019
                    if "Error Description" = '' then
                        if ("Transaction Type" = "transaction type"::Order) and
                           ("Amount Including VAT" < 0) and
                           (recAmzLine."Line Discount Excl. Tax" <> 0)
                       then
                            "Error Description" := StrSubstNo(lText023, FieldCaption("Transaction Type"), "Transaction Type");
                    //<< 04-01-23 ZY-LD 019

                    //>> 03-03-23 ZY-LD 020  - 27-07-23 ZY-LD - It runs correct now, so we don´t need this.
                    /*if ("Error Description" = '') and (not Correction) then
                        if (recAmzOrderLine."Item No." = prevAmzOrderLine."Item No.") and
                           (recAmzOrderLine.Quantity = prevAmzOrderLine.Quantity)
                        then begin
                            if recAmzOrderLine."Transaction Type" = recAmzOrderLine."transaction type"::Refund then begin
                                recAmzOrderLineArch.SetRange("eCommerce Order Id", recAmzOrderLine."eCommerce Order Id");
                                recAmzOrderLineArch.SetRange("Transaction Type", recAmzOrderLineArch."transaction type"::Order);
                                recAmzOrderLineArch.CalcSums(Quantity);

                                recAmzOrderLine2.SetRange("Transaction Type", recAmzOrderLine."Transaction Type");
                                recAmzOrderLine2.SetRange("eCommerce Order Id", recAmzOrderLine."eCommerce Order Id");
                                recAmzOrderLine2.SetRange("Invoice No.", recAmzOrderLine."Invoice No.");
                                recAmzOrderLine2.CalcSums(Quantity);

                                if recAmzOrderLineArch.Quantity < recAmzOrderLine2.Quantity then
                                    "Error Description" := lText024;
                            end else
                                "Error Description" := lText024;
                        end;*/
                    prevAmzOrderLine := recAmzOrderLine;
                //<< 03-03-23 ZY-LD 020
                until recAmzOrderLine.Next() = 0;
        end;

        Validate("Sales Document Type");

    end;

    procedure InvoiceLookup()
    var
        lSaleInvHead: Record "Sales Invoice Header";
        lSaleCrMemoHead: Record "Sales Cr.Memo Header";
    begin
        if "Transaction Type" = "transaction type"::Order then begin
            lSaleInvHead.Get("RHQ Invoice No");
            Page.RunModal(Page::"Posted Sales Invoice", lSaleInvHead);
        end else begin
            lSaleCrMemoHead.Get("RHQ Invoice No");
            Page.RunModal(Page::"Posted Sales Credit Memos", lSaleInvHead);
        end;
    end;

    local procedure GetMarketPlace()
    begin
        TestField("Marketplace ID");
        if "Marketplace ID" <> recAmzMktPlace."Marketplace ID" then begin
            recAmzMktPlace.SetAutoCalcFields("VAT Bus Post. Grp. (Ship-From)");
            recAmzMktPlace.Get("Marketplace ID");
            recAmzMktPlace.TestField(Active, true);
            recAmzMktPlace.TestField("VAT Bus Post. Grp. (Ship-From)");
            recAmzMktPlace.TestField("VAT Bus Posting Group (EU)");
            recAmzMktPlace.TestField("VAT Bus Posting Group (No VAT)");
            recAmzMktPlace.TestField("Main Market Place ID");
            recAmzMktPlace.TestField("VAT Prod. Posting Group");
        end;
        //VATProdPostingGroup := recAmzMktPlace."VAT Prod. Posting Group";
    end;

    procedure InitRecord()
    begin
        GetMarketPlace;
        recAmzMktPlace.TestField("Customer No.");
        "Customer No." := recAmzMktPlace."Customer No.";
    end;

    procedure SetTaxValue(pTaxType: Text; pTaxCalculationReasonCode: Text; pTaxAddressRole: Text; pBuyerTaxRegType: Text; pTaxRepScheme: Text; pTaxCollectionResp: Text)
    begin
        case UpperCase(pTaxType) of
            'VAT':
                Validate("Tax Type", "tax type"::VAT);
            else
                "Error Description" := StrSubstNo(Text001, FieldCaption("Tax Type"), pTaxType);
        end;

        case UpperCase(pTaxCalculationReasonCode) of
            'TAXABLE':
                Validate("Tax Calculation Reason Code", "tax calculation reason code"::Taxable);
            else
                "Error Description" := StrSubstNo(Text001, FieldCaption("Tax Calculation Reason Code"), pTaxCalculationReasonCode);
        end;

        case UpperCase(pTaxAddressRole) of
            'SHIPTO':
                Validate("Tax Address Role", "tax address role"::"Ship-to");
            'SHIPFROM':
                Validate("Tax Address Role", "tax address role"::"Ship-from");
            else
                "Error Description" := StrSubstNo(Text001, FieldCaption("Tax Address Role"), pTaxAddressRole);
        end;

        case UpperCase(pBuyerTaxRegType) of
            'VAT':
                Validate("Buyer Tax Reg. Type", "buyer tax reg. type"::VAT);
            'CITIZENID':
                Validate("Buyer Tax Reg. Type", "buyer tax reg. type"::"Citizen ID");
            'BUSINESSREG':
                Validate("Buyer Tax Reg. Type", "buyer tax reg. type"::"Business Registration");
        //ELSE
        //  "Error Description" := STRSUBSTNO(Text001,FieldCaption("Buyer Tax Reg. Type"),pBuyerTaxRegType);
        end;

        //>> 08-06-23 ZY-LD 024
        Validate("Tax Reporting Scheme", pTaxRepScheme);
        case UpperCase(pTaxCollectionResp) of
            'SELLER':
                Validate("Tax Collection Respons.", "tax collection respons."::Seller);
            'MARKETPLACE':
                Validate("Tax Collection Respons.", "tax collection respons."::Marketplace);
            else
                "Error Description" := StrSubstNo(Text001, FieldCaption("Tax Address Role"), pTaxAddressRole);
        end;
        //<< 08-06-23 ZY-LD 024
    end;

    procedure SetTransactionType(pTransactType: Text)
    begin
        case pTransactType of
            'SHIPMENT',
          'LIQUIDATIONS':
                Validate("Transaction Type", "transaction type"::Order);
            'RETURN',
          'REFUND':
                Validate("Transaction Type", "transaction type"::Refund);
            else
                "Error Description" := StrSubstNo(Text001, FieldCaption("Transaction Type"), pTransactType);
        end;
    end;

    procedure SetVatProdPostingGroup(pVatProdPostingGroup: Code[10])
    begin
        gVATProdPostingGroup := pVatProdPostingGroup;
    end;

    procedure ArchiveDocumentManually()
    var
        recAmzonOrderHead: Record "eCommerce Order Header";
        recAmzOrderLine: Record "eCommerce Order Line";
        recAmzOrderArc: Record "eCommerce Order Archive";
        recAmzOrderLineArc: Record "eCommerce Order Line Archive";
        lText001: Label 'Do you want to archive %1 manually?';
    begin
        //>> 31-08-21 ZY-LD 049
        if Confirm(lText001, false, "eCommerce Order Id") then begin
            recAmzonOrderHead.SetRange("eCommerce Order Id", "eCommerce Order Id");
            recAmzonOrderHead.SetRange("Invoice No.", "Invoice No.");
            if recAmzonOrderHead.Get("Transaction Type", "eCommerce Order Id", "Invoice No.") then begin
                recAmzOrderArc.TransferFields(recAmzonOrderHead);
                recAmzOrderArc."Date Archived" := Today;
                recAmzOrderArc.Insert(true);

                recAmzOrderLine.SetRange("Transaction Type", "Transaction Type");
                recAmzOrderLine.SetRange("eCommerce Order Id", recAmzonOrderHead."eCommerce Order Id");
                recAmzOrderLine.SetRange("Invoice No.", recAmzonOrderHead."Invoice No.");
                if recAmzOrderLine.FindSet() then
                    repeat
                        recAmzOrderLineArc.TransferFields(recAmzOrderLine);
                        recAmzOrderLineArc.Insert(true);
                    until recAmzOrderLine.Next() = 0;

                recAmzonOrderHead.Delete(true);
            end;
        end;
        //<< 31-08-21 ZY-LD 049
    end;

    procedure UpdateGiveAwayOrder()
    begin
        //>> 24-05-23 ZY-LD 023
        "Give Away Order" := not "Give Away Order";
        Modify(true);
        //<< 24-05-23 ZY-LD 023
    end;

    procedure ForceValidationDocument()
    var
        UserSetup: Record "User Setup";
        ErrorAllowed: Label '%1 do not have permission to Force Validate Document';
    begin
        IF UserSetup.get(UserId) then
            If UserSetup."Allow Force Validation" then begin
                if "Error Description" <> '' then
                    "Error Description" := '';//05-05-2025 BK #485255
            end else
                Error(ErrorAllowed, UserId);

    end;
}
