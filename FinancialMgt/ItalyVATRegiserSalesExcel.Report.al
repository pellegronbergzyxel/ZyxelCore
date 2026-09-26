namespace ZyxelCore.ZyxelCore;

using Microsoft.Finance.VAT.Ledger;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Sales.History;
using Microsoft.Sales.Customer;
using System.IO;

report 50100 "Italy VAT Regiser Sales Excel"
{
    ApplicationArea = All;
    Caption = 'Italy VAT Regiser Sales Excel';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(EcomOrderArchive; "eCommerce Order Archive")
        {
            RequestFilterFields = "Posting Date";

            trigger OnPreDataItem()
            begin
                // Capture posting date filter before overriding to skip the main loop
                PostingDateFilter := GetFilter("Posting Date");
                SetRange("Posting Date", 0D, 0D);
            end;

            trigger OnPostDataItem()
            var
                Cnt1: Integer;
                Cnt2: Integer;
                Cnt3: Integer;
                Cnt4: Integer;
            begin
                BuildSheet('B2C Invoice', 0, 0, true);
                Cnt1 := CurrentSheetCount;
                BuildSheet('B2C Credit Memo', 1, 0, false);
                Cnt2 := CurrentSheetCount;
                BuildSheet('B2B Invoice', 0, 1, false);
                Cnt3 := CurrentSheetCount;
                BuildSheet('B2B Credit Memo', 1, 1, false);
                Cnt4 := CurrentSheetCount;

                if not HasData then begin
                    Message('No Italy VAT transactions found for the selected period.');
                    exit;
                end;

                TempExcelBuf.CloseBook();
                if GuiAllowed() then begin
                    TempExcelBuf.OpenExcel();
                    Message('Report finished.\B2C Invoice: %1 transactions\B2C Credit Memo: %2 transactions\B2B Invoice: %3 transactions\B2B Credit Memo: %4 transactions',
                        Cnt1, Cnt2, Cnt3, Cnt4);
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        TempExcelBuf: Record "Excel Buffer" temporary;
        PostingDateFilter: Text;
        HasData: Boolean;
        CurrentSheetCount: Integer;

    local procedure BuildSheet(SheetName: Text; TransType: Integer; SellToType: Integer; IsFirst: Boolean)
    var
        EcomArchive: Record "eCommerce Order Archive";
    begin
        CurrentSheetCount := 0;
        TempExcelBuf.DeleteAll(false);
        TempExcelBuf.ClearNewRow();

        WriteSheetHeader();

        EcomArchive.SetRange("Marketplace ID", 'IT');
        EcomArchive.SetRange("Ship-to Country", 'IT');
        //EcomArchive.SetRange("Transaction Type", TransType);
        if TransType = 0 then
            EcomArchive.SetRange("Sales Document Type", EcomArchive."Sales Document Type"::Invoice)
        else
            EcomArchive.SetRange("Sales Document Type", EcomArchive."Sales Document Type"::"Credit Memo");
        EcomArchive.SetRange("Sell-to Type",SellToType);
        if PostingDateFilter <> '' then
            EcomArchive.SetFilter("Posting Date", PostingDateFilter);

        if EcomArchive.FindSet() then
            repeat
                FillArchiveRows(EcomArchive);
            until EcomArchive.Next() = 0;

        if IsFirst then
            TempExcelBuf.CreateNewBook(SheetName)
        else
            TempExcelBuf.SelectOrAddSheet(SheetName);
        TempExcelBuf.WriteSheet(SheetName, CompanyName(), UserId());
    end;

    local procedure WriteSheetHeader()
    begin
        TempExcelBuf.NewRow();
        AddHdr('Posting Date');
        AddHdr('Document Date');
        AddHdr('Document Type');
        AddHdr('Document No.');
        AddHdr('Customer No.');
        AddHdr('Customer Name');
        AddHdr('VAT %');
        AddHdr('VAT Base');
        AddHdr('VAT Amount');
        AddHdr('Total Amount');
        AddHdr('VAT Reg. No.');
    end;

    local procedure AddHdr(HeaderText: Text)
    begin
        TempExcelBuf.AddColumn(HeaderText, false, '', true, false, false, '', 0);
    end;

    local procedure FillArchiveRows(var EcomArchive: Record "eCommerce Order Archive")
    var
        SalesInvHdr: Record "Sales Invoice Header";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        VATEntry: Record "VAT Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        Cust: Record Customer;
        DocumentNo: Code[20];
        DocumentDate: Date;
        DocTypeText: Text;
        CustName: Text[100];
        VATPercent: Decimal;
    begin
        if Cust.Get(EcomArchive."Customer No.") then
            CustName := Cust.Name;

        if EcomArchive."Transaction Type" = EcomArchive."Transaction Type"::Order then begin
            SalesInvHdr.SetRange("External Document No.", EcomArchive."eCommerce Order Id");
        //    SalesInvHdr.SetRange("External Invoice No.", EcomArchive."Invoice No.");
            if not SalesInvHdr.FindFirst() then
                exit;
            DocumentNo := SalesInvHdr."No.";
            DocumentDate := SalesInvHdr."Document Date";
            DocTypeText := 'Invoice';
            VATEntry.SetRange("Document Type", VATEntry."Document Type"::Invoice);
            VATEntry.SetRange("Posting Date", SalesInvHdr."Posting Date");
        end else begin
            SalesCrMemoHdr.SetRange("External Document No.", EcomArchive."eCommerce Order Id");
          //  SalesCrMemoHdr.SetRange("External Invoice No.", EcomArchive."Invoice No.");
            if not SalesCrMemoHdr.FindFirst() then
                exit;
            DocumentNo := SalesCrMemoHdr."No.";
            DocumentDate := SalesCrMemoHdr."Document Date";
            DocTypeText := 'Credit Memo';
            VATEntry.SetRange("Document Type", VATEntry."Document Type"::"Credit Memo");
            VATEntry.SetRange("Posting Date", SalesCrMemoHdr."Posting Date");
        end;

        VATEntry.SetRange(Type, VATEntry.Type::Sale);
        VATEntry.SetRange("Document No.", DocumentNo);
        if not VATEntry.FindSet() then
            exit;

        HasData := true;
        CurrentSheetCount += 1;
        repeat
            VATPercent := 0;
            if VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group") then
                VATPercent := VATPostingSetup."VAT %";

            TempExcelBuf.NewRow();
            TempExcelBuf.AddColumn(Format(EcomArchive."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'), false, '', false, false, false, '', 0);
            TempExcelBuf.AddColumn(Format(DocumentDate, 0, '<Day,2>/<Month,2>/<Year4>'), false, '', false, false, false, '', 0);
            TempExcelBuf.AddColumn(DocTypeText, false, '', false, false, false, '', 0);
            TempExcelBuf.AddColumn(DocumentNo, false, '', false, false, false, '', 0);
            TempExcelBuf.AddColumn(EcomArchive."Customer No.", false, '', false, false, false, '', 0);
            TempExcelBuf.AddColumn(CustName, false, '', false, false, false, '', 0);
            TempExcelBuf.AddColumn(VATPercent, false, '', false, false, false, '', 0);
            TempExcelBuf.AddColumn(VATEntry.Base, false, '', false, false, false, '###,##0.00', 0);
            TempExcelBuf.AddColumn(VATEntry.Amount, false, '', false, false, false, '###,##0.00', 0);
            TempExcelBuf.AddColumn(VATEntry.Base + VATEntry.Amount, false, '', false, false, false, '###,##0.00', 0);
            TempExcelBuf.AddColumn(EcomArchive."Purchaser VAT No.", false, '', false, false, false, '', 0);
        until VATEntry.Next() = 0;
    end;
}
