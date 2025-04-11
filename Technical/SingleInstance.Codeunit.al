Codeunit 50054 "Single Instance"
{
    // 001. 24-04-18 ZY-LD 000 - New function "RejectItemReplication".
    // 002. 16-10-18 ZY-LD 2018101610000042 - Set Date.
    // 003. 20-11-18 ZY-LD 000 - Set Merge Text.
    // 004. 01-02-19 ZY-LD 000 - Show Dialog, used for creating purchase receipt.
    // 005. 12-03-19 ZY-LD 000 - Hide dialog.
    // 006. 20-09-19 ZY-LD P0302 - E-mail Sales Invoice.
    // 007. 16-10-20 ZY-LD P0500 - Use of Report.
    // 008. 04-11-20 ZY-LD P0517 - Delete Sales Order.
    // 009. 18-11-20 ZY-LD 2020111710000052 - In special occations a validation has to be avoided.
    // 010. 26-11-20 ZY-LD 2020111910000165 - Save Sales Header.
    // 011. 11-02-22 ZY-LD P0747 - Handling "Charge (Item)".
    // 012. 25-04-22 ZY-LD 2022042510000261 - Prevent Negative Inventory.
    // 013. 01-07-22 ZY-LD 000 - Handling Currency Exchange Rates.

    Permissions = TableData "Use of Report Entry" = rimd;
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    procedure SetSalesInvoiceNo(pSalesInvoiceNo: Code[20])
    begin
        gSalesInvoiceNo := pSalesInvoiceNo;
    end;


    procedure GetSalesInvoiceNo(): Code[20]
    begin
        exit(gSalesInvoiceNo);
    end;


    procedure SetDocumentNo(pDocumentNo: Code[20])
    begin
        gDocumentNo := pDocumentNo;
    end;


    procedure GetDocumentNo(): Code[20]
    begin
        exit(gDocumentNo);
    end;


    procedure SetMergefield(pFieldNo: Integer; pValue: Text)
    var
        lCountry: Record "Country/Region";
    begin
        case pFieldNo of
            8, 27:
                begin
                    if lCountry.Get(pValue) then
                        gMergeFields[pFieldNo] := lCountry.Name
                    else
                        gMergeFields[pFieldNo] := pValue;
                end;
            else
                gMergeFields[pFieldNo] := CopyStr(pValue, 1, 250);
        end;
    end;


    procedure GetMergefield(pFieldNo: Integer): Text
    begin
        exit(gMergeFields[pFieldNo]);
    end;


    procedure SetMergeText(pMergeText: Text)
    begin
        gMergeText := pMergeText;  // 20-11-18 ZY-LD 003
    end;


    procedure GetMergeText(): Text
    begin
        exit(gMergeText);  // 20-11-18 ZY-LD 003
    end;


    procedure SetManualChange(pManualChange: Boolean)
    begin
        gManualChange := pManualChange;
    end;


    procedure GetManualChange(): Boolean
    begin
        exit(gManualChange);
    end;


    procedure SetAllowToDeleteAddItem(pAllowDeleteAddItem: Boolean)
    begin
        gAllowDeleteAddItem := pAllowDeleteAddItem;
    end;


    procedure GetAllowToDeleteAddItem(): Boolean
    begin
        exit(gAllowDeleteAddItem);
    end;


    procedure SetRejectChangeLog(pRejectChangeLog: Boolean)
    begin
        gRejectChangeLog := pRejectChangeLog;  // 24-04-18 ZY-LD 001
    end;


    procedure RejectChangeLog(): Boolean
    begin
        exit(gRejectChangeLog);  // 24-04-18 ZY-LD 001
    end;


    procedure SetDate(pDate: Date)
    begin
        gDate := pDate;  // 16-10-18 ZY-LD 002
    end;


    procedure GetDate(): Date
    begin
        exit(gDate);  // 16-10-18 ZY-LD 002
    end;


    procedure SetWarehouseManagement(pWarehouseManagement: Boolean)
    begin
        gWarehouseManagement := pWarehouseManagement;  // 01-02-19 ZY-LD 004
    end;


    procedure GetWarehouseManagement(): Boolean
    begin
        exit(gWarehouseManagement);  // 01-02-19 ZY-LD 004
    end;


    procedure SetHideSalesDialog(pHideSalesDialog: Boolean)
    begin
        gHideSalesDialog := pHideSalesDialog;  // 12-03-19 ZY-LD 005
    end;


    procedure GetHideSalesDialog(): Boolean
    begin
        exit(gHideSalesDialog);  // 12-03-19 ZY-LD 005
    end;


    procedure SetHideReportDialog(pHideReportDialog: Boolean)
    begin
        gHideReportDialog := pHideReportDialog;  // 12-03-19 ZY-LD 005
    end;


    procedure GetHideReportDialog(): Boolean
    begin
        exit(gHideReportDialog);  // 12-03-19 ZY-LD 005
    end;


    procedure UseOfReport(pObjectType: Integer; pObjectId: Integer; pReportType: Integer)
    var
        recServEnviron: Record "Server Environment";
        recObject: Record AllObj;
        ZGT: Codeunit "ZyXEL General Tools";
        EntNo: Integer;
    begin
        //>> 16-10-20 ZY-LD 007
        if recServEnviron.ProductionEnvironment then begin
            recUseOfRepTmp.SetRange("Company Name", CompanyName());
            recUseOfRepTmp.SetRange("Object Type", pObjectType);
            recUseOfRepTmp.SetRange("Object Id", pObjectId);
            recUseOfRepTmp.SetRange("User Id", UserId());
            recUseOfRepTmp.SetRange(Month, Date2dmy(Today, 2));
            recUseOfRepTmp.SetRange(Year, Date2dmy(Today, 3));
            if recUseOfRepTmp.FindFirst then begin
                if pReportType > 1 then
                    recUseOfRepTmp."Report Type" := pReportType;
                recUseOfRepTmp.Quantity += 1;
                recUseOfRepTmp.Modify;
            end else begin
                recObject.Get(pObjectType, pObjectId);

                recUseOfRepTmp.Reset;
                EntNo := 1;
                if recUseOfRepTmp.FindLast then
                    EntNo := recUseOfRepTmp."Entry No." + 1;
                Clear(recUseOfRepTmp);

                recUseOfRepTmp."Entry No." := EntNo;
                recUseOfRepTmp."Company Name" := CompanyName();
                recUseOfRepTmp."Object Type" := pObjectType;
                recUseOfRepTmp."Object Id" := pObjectId;
                recUseOfRepTmp."Object Description 2" := recObject."Object Name";
                recUseOfRepTmp."User Id" := UserId;
                if pObjectType = 8 then
                    recUseOfRepTmp."Report Type" := recUseOfRepTmp."report type"::Page
                else
                    recUseOfRepTmp."Report Type" := pReportType;
                GetReportType(Format(recUseOfRepTmp."Object Id"), recUseOfRepTmp."Report Type");
                recUseOfRepTmp.Month := Date2dmy(Today, 2);
                recUseOfRepTmp.Year := Date2dmy(Today, 3);
                recUseOfRepTmp.Quantity := 1;
                recUseOfRepTmp.Insert;
            end;
        end;
        //<< 16-10-20 ZY-LD 007
    end;


    procedure SaveUseOfReport()
    var
        recUseofRep: Record "Use of Report Entry";
        recAutoSetup: Record "Automation Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
    begin
        //>> 16-10-20 ZY-LD 007
        recUseOfRepTmp.Reset;
        if recUseOfRepTmp.FindFirst then
            if ZGT.ItalianServer or ZGT.TurkishServer then
                ZyWebServMgt.SendUseOfReport(recUseOfRepTmp)
            else
                InsertUseOfReport(recUseOfRepTmp);
        recUseOfRepTmp.DeleteAll;

        //<< 16-10-20 ZY-LD 007
    end;


    procedure InsertUseOfReport(var pUseOfRepTmp: Record "Use of Report Entry" temporary)
    var
        recUseofRep: Record "Use of Report Entry";
        recAutoSetup: Record "Automation Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
    begin
        //>> 16-10-20 ZY-LD 007
        if ZGT.IsZNetCompany then
            recAutoSetup.ChangeCompany(ZGT.GetSistersCompanyName(1))
        else
            recAutoSetup.ChangeCompany(ZGT.GetCompanyName(1));
        recAutoSetup.Get;
        if recAutoSetup."Register Use of Report" then
            if pUseOfRepTmp.FindSet then
                repeat
                    recUseofRep.SetRange("Company Name", pUseOfRepTmp."Company Name");
                    recUseofRep.SetRange("Object Type", pUseOfRepTmp."Object Type");
                    recUseofRep.SetRange("Object Id", pUseOfRepTmp."Object Id");
                    recUseofRep.SetRange("User Id", pUseOfRepTmp."User Id");
                    recUseofRep.SetRange(Month, pUseOfRepTmp.Month);
                    recUseofRep.SetRange(Year, pUseOfRepTmp.Year);
                    if recUseofRep.FindFirst then begin
                        recUseofRep.Quantity += pUseOfRepTmp.Quantity;
                        recUseofRep.Date := CurrentDatetime;
                        recUseofRep.Modify;
                    end else begin
                        Clear(recUseofRep);
                        recUseofRep.Reset;
                        recUseofRep."Company Name" := pUseOfRepTmp."Company Name";
                        recUseofRep."Object Type" := pUseOfRepTmp."Object Type";
                        recUseofRep."Object Id" := pUseOfRepTmp."Object Id";
                        recUseofRep."User Id" := pUseOfRepTmp."User Id";
                        recUseofRep."Report Type" := pUseOfRepTmp."Report Type";
                        recUseofRep.Month := pUseOfRepTmp.Month;
                        recUseofRep.Year := pUseOfRepTmp.Year;
                        recUseofRep.Quantity := pUseOfRepTmp.Quantity;
                        recUseofRep."Object Description 2" := pUseOfRepTmp."Object Description 2";
                        recUseofRep.Date := CurrentDatetime;
                        recUseofRep.Insert;
                    end;
                until pUseOfRepTmp.Next() = 0;
        //<< 16-10-20 ZY-LD 007
    end;

    local procedure GetReportType(pReportNo: Code[10]; var pReportType: Option " ","Report","Processing Only",Excel,"Usable (but unused)",Document)
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.ItalianServer then begin
            if StrPos('50023,50024,406,407', pReportNo) <> 0 then
                pReportType := Preporttype::Document;
        end else
            if ZGT.TurkishServer then begin
                if StrPos('206,207,406,407', pReportNo) <> 0 then
                    pReportType := Preporttype::Document;
            end else
                if StrPos('50000,50001,50007,50008,50009,50010,50014,50015,50016,50018,50020,50021,50029,50033,50043,50049,50057,50066,50067,50106,50107,50139,50185,50186', pReportNo) <> 0 then
                    pReportType := Preporttype::Document;
    end;


    procedure SetDeleteSalesOrder(pDeleteSalesOrder: Boolean)
    begin
        gDeleteSalesOrder := pDeleteSalesOrder;  // 04-11-20 ZY-LD 008
    end;


    procedure GetDeleteSalesOrder(): Boolean
    begin
        exit(gDeleteSalesOrder);  // 04-11-20 ZY-LD 008
    end;


    procedure SetPostedManually(pPostedManually: Boolean)
    begin
        gPostedManually := pPostedManually;
    end;


    procedure GetPostedManually(): Boolean
    begin
        exit(gPostedManually);
    end;


    procedure ResetYesToAll()
    begin
        gYesToAll := false;
        gDontAskAgain := false;
    end;


    procedure GetYesToAll(RequestOnly: Boolean) rValue: Boolean
    var
        lText001: label 'Yes to all?';
    begin
        if gYesToAll then
            rValue := gYesToAll
        else
            if (not RequestOnly) and (not gDontAskAgain) then begin
                gYesToAll := Confirm(lText001);
                gDontAskAgain := true;
            end;
    end;


    procedure SaveSalesHeader(var pSalesHead: Record "Sales Header")
    begin
        recSalesHead := pSalesHead;  // 26-11-20 ZY-LD 010
    end;


    procedure GetSalesHeader(var pSalesHead: Record "Sales Header")
    begin
        pSalesHead := recSalesHead;  // 26-11-20 ZY-LD 010
    end;


    procedure ClearSalesHeader()
    begin
        Clear(recSalesHead);  // 26-11-20 ZY-LD 010
    end;


    procedure SetUpdateShipmentDate(pUpdateShipmentDate: Boolean)
    begin
        gUpdateShipmentDate := pUpdateShipmentDate;  // 30-12-20 ZY-LD 011
    end;


    procedure GetUpdateShipmentDate(): Boolean
    begin
        exit(gUpdateShipmentDate);  // 30-12-20 ZY-LD 011
    end;


    procedure SetValidateFromPage(NewValidateFromPage: Boolean)
    begin
        // On Transfer Order Subpage was "OnBeforeValidate" on the table running before "OnBeforeValidate" on the subpage. That is why this function is made.
        gValidateFromPage := NewValidateFromPage;  // 30-12-20 ZY-LD 011
    end;


    procedure GetValidateFromPage(): Boolean
    begin
        exit(gValidateFromPage);  // 30-12-20 ZY-LD 011
    end;


    procedure SetKeepLocationCode(pEnterSelectedFields: Boolean)
    begin
        gEnterSelectedFields := pEnterSelectedFields;
    end;


    procedure GetKeepLocationCode(): Boolean
    begin
        exit(gEnterSelectedFields);
    end;


    procedure SetSkipAddPostGrpPrLocation(pSkipAddPostGrpPrLocation: Boolean)
    begin
        gSkipAddPostGrpPrLocation := pSkipAddPostGrpPrLocation;
    end;


    procedure GetSkipAddPostGrpPrLocation(): Boolean
    begin
        exit(gSkipAddPostGrpPrLocation);
    end;


    procedure SetPurchPost(pPurchPost: Boolean)
    begin
        gPurchPost := pPurchPost;  // 11-02-22 ZY-LD 011
    end;


    procedure GetPurchPost(): Boolean
    begin
        exit(gPurchPost);  // 11-02-22 ZY-LD 011
    end;


    procedure SetChargeItemPost(pChargeItemPost: Boolean)
    begin
        gChargeItemPost := pChargeItemPost;  // 11-02-22 ZY-LD 011
    end;


    procedure GetChargeItemPost(): Boolean
    begin
        exit(gChargeItemPost);  // 11-02-22 ZY-LD 011
    end;


    procedure SetWebServiceUpdate(pWebServiceUpdate: Boolean)
    begin
        gWebServiceUpdate := pWebServiceUpdate;
    end;


    procedure GetWebServiceUpdate(): Boolean
    begin
        exit(gWebServiceUpdate);
    end;


    procedure SetExchangeRateService(pExchangeRateService: Boolean)
    var
        recCurrExchRate: Record "Currency Exchange Rate";
    begin
        //>> 01-07-22 ZY-LD 013
        gExchangeRateService := pExchangeRateService;

        if gExchangeRateService then begin
            recCurrExchRate.SetRange("Starting Date", Today);
            if recCurrExchRate.FindSet then
                repeat
                    recCurrExchRateTmp := recCurrExchRate;
                    if not recCurrExchRateTmp.Insert then;
                until recCurrExchRate.Next() = 0;
        end else begin
            recCurrExchRateTmp.Reset;
            recCurrExchRateTmp.DeleteAll;
        end;
        //<< 01-07-22 ZY-LD 013
    end;


    procedure GetExchangeRateService(): Boolean
    begin
        exit(gExchangeRateService);  // 01-07-22 ZY-LD 013
    end;


    procedure GetExchangeRateTmp(pCurrencyCode: Code[10]; var pCurrExchRateTmp: Record "Currency Exchange Rate" temporary) rValue: Boolean
    begin
        //>> 01-07-22 ZY-LD 013
        if recCurrExchRateTmp.Get(pCurrencyCode, Today) then begin
            pCurrExchRateTmp := recCurrExchRateTmp;
            rValue := true;
        end;
        //<< 01-07-22 ZY-LD 013
    end;


    procedure SetSkipErrorOnBlockOnOrder(pSkipBlockOnOrder: Boolean)
    begin
        gSkipBlockOnOrder := pSkipBlockOnOrder;
    end;


    procedure SkipErrorOnBlockOnOrder(): Boolean
    begin
        exit(gSkipBlockOnOrder);
    end;


    procedure SetSkipVerifyOnInventory(pSkipVerifyOnInventory: Boolean)
    begin
        gSkipVerifyOnInventory := pSkipVerifyOnInventory
    end;


    procedure GetSkipVerifyOnInventory(): Boolean
    begin
        exit(gSkipVerifyOnInventory)
    end;

    procedure SetRecordRef(var RefRec: RecordRef)
    begin
        GlobalRefRec := RefRec;
    end;

    procedure GetRecordRef(): RecordRef
    begin
        exit(GlobalRefRec)
    end;

    procedure SetUseBillToCustomer(NewUseBillToCustomer: Boolean)
    begin
        gUseBillToCustomer := NewUseBillToCustomer;
    end;

    procedure GetUseBillToCustomer(): Boolean
    begin
        exit(gUseBillToCustomer);
    end;

    procedure SetAllowChangeOfCustomerPostingGroup(NewAllowChangeOfCustomerPostingGroup: Boolean)
    begin
        gAllowChangeOfCustomerPostingGroup := NewAllowChangeOfCustomerPostingGroup;
    end;

    procedure GetAllowChangeOfCustomerPostingGroup(): Boolean
    begin
        Exit(gAllowChangeOfCustomerPostingGroup);
    end;

    procedure SetChechVATDate(NewCheckVATDate: Boolean)
    Begin
        gCheckVATDate := NewCheckVATDate;
    End;

    procedure GetCheckVATDate(): Boolean
    begin
        Exit(gCheckVATDate);
    end;

    procedure SetPostDamage(NewPostDamage: Boolean)
    Begin
        gPostDamage := NewPostDamage;
    End;

    procedure GetPostDamage(): Boolean
    Begin
        exit(gPostDamage);
    End;

    procedure SetDocumentCaptureRunning(NewDocumentCapture: Boolean)
    begin
        gDocumentCapture := NewDocumentCapture;
    end;

    procedure DocumentCaptureRunning(): Boolean
    begin
        exit(gDocumentCapture);
    end;

    procedure SetItemNo(pItemNo: Code[20])
    Begin
        gItemNo := pItemNo;
    End;

    procedure GetItemNo(): Code[20]
    begin
        exit(gItemNo);
    end;

    procedure SetCustomerNo(pCustNo: Code[20])
    Begin
        gCustomerNo := pCustNo;
    End;

    procedure GetCustomerNo(): Code[20]
    begin
        exit(gCustomerNo);
    end;

    procedure SetOutputType(pOutputType: Option Print,Preview,PDF,Email,Excel,Word,XML)
    begin
        gOutputType := pOutputType;
    end;

    procedure GetOutputType(): Option;
    begin
        exit(gOutputType);
    end;


    var
        GlobalRefRec: RecordRef;
        recUseOfRepTmp: Record "Use of Report Entry" temporary;
        recSalesHead: Record "Sales Header";
        recCurrExchRateTmp: Record "Currency Exchange Rate" temporary;
        gSalesInvoiceNo: Code[20];
        gDocumentNo: Code[20];
        gItemNo: Code[20];
        gCustomerNo: Code[20];
        gMergeFields: array[120] of Text[250];
        gOutputType: Option Print,Preview,PDF,Email,Excel,Word,XML;
        gMergeText: Text;
        gManualChange: Boolean;
        gAllowDeleteAddItem: Boolean;
        gRejectItemReplication: Boolean;
        gRejectChangeLog: Boolean;
        gDate: Date;
        gWarehouseManagement: Boolean;
        gHideSalesDialog: Boolean;
        gHideReportDialog: Boolean;
        gEmailSalesInvoice: Boolean;
        gEmailAddress: Text;
        gDeleteSalesOrder: Boolean;
        gPostedManually: Boolean;
        gAvoidSalesValidation: Boolean;
        gYesToAll: Boolean;
        gDontAskAgain: Boolean;
        gUpdateShipmentDate: Boolean;
        gValidateFromPage: Boolean;
        gEnterSelectedFields: Boolean;
        gSkipAddPostGrpPrLocation: Boolean;
        gItemChargeNo: Code[20];
        gEmailEntryNo: Integer;
        gPurchPost: Boolean;
        gPreventNegativeInventory: Boolean;
        gChargeItemPost: Boolean;
        gWebServiceUpdate: Boolean;
        gExchangeRateService: Boolean;
        gSkipBlockOnOrder: Boolean;
        gSkipVerifyOnInventory: Boolean;
        gUseBillToCustomer: Boolean;
        gAllowChangeOfCustomerPostingGroup: Boolean;
        gCheckVATDate: Boolean;
        gPostDamage: Boolean;
        gDocumentCapture: Boolean;
}
