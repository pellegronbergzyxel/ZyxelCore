XmlPort 50044 "WS Replicate Ic Dim. Value"
{
    Caption = 'WS Replicate Ic Dimension Value';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/Replicate';
    Encoding = UTF8;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("IC Dimension Value"; "IC Dimension Value")
            {
                MinOccurs = Zero;
                XmlName = 'IcDimensionValue';
                UseTemporary = true;
                fieldelement(DimCode; "IC Dimension Value"."Dimension Code")
                {
                }
                fieldelement(Code; "IC Dimension Value".Code)
                {
                }
                fieldelement(Name; "IC Dimension Value".Name)
                {
                }
                fieldelement(DimValueType; "IC Dimension Value"."Dimension Value Type")
                {
                }
                fieldelement(Blocked; "IC Dimension Value".Blocked)
                {
                }
                fieldelement(MapToDimCode; "IC Dimension Value"."Map-to Dimension Code")
                {
                }
                fieldelement(MapToDimValue; "IC Dimension Value"."Map-to Dimension Value Code")
                {
                }
                fieldelement(Indentation; "IC Dimension Value".Indentation)
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }


    procedure SetData()
    var
        recIcDimValue: Record "IC Dimension Value";
    begin
        if recIcDimValue.FindSet then
            repeat
                "IC Dimension Value" := recIcDimValue;
                "IC Dimension Value".Insert;
            until recIcDimValue.Next() = 0;
    end;


    procedure ReplicateData()
    var
        recICDimValue: Record "IC Dimension Value";
    begin
        if "IC Dimension Value".FindFirst then
            repeat
                if not recICDimValue.Get("IC Dimension Value"."Dimension Code", "IC Dimension Value".Code) then begin
                    recICDimValue := "IC Dimension Value";
                    recICDimValue.Insert;
                end else begin
                    recICDimValue := "IC Dimension Value";
                    recICDimValue.Modify;
                end;
            until "IC Dimension Value".Next() = 0;
    end;
}
