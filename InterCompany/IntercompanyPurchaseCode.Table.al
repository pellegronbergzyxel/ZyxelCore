Table 50040 "Intercompany Purchase Code"
{
    // 001.  NIQ0.99  20-06-2009  SHE  [3100]
    //                                 .Object created

    Caption = 'Intercompany Purchase';
    LookupPageID = "Intercompany Purchase";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; "Read Comp. Info from Company"; Text[30])
        {
            Caption = 'Read Comp. Info from Company';
            TableRelation = Company;
        }
        field(3; "Calc. Local VAT for Currency"; Code[10])
        {
            Caption = 'Calc. Local VAT for Currency';
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        rCurrency: Record Currency;
        rVendor: Record Vendor;
}
