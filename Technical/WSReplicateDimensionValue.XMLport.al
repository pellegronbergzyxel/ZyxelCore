XmlPort 50041 "WS Replicate Dimension Value"
{
    Caption = 'WS Replicate Dimension Value';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/RepDimValue';
    Encoding = UTF8;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Dimension Value"; "Dimension Value")
            {
                MinOccurs = Zero;
                XmlName = 'DimensionValue';
                UseTemporary = true;
                fieldelement(DimCode; "Dimension Value"."Dimension Code")
                {
                }
                fieldelement(Code; "Dimension Value".Code)
                {
                }
                fieldelement(Name; "Dimension Value".Name)
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
        recDimValue: Record "Dimension Value";
        recGlSetup: Record "General Ledger Setup";
    begin
        recGlSetup.Get;
        recDimValue.SetFilter("Dimension Code", '%1|%2', recGlSetup."Shortcut Dimension 3 Code", recGlSetup."Shortcut Dimension 4 Code");
        recDimValue.SetFilter("Dimension Code", '%1|%2|%3|%4',
          recGlSetup."Shortcut Dimension 1 Code",
          recGlSetup."Shortcut Dimension 2 Code",
          recGlSetup."Shortcut Dimension 3 Code",
          recGlSetup."Shortcut Dimension 4 Code");
        if recDimValue.FindSet then
            repeat
                "Dimension Value"."Dimension Code" := recDimValue."Dimension Code";
                "Dimension Value".Code := recDimValue.Code;
                "Dimension Value".Name := recDimValue.Name;
                "Dimension Value".Insert;
            until recDimValue.Next() = 0;
    end;


    procedure ReplicateData()
    var
        recDimVal: Record "Dimension Value";
    begin
        if "Dimension Value".FindSet then
            repeat
                if not recDimVal.Get("Dimension Value"."Dimension Code", "Dimension Value".Code) then begin
                    recDimVal.Init;
                    recDimVal."Dimension Code" := "Dimension Value"."Dimension Code";
                    recDimVal.Code := "Dimension Value".Code;
                    recDimVal.Name := "Dimension Value".Name;
                    recDimVal.Insert;
                end;
            until "Dimension Value".Next() = 0;
    end;
}
