query 50019 "VAT Entries Base Amt. Sum ZX"
{
    // 001. 17-10-23 ZY-LD 000 - Zyxel´s VAT Registration No. can be different from the one in company info. Zyxel has it´s own country/region code on the entry.
    // 002. 29-05-24 ZY-LD 000 - We can´t use the default VAT Registration No. to show the VIES report. We have created our own field. See GeneralLedgerEvent how it´s filled.

    Caption = 'VAT Entries Base Amt. Sum';
    OrderBy = Ascending(Country_Region_Code), Ascending(VAT_Registration_No);

    elements
    {
        dataitem(VAT_Entry; "VAT Entry")
        {
            DataItemTableFilter = Type = const(Sale);
            filter(Posting_Date; "Posting Date")
            {
            }
            filter(VAT_Date; "VAT Reporting Date")
            {
            }
            filter(Document_Date; "Document Date")
            {
            }
            column(Company_VAT_Registration_No; "Company VAT Registration No.")  // 17-10-23 ZY-LD 001
            {
            }
            //column(VAT_Registration_No; "VAT Registration No.")  // 29-05-24 ZY-LD 002
            column(VAT_Registration_No; "VAT Registration No. VIES")  // 29-05-24 ZY-LD 002
            {
            }
            column(EU_3_Party_Trade; "EU 3-Party Trade")
            {
            }
            column(EU_Service; "EU Service")
            {
            }
            column(Country_Region_Code; "Company Country/Region Code")  // 17-10-23 ZY-LD 001
            {
            }
            column(Sum_Base; Base)
            {
                Method = Sum;
            }
            column(Sum_Additional_Currency_Base; "Additional-Currency Base")
            {
                Method = Sum;
            }
            column(Bill_to_Pay_to_No; "Bill-to/Pay-to No.")
            {
            }
            column(VAT_Bus_Posting_Group; "VAT Bus. Posting Group")
            {
            }
            column(VAT_Prod_Posting_Group; "VAT Prod. Posting Group")
            {
            }
            column(ShipFrom_Country_Region_Code; "Ship-from Country/Region Code")  // 17-10-23 ZY-LD 001
            {
            }
            dataitem(Country_Region; "Country/Region")
            {
                //DataItemLink = Code = VAT_Entry."Country/Region Code";  // 17-10-23 ZY-LD 001
                DataItemLink = Code = VAT_Entry."company Country/Region Code";  // 17-10-23 ZY-LD 001
                column(EU_Country_Region_Code; "EU Country/Region Code")
                {
                    ColumnFilter = EU_Country_Region_Code = filter(<> '');
                }
            }
        }
    }
}
