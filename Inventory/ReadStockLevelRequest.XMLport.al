XmlPort 50057 "Read Stock Level Request"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML

    Caption = 'Read Stock Level Request';
    Direction = Import;
    Encoding = UTF8;
    Format = Xml;
    FormatEvaluate = Xml;
    UseDefaultNamespace = false;
    UseRequestPage = false;

    schema
    {
        textelement(InventoryRequestResponse)
        {
            textelement(Items)
            {
                tableelement("VCK Inventory"; "VCK Inventory")
                {
                    XmlName = 'Item';
                    textelement(Index)
                    {
                    }
                    textelement(itemno1)
                    {
                        XmlName = 'ItemNo';
                    }
                    fieldelement(ProductNo; "VCK Inventory"."Item No.")
                    {
                    }
                    textelement(Description)
                    {
                    }
                    fieldelement(Warehouse; "VCK Inventory".Warehouse)
                    {
                        FieldValidate = no;
                    }
                    fieldelement(Location; "VCK Inventory".Location)
                    {
                        FieldValidate = no;
                    }
                    textelement(Bin)
                    {
                        MinOccurs = Zero;
                    }
                    textelement(Grade)
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(QuantityOnHand; "VCK Inventory"."Quantity On Hand")
                    {
                    }

                    trigger OnBeforeInsertRecord()
                    begin
                        //"VCK Inventory"."Time Stamp" := SystemDT;
                        "VCK Inventory"."Time Stamp" := CreateDatetime(WhseDate, 0T);
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

    trigger OnPreXmlPort()
    begin
        "VCK Inventory".DeleteAll;
    end;

    var
        WhseDate: Date;
        DD: Integer;
        MM: Integer;
        YYYY: Integer;


    procedure Init(NewWarehouseDate: Date)
    begin
        WhseDate := NewWarehouseDate;
    end;
}
