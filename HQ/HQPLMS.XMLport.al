XmlPort 50026 "HQ PLMS"
{

    DefaultNamespace = 'urn:microsoft-dynamics-nav/plms';
    Direction = Import;
    Format = Xml;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'Item';
                UseTemporary = true;
                fieldelement(No; Item."No.")
                {
                }
                fieldelement(HeightCm; Item."Height (cm)")
                {
                }
                fieldelement(WidthCm; Item."Width (cm)")
                {
                }
                fieldelement(LengthCm; Item."Length (cm)")
                {
                }
                fieldelement(VolumeCm3; Item."Volume (cm3)")
                {
                }
                fieldelement(PlasticWeight; Item."Plastic Weight")
                {
                }
                fieldelement(PaperWeight; Item."Paper Weight")
                {
                }
                fieldelement(CartonsPerPallet; Item."Cartons Per Pallet")
                {
                }
                fieldelement(HeightCtn; Item."Height (ctn)")
                {
                }
                fieldelement(WidthCtn; Item."Width (ctn)")
                {
                }
                fieldelement(LengthCtn; Item."Length (ctn)")
                {
                }
                fieldelement(VolumeCtn; Item."Volume (ctn)")
                {
                }
                fieldelement(NumberPerCarton; Item."Number per carton")
                {
                }
                fieldelement(GrossWeight; Item."Gross Weight")
                {
                }
                fieldelement(NetWeight; Item."Net Weight")
                {
                }
                fieldelement(PalletLengthCm; Item."Pallet Length (cm)")
                {
                }
                fieldelement(PalletWidthCm; Item."Pallet Width (cm)")
                {
                }
                fieldelement(PalletHeightCm; Item."Pallet Height (cm)")
                {
                }
                fieldelement(UnCode; Item."UN Code")
                {
                }
                fieldelement(Batteryweight; Item."Battery weight")
                {
                }
                fieldelement(CartonWeight; Item."Carton Weight")
                {
                }
                fieldelement(QuantityPrPallet; Item."Qty Per Pallet")
                {
                }
                fieldelement(EndOfTechnicalSupportDate; Item."End of Technical Support Date")
                {
                }
                fieldelement(EndOfRmaDate; Item."End of RMA Date")
                {
                }
                textelement(TaxReductionRate)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        if TaxReductionRate in ['NA', 'N/A'] then begin
                            Item."Tax Reduction Rate Active" := false;
                            Item."Tax Reduction rate" := 0;
                        end else begin
                            Evaluate(Item."Tax Reduction rate", TaxReductionRate);
                            Item."Tax Reduction Rate Active" := true;
                        end;
                    end;
                }
                fieldelement(EanCode; Item.GTIN)
                {
                }
                fieldelement(Category1Code; Item."Category 1 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(Category2Code; Item."Category 2 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(Category3Code; Item."Category 3 Code")
                {
                    FieldValidate = no;
                }
                fieldelement(BusinessCenter; Item."Business Center")
                {
                    FieldValidate = no;
                }
                fieldelement(SBU; Item.SBU)
                {
                    FieldValidate = no;
                }
                fieldelement(ModelPhase; Item."HQ Model Phase")
                {
                }
                fieldelement(ProductLengthCm; Item."Product Length (cm)")
                {
                }
                textelement(SbuCompany)
                {
                }
                fieldelement(LifecyclePhase; Item."Lifecycle Phase")
                {
                }
                fieldelement(LastBuyDate; Item."Last Buy Date")
                {
                }
                fieldelement(QtyPerColorBox; Item."Qty. per Color Box")
                {
                }
                textelement(ScipNo)
                {
                }
                fieldelement(SvhcHigherThan1000ppm; Item."SVHC > 1000 ppm")
                {
                }
                textelement(ProductUseBattery)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        case UpperCase(ProductUseBattery) of
                            'NO':
                                Item."Product use Battery" := Item."product use battery"::No;
                            'YES':
                                Item."Product use Battery" := Item."product use battery"::Yes;
                            else
                                Item."Product use Battery" := Item."product use battery"::" ";
                        end;
                    end;
                }
                fieldelement(WeeeCategory; Item."WEEE Category")
                {
                }
                fieldelement(DeviceWeight; Item."Device Weight") //30-09-226 BK #Request from HQ
                {

                }
                fieldelement(TariffNo; item."Tariff No.") //30-09-226 BK #Request from HQ
                {

                }

                trigger OnBeforeInsertRecord()
                begin
                    case UpperCase(SbuCompany) of
                        'ZCOM':
                            Item."SBU Company" := Item."sbu company"::"ZCom HQ";
                        'ZNET':
                            Item."SBU Company" := Item."sbu company"::"ZNet HQ";
                    end;

                    if ScipNo <> '' then begin
                        repeat
                            ScipNoTmp."Item No." := Item."No.";
                            if StrPos(ScipNo, ',') <> 0 then begin
                                ScipNoTmp."SCIP No." := CopyStr(ScipNo, 1, StrPos(ScipNo, ',') - 1);
                                ScipNo := CopyStr(ScipNo, StrPos(ScipNo, ',') + 1, StrLen(ScipNo));
                            end else begin
                                ScipNoTmp."SCIP No." := ScipNo;
                                ScipNo := '';
                            end;
                            ScipNoTmp.Insert;
                        until ScipNo = '';
                    end;
                end;
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

    procedure GetData(): Boolean
    var
        recItem: Record Item;
        recReworkItem: Record Item;
        recHqDimension: Record SBU;
        ScipNumber: Record "SCIP Number";
        WebServLogEntry: Record "Web Service Log Entry";
        HqDim: Enum "HQ Dimension";
        EmailAddMgt: Codeunit "E-mail Address Management";
        ItemNoList: Text;
        lText001: Label 'PLMS';
    begin
        // Updates PLMS into item table
        //>> 16-04-24 ZY-LD 008
        if Item.FindSet() then begin
            WebServLogEntry.CreateWebServiceLog(lText001, '');

            recItem.LockTable;
            repeat
                InsertHQDimension(HqDim::"Category 1", Item."Category 1 Code");
                InsertHQDimension(HqDim::"Category 2", Item."Category 2 Code");
                InsertHQDimension(HqDim::"Category 3", Item."Category 3 Code");
                InsertHQDimension(HqDim::"Business Center", Item."Business Center");
                InsertHQDimension(HqDim::SBU, Item.SBU);
                InsertHQDimension(HqDim::"WEEE Category'", Item."WEEE Category");

                // Delete existing numbers, so the table matches what we receive from HQ.
                ScipNumber.SetRange("Item No.", Item."No.");
                ScipNumber.DeleteAll(true);
                ScipNumber.SetRange("Item No.");

                ScipNoTmp.SetRange("Item No.", Item."No.");
                If ScipNoTmp.FindSet then
                    repeat
                        ScipNumber := ScipNoTmp;
                        ScipNumber.Insert(true);
                    until ScipNoTmp.Next = 0;

                if recItem.Get(Item."No.") then begin
                    if (recItem."Height (cm)" <> Item."Height (cm)") or
                       (recItem."Width (cm)" <> Item."Width (cm)") or
                       (recItem."Length (cm)" <> Item."Length (cm)") or
                       (recItem."Volume (cm3)" <> Item."Volume (cm3)") or
                       (recItem."Plastic Weight" <> Item."Plastic Weight") or
                       (recItem."Paper Weight" <> Item."Paper Weight") or
                       (recItem."Carton Weight" <> Item."Carton Weight") or
                       (recItem."Height (ctn)" <> Item."Height (ctn)") or
                       (recItem."Width (ctn)" <> Item."Width (ctn)") or
                       (recItem."Length (ctn)" <> Item."Length (ctn)") or
                       (recItem."Volume (ctn)" <> Item."Volume (ctn)") or
                       (recItem."Number per carton" <> Item."Number per carton") or
                       (recItem."Gross Weight" <> Item."Gross Weight") or
                       (recItem."Net Weight" <> Item."Net Weight") or
                       (recItem."Pallet Length (cm)" <> Item."Pallet Length (cm)") or
                       (recItem."Pallet Width (cm)" <> Item."Pallet Width (cm)") or
                       (recItem."Pallet Height (cm)" <> Item."Pallet Height (cm)") or
                       (recItem."UN Code" <> Item."UN Code") or
                       (recItem."Battery weight" <> Item."Battery weight") or
                       (recItem."Carton Weight" <> Item."Carton Weight") or
                       (recItem."Units per Parcel" <> Item."Units per Parcel") or
                       (recItem."Qty Per Pallet" <> Item."Qty Per Pallet") or
                       (recItem."End of Technical Support Date" <> Item."End of Technical Support Date") or
                       (recItem."End of RMA Date" <> Item."End of RMA Date") or
                       (recItem."Tax Reduction rate" <> Item."Tax Reduction rate") or
                       (recItem."Model Description" <> Item."Model Description") or
                       (recItem.GTIN <> Item.GTIN) or
                       (recItem."Category 1 Code" <> Item."Category 1 Code") or
                       (recItem."Category 2 Code" <> Item."Category 2 Code") or
                       (recItem."Category 3 Code" <> Item."Category 3 Code") or
                       (recItem."Business Center" <> Item."Business Center") or
                       (recItem.SBU <> Item.SBU) or
                       (recItem."SBU Company" <> Item."SBU Company") or
                       (recItem."HQ Model Phase" <> Item."HQ Model Phase") or
                       (recItem."Product Length (cm)" <> Item."Product Length (cm)") or
                       (recItem."Lifecycle Phase" <> Item."Lifecycle Phase") or
                       (recItem."Last Buy Date" <> Item."Last Buy Date") or
                       (recItem."Qty. per Color Box" <> Item."Qty. per Color Box") or
                       ((recItem."Cartons Per Pallet" <> Item."Cartons Per Pallet") and (Item."Cartons Per Pallet" <> 0)) or
                       (recItem."SCIP No." <> Item."SCIP No.") or
                       (recItem."Tax Reduction Rate Active" <> Item."Tax Reduction Rate Active") or
                       (recItem."SVHC > 1000 ppm" <> Item."SVHC > 1000 ppm") or
                       (recItem."Product use Battery" <> Item."Product use Battery") or
                       (recItem."WEEE Category" <> Item."WEEE Category") or
                       (recItem."Device Weight" <> item."Device Weight") or
                       ((recItem."Tariff No." <> item."Tariff No.") and (item."Tariff No." <> ''))
                    then begin
                        recItem."Height (cm)" := Item."Height (cm)";
                        recItem."Width (cm)" := Item."Width (cm)";
                        recItem."Length (cm)" := Item."Length (cm)";
                        recItem."Volume (cm3)" := Item."Volume (cm3)";
                        recItem."Plastic Weight" := Item."Plastic Weight";
                        recItem."Paper Weight" := Item."Paper Weight";
                        recItem."Carton Weight" := Item."Carton Weight";
                        recItem."Height (ctn)" := Item."Height (ctn)";
                        recItem."Width (ctn)" := Item."Width (ctn)";
                        recItem."Length (ctn)" := Item."Length (ctn)";
                        recItem."Volume (ctn)" := Item."Volume (ctn)";
                        recItem."Number per carton" := Item."Number per carton";
                        recItem."Gross Weight" := Item."Gross Weight";
                        recItem."Net Weight" := Item."Net Weight";
                        recItem."Pallet Length (cm)" := Item."Pallet Length (cm)";
                        recItem."Pallet Width (cm)" := Item."Pallet Width (cm)";
                        recItem."Pallet Height (cm)" := Item."Pallet Height (cm)";
                        recItem."UN Code" := Item."UN Code";
                        recItem."Battery weight" := Item."Battery weight";
                        recItem."Carton Weight" := Item."Carton Weight";
                        recItem."Units per Parcel" := Item."Units per Parcel";
                        recItem."Qty Per Pallet" := Item."Qty Per Pallet";
                        recItem."End of Technical Support Date" := Item."End of Technical Support Date";
                        recItem."End of RMA Date" := Item."End of RMA Date";
                        recItem."Tax Reduction rate" := Item."Tax Reduction rate";
                        recItem."Model Description" := Item."Model Description";
                        recItem.GTIN := Item.GTIN;
                        recItem.Validate("Category 1 Code", Item."Category 1 Code");
                        recItem.Validate("Category 2 Code", Item."Category 2 Code");
                        recItem.Validate("Category 3 Code", Item."Category 3 Code");
                        recItem."Business Center" := Item."Business Center";
                        recItem.SBU := Item.SBU;
                        recItem."SBU Company" := Item."SBU Company";
                        recItem."HQ Model Phase" := Item."HQ Model Phase";
                        recItem."Product Length (cm)" := Item."Product Length (cm)";
                        recItem."Number per parcel" := Item."Number per parcel";
                        recItem."Lifecycle Phase" := Item."Lifecycle Phase";
                        recItem."Last Buy Date" := Item."Last Buy Date";
                        recItem.Validate("Qty. per Color Box", Item."Qty. per Color Box");
                        if Item."Cartons Per Pallet" <> 0 then
                            recItem."Cartons Per Pallet" := Item."Cartons Per Pallet";
                        recItem."SCIP No." := Item."SCIP No.";
                        recItem."Tax Reduction Rate Active" := Item."Tax Reduction Rate Active";
                        if recItem."Volume (cm3)" <> 0 then
                            recItem."Unit Volume" := recItem."Volume (cm3)"
                        else
                            if recItem."Volume (ctn)" <> 0 then
                                recItem."Unit Volume" := recItem."Volume (ctn)";
                        recItem."SVHC > 1000 ppm" := Item."SVHC > 1000 ppm";
                        recItem."Product use Battery" := Item."Product use Battery";
                        recItem."WEEE Category" := Item."WEEE Category";
                        recItem."Device Weight" := Item."Device Weight"; //30-09-2026 BK #Request from HQ
                        if recItem."Tariff No." = '' then
                            recItem."Tariff No." := Item."Tariff No.";//30-09-2026 BK #Request from HQ
                        recItem.Modify(true);

                        recReworkItem.SetRange("Update PLMS from Item No.", recItem."No.");
                        if recReworkItem.FindSet(true) then
                            repeat
                                recReworkItem.TransferPlmsFields;
                            until recReworkItem.Next() = 0;

                        WebServLogEntry."Quantity Modified" += 1;
                    end;
                end else begin  // Insert
                    if ItemNoList <> '' then
                        ItemNoList += '; ';
                    ItemNoList += Item."No.";
                end;
            until Item.Next() = 0;

            WebServLogEntry.CloseWebServiceLog;

            if ItemNoList <> '' then begin
                EmailAddMgt.CreateEmailWithBodytext('PLMSUPDATE', ItemNoList, '');
                EmailAddMgt.Send;
            end;

            exit(true);
        end;
    end;

    local procedure InsertHQDimension(pDim: Enum "HQ Dimension"; pCode: Code[50])
    HqDimension: Record SBU;
    begin
        if (pCode <> '') and
           not HqDimension.Get(pDim, pCode)
        then begin
            HqDimension.Type := pDim;
            HqDimension.Code := pCode;
            HqDimension.Description := pCode;
            HqDimension.Insert;
        end;
    end;

    var
        ScipNoTmp: Record "SCIP Number" temporary;
}
