XmlPort 50040 "WS Replicate Tariff Number"
{
    Caption = 'WS Replicate Tariff Number';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/RepTariff';
    Encoding = UTF8;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Tariff Number"; "Tariff Number")
            {
                MinOccurs = Zero;
                XmlName = 'TariffNumber';
                UseTemporary = true;
                fieldelement(No; "Tariff Number"."No.")
                {
                }
                fieldelement(Description; "Tariff Number".Description)
                {
                }
                fieldelement(Supplementary; "Tariff Number"."Supplementary Units")
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
        recTariffNo: Record "Tariff Number";
    begin
        if recTariffNo.FindSet then
            repeat
                "Tariff Number" := recTariffNo;
                "Tariff Number".Insert;
            until recTariffNo.Next() = 0;
    end;


    procedure ReplicateData()
    var
        recTariffNumber: Record "Tariff Number";
    begin
        if "Tariff Number".FindSet then
            repeat
                if not recTariffNumber.Get("Tariff Number"."No.") then begin
                    recTariffNumber := "Tariff Number";
                    recTariffNumber.Insert;
                end else begin
                    recTariffNumber := "Tariff Number";
                    recTariffNumber.Modify;
                end;
            until "Tariff Number".Next() = 0;
    end;
}
