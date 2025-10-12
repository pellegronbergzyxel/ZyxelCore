codeunit 50087 "Zyxel General Event"
{
    // 004. 06-12-18 ZY-LD 000 - Replicate User Setup.
    // 005. 13-05-20 ZY-LD P0435 - Run Job Queue Monitor.
    // 006. 16-10-20 ZY-LD P0500 - Use of Report.
    // 007. 21-12-20 ZY-LD 000 - When communication with HMRC a security protocol needs to be added.
    // 008. 09-02-21 ZY-LD 000 - Create User Setup and user personailzation.
    // 009. 26-02-21 ZY-LD 2021021810000306 - Set "Start Date" on Exchange Rate.
    // 010. 07-04-21 ZY-LD 000 - Check for negative values in MTD.
    // 011. 14-04-21 ZY-LD P0559 - Automated replication after update.
    // 012. 19-04-21 ZY-LD 2021041910000131 - Insert "Inventory Posting Setup" when creating new location.
    // 013. 18-10-21 ZY-LD 2021101810000032 - It happens from time to time that "Type" doesn´t get transferred to the IC Outbox document. We need to locate the error.
    // 014. 31-03-22 ZY-LD 000 - Copy TYR from last month automatic.
    // 015. 01-07-22 ZY-LD 000 - Adjusted Currency Exchange Rate Handling.
    // 016. 30-09-22 ZY-LD 2022092710000043 - Security Layer must be TLS1.2 to download exchange rates.
    // 017. 02-04-24 ZY-LD 000 - Customized customer statement.

    Permissions = TableData "Use of Report Entry" = rimd,
                  tabledata "Substitute Report" = r;

    trigger OnRun()
    begin
    end;

    var
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";

    local procedure "Sales Price"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifySalesPrice(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    begin
        //DeleteSalesPriceReplicated(Rec);  // 24-09-18 ZY-LD 003
        //We need TO investigate all delete functions first.
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteSalesPrice(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    begin
        //DeleteSalesPriceReplicated(Rec);  // 24-09-18 ZY-LD 003
    end;

    local procedure DeleteSalesPriceReplicated(var Rec: Record "Price List Line")
    var
        recSalesPriceRep: Record "Price List Line Replicated";
    begin
        //>> 24-09-18 ZY-LD 003
        begin
            recSalesPriceRep.SetRange("Price List Code", Rec."Price List Code");
            recSalesPriceRep.SetRange("Line No.", Rec."Line No.");
            recSalesPriceRep.DeleteAll(true);
        end;
        //<< 24-09-18 ZY-LD 003
    end;

    local procedure ">> Bank Account"()
    begin
    end;

    local procedure ">> User"()
    begin
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

        //>> 09-02-21 ZY-LD 008
        if not ZGT.ItalianServer() and not ZGT.TurkishServer() then  // 02-01-24 ZY-LD 017
            recUserSetup.ChangeCompany(ZGT.GetRHQCompanyName);
        recUserSetup.Validate("User ID", Rec."User Name");
        if not recUserSetup.Insert(true) then;

        if not ZGT.ItalianServer() and not ZGT.TurkishServer() then  // 02-01-24 ZY-LD 017
            recUserSetup.ChangeCompany(ZGT.GetSistersCompanyName(1))
        else
            //>> 02-01-24 ZY-LD 017
            if ZGT.ItalianServer() then
                recUserSetup.ChangeCompany(ZGT.GetSistersCompanyName(14))
            else
                if ZGT.TurkishServer() then
                    recUserSetup.ChangeCompany(ZGT.GetSistersCompanyName(15));  //<< 02-01-24 ZY-LD 017
        if not recUserSetup.Insert(true) then;

        //recUserPer.VALIDATE("User ID","User Name");
        recUserPer.Validate("User SID", Rec."User Security ID");
        if not recUserPer.Insert(true) then;
        //<< 09-02-21 ZY-LD 008
    end;

    [EventSubscriber(ObjectType::Table, Database::"User Setup", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyUserSetup(var Rec: Record "User Setup"; var xRec: Record "User Setup"; RunTrigger: Boolean)
    begin
        ZyWebServMgt.ReplicateUserSetup(Rec."User ID");  // 06-12-18 ZY-LD 004
    end;

    local procedure ">> Currency"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Currency Exchange Rate", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertCurrencyExchangeRate(var Rec: Record "Currency Exchange Rate"; RunTrigger: Boolean)
    var
        SI: Codeunit "Single Instance";
    begin
        begin
            //>> 26-02-21 ZY-LD 009
            if not Rec.IsTemporary and not SI.GetWebServiceUpdate then
                if SI.GetDate <> 0D then
                    Rec."Starting Date" := SI.GetDate;
            //<< 26-02-21 ZY-LD 009
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Currency Exchange Rate", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertCurrencyExchangeRate(var Rec: Record "Currency Exchange Rate"; RunTrigger: Boolean)
    var
        recCurrency: Record Currency;
        recCurrExchRate: Record "Currency Exchange Rate";
        recServerEnviron: Record "Server Environment";
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
    begin
        begin
            //>> 31-03-22 ZY-LD 014
            /*//>> 26-02-21 ZY-LD 009
            IF recCurrency.GET("Currency Code") THEN BEGIN
              IF NOT recCurrency."Update via Exchange Rate Serv." THEN
                DELETE(TRUE);
            END;
            //<< 26-02-21 ZY-LD 009*/

            //>> 01-07-22 ZY-LD 015
            if not Rec.IsTemporary then begin
                if ZGT.IsRhq and ZGT.IsZComCompany then
                    if SI.GetExchangeRateService then
                        if recCurrency.Get(Rec."Currency Code") then
                            if not recCurrency."Update via Exchange Rate Serv." then
                                Rec.Delete(true);

                /*IF NOT ISTEMPORARY THEN BEGIN
                  IF NOT SI.GetWebServiceUpdate THEN
                    IF ZGT.IsRhq AND ZGT.IsZComCompany THEN
                      IF SI.GetDate = 0D THEN BEGIN  // During the month
                        IF recCurrency.GET("Currency Code") THEN
                          IF NOT recCurrency."Update via Exchange Rate Serv." THEN
                            DELETE(TRUE);
                      END ELSE BEGIN  // At end of month
                        IF recCurrency.GET("Currency Code") THEN
                          IF recCurrency."Copy Last Months Exch. Rate" THEN BEGIN
                            recCurrExchRate.SETRANGE("Currency Code","Currency Code");
                            recCurrExchRate.SETFILTER("Starting Date",'<%1',"Starting Date");
                            IF recCurrExchRate.FINDLAST THEN BEGIN
                              "Exchange Rate Amount" := recCurrExchRate."Exchange Rate Amount";
                              "Adjustment Exch. Rate Amount" := recCurrExchRate."Adjustment Exch. Rate Amount";
                              Modify(true);
                            END;
                          END ELSE
                            IF NOT recCurrency."Update via Exchange Rate Serv." THEN
                              DELETE(TRUE);
                      END;*/
                //<< 31-03-22 ZY-LD 014
                //<< 01-07-22 ZY-LD 015

                //>> 12-08-20 ZY-LD 007
                recCurrency.Get(Rec."Currency Code");
                recCurrency.Replicated := false;
                recCurrency.Modify(true);
                //<< 12-08-20 ZY-LD 007
            end;
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
        //>> 01-07-22 ZY-LD 015
        if not Rec.IsTemporary then
            if ZGT.IsRhq and ZGT.IsZComCompany then
                if SI.GetExchangeRateService then
                    if recCurrency.Get(Rec."Currency Code") then
                        if not recCurrency."Update via Exchange Rate Serv." then
                            if SI.GetExchangeRateTmp(Rec."Currency Code", recCurrExchRateTmp) then begin
                                Rec."Exchange Rate Amount" := recCurrExchRateTmp."Exchange Rate Amount";
                                Rec."Adjustment Exch. Rate Amount" := recCurrExchRateTmp."Adjustment Exch. Rate Amount";
                            end;
        //<< 01-07-22 ZY-LD 015
    end;

    [EventSubscriber(ObjectType::Table, Database::"Currency Exchange Rate", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyCurrencyExchangeRate(var Rec: Record "Currency Exchange Rate"; var xRec: Record "Currency Exchange Rate"; RunTrigger: Boolean)
    var
        recCurrency: Record Currency;
    begin
        begin
            //>> 12-08-20 ZY-LD 007
            recCurrency.Get(Rec."Currency Code");
            recCurrency.Replicated := false;
            recCurrency.Modify(true);
            //<< 12-08-20 ZY-LD 007
        end;
    end;

    [EventSubscriber(Objecttype::Page, Page::Currencies, 'OnAfterActionEvent', 'UpdateExchangeRatesDate', false, false)]
    local procedure OnAfterActionEventUpdateExchangeRatesDate_Page5(var Rec: Record Currency)
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        SI: Codeunit "Single Instance";
        DateTimeDialog: Page "Date-Time Dialog";
    begin
        //>> 26-02-21 ZY-LD 009
        DateTimeDialog.SetDateTime(CreateDatetime(CalcDate('<CM+1D>', Today), 0T));
        if DateTimeDialog.RunModal = Action::OK then begin
            SI.SetDate(Dt2Date(DateTimeDialog.GetDateTime));
            UpdateCurrencyExchangeRates.Run;
            SI.SetDate(0D);
        end;
        //<< 26-02-21 ZY-LD 009
    end;

    local procedure ">> VAT Registration No. Format"()
    begin
    end;

    // [EventSubscriber(ObjectType::Table, Database::"VAT Registration No. Format", 'OnBeforeExitTest', '', false, false)]
    // local procedure OnBeforeExitTest(VATRegNo: Text[20]; CountryCode: Code[10]; Number: Code[20]; TableID: Option)
    // begin
    //     //>> 31-03-21 ZY-LD 010
    //     case TableID of
    //         Database::"Concur Vendor":
    //             CheckConcurVendor(VATRegNo, Number);
    //     end;
    //     //<< 31-03-21 ZY-LD 010
    // end;

    // local procedure CheckConcurVendor(VATRegNo: Text[20]; Number: Code[20])
    // var
    //     ConcVend: Record "Concur Vendor";
    //     Check: Boolean;
    //     Finish: Boolean;
    //     t: Text[250];
    //     lText001: Label 'This VAT registration number has already been entered for the following concur vendors:\ %1';
    // begin
    //     //>> 31-03-21 ZY-LD 010
    //     Check := true;
    //     t := '';
    //     ConcVend.SetCurrentkey("VAT Registration No.");
    //     ConcVend.SetRange("VAT Registration No.", VATRegNo);
    //     ConcVend.SetFilter("No.", '<>%1', Number);
    //     if ConcVend.Find('-') then begin
    //         Check := false;
    //         Finish := false;
    //         repeat
    //             if ConcVend."No." <> Number then
    //                 if t = '' then
    //                     t := ConcVend."No."
    //                 else
    //                     if StrLen(t) + StrLen(ConcVend."No.") + 5 <= MaxStrLen(t) then
    //                         t := t + ', ' + ConcVend."No."
    //                     else begin
    //                         t := t + '...';
    //                         Finish := true;
    //                     end;
    //         until (ConcVend.Next() = 0) or Finish;
    //     end;
    //     if Check = false then
    //         Message(lText001, t);
    //     //<< 31-03-21 ZY-LD 010
    // end;

    local procedure ">> Location"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::Location, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertLocation(var Rec: Record Location; RunTrigger: Boolean)
    var
        recInvPostGrp: Record "Inventory Posting Group";
        recInvPostSetup: Record "Inventory Posting Setup";
        recInvPostSetup2: Record "Inventory Posting Setup";
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
    begin
        //>> 19-04-21 ZY-LD 012
        if RunTrigger then
            if recInvPostGrp.FindFirst() then
                repeat
                    recInvPostSetup2.SetRange("Location Code", ItemLogisticEvents.GetMainWarehouseLocation);
                    recInvPostSetup2.SetRange("Invt. Posting Group Code", recInvPostGrp.Code);
                    if recInvPostSetup2.FindFirst() then begin
                        recInvPostSetup := recInvPostSetup2;
                        recInvPostSetup.Validate("Location Code", Rec.Code);
                        if not recInvPostSetup.Insert(true) then;
                    end;
                until recInvPostGrp.Next() = 0;
        //<< 19-04-21 ZY-LD 012
    end;

    local procedure ">> IC Intercompany"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"IC Outbox Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertICOutboxSalesLine(var Rec: Record "IC Outbox Sales Line"; RunTrigger: Boolean)
    var
        recSalesInvLine: Record "Sales Invoice Line";
        lText001: Label 'A difference has occured between the %1" on the "%2" and the "%3" on the "%4".\Please advice navsupport@zyxel.eu';
        recGenBusPostGrp: Record "Gen. Business Posting Group";
    begin
        begin
            //>> 18-10-21 ZY-LD 013
            if recSalesInvLine.Get(Rec."Document No.", Rec."Line No.") then
                if recSalesInvLine.Type <> Rec."IC Partner Ref. Type" then
                    if recGenBusPostGrp.Get(recSalesInvLine."Gen. Bus. Posting Group") and (recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."sample / test equipment"::" ") then
                        Error(lText001, recSalesInvLine.FieldCaption(Type), recSalesInvLine.TableCaption(), Rec.FieldCaption(Rec."IC Partner Ref. Type"), Rec.TableCaption());
            //<< 18-10-21 ZY-LD 013
        end;
    end;

    local procedure ">> Codeunit 1"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
    local procedure OnAfterCompanyOpen()
    var
        JobQueueMonitor: Codeunit "Job Queue Monitor";
        ZGT: Codeunit "Zyxel General Tools";
        ServicePointManager: dotnet ServicePointManager;
        SecurityProtocolType: dotnet SecurityProtocolType;
    begin
        // We don´t need that anymore. 18-07-24 ZY-LD 
        // if not ZGT.ItalianServer and not ZGT.TurkishServer() then
        //     if currentclienttype <> ClientType::SOAP then
        //         JobQueueMonitor.Monitor(GuiAllowed());  // 13-05-20 ZY-LD 005
        ServicePointManager.SecurityProtocol := SecurityProtocolType.Tls12;  // 30-09-22 ZY-LD 016

        // Change default document layout on standard reports
        UpdateReportLayoutSelection(Report::"Purchase - Invoice", './Layouts/PurchaseInvoiceZyxel.rdlc');
        UpdateReportLayoutSelection(Report::"Purchase - Credit Memo", './Layouts/PurchaseCreditMemoZyxel.rdlc');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterGetPrinterName', '', false, false)]
    local procedure OnAfterFindPrinter(ReportID: Integer; var PrinterName: Text[250])
    var
        SI: Codeunit "Single Instance";
    begin
        SI.UseOfReport(3, ReportID, 1);  // 16-10-20 ZY-LD 006
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnBeforeCompanyClose', '', false, false)]
    local procedure OnBeforeCompanyClose()
    var
        SI: Codeunit "Single Instance";
        JobQueueMonitor: Codeunit "Job Queue Monitor";
    begin
        if GuiAllowed() then begin
            SI.SaveUseOfReport;  // 16-10-20 ZY-LD 006
            //JobQueueMonitor.Monitor(GuiAllowed());  // 13-05-20 ZY-LD 005  18-07-24 ZY-LD 000 - We don´t need that anymore.
        end;
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

    local procedure ">> Codeunit 1140"()
    begin
    end;

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
        KeyRef1: KeyRef;
        KeyFldRef: FieldRef;
        i: Integer;
    begin
        //>> 08-09-17 ZY-LD 001
        // Try to find the insert record in the Change Log Table
        TempChangeLogEntry.SetFilter("Date and Time", '%1..%2', CreateDateTime(Today(), 0T), CreateDateTime(ToDay(), 235959T));
        TempChangeLogEntry.SetRange("Table No.", TableNumber);
        TempChangeLogEntry.SetRange("Type of Change", TempChangeLogEntry."Type of Change"::Insertion);
        KeyRef1 := RecRef.KEYINDEX(1);
        for i := 1 to KeyRef1.FIELDCOUNT do begin
            KeyFldRef := KeyRef1.FIELDINDEX(i);

            case i of
                1:
                    TempChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(KeyFldRef.VALUE, 0, 9));
                2:
                    TempChangeLogEntry.SetRange("Primary Key Field 2 Value", Format(KeyFldRef.VALUE, 0, 9));
                3:
                    TempChangeLogEntry.SetRange("Primary Key Field 3 Value", Format(KeyFldRef.VALUE, 0, 9));
            end;
        end;
        if not TempChangeLogEntry.FindFirst() then begin
            ChangeLogEntry.SetFilter("Date and Time", '%1..%2', CreateDateTime(Today(), 0T), CreateDateTime(Today(), 235959T));
            ChangeLogEntry.SetRange("Table No.", TableNumber);
            ChangeLogEntry.SetRange("Type of Change", ChangeLogEntry."Type of Change"::Insertion);
            KeyRef1 := RecRef.KEYINDEX(1);
            for i := 1 to KeyRef1.FIELDCOUNT do begin
                KeyFldRef := KeyRef1.FIELDINDEX(i);

                case i of
                    1:
                        ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(KeyFldRef.VALUE, 0, 9));
                    2:
                        ChangeLogEntry.SetRange("Primary Key Field 2 Value", Format(KeyFldRef.VALUE, 0, 9));
                    3:
                        ChangeLogEntry.SetRange("Primary Key Field 3 Value", Format(KeyFldRef.VALUE, 0, 9));
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
        //<< 08-09-17 ZY-LD 001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Layout Reporting", 'OnBeforeRunReportWithCustomReportSelection', '', false, false)]
    local procedure CustomLayoutReporting_OnBeforeRunReportWithCustomReportSelection(var OutputType: Option Print,Preview,PDF,Email,Excel,Word,XML; var CustomReportSelection: Record "Custom Report Selection"; var EmailPrintIfEmailIsMissing: Boolean; var ReportID: Integer)
    var
        SingleInstance: Codeunit "Single Instance";
        recCust: Record Customer;
        PrevOutputType: Integer;
    begin
        //>> 16-10-18 ZY-LD 001
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
                if recCust."Print Statements" and EmailPrintIfEmailIsMissing then  // 03-12-19 ZY-LD 003
                    OutputType := OutputType::Print
                else
                    OutputType := 99;  // 03-12-19 ZY-LD 003
        end;
        //<< 16-10-18 ZY-LD 001
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
            //>> 10-08-18 ZY-LD 001
            if ZGT.IsRhq then
                if not recCountryShipDay.Get(SalesInvHeader."Ship-to Country/Region Code") then
                    Clear(recCountryShipDay);  // 05-11-18 ZY-LD 001
            if (recCountryShipDay."Ship-To Code" <> '') and
               (SalesInvHeader."Sales Order Type" = SalesInvHeader."Sales Order Type"::Normal)  // 16-10-19 ZY-LD 002
            then begin
                recShiptoAdd.Get(SalesInvHeader."Bill-to Customer No.", recCountryShipDay."Ship-To Code");
                FormatAddr.FormatAddr(
                  AddrArray, recShiptoAdd.Name, recShiptoAdd."Name 2", recShiptoAdd.Contact, recShiptoAdd.Address, recShiptoAdd."Address 2",
                  recShiptoAdd.City, recShiptoAdd."Post Code", recShiptoAdd.County, recShiptoAdd."Country/Region Code");
            end else  //<< 10-08-18 ZY-LD 001
                      //>> 11-11-22 ZY-LD 004
                if "eCommerce Order" then
                    FormatAddr.FormatAddr(
                      AddrArray, '', '', '', '', '',
                      "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code")
                else  //<< 11-11-22 ZY-LD 004
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
        end;  // 10-08-18 ZY-LD 001
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
            //>> 02-04-24 ZY-LD 017
            //            Report::"Standard Statement":
            //                NewReportId := Report::"Standard Statement Zyxel";

            //<< 02-04-24 ZY-LD 017                
            else begin
                if SubtiRep.get(ReportId) then
                    NewReportId := SubtiRep."New Report Id";
            end;
        end;
    end;

    var
        TempChangeLogSetupTable2: Record "Change Log Setup (Table)" temporary;
}
