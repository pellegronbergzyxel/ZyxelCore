XmlPort 50028 "HQ EiCard Download Link"
{
    // 001. 09-06-23 ZY-LD 000 - Table 76132 was practical unused, and therefore removed.

    Caption = 'HQ EiCard Download Link';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/dl';
    Direction = Import;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("EiCard Queue"; "EiCard Queue")
            {
                MinOccurs = Zero;
                XmlName = 'EiCardLinkHeader';
                UseTemporary = true;
                fieldelement(PurchaseOrderNo; "EiCard Queue"."Purchase Order No.")
                {

                    trigger OnAfterAssignField()
                    begin
                        "EiCard Queue"."Sales Order No." := "EiCard Queue"."Purchase Order No.";  // 09-06-23 ZY-LD 001
                    end;
                }
                tableelement("EiCard Link Line"; "EiCard Link Line")
                {
                    MinOccurs = Zero;
                    XmlName = 'EiCardLinkLine';
                    UseTemporary = true;
                    fieldelement(PurchaseOrderLineNo; "EiCard Link Line"."Purchase Order Line No.")
                    {
                    }
                    fieldelement(ItemNo; "EiCard Link Line"."Item No.")
                    {
                    }
                    fieldelement(DownloadLink; "EiCard Link Line".Link)
                    {
                    }

                    trigger OnAfterInitRecord()
                    begin
                        EntryNoLine += 1;
                        "EiCard Link Line".UID := EntryNoLine;
                        "EiCard Link Line"."Purchase Order No." := "EiCard Queue"."Purchase Order No.";
                        "EiCard Link Line"."Line No." := EntryNoLine * 10000;
                    end;
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

    var
        EntryNo: Integer;
        EntryNoLine: Integer;


    procedure GetData(var pEicardQueue: Record "EiCard Queue" temporary; var pEiCardLinkLine: Record "EiCard Link Line" temporary)
    begin
        if "EiCard Queue".FindSet then
            repeat
                pEicardQueue := "EiCard Queue";
                pEicardQueue.Insert;

                "EiCard Link Line".SetRange("Purchase Order No.", "EiCard Queue"."Purchase Order No.");
                if "EiCard Link Line".FindSet then
                    repeat
                        pEiCardLinkLine := "EiCard Link Line";
                        //30-06-2026 BK #581893
                        pEiCardLinkLine.Quantity := FindPurchaseOrder("EiCard Link Line"."Purchase Order No.", "EiCard Link Line"."Purchase Order Line No.");
                        pEiCardLinkLine.Insert;
                    until "EiCard Link Line".Next() = 0;
            until "EiCard Queue".Next() = 0;
    end;

    //30-06-2026 BK #581893
    procedure FindPurchaseOrder(PurchaseOrderNo: Code[20]; PurchaseOrderLineNo: Decimal): Decimal
    var
        PurchaseLine: Record "Purchase Line";
    begin
        if (PurchaseOrderNo <> '') and (PurchaseOrderLineNo <> 0) then
            if PurchaseLine.get(PurchaseLine."Document Type"::Order, PurchaseOrderNo, PurchaseOrderLineNo) then
                exit(PurchaseLine.Quantity);

    end;
}
