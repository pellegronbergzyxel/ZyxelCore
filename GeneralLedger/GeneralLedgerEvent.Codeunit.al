codeunit 50085 "General Ledger Event"
{
    // 001. 01-08-18 ZY-LD 000 - Created.
    // 002. 15-08-18 ZY-LD 000 - RHQ G/L Account No. must be filled in Turkey.
    // 003. 24-09-18 ZY-LD 000 - If sales price is modified we want the sales price to be replicated again.
    // 004. 30-10-18 ZY-LD 2018102910000171 - Set "Global Dimension No." on "Dimension Value".
    // 005. 13-11-19 ZY-LD 000 - Update RHQ Name.
    // 006. 05-08-20 ZY-LD P0456 - Update Travel Expense.
    // 007. 12-08-20 ZY-LD P0454 - Reset replication when modified.
    // 008. 17-11-20 ZY-LD P0524 - OnBeforeCheckGenJnlLine.
    // 009. 02-12-20 ZY-LD 2020113010000072 - Find Customer and Vendor Name for VAT Entries.
    // 010. 17-08-21 ZY-LD 000 - If it´s eCommerce, then we have to use the "Ship-to Country/Region Code" to get the correct value on "Value Entry".
    // 011. 04-11-21 ZY-LD 000 - New fields.
    // 012. 03-01-24 ZY-LD 012 - Location Code is added to VAT Entries. Ref.: Vojtech.
    // 013. 11-03-24 ZY-LD 000 - Ship-to Code moved to sale
    // 014. 11-03-24 ZY-LD 000 - Set mapping of dimensions.
    // 015. 18-03-24 ZY-LD 000 - We have setup a separate validation of the VAT posting date, in order to be able to post VAT back in time.
    // 016. 09-04-24 ZY-LD 000 - Ship-to Address was not correct updated. It is now.
    // 017. 15-04-24 ZY-LD 000 - Standard compare against "Country / Region Code", but we have our warehouse located in Holland.
    // 018. 06-05-24 ZY-LD 000 - Select e-mail address for reminders.
    // 019. 29-05-24 ZY-LD 000 - If the "Bill-to Country" and the "Ship-to Country" are the same, the VAT registration No. must be the subsidary "VAT Reg. No.", otherwise it must be the "Ship-to VAT Reg. No.".

    Permissions = tabledata "General Ledger Setup" = r;

    var
        ServEnviron: Record "Server Environment";

    [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnAfterValidateEvent', 'Name', false, false)]
    local procedure OnAfterValidateNameGlAccount(var Rec: Record "G/L Account"; var xRec: Record "G/L Account"; CurrFieldNo: Integer)
    var
        recGlAcc: Record "G/L Account";
    begin
        begin
            //>> 13-11-19 ZY-LD 005
            if Rec.Name <> xRec.Name then begin
                if Rec."No." = Rec."RHQ G/L Account No." then
                    Rec."RHQ G/L Account Name" := Rec.Name;

                recGlAcc.SetRange("RHQ G/L Account No.", Rec."No.");
                recGlAcc.SetFilter("No.", '<>%1', Rec."No.");
                if recGlAcc.FindSet(true) then
                    repeat
                        recGlAcc."RHQ G/L Account Name" := Rec.Name;
                        recGlAcc.Modify();
                    until recGlAcc.Next() = 0;
            end;
            //<< 13-11-19 ZY-LD 005
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertGLEntry(var Rec: Record "G/L Entry"; RunTrigger: Boolean)
    var
        recGLAcc: Record "G/L Account";
        lText001: Label '"%1" must not be blank on "%2" "%3".';
    begin
        //>> 15-08-18 ZY-LD 002
        if ServEnviron.TurkishServer then begin
            recGLAcc.Get(Rec."G/L Account No.");
            if recGLAcc."RHQ G/L Account No." = '' then
                Error(lText001, recGLAcc.FieldCaption("RHQ G/L Account No."), Rec.FieldCaption(Rec."G/L Account No."), Rec."G/L Account No.");
        end;
        //<< 15-08-18 ZY-LD 002
    end;

    [EventSubscriber(ObjectType::Table, Database::"Dimension Value", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertDimensionValue(var Rec: Record "Dimension Value"; RunTrigger: Boolean)
    var
        IcDimValue: Record "IC Dimension Value";
        IcDim: Record "IC Dimension";
    begin
        //>> 30-10-18 ZY-LD 004
        begin
            //>> 11-03-24 ZY-LD 014
            Rec.Validate("Map-to IC Dimension Code", Rec."Dimension Code");
            Rec."Map-to IC Dimension Value Code" := Rec.Code;
            //<< 11-03-24 ZY-LD 014
            Rec."Global Dimension No." := GetGlobalDimensionNo(Rec);
            Rec.Modify();

            //>> 11-03-24 ZY-LD 014
            if IcDim.get(Rec."Dimension Code") then
                if not IcDimValue.get(Rec."Dimension Code", Rec.Code) then begin
                    IcDimValue.Init();
                    IcDimValue.Validate("Dimension Code", Rec."Dimension Code");
                    IcDimValue.Validate(Code, Rec.Code);
                    IcDimValue.Validate(Name, Rec.Name);
                    IcDimValue.Validate("Map-to Dimension Code", Rec."Dimension Code");
                    IcDimValue."Map-to Dimension Value Code" := Rec.Code;
                    IcDimValue.Insert(true);
                end;
            //<< 11-03-24 ZY-LD 014
        end;
        //<< 30-10-18 ZY-LD 004
    end;

    [EventSubscriber(ObjectType::Table, Database::"Dimension Value", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyDimensionValue(var Rec: Record "Dimension Value"; var xRec: Record "Dimension Value"; RunTrigger: Boolean)
    begin
        //>> 30-10-18 ZY-LD 004
        if RunTrigger then begin
            Rec."Global Dimension No." := GetGlobalDimensionNo(Rec);
            Rec.Modify();
        end;
        //<< 30-10-18 ZY-LD 004
    end;

    [EventSubscriber(ObjectType::Table, Database::"General Ledger Setup", 'OnAfterValidateEvent', 'Allow Posting From', false, false)]
    local procedure OnAfterValidateAllowPostingFrom(var Rec: Record "General Ledger Setup"; var xRec: Record "General Ledger Setup"; CurrFieldNo: Integer)
    begin
        UpdateUserSetup(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"General Ledger Setup", 'OnAfterValidateEvent', 'Allow Posting To', false, false)]
    local procedure OnAfterValidateAllowPostingTo(var Rec: Record "General Ledger Setup"; var xRec: Record "General Ledger Setup"; CurrFieldNo: Integer)
    begin
        UpdateUserSetup(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"General Ledger Setup", 'OnBeforeFirstAllowedPostingDate', '', false, false)]
    local procedure GeneralLedgerSetup_OnBeforeFirstAllowedPostingDate(GeneralLedgerSetup: Record "General Ledger Setup"; var AllowedPostingDate: Date; var IsHandled: Boolean)
    var
        InvtPeriod: Record "Inventory Period";
        UserSetup: Record "User Setup";
    begin
        AllowedPostingDate := GeneralLedgerSetup."Allow Posting From";
        if UserSetup.Get(UserId()) and (UserSetup."Allow Posting From" <> 0D) then
            AllowedPostingDate := UserSetup."Allow Posting From";
        if not InvtPeriod.IsValidDate(AllowedPostingDate) then
            AllowedPostingDate := CalcDate('<+1D>', AllowedPostingDate);

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Finance Charge Memo Header", 'OnBeforeInsertFinChrgMemoLine', '', false, false)]
    local procedure FinanceChargeMemoHeader_OnBeforeInsertFinChrgMemoLine(var FinChrgMemoLine: Record "Finance Charge Memo Line")
    begin
        FinChrgMemoLine.Description := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Issued Fin. Charge Memo Header", 'OnBeforePrintRecords', '', false, false)]
    local procedure IssuedFinChargeMemoHeader_OnBeforePrintRecords(var IssuedFinChargeMemoHeader: Record "Issued Fin. Charge Memo Header"; ShowRequestForm: Boolean; SendAsEmail: Boolean; HideDialog: Boolean; var IsHandled: Boolean)
    var
        DummyReportSelections: Record "Report Selections";
        DocumentSendingProfile: Record "Document Sending Profile";
        ReportDistributionMgt: Codeunit "Report Distribution Management";
    begin
        if SendAsEmail and IssuedFinChargeMemoHeader.SendAsEmailCustomer(IssuedFinChargeMemoHeader."Customer No.") then
            DocumentSendingProfile.TrySendToEMail(
              DummyReportSelections.Usage::"Fin.Charge".AsInteger(), IssuedFinChargeMemoHeader, IssuedFinChargeMemoHeader.FieldNo("No."),
              ReportDistributionMgt.GetFullDocumentTypeText(IssuedFinChargeMemoHeader), IssuedFinChargeMemoHeader.FieldNo("Customer No."), not HideDialog)
        else
            DocumentSendingProfile.TrySendToPrinter(
              DummyReportSelections.Usage::"Fin.Charge".AsInteger(), IssuedFinChargeMemoHeader, IssuedFinChargeMemoHeader.FieldNo("Customer No."), ShowRequestForm);

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reminder Header", 'OnInsertLinesOnBeforeReminderLineInsert', '', false, false)]
    local procedure ReminderHeader_OnInsertLinesOnBeforeReminderLineInsert(var ReminderHeader: Record "Reminder Header"; var ReminderLine: Record "Reminder Line")
    begin
        ReminderLine.Description := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Issued Reminder Header", 'OnBeforePrintRecords', '', false, false)]
    local procedure OnBeforePrintRecords(var IssuedReminderHeader: Record "Issued Reminder Header"; ShowRequestForm: Boolean; SendAsEmail: Boolean; HideDialog: Boolean; var IsHandled: Boolean)
    var
        Cust: Record Customer;

    // DocumentSendingProfile: Record "Document Sending Profile";
    // DummyReportSelections: Record "Report Selections";
    // IssuedReminderHeaderCopy: Record "Issued Reminder Header";
    // IssuedReminderHeaderToSend: Record "Issued Reminder Header";
    // ReportDistributionMgt: Codeunit "Report Distribution Management";
    // SuppresSendDialogQst: Label 'Do you want to suppress send dialog?';
    begin

        //>> 03-08-18 CD-LD 001
        if Cust.Get(IssuedReminderHeader."Customer No.") and (not Cust."E-Mail Reminder") then begin
            IsHandled := true;
        end;
        //<< 03-08-18 CD-LD 001

        /*if SendAsEmail and IssuedReminderHeader.SendAsEmailCustomer(IssuedReminderHeader."Customer No.") then begin
            IssuedReminderHeaderCopy.Copy(IssuedReminderHeader);
            if (not HideDialog) and (IssuedReminderHeaderCopy.Count() > 1) then
                if Confirm(SuppresSendDialogQst) then
                    HideDialog := true;
            if IssuedReminderHeaderCopy.FindSet() then
                repeat
                    IssuedReminderHeaderToSend.Copy(IssuedReminderHeaderCopy);
                    IssuedReminderHeaderToSend.SetRecFilter();
                    DocumentSendingProfile.TrySendToEMail(
                      DummyReportSelections.Usage::Reminder.AsInteger(), IssuedReminderHeaderToSend, IssuedReminderHeaderToSend.FieldNo("No."),
                      ReportDistributionMgt.GetFullDocumentTypeText(IssuedReminderHeader), IssuedReminderHeaderToSend.FieldNo("Customer No."), not HideDialog)
                until IssuedReminderHeaderCopy.Next() = 0;
        end else
            DocumentSendingProfile.TrySendToPrinter(
              DummyReportSelections.Usage::Reminder.AsInteger(), IssuedReminderHeader,
              IssuedReminderHeaderToSend.FieldNo("Customer No."), ShowRequestForm);

        IsHandled := true;*/
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", 'OnBeforeGetEmailAddress', '', false, false)]
    local procedure OnBeforeGetEmailAddress(ReportUsage: Option; RecordVariant: Variant; var TempBodyReportSelections: Record "Report Selections" temporary; var EmailAddress: Text[250]; var IsHandled: Boolean; CustNo: Code[20])
    var
        CustomRepSelec: Record "Custom Report Selection";
    begin
        //>> 06-05-24 ZY-LD 018
        // I can not find anywhere the e-mail address is selected from custom report selection on reminders.
        CustomRepSelec.SetRange("Source Type", Database::Customer);
        CustomRepSelec.SetRange("Source No.", CustNo);
        CustomRepSelec.SetRange(Usage, ReportUsage);
        IsHandled := CustomRepSelec.FindFirst();
        EmailAddress := CustomRepSelec."Send To Email";
        //<< 06-05-24 ZY-LD 018
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", 'OnBeforeGetEmailBodyCustomer', '', false, false)]
    local procedure OnBeforeGetEmailBodyCustomer(ReportUsage: Integer; RecordVariant: Variant; var TempBodyReportSelections: Record "Report Selections" temporary; CustNo: Code[20]; var CustEmailAddress: Text[250]; var EmailBodyText: Text; var IsHandled: Boolean; var Result: Boolean)
    var
        EmailAdd: Record "E-mail address";
        EmailAddMgt: Codeunit "E-mail Address Management";
    begin
        /*if ReportUsage = 15 then begin
            EmailAdd.SetRange("Document Usage", EmailAdd."Document Usage"::Reminder);
            if EmailAdd.FindFirst() then
                EmailBodyText := EmailAddMgt.GetBody(EmailAdd.Code, '', CustNo, EmailAdd."Html Formatted");
        end;
        Result := EmailBodyText <> '';
        IsHandled := Result;*/
    end;

    local procedure UpdateUserSetup(var Rec: Record "General Ledger Setup")
    var
        recUserSetup: Record "User Setup";
        recUserSetup2: Record "User Setup";
        lText001: Label 'Do you want to update:\"%1" to "%2" and\"%3" to "%4" on\all users in table"%5"?';
        lText002: Label 'Users are updated.';
    begin
        if Confirm(lText001, false, Rec.FieldCaption(Rec."Allow Posting From"), Rec."Allow Posting From", Rec.FieldCaption(Rec."Allow Posting To"), Rec."Allow Posting To", recUserSetup.TableCaption()) then begin
            recUserSetup.SetFilter("Allow Posting From", '<>%1', 0D);
            recUserSetup.SetFilter("Allow Posting To", '<>%1', 0D);
            if recUserSetup.FindSet() then
                repeat
                    recUserSetup2.Get(recUserSetup."User ID");
                    recUserSetup2."Allow Posting From" := Rec."Allow Posting From";
                    recUserSetup2."Allow Posting To" := Rec."Allow Posting To";
                    recUserSetup2.Validate("Allow Posting From");
                    recUserSetup2.Validate("Allow Posting To");
                    recUserSetup2.Modify();
                until recUserSetup.Next() = 0;
            Message(lText002);
        end;
    end;

    procedure GetGlobalDimensionNo(Rec: Record "Dimension Value"): Integer
    var
        recGlSetup: Record "General Ledger Setup";
    begin
        //>> 30-10-18 ZY-LD 004
        begin
            recGlSetup.Get();
            //>> 20-08-23 ZY-LD 012
            if recGlSetup."Shortcut Dimension 1 Code" = Rec."Dimension Code" then
                exit(1);
            if recGlSetup."Shortcut Dimension 2 Code" = Rec."Dimension Code" then
                exit(2);
            //<< 20-08-23 ZY-LD 012
            if recGlSetup."Shortcut Dimension 3 Code" = Rec."Dimension Code" then
                exit(3);
            if recGlSetup."Shortcut Dimension 4 Code" = Rec."Dimension Code" then
                exit(4);
            if recGlSetup."Shortcut Dimension 5 Code" = Rec."Dimension Code" then
                exit(5);
            if recGlSetup."Shortcut Dimension 6 Code" = Rec."Dimension Code" then
                exit(6);
            if recGlSetup."Shortcut Dimension 7 Code" = Rec."Dimension Code" then
                exit(7);
            if recGlSetup."Shortcut Dimension 8 Code" = Rec."Dimension Code" then
                exit(8);
        end;
        //<< 30-10-18 ZY-LD 004
    end;

    local procedure ">> Post"()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeRunCheck', '', false, false)]
    local procedure OnBeforeCheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        lText001: Label 'If one of the four posting groups are filled, then "Gen. Posting Type" must also be filled. Account No. %9.\\%1: %2\%3: %4\%5: %6\%7: %8.';
    begin
        //>> 17-11-20 ZY-LD 008
        if GenJournalLine."Account No." <> '' then
            case GenJournalLine."Account Type" of
                GenJournalLine."account type"::"G/L Account":
                    begin
                        if ((GenJournalLine."Gen. Bus. Posting Group" <> '') or (GenJournalLine."Gen. Prod. Posting Group" <> '') or
                             (GenJournalLine."VAT Bus. Posting Group" <> '') or (GenJournalLine."VAT Prod. Posting Group" <> '')) and
                           (GenJournalLine."Gen. Posting Type" = GenJournalLine."gen. posting type"::" ")
                        then
                            Error(
                              lText001,
                              GenJournalLine.FieldCaption(GenJournalLine."Gen. Bus. Posting Group"), GenJournalLine."Gen. Bus. Posting Group",
                              GenJournalLine.FieldCaption(GenJournalLine."Gen. Prod. Posting Group"), GenJournalLine."Gen. Prod. Posting Group",
                              GenJournalLine.FieldCaption(GenJournalLine."VAT Bus. Posting Group"), GenJournalLine."VAT Bus. Posting Group",
                              GenJournalLine.FieldCaption(GenJournalLine."VAT Prod. Posting Group"), GenJournalLine."VAT Prod. Posting Group",
                              GenJournalLine."Account No.");
                    end;
            end;
        //<< 17-11-20 ZY-LD 008
    end;

    // Event OnBeforeCheckVATDate does not exist in Italy. Event has been moved to MTD in order to run it in EMEA.
    /*[EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeCheckVATDate', '', false, false)]
    local procedure OnBeforeCheckVATDate()
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetChechVATDate(true);  // 18-03-24 ZY-LD 015
    end;*/

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnAfterDateNoAllowed', '', false, false)]
    local procedure OnAfterDateNoAllowed(PostingDate: Date; var DateIsNotAllowed: Boolean)
    var
        SI: Codeunit "Single Instance";
    begin
        //>> 18-03-24 ZY-LD 015
        if SI.GetCheckVATDate then begin
            DateIsNotAllowed := not IsVatPostingDateValidWithSetup(PostingDate);
            SI.SetChechVATDate(false);
        end;
        //<< 18-03-24 ZY-LD 015
    end;


    local procedure ">> Page"()
    begin
    end;

    [EventSubscriber(Objecttype::Page, 39, 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeleteRecordPage39(var Rec: Record "Gen. Journal Line"; var AllowDelete: Boolean)
    var
        recTrvlExpHead: Record "Travel Expense Header";
        recGenJnl: Record "Gen. Journal Line";
    begin
        begin
            //>> 05-08-20 ZY-LD 006
            // If we delete the last journal line, we have to re-open the travel expense.
            if (Rec."Journal Template Name" = 'GENERAL') and (Rec."Journal Batch Name" = 'TRAVELEXP') then begin
                recGenJnl.SetRange("Journal Template Name", Rec."Journal Template Name");
                recGenJnl.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                recGenJnl.SetRange("Document No.", Rec."Document No.");
                recGenJnl.SetFilter("Line No.", '<>%1', Rec."Line No.");
                if not recGenJnl.FindFirst() then begin
                    recTrvlExpHead.SetRange("G/L Document No.", Rec."Document No.");
                    if recTrvlExpHead.FindFirst() then begin
                        recTrvlExpHead."G/L Document No." := '';
                        recTrvlExpHead."G/L Posting Date" := 0D;
                        recTrvlExpHead."Document Status" := recTrvlExpHead."document status"::Open;
                        recTrvlExpHead.Modify();
                    end;
                end;
            end;
            //<< 05-08-20 ZY-LD 006
        end;
    end;

    local procedure ">> VAT"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEvent_VATEntry(var Rec: Record "VAT Entry"; RunTrigger: Boolean)
    var
        recSalesInvHead: Record "Sales Invoice Header";
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
        recPurchInvHead: Record "Purch. Inv. Header";
        recPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        recEcomHead: Record "eCommerce Order Header";
        recEcomArch: Record "eCommerce Order Archive";
        recLocation: Record Location;
        Cust: Record Customer;
        Vend: Record Vendor;
    begin
        with Rec do begin
            "Company Country/Region Code" := "Country/Region Code";
            "VAT Registration No. ZX" := "VAT Registration No.";
            "VAT Registration No. VIES" := "VAT Registration No.";  // 29-05-24 ZY-LD 019

            case Type of
                Type::Purchase:
                    begin
                        if Vend.Get("Bill-to/Pay-to No.") then begin
                            "Bill-to/Pay-to Name" := vend.Name;
                            "Bill-to/Pay-to Post Code" := vend."Post Code";
                        end;

                        case "Document Type" of
                            "document type"::Invoice:
                                if recPurchInvHead.Get("Document No.") then begin
                                    "Ship-to Name" := recPurchInvHead."Ship-to Name";
                                    "Vendor Document No." := recPurchInvHead."Vendor Invoice No.";  // 04-11-21 ZY-LD 011
                                    "Location Code" := recPurchInvHead."Location Code";  // 03-01-24 ZY-LD 012
                                end;
                            "document type"::"Credit Memo":
                                if recPurchCrMemoHdr.Get("Document No.") then begin
                                    "Ship-to Name" := recPurchCrMemoHdr."Ship-to Name";
                                    "Vendor Document No." := recPurchCrMemoHdr."Vendor Cr. Memo No.";  // 04-11-21 ZY-LD 011
                                    "Location Code" := recPurchcrmemohdr."Location Code";  // 03-01-24 ZY-LD 012
                                end;
                        end;
                    end;
                Type::Sale:
                    begin
                        if Cust.Get("Bill-to/Pay-to No.") then begin
                            "Bill-to/Pay-to Name" := cust.Name;
                            "Bill-to/Pay-to Post Code" := cust."Post Code";
                        end;

                        case "Document Type" of
                            "document type"::Invoice:
                                if recSalesInvHead.Get(Rec."Document No.") then begin
                                    "Company Country/Region Code" := recSalesInvHead."Ship-to Country/Region Code";
                                    "Company VAT Registration No." := recSalesInvHead."Company VAT Registration Code";
                                    "Ship-to Name" := recSalesInvHead."Ship-to Name";
                                    "Location Code" := recsalesInvHead."Location Code";  // 03-01-24 ZY-LD 012
                                    if recSalesInvHead."Ship-to VAT" <> '' then
                                        "VAT Registration No. ZX" := recSalesInvHead."Ship-to VAT"
                                    else
                                        "VAT Registration No. ZX" := recSalesInvHead."VAT Registration No.";
                                    //>> 29-05-24 ZY-LD 019
                                    If (recSalesInvHead."Bill-to Country/Region Code" <> recSalesInvHead."Ship-to Country/Region Code") and
                                       (recSalesInvHead."Ship-to VAT" <> '')
                                     then
                                        "VAT Registration No. VIES" := recSalesInvHead."Ship-to VAT"
                                    else
                                        "VAT Registration No. VIES" := recSalesInvHead."VAT Registration No.";
                                    //>> 29-05-24 ZY-LD 019

                                    if recEcomHead.get(recEcomHead."Transaction Type"::Order, recSalesInvHead."External Document No.", recSalesInvHead."External Invoice No.") then begin
                                        "Ship-from Country/Region Code" := recEcomHead."Ship From Country";
                                        "eCommerce Customer Type" := recEcomHead."Sell-to Type" + 1;
                                    end else
                                        if recEcomarch.get(recEcomHead."Transaction Type"::Order, recSalesInvHead."External Document No.", recSalesInvHead."External Invoice No.") then begin
                                            "Ship-from Country/Region Code" := recEcomArch."Ship-From Country";
                                            "eCommerce Customer Type" := recEcomArch."Sell-to Type" + 1;
                                        end else
                                            if recLocation.get(recSalesinvHead."Location Code") then begin
                                                recLocation.TestField("Country/Region Code");
                                                "Ship-from Country/Region Code" := recLocation."Country/Region Code";
                                            end;
                                end;
                            "document type"::"Credit Memo":
                                if recSalesCrMemoHead.Get(Rec."Document No.") then begin
                                    "Company Country/Region Code" := recsalescrmemohead."sell-to Country/Region Code";
                                    "Company VAT Registration No." := recSalesCrMemoHead."Company VAT Registration Code";
                                    "Ship-to Name" := recSalesCrMemoHead."Ship-to Name";
                                    "Location Code" := recSalesCrMemoHead."Location Code";  // 03-01-24 ZY-LD 012
                                    if recSalesCrMemoHead."Ship-to VAT" <> '' then
                                        "VAT Registration No. ZX" := recSalesCrMemoHead."Ship-to VAT"
                                    else
                                        "VAT Registration No. ZX" := recSalesCrMemoHead."VAT Registration No.";

                                    //>> 29-05-24 ZY-LD 019
                                    If (recSalesCrMemoHead."Bill-to Country/Region Code" <> recSalesCrMemoHead."Rcvd.-from Count./Region Code") and
                                       (recSalesCrMemoHead."Rcvd.-from Count./Region Code" <> '') and
                                       (recSalesCrMemoHead."Ship-to VAT" <> '')
                                     then
                                        "VAT Registration No. VIES" := recSalesCrMemoHead."Ship-to VAT"
                                    else
                                        "VAT Registration No. VIES" := recSalesCrMemoHead."VAT Registration No.";
                                    //>> 29-05-24 ZY-LD 019

                                    if recEcomHead.get(recEcomHead."Transaction Type"::Refund, recSalescrmemoHead."External Document No.", recSalescrmemoHead."External Invoice No.") then begin
                                        "Ship-from Country/Region Code" := recEcomHead."Ship From Country";
                                        "eCommerce Customer Type" := recEcomHead."Sell-to Type" + 1;
                                    end else
                                        if recEcomarch.get(recEcomHead."Transaction Type"::Refund, recSalescrmemoHead."External Document No.", recSalescrmemoHead."External Invoice No.") then begin
                                            "Ship-from Country/Region Code" := recEcomArch."Ship-From Country";
                                            "eCommerce Customer Type" := recEcomArch."Sell-to Type" + 1;
                                        end else
                                            if recLocation.get(recSalesCrMemoHead."Location Code") then begin
                                                recLocation.TestField("Country/Region Code");
                                                "Ship-from Country/Region Code" := recLocation."Country/Region Code";
                                            end;
                                end
                        end;
                    end;
            end;
        end;
    end;

    local procedure ">> Posted Documents"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeletePostedSalesInvoice(var Rec: Record "Sales Invoice Header"; RunTrigger: Boolean)
    begin
        ErrorOnDeletePostedDocument;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeletePostedSalesCreditMemo(var Rec: Record "Sales Cr.Memo Header"; RunTrigger: Boolean)
    begin
        ErrorOnDeletePostedDocument;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeletePostedPurchaseInvoice(var Rec: Record "Purch. Inv. Header"; RunTrigger: Boolean)
    begin
        ErrorOnDeletePostedDocument;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Cr. Memo Hdr.", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeletePostedPurchaseCreditMemo(var Rec: Record "Purch. Cr. Memo Hdr."; RunTrigger: Boolean)
    begin
        ErrorOnDeletePostedDocument;
    end;

    [EventSubscriber(ObjectType::Page, Page::"IC Chart of Accounts", 'OnCopyFromChartOfAccountsOnBeforeICGLAccInsert', '', false, false)]
    local procedure ICChartofAccounts_OnCopyFromChartOfAccountsOnBeforeICGLAccInsert(var ICGLAccount: Record "IC G/L Account")
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        //Remember to change in CopyFromChartOfAccounts on XmlPort 50037 "WS Replicate G/L Account" if new changes are made
        //>> 04-09-18 ZY-LD 001
        if ZGT.IsRhq then
            ICGLAccount."Map-to G/L Acc. No." := ICGLAccount."No.";
        //<< 04-09-18 ZY-LD 001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Deferral Utilities", 'OnBeforeUpdateDeferralLineDescription', '', false, false)]
    local procedure DeferralUtilities_OnBeforeUpdateDeferralLineDescription(var DeferralLine: Record "Deferral Line"; DeferralHeader: Record "Deferral Header"; DeferralTemplate: Record "Deferral Template"; PostDate: Date; var IsHandled: Boolean)
    var
        DefUtil: Codeunit "Deferral Utilities";
    begin
        //>> 28-01-20 ZY-LD 001
        case DeferralTemplate."Deferral Line Description" of
            DeferralTemplate."Deferral Line Description"::"Template Period Description":
                DeferralLine.Description := DefUtil.CreateRecurringDescription(PostDate, DeferralTemplate."Period Description");
            DeferralTemplate."Deferral Line Description"::"Header Schedule Description":
                DeferralLine.Description := DefUtil.CreateRecurringDescription(PostDate, DeferralHeader."Schedule Description");
        end;
        //<< 28-01-20 ZY-LD 001

    end;

    local procedure ErrorOnDeletePostedDocument()
    var
        ZGT: Codeunit "ZyXEL General Tools";
        lText001: Label 'It is not allowed to delete posted documents.';
        lText002: Label 'Are you absolutely sure that you want to delete the document.';
    begin
        if not ZGT.UserIsDeveloper() then begin
            Error(lText001)
        end else
            if not Confirm(lText002) then
                Error('');
    end;


    local procedure IsVatPostingDateValidWithSetup(PostingDate: Date) Result: Boolean
    var
        GlSetup: Record "General Ledger Setup";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
    begin
        //>> 18-03-24 ZY-LD 015
        GLSetup.Get;
        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            AllowPostingFrom := GLSetup."Allow VAT Posting From";
            AllowPostingTo := GLSetup."Allow VAT Posting To";
        end;
        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            AllowPostingFrom := GLSetup."Allow Posting From";
            AllowPostingTo := GLSetup."Allow Posting To";
        end;
        if AllowPostingTo = 0D then
            AllowPostingTo := DMY2Date(31, 12, 9999);
        exit(PostingDate in [AllowPostingFrom .. AllowPostingTo]);
        //<< 18-03-24 ZY-LD 015
    end;
}
