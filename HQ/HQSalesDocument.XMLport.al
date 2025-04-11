xmlport 50029 "HQ Sales Document"
{
    Caption = 'HQ Sales Document';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/pd';
    Direction = Import;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("HQ Invoice Header"; "HQ Invoice Header")
            {
                XmlName = 'Document';
                UseTemporary = true;
                fieldelement(DocumentType; "HQ Invoice Header"."Document Type")
                {
                }
                fieldelement(DocumentNo; "HQ Invoice Header"."No.")
                {
                }
                fieldelement(CurrencyCode; "HQ Invoice Header"."Currency Code")
                {
                }
                fieldelement(Type; "HQ Invoice Header".Type)
                {
                }
                fieldelement(Filename; "HQ Invoice Header".Filename)
                {
                }
                tableelement("HQ Invoice Line"; "HQ Invoice Line")
                {
                    LinkFields = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    LinkTable = "HQ Invoice Header";
                    XmlName = 'DocumentLine';
                    UseTemporary = true;
                    fieldelement(ItemNo; "HQ Invoice Line"."No.")
                    {
                    }
                    fieldelement(Quantity; "HQ Invoice Line".Quantity)
                    {
                    }
                    fieldelement(UnitPrice; "HQ Invoice Line"."Unit Price")
                    {
                    }
                    fieldelement(LastBillOfMarerialPrice; "HQ Invoice Line"."Last Bill of Material Price")
                    {
                    }
                    fieldelement(OverheadPrice; "HQ Invoice Line"."Overhead Price")
                    {
                    }
                    fieldelement(PurchaseOrderNo; "HQ Invoice Line"."Purchase Order No.")
                    {
                    }
                    fieldelement(PurchaseOrderLineNo; "HQ Invoice Line"."Purchase Order Line No.")
                    {
                    }
                    fieldelement(NoCharge; "HQ Invoice Line"."No Charge (n/c)")
                    {
                    }

                    trigger OnAfterInitRecord()
                    begin
                        LineNo += 10000;
                        "HQ Invoice Line"."Line No." := LineNo;
                        "HQ Invoice Line"."Document Type" := "HQ Invoice Header"."Document Type";
                        "HQ Invoice Line"."Document No." := "HQ Invoice Header"."No.";
                    end;
                }
            }
        }
    }

    var
        LineNo: Integer;

    procedure GetData(var DocumentHeader: Record "HQ Invoice Header" temporary; var DocumentLine: Record "HQ Invoice Line" temporary)
    begin
        if "HQ Invoice Header".FindSet() then begin
            repeat
                DocumentHeader := "HQ Invoice Header";
                DocumentHeader.Insert();
            until "HQ Invoice Header".Next() = 0;

            if "HQ Invoice Line".FindSet() then
                repeat
                    DocumentLine := "HQ Invoice Line";
                    DocumentLine.Insert();
                until "HQ Invoice Line".Next() = 0;
        end;
    end;
}
