codeunit 50002 "Report Event"
{
    // 001. 06-07-21 ZY-LD P0625 - Transfer currency code for sales doc sub.
    // 002. 17-08-21 ZY-LD 2021081710000128 - Ship-to VAT.
    // 003. 15-09-21 ZY-LD 2021091310000081 - We can´t use Your Reference.
    // 004. 10-05-22 ZY-LD 000 - Create sales invoice per location code.
    // 005. 10-06-22 ZY-LD 2022061010000099 - EU 3-Party Trade.
    // 006. 08-07-24 ZY-LD 000 - Set correct country dimension on sample invoice.
    // 007. 21-08-24 ZY-LD #449671 - Somehow the filter on country/region code was not adapted from NAV.

    trigger OnRun()
    begin
    end;

    #region Exch. Rate Adjustment
    [EventSubscriber(Objecttype::Report, Report::"Exch. Rate Adjustment", 'OnBeforeOpenPage', '', false, false)]
    local procedure OnAfterOpenRequestPage(var AdjGLAcc: Boolean)
    var
        recGenSetup: Record "General Ledger Setup";
    begin
        recGenSetup.Get();
        AdjGlAcc := recGenSetup."Additional Reporting Currency" <> '';
    end;
    #endregion

    #region Combine Shipments ZX
    [EventSubscriber(Objecttype::Report, Report::"Combine Shipments ZX", 'OnBeforeValidateCustomerNo', '', false, false)]
    local procedure CombineShipmentsZX_OnBeforeValidateCustomerNo(var ToSalesHeader: Record "Sales Header"; var FromSalesOrderHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line"; var IsHandled: Boolean)
    begin
        ToSalesHeader.Validate("Sales Order Type", FromSalesOrderHeader."Sales Order Type");
    end;

    [EventSubscriber(Objecttype::Report, Report::"Combine Shipments ZX", 'OnBeforeSalesInvHeaderModify', '', false, false)]
    local procedure OnAfterValidateBillToCustomerNoInsertSalesInvHeader(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header")
    var
        SI: Codeunit "Single Instance";
        recWhseOutbHead: Record "VCK Delivery Document Header";
        recSellToCust: Record Customer;
        PickingListNo: Code[20];
        ShipmentMethodCode: Code[10];
    begin
        SalesHeader.SetHideValidationDialog(true);
        //>> 10-05-22 ZY-LD 004
        SI.SetKeepLocationCode(true);
        SalesHeader.Validate(SalesHeader."Location Code", SalesOrderHeader."Location Code");
        SI.SetKeepLocationCode(false);
        //<< 10-05-22 ZY-LD 004

        //>> 09-07-20 ZY-LD 003
        PickingListNo := SalesOrderHeader.GetFilter("Picking List No. Filter");
        if recWhseOutbHead.Get(PickingListNo) and (recWhseOutbHead."Delivery Terms Terms" <> '') then
            ShipmentMethodCode := recWhseOutbHead."Delivery Terms Terms"
        else
            ShipmentMethodCode := SalesOrderHeader."Shipment Method Code";
        //<< 09-07-20 ZY-LD 003

        SalesHeader."External Document No." := SalesOrderHeader."External Document No.";  // 01-11-19 ZY-LD 001
        SalesHeader.Validate(SalesHeader."Ship-to Code", SalesOrderHeader."Ship-to Code");  // 01-11-19 ZY-LD 001
        SalesHeader.Validate(SalesHeader."Shipment Method Code", ShipmentMethodCode);  // 09-07-20 ZY-LD 003
        SalesHeader.Validate(SalesHeader."Currency Code", SalesOrderHeader."Currency Code");  // 09-07-20 ZY-LD 003
        SalesHeader.Validate(SalesHeader."Customer Document No.", SalesOrderHeader."Customer Document No.");
        SalesHeader.Validate(SalesHeader."SAP No.", SalesOrderHeader."SAP No.");

        //>> 17-06-20 ZY-LD 002
        recSellToCust.Get(SalesHeader."Sell-to Customer No.");
        if recSellToCust."Create Invoice pr. Order" then begin
            //>> 15-09-21 ZY-LD 003
            //"Your Reference" := SalesOrderHeader."No.";
            SalesHeader."Create Invoice pr. Order No." := SalesOrderHeader."No.";
            SalesHeader."Your Reference" := SalesHeader."External Document No.";
            //<< 15-09-21 ZY-LD 003
        end;
        //<< 17-06-20 ZY-LD 002

        SalesHeader.Validate(SalesHeader."Currency Code Sales Doc SUB", SalesOrderHeader."Currency Code Sales Doc SUB");  // 06-07-21 ZY-LD 001
        SalesHeader.Validate(SalesHeader."Ship-to VAT", SalesOrderHeader."Ship-to VAT");  // 17-08-21 ZY-LD 002

        SalesHeader.SetHideValidationDialog(false);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Combine Shipments ZX", 'OnAfterInsertSalesInvHeader', '', false, false)]
    local procedure CombineShipmentsZX_OnAfterInsertSalesInvHeader(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        Cust: Record Customer;
        GenLedgSetup: Record "General Ledger Setup";
        DefaultDim: Record "Default Dimension";
        DimSetEntry: Record "Dimension Set Entry";
    begin
        //>> 08-07-24 ZY-LD 006
        if Cust.get(SalesHeader."Sell-to Customer No.") and Cust."Sample Account" then begin
            GenLedgSetup.get;
            IF DefaultDim.get(Database::Customer, SalesHeader."Sell-to Customer No.", GenLedgSetup."Shortcut Dimension 3 Code") and
               (DefaultDim."Value Posting" IN [DefaultDim."Value Posting"::"Code Mandatory", DefaultDim."Value Posting"::"Same Code"])
            then
                if DimSetEntry.get(SalesShipmentHeader."Dimension Set ID", GenLedgSetup."Shortcut Dimension 3 Code") then
                    SalesHeader.ValidateShortcutDimCode(3, DimSetEntry."Dimension Value Code");
        end;
        //<< 08-07-24 ZY-LD 006
    end;
    #endregion

    procedure GetEUArticle(pShipToCountry: Code[20]; pSellToCountry: Code[20]; pVATBusPostGrp: Code[20]; pVATProdPostGrp: Code[20]; pCustNo: Code[20]; pEUThreePartyTrade: Boolean; var pArticleText: Text)
    var
        recVatPostSetup: Record "VAT Posting Setup";
        recCountry: Record "Country/Region";
        xrecEUArticle: Record "EU Article";
        recEUArticleSetup: Record "EU Article Setup";
    begin
        //>> 10-06-22 ZY-LD 005
        //>> 08-02-21 ZY-LD 009
        if pShipToCountry = '' then
            pShipToCountry := pSellToCountry;
        recCountry.Get(pShipToCountry);
        if recCountry."EU Country/Region Code" <> '' then begin
            recEUArticleSetup.SetAutoCalcFields("EU Article Description");
            if recEUArticleSetup.Get(pVATBusPostGrp, pVATProdPostGrp, pEUThreePartyTrade) then begin
                recEUArticleSetup.TestField("EU Article Code");

                if StrPos(pArticleText, recEUArticleSetup."EU Article Description") = 0 then
                    if pArticleText = '' then
                        pArticleText := recEUArticleSetup."EU Article Description"
                    else
                        pArticleText += '; ' + recEUArticleSetup."EU Article Description";
            end;

            /*recVatPostSetup.GET(pVATBusPostGrp,pVATProdPostGrp);
            IF recVatPostSetup."VAT Calculation Type" = recVatPostSetup."VAT Calculation Type"::"Reverse Charge VAT" THEN
              recVatPostSetup.TESTFIELD("EU Article Code");

            IF recEUArticle.GET(recVatPostSetup."EU Article Code") THEN
              IF StrPos(pArticleText,recEUArticle.Description) = 0 THEN
                IF pArticleText = '' THEN
                  pArticleText := recEUArticle.Description
                ELSE
                  pArticleText += '; ' + recEUArticle.Description;*/
        end;
        //<< 08-02-21 ZY-LD 009
        //<< 10-06-22 ZY-LD 005
    end;

    #region Report Selections
    [EventSubscriber(ObjectType::Table, Database::"Report Selections", 'OnFindReportSelections', '', false, false)]
    local procedure ReportSelections_OnFindReportSelections(var FilterReportSelections: Record "Report Selections"; var IsHandled: Boolean; var ReturnReportSelections: Record "Report Selections"; AccountNo: Code[20]; TableNo: Integer)
    var
        Cust: Record Customer;
        ReportSelections: Record "Report Selections";
        CustomReportSelection: Record "Custom Report Selection";
    begin
        if (TableNo = Database::"Customer") and Cust.Get(AccountNo) then begin
            FilterReportSelections.Reset();
            FilterReportSelections.DeleteAll();

            CustomReportSelection.SetFilter(Usage, ReturnReportSelections.GetFilter(Usage));
            CustomReportSelection.SetRange("Source Type", TableNo);
            CustomReportSelection.SetRange("Source No.", AccountNo);
            if not CustomReportSelection.IsEmpty() then begin
                CustomReportSelection.SetFilter("Use for Email Attachment", ReturnReportSelections.GetFilter("Use for Email Attachment"));
                CustomReportSelection.SetFilter("Use for Email Body", ReturnReportSelections.GetFilter("Use for Email Body"));
            end;
            if CustomReportSelection.FindSet() then
                repeat
                    if CustomReportSelection."Report ID" = 0 then begin
                        ReportSelections.SetRange(Usage, CustomReportSelection.Usage);
                        ReportSelections.SetRange("Use for Email Attachment", true);
                        ReportSelections.SetFilter("Report ID", '<>0');
                        ReportSelections.SetRange("Country/Region Code", Cust."Country/Region Code");
                        if ReportSelections.FindLast() then
                            ReportSelections.SetRange("Country/Region Code", ReportSelections."Country/Region Code")
                        else
                            ReportSelections.SetRange("Country/Region Code", '');
                        if ReportSelections.FindSet() then
                            repeat
                                FilterReportSelections.Usage := CustomReportSelection.Usage;
                                FilterReportSelections.Sequence := ReportSelections.Sequence;
                                FilterReportSelections."Report ID" := ReportSelections."Report ID";
                                FilterReportSelections."Custom Report Layout Code" := CustomReportSelection."Custom Report Layout Code";
                                FilterReportSelections."Email Body Layout Code" := CustomReportSelection."Email Body Layout Code";
                                FilterReportSelections."Use for Email Attachment" := CustomReportSelection."Use for Email Attachment";
                                FilterReportSelections."Use for Email Body" := CustomReportSelection."Use for Email Body";
                                if FilterReportSelections.Insert() then;
                            until ReportSelections.Next() = 0;
                    end else begin
                        FilterReportSelections.Usage := CustomReportSelection.Usage;
                        FilterReportSelections.Sequence := Format(CustomReportSelection.Sequence);
                        FilterReportSelections."Report ID" := CustomReportSelection."Report ID";
                        FilterReportSelections."Custom Report Layout Code" := CustomReportSelection."Custom Report Layout Code";
                        FilterReportSelections."Email Body Layout Code" := CustomReportSelection."Email Body Layout Code";
                        FilterReportSelections."Use for Email Attachment" := CustomReportSelection."Use for Email Attachment";
                        FilterReportSelections."Use for Email Body" := CustomReportSelection."Use for Email Body";
                        if FilterReportSelections.Insert() then;
                    end;
                until CustomReportSelection.Next() = 0
            else begin
                //>> 21-08-24 ZY-LD 007
                if (TableNo = Database::"Customer") and Cust.Get(AccountNo) then begin
                    ReturnReportSelections.SetFilter("Country/Region Code", '%1|%2', '', Cust."Country/Region Code");
                    if ReturnReportSelections.FindLast() then
                        ReturnReportSelections.SetRange("Country/Region Code", ReturnReportSelections."Country/Region Code");
                end;
                //<< 21-08-24 ZY-LD 007

                if ReturnReportSelections.FindSet() then begin
                    FilterReportSelections := ReturnReportSelections;
                    if FilterReportSelections.Insert() then;
                end;
            end;

            IsHandled := true;
        end;
    end;
    #endregion
}
