tableextension 50156 PurchasesPayablesSetupZX extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Company Code"; Text[30])
        {
            Description = 'ZY1.0 - Auto Item Journal';
        }
        field(50001; "Template Name"; Code[10])
        {
            Description = 'ZY1.0 - Auto Item Journal';
        }
        field(50002; "Batch Name"; Code[10])
        {
            Description = 'ZY1.0 - Auto Item Journal';
        }
        field(50003; "In-Transit Location"; Code[10])
        {
            Description = 'ZY1.0 - Auto Item Journal';
        }
        field(50004; "Concur Vendor Nos."; Code[10])
        {
            Caption = 'Concur Vendor Nos.';
            Description = '28-08-20 ZY-LD 005';
            TableRelation = "No. Series";
        }
        field(50005; "Live Company"; Text[30])
        {
            Description = 'ZY1.0 - Auto Item Journal';
        }
        field(50006; "EiCard HQ Invoice Folder"; Text[250])
        {
            Description = 'PAB 1.0';
            InitValue = '\\zysql.lan.zyxel.dk\HQInvoices';
        }
        field(50007; "EiCard HQ Order Folder"; Text[250])
        {
            Description = 'PAB 1.0';
            InitValue = '\\zysql.lan.zyxel.dk\HQOrders';
        }
        field(50008; "PurchJnl Template Name"; Code[10])
        {
            Description = 'ZY2.0 - Auto Purchase Journal';

        }
        field(50009; "PurchJnl Batch Name"; Code[10])
        {
            Description = 'ZY2.0 - Auto Purchase Journal';
        }
        field(50010; "Vendor No. in RHQ"; Code[20])
        {
            Description = 'ZY2.0 - Auto Purchase Journal';
        }
        field(50011; "CZ RHQ intercompany Account"; Code[20])
        {
            Description = 'ZY2.0 - Auto Purchase Journal - Used in Report 62016';
            TableRelation = "G/L Account";
        }
        field(50012; "Block Last Direct Cost"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50013; "Concur Invoice Nos."; Code[10])
        {
            Caption = 'Concur Invoice Nos.';
            Description = '28-08-20 ZY-LD 005';
            TableRelation = "No. Series";
        }
        field(50015; "Default Gen. Bus. Posting Grp"; Code[10])
        {
            Description = 'ZY2.0 - Auto Purchase Journal - Used in Report 62016';
        }
        field(50016; "Default Gen. Prod Posting Grp"; Code[10])
        {
            Description = 'ZY2.0 - Auto Purchase Journal - Used in Report 62016';
        }
        field(50017; "EiCard Vendor No."; Code[20])
        {
            Description = 'PAB 1.0';
            InitValue = '20001';
            TableRelation = Vendor."No.";
        }
        field(50018; "EiCard Email Address"; Text[250])
        {
            Description = 'PAB 1.0';
            InitValue = 'eicards@zyxel.eu';
        }
        field(50019; "EiCard Default Email Subject"; Text[250])
        {
            Description = 'PAB 1.0';
            InitValue = 'Your EiCard Order';
        }
        field(50020; "EiCard Additional Recipient"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(50021; "EiCard Lead Time"; Integer)
        {
            Description = 'PAB 1.0';
            InitValue = 1;
        }
        field(50022; "Auto Post EiCard Orders"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50023; "EMail Creator on Error"; Boolean)
        {
            Description = 'PAB 1.0';
            InitValue = true;
        }
        field(50024; "Error Reporting Email"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(50025; "EiCard PO Lead Time"; Integer)
        {
            Description = 'PAB 1.0';
            InitValue = 2;
        }
        field(50027; "EShop Invoice Folder"; Text[250])
        {
            Description = 'PAB 1.0';
            InitValue = '\\zysql.lan.zyxel.dk\EShopInvoices';
        }
        field(50028; "EShop Order Folder"; Text[250])
        {
            Description = 'PAB 1.0';
            InitValue = '\\zysql.lan.zyxel.dk\EShopOrders';
        }
        field(50029; "Send Orders To EShop"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50030; "EShop Vendor No."; Code[20])
        {
            Description = 'PAB 1.0';
            InitValue = '20001';
            TableRelation = Vendor."No.";
        }
        field(50031; "EShop Default Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            Description = 'PAB 1.0';
            TableRelation = "Transport Method";
        }
        field(50032; "EiCar Default Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            Description = 'PAB 1.0';
            TableRelation = "Transport Method";
        }
        field(50033; "EiCard Posting File"; Text[250])
        {
            Description = 'PAB 1.0';
            InitValue = '\\EShopPosting\postline.txt';
        }
        field(50034; "EiCard Posting Trigger File"; Text[250])
        {
            Description = 'PAB 1.0';
            InitValue = '\\EShopPosting\trigger.txt';
        }
        field(50035; "EiCard FTP Folder"; Code[20])
        {
            Caption = 'EiCard FTP Folder';
            Description = '06-02-19 ZY-LD 001';
            TableRelation = "FTP Folder";
        }
        field(50036; "EShop FTP Folder"; Code[20])
        {
            Caption = 'EShop FTP Folder';
            Description = '06-02-19 ZY-LD 001';
            TableRelation = "FTP Folder";
        }
        field(50037; "EShop Vendor No. CH"; Code[20])
        {
            Caption = 'EShop Vendor No. CH';
            Description = '06-02-19 ZY-LD 001';
            InitValue = '20001';
            TableRelation = Vendor."No.";
        }
        field(50038; "EiCard FTP Folder CH"; Code[20])
        {
            Caption = 'EiCard FTP Folder CH';
            Description = '06-02-19 ZY-LD 001';
            TableRelation = "FTP Folder";
        }
        field(50039; "EShop FTP Folder CH"; Code[20])
        {
            Caption = 'EShop FTP Folder CH';
            Description = '06-02-19 ZY-LD 001';
            TableRelation = "FTP Folder";
        }
        field(50040; "SBU Filter CH"; Code[50])
        {
            Caption = 'SBU Filter CH';
            TableRelation = SBU.Code where(Type = const(SBU));
            ValidateTableRelation = false;
        }
        field(50041; "SBU Filter SP"; Code[50])
        {
            Caption = 'SBU Filter SP';
            TableRelation = SBU.Code where(Type = const(SBU));
            ValidateTableRelation = false;
        }
        field(50042; "EiCard Vendor No. CH"; Code[20])
        {
            Caption = 'EiCard Vendor No. CH';
            TableRelation = Vendor."No.";
        }
        field(50043; "EMEA Vendor No."; Code[20])
        {
            Caption = 'EMEA Vendor No.';
            TableRelation = Vendor;
        }
        field(50044; "NL to DK Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(50045; "NL to DK Debit Account No."; Code[20])
        {
            Caption = 'Debit Account No.';
            TableRelation = "G/L Account";
        }
        field(50046; "NL to DK Credit Account No."; Code[20])
        {
            Caption = 'Credit Account No.';
            TableRelation = "G/L Account";
        }
        field(50047; "NL to DK VAT Prod. Post. Grp."; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(50048; AllowLocationchange; Boolean)
        {
            Caption = 'Allow location change on purchase lines';
        }
        field(50050; CostPriceVendorno; Code[20]) //18-11-2025 BK #524237
        {
            Caption = 'Cost Price Vendor No.';
            Description = 'Vendor No. for cost price, used when cost price is 0 on sales order.';
            TableRelation = Vendor."No.";
        }
    }

}
