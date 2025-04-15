codeunit 50029 CommonSubscribers
{
    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
    local procedure Navigate_OnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; var NewSourceRecVar: Variant; ExtDocNo: Code[250]; HideDialog: Boolean)
    var
        TravelExpHeader: Record "Travel Expense Header";
    begin
        if TravelExpHeader.ReadPermission() then begin
            TravelExpHeader.SetCurrentKey("G/L Document No.", "G/L Posting Date");
            TravelExpHeader.SetFilter("G/L Document No.", DocNoFilter);
            TravelExpHeader.SetFilter("G/L Posting Date", PostingDateFilter);
            if TravelExpHeader.Count() > 0 then begin
                DocumentEntry.Init();
                DocumentEntry."Entry No." := DocumentEntry."Entry No." + 1;
                DocumentEntry."Table ID" := Database::"Travel Expense Header";
                DocumentEntry."Document Type" := "Document Entry Document Type"::" ";
                DocumentEntry."Table Name" := CopyStr(TravelExpHeader.TableCaption(), 1, MaxStrLen(DocumentEntry."Table Name"));
                DocumentEntry."No. of Records" := TravelExpHeader.Count();
                DocumentEntry.Insert();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateShowRecords', '', false, false)]
    local procedure Navigate_OnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; var TempDocumentEntry: Record "Document Entry" temporary; SalesInvoiceHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; PurchInvHeader: Record "Purch. Inv. Header"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; ServiceInvoiceHeader: Record "Service Invoice Header"; ServiceCrMemoHeader: Record "Service Cr.Memo Header"; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250]; ExtDocNo: Code[250])
    var
        TravelExpHeader: Record "Travel Expense Header";
    begin
        if TableID = Database::"Travel Expense Header" then begin
            TravelExpHeader.SetCurrentKey("G/L Document No.", "G/L Posting Date");
            TravelExpHeader.SetFilter("G/L Document No.", DocNoFilter);
            TravelExpHeader.SetFilter("G/L Posting Date", PostingDateFilter);
            Page.Run(Page::"Travel Expense", TravelExpHeader);
        end;
    end;


    // 491247 >>
    [EventSubscriber(ObjectType::Table, Database::"Report Selections", 'OnBeforeGetEmailBodyCustomer', '', false, false)]
    local procedure OnBeforeGetEmailBodyCustomer(ReportUsage: Integer; RecordVariant: Variant; var TempBodyReportSelections: Record "Report Selections" temporary; CustNo: Code[20]; var CustEmailAddress: Text[250]; var EmailBodyText: Text; var IsHandled: Boolean; var Result: Boolean)
    var
        SalesHeader: Record "Sales Header";
        recref: RecordRef;
        CustReptMgt: Codeunit "Custom Report Management";
        CustomReportSelection: Record "Custom Report Selection";
        temptext: text[250];
    begin
        if RecordVariant.IsRecord then begin
            recref.GetTable(RecordVariant);
            Case recref.Number of

                36:
                    begin
                        SalesHeader := RecordVariant;
                        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                            temptext := CustReptMgt.GetEmailAddress(Database::Customer, SalesHeader."Sell-to Customer No.", CustomReportSelection.Usage::"S.Order", temptext);
                            if temptext <> '' then
                                CustEmailAddress := temptext;
                        end
                    end;
            end;

        end

    end;
    // 491247 <<

}
