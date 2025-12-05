Codeunit 50070 "Customer Events"
{
    trigger OnRun()
    begin
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";

    #region Customer
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        if ZGT.IsRhq() then begin
            if ZGT.IsZNetCompany() then begin
                Rec."Post EiCard Invoice Automatic" := Rec."post eicard invoice automatic"::"Yes (when purchase invoice is posted)";
                Rec."Minimum Order Value Enabled" := true;
                Rec."E-mail Deliv. Note at Release" := true;
            end;

            Rec."Combine Shipments" := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    var
        lText001: label '"%1" is blank. Do you want continue?';
        lText002: label 'Modification is stopped.';
    begin
        if ZGT.IsRhq() and GuiAllowed() then
            if Rec."Territory Code" = '' then
                if not Confirm(lText001, false, Rec.FieldCaption(Rec."Territory Code")) then
                    Error(lText002);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    var
        recCust: Record Customer;
    begin
        if not Rec.IsTemporary() then
            if ZGT.IsRhq() then begin
                recCust.SetRange("No.", Rec."No.");
                Report.RunModal(Report::"Create Conts. from Customers", false, false, recCust);
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Name', false, false)]
    local procedure OnBeforeValidateCustomerName(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.Name := copystr(recConvChar.ConvertCharacters(Rec.Name), 1, 100);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Name 2', false, false)]
    local procedure OnBeforeValidateCustomerName2(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec."Name 2" := copystr(recConvChar.ConvertCharacters(Rec."Name 2"), 1, 50);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Address', false, false)]
    local procedure OnBeforeValidateCustomerAddress(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.Address := copystr(recConvChar.ConvertCharacters(Rec.Address), 1, 100);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Address 2', false, false)]
    local procedure OnBeforeValidateCustomerAddress2(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec."Address 2" := copystr(recConvChar.ConvertCharacters(Rec."Address 2"), 1, 50);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'City', false, false)]
    local procedure OnBeforeValidateCustomerCity(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.City := copystr(recConvChar.ConvertCharacters(Rec.City), 1, 30);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Payment Terms Code', false, false)]
    local procedure OnAfterValidate_PaymentTermsCode(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        SalesHead: Record "Sales Header";
        lText001: Label 'Do you want to update "%1" on %2 sales order(s) with unshipped lines?';
    begin
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
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'E-Mail', false, false)]
    local procedure OnBeforeValidateEmail(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."E-Mail" := copystr(ZGT.ValidateEmailAdd(Rec."E-Mail"), 1, 80);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Notification E-Mail', false, false)]
    local procedure OnBeforeValidateNotificationEmail(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."E-Mail" := copystr(ZGT.ValidateEmailAdd(Rec."E-Mail"), 1, 80);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'Confirmation E-Mail', false, false)]
    local procedure OnBeforeValidateConfirmationEmail(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."E-Mail" := copystr(ZGT.ValidateEmailAdd(Rec."E-Mail"), 1, 80);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'EiCard Email Address', false, false)]
    local procedure OnBeforeValidateEiCardEmailAddress(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."EiCard Email Address" := copystr(ZGT.ValidateEmailAdd(Rec."EiCard Email Address"), 1, 50);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'EiCard Email Address1', false, false)]
    local procedure OnBeforeValidateEiCardEmailAddress1(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."EiCard Email Address1" := copystr(ZGT.ValidateEmailAdd(Rec."EiCard Email Address1"), 1, 50);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'EiCard Email Address2', false, false)]
    local procedure OnBeforeValidateEiCardEmailAddress2(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."EiCard Email Address2" := copystr(ZGT.ValidateEmailAdd(Rec."EiCard Email Address2"), 1, 50);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'EiCard Email Address3', false, false)]
    local procedure OnBeforeValidateEiCardEmailAddress3(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."EiCard Email Address3" := copystr(ZGT.ValidateEmailAdd(Rec."EiCard Email Address3"), 1, 50);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'EiCard Email Address4', false, false)]
    local procedure OnBeforeValidateEiCardEmailAddress4(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."EiCard Email Address4" := copystr(ZGT.ValidateEmailAdd(Rec."EiCard Email Address4"), 1, 50);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeValidateEvent', 'E-mail for Order Scanning', false, false)]
    local procedure OnBeforeValidateEmailForOrderScanning(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."E-mail for Order Scanning" := copystr(ZGT.ValidateEmailAdd(Rec."E-mail for Order Scanning"), 1, 30);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Gen. Bus. Posting Group', false, false)]
    local procedure OnAfterValidateGenBusPostingGroup(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        UpdateSalesOrder(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'VAT Bus. Posting Group', false, false)]
    local procedure OnAfterValidateVATBusPostingGroup(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        UpdateSalesOrder(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Customer Posting Group', false, false)]
    local procedure OnAfterValidateCustomerPostingGroup(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        UpdateSalesOrder(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Customer Price Group', false, false)]
    local procedure OnAfterValidateCustomerPriceGroup(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recCustPriceGrp: Record "Customer Price Group";
        lText001: label '"%1" %2 is blocked.';
    begin
        if recCustPriceGrp.Get(Rec."Customer Price Group") and recCustPriceGrp.Blocked then
            Error(lText001, Rec.FieldCaption(Rec."Customer Price Group"), Rec."Customer Price Group");
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Bill-to Customer No.', false, false)]
    local procedure OnAfterValidateBillToCustomerNo(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec.Validate(Rec."E-mail Sales Documents");
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'E-mail Sales Documents', false, false)]
    local procedure OnAfterValidateEmailSalesDocuments(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        if (Rec."No." <> Rec."Bill-to Customer No.") and
            (Rec."Bill-to Customer No." <> '')
        then
            Rec."E-mail Sales Documents" := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'E-Mail Statement', false, false)]
    local procedure OnAfterValidateEmailStatement(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        Rec."Print Statements" := Rec."E-Mail Statement";
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Territory Code', false, false)]
    local procedure OnAfterValidateTerritoryCode(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recForeTerrCountry: Record "Forecast Territory Country";
        recForeTerr: Record "Forecast Territory";

    begin
        begin
            Rec."Forecast Territory" := '';
            if recForeTerrCountry.Get(Rec."Territory Code", CopyStr(Rec."Global Dimension 1 Code", 1, 2)) then begin
                Rec."Forecast Territory" := recForeTerrCountry."Forecast Territory Code";
                recForeTerr.Get(Rec."Forecast Territory");
                Rec."Automatic Invoice Handling" := recForeTerr."Automatic Invoice Handling";
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Country/Region Code', false, false)]
    local procedure OnAfterValidateCountryRegionCode(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        recTerritory: Record Territory;
        lText001: label 'Do you want to change "%1" from "%2" to "%3"?';
        lText002: label '"%1" is not created as "%2". Do you want to continue?';
        lText003: label 'Modification is stopped.';
    begin
        if ZGT.IsRhq() and GuiAllowed() then
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
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'E-Mail', false, false)]
    local procedure OnAfterValidateEmail(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        CustomrepMgt: Codeunit "Custom Report Management";
    begin
        begin
            if xRec."E-Mail" = CustomrepMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::Reminder, Rec."E-Mail") then
                CustomrepMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::Reminder, Rec."E-Mail");
            if xRec."E-Mail" = CustomrepMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"C.Statement", Rec."E-Mail") then
                CustomrepMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"C.Statement", Rec."E-Mail");
            if xRec."E-Mail" = CustomrepMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Invoice", Rec."E-Mail") then
                CustomrepMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Invoice", Rec."E-Mail");
            if xRec."E-Mail" = CustomrepMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Cr.Memo", Rec."E-Mail") then
                CustomrepMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Cr.Memo", Rec."E-Mail");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'VAT ID', false, false)]
    local procedure OnAfterValidateVATID(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        VATRegNoFormat: Record "VAT Registration No. Format";
    begin
        VATRegNoFormat.Test(Rec."VAT ID", Rec."Country/Region Code", Rec."No.", Database::Customer);
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
        if Rec."No." <> Rec."Bill-to Customer No." then
            if recBillToCust.Get(Rec."Bill-to Customer No.") then
                if recIcPartner.Get(recBillToCust."IC Partner Code") then begin
                    recDataforRep.SetRange("Table No.", Database::Customer);
                    recDataforRep.SetRange("Company Name", recIcPartner."Inbox Details");
                    Page.RunModal(Page::"Data for Replication List", recDataforRep);
                end;
    end;
    #endregion

    local procedure UpdateSalesOrder(var Rec: Record Customer; var xRec: Record Customer)
    var
        recSalesHead: Record "Sales Header";
        lText001: label 'Please remember to update posting groups on %1 existing sales order(s).';
    begin
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

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertShipToAdd(var Rec: Record "Ship-to Address"; RunTrigger: Boolean)
    var
        recCust: Record Customer;
        recInvSetup: Record "Inventory Setup";
    begin
        if GuiAllowed() and not Rec.IsTemporary() then begin
            if recCust.Get(Rec."Customer No.") then
                Rec.Validate(Rec."Shipment Method Code", recCust."Shipment Method Code");

            recInvSetup.Get();
            if recInvSetup."AIT Location Code" <> '' then
                Rec.Validate(Rec."Location Code", recInvSetup."AIT Location Code");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteShipToAdd(var Rec: Record "Ship-to Address"; RunTrigger: Boolean)
    var
        recSalesHead: Record "Sales Header";
        lText001: label '"%1" %2 is active on the "%3" %4.';

    begin
        begin
            recSalesHead.SetRange("Sell-to Customer No.", Rec."Customer No.");
            recSalesHead.SetRange("Ship-to Code", Rec.Code);
            if recSalesHead.FindFirst() then
                Error(lText001, Rec.TableCaption(), Rec.Code, recSalesHead."Document Type", recSalesHead."No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeValidateEvent', 'Name', false, false)]
    local procedure OnBeforeValidateShipToAddName(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address"; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.Name := Copystr(recConvChar.ConvertCharacters(Rec.Name), 1, 100);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeValidateEvent', 'Name 2', false, false)]
    local procedure OnBeforeValidateShipToAddName2(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address"; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec."Name 2" := Copystr(recConvChar.ConvertCharacters(Rec."Name 2"), 1, 50);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeValidateEvent', 'Address', false, false)]
    local procedure OnBeforeValidateShipToAddAddress(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address"; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.Address := Copystr(recConvChar.ConvertCharacters(Rec.Address), 1, 100);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeValidateEvent', 'Address 2', false, false)]
    local procedure OnBeforeValidateShipToAddAddress2(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address"; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec."Address 2" := Copystr(recConvChar.ConvertCharacters(Rec."Address 2"), 1, 50);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnBeforeValidateEvent', 'City', false, false)]
    local procedure OnBeforeValidateShipToAddCity(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address"; CurrFieldNo: Integer)
    var
        recConvChar: Record "Convert Characters";
    begin
        Rec.City := Copystr(recConvChar.ConvertCharacters(Rec.City), 1, 30);
    end;

    //>> Custom Report Selection
    [EventSubscriber(ObjectType::Table, Database::"Custom Report Selection", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertCustomReportSelection(var Rec: Record "Custom Report Selection")
    begin
        if Rec."Report ID" = 0 then
            Rec."Report ID" := 1;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Custom Report Selection", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertCustomReportSelection(var Rec: Record "Custom Report Selection")
    begin
        if Rec."Report ID" = 1 then begin
            Rec."Report ID" := 0;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Custom Report Selection", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyCustomReportSelection(var Rec: Record "Custom Report Selection")
    begin
        if Rec."Report ID" = 1 then begin
            Rec."Report ID" := 0;
            Rec.Modify();
        end;
    end;

    [EventSubscriber(Objecttype::Page, 540, 'OnInsertRecordEvent', '', false, false)]
    local procedure OnAfterInsertPage540(var Rec: Record "Default Dimension"; BelowxRec: Boolean; var xRec: Record "Default Dimension"; var AllowInsert: Boolean)
    begin
        ValidateTerritoryCode(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 540, 'OnModifyRecordEvent', '', false, false)]
    local procedure OnAfterModifyPage540(var Rec: Record "Default Dimension"; var xRec: Record "Default Dimension"; var AllowModify: Boolean)
    begin
        ValidateTerritoryCode(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 540, 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnAfterDeletePage540(var Rec: Record "Default Dimension"; var AllowDelete: Boolean)
    var
        recGenSetup: Record "General Ledger Setup";
        recCust: Record Customer;
    begin
        begin
            recGenSetup.Get();
            if (Rec."Table ID" = Database::Customer) and (Rec."Dimension Code" = recGenSetup."Global Dimension 1 Code") then
                if recCust.Get(Rec."No.") then begin
                    recCust."Forecast Territory" := '';
                    recCust.Modify(true);
                end;
        end;
    end;

    local procedure ValidateTerritoryCode(var Rec: Record "Default Dimension")
    var
        recGenSetup: Record "General Ledger Setup";
        recCust: Record Customer;
    begin
        begin
            recGenSetup.Get();
            if (Rec."Table ID" = Database::Customer) and (Rec."Dimension Code" = recGenSetup."Global Dimension 1 Code") then
                if recCust.Get(Rec."No.") then begin
                    recCust."Global Dimension 1 Code" := Rec."Dimension Value Code";
                    recCust.Validate("Territory Code");
                    recCust.Modify(true);
                end;
        end;
    end;

    local procedure ShowCustBillToSetup(var Rec: Record Customer)
    var
        recCustPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
    begin
        begin
            recCustPostGrpSetup.SetFilter("Country/Region Code", GetCustPostGrpSetupCountryFilter(Rec));
            recCustPostGrpSetup.SetFilter("Customer No.", '%1|%2', Rec."No.", '');
            Page.Run(Page::"Add. Bill-to Cust. Setup", recCustPostGrpSetup);
        end;
    end;

    local procedure ShowCustPostGrpSetup(var Rec: Record Customer; pCompanyType: Option Main,Subsidary)
    var
        recCustPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
    begin
        begin
            recCustPostGrpSetup.FilterGroup(2);
            recCustPostGrpSetup.SetRange("Company Type", pCompanyType);
            recCustPostGrpSetup.FilterGroup(0);

            recCustPostGrpSetup.SetFilter("Country/Region Code", GetCustPostGrpSetupCountryFilter(Rec));
            Page.Run(Page::"Add. Cust. Posting Grp. Setup", recCustPostGrpSetup);
        end;
    end;

    local procedure ShowVATRegistrationSetup(var Rec: Record Customer)
    var
        recVATRegNoLocation: Record "VAT Reg. No. pr. Location";

    begin
        begin
            recVATRegNoLocation.SetFilter("Ship-to Customer Country Code", '%1|%2', GetCustPostGrpSetupCountryFilter(Rec), '');
            recVATRegNoLocation.SetFilter("Sell-to Customer No.", '%1|%2', Rec."No.", '');
            Page.Run(Page::"VAT Reg. No. pr. Locations", recVATRegNoLocation);
        end;
    end;


    procedure GetCustPostGrpSetupCountryFilter(var Rec: Record Customer) rValue: Text
    var
        recShiptoAdd: Record "Ship-to Address";
        recAddCustPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
    begin
        begin
            if Rec."Country/Region Code" <> '' then
                rValue := Rec."Country/Region Code" + '|';

            recShiptoAdd.SetRange("Customer No.", Rec."No.");
            recShiptoAdd.SetFilter("Country/Region Code", '<>%1', '');
            recShiptoAdd.SetFilter("Last Used Date", '%1..', CalcDate('<-1Y>', Today));
            if recShiptoAdd.FindSet() then
                repeat
                    if StrPos(rValue, recShiptoAdd."Country/Region Code") = 0 then
                        rValue += recShiptoAdd."Country/Region Code" + '|';
                until recShiptoAdd.Next() = 0;


            recAddCustPostGrpSetup.SetRange("Customer No.", Rec."No.");
            if recAddCustPostGrpSetup.FindSet() then
                repeat
                    if (recAddCustPostGrpSetup."Country/Region Code" = '') then
                        if recAddCustPostGrpSetup."Location Code in SUB" <> '' then
                            rValue += '''''' + '|'
                        else
                            if StrPos(rValue, recAddCustPostGrpSetup."Country/Region Code") = 0 then
                                rValue += recAddCustPostGrpSetup."Country/Region Code" + '|';
                until recAddCustPostGrpSetup.Next() = 0;


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
        NewPrintOnlyOpenEntries: Boolean;
    begin
        NewPrintEntriesDue := TRUE;
        NewPrintAllHavingEntry := false;
        NewPrintAllHavingBal := true;
        NewPrintReversedEntries := false;
        NewPrintUnappliedEntries := false;
        NewIncludeAgingBand := TRUE;
        NewPeriodLength := '<1M+CM>';
        NewDateChoice := DateChoice::"Due Date";
        NewLogInteraction := true;
        NewPrintOnlyOpenEntries := TRUE;

        NewStartDate := AccountingPeriodMgt.FindFiscalYear(WorkDate());
        NewEndDate := WorkDate();

        CustomerStatementReport.InitializeRequest(
          NewPrintEntriesDue, NewPrintAllHavingEntry, NewPrintAllHavingBal, NewPrintReversedEntries,
          NewPrintUnappliedEntries, NewIncludeAgingBand, NewPeriodLength, NewDateChoice,
          NewLogInteraction, NewStartDate, NewEndDate,
          NewPrintOnlyOpenEntries);
        CustomerStatementReport.UseRequestPage(UseRequestPage);
        CustomerStatementReport.Run();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnEnqueueMailingJobOnBeforeRunJobQueueEnqueue, '', false, false)]
    local procedure "Report Selections_OnEnqueueMailingJobOnBeforeRunJobQueueEnqueue"(RecordIdToProcess: RecordId; ParameterString: Text; Description: Text; var JobQueueEntry: Record "Job Queue Entry"; var IsHandled: Boolean)
    begin
        //undgå at Document-Mailing codeunit køres via Job Queue - den gensender MANGE documenter til kunden igen.
        //26-11-2025 BK #542415
        if JobQueueEntry."Object ID to Run" = CODEUNIT::"Document-Mailing" then
            IsHandled := true;
    end;


}
