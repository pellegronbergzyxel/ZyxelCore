XmlPort 50043 "WS Replicate Sales Person"
{
    Caption = 'WS Replicate Sales Person';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/Replicate';
    Encoding = UTF8;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Salesperson/Purchaser"; "Salesperson/Purchaser")
            {
                MinOccurs = Zero;
                XmlName = 'SalesPerson';
                UseTemporary = true;
                fieldelement(Code; "Salesperson/Purchaser".Code)
                {
                }
                fieldelement(Name; "Salesperson/Purchaser".Name)
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
        recSalesPers: Record "Salesperson/Purchaser";
    begin
        if recSalesPers.FindFirst then
            repeat
                "Salesperson/Purchaser" := recSalesPers;
                "Salesperson/Purchaser".Insert;
            until recSalesPers.Next() = 0;
    end;


    procedure ReplicateData()
    var
        recSalesPerson: Record "Salesperson/Purchaser";
    begin
        if "Salesperson/Purchaser".FindSet then
            repeat
                if not recSalesPerson.Get("Salesperson/Purchaser".Code) then begin
                    recSalesPerson.Init;
                    recSalesPerson.Code := "Salesperson/Purchaser".Code;
                    recSalesPerson.Name := "Salesperson/Purchaser".Name;
                    recSalesPerson.Insert;
                end else begin
                    recSalesPerson.Name := "Salesperson/Purchaser".Name;
                    recSalesPerson.Modify;
                end;
            until "Salesperson/Purchaser".Next() = 0;
    end;
}
