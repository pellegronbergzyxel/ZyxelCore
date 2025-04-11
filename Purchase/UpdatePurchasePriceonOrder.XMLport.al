XmlPort 50002 "Update Purchase Price on Order"
{
    Caption = 'Update Purchase Price on Order';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/purchpriceorder';
    Direction = Import;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Purchase Line"; "Purchase Line")
            {
                MinOccurs = Zero;
                XmlName = 'PurchaseOrderLine';
                UseTemporary = true;
                fieldelement(DocumentNo; "Purchase Line"."Document No.")
                {
                }
                fieldelement(LineNo; "Purchase Line"."Line No.")
                {
                }
                fieldelement(ItemNo; "Purchase Line"."No.")
                {
                }
                fieldelement(UnitCost; "Purchase Line"."Direct Unit Cost")
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


    procedure GetLines(var pPurchLine: Record "Purchase Line" temporary)
    begin
        if "Purchase Line".FindSet then
            repeat
                pPurchLine := "Purchase Line";
                pPurchLine.Insert;
            until "Purchase Line".Next() = 0;
    end;
}
