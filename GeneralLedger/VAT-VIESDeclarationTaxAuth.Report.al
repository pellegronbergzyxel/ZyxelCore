report 50012 "VAT- VIES Decl. Tax Auth ZX"
{
    // 001. 17-10-23 ZY-LD 000 - There can be multible company VAT registration numbers.

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FinancialMgt/VAT/VATVIESDeclarationTaxAuth.rdlc';
    ApplicationArea = VAT;
    Caption = 'VAT- VIES Declaration Tax Auth';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) ORDER(Ascending) where(Number = filter(1 ..));
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(PeriodDate; Format(EndDate, 0, 6))
            {
            }
            //>> 17-10-23 ZY-LD 001
            //column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
            //{
            //}
            column(CompanyInfoVATRegNo; CompVATRegistrationNoFilter)
            {
            }
            //<< 17-10-23 ZY-LD 001
            column(CompanyAddr6; CompanyAddr[6])
            {
            }
            column(CompanyAddr7; CompanyAddr[7])
            {
            }
            column(CompanyAddr8; CompanyAddr[8])
            {
            }
            column(CountryRegionCode; VATEntriesBaseAmtSum.EU_Country_Region_Code)
            {
            }
            column(VATRegNo; VATEntriesBaseAmtSum.VAT_Registration_No)
            {
            }
            column(TotalValueofItemSupplies; -TotalValueofItemSupplies)
            {
            }
            column(EU3PartyItemTradeAmt; -EU3PartyItemTradeAmt)
            {
                AutoFormatType = 1;
            }
            column(CountryBlank; CountryBlank)
            {
            }
            column(ShowError; ShowError)
            {
            }
            column(CountryCode; VATEntriesBaseAmtSum.Country_Region_Code)
            {
            }
            column(BilltoPaytoNo; VATEntriesBaseAmtSum.Bill_to_Pay_to_No)
            {
            }
            column(TotalValueofServiceSupplies; -TotalValueofServiceSupplies)
            {
            }
            column(EU3PartyServiceTradeAmt; -EU3PartyServiceTradeAmt)
            {
                AutoFormatType = 1;
            }
            column(ErrorText; ErrorText)
            {
            }
            column(HeaderText; HeaderText)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TotalValueofServiceSupplies := 0;
                TotalValueofItemSupplies := 0;
                EU3PartyItemTradeAmt := 0;
                EU3PartyServiceTradeAmt := 0;
                with VATEntriesBaseAmtSum do begin
                    if not Read() then
                        CurrReport.Break();

                    if EU_Service then begin
                        if UseAmtsInAddCurr then
                            TotalValueofServiceSupplies := Sum_Additional_Currency_Base
                        else
                            TotalValueofServiceSupplies := Sum_Base
                    end else
                        if UseAmtsInAddCurr then
                            TotalValueofItemSupplies := Sum_Additional_Currency_Base
                        else
                            TotalValueofItemSupplies := Sum_Base;

                    if EU_3_Party_Trade then begin
                        EU3PartyItemTradeAmt := TotalValueofItemSupplies;
                        EU3PartyServiceTradeAmt := TotalValueofServiceSupplies;
                    end;

                    CountryBlank := true;
                    if not ((Sum_Base <> 0) or (Sum_Additional_Currency_Base <> 0)) and
                       (Bill_to_Pay_to_No <> '') and (EU_Country_Region_Code <> '')
                    then
                        CountryBlank := false;

                    //>> 17-01-23 ZY-LD 001
                    //if Country_Region_Code = CompanyInfo."Country/Region Code" then
                    //                        CurrReport.Skip();
                    if Country_Region_Code = ShipFrom_Country_Region_Code then
                        CurrReport.Skip();
                    //<< 17-01-23 ZY-LD 001

                    ShowError := false;
                    ErrorText := '';
                    if VAT_Registration_No = '' then begin
                        ShowError := true;
                        ErrorText := StrSubstNo(Text001, Bill_to_Pay_to_No);
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if (StartDate = 0D) or (EndDate = 0D) then
                    Error(Text002);
                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                CompanyInfo.TestField("VAT Registration No.");

                VATEntriesBaseAmtSum.SetFilter(VAT_Registration_No, VATRegistrationNoFilter);
                VATEntriesBaseAmtSum.SetFilter(VAT_Date, '%1..%2', StartDate, EndDate);

                //RD 1.0
                VATEntriesBaseAmtSum.SetFilter(VAT_Bus_Posting_Group, VATBusPostingGroup);
                VATEntriesBaseAmtSum.SetFilter(VAT_Prod_Posting_Group, VATProdPostingGroup);
                //RD1.0
                VATEntriesBaseAmtSum.SetFilter(Company_VAT_Registration_No, CompVATRegistrationNoFilter);  // 17-10-23 ZY-LD 001
                VATEntriesBaseAmtSum.Open();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowAmountsInAddReportingCurrency; UseAmtsInAddCurr)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Amounts in Add. Reporting Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if the reported amounts are shown in the additional reporting currency.';
                    }
                    field(StartingDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start date';
                        ToolTip = 'Specifies the start date for the report.';
                    }
                    field(EndingDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End date';
                        ToolTip = 'Specifies the end date for the report.';
                    }
                    field(VATRegistrationNoFilter; VATRegistrationNoFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'VAT Registration No. Filter';
                        ToolTip = 'Specifies a VAT registration number, in order to limit the report to one or more customers or vendors.';
                    }
                    field(CompVATRegistrationNoFilter; CompVATRegistrationNoFilter)
                    {
                        //>> 17-10-23 ZY-LD 001
                        ApplicationArea = Basic, Suite;
                        Caption = 'VAT Registration No. - Zyxel Filter';
                        ToolTip = 'Specifies a Zyxel VAT registration number, in order to limit the report to one VAT registration number.';
                        //<< 17-10-23 ZY-LD 001
                    }
                    field(VATBusPostingGroupFilter; VATBusPostingGroup)
                    {
                        Caption = 'VAT Bus. Posting Group';
                    }
                    field(VATProdPostingGroupFilter; VATProdPostingGroup)
                    {
                        Caption = 'VAT Prod. Posting Group';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        CUSTOMSCaption = 'CUSTOMS', Comment = 'Uppercase of the translation customers';
        VIES_DECLARATIONCaption = 'VIES DECLARATION';
        TAXCaption = 'TAX';
        Country_Region_Codes_Caption = 'Country/Region Codes:';
        Name_and_Address_Caption = 'Name and Address';
        BECaption = 'BE';
        BelgiumCaption = 'Belgium';
        DECaption = 'DE';
        GermanyCaption = 'Germany';
        ELCaption = 'EL';
        GreeceCaption = 'Greece';
        ESCaption = 'ES';
        SpainCaption = 'Spain';
        FRCaption = 'FR';
        FranceCaption = 'France';
        GBCaption = 'UK';
        EnglandCaption = 'United Kingdom';
        IECaption = 'IE';
        IrelandCaption = 'Ireland';
        PeriodCaption = 'Period';
        ITCaption = 'IT';
        ItalyCaption = 'Italy';
        LUCaption = 'LU';
        LuxembourgCaption = 'Luxembourg';
        Seller_s_VAT_Registration_No_Caption = 'Seller''s VAT Registration No.';
        NLCaption = 'NL';
        NetherlandsCaption = 'Netherlands';
        PTCaption = 'PT';
        PortugalCaption = 'Portugal';
        Total_Sales_to_EUCaption = 'Total Sales to EU in the Period (in thousands)';
        DKCaption = 'DK';
        DenmarkCaption = 'Denmark';
        SECaption = 'SE';
        ATCaption = 'AT';
        FICaption = 'FI';
        SwedenCaption = 'Sweden';
        FinlandCaption = 'Finland';
        AustriaCaption = 'Austria';
        CYCaption = 'CY';
        EECaption = 'EE';
        HUCaption = 'HU';
        CyprusCaption = 'Cyprus';
        CzechRepublicCaption = 'Czech Republic';
        HungaryCaption = 'Hungary';
        EstoniaCaption = 'Estonia';
        LTCaption = 'LT';
        LithuaniaCaption = 'Lithuania';
        LVCaption = 'LV';
        LatviaCaption = 'Latvia';
        MTCaption = 'MT';
        MaltaCaption = 'Malta';
        PLCaption = 'PL';
        PolandCaption = 'Poland';
        ROCaption = 'RO';
        RomaniaCaption = 'Romania';
        SKCaption = 'SK';
        SlovakRepublicCaption = 'Slovakia';
        SLCaption = 'SL';
        SloveniaCaption = 'Slovenia';
        BGCaption = 'BG';
        BulgariaCaption = 'Bulgaria';
        CZCaption = 'CZ';
        CountryRegionCodeCaption = 'Customer Country/Region Code';
        Customers_VAT_Registration_No_Caption = 'Customer VAT Registration No.';
        TotalValueofItemSuppliesCaption = 'Total Value of Item Supplies';
        CodeCaption = 'Code';
        EU3PartyItemTradeAmtCaption = 'EU 3-Party Item Trade Amount';
        TotalValueOfServiceSuppliesCaption = 'Total Value of Service Supplies';
        EU3PartyServiceTradeAmtCaption = 'EU 3-Party Service Trade Amount';
        V0Caption = '0', Locked = true;
        ErrorTextCaption = 'Warning!';
        DateCaption = 'Date';
        SignatureCaption = 'Signature';
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        //>> 17-10-23 ZY-LD 001
        CompanyInfo.get;
        if CompVATRegistrationNoFilter = '' then
            CompVATRegistrationNoFilter := CompanyInfo."VAT Registration No.";
        //<< 17-10-23 ZY-LD 001
    end;

    trigger OnPreReport()
    begin
        if UseAmtsInAddCurr then
            HeaderText := StrSubstNo(Text000, GLSetup."Additional Reporting Currency")
        else begin
            GLSetup.TestField("LCY Code");
            HeaderText := StrSubstNo(Text000, GLSetup."LCY Code");
        end;

        //>> 17-10-23 ZY-LD 001
        CompanyInfo.get;
        if CompVATRegistrationNoFilter = '' then
            Error(Text003);
        //<< 17-10-23 ZY-LD 001
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        VATEntriesBaseAmtSum: Query "VAT Entries Base Amt. Sum ZX";
        CompanyAddr: array[8] of Text[100];
        StartDate: Date;
        EndDate: Date;
        EU3PartyItemTradeAmt: Decimal;
        EU3PartyServiceTradeAmt: Decimal;
        ErrorText: Text[250];
        UseAmtsInAddCurr: Boolean;
        TotalValueofServiceSupplies: Decimal;
        TotalValueofItemSupplies: Decimal;
        HeaderText: Text[50];
        CountryBlank: Boolean;
        ShowError: Boolean;
        Text000: Label 'All amounts are in %1.';
        Text001: Label 'The VAT Registration No. is not filled in for all VAT entries where for Customer %1 on one or more entries.';
        Text002: Label 'Start and end date must be filled in.';
        Text003: Label 'VAT Registration No. - Zyxel Filter must be filled in order to filter the report into one VAT registration no.';  // 17-10-23 ZY-LD 001
        VATRegistrationNoFilter: Text[250];
        CompVATRegistrationNoFilter: Text[250];  // 17-10-23 ZY-LD 001

    procedure InitializeRequest(NewUseAmtsInAddCurr: Boolean; NewStartDate: Date; NedEndDate: Date; SetVATRegistrationNoFilter: Text[250])
    begin
        UseAmtsInAddCurr := NewUseAmtsInAddCurr;
        StartDate := NewStartDate;
        EndDate := NedEndDate;
        VATRegistrationNoFilter := SetVATRegistrationNoFilter;
    end;


    var
        VATBusPostingGroup: Text;
        VATProdPostingGroup: Text;
}
