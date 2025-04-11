Table 50005 "VAT Reg. No. pr. Location"
{
    // 001. 08-08-19 ZY-LD 2019080710000106 - New field.
    // 002. 23-10-20 ZY-LD 000 - Give a message to the user.
    // 003. 25-01-21 ZY-LD P0559 - New field.
    // 004. 01-12-21 ZY-LD 2021113010000114 - New field.
    // 005. 20-10-23 ZY-LD #7961109 - Run only if location code is filled.
    // 006. 07-11-23 ZY-LD 000 - If location code is blank we use company info.

    Caption = 'VAT Reg. No. pr. Location';
    DataCaptionFields = "Location Code", "Ship-to Customer Country Code";
    DrillDownPageID = "VAT Reg. No. pr. Locations";
    LookupPageID = "VAT Reg. No. pr. Locations";

    fields
    {
        field(1; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(2; "Ship-to Customer Country Code"; Code[10])
        {
            Caption = 'Ship-to Customer Country Code';
            TableRelation = "Country/Region";
        }
        field(3; "VAT Country Code"; Code[10])
        {
            Caption = 'VAT Country Code';
            TableRelation = "Country/Region";

            trigger OnLookup()
            begin
                if Page.RunModal(Page::"VAT Reg. No. pr. Country List", recCountry) = Action::LookupOK then
                    "VAT Country Code" := recCountry.Code;
                CalcFields("VAT Registration No.");
            end;
        }
        field(4; "VAT Registration No."; Code[20])
        {
            CalcFormula = lookup("Country/Region"."VAT Registration No." where(Code = field("VAT Country Code")));
            Caption = 'VAT Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Description = '08-08-19 ZY-LD 001';
            TableRelation = Customer;
        }
        field(6; "EORI No."; Code[20])
        {
            CalcFormula = lookup("Country/Region"."EORI No." where(Code = field("VAT Country Code")));
            Caption = 'EORI No.';
            Description = '01-12-21 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Send-from Country/Region"; Code[10])
        {
            CalcFormula = lookup(Location."Country/Region Code" where(Code = field("Location Code")));
            Caption = 'Send-from Country/Region';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Location Code", "Ship-to Customer Country Code", "Sell-to Customer No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //>> 23-10-20 ZY-LD 002
        if ZGT.IsRhq and ZGT.IsZComCompany then
            Message(lText001);
        //<< 23-10-20 ZY-LD 002
    end;

    var
        recCountry: Record "Country/Region";
        ZGT: Codeunit "ZyXEL General Tools";
        lText001: label 'Remember you might have to do the setup in the subsidary as well.';


    procedure "GetZyxelVATReg/EoriNo"(pType: Option "VAT Registration No.","EORI No."; pLocationCode: Code[10]; pShipToCountry: Code[10]; pSellToCountry: Code[10]; pSellToCustomerNo: Code[20]) rValue: Code[20]
    var
        recVATRegNoMatrix: Record "VAT Reg. No. pr. Location";
        recCompInfo: Record "Company Information";
        lText001: label 'There is no "%1" within the filter.\\%2\\Please contact the Finance Department for the setup.';
    begin
        reccompinfo.get;
        IF pLocationCode <> '' THEN BEGIN  // 20-10-23 ZY-LD 005
            recVATRegNoMatrix.SetAutocalcFields("VAT Registration No.", "EORI No.");
            recVATRegNoMatrix.SetRange("Location Code", pLocationCode);
            if pShipToCountry <> '' then
                recVATRegNoMatrix.SetFilter("Ship-to Customer Country Code", '%1|%2', pShipToCountry, '')
            else
                recVATRegNoMatrix.SetFilter("Ship-to Customer Country Code", '%1|%2', pSellToCountry, '');
            recVATRegNoMatrix.SetFilter("Sell-to Customer No.", '%1|%2', pSellToCustomerNo, '');
            if recVATRegNoMatrix.FindLast then begin
                recVATRegNoMatrix.TestField("VAT Registration No.");
                case pType of
                    Ptype::"VAT Registration No.":
                        rValue := recVATRegNoMatrix."VAT Registration No.";
                    Ptype::"EORI No.":
                        if recVATRegNoMatrix."EORI No." <> '' then
                            rValue := recVATRegNoMatrix."EORI No."
                        else
                            rValue := recCompInfo."EORI No.";
                end;
            end;
        end else begin
            //>> 07-11-23 ZY-LD 006
            case pType of
                Ptype::"VAT Registration No.":
                    rValue := recCompInfo."VAT Registration No.";
                Ptype::"EORI No.":
                    rValue := recCompInfo."EORI No.";
            end;
            //<< 07-11-23 ZY-LD 006
        end;
    end;
}
