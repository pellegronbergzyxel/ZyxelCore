codeunit 50017 DimensionManagementExtension
{
    procedure ICCreateDimensionValue(FieldNumber: Integer; var ICDocDim: Record "IC Document Dimension")
    var
        recGenLedgSetup: Record "General Ledger Setup";
    begin
        //>> 13-01-21 ZY-LD 001
        recGenLedgSetup.Get();

        if ICDocDim.FindSet() then
            repeat
                case FieldNumber of
                    7:
                        if ICDocDim."Dimension Code" = recGenLedgSetup."Shortcut Dimension 7 Code" then
                            CreateDimensionValue(FieldNumber, ICDocDim."Dimension Code", ICDocDim."Dimension Value Code");
                end;
            until ICDocDim.Next() = 0;
        //<< 13-01-21 ZY-LD 001
    end;

    procedure CreateDimensionValue(FieldNumber: Integer; DimCode: Code[20]; DimValue: Code[20])
    var
        recDimValue: Record "Dimension Value";
        recIcDimValue: Record "IC Dimension Value";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        //>> 13-01-21 ZY-LD 001
        if not recDimValue.Get(DimCode, DimValue) then begin
            recDimValue.Init();
            recDimValue.Validate("Dimension Code", DimCode);
            recDimValue.Validate(Code, DimValue);
            recDimValue.Validate(Name, DimValue);
            recDimValue.Validate("Global Dimension No.", FieldNumber);
            recDimValue.Insert(true);

            if ZGT.IsZComCompany then
                if not recIcDimValue.Get(DimCode, DimValue) then begin
                    recIcDimValue.Init();
                    recIcDimValue.Validate("Dimension Code", DimCode);
                    recIcDimValue.Validate(Code, DimValue);
                    recIcDimValue.Validate(Name, DimValue);
                    recIcDimValue.Validate("Map-to Dimension Code", DimCode);
                    recIcDimValue.Validate("Map-to Dimension Value Code", DimValue);
                    recIcDimValue.Insert(true);

                    recDimValue.Validate("Map-to IC Dimension Code", DimCode);
                    recDimValue.Validate("Map-to IC Dimension Value Code", DimValue);
                    recDimValue.Modify(true);
                end;
        end;
        //<< 13-01-21 ZY-LD 001
    end;
}
