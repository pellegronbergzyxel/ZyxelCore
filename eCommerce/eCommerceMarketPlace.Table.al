table 50104 "eCommerce Market Place"
{

    Caption = 'eCommerce Market Place';

    fields
    {
        field(1; "Marketplace ID"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(2; "eCommerce Web Site"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(3; "Customer No."; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Customer;
        }
        field(4; "Posting Company"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Company;
        }
        field(5; Active; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(6; "Sales Person Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(7; "Shipment Method"; Code[10])
        {
            Caption = 'Shipping Method Code / Incoterms';
            Description = 'PAB 1.0';
            TableRelation = "Shipment Method".Code;
        }
        field(8; "Shipping Agent Code"; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = "Shipping Agent".Code;
        }
        field(9; "Transport Method"; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = "Transport Method".Code;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            Description = '10-04-19 ZY-LD 003';
        }
        field(11; "Main Market Place ID"; Code[10])
        {
            Caption = 'Main Market Place ID';
            Description = '20-06-19 ZY-LD 004';
            TableRelation = "eCommerce Market Place";
        }
        field(19; "Currency Code"; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = Currency.Code;
        }
        field(20; "Location Code"; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = Location.Code;
        }
        field(21; "Return Reason Code for Cr. Mem"; Code[10])
        {
            Caption = 'Return Reason Code for Cr. Memo';
            Description = 'LD1.0';
            TableRelation = "Return Reason";
        }
        field(22; "Export Outside EU"; Boolean)
        {
            Caption = 'Export Outside EU';
            Description = '19-12-17 ZY-LD 001';
        }
        field(23; "Export Outside Country Code"; Code[20])
        {
            Caption = 'Export Outside Country Code';
            Description = '19-12-17 ZY-LD 001';
            TableRelation = "Country/Region";
            ValidateTableRelation = false;
        }
        field(25; "IC Partner Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "IC Partner".Code;
        }
        field(26; Country; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = "Country/Region".Code;
        }
        field(27; "Distributor Name"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(28; "Vendor No."; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Vendor;
        }
        field(40; "VAT Prod. Posting Group"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "VAT Product Posting Group";
        }
        field(41; "Discount Amount"; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(42; "Fee Account No."; Code[20])
        {
            Caption = 'Fee G/L Account No.';
            Description = 'PAB 1.0';
            TableRelation = "G/L Account";
        }
        field(43; "Charge Account No."; Code[20])
        {
            Caption = 'Charge G/L Account No.';
            Description = 'PAB 1.0';
            TableRelation = "G/L Account";
        }
        field(44; "Cash Recipt G/L Batch"; Code[20])
        {
            Caption = 'Cash Recipt G/L Batch';
            Description = 'PAB 1.0';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Cach Recipt G/L Template"));
        }
        field(45; "Cach Recipt G/L Template"; Code[20])
        {
            Caption = 'Cach Recipt G/L Template';
            Description = 'PAB 1.0';
            TableRelation = "Gen. Journal Template".Name;
        }
        field(46; "Cash Recipt Description"; Text[20])
        {
            Caption = 'Cash Recipt Description';
            Description = 'PAB 1.0';
        }
        field(47; "Periodic Account No."; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Customer."No.";
        }
        field(48; "Periodic Posting Description"; Text[20])
        {
            Description = 'PAB 1.0';
        }
        field(49; "Cash Recipt Number Series"; Code[20])
        {
            Caption = 'Cash Recipt Number Series';
            Description = 'PAB 1.0';
            TableRelation = "No. Series".Code;
        }
        field(50; "Payment G/L Batch"; Code[20])
        {
            Caption = 'Payment G/L Batch';
            Description = 'PAB 1.0';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payment G/L Template"));
        }
        field(51; "Payment G/L Template"; Code[20])
        {
            Caption = 'Payment G/L Template';
            Description = 'PAB 1.0';
            TableRelation = "Gen. Journal Template".Name;
        }
        field(52; "Payment Number Series"; Code[20])
        {
            Caption = 'Payment Number Series';
            Description = 'PAB 1.0';
            TableRelation = "No. Series".Code;
        }
        field(53; "VAT Bus Posting Group (EU)"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(54; "VAT Bus Posting Group (No VAT)"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(55; "VAT Bus Post. Grp. (Ship-From)"; Code[20])
        {
            CalcFormula = lookup(Customer."VAT Bus. Posting Group" where("No." = field("Customer No.")));
            Caption = 'VAT Bus Posting Group (Ship-From)';
            Description = 'LD1.0';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "VAT Business Posting Group";
        }
        field(56; "Country Dimension"; Code[10])
        {
            Caption = 'Country Dimension';
            Description = '26-01-18 ZY-LD 002';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                         "Dimension Value Type" = const(Standard),
                                                         Blocked = const(false));
        }
        field(57; "Default Mapping"; Boolean)
        {
            Caption = 'Default Mapping';

            trigger OnValidate()
            begin
                recAznCompMap.SetRange("Customer No.", "Customer No.");  // 10-04-19 ZY-LD 003
                recAznCompMap.SetRange("Default Mapping", true);
                recAznCompMap.SetFilter("Marketplace ID", '<>%1', "Marketplace ID");
                if recAznCompMap.FindFirst() then
                    Error(Text001, recAznCompMap."Marketplace ID", recAznCompMap.FieldCaption("Default Mapping"));
            end;
        }
        field(58; Roundings; Code[20])
        {
            Caption = 'Rounding G/L Account No.';
            Description = '16-02-17 ZY-LD 002';
            TableRelation = "G/L Account";
        }
        field(59; "Transaction Type - Order"; Code[10])
        {
            Caption = 'Transaction Type - Order';
            Description = '29-06-22 ZY-LD 006';
            TableRelation = "Transaction Type";
        }
        field(60; "Code for Shipping Fee"; Code[20])
        {
            Caption = 'Code for Shipping Fee';
            Description = '18-08-22 ZY-LD 007';
        }
        field(61; "Market Place Name"; Code[30])
        {
            Caption = 'Market Place Name';
        }
        field(62; "Tax G/L Account No."; Code[20])
        {
            Caption = 'Tax G/L Account No.';
            Description = 'PAB 1.0';
            TableRelation = "G/L Account";
        }
        field(63; "Settle eCommerce Documents"; Boolean)
        {
            Caption = 'Settle eCommerce Documents';
        }
        field(64; "Advertising G/L Account No."; Code[20])
        {
            Caption = 'Advertising G/L Account No.';
            Description = 'PAB 1.0';
            TableRelation = "G/L Account";
        }
        field(65; "Transaction Type - Refund"; Code[10])
        {
            Caption = 'Transaction Type - Refund';
            Description = '29-06-22 ZY-LD 006';
            TableRelation = "Transaction Type";
        }
        field(66; "Accepted Rounding"; Decimal)
        {
            Caption = 'Accepted Rounding';
            MaxValue = 1;
            MinValue = 0;
        }
        field(67; "Shipping G/L Account No."; Code[20])
        {
            Caption = 'Shipping G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(68; "Waste G/L Account No."; Code[20])
        {
            Caption = 'Waste G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(69; "Import Data from"; Option)
        {
            Caption = 'Import Data from';
            OptionMembers = "Tax Document Library","eCommerce Fulfilled Shipments/Returns";
        }
        field(70; "Discount G/L Account No."; Code[20])
        {
            Caption = 'Discount G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(71; "Code for Discount"; Code[10])
        {
            Caption = 'Code for Discount';
        }
        field(72; "Use Main Market Place ID"; Boolean)
        {
            Caption = 'Use Main Market Place ID';
        }
        field(73; "Code for Compensation Fee"; Code[20])
        {
            Caption = 'Code for Compensation Fee';
        }
        field(74; "Tax Exception Start Date"; Date)
        {
            Caption = 'Tax Exception Start Date';
        }
        field(75; "Tax Exception End Date"; Date)
        {
            Caption = 'Tax Exception End Date';
        }
        field(76; "VAT Prod. Posting Group (GB)"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group (GB)';
            TableRelation = "VAT Product Posting Group";
        }
        field(77; "Country/Region Code (GB)"; Code[10])
        {
            Caption = 'Country/Region Code (GB)';
            TableRelation = "Country/Region";
        }
        field(79; "No Comsuner VAT Check"; Boolean)  // 08-09-2025 BK #522911
        {
            Caption = 'No Consumer VAT Check';

        }
    }

    keys
    {
        key(Key1; "Marketplace ID")
        {
            Clustered = true;
        }
    }

    var
        recAznCompMap: Record "eCommerce Market Place";
        Text001: Label '"%1" is already marked as "%2".';

    procedure CopyDefaultMapping(pNewMarketplace: Code[10])
    var
        recAznCompMapDefault: Record "eCommerce Market Place";
        lrecAznCompMap: Record "eCommerce Market Place";
        recDimValue: Record "Dimension Value";
        recGenLedgSetup: Record "General Ledger Setup";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        Prefix: Code[10];
    begin
        recAznCompMapDefault.SetRange("Default Mapping", true);
        if recAznCompMapDefault.FindFirst() then begin
            lrecAznCompMap := recAznCompMapDefault;
            lrecAznCompMap."Marketplace ID" := pNewMarketplace;
            Prefix := CopyStr(lrecAznCompMap."Market Place Name", 1, StrPos(lrecAznCompMap."Market Place Name", '.'));
            lrecAznCompMap."Market Place Name" := Prefix + pNewMarketplace;
            lrecAznCompMap."Default Mapping" := false;
            lrecAznCompMap."Settle eCommerce Documents" := false;

            lrecAznCompMap."Vendor No." := '';
            lrecAznCompMap."Periodic Account No." := '';

            recGenLedgSetup.Get();
            Prefix := CopyStr(lrecAznCompMap."Country Dimension", 1, StrPos(lrecAznCompMap."Country Dimension", '-'));
            if recDimValue.Get(recGenLedgSetup."Shortcut Dimension 3 Code", Prefix + pNewMarketplace) then
                lrecAznCompMap.Validate("Country Dimension", Prefix + pNewMarketplace)
            else
                lrecAznCompMap."Country Dimension" := '';

            if lrecAznCompMap.Insert() then begin
                SI.SetMergefield(100, pNewMarketplace);
                EmailAddMgt.CreateSimpleEmail('ECOMNMKTPL', '', '');
                EmailAddMgt.Send();
            end;
        end;
    end;
}
