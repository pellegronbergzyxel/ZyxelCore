XmlPort 50078 "HQ Battery Certificate"
{
    Caption = 'HQ Battery Certificate';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/bc';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Battery Certificate"; "Battery Certificate")
            {
                MinOccurs = Zero;
                XmlName = 'BatteryCert';
                UseTemporary = true;
                fieldelement(ItemNo; "Battery Certificate"."Item No.")
                {
                }
                fieldelement(Description; "Battery Certificate".Description)
                {
                }
                fieldelement(Filename; "Battery Certificate".Filename)
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


    procedure GetData(var pBatCertTmp: Record "Battery Certificate" temporary)
    begin
        if "Battery Certificate".FindSet then
            repeat
                pBatCertTmp := "Battery Certificate";
                pBatCertTmp.Insert;
            until "Battery Certificate".Next() = 0;
    end;
}
