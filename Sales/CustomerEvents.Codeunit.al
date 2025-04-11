Codeunit 50070 "Customer Events"
{
    // 001. 21-03-18 ZY-LD 2018011010000196 - Print Statement is set.
    // 002. 16-08-18 ZY-LD 2018081610000289 - Automatic creation of Territory countries.
    // 003. 20-08-18 ZY-LD 2018082010000182 - Territory Code and Country/Region Code.
    // 004. 02-11-18 ZY-LD 2018103110000111 - Extra fields for replication.
    // 005. 06-11-18 ZY-LD 2018060810000271 - Update E-mail as invoice e-mail.
    // 006. 13-11-18 ZY-LD 0062018111310000028 - Rewritten the code.
    // 007. 26-11-18 ZY-LD 0072018111910000071 - Territory Code.
    // 008. 26-11-18 ZY-LD 000 - Update invoice and credit memo e-mail address.
    // 009. 27-05-19 ZY-LD P0213 - Force replication on customers.
    // 010. 26-08-19 ZY-LD 000 - Validate EiCard address.
    // 011. 25-09-19 ZY-LD P0309 - New field.
    // 012. 06-11-19 ZY-LD P0332 - Validation of e-mail and set "Post Eicard Invoice Automatic".
    // 013. 03-02-20 ZY-LD 000 - Block price group.
    // 014. 09-07-20 ZY-LD P0455 - Transfer "Shipment Method Code" from customer at creation.
    // 015. 23-09-20 ZY-LD P0479 - Create contact on insert.
    // 016. 12-10-20 ZY-LD 000 - Code moved from table 18.
    // 017. 11-11-20 ZY-LD P0517 - Validation of e-mail.
    // 018. 17-11-20 ZY-LD P0499 - Init Value for ZNet.
    // 019. 29-01-21 ZY-LD 2021012810000165 - "Combine Shipments" is set default for both companies.
    // 020. 03-02-21 ZY-LD P0557 - Sample setup.
    // 021. 08-02-21 ZY-LD 2021011510000162 - Show page.
    // 022. 03-08-21 ZY-LD 000 - Reminder for updating sales orders.
    // 023. 18-08-21 ZY-LD 2021081710000128 - We need the country code here too.
    // 024. 03-03-22 ZY-LD 2022020410000063 - Set "E-mail Deliv. Note at Release" to TRUE.
    // 025. 03-02-23 ZY-LD 000 - We have seen active ship-to addresses been deleted.
    // 026. 20-11-23 ZY-LD 000 - If "Report ID" is zero, it will use the report selection to find the report.
    // 027. 22-07-24 ZY-LD 000 - Update sales order with the new code.

    trigger OnRun()
    begin
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        ModifyPage301: Boolean;
        ModifyPage540: Boolean;
        ModifyPage542: Boolean;

    #region Customer
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        begin
            if ZGT.IsRhq then begin
                //>> 06-11-19 ZY-LD 012
                if ZGT.IsZNetCompany then begin  // 29-01-21 ZY-LD 019
                    Rec."Post EiCard Invoice Automatic" := Rec."post eicard invoice automatic"::"Yes (when purchase invoice is posted)";
                    //"Combine Shipments" := TRUE;  // 29-01-21 ZY-LD 019
                    Rec."Minimum Order Value Enabled" := true;  // 17-11-20 ZY-LD 018
                    Rec."E-mail Deliv. Note at Release" := true;  // 03-03-22 ZY-LD 024
                end;
                //<< 06-11-19 ZY-LD 012

                Rec."Combine Shipments" := true;  // 29-01-21 ZY-LD 019
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    var
        lText001: label '"%1" is blank. Do you want continue?';
        lText002: label 'Modification is stopped.';
    begin
        //>> 16-08-18 ZY-LD 002
        if ZGT.IsRhq and GuiAllowed then
            if Rec."Territory Code" = '' then
                if not Confirm(lText001, false, Rec.FieldCaption(Rec."Territory Code")) then
                    Error(lText002);
        //<< 16-08-18 ZY-LD 002
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    var
        recCust: Record Customer;
    begin
        begin
            //>> 23-09-20 ZY-LD 015
            if not Rec.IsTemporary then
                if ZGT.IsRhq then begin
                    recCust.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Create Conts. from Customers", false, false, recCust);
                end;
            //<< 23-09-20 ZY-LD 015
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Name', false, false)]
    local procedure OnBeforeValidateCustomerName(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.Name := recConvChar.ConvertCharacters(Rec.Name);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Name 2', false, false)]
    local procedure OnBeforeValidateCustomerName2(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec."Name 2" := recConvChar.ConvertCharacters(Rec."Name 2");
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Address', false, false)]
    local procedure OnBeforeValidateCustomerAddress(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.Address := recConvChar.ConvertCharacters(Rec.Address);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Address 2', false, false)]
    local procedure OnBeforeValidateCustomerAddress2(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec."Address 2" := recConvChar.ConvertCharacters(Rec."Address 2");
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'City', false, false)]
    local procedure OnBeforeValidateCustomerCity(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.City := recConvChar.ConvertCharacters(Rec.City);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Payment Terms Code', false, false)]
    local procedure OnAfterValidate_PaymentTermsCode(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        SalesHead: Record "Sales Header";
        lText001: Label 'Do you want to update "%1" on %2 sales order(s) with unshipped lines?';
    begin
        //>> 22-07-24 ZY-LD 027
        if (Rec."Payment Terms Code" <> '') and (Rec."Payment Terms Code" <> xRec."Payment Terms Code") then begin
            SalesHead.SetRange("Document Type", SalesHead."Document Type"::Order);
            SalesHead.SetRange("Sell-to Customer No.", Rec."No.");
            SalesHead.SetRange("Payment Terms Code", xRec."Payment Terms Code");
            SalesHead.SetRange("Completely Shipped", false);
            if SalesHead.FindSet() then
                if Confirm(lText001, false, SalesHead.FieldCaption("Payment Terms Code"), SalesHead.Count) then begin
                    SalesHead.SetHideValidationDialog(true);
                    repeat
                        SalesHead.Validate("Payment Terms Code", Rec."Payment Terms Code");
                        SalesHead.Modify(true);
                    until SalesHead.Next() = 0;
                    SalesHead.SetHideValidationDialog(false);
                end;
        end
        //<< 22-07-24 ZY-LD 027
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'E-Mail', false, false)]
    local procedure OnBeforeValidateEmail(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."E-Mail" := ZGT.ValidateEmailAdd(Rec."E-Mail");  // 06-11-19 ZY-LD 012
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Notification E-Mail', false, false)]
    local procedure OnBeforeValidateNotificationEmail(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."E-Mail" := ZGT.ValidateEmailAdd(Rec."E-Mail");  // 06-11-19 ZY-LD 012
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Confirmation E-Mail', false, false)]
    local procedure OnBeforeValidateConfirmationEmail(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."E-Mail" := ZGT.ValidateEmailAdd(Rec."E-Mail");  // 06-11-19 ZY-LD 012
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'EiCard Email Address', false, false)]
    local procedure OnBeforeValidateEiCardEmailAddress(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."EiCard Email Address" := ZGT.ValidateEmailAdd(Rec."EiCard Email Address");  // 26-08-19 ZY-LD 010
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'EiCard Email Address1', false, false)]
    local procedure OnBeforeValidateEiCardEmailAddress1(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."EiCard Email Address1" := ZGT.ValidateEmailAdd(Rec."EiCard Email Address1");  // 26-08-19 ZY-LD 010
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'EiCard Email Address2', false, false)]
    local procedure OnBeforeValidateEiCardEmailAddress2(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."EiCard Email Address2" := ZGT.ValidateEmailAdd(Rec."EiCard Email Address2");  // 26-08-19 ZY-LD 010
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'EiCard Email Address3', false, false)]
    local procedure OnBeforeValidateEiCardEmailAddress3(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."EiCard Email Address3" := ZGT.ValidateEmailAdd(Rec."EiCard Email Address3");  // 26-08-19 ZY-LD 010
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'EiCard Email Address4', false, false)]
    local procedure OnBeforeValidateEiCardEmailAddress4(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."EiCard Email Address4" := ZGT.ValidateEmailAdd(Rec."EiCard Email Address4");  // 26-08-19 ZY-LD 010
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'E-mail for Order Scanning', false, false)]
    local procedure OnBeforeValidateEmailForOrderScanning(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."E-mail for Order Scanning" := ZGT.ValidateEmailAdd(Rec."E-mail for Order Scanning");  // 11-11-20 ZY-LD 017
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Gen. Bus. Posting Group', false, false)]
    local procedure OnAfterValidateGenBusPostingGroup(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        UpdateSalesOrder(Rec, xRec);  // 03-08-21 ZY-LD 022
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'VAT Bus. Posting Group', false, false)]
    local procedure OnAfterValidateVATBusPostingGroup(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        UpdateSalesOrder(Rec, xRec);  // 03-08-21 ZY-LD 022
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Customer Posting Group', false, false)]
    local procedure OnAfterValidateCustomerPostingGroup(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        UpdateSalesOrder(Rec, xRec);  // 03-08-21 ZY-LD 022
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Customer Price Group', false, false)]
    local procedure OnAfterValidateCustomerPriceGroup(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recCustPriceGrp: Record "Customer Price Group";
        lText001: label '"%1" %2 is blocked.';
    begin
        begin
            //>> 03-02-20 ZY-LD 013
            if recCustPriceGrp.Get(Rec."Customer Price Group") and recCustPriceGrp.Blocked then
                Error(lText001, Rec.FieldCaption(Rec."Customer Price Group"), Rec."Customer Price Group");
            //<< 03-02-20 ZY-LD 013
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Bill-to Customer No.', false, false)]
    local procedure OnAfterValidateBillToCustomerNo(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec.Validate(Rec."E-mail Sales Documents");  // 25-09-19 ZY-LD 011
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'E-mail Sales Documents', false, false)]
    local procedure OnAfterValidateEmailSalesDocuments(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        begin
            //>> 25-09-19 ZY-LD 011
            if (Rec."No." <> Rec."Bill-to Customer No.") and
               (Rec."Bill-to Customer No." <> '')
            then
                Rec."E-mail Sales Documents" := false;
            //<< 25-09-19 ZY-LD 011
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'E-Mail Statement', false, false)]
    local procedure OnAfterValidateEmailStatement(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        begin
            Rec."Print Statements" := Rec."E-Mail Statement";  // 21-03-18 ZY-LD 001
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Territory Code', false, false)]
    local procedure OnAfterValidateTerritoryCode(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recForeTerrCountry: Record "Forecast Territory Country";
        recForeTerr: Record "Forecast Territory";
        recGenSetup: Record "General Ledger Setup";
        recDefDim: Record "Default Dimension";
        PrevForecastCode: Code[20];
        DifferentForecastCodes: Boolean;
        lText001: label '"%1" does not exist for "%2".';
    begin
        //>> 13-11-18 ZY-LD 006
        //>> 20-08-18 ZY-LD 003
        begin
            //>> 26-11-18 ZY-LD 007
            Rec."Forecast Territory" := '';
            if recForeTerrCountry.Get(Rec."Territory Code", CopyStr(Rec."Global Dimension 1 Code", 1, 2)) then begin
                Rec."Forecast Territory" := recForeTerrCountry."Forecast Territory Code";
                //>> 06-11-19 ZY-LD 012
                recForeTerr.Get(Rec."Forecast Territory");
                Rec."Automatic Invoice Handling" := recForeTerr."Automatic Invoice Handling";
                //<< 06-11-19 ZY-LD 012
            end;

            //  recForeTerrCountry.SETRANGE("Territory Code","Territory Code");
            //  IF recForeTerrCountry.FINDSET THEN BEGIN
            //    REPEAT
            //      IF (PrevForecastCode <> recForeTerrCountry."Forecast Territory Code") AND
            //         (PrevForecastCode <> '')
            //      THEN
            //        DifferentForecastCodes := TRUE;
            //
            //      PrevForecastCode := recForeTerrCountry."Forecast Territory Code";
            //    UNTIL recForeTerrCountry.Next() = 0;
            //
            //    IF DifferentForecastCodes THEN BEGIN
            //      IF PAGE.RUNMODAL(PAGE::"Forecast Territory Countries",recForeTerrCountry) = ACTION::LookupOK THEN
            //        VALIDATE("Forecast Territory",recForeTerrCountry."Forecast Territory Code");
            //    END ELSE
            //      VALIDATE("Forecast Territory",recForeTerrCountry."Forecast Territory Code");
            //  END ELSE
            //    ERROR(lText001,recForeTerrCountry.TABLECAPTION,"Territory Code");
            //<< 26-11-18 ZY-LD 007
        end;
        //<< 20-08-18 ZY-LD 003
        //<< 13-11-18 ZY-LD 006
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Country/Region Code', false, false)]
    local procedure OnAfterValidateCountryRegionCode(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        lText001: label 'Do you want to change "%1" from "%2" to "%3"?';
        lText002: label '"%1" is not created as "%2". Do you want to continue?';
        recTerritory: Record Territory;
        lText003: label 'Modification is stopped.';
    begin
        //>> 20-08-18 ZY-LD 003
        if ZGT.IsRhq and GuiAllowed then
            if Rec."Territory Code" = '' then begin
                if recTerritory.Get(Rec."Country/Region Code") then
                    Rec.Validate(Rec."Territory Code", Rec."Country/Region Code")
                else
                    if not Confirm(lText002, false, Rec."Country/Region Code", recTerritory.TableCaption) then
                        Error(lText003);
            end else
                if xRec."Country/Region Code" = Rec."Territory Code" then
                    if Confirm(lText001, false, Rec.FieldCaption(Rec."Territory Code"), Rec."Territory Code", Rec."Country/Region Code") then
                        Rec.Validate(Rec."Territory Code", Rec."Country/Region Code");
        //<< 20-08-18 ZY-LD 003
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'E-Mail', false, false)]
    local procedure OnAfterValidateEmail(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        CustomrepMgt: Codeunit "Custom Report Management";
    begin
        begin
            //>> 26-11-18 ZY-LD 008
            if xRec."E-Mail" = CustomrepMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::Reminder, Rec."E-Mail") then
                CustomrepMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::Reminder, Rec."E-Mail");
            if xRec."E-Mail" = CustomrepMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"C.Statement", Rec."E-Mail") then
                CustomrepMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"C.Statement", Rec."E-Mail");
            if xRec."E-Mail" = CustomrepMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Invoice", Rec."E-Mail") then
                CustomrepMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Invoice", Rec."E-Mail");
            if xRec."E-Mail" = CustomrepMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Cr.Memo", Rec."E-Mail") then
                CustomrepMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Cr.Memo", Rec."E-Mail");
            //<< 26-11-18 ZY-LD 008
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'VAT ID', false, false)]
    local procedure OnAfterValidateVATID(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        VATRegNoFormat: Record "VAT Registration No. Format";
    begin
        VATRegNoFormat.Test(Rec."VAT ID", Rec."Country/Region Code", Rec."No.", Database::Customer);  // 12-10-20 ZY-LD 016
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    begin
        ZyWebSrvMgt.ReplicateCustomers('', Rec."No.", false);
    end;


    procedure SetReplicationPrCompany(var Rec: Record Customer)
    var
        recBillToCust: Record Customer;
        recIcPartner: Record "IC Partner";
        recDataforRep: Record "Data for Replication";
    begin
        //>> 02-11-18 ZY-LD 004
        if Rec."No." <> Rec."Bill-to Customer No." then
            if recBillToCust.Get(Rec."Bill-to Customer No.") then
                if recIcPartner.Get(recBillToCust."IC Partner Code") then begin
                    recDataforRep.SetRange("Table No.", Database::Customer);
                    recDataforRep.SetRange("Company Name", recIcPartner."Inbox Details");
                    Page.RunModal(Page::"Data for Replication List", recDataforRep);
                end;
        //<< 02-11-18 ZY-LD 004
    end;
    #endregion

    local procedure UpdateSalesOrder(var Rec: Record Customer; var xRec: Record Customer)
    var
        recSalesHead: Record "Sales Header";
        lText001: label 'Please remember to update posting groups on %1 existing sales order(s).';
    begin
        //>> 03-08-21 ZY-LD 022
        if (Rec."Gen. Bus. Posting Group" <> xRec."Gen. Bus. Posting Group") or
           (Rec."VAT Bus. Posting Group" <> xRec."VAT Bus. Posting Group") or
           (Rec."Customer Posting Group" <> xRec."Customer Posting Group")
        then begin
            recSalesHead.SetCurrentkey("Document Type", "Sell-to Customer No.");
            recSalesHead.SetRange("Document Type", recSalesHead."document type"::Order);
            recSalesHead.SetRange("Sell-to Customer No.", Rec."No.");
            recSalesHead.SetRange("Completely Invoiced", false);
            if not recSalesHead.IsEmpty then
                Message(lText001, recSalesHead.Count);
        end;
        //<< 03-08-21 ZY-LD 022
    end;

    //>> Cust. Ledger Entry
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustEntry-Apply Posted Entries", 'OnApplyApplyCustEntryFormEntryOnAfterCustLedgEntrySetFilters', '', false, false)]
    local procedure OnApplyApplyCustEntryFormEntryOnAfterCustLedgEntrySetFilters(var CustLedgerEntry: Record "Cust. Ledger Entry"; var ApplyingCustLedgerEntry: Record "Cust. Ledger Entry"; var IsHandled: Boolean)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        SalesInvHead: Record "Sales Invoice Header";
        SalesCrMemoHead: Record "Sales Cr.Memo Header";

    begin
        // Report 50039 is build to easy application of open payments primary from the eCommerce accounts. I that case we need a filter on External Document No. that is present on the payment and the invoice.
        CustLedgEntry.SetCurrentKey("External Document No.");
        CustLedgEntry.SetRange("External Document No.", ApplyingCustLedgerEntry."External Document No.");
        CustLedgEntry.SetRange("Sell-to Customer No.", ApplyingCustLedgerEntry."Sell-to Customer No.");
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        if CustLedgEntry.FindFirst() then begin
            If SalesInvHead.get(CustLedgEntry."Document No.") and
               SalesInvHead."eCommerce Order" or (CustLedgEntry."Customer No." IN ['200062', '200083', '200245', '200283'])
            then
                CustLedgerEntry.SetRange("External Document No.", ApplyingCustLedgerEntry."External Document No.");
        end else begin
            CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::"Credit Memo");
            if CustLedgEntry.FindFirst() then
                if SalesCrMemoHead.get(CustLedgEntry."Document No.") and
                   SalesCrMemoHead."eCommerce Order" or (CustLedgEntry."Customer No." IN ['200062', '200083', '200245', '200283'])
                then
                    CustLedgerEntry.SetRange("External Document No.", ApplyingCustLedgerEntry."External Document No.");
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Apply Customer Entries", 'OnPostDirectApplicationBeforeSetValues', '', false, false)]
    local procedure ApplyCustomerEntries_OnPostDirectApplicationBeforeSetValues(var ApplicationDate: Date)
    begin
        // Report 50039 - To make it easier to apply without setting the posting date manually.
        if ApplicationDate < CalcDate('<-CM>', WorkDate()) then
            ApplicationDate := WorkDate();
    end;

    //>> Page
    [EventSubscriber(Objecttype::Page, 21, 'OnAfterActionEvent', 'CustBillToCustSetup', false, false)]
    local procedure OnAfterActionEventCustBillToCustSetup_Page21(var Rec: Record Customer)
    begin
        ShowCustBillToSetup(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 21, 'OnAfterActionEvent', 'CustPostingGrpSetupMain', false, false)]
    local procedure OnAfterActionEventCustPostingGrpSetupMain_Page21(var Rec: Record Customer)
    begin
        ShowCustPostGrpSetup(Rec, 0);
    end;

    [EventSubscriber(Objecttype::Page, 21, 'OnAfterActionEvent', 'CustPostingGrpSetupSub', false, false)]
    local procedure OnAfterActionEventCustPostingGrpSetupSub_Page21(var Rec: Record Customer)
    begin
        ShowCustPostGrpSetup(Rec, 1);
    end;

    [EventSubscriber(Objecttype::Page, 21, 'OnAfterActionEvent', 'CustVatRegNoSetup', false, false)]
    local procedure OnAfterActionEventVatRegNoSetup_Page21(var Rec: Record Customer)
    begin
        ShowVATRegistrationSetup(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 22, 'OnAfterActionEvent', 'CustBillToCustSetup', false, false)]
    local procedure OnAfterActionEventCustBillToCustSetup_Page22(var Rec: Record Customer)
    begin
        ShowCustBillToSetup(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 22, 'OnAfterActionEvent', 'CustPostingGrpSetupMain', false, false)]
    local procedure OnAfterActionEventCustPostingGrpSetupMain_Page22(var Rec: Record Customer)
    begin
        ShowCustPostGrpSetup(Rec, 0);
    end;

    [EventSubscriber(Objecttype::Page, 22, 'OnAfterActionEvent', 'CustPostingGrpSetupSub', false, false)]
    local procedure OnAfterActionEventCustPostingGrpSetupSub_Page22(var Rec: Record Customer)
    begin
        ShowCustPostGrpSetup(Rec, 1);
    end;

    [EventSubscriber(Objecttype::Page, 22, 'OnAfterActionEvent', 'CustVatRegNoSetup', false, false)]
    local procedure OnAfterActionEventVatRegNoSetup_Page22(var Rec: Record Customer)
    begin
        ShowVATRegistrationSetup(Rec);
    end;

    local procedure ">> Ship To Address"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertShipToAdd(var Rec: Record "Ship-to Address"; RunTrigger: Boolean)
    var
        recCust: Record Customer;
        recInvSetup: Record "Inventory Setup";
    begin
        begin
            //>> 09-07-20 ZY-LD 014
            if GuiAllowed and not Rec.IsTemporary then begin
                if recCust.Get(Rec."Customer No.") then
                    Rec.Validate(Rec."Shipment Method Code", recCust."Shipment Method Code");

                recInvSetup.Get;
                if recInvSetup."AIT Location Code" <> '' then
                    Rec.Validate(Rec."Location Code", recInvSetup."AIT Location Code");
            end;
            //<< 09-07-20 ZY-LD 014
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteShipToAdd(var Rec: Record "Ship-to Address"; RunTrigger: Boolean)
    var
        recSalesHead: Record "Sales Header";
        lText001: label '"%1" %2 is active on the "%3" %4.';
        recCust: Record Customer;
    begin
        begin
            //>> 03-02-23 ZY-LD 025
            recSalesHead.SetRange("Sell-to Customer No.", Rec."Customer No.");
            recSalesHead.SetRange("Ship-to Code", Rec.Code);
            if recSalesHead.FindFirst then
                Error(lText001, Rec.TableCaption, Rec.Code, recSalesHead."Document Type", recSalesHead."No.");
            //<< 03-02-23 ZY-LD 025
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeValidateEvent', 'Name', false, false)]
    local procedure OnBeforeValidateShipToAddName(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address"; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.Name := recConvChar.ConvertCharacters(Rec.Name);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeValidateEvent', 'Name 2', false, false)]
    local procedure OnBeforeValidateShipToAddName2(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address"; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec."Name 2" := recConvChar.ConvertCharacters(Rec."Name 2");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeValidateEvent', 'Address', false, false)]
    local procedure OnBeforeValidateShipToAddAddress(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address"; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.Address := recConvChar.ConvertCharacters(Rec.Address);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeValidateEvent', 'Address 2', false, false)]
    local procedure OnBeforeValidateShipToAddAddress2(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address"; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec."Address 2" := recConvChar.ConvertCharacters(Rec."Address 2");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeValidateEvent', 'City', false, false)]
    local procedure OnBeforeValidateShipToAddCity(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address"; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.City := recConvChar.ConvertCharacters(Rec.City);
    end;

    //>> Custom Report Selection
    [EventSubscriber(ObjectType::Table, Database::"Custom Report Selection", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertCustomReportSelection(var Rec: Record "Custom Report Selection")
    begin
        //>> 20-11-23 ZY-LD 026
        if Rec."Report ID" = 0 then
            Rec."Report ID" := 1;
        //<< 20-11-23 ZY-LD 026            
    end;

    [EventSubscriber(ObjectType::Table, Database::"Custom Report Selection", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertCustomReportSelection(var Rec: Record "Custom Report Selection")
    begin
        //>> 20-11-23 ZY-LD 026
        if Rec."Report ID" = 1 then begin
            Rec."Report ID" := 0;
            Rec.Modify();
        end;
        //<< 20-11-23 ZY-LD 026
    end;

    [EventSubscriber(ObjectType::Table, Database::"Custom Report Selection", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyCustomReportSelection(var Rec: Record "Custom Report Selection")
    begin
        //>> 20-11-23 ZY-LD 026
        if Rec."Report ID" = 1 then begin
            Rec."Report ID" := 0;
            Rec.Modify();
        end;
        //<< 20-11-23 ZY-LD 026
    end;

    local procedure ">> Default Dimension"()
    begin
    end;

    [EventSubscriber(Objecttype::Page, 540, 'OnInsertRecordEvent', '', false, false)]
    local procedure OnAfterInsertPage540(var Rec: Record "Default Dimension"; BelowxRec: Boolean; var xRec: Record "Default Dimension"; var AllowInsert: Boolean)
    begin
        ValidateTerritoryCode(Rec);  // 26-11-18 ZY-LD 007
    end;

    [EventSubscriber(Objecttype::Page, 540, 'OnModifyRecordEvent', '', false, false)]
    local procedure OnAfterModifyPage540(var Rec: Record "Default Dimension"; var xRec: Record "Default Dimension"; var AllowModify: Boolean)
    begin
        ValidateTerritoryCode(Rec);  // 26-11-18 ZY-LD 007
    end;

    [EventSubscriber(Objecttype::Page, 540, 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnAfterDeletePage540(var Rec: Record "Default Dimension"; var AllowDelete: Boolean)
    var
        recGenSetup: Record "General Ledger Setup";
        recCust: Record Customer;
    begin
        //>> 26-11-18 ZY-LD 007
        begin
            recGenSetup.Get;
            if (Rec."Table ID" = Database::Customer) and (Rec."Dimension Code" = recGenSetup."Global Dimension 1 Code") then
                if recCust.Get(Rec."No.") then begin
                    recCust."Forecast Territory" := '';
                    recCust.Modify(true);
                end;
        end;
        //<< 26-11-18 ZY-LD 007
    end;

    local procedure ValidateTerritoryCode(var Rec: Record "Default Dimension")
    var
        recGenSetup: Record "General Ledger Setup";
        recCust: Record Customer;
    begin
        //>> 26-11-18 ZY-LD 007
        begin
            recGenSetup.Get;
            if (Rec."Table ID" = Database::Customer) and (Rec."Dimension Code" = recGenSetup."Global Dimension 1 Code") then
                if recCust.Get(Rec."No.") then begin
                    recCust."Global Dimension 1 Code" := Rec."Dimension Value Code";
                    recCust.Validate("Territory Code");
                    recCust.Modify(true);
                end;
        end;
        //<< 26-11-18 ZY-LD 007
    end;

    local procedure ">> Functions"()
    begin
    end;

    local procedure ShowCustBillToSetup(var Rec: Record Customer)
    var
        recCustPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
    begin
        begin
            //>> 03-02-21 ZY-LD 020
            recCustPostGrpSetup.SetFilter("Country/Region Code", GetCustPostGrpSetupCountryFilter(Rec));
            recCustPostGrpSetup.SetFilter("Customer No.", '%1|%2', Rec."No.", '');
            Page.Run(Page::"Add. Bill-to Cust. Setup", recCustPostGrpSetup);
            //<< 03-02-21 ZY-LD 020
        end;
    end;

    local procedure ShowCustPostGrpSetup(var Rec: Record Customer; pCompanyType: Option Main,Subsidary)
    var
        recCustPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
    begin
        begin
            //>> 03-02-21 ZY-LD 020
            recCustPostGrpSetup.FilterGroup(2);
            recCustPostGrpSetup.SetRange("Company Type", pCompanyType);
            recCustPostGrpSetup.FilterGroup(0);

            recCustPostGrpSetup.SetFilter("Country/Region Code", GetCustPostGrpSetupCountryFilter(Rec));
            //recCustPostGrpSetup.SetFilter("Customer No.", '%1|%2', Rec."No.", '');  // 24-09-24 ZY-LD 000 - Removed, because it must be possible to setup local customers from the subsidary.
            Page.Run(Page::"Add. Cust. Posting Grp. Setup", recCustPostGrpSetup);
            //<< 03-02-21 ZY-LD 020
        end;
    end;

    local procedure ShowVATRegistrationSetup(var Rec: Record Customer)
    var
        recCustPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
        recVATRegNoLocation: Record "VAT Reg. No. pr. Location";
    begin
        begin
            //>> 03-02-21 ZY-LD 020
            recVATRegNoLocation.SetFilter("Ship-to Customer Country Code", '%1|%2', GetCustPostGrpSetupCountryFilter(Rec), '');
            recVATRegNoLocation.SetFilter("Sell-to Customer No.", '%1|%2', Rec."No.", '');
            Page.Run(Page::"VAT Reg. No. pr. Locations", recVATRegNoLocation);
            //<< 03-02-21 ZY-LD 020
        end;
    end;


    procedure GetCustPostGrpSetupCountryFilter(var Rec: Record Customer) rValue: Text
    var
        recShiptoAdd: Record "Ship-to Address";
        recAddCustPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
    begin
        begin
            //>> 03-02-21 ZY-LD 020
            if Rec."Country/Region Code" <> '' then
                rValue := Rec."Country/Region Code" + '|';

            recShiptoAdd.SetRange("Customer No.", Rec."No.");
            recShiptoAdd.SetFilter("Country/Region Code", '<>%1', '');
            recShiptoAdd.SetFilter("Last Used Date", '%1..', CalcDate('<-1Y>', Today));
            if recShiptoAdd.FindSet then
                repeat
                    if StrPos(rValue, recShiptoAdd."Country/Region Code") = 0 then
                        rValue += recShiptoAdd."Country/Region Code" + '|';
                until recShiptoAdd.Next() = 0;
            //<< 03-02-21 ZY-LD 020

            //>> 18-08-21 ZY-LD 023
            recAddCustPostGrpSetup.SetRange("Customer No.", Rec."No.");
            if recAddCustPostGrpSetup.FindSet then
                repeat
                    if (recAddCustPostGrpSetup."Country/Region Code" = '') then
                        if recAddCustPostGrpSetup."Location Code in SUB" <> '' then
                            rValue += '''''' + '|'
                        else
                            if StrPos(rValue, recAddCustPostGrpSetup."Country/Region Code") = 0 then
                                rValue += recAddCustPostGrpSetup."Country/Region Code" + '|';
                until recAddCustPostGrpSetup.Next() = 0;
            //<< 18-08-21 ZY-LD 023

            rValue := DelChr(rValue, '>', '|');
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Create Conts. from Customers", 'OnBeforeContactInsert', '', false, false)]
    local procedure CreateContsfromVendors_OnBeforeContactInsert(Customer: Record Customer; var Contact: Record Contact)
    var
        RMSetup: Record "Marketing Setup";
    begin
        RMSetup.Get();
        if RMSetup."Use Cust and Vend No. for Cont" then
            Contact."No." := Customer."No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustCont-Update", 'OnBeforeOnInsert', '', false, false)]
    local procedure VendContUpdate_OnBeforeOnInsert(var IsHandled: Boolean)
    var
        RMSetup: Record "Marketing Setup";
    begin
        RMSetup.Get();
        if RMSetup."Use Cust and Vend No. for Cont" then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Small Business Report Catalog", 'OnBeforeRunCustomerStatementReport', '', false, false)]
    local procedure SmallBusinessReportCatalog_OnBeforeRunCustomerStatementReport(UseRequestPage: Boolean)
    var
        CustomerStatementReport: Report "Statement ZX";
        AccountingPeriodMgt: Codeunit "Accounting Period Mgt.";
        NewPrintEntriesDue: Boolean;
        NewPrintAllHavingEntry: Boolean;
        NewPrintAllHavingBal: Boolean;
        NewPrintReversedEntries: Boolean;
        NewPrintUnappliedEntries: Boolean;
        NewIncludeAgingBand: Boolean;
        NewPeriodLength: Text[30];
        NewDateChoice: Option;
        NewLogInteraction: Boolean;
        NewStartDate: Date;
        NewEndDate: Date;
        DateChoice: Option "Due Date","Posting Date";
        IsHandled: Boolean;
        NewPrintOnlyOpenEntries: Boolean;
    begin
        NewPrintEntriesDue := TRUE;  // 16-10-18 ZY-LD 001
        NewPrintAllHavingEntry := false;
        NewPrintAllHavingBal := true;
        NewPrintReversedEntries := false;
        NewPrintUnappliedEntries := false;
        NewIncludeAgingBand := TRUE;  // 16-10-18 ZY-LD 001
        NewPeriodLength := '<1M+CM>';
        NewDateChoice := DateChoice::"Due Date";
        NewLogInteraction := true;
        NewPrintOnlyOpenEntries := TRUE;  // 16-10-18 ZY-LD 001

        NewStartDate := AccountingPeriodMgt.FindFiscalYear(WorkDate());
        NewEndDate := WorkDate();

        CustomerStatementReport.InitializeRequest(
          NewPrintEntriesDue, NewPrintAllHavingEntry, NewPrintAllHavingBal, NewPrintReversedEntries,
          NewPrintUnappliedEntries, NewIncludeAgingBand, NewPeriodLength, NewDateChoice,
          NewLogInteraction, NewStartDate, NewEndDate,
          NewPrintOnlyOpenEntries);  // 16-10-18 ZY-LD 001
        CustomerStatementReport.UseRequestPage(UseRequestPage);
        CustomerStatementReport.Run();
    end;

}
