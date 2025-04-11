xmlport 50077 "HQ Sales Price"
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/sp';
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
#pragma warning disable AL0432
            tableelement(SalesPrice; "Sales Price")
#pragma warning restore AL0432
            {
                MinOccurs = Zero;
                XmlName = 'SalesPrice';
                UseTemporary = true;
                fieldelement(ItemNo; SalesPrice."Item No.")
                {
                }
                fieldelement(SalesCode; SalesPrice."Sales Code")
                {
                }
                fieldelement(CurrencyCode; SalesPrice."Currency Code")
                {
                }
                fieldelement(StartingDate; SalesPrice."Starting Date")
                {
                }
                fieldelement(UnitPrice; SalesPrice."Unit Price")
                {
                }
                fieldelement(UnitOfMeasure; SalesPrice."Unit of Measure Code")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    SalesPrice."Minimum Quantity" := 1;
                    if CustPriceGrp.Get(SalesPrice."Sales Code") then
                        SalesPrice."Sales Type" := SalesPrice."sales type"::"Customer Price Group"
                    else
                        if Cust.Get(SalesPrice."Sales Code") then
                            SalesPrice."Sales Type" := SalesPrice."Sales Type"::Customer
                        else
                            Error(WasNotFoundErr, SalesPrice.FieldCaption("Sales Code"), SalesPrice."Sales Code");
                end;
            }
        }
    }

    var
        CustPriceGrp: Record "Customer Price Group";
        Cust: Record Customer;
        WasNotFoundErr: Label '"%1" %2 was not found.';

    procedure SetData(var TempPriceListLine: Record "Price List Line" temporary): Boolean
    begin
        if TempPriceListLine.FindSet() then
            repeat
                SalesPrice.Init();
                SalesPrice."Item No." := TempPriceListLine."Asset No.";
                SalesPrice."Sales Code" := TempPriceListLine."Source No.";
                SalesPrice."Currency Code" := TempPriceListLine."Currency Code";
                SalesPrice."Starting Date" := TempPriceListLine."Starting Date";
                SalesPrice."Unit Price" := TempPriceListLine."Unit Price";
                SalesPrice."Unit of Measure Code" := TempPriceListLine."Unit of Measure Code";
                SalesPrice.Insert();
            until TempPriceListLine.Next() = 0;

        exit(true);
    end;

    procedure GetData(var TempPriceListLine: Record "Price List Line" temporary)
    var
        PriceListHeader: Record "Price List Header";
        PriceHdrNotFoundErr: Label 'No active and relevant Price List Header was found!';
    begin
        if SalesPrice.FindSet() then begin
            PriceListHeader.SetCurrentKey("Source Type", "Source No.", "Starting Date", "Currency Code");
            PriceListHeader.SetFilter(Status, '<>%1', PriceListHeader.Status::Inactive);
            PriceListHeader.SetRange("Source Group", PriceListHeader."Source Group"::Customer);
            PriceListHeader.SetRange("Source Type", PriceListHeader."Source Type"::"Customer Price Group");
            if not PriceListHeader.FindFirst() then begin
                PriceListHeader.SetRange("Source Type", PriceListHeader."Source Type"::"All Customers");
                if not PriceListHeader.FindFirst() then begin
                    PriceListHeader.SetRange("Source Type", PriceListHeader."Source Type"::All);
                    if not PriceListHeader.FindFirst() then
                        Error(PriceHdrNotFoundErr);
                end;
            end;

            repeat
                PriceListHeader.SetFilter("Starting Date", '%1|<=%2', 0D, SalesPrice."Starting Date");
                if not PriceListHeader.FindLast() then begin
                    PriceListHeader.SetRange("Starting Date");
                    if not PriceListHeader.FindLast() then
                        Error(PriceHdrNotFoundErr);
                end;

                TempPriceListLine.Init();
                TempPriceListLine."Price List Code" := PriceListHeader.Code;
                TempPriceListLine.SetNextLineNo();
                TempPriceListLine.SetNewRecord(true);
                TempPriceListLine."Asset Type" := TempPriceListLine."Asset Type"::Item;
                TempPriceListLine."Asset No." := SalesPrice."Item No.";
                TempPriceListLine."Source Group" := PriceListHeader."Source Group";
                TempPriceListLine.Validate("Source Type", PriceListHeader."Source Type");
                TempPriceListLine.Validate("Source No.", SalesPrice."Sales Code");
                TempPriceListLine.Validate("Asset Type", TempPriceListLine."Asset Type"::Item);
                TempPriceListLine.Validate("Asset No.", SalesPrice."Item No.");
                TempPriceListLine.Validate("Amount Type", TempPriceListLine."Amount Type"::Price);
                TempPriceListLine."Currency Code" := SalesPrice."Currency Code";
                TempPriceListLine."Starting Date" := SalesPrice."Starting Date";
                TempPriceListLine."Unit Price" := SalesPrice."Unit Price";
                TempPriceListLine."Unit of Measure Code" := SalesPrice."Unit of Measure Code";
                TempPriceListLine."Minimum Quantity" := 1;
                TempPriceListLine.Insert(true);
            until SalesPrice.Next() = 0;
        end;
    end;
}
