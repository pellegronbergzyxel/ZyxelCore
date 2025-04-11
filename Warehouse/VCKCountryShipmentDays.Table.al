Table 50045 "VCK Country Shipment Days"
{
    // 001. 06-09-18 ZY-LD 2018090610000046 - New fields.
    // 002. 15-11-18 ZY-LD 000 - New field.
    // 003. 01-04-19 ZY-LD 000 - New field.
    // 004. 20-16-19 ZY-LD 000 - Delete in sub table.
    // 005. 08-07-19 ZY-LD 2019070810000081 - Must not be 0D.

    Caption = 'Country Picking Days';
    DrillDownPageID = "VCK Country Shipment Days";
    LookupPageID = "VCK Country Shipment Days";

    fields
    {
        field(1; "Country Code"; Code[20])
        {
            Caption = 'Country Code';
            NotBlank = true;
            TableRelation = "Country/Region".Code;
        }
        field(2; Monday; Boolean)
        {
            Caption = 'Monday';

            trigger OnValidate()
            begin
                UpdateSub(Monday, 1);
            end;
        }
        field(3; Tuesday; Boolean)
        {
            Caption = 'Tuesday';

            trigger OnValidate()
            begin
                UpdateSub(Tuesday, 2);
            end;
        }
        field(4; Wednesday; Boolean)
        {
            Caption = 'Wednesday';

            trigger OnValidate()
            begin
                UpdateSub(Wednesday, 3);
            end;
        }
        field(5; Thursday; Boolean)
        {
            Caption = 'Thursday';

            trigger OnValidate()
            begin
                UpdateSub(Thursday, 4);
            end;
        }
        field(6; Friday; Boolean)
        {
            Caption = 'Friday';

            trigger OnValidate()
            begin
                UpdateSub(Friday, 5);
            end;
        }
        field(7; "Delivery Days"; Integer)
        {
            Caption = 'Delivery Days';
            InitValue = 2;
        }
        field(8; "Eoq Start Date"; Date)
        {
            Caption = 'End of Quarter Start Date';
            Description = '06-09-18 ZY-LD 001';

            trigger OnValidate()
            begin
                //>> 08-07-19 ZY-LD 005
                if "Eoq Start Date" = 0D then
                    Error(Text001, FieldCaption("Eoq Start Date"));
                //<< 08-07-19 ZY-LD 005
            end;
        }
        field(9; "Eoq End Date"; Date)
        {
            Caption = 'End of Quarter End Date';
            Description = '06-09-18 ZY-LD 001';

            trigger OnValidate()
            begin
                //>> 08-07-19 ZY-LD 005
                if "Eoq End Date" = 0D then
                    Error(Text001, FieldCaption("Eoq End Date"));
                //<< 08-07-19 ZY-LD 005
            end;
        }
        field(10; "Eoq Date Formula"; DateFormula)
        {
            Caption = 'End of Quarter Date Formula';
            Description = '06-09-18 ZY-LD 001';
        }
        field(11; "Shipment Time"; Time)
        {
            Caption = 'Picking Time';
            Description = '06-09-18 ZY-LD 001';
            InitValue = 120000T;
        }
        field(12; "Ship-To Code"; Code[10])
        {
            Caption = 'Ship-To Code';
            Description = '06-09-18 ZY-LD 001';
        }
        field(13; "Min. Amount to Ship"; Decimal)
        {
            BlankZero = true;
            Caption = 'Min. Amount to Pick';
            Description = '15-11-18 ZY-LD 002';
        }
        field(14; "Block DD Release from"; DateTime)
        {
            Caption = 'Block Delivery Document Release from';
            Description = '01-04-19 ZY-LD 003';
        }
    }

    keys
    {
        key(Key1; "Country Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //>> 20-16-19 ZY-LD 004
        recCtryShipDaySub.SetRange("Country Code", "Country Code");
        recCtryShipDaySub.DeleteAll(true);
        //<< 20-16-19 ZY-LD 004
    end;

    var
        recCtryShipDaySub: Record "VCK Country Shipm. Day Sub";
        Text001: label '"%1" must not be blank.';

    local procedure UpdateSub(pDayChosen: Boolean; pWeekDay: Integer)
    var
        recVckCouShipDaySub: Record "VCK Country Shipm. Day Sub";
    begin
        if pDayChosen then begin
            recVckCouShipDaySub."Country Code" := "Country Code";
            recVckCouShipDaySub."Week Day" := pWeekDay;
            if not recVckCouShipDaySub.Insert then;
        end else
            if recVckCouShipDaySub.Get("Country Code", pWeekDay) then
                recVckCouShipDaySub.Delete;
    end;
}
