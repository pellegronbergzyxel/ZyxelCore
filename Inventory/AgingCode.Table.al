Table 50067 "Aging Code"
{
    // 001. 23-07-18 ZY-LD 2018072310000062 - New field and primary key.
    // 002. 12-02-20 ZY-LD P03?? - Find max aging.

    Caption = 'Aging Code';
    DataPerCompany = false;

    fields
    {
        field(1; "Due Days"; Integer)
        {
            Caption = 'Due Days';
        }
        field(2; "Aging Code"; Text[10])
        {
            Caption = 'Aging Code';
        }
        field(3; Allowance; Decimal)
        {
            Caption = 'Allowance';
            MaxValue = 100;
            MinValue = 0;
        }
        field(4; "Code"; Code[10])
        {
            Description = '23-07-18 ZY-LD 001';
        }
    }

    keys
    {
        key(Key1; "Code", "Due Days")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetAgingCode(pCode: Code[10]; pDueDays: Integer): Text[10]
    var
        lAgingCode: Record "Aging Code";
    begin
        //>> 23-07-18 ZY-LD 001
        if pDueDays < 0 then
            pDueDays := 0;

        lAgingCode.SetRange(Code, pCode);  //<< 23-07-18 ZY-LD 001
        lAgingCode.SetFilter("Due Days", '..%1', pDueDays);
        if lAgingCode.FindLast then
            exit(lAgingCode."Aging Code");
    end;


    procedure GetAllowance(pCode: Code[10]; pDueDays: Integer): Decimal
    var
        lAgingCode: Record "Aging Code";
    begin
        //>> 23-07-18 ZY-LD 001
        if pDueDays < 0 then
            pDueDays := 0;

        lAgingCode.SetRange(Code, pCode);  //<< 23-07-18 ZY-LD 001
        lAgingCode.SetFilter("Due Days", '..%1', pDueDays);
        if lAgingCode.FindLast then
            exit(lAgingCode.Allowance);
    end;


    procedure GetMaxAcingCode(pCode: Code[10]; pAging: Code[10]; pAging2: Code[10]): Code[10]
    var
        recAging: Record "Aging Code";
        recAging2: Record "Aging Code";
    begin
        //>> 12-02-20 ZY-LD 002
        recAging.SetRange(Code, pCode);
        recAging.SetRange("Aging Code", pAging);
        if recAging.FindFirst then;

        recAging2.SetRange(Code, pCode);
        recAging2.SetRange("Aging Code", pAging2);
        if recAging2.FindFirst then;

        if recAging2."Due Days" > recAging."Due Days" then
            exit(pAging2)
        else
            exit(pAging);
        //<< 12-02-20 ZY-LD 002
    end;
}
