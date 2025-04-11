XmlPort 50026 "HQ PLMS"
{
    // 001. 30-08-18 ZY-LD 000 - Number pr. parcel is added.
    // 002. 18-10-19 ZY-LD 000 - SBU Company is added.
    // 003. 23-03-20 ZY-LD P0394 - New fields.
    // 004. 11-08-20 ZY-LD 000 - Qty. per Color Box is added.
    // 005. 15-12-20 ZY-LD 000 - FieldValidate is set to NO on the category fields.
    // 006. 02-03-22 ZY-LD 2022030210000038 - Handle Tax Reduction Rate. It can be N/A.
    // 007. 17-05-23 ZY-LD 000 - WEEE Category.
    // 008. 16-04-24 ZY-LD 000 - SCIP No. is moved to a sub table. At the same time code from 50077 has been moved to GetData.

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
                        //>> 02-03-22 ZY-LD 006
                        if TaxReductionRate in ['NA', 'N/A'] then begin
                            Item."Tax Reduction Rate Active" := false;
                            Item."Tax Reduction rate" := 0;
                        end else begin
                            Evaluate(Item."Tax Reduction rate", TaxReductionRate);
                            Item."Tax Reduction Rate Active" := true;
                        end;
                        //<< 02-03-22 ZY-LD 006
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
                //>> 16-04-24 ZY-LD 008
                /*fieldelement(ScipNo; Item."SCIP No.")
                {
                }*/
                textelement(ScipNo)
                {
                }
                //<< 16-04-24 ZY-LD 
                fieldelement(SvhcHigherThan1000ppm; Item."SVHC > 1000 ppm")
                {
                }
                textelement(ProductUseBattery)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        //>> 17-05-23 ZY-LD 007
                        case UpperCase(ProductUseBattery) of
                            'NO':
                                Item."Product use Battery" := Item."product use battery"::No;
                            'YES':
                                Item."Product use Battery" := Item."product use battery"::Yes;
                            else
                                Item."Product use Battery" := Item."product use battery"::" ";
                        end;
                        //<< 17-05-23 ZY-LD 007
                    end;
                }
                fieldelement(WeeeCategory; Item."WEEE Category")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    //>> 18-10-19 ZY-LD 002
                    case UpperCase(SbuCompany) of
                        'ZCOM':
                            Item."SBU Company" := Item."sbu company"::"ZCom HQ";
                        'ZNET':
                            Item."SBU Company" := Item."sbu company"::"ZNet HQ";
                    end;
                    //<< 18-10-19 ZY-LD 002

                    //>> 16-04-24 ZY-LD 008
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
                        //<< 16-04-24 ZY-LD 008
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

    //>> 16-04-24 ZY-LD 008
    /*
        procedure GetDataOLD(var pItem: Record Item temporary; var pHqDimension: Record SBU temporary)
        begin
            if Item.FindSet then
                repeat
                    pItem := Item;
                    pItem.Insert;

                    //>> 18-10-19 ZY-LD 002
                    if (Item."Category 1 Code" <> '') and
                       not pHqDimension.Get(pHqDimension.Type::"Category 1", Item."Category 1 Code")
                    then begin
                        pHqDimension.Type := pHqDimension.Type::"Category 1";
                        pHqDimension.Code := Item."Category 1 Code";
                        pHqDimension.Description := Item."Category 1 Code";
                        pHqDimension.Insert;
                    end;
                    if (Item."Category 2 Code" <> '') and
                       not pHqDimension.Get(pHqDimension.Type::"Category 2", Item."Category 2 Code")
                    then begin
                        pHqDimension.Type := pHqDimension.Type::"Category 2";
                        pHqDimension.Code := Item."Category 2 Code";
                        pHqDimension.Description := Item."Category 2 Code";
                        pHqDimension.Insert;
                    end;
                    if (Item."Category 3 Code" <> '') and
                       not pHqDimension.Get(pHqDimension.Type::"Category 3", Item."Category 3 Code")
                    then begin
                        pHqDimension.Type := pHqDimension.Type::"Category 3";
                        pHqDimension.Code := Item."Category 3 Code";
                        pHqDimension.Description := Item."Category 3 Code";
                        pHqDimension.Insert;
                    end;
                    if (Item."Business Center" <> '') and
                       not pHqDimension.Get(pHqDimension.Type::"Business Center", Item."Business Center")
                    then begin
                        pHqDimension.Type := pHqDimension.Type::"Business Center";
                        pHqDimension.Code := Item."Business Center";
                        pHqDimension.Description := Item."Business Center";
                        pHqDimension.Insert;
                    end;
                    if (Item.SBU <> '') and
                       not pHqDimension.Get(pHqDimension.Type::SBU, Item.SBU)
                    then begin
                        pHqDimension.Type := pHqDimension.Type::SBU;
                        pHqDimension.Code := Item.SBU;
                        pHqDimension.Description := Item.SBU;
                        pHqDimension.Insert;
                    end;
                    //<< 18-10-19 ZY-LD 002

                    //>> 17-05-23 ZY-LD 007
                    if (Item."WEEE Category" <> '') and
                       not pHqDimension.Get(pHqDimension.Type::"WEEE Category", Item."WEEE Category")
                    then begin
                        pHqDimension.Type := pHqDimension.Type::"WEEE Category";
                        pHqDimension.Code := Item."WEEE Category";
                        pHqDimension.Description := Item."WEEE Category";
                        pHqDimension.Insert;
                    end;
                //<< 17-05-23 ZY-LD 007
                until Item.Next() = 0;
        end;
    */
    //<< 16-04-24 ZY-LD 008
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
                       //(recItem."Category 4 Code" <> Item."Category 4 Code") OR  // 23-07-18 ZY-LD 001
                       (recItem."Business Center" <> Item."Business Center") or
                       (recItem.SBU <> Item.SBU) or
                       (recItem."SBU Company" <> Item."SBU Company") or  // 24-10-19 ZY-LD 021
                       (recItem."HQ Model Phase" <> Item."HQ Model Phase") or
                       (recItem."Product Length (cm)" <> Item."Product Length (cm)") or  // 17-08-18 ZY-LD 002
                       (recItem."Lifecycle Phase" <> Item."Lifecycle Phase") or  // 23-03-20 ZY-LD 026
                       (recItem."Last Buy Date" <> Item."Last Buy Date") or  // 23-03-20 ZY-LD 026
                       (recItem."Qty. per Color Box" <> Item."Qty. per Color Box") or  // 11-08-20 ZY-LD 030
                       ((recItem."Cartons Per Pallet" <> Item."Cartons Per Pallet") and (Item."Cartons Per Pallet" <> 0) or  // 11-09-20 ZY-LD 031
                       (recItem."SCIP No." <> Item."SCIP No.") or  // 06-01-21 ZY-LD 035
                       (recItem."Tax Reduction Rate Active" <> Item."Tax Reduction Rate Active") or  // 03-03-22 ZY-LD 045
                       (recItem."SVHC > 1000 ppm" <> Item."SVHC > 1000 ppm") or  // 02-11-22 ZY-LD 057
                       (recItem."Product use Battery" <> Item."Product use Battery") or  // 17-05-23 ZY-LD 064
                       (recItem."WEEE Category" <> Item."WEEE Category"))  // 17-05-23 ZY-LD 064
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
                        recItem.Validate("Category 1 Code", Item."Category 1 Code");  // 19-10-20 ZY-LD 032
                        recItem.Validate("Category 2 Code", Item."Category 2 Code");  // 19-10-20 ZY-LD 032
                        recItem.Validate("Category 3 Code", Item."Category 3 Code");  // 19-10-20 ZY-LD 032
                                                                                      //recItem."Category 4 Code" := pItemTmp."Category 4 Code";  // 23-07-18 ZY-LD 001
                        recItem."Business Center" := Item."Business Center";
                        recItem.SBU := Item.SBU;
                        recItem."SBU Company" := Item."SBU Company";  // 24-10-19 ZY-LD 021
                        recItem."HQ Model Phase" := Item."HQ Model Phase";
                        recItem."Product Length (cm)" := Item."Product Length (cm)";  // 17-08-18 ZY-LD 002
                        recItem."Number per parcel" := Item."Number per parcel";  // 30-08-18 ZY-LD 003
                        recItem."Lifecycle Phase" := Item."Lifecycle Phase";  // 23-03-20 ZY-LD 026
                        recItem."Last Buy Date" := Item."Last Buy Date";  // 23-03-20 ZY-LD 026
                        recItem.Validate("Qty. per Color Box", Item."Qty. per Color Box");  // 11-08-20 ZY-LD 030
                        if Item."Cartons Per Pallet" <> 0 then  // 11-09-20 ZY-LD 031
                            recItem."Cartons Per Pallet" := Item."Cartons Per Pallet";  // 11-09-20 ZY-LD 031
                        recItem."SCIP No." := Item."SCIP No.";  // 06-01-21 ZY-LD 035
                        recItem."Tax Reduction Rate Active" := Item."Tax Reduction Rate Active";  // 03-03-22 ZY-LD 045
                                                                                                  //>> 17-03-22 ZY-LD 046
                        if recItem."Volume (cm3)" <> 0 then
                            recItem."Unit Volume" := recItem."Volume (cm3)"
                        else
                            if recItem."Volume (ctn)" <> 0 then
                                recItem."Unit Volume" := recItem."Volume (ctn)";
                        //<< 17-03-22 ZY-LD 046
                        recItem."SVHC > 1000 ppm" := Item."SVHC > 1000 ppm";  // 02-11-22 ZY-LD 057
                        recItem."Product use Battery" := Item."Product use Battery";  // 17-05-23 ZY-LD 064
                        recItem."WEEE Category" := Item."WEEE Category";  // 17-05-23 ZY-LD 064
                        recItem.Modify(true);

                        //>> 24-03-23 ZY-LD 062
                        recReworkItem.SetRange("Update PLMS from Item No.", recItem."No.");
                        if recReworkItem.FindSet(true) then
                            repeat
                                recReworkItem.TransferPlmsFields;
                            until recReworkItem.Next() = 0;
                        //<< 24-03-23 ZY-LD 062

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
        //<< 16-04-24 ZY-LD 008
    end;

    local procedure InsertHQDimension(pDim: Enum "HQ Dimension"; pCode: Code[50])
    HqDimension: Record SBU;
    begin
        //>> 16-04-24 ZY-LD 008
        if (pCode <> '') and
           not HqDimension.Get(pDim, pCode)
        then begin
            HqDimension.Type := pDim;
            HqDimension.Code := pCode;
            HqDimension.Description := pCode;
            HqDimension.Insert;
        end;
        //<< 16-04-24 ZY-LD 008
    end;

    var
        ScipNoTmp: Record "SCIP Number" temporary;  // 16-04-24 ZY-LD 008
}
