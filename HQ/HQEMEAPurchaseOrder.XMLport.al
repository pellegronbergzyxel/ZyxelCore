XmlPort 50030 "HQ EMEA Purchase Order"
{
    // // Update purchase orders

    DefaultNamespace = 'urn:microsoft-dynamics-nav/pol';
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Purchase Header"; "Purchase Header")
            {
                XmlName = 'PurchaseOrder';
                UseTemporary = true;
                fieldelement(DocumentNo; "Purchase Header"."No.")
                {
                }
                tableelement("Purchase Line"; "Purchase Line")
                {
                    LinkFields = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    LinkTable = "Purchase Header";
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
                    fieldelement(Quantity; "Purchase Line".Quantity)
                    {
                    }
                    fieldelement(UnitPrice; "Purchase Line"."Unit Cost")
                    {
                    }
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


    procedure GetData(var pPurchaseHead: Record "Purchase Header" temporary; var pPurchaseLine: Record "Purchase Line" temporary)
    begin
        if "Purchase Header".FindSet then begin
            repeat
                pPurchaseHead := "Purchase Header";
                pPurchaseHead.Insert;
            until "Purchase Header".Next() = 0;

            if "Purchase Line".FindSet then
                repeat
                    pPurchaseLine := "Purchase Line";
                    pPurchaseLine.Insert;
                until "Purchase Line".Next() = 0;
        end;
    end;
}
