Report 50096 "VAT Report For BCIT"
{
    Caption = 'VAT Report For BCIT';
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;
    Extensible = true;

    RDLCLayout = './Layouts/VAT Report For BCIT.rdlc';
    //WordLayout = './Layouts/VAT Report For BCIT.docx';
    dataset
    {
        DataItem(VATEntry; "VAT Entry")
        {
            DataItemTableView = sorting("Posting Date");
            RequestFilterFields = "Posting Date", Type, "Country/Region Code", "EU Country/Region Code";

            column(PostingDate; "Posting Date")
            {

            }
            column(PostingDateLb; FieldCaption("Posting Date"))
            {

            }
            column(DocumentDate; "Document Date")
            {

            }
            column(DocumentDateLB; FieldCaption("Document Date"))
            {

            }
            column(DocumentType; "Document Type")
            {

            }
            column(DocumentTypeLB; FieldCaption("Document Type"))
            {

            }
            column(DocumentNo; "Document No.")
            {

            }
            column(DocumentNoLb; FieldCaption("Document No."))
            {

            }
            column(ExternalDocumentNo; "External Document No.")
            {

            }
            column(ExternalDocumentNoLb; FieldCaption("External Document No."))
            {

            }
            column(SourceName; SourceName)
            {

            }
            column(VATIdentifier; "VAT Prod. Posting Group")
            {

            }

            column(VATPercent; VATPercent)
            {

            }
            column(DeductibleBase; "Base")
            {

            }
            column(DeductibleAmount; "Amount")
            {

            }
            column(NonDeductibleBase; "Non-Deductible VAT Base")
            {

            }
            column(NonDeductibleAmount; vatentry."Non-Deductible VAT Amount")
            {

            }
            column(DocumentTotal; TotalAmount)
            {

            }
            column(VATRegistrationNo; "VAT Registration No.")
            {

            }
            column(CurrencyCode; "Source Currency Code")
            {

            }
            column(EntryNo; "Entry No.")
            {

            }
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(HomePage; CompanyInfo."Post Code")
                {
                }
                column(EMail; CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoName; CompanyInfo.Name)
                {
                }
                column(CompanyInfoAddress; CompanyInfo.Address)
                {
                }
                column(CompanyInfoAddress2; CompanyInfo."Address 2")
                {
                }
                column(CompanyInfoCity; CompanyInfo.City)
                {
                }
                column(DocumentCaptionCopyText; companyInfo."VAT Registration No.")
                {
                }
                column(ReporName; ReportName)
                {
                }
                column(VATPCTLabel; VATPCTLabel)
                {

                }
                column(ReportTypeFilter; ReportTypeFilter)
                {

                }
                column(CurrencycodeLabel; CurrencycodeLabel)
                {

                }
            }

            trigger OnPreDataItem()
            begin
                TotalBase := 0;
                TotalAmount := 0;
                VATEntry.SETRANGE("Country/Region Code", CountryCode);
                VATEntry.SETRANGE(Type, ReportType);
                if ReportType = ReportType::Purchase then
                    ReportTypeFilter := 'VAT Register Purchase Register'
                else
                    ReportTypeFilter := 'VAT Register Sales Register';

            end;

            trigger OnAfterGetRecord()
            begin
                TotalAmount := 0;
                IF "type" = type::Purchase THEN begin
                    if "Document Type" = "Document Type"::Invoice THEN begin
                        If VATEntry."Document No." <> '' THEN begin
                            PostedPurchaseInvoice.Get(VATEntry."Document No.");
                            Vendor.Get(PostedPurchaseInvoice."Buy-from Vendor No.");
                        end;
                    End ELSE IF "Document Type" = "Document Type"::"Credit Memo" THEN begin
                        If VATEntry."Document No." <> '' THEN begin
                            PostedPurchaseCreditMemo.Get(VATEntry."Document No.");
                            Vendor.Get(PostedPurchaseCreditMemo."Buy-from Vendor No.");
                        end;
                    End;
                    SourceName := Vendor."Name";
                End ELSE begin
                    if "Document Type" = "Document Type"::Invoice THEN begin
                        If VATEntry."Document No." <> '' THEN begin
                            PostedSalesInvoice.Get(VATEntry."Document No.");
                            customer.Get(PostedSalesInvoice."sell-to Customer No.");
                        end;
                    End ELSE IF "Document Type" = "Document Type"::"Credit Memo" THEN begin
                        If VATEntry."Document No." <> '' THEN begin
                            PostedSalesCreditMemo.Get(VATEntry."Document No.");
                            Customer.Get(PostedSalesCreditMemo."sell-to Customer No.");
                        end;
                    End;
                    SourceName := Customer."Name";
                End;

                If ("VAT Bus. Posting Group" <> '') and ("VAT Prod. Posting Group" <> '') then begin
                    VatPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                    VATPercent := VatPostingSetup."VAT %"
                end;

                TotalAmount := Base + Amount;
                UpdateGrandTotal(VATEntry);

                if Exceloptions then
                    MakeExcelLine();
            end;

            trigger OnPostDataItem()
            begin
                TempPostBuffer.Reset();
                if TempPostBuffer.FindSet() then
                    repeat
                        PostBuffer := TempPostBuffer;
                        PostBuffer.Insert();
                    until TempPostBuffer.Next() = 0;

            end;

        }
        dataitem(PostBuffer; "Invoice Posting Buffer")
        {
            column(GroupID; PostBuffer."Group ID")
            {
                caption = 'Group ID';
            }
            column("VatBusGroup"; PostBuffer."VAT Bus. Posting Group")
            {

            }
            column("VatProdGroup"; PostBuffer."VAT Prod. Posting Group")
            {

            }
            column("VatBaseBeforePmtDisc"; PostBuffer."VAT Base Before Pmt. Disc.")
            {

            }
            column("VatAmount"; PostBuffer."VAT Amount")
            {

            }
            column("NonDeductibleVatBase"; PostBuffer."Non-Deductible VAT Base")
            {

            }
            column("NonDeductibleVatAmount"; PostBuffer."Non-Deductible VAT Amount")
            {

            }
            trigger OnPreDataItem()
            begin
                PostBuffer.SETCURRENTKEY("Group ID");
                PostBuffer.SETFILTER("Group ID", '<>%1', '');
            end;

            trigger OnAfterGetRecord()
            begin
                //if PostBuffer.next() <> 0 then;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CountryCode; CountryCode)
                    {
                        Caption = 'Country Code';

                    }
                    field(ReportType; ReportType)
                    {
                        Caption = 'Report Type';

                    }
                    field(Exceloptions; Exceloptions)
                    {
                        Caption = 'Create Excel File';
                    }
                }
                group(Group)
                {
                    Caption = 'Filters';
                    field("Posting Date"; VATEntry."Posting Date")
                    {
                        Caption = 'Posting Date';
                    }
                    field("VAT Identifier"; VATEntry."VAT Prod. Posting Group")
                    {
                        Caption = 'VAT Identifier';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            CountryCode := CountryLabel;
            CompanyInfo.Get();
            ReportName := 'VAT Report For BCIT';
        end;
    }

    trigger OnPreReport()
    begin
        IF Exceloptions then
            MakeExcelHead();

        Clear(TempPostBuffer);
    end;

    trigger OnPostReport()
    begin
        IF NOT Exceloptions then
            exit;

        MakeTotalExcelLine();
        CreateExcelbook();
    end;

    procedure MakeExcelHead()
    begin
        TempExcelbuf.AddColumn('VAT Report For BCIT', false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.NewRow();
        TempExcelbuf.AddColumn(DateFilterLabel + ': ' + VATEntry.GetFilter("Posting Date"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.NewRow();
        TempExcelbuf.AddColumn(CountryLabel + ': ' + CountryCode, false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.NewRow();
        TempExcelbuf.AddColumn(ReportTypeLabel + ': ' + Format(ReportType), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.NewRow();
        TempExcelBuf.NewRow();
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("Posting Date"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("Document Date"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("Document No."), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("Document Type"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("Document No."), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("External Document No."), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(sourceNameLabel, false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATPCTLabel, false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption(Base), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption(Amount), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("Non-Deductible VAT Base"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("Non-Deductible VAT Amount"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("VAT Prod. Posting Group"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("VAT Bus. Posting Group"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(TotalAmountLabel, false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("VAT Registration No."), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry.FieldCaption("Source Currency Code"), false, '', true, false, false, '', TempExcelBuf."cell type"::Text);

        TempExcelBuf.NewRow();
    end;


    procedure MakeExcelLine()
    begin
        TempExcelBuf.AddColumn(VATEntry."Posting Date", false, '', false, false, false, '', TempExcelBuf."cell type"::Date);
        TempExcelBuf.AddColumn(VATEntry."Document Date", false, '', false, false, false, '', TempExcelBuf."cell type"::Date);
        TempExcelBuf.AddColumn(VATEntry."Document No.", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry."Document Type", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        tempExcelBuf.AddColumn(VATEntry."Document No.", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry."External Document No.", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(SourceName, false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATPercent, false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(VATEntry.Base, false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(VATEntry.Amount, false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(VATEntry."Non-Deductible VAT Base", false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(VATEntry."Non-Deductible VAT Amount", false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(VATEntry."VAT Bus. Posting Group", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry."VAT Prod. Posting Group", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        tempExcelBuf.AddColumn(TotalAmount, false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
        TempExcelBuf.AddColumn(VATEntry."VAT Registration No.", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.AddColumn(VATEntry."Source Currency Code", false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.NewRow();
    end;


    procedure MakeTotalExcelLine()
    begin
        TempExcelBuf.NewRow();
        TempExcelbuf.AddColumn('Total pr. Groups', false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
        TempExcelBuf.NewRow();
        TempPostBuffer.SetRange("VAT Bus. Posting Group");
        TempPostBuffer.SetRange("VAT Prod. Posting Group");
        IF TempPostBuffer.FindSet() then
            repeat
                TempExcelBuf.AddColumn(TempPostBuffer."VAT Bus. Posting Group", false, '', true, false, false, '', TempExcelBuf."cell type"::Date);
                TempExcelBuf.AddColumn(TempPostBuffer."VAT Prod. Posting Group", false, '', true, false, false, '', TempExcelBuf."cell type"::Text);
                TempExcelBuf.AddColumn('', false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
                tempExcelBuf.AddColumn('', false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
                TempExcelBuf.AddColumn('', false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
                TempExcelBuf.AddColumn('', false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
                TempExcelBuf.AddColumn('', false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
                TempExcelBuf.AddColumn(TempPostBuffer."VAT Base Before Pmt. Disc.", false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
                TempExcelBuf.AddColumn(TempPostBuffer."VAT Amount", false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
                TempExcelBuf.AddColumn(TempPostBuffer."Non-Deductible VAT Base", false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
                TempExcelBuf.AddColumn(TempPostBuffer."Non-Deductible VAT Amount", false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
                TempExcelBuf.AddColumn('', false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
                TempExcelBuf.AddColumn('', false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
                tempExcelBuf.AddColumn(TempPostBuffer."VAT Base Before Pmt. Disc." + TempPostBuffer."VAT Amount", false, '', false, false, false, '#,##0.00', TempExcelBuf."cell type"::Number);
                TempExcelBuf.AddColumn('', false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
                TempExcelBuf.AddColumn('', false, '', false, false, false, '', TempExcelBuf."cell type"::Text);
                TempExcelBuf.NewRow();
            until TempPostBuffer.Next() = 0;
    end;

    procedure CreateExcelbook()
    begin
        TempExcelBuf.CreateBook('', Text002);
        TempExcelBuf.WriteSheet(Text002, CompanyName(), UserId());
        TempExcelBuf.CloseBook();
        if GuiAllowed() then begin
            TempExcelBuf.OpenExcel();
            Error('');
        end;
    end;

    procedure UpdateGrandTotal(VATEntry: Record "VAT Entry")
    begin

        TempPostBuffer.setrange("VAT Bus. Posting Group", VATEntry."VAT Bus. Posting Group");
        TempPostBuffer.setrange("VAT Prod. Posting Group", VATEntry."VAT Prod. Posting Group");
        if TempPostBuffer.findfirst then begin
            TempPostBuffer."VAT Base Before Pmt. Disc." += VATEntry.Base;
            TempPostBuffer."VAT Amount" += VATEntry.Amount;
            TempPostBuffer."Non-Deductible VAT Base" += VATEntry."Non-Deductible VAT Base";
            TempPostBuffer."Non-Deductible VAT Amount" += VATEntry."Non-Deductible VAT Amount";
            TempPostBuffer.Modify();
        end else begin
            TempPostBuffer.init();
            TempPostBuffer."Group ID" := VATEntry."VAT Bus. Posting Group" + VATEntry."VAT Prod. Posting Group";
            TempPostBuffer."VAT Bus. Posting Group" := VATEntry."VAT Bus. Posting Group";
            TempPostBuffer."VAT Prod. Posting Group" := VATEntry."VAT Prod. Posting Group";
            TempPostBuffer."VAT Base Before Pmt. Disc." := VATEntry.Base;
            TempPostBuffer."VAT Amount" := VATEntry.Amount;
            TempPostBuffer."Non-Deductible VAT Base" := VATEntry."Non-Deductible VAT Base";
            TempPostBuffer."Non-Deductible VAT Amount" := VATEntry."Non-Deductible VAT Amount";
            TempPostBuffer.insert();
        end;
    end;

    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        PostedPurchaseInvoice: Record "Purch. Inv. Header";
        PostedPurchaseCreditMemo: Record "Purch. Cr. Memo Hdr.";
        PostedSalesInvoice: Record "Sales Invoice Header";
        PostedSalesCreditMemo: Record "Sales Cr.Memo Header";
        VatPostingSetup: Record "VAT Posting Setup";
        TempExcelbuf: Record "Excel Buffer" temporary;
        TempPostBuffer: Record "Invoice Posting Buffer" temporary;
        CompanyInfo: Record "Company Information";


        VATPercent: Decimal;
        CountryCode: Code[10];
        SourceName: Text[100];
        ReportName: text[100];
        ReportTypeFilter: text[100];
        TotalBase: Decimal;
        TotalAmount: Decimal;

        ReportType: Enum "General Posting Type";
        Exceloptions: Boolean;
        CountryLabel: Label 'IT';
        sourceNameLabel: Label 'Source Name';
        VATPCTLabel: Label 'VAT %';
        TotalAmountLabel: Label 'Total Amount';
        TotalbaseLabel: Label 'Total Base';
        Text002: Label 'VAT Entries';
        ReportTypeLabel: Label 'Report Type';
        DateFilterLabel: Label 'Datefilter';
        CurrencycodeLabel: Label 'Cur.';




}