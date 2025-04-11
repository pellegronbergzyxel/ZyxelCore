xmlport 50076 "HQ Purchase Price"
{
    // 001. 26-03-24 ZY-LD 000 - We can´t use the default, because if there are more than one line they will get the same line no.
    // 002. 02-09-24 ZY-LD 000 - We expect only the four different values.

    DefaultNamespace = 'urn:microsoft-dynamics-nav/pp';
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
#pragma warning disable AL0432
            tableelement(PurchasePrice; "Purchase Price")
#pragma warning restore AL0432
            {
                MinOccurs = Zero;
                XmlName = 'PurchasePrice';
                UseTemporary = true;
                fieldelement(ItemNo; PurchasePrice."Item No.")
                {
                }
                textelement(Vendor)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Vendor := VendCode;
                    end;
                }
                fieldelement(CurrencyCode; PurchasePrice."Currency Code")
                {
                }
                fieldelement(StartingDate; PurchasePrice."Starting Date")
                {
                }
                fieldelement(UnitCost; PurchasePrice."Direct Unit Cost")
                {
                }
                fieldelement(UnitOfMeasure; PurchasePrice."Unit of Measure Code")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    case UpperCase(Vendor) of
                        'ZCOMHQ':
                            Vend.SetRange("SBU Company", Vend."SBU Company"::"ZCom HQ");
                        'ZCOMEMEA':
                            Vend.SetRange("SBU Company", Vend."SBU Company"::"ZCom EMEA");
                        'ZNETHQ':
                            Vend.SetRange("SBU Company", Vend."SBU Company"::"ZNet HQ");
                        'ZNETEMEA':
                            Vend.SetRange("SBU Company", Vend."SBU Company"::"ZNet EMEA");
                        else
                            error(Text001);  // 02-09-24 ZY-LD 002
                    end;

                    Vend.FindFirst();
                    PurchasePrice."Vendor No." := Vend."No.";
                    PurchasePrice."Minimum Quantity" := 1;
                end;
            }
        }
    }

    var
        Vend: Record Vendor;
        VendCode: Code[10];
        Text001: Label 'Unexpected vendor code. Expected values are "ZCOMHQ, ZNETHQ, ZCOMEMEA,ZNETEMEA';  // 02-09-24 ZY-LD 002

    procedure SetData(VendorCode: Code[10]; var TempPriceListLine: Record "Price List Line" temporary): Boolean
    begin
        if TempPriceListLine.FindSet() then begin
            VendCode := VendorCode;
            repeat
                PurchasePrice.Init();
                PurchasePrice."Item No." := TempPriceListLine."Asset No.";
                PurchasePrice."Currency Code" := TempPriceListLine."Currency Code";
                PurchasePrice."Starting Date" := TempPriceListLine."Starting Date";
                PurchasePrice."Direct Unit Cost" := TempPriceListLine."Direct Unit Cost";
                PurchasePrice."Unit of Measure Code" := TempPriceListLine."Unit of Measure Code";
                PurchasePrice.Insert();
            until TempPriceListLine.Next() = 0;

            exit(true);
        end;
    end;

    procedure GetData(var TempPriceListLine: Record "Price List Line" temporary)
    var
        PriceListHeader: Record "Price List Header";
        LiNo: Integer;
        PriceHdrNotFoundErr: Label 'No active and relevant Price List Header was found!';
    begin
        if PurchasePrice.FindSet() then begin
            PriceListHeader.SetCurrentKey("Source Type", "Source No.", "Starting Date", "Currency Code");
            PriceListHeader.SetFilter(Status, '<>%1', PriceListHeader.Status::Inactive);
            PriceListHeader.SetRange("Source Group", PriceListHeader."Source Group"::Vendor);
            PriceListHeader.SetRange("Source Type", PriceListHeader."Source Type"::Vendor);
            if not PriceListHeader.FindFirst() then begin
                PriceListHeader.SetRange("Source Type", PriceListHeader."Source Type"::"All Vendors");
                if not PriceListHeader.FindFirst() then begin
                    PriceListHeader.SetRange("Source Type", PriceListHeader."Source Type"::All);
                    if not PriceListHeader.FindFirst() then
                        Error(PriceHdrNotFoundErr);
                end;
            end;

            repeat
                PriceListHeader.SetFilter("Starting Date", '%1|<=%2', 0D, PurchasePrice."Starting Date");
                if not PriceListHeader.FindLast() then begin
                    PriceListHeader.SetRange("Starting Date");
                    if not PriceListHeader.FindLast() then
                        Error(PriceHdrNotFoundErr);
                end;

                TempPriceListLine.Init();
                TempPriceListLine."Price List Code" := PriceListHeader.Code;
                //>> 26-03-24 ZY-LD 001
                //TempPriceListLine.SetNextLineNo();
                LiNo += 10000;
                TempPriceListLine."Line No." := LiNo;
                //<< 26-03-24 ZY-LD 001
                TempPriceListLine.SetNewRecord(true);
                TempPriceListLine."Asset Type" := TempPriceListLine."Asset Type"::Item;
                TempPriceListLine."Asset No." := PurchasePrice."Item No.";
                TempPriceListLine."Source Group" := PriceListHeader."Source Group";
                if PurchasePrice."Vendor No." <> '' then
                    TempPriceListLine.Validate("Source Type", TempPriceListLine."Source Type"::Vendor)
                else
                    TempPriceListLine.Validate("Source Type", PriceListHeader."Source Type");
                TempPriceListLine.Validate("Source No.", PurchasePrice."Vendor No.");
                if PriceListHeader."Source Type" <> PriceListHeader."Source Type"::Vendor then
                    TempPriceListLine."Source No." := PurchasePrice."Vendor No.";
                TempPriceListLine.Validate("Asset Type", TempPriceListLine."Asset Type"::Item);
                TempPriceListLine.Validate("Asset No.", PurchasePrice."Item No.");
                TempPriceListLine.Validate("Amount Type", TempPriceListLine."Amount Type"::Price);
                TempPriceListLine.Validate("Price Type", PriceListHeader."Price Type");
                TempPriceListLine."Currency Code" := PurchasePrice."Currency Code";
                TempPriceListLine."Starting Date" := PurchasePrice."Starting Date";
                TempPriceListLine."Direct Unit Cost" := PurchasePrice."Direct Unit Cost";
                TempPriceListLine."Unit of Measure Code" := PurchasePrice."Unit of Measure Code";
                TempPriceListLine."Minimum Quantity" := 1;
                TempPriceListLine.Insert(true);
            until PurchasePrice.Next() = 0;
        end;
    end;
}
