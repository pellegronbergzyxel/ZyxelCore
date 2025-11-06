tableextension 50226 PriceListLineZX extends "Price List Line"
{
    fields
    {
        field(50001; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Asset No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Automatically Added"; Boolean)
        {
            Description = 'PAB 1.0';
            InitValue = false;
        }
        field(50005; "New Price"; Boolean)
        {
            Caption = 'New Price';
            InitValue = true;
        }
    }
    procedure EnterNewSalesPrice()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPrice: Record "Price List Line";
        SalesPriceTmp: Record "Price List Line" temporary;
        PriceListHeader: Record "Price List Header";
        PriceListMgt: Codeunit "Price List Management";
        SI: Codeunit "Single Instance";
        NewSalesPrice: Page "New Sales Price";
        lText001: Label 'Before the price is active the margin has to be approved by HQ. You can follow the status on the sales price line.';
        lText002: Label 'The price could not be created.';
        lText003: Label 'The price will be sent to HQ for margin approval.\When approved, the price will automatic be validated and active.\If not approved, you will be notified for a comment and the price will be sent for re-approval.\You can follow the status on the price list or in the list "Margin Approval".';
    begin
        SalesPriceTmp.Validate("Source Type", SalesPriceTmp."Source Type"::Customer);
        if SI.GetCustomerNo <> '' then
            SalesPriceTmp.Validate("Assign-to No.", SI.GetCustomerNo);
        SalesPriceTmp.Validate("Asset Type", Rec."Asset Type"::Item);
        if SI.GetItemNo <> '' then
            SalesPriceTmp.Validate("Product No.", SI.GetItemNo);
        SalesPriceTmp.Insert;
        if Page.RunModal(Page::"New Sales Price", SalesPriceTmp) = Action::LookupOK then begin
            if (SalesPriceTmp."Assign-to No." <> '') and
               (SalesPriceTmp."Currency Code" <> '') and
               (SalesPriceTmp."Product No." <> '') and
               (SalesPriceTmp."Starting Date" <> 0D) and
               (SalesPriceTmp."Ending Date" <> 0D) and
               (SalesPriceTmp."Unit Price" <> 0)
            then begin
                SalesPrice.Init();
                SalesPrice.Validate("Price List Code", SalesPriceTmp."Price List Code");
                SalesPrice.SetNextLineNo();
                SalesPrice.Validate("Source Type", SalesPriceTmp."Source Type");
                SalesPrice.Validate("Assign-to No.", SalesPriceTmp."Assign-to No.");
                SalesPrice.Validate("Currency Code", SalesPriceTmp."Currency Code");
                SalesPrice.Validate("Asset Type", SalesPriceTmp."Asset Type");
                SalesPrice.Validate("Product No.", SalesPriceTmp."Product No.");
                SalesPrice.Validate("Starting Date", SalesPriceTmp."Starting Date");
                SalesPrice.Validate("Ending Date", SalesPriceTmp."Ending Date");
                SalesPrice.Validate("Minimum Quantity", SalesPriceTmp."Minimum Quantity");
                SalesPrice.Validate("Unit Price", SalesPriceTmp."Unit Price");
                if SalesPrice.Insert(true) then begin
                    SalesSetup.get;
                    if not SalesSetup."Margin Approval" then begin //30-10-2025 BK #MarginApproval
                        if PriceListHeader.Get(SalesPrice."Price List Code") and (PriceListHeader.Status = PriceListHeader.Status::Active) then
                            PriceListMgt.ActivateDraftLines(PriceListHeader);
                    end else
                        Message(lText003);
                end else
                    Message(lText002);
            end;
            SI.SetCustomerNo('');
            SI.SetItemNo('');
        end;
    end;
}
