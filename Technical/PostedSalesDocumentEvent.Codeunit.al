codeunit 50059 "Posted Sales Document Event"
{
    #region Sales Invoice
    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Inv. - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure PostedSalesInvUpdate_OnAfterRecordChanged(var SalesInvoiceHeader: Record "Sales Invoice Header"; xSalesInvoiceHeader: Record "Sales Invoice Header"; var IsChanged: Boolean)
    begin
        if Not IsChanged then //06-01-2026 BK #From Harry change posted invoice 
            IsChanged :=
                (SalesInvoiceHeader."Bill-to Name" <> xSalesInvoiceHeader."Bill-to Name") or
                (SalesInvoiceHeader."Bill-to Name 2" <> xSalesInvoiceHeader."Bill-to Name 2") or
                (SalesInvoiceHeader."Bill-to Address" <> xSalesInvoiceHeader."Bill-to Address") or
                (SalesInvoiceHeader."Bill-to Address 2" <> xSalesInvoiceHeader."Bill-to Address 2") or
                (SalesInvoiceHeader."Bill-to Post Code" <> xSalesInvoiceHeader."Bill-to Post Code") or
                (SalesInvoiceHeader."Bill-to City" <> xSalesInvoiceHeader."Bill-to City") or
                (SalesInvoiceHeader."Bill-to County" <> xSalesInvoiceHeader."Bill-to County") or
                (SalesInvoiceHeader."Bill-to Country/Region Code" <> xSalesInvoiceHeader."Bill-to Country/Region Code") or
                (SalesInvoiceHeader."NL to DK Rev. Charge Posted" <> xSalesInvoiceHeader."NL to DK Rev. Charge Posted") or
                (SalesInvoiceHeader."NL to DK Reverse Chg. Doc No." <> xSalesInvoiceHeader."NL to DK Reverse Chg. Doc No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", 'OnRunOnBeforeAssignValues', '', false, false)]
    local procedure SalesInvHeaderEdit_OnRunOnBeforeAssignValues(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceHeaderRec: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader."Bill-to Name" := SalesInvoiceHeaderRec."Bill-to Name";
        SalesInvoiceHeader."Bill-to Name 2" := SalesInvoiceHeaderRec."Bill-to Name 2";
        SalesInvoiceHeader."Bill-to Address" := SalesInvoiceHeaderRec."Bill-to Address";
        SalesInvoiceHeader."Bill-to Address 2" := SalesInvoiceHeaderRec."Bill-to Address 2";
        SalesInvoiceHeader."Bill-to Post Code" := SalesInvoiceHeaderRec."Bill-to Post Code";
        SalesInvoiceHeader."Bill-to City" := SalesInvoiceHeaderRec."Bill-to City";
        SalesInvoiceHeader."Bill-to County" := SalesInvoiceHeaderRec."Bill-to County";
        SalesInvoiceHeader."Bill-to Country/Region Code" := SalesInvoiceHeaderRec."Bill-to Country/Region Code";
        SalesInvoiceHeader."NL to DK Rev. Charge Posted" := SalesInvoiceHeaderRec."NL to DK Rev. Charge Posted";
        SalesInvoiceHeader."NL to DK Reverse Chg. Doc No." := SalesInvoiceHeaderRec."NL to DK Reverse Chg. Doc No.";
    end;
    #endregion

    #region Sales Credit Memo
    [EventSubscriber(ObjectType::Page, Page::"Pstd. Sales Cr. Memo - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure PstdSalesCrMemoUpdate_OnAfterRecordChanged(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; xSalesCrMemoHeader: Record "Sales Cr.Memo Header"; var IsChanged: Boolean)
    begin
        IsChanged :=
            (SalesCrMemoHeader."Document Date" <> xSalesCrMemoHeader."Document Date") or
            (SalesCrMemoHeader."Payment Method Code" <> xSalesCrMemoHeader."Payment Method Code") or
            (SalesCrMemoHeader."Bill-to Name" <> xSalesCrMemoHeader."Bill-to Name") or
            (SalesCrMemoHeader."Bill-to Name 2" <> xSalesCrMemoHeader."Bill-to Name 2") or
            (SalesCrMemoHeader."Bill-to Address" <> xSalesCrMemoHeader."Bill-to Address") or
            (SalesCrMemoHeader."Bill-to Address 2" <> xSalesCrMemoHeader."Bill-to Address 2") or
            (SalesCrMemoHeader."Bill-to Post Code" <> xSalesCrMemoHeader."Bill-to Post Code") or
            (SalesCrMemoHeader."Bill-to City" <> xSalesCrMemoHeader."Bill-to City") or
            (SalesCrMemoHeader."Bill-to County" <> xSalesCrMemoHeader."Bill-to County") or
            (SalesCrMemoHeader."Bill-to Country/Region Code" <> xSalesCrMemoHeader."Bill-to Country/Region Code") or
            (SalesCrMemoHeader."NL to DK Rev. Charge Posted" <> xSalesCrMemoHeader."NL to DK Rev. Charge Posted") or
            (SalesCrMemoHeader."NL to DK Reverse Chg. Doc No." <> xSalesCrMemoHeader."NL to DK Reverse Chg. Doc No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Credit Memo Hdr. - Edit", 'OnBeforeSalesCrMemoHeaderModify', '', false, false)]
    local procedure SalesCreditMemoHdrEdit_OnBeforeSalesCrMemoHeaderModify(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; FromSalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        SalesCrMemoHeader."Document Date" := FromSalesCrMemoHeader."Document Date";
        SalesCrMemoHeader."Payment Method Code" := FromSalesCrMemoHeader."Payment Method Code";
        SalesCrMemoHeader."Bill-to Name" := FromSalesCrMemoHeader."Bill-to Name";
        SalesCrMemoHeader."Bill-to Name 2" := FromSalesCrMemoHeader."Bill-to Name 2";
        SalesCrMemoHeader."Bill-to Address" := FromSalesCrMemoHeader."Bill-to Address";
        SalesCrMemoHeader."Bill-to Address 2" := FromSalesCrMemoHeader."Bill-to Address 2";
        SalesCrMemoHeader."Bill-to Post Code" := FromSalesCrMemoHeader."Bill-to Post Code";
        SalesCrMemoHeader."Bill-to City" := FromSalesCrMemoHeader."Bill-to City";
        SalesCrMemoHeader."Bill-to County" := FromSalesCrMemoHeader."Bill-to County";
        SalesCrMemoHeader."Bill-to Country/Region Code" := FromSalesCrMemoHeader."Bill-to Country/Region Code";
        SalesCrMemoHeader."NL to DK Rev. Charge Posted" := FromSalesCrMemoHeader."NL to DK Rev. Charge Posted";
        SalesCrMemoHeader."NL to DK Reverse Chg. Doc No." := FromSalesCrMemoHeader."NL to DK Reverse Chg. Doc No.";
    end;
    #endregion
}
