XmlPort 50053 "HQ Purchase Order Status"
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/PoStatus';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Purchase Header"; "Purchase Header")
            {
                XmlName = 'PurchaseHeader';
                UseTemporary = true;
                fieldelement(OrderNo; "Purchase Header"."No.")
                {
                }
                textelement(Status)
                {
                }
                textelement(StatusDescription)
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
    begin
    end;
}
