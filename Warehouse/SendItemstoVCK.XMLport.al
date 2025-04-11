XmlPort 50055 "Send Items to VCK"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 13-07-19 .. 02-07-19 PAB - Changes made for Project Rock Go-live.
    // 002. 24-01-22 ZY-LD 2022012410000054 - "Number per Carton" has been removed.
    // 003. 22-02-22 ZY-LD P0767 - Namespace is changed.

    Caption = 'Send Items to VCK';
    DefaultNamespace = 'http://schemas.allincontrol.com/BizTalk/2013';
    Direction = Export;
    Encoding = UTF8;
    FileName = 'C:\tmp\test.xml';
    Format = Xml;
    FormatEvaluate = Legacy;
    UseDefaultNamespace = true;
    UseRequestPage = false;

    schema
    {
        textelement(ItemInterface)
        {
            textelement(CustomerID)
            {
            }
            textelement(MessageNo)
            {
            }
            textelement(CustomerMessageNo)
            {
            }
            textelement(ProjectID)
            {
            }
            textelement(CostCenter)
            {
            }
            textelement(Items)
            {
                tableelement(Item; Item)
                {
                    MinOccurs = Zero;
                    XmlName = 'Item';
                    fieldelement(ItemNo; Item."No.")
                    {
                    }
                    textelement(CommonItemNo)
                    {
                    }
                    textelement(AlternateItemNo)
                    {
                    }
                    fieldelement(Description; Item.Description)
                    {
                    }
                    fieldelement(Description2; Item."Description 2")
                    {
                    }
                    fieldelement(TariffNo; Item."Tariff No.")
                    {
                    }
                    textelement("item::vendor no")
                    {
                        XmlName = 'SupplierID';
                    }
                    textelement("item::model id")
                    {
                        XmlName = 'SupplierItemNo';
                    }
                    fieldelement(CountryOfOrigin; Item."Country/Region of Origin Code")
                    {
                    }
                    textelement(CountryOfPurchase)
                    {
                    }
                    textelement("item::item category code")
                    {
                        XmlName = 'ProductGroup';
                    }
                    textelement(StorageCode)
                    {
                    }
                    textelement(PackingCode)
                    {
                    }
                    textelement(CycleCountCode)
                    {
                    }
                    fieldelement(HazardCode; Item."UN Code")
                    {
                    }
                    textelement(DurabilityInDays)
                    {
                    }
                    fieldelement(Barcode; Item.GTIN)
                    {
                    }
                    textelement(Remarks)
                    {
                    }
                    textelement(Checklist)
                    {
                    }
                    textelement(Stock)
                    {
                    }
                    textelement(Dimensions)
                    {
                        textelement(Unit)
                        {
                            fieldelement(Length; Item."Length (cm)")
                            {
                            }
                            fieldelement(Width; Item."Width (cm)")
                            {
                            }
                            fieldelement(Height; Item."Height (cm)")
                            {
                            }
                            fieldelement(NetWeight; Item."Net Weight")
                            {
                            }
                            fieldelement(GrossWeight; Item."Gross Weight")
                            {
                            }

                            trigger OnBeforePassVariable()
                            begin
                                //"Number per carton" := FORMAT(Item."Number per carton");  24-01-22 ZY-LD 002
                            end;
                        }
                        textelement(Box)
                        {
                            fieldelement(Units; Item."Number per carton")
                            {
                            }
                            fieldelement(Length; Item."Length (ctn)")
                            {
                            }
                            fieldelement(Width; Item."Width (ctn)")
                            {
                            }
                            fieldelement(Height; Item."Height (ctn)")
                            {
                            }
                            textelement(GrossWeight)
                            {

                                trigger OnBeforePassVariable()
                                begin
                                    GrossWeight := Format(ROUND(Item."Gross Weight" * Item."Number per carton"), 0, 9);
                                end;
                            }
                        }
                        textelement(Pallet)
                        {
                            fieldelement(Units; Item."Qty Per Pallet")
                            {
                            }
                            fieldelement(Length; Item."Pallet Length (cm)")
                            {
                            }
                            fieldelement(Width; Item."Pallet Width (cm)")
                            {
                            }
                            fieldelement(Height; Item."Pallet Height (cm)")
                            {
                            }
                            textelement(grossweight1)
                            {
                                XmlName = 'GrossWeight';

                                trigger OnBeforePassVariable()
                                begin
                                    //GrossWeight1 := '0';
                                    GrossWeight1 := Format(ROUND(Item."Gross Weight" * Item."Qty Per Pallet"), 0, 9);
                                end;
                            }
                        }
                    }
                    textelement(Tracking)
                    {
                        textelement(Serialnumbers)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                if Item."Serial Number Required" then
                                    Serialnumbers := 'True'
                                else
                                    Serialnumbers := 'False';
                            end;
                        }
                    }
                    textelement(RMA)
                    {
                        textelement(Process)
                        {
                        }
                        textelement(OutOfWarranty)
                        {

                            trigger OnBeforePassVariable()
                            begin
                                OutOfWarranty := 'False';
                            end;
                        }
                    }
                    textelement(SPM)
                    {
                        textelement(OEM)
                        {
                        }
                        textelement(SupplierID)
                        {
                        }
                        textelement(ProductGroup)
                        {
                        }
                        textelement(ExclusiveFor)
                        {
                        }
                        textelement(PLCStatus)
                        {
                        }
                        textelement(EndOfDelivery)
                        {
                        }
                        textelement(EndOfService)
                        {
                        }
                        textelement(SuccessorItemNo)
                        {
                        }
                        textelement(StandardCost)
                        {
                        }
                        textelement(ServicePrice)
                        {
                        }
                        textelement(TransferPrice)
                        {
                        }
                        textelement(RepairCost)
                        {
                        }
                        textelement(Scrap)
                        {
                        }
                        textelement(OnHold)
                        {
                        }
                        textelement(AutoPickAndPack)
                        {
                        }
                        textelement(WarrantyCheck)
                        {
                        }
                        textelement(WarrantyInitial)
                        {
                        }
                        textelement(WarrantyRepair)
                        {
                        }
                        textelement(RepairTimeInDays)
                        {
                        }
                        textelement(RequestReminder)
                        {
                        }
                        textelement(IncomingReminder)
                        {
                        }
                        textelement(remarks1)
                        {
                            XmlName = 'Remarks';
                        }
                    }

                    trigger OnAfterGetRecord()
                    var
                        recItem: Record Item;
                    begin
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

    trigger OnInitXmlPort()
    var
        recItem: Record Item;
    begin
    end;


    procedure SetParameters(Customer: Code[20]; Project: Code[20]; Message: Code[20])
    begin
        CustomerID := Customer;
        ProjectID := Project;
        CustomerMessageNo := Message;
    end;
}
