table 50122 "eCommerce Country Mapping"
{
    Caption = 'eCommerce Country Mapping';
    DrillDownPageID = "eCommerce Country Mapping";
    LookupPageID = "eCommerce Country Mapping";
    Permissions = TableData "Dimension Value" = ri;

    fields
    {
        field(1; "Ship-to Country Code"; Code[20])
        {
            Caption = 'Ship-to Country Code';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = "Country/Region".Code;
        }
        field(2; "VAT Bus. Posting Group"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "VAT Business Posting Group".Code;

            trigger OnValidate()
            begin
                UpdateeCommerceOrders;
            end;
        }
        field(3; "Ship-to VAT No."; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(4; "Ship-to Threshold"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(5; "Threshold Reached"; Boolean)
        {
            Description = 'PAB 1.0';
            Editable = false;
        }
        field(6; "Market Place ID"; Text[30])
        {
            Description = 'PAB 1.0';
            TableRelation = "eCommerce Market Place";
        }
        field(7; "VAT Applicale"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(8; "Threshold Posted"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line"."Total (Inc. Tax)" where("Customer No." = field("Customer No."),
                                                                            "Ship-to Country Code" = field("Ship-to Country Code")));
            Caption = 'Threshold Posted';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Has Threshold"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(10; "Threshold Amount"; Decimal)
        {
            Caption = 'Threshold Amount';
            Description = 'LD1.0';
            MinValue = 0;
        }
        field(11; "Threshold Reached Date"; Date)
        {
            Caption = 'Threshold Reached Date';
            Description = 'LD1.0';
        }
        field(12; "Country Dimension"; Code[10])
        {
            Caption = 'Country Dimension';
            Description = 'LD1.0';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                         "Dimension Value Type" = const(Standard),
                                                         Blocked = const(false));

            trigger OnValidate()
            begin
                UpdateeCommerceOrders;
            end;
        }
        field(13; "Default Mapping"; Boolean)
        {
            Caption = 'Default Mapping';
            Description = 'LD1.0';

            trigger OnValidate()
            begin
                recAmzCompMap.Get("Market Place ID");  // 10-04-19 ZY-LD 002
                recAznCountryMap.SetRange("Customer No.", recAmzCompMap."Customer No.");  // 10-04-19 ZY-LD 002
                recAznCountryMap.SetRange("Default Mapping", true);
                recAznCountryMap.SetFilter("Ship-to Country Code", '<>%1', "Ship-to Country Code");
                if recAznCountryMap.FindFirst() then
                    Error(Text001, recAznCountryMap."Ship-to Country Code", recAznCountryMap.FieldCaption("Default Mapping"));
            end;
        }
        field(14; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = '10-04-19 ZY-LD 002';
            TableRelation = Customer;
        }
        field(15; "Use Reverce Charge - DOM Bus"; Boolean)
        {
            Caption = 'Use Reverce Charge for Domestic Business Customers';
            Description = '31-01-20 ZY-LD 003';
        }
        field(16; "Alt. VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'Alt. VAT Bus. Posting Group';
            Description = 'PAB 1.0';
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(17; "Threshold Posted Archive"; Decimal)
        {
            CalcFormula = sum("eCommerce Order Line Archive"."Total (Inc. Tax)" where("Customer No." = field("Customer No."),
                                                                                      "Ship-to Country Code" = field("Ship-to Country Code")));
            Caption = 'Threshold Posted';
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Use Country VAT Bus. Post Grp."; Boolean)
        {
            Caption = 'Use VAT Bus. Post Grp. from Country Mapping';
        }
        field(19; "Post Without Zyxel VAT Reg. No"; Boolean)
        {
            Caption = 'Post Without Zyxel VAT Registration No.';
        }
        field(20; "Domestic Reverse Charge"; Boolean)
        {
            Caption = 'Domestic Reverse Charge';
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Ship-to Country Code")
        {
            Clustered = true;
        }
    }

    var
        recAznCountryMap: Record "eCommerce Country Mapping";
        Text001: Label '%1 is already "%2".';
        recAmzCompMap: Record "eCommerce Market Place";
        ZGT: Codeunit "ZyXEL General Tools";

    procedure InsertCountryMapping(pMarketPlace: Code[10]; pNewCountryMapping: Code[10])
    var
        recAznCountryMap: Record "eCommerce Country Mapping";
        recDimValue: Record "Dimension Value";
        recDimValueRHQ: Record "Dimension Value";
        recGenLedgSetup: Record "General Ledger Setup";
        ServerEnvironment: Record "Server Environment";
        recVatBusPostGrp: Record "VAT Business Posting Group";
        NewDimension: Code[10];
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        lText001: Label 'AMAZON';
        lText002: Label 'DOM';
        lText003: Label 'Domestic';
    begin
        // Copy country mapping, and create company dimension.
        recGenLedgSetup.Get();
        NewDimension := UpperCase(lText001) + '-' + pNewCountryMapping;

        if not recDimValue.Get(recGenLedgSetup."Shortcut Dimension 3 Code", NewDimension) then begin
            recDimValue.Validate("Dimension Code", recGenLedgSetup."Shortcut Dimension 3 Code");
            recDimValue.Validate(Code, UpperCase(lText001) + '-' + pNewCountryMapping);
            recDimValue.Validate(Name, lText001 + ' ' + pNewCountryMapping);
            recDimValue.Validate("Dimension Value Type", recDimValue."dimension value type"::Standard);
            recDimValue.Validate("Global Dimension No.", 3);
            if not recDimValue.Insert() then;

            //>> 03-07-20 ZY-LD 004
            if (ZGT.IsZComCompany and not ZGT.IsRhq) or ZGT.IsZNetCompany then begin
                if ZGT.IsZComCompany and not ZGT.IsRhq then
                    recDimValueRHQ.ChangeCompany(ZGT.GetSistersCompanyName(1));
                if not recDimValueRHQ.Get(recGenLedgSetup."Shortcut Dimension 3 Code", NewDimension) then begin
                    recDimValueRHQ := recDimValue;
                    if not recDimValueRHQ.Insert() then;
                end;
            end;
            //<< 03-07-20 ZY-LD 004

            //>> 22-02-18 ZY-LD 001
            if ServerEnvironment.ProductionEnvironment then begin
                SI.SetMergefield(100, recDimValue.Code);
                SI.SetMergefield(101, CompanyName());
                EmailAddMgt.CreateSimpleEmail('COUNTRYDIM', '', '');
                EmailAddMgt.Send;
            end;
            //<< 22-02-18 ZY-LD 001
        end;

        //>> 12-10-22 ZY-LD 005
        if not recVatBusPostGrp.Get(StrSubstNo('%1 %2', lText002, pNewCountryMapping)) then begin
            recVatBusPostGrp.Init();
            recVatBusPostGrp.Validate(Code, StrSubstNo('%1 %2', lText002, pNewCountryMapping));
            recVatBusPostGrp.Validate(Description, StrSubstNo('%1 %2', lText002, pNewCountryMapping));
            recVatBusPostGrp.Insert(true);
        end;
        //<< 12-10-22 ZY-LD 005

        //>> 10-04-19 ZY-LD 002
        recAmzCompMap.Get(pMarketPlace);
        recAznCountryMap."Customer No." := recAmzCompMap."Customer No.";
        recAznCountryMap."Market Place ID" := pMarketPlace;
        //<< 10-04-19 ZY-LD 002
        recAznCountryMap."Ship-to Country Code" := pNewCountryMapping;
        recAznCountryMap."Country Dimension" := recDimValue.Code;
        recAznCountryMap."VAT Bus. Posting Group" := recVatBusPostGrp.Code;  // 12-10-22 ZY-LD 005
        recAznCountryMap.Insert();
    end;

    local procedure UpdateeCommerceOrders()
    var
        recAmzHead: Record "eCommerce Order Header";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ("Country Dimension" <> '') and ("VAT Bus. Posting Group" <> '') then begin
            recAmzHead.SetRange(Open, true);
            recAmzHead.SetRange("Ship To Country", "Ship-to Country Code");
            recAmzHead.SetFilter("VAT Bus. Posting Group", '%1', '');
            if recAmzHead.FindSet(true) then begin
                ZGT.OpenProgressWindow('', recAmzHead.Count());
                repeat
                    ZGT.UpdateProgressWindow('', 0, true);
                    recAmzHead.Validate("VAT Bus. Posting Group");
                    recAmzHead.ValidateDocument;
                    recAmzHead.Modify(true);
                until recAmzHead.Next() = 0;
                ZGT.CloseProgressWindow;
            end;
        end;
    end;
}
