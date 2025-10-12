codeunit 50087 "Zyxel General Event"
{

    Permissions = TableData "Use of Report Entry" = rimd,
                  tabledata "Substitute Report" = r;

    trigger OnRun()
    begin
    end;

    var
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";


    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesPrice(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    begin

        //We need TO investigate all delete functions first.
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteSalesPrice(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    begin
        //DeleteSalesPriceReplicated(Rec);  
    end;

    local procedure DeleteSalesPriceReplicated(var Rec: Record "Price List Line")
    var
        recSalesPriceRep: Record "Price List Line Replicated";
    begin
        begin
            recSalesPriceRep.SetRange("Price List Code", Rec."Price List Code");
            recSalesPriceRep.SetRange("Line No.", Rec."Line No.");
            recSalesPriceRep.DeleteAll(true);
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::User, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertUser(var Rec: Record User; RunTrigger: Boolean)
    var
        recUserSetup: Record "User Setup";
        recUserPer: Record "User Personalization";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if Rec."User Name" = '' then
            exit;

        if not ZGT.ItalianServer() and not ZGT.TurkishServer() then
            recUserSetup.ChangeCompany(ZGT.GetRHQCompanyName());
        recUserSetup.Validate("User ID", Rec."User Name");
        if not recUserSetup.Insert(true) then;

        if not ZGT.ItalianServer() and not ZGT.TurkishServer() then
            recUserSetup.ChangeCompany(ZGT.GetSistersCompanyName(1))
        else

            if ZGT.ItalianServer() then
                recUserSetup.ChangeCompany(ZGT.GetSistersCompanyName(14))
            else
                if ZGT.TurkishServer() then
                    recUserSetup.ChangeCompany(ZGT.GetSistersCompanyName(15));
        if not recUserSetup.Insert(true) then;

        recUserPer.Validate("User SID", Rec."User Security ID");
        if not recUserPer.Insert(true) then;
    end;

    [EventSubscriber(ObjectType::Table, Database::"User Setup", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyUserSetup(var Rec: Record "User Setup"; var xRec: Record "User Setup"; RunTrigger: Boolean)
    begin
        ZyWebServMgt.ReplicateUserSetup(Rec."User ID");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Currency Exchange Rate", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertCurrencyExchangeRate(var Rec: Record "Currency Exchange Rate"; RunTrigger: Boolean)
    var
        SI: Codeunit "Single Instance";
    begin

        if not Rec.IsTemporary() and not SI.GetWebServiceUpdate() then
            if SI.GetDate() <> 0D then
                Rec."Starting Date" := SI.GetDate();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Currency Exchange Rate", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertCurrencyExchangeRate(var Rec: Record "Currency Exchange Rate"; RunTrigger: Boolean)
    var
        recCurrency: Record Currency;
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
    begin

        if not Rec.IsTemporary() then begin
            if ZGT.IsRhq() and ZGT.IsZComCompany() then
                if SI.GetExchangeRateService() then
                    if recCurrency.Get(Rec."Currency Code") then
                        if not recCurrency."Update via Exchange Rate Serv." then
                            Rec.Delete(true);

            recCurrency.Get(Rec."Currency Code");
            recCurrency.Replicated := false;
            recCurrency.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Currency Exchange Rate", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyCurrencyExchangeRate(var Rec: Record "Currency Exchange Rate"; var xRec: Record "Currency Exchange Rate"; RunTrigger: Boolean)
    var
        recCurrency: Record Currency;
        recCurrExchRateTmp: Record "Currency Exchange Rate" temporary;
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
    begin
        if not Rec.IsTemporary() then
            if ZGT.IsRhq() and ZGT.IsZComCompany() then
                if SI.GetExchangeRateService() then
                    if recCurrency.Get(Rec."Currency Code") then
                        if not recCurrency."Update via Exchange Rate Serv." then
                            if SI.GetExchangeRateTmp(Rec."Currency Code", recCurrExchRateTmp) then begin
                                Rec."Exchange Rate Amount" := recCurrExchRateTmp."Exchange Rate Amount";
                                Rec."Adjustment Exch. Rate Amount" := recCurrExchRateTmp."Adjustment Exch. Rate Amount";
                            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Currency Exchange Rate", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyCurrencyExchangeRate(var Rec: Record "Currency Exchange Rate"; var xRec: Record "Currency Exchange Rate"; RunTrigger: Boolean)
    var
        recCurrency: Record Currency;
    begin
        begin
            recCurrency.Get(Rec."Currency Code");
            recCurrency.Replicated := false;
            recCurrency.Modify(true);
        end;
    end;

    [EventSubscriber(Objecttype::Page, Page::Currencies, 'OnAfterActionEvent', 'UpdateExchangeRatesDate', false, false)]
    local procedure OnAfterActionEventUpdateExchangeRatesDate_Page5(var Rec: Record Currency)
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        SI: Codeunit "Single Instance";
        DateTimeDialog: Page "Date-Time Dialog";
    begin
        DateTimeDialog.SetDateTime(CreateDatetime(CalcDate('<CM+1D>', Today), 0T));
        if DateTimeDialog.RunModal() = Action::OK then begin
            SI.SetDate(Dt2Date(DateTimeDialog.GetDateTime()));
            UpdateCurrencyExchangeRates.Run();
            SI.SetDate(0D);
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::Location, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertLocation(var Rec: Record Location; RunTrigger: Boolean)
    var
        recInvPostGrp: Record "Inventory Posting Group";
        recInvPostSetup: Record "Inventory Posting Setup";
        recInvPostSetup2: Record "Inventory Posting Setup";
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
    begin
        if RunTrigger then
            if recInvPostGrp.FindFirst() then
                repeat
                    recInvPostSetup2.SetRange("Location Code", ItemLogisticEvents.GetMainWarehouseLocation());
                    recInvPostSetup2.SetRange("Invt. Posting Group Code", recInvPostGrp.Code);
                    if recInvPostSetup2.FindFirst() then begin
                        recInvPostSetup := recInvPostSetup2;
                        recInvPostSetup.Validate("Location Code", Rec.Code);
                        if not recInvPostSetup.Insert(true) then;
                    end;
                until recInvPostGrp.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Table, Database::"IC Outbox Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertICOutboxSalesLine(var Rec: Record "IC Outbox Sales Line"; RunTrigger: Boolean)
    var
        recSalesInvLine: Record "Sales Invoice Line";
        recGenBusPostGrp: Record "Gen. Business Posting Group";

        lText001: Label 'A difference has occured between the %1" on the "%2" and the "%3" on the "%4".\Please advice navsupport@zyxel.eu';

    begin
        if recSalesInvLine.Get(Rec."Document No.", Rec."Line No.") then
            if recSalesInvLine.Type <> Rec."IC Partner Ref. Type" then
                if recGenBusPostGrp.Get(recSalesInvLine."Gen. Bus. Posting Group") and (recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."sample / test equipment"::" ") then
                    Error(lText001, recSalesInvLine.FieldCaption(Type), recSalesInvLine.TableCaption(), Rec.FieldCaption(Rec."IC Partner Ref. Type"), Rec.TableCaption());
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
    local procedure OnAfterCompanyOpen()
    var

        ServicePointManager: dotnet ServicePointManager;
        SecurityProtocolType: dotnet SecurityProtocolType;
    begin
        ServicePointManager.SecurityProtocol := SecurityProtocolType.Tls12;

        // Change default document layout on standard reports
        UpdateReportLayoutSelection(Report::"Purchase - Invoice", './Layouts/PurchaseInvoiceZyxel.rdlc');
        UpdateReportLayoutSelection(Report::"Purchase - Credit Memo", './Layouts/PurchaseCreditMemoZyxel.rdlc');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterGetPrinterName', '', false, false)]
    local procedure OnAfterFindPrinter(ReportID: Integer; var PrinterName: Text[250])
    var
        SI: Codeunit "Single Instance";
    begin
        SI.UseOfReport(3, ReportID, 1);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnBeforeCompanyClose', '', false, false)]
    local procedure OnBeforeCompanyClose()
    var
        SI: Codeunit "Single Instance";

    begin
        if GuiAllowed() then
            SI.SaveUseOfReport();
    end;

    local procedure UpdateReportLayoutSelection(ReportID: Integer; NewLayout: Text)
    var
        ReportLayoutList: Record "Report Layout List";
        ReportLayoutSelection: Record "Report Layout Selection";
        CustomLayout: Integer;
    begin
        if ReportLayoutSelection.Get(ReportID, CompanyName()) then begin
            CustomLayout := ReportLayoutSelection.HasCustomLayout(ReportID);
            if CustomLayout in [1, 2] then
                exit;
        end;

        ReportLayoutList.SetRange("Report ID", ReportID);
        ReportLayoutList.SetRange(Description, NewLayout);
        if ReportLayoutList.FindFirst() then
            SetDefaultReportLayoutSelection(ReportLayoutList);
    end;

    local procedure SetDefaultReportLayoutSelection(SelectedReportLayoutList: Record "Report Layout List")
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        EmptyGuid: Guid;
        TypeInt: Integer;
    begin
        // Add to TenantReportLayoutSelection table with an Empty Guid.
        AddLayoutSelection(SelectedReportLayoutList, EmptyGuid);

        // Add to the report layout selection table
        TypeInt := GetReportLayoutSelectionCorrespondingEnum(SelectedReportLayoutList);
        if ReportLayoutSelection.Get(SelectedReportLayoutList."Report ID", CompanyName()) then begin
            if ReportLayoutSelection.Type <> TypeInt then begin
                ReportLayoutSelection.Validate(Type, TypeInt);
                if ReportLayoutSelection.Modify() then;
            end;
        end else begin
            ReportLayoutSelection.Init();
            ReportLayoutSelection."Report ID" := SelectedReportLayoutList."Report ID";
            ReportLayoutSelection."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(ReportLayoutSelection."Company Name"));
            ReportLayoutSelection.Validate(Type, TypeInt);
            ReportLayoutSelection."Custom Report Layout Code" := '';
            if not ReportLayoutSelection.Insert() then
                ReportLayoutSelection.Modify();
        end;
    end;

    local procedure GetReportLayoutSelectionCorrespondingEnum(SelectedReportLayoutList: Record "Report Layout List"): Integer
    begin
        case SelectedReportLayoutList."Layout Format" of
            SelectedReportLayoutList."Layout Format"::RDLC:
                exit(0);
            SelectedReportLayoutList."Layout Format"::Word:
                exit(1);
            SelectedReportLayoutList."Layout Format"::Custom:
                exit(2);
            SelectedReportLayoutList."Layout Format"::Excel:
                exit(3);
            else
                exit(4);
        end
    end;

    local procedure AddLayoutSelection(SelectedReportLayoutList: Record "Report Layout List"; UserIdGuid: Guid): Boolean
    var
        TenantReportLayoutSelection: Record "Tenant Report Layout Selection";
        CompName: Text[30];
    begin
        CompName := CopyStr(CompanyName(), 1, MaxStrLen(TenantReportLayoutSelection."Company Name"));
        if not TenantReportLayoutSelection.Get(SelectedReportLayoutList."Report ID", CompName, UserIdGuid) then begin
            TenantReportLayoutSelection.Init();
            TenantReportLayoutSelection."App ID" := SelectedReportLayoutList."Application ID";
            TenantReportLayoutSelection."Company Name" := CompName;
            TenantReportLayoutSelection."Layout Name" := SelectedReportLayoutList."Name";
            TenantReportLayoutSelection."Report ID" := SelectedReportLayoutList."Report ID";
            TenantReportLayoutSelection."User ID" := UserIdGuid;
            if not TenantReportLayoutSelection.Insert() then
                TenantReportLayoutSelection.Modify();
        end;
    end;


<<<<<<< HEAD
    // V26 >>
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Change Log Management", 'OnBeforeInsertChangeLogEntry', '', false, false)]
    // local procedure ChangeLogManagement_OnBeforeInsertChangeLogEntry(var ChangeLogEntry: Record "Change Log Entry"; AlwaysLog: Boolean; var Handled: Boolean)
    // var
    //     SI: Codeunit "Single Instance";
    // begin
    //     //>> 24-04-18 ZY-LD 002
    //     if SI.GetRecordRef().CurrentCompany <> CompanyName then
    //         exit;
    //     if SI.RejectChangeLog then
    //         exit;
    //     //<< 24-04-18 ZY-LD 002

    //     //>> 08-09-17 001 ZY-LD
    //     if (ChangeLogEntry."Table No." = Database::Customer) and (ChangeLogEntry."Field No." in [55026, 55028, 54]) or
    //        (ChangeLogEntry."Table No." = Database::"G/L Account") and (ChangeLogEntry."Field No." in [26]) or
    //        (ChangeLogEntry."Table No." = Database::Item) and (ChangeLogEntry."Field No." in [30, 62, 55008, 55014, 55015, 55016, 55017]) or
    //        (ChangeLogEntry."Table No." = Database::Vendor) and (ChangeLogEntry."Field No." in [54])
    //     then
    //         Handled := true;
    //     //<< 08-09-17 001 ZY-LD

    //     //>> 08-09-17 ZY-LD 001
    //     if TempChangeLogSetupTable2."Omit Modify on Creation Day" then
    //         if OmitModification(ChangeLogEntry."Table No.", SI.GetRecordRef()) then
    //             Handled := true;
    //     //<< 08-09-17 ZY-LD 001
    // end;
    // V26<<
=======
    /*[EventSubscriber(ObjectType::Codeunit, Codeunit::"Change Log Management", 'OnBeforeInsertChangeLogEntry', '', false, false)]
    local procedure ChangeLogManagement_OnBeforeInsertChangeLogEntry(var ChangeLogEntry: Record "Change Log Entry"; AlwaysLog: Boolean; var Handled: Boolean)
    var
        SI: Codeunit "Single Instance";
    begin
        if SI.GetRecordRef().CurrentCompany() <> CompanyName() then
            exit;
        if SI.RejectChangeLog() then
            exit;
        if TempChangeLogSetupTable2."Omit Modify on Creation Day" then
            if OmitModification(ChangeLogEntry."Table No.", SI.GetRecordRef()) then
                Handled := true;
    end; 
    */
>>>>>>> 111787a2f0c658073ec47c92c11d15db5a9839d3

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Change Log Management", 'OnBeforeLogInsertion', '', false, false)]
    local procedure ChangeLogManagement_OnBeforeLogInsertion(var RecRef: RecordRef)
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetRecordRef(RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Change Log Management", 'OnBeforeLogModification', '', false, false)]
    local procedure ChangeLogManagement_OnBeforeLogModification(var RecRef: RecordRef)
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetRecordRef(RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Change Log Management", 'OnBeforeLogRename', '', false, false)]
    local procedure ChangeLogManagement_OnBeforeLogRename(var RecRef: RecordRef)
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetRecordRef(RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Change Log Management", 'OnBeforeLogDeletion', '', false, false)]
    local procedure ChangeLogManagement_OnBeforeLogDeletion(var RecRef: RecordRef)
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetRecordRef(RecRef);
    end;
    // V26 >>
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Change Log Management", 'OnAfterGetDatabaseTableTriggerSetup', '', false, false)]
    // local procedure OnAfterGetDatabaseTableTriggerSetup(TempChangeLogSetupTable: Record "Change Log Setup (Table)" temporary; var LogInsert: Boolean; var LogModify: Boolean; var LogDelete: Boolean; var LogRename: Boolean);
    // begin
    //     TempChangeLogSetupTable2 := TempChangeLogSetupTable; //TODO Ensure this called for every request, so it has the correct value
    // end;
    // V26 >>

    local procedure OmitModification(TableNumber: Integer; RecRef: RecordRef): Boolean;
    var
        TempChangeLogEntry: Record "Change Log Entry" temporary;
        ChangeLogEntry: Record "Change Log Entry";
        KeyFldRef: FieldRef;
        KeyRef1: KeyRef;
        i: Integer;
    begin
        // Try to find the insert record in the Change Log Table
        TempChangeLogEntry.SetFilter("Date and Time", '%1..%2', CreateDateTime(Today(), 0T), CreateDateTime(ToDay(), 235959T));
        TempChangeLogEntry.SetRange("Table No.", TableNumber);
        TempChangeLogEntry.SetRange("Type of Change", TempChangeLogEntry."Type of Change"::Insertion);
        KeyRef1 := RecRef.KEYINDEX(1);
        for i := 1 to KeyRef1.FIELDCOUNT() do begin
            KeyFldRef := KeyRef1.FIELDINDEX(i);

            case i of
                1:
                    TempChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(KeyFldRef.VALUE(), 0, 9));
                2:
                    TempChangeLogEntry.SetRange("Primary Key Field 2 Value", Format(KeyFldRef.VALUE(), 0, 9));
                3:
                    TempChangeLogEntry.SetRange("Primary Key Field 3 Value", Format(KeyFldRef.VALUE(), 0, 9));
            end;
        end;
        if not TempChangeLogEntry.FindFirst() then begin
            ChangeLogEntry.SetFilter("Date and Time", '%1..%2', CreateDateTime(Today(), 0T), CreateDateTime(Today(), 235959T));
            ChangeLogEntry.SetRange("Table No.", TableNumber);
            ChangeLogEntry.SetRange("Type of Change", ChangeLogEntry."Type of Change"::Insertion);
            KeyRef1 := RecRef.KEYINDEX(1);
            for i := 1 to KeyRef1.FIELDCOUNT() do begin
                KeyFldRef := KeyRef1.FIELDINDEX(i);

                case i of
                    1:
                        ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(KeyFldRef.VALUE(), 0, 9));
                    2:
                        ChangeLogEntry.SetRange("Primary Key Field 2 Value", Format(KeyFldRef.VALUE(), 0, 9));
                    3:
                        ChangeLogEntry.SetRange("Primary Key Field 3 Value", Format(KeyFldRef.VALUE(), 0, 9));
                end;
            end;
            if ChangeLogEntry.FindFirst() then begin
                TempChangeLogEntry := ChangeLogEntry;
                TempChangeLogEntry.Insert();
                exit(true);
            end else
                exit(false);
        end else
            exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Layout Reporting", 'OnBeforeRunReportWithCustomReportSelection', '', false, false)]
    local procedure CustomLayoutReporting_OnBeforeRunReportWithCustomReportSelection(var OutputType: Option Print,Preview,PDF,Email,Excel,Word,XML; var CustomReportSelection: Record "Custom Report Selection"; var EmailPrintIfEmailIsMissing: Boolean; var ReportID: Integer)
    var
        recCust: Record Customer;
        SingleInstance: Codeunit "Single Instance";

    begin
        if not (OutputType = 99) then
            SingleInstance.SetOutputType(OutputType)
        else
            OutputType := SingleInstance.GetOutputType();

        if (OutputType = OutputType::Email) and
           (CustomReportSelection."Source Type" = Database::Customer) and
           (CustomReportSelection.Usage = CustomReportSelection.Usage::"C.Statement")
        then begin
            recCust.Get(CustomReportSelection."Source No.");
            if not recCust."E-Mail Statement" then
                if recCust."Print Statements" and EmailPrintIfEmailIsMissing then
                    OutputType := OutputType::Print
                else
                    OutputType := 99;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Format Address", 'OnBeforeSalesInvShipTo', '', false, false)]
    local procedure FormatAddress_OnBeforeSalesInvShipTo(var AddrArray: array[8] of Text[100]; var SalesInvHeader: Record "Sales Invoice Header"; var Handled: Boolean; var Result: Boolean; var CustAddr: array[8] of Text[100])
    var
        recCountryShipDay: Record "VCK Country Shipment Days";
        recShiptoAdd: Record "Ship-to Address";
        ZGT: Codeunit "ZyXEL General Tools";
        FormatAddr: Codeunit "Format Address";
        i: Integer;
    begin
        Handled := true;
        with SalesInvHeader do begin
            if ZGT.IsRhq() then
                if not recCountryShipDay.Get(SalesInvHeader."Ship-to Country/Region Code") then
                    Clear(recCountryShipDay);
            if (recCountryShipDay."Ship-To Code" <> '') and
               (SalesInvHeader."Sales Order Type" = SalesInvHeader."Sales Order Type"::Normal)
            then begin
                recShiptoAdd.Get(SalesInvHeader."Bill-to Customer No.", recCountryShipDay."Ship-To Code");
                FormatAddr.FormatAddr(
                  AddrArray, recShiptoAdd.Name, recShiptoAdd."Name 2", recShiptoAdd.Contact, recShiptoAdd.Address, recShiptoAdd."Address 2",
                  recShiptoAdd.City, recShiptoAdd."Post Code", recShiptoAdd.County, recShiptoAdd."Country/Region Code");
            end else
                if "eCommerce Order" then
                    FormatAddr.FormatAddr(
                      AddrArray, '', '', '', '', '',
                      "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code")
                else
                    FormatAddr.FormatAddr(
                      AddrArray, "Ship-to Name", "Ship-to Name 2", "Ship-to Contact", "Ship-to Address", "Ship-to Address 2",
                      "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code");

            if "Sell-to Customer No." <> "Bill-to Customer No." then begin
                Result := true;
                exit;
            end;
            for i := 1 to ArrayLen(AddrArray) do
                if AddrArray[i] <> CustAddr[i] then begin
                    Result := true;
                    exit;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure ReportManagement_OnAfterSubstituteReport(ReportId: Integer; RunMode: Option; RequestPageXml: Text; RecordRef: RecordRef; var NewReportId: Integer)
    var
        SubtiRep: Record "Substitute Report";
    begin
        case ReportId of
            Report::"Exch. Rate Adjustment":
                NewReportId := Report::"Exch. Rate Adjustment Zyxel";
            Report::"VAT- VIES Declaration Tax Auth":
                NewReportId := Report::"VAT- VIES Decl. Tax Auth ZX";
            Report::"Move IC Trans. to Partner Comp":
                NewReportId := Report::"Move IC Trans. to Pa. Comp ZX";
            Report::"Calculate Inventory":
                NewReportId := Report::"Calculate Inventory ZX";
            Report::"Calculate Inventory Value":
                NewReportId := Report::"Calculate Inventory Value ZX";
            Report::"Combine Shipments":
                NewReportId := Report::"Combine Shipments ZX";
            Report::"Customer - Sales List":
                NewReportId := Report::"Customer - Sales List ZX";
            Report::"Customer - Summary Aging":
                NewReportId := Report::"Customer - Summary Aging ZX";
            Report::"Statement":
                NewReportId := Report::"Statement ZX";

            else
                if SubtiRep.get(ReportId) then
                    NewReportId := SubtiRep."New Report Id";
        end;
    end;

    var
        TempChangeLogSetupTable2: Record "Change Log Setup (Table)" temporary;
}
