tableextension 50156 PurchasesPayablesSetupZX extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Company Code"; Text[30])
        {
            Description = 'ZY1.0 - Auto Item Journal';

            trigger OnValidate()
            var
                Company: Record Company;
            begin
                /*
                //ZY1.0 <<
                TESTFIELD("Live Company");
                IF CompanyName() <> "Live Company" THEN ERROR(Text000,"Live Company");
                IF ("Company Code" <> xRec."Company Code") AND ("Company Code" <> '') THEN
                 IF NOT Company.GET("Company Code") THEN
                  ERROR(Text003,"Company Code");
                //ZY1.0 <<
                */
            end;
        }
        field(50001; "Template Name"; Code[10])
        {
            Description = 'ZY1.0 - Auto Item Journal';

            trigger OnLookup()
            var
                LocalItemJnlTemplate: Record "Item Journal Template";
            begin
                /*
                //ZY1.0 >>
                TESTFIELD("Company Code");
                LocalItemJnlTemplate.RESET;
                LocalItemJnlTemplate.CHANGECOMPANY("Company Code");
                IF PAGE.RUNMODAL(0,LocalItemJnlTemplate) = ACTION::LookupOK THEN
                  "Template Name" := LocalItemJnlTemplate.Name;
                
                //ZY1.0 <<
                */
            end;

            trigger OnValidate()
            var
                LocalItemJnlTemplate: Record "Item Journal Template";
            begin
                /*
                //ZY1.0 >>
                TESTFIELD("Company Code");
                IF ("Template Name" <> xRec."Template Name") AND ("Template Name" <> '') THEN BEGIN
                  LocalItemJnlTemplate.RESET;
                  LocalItemJnlTemplate.CHANGECOMPANY("Company Code");
                  IF NOT LocalItemJnlTemplate.GET("Template Name") THEN
                   ERROR(Text002,"Company Code");
                END;
                //ZY1.0 <<
                */
            end;
        }
        field(50002; "Batch Name"; Code[10])
        {
            Description = 'ZY1.0 - Auto Item Journal';

            trigger OnLookup()
            var
                LclItemJournalBatch: Record "Item Journal Batch";
            begin
                /*
                //ZY1.0 >>
                TESTFIELD("Company Code");
                TESTFIELD("Template Name");
                LclItemJournalBatch.RESET;
                LclItemJournalBatch.CHANGECOMPANY("Company Code");
                LclItemJournalBatch.SETRANGE(LclItemJournalBatch."Journal Template Name","Template Name");
                IF PAGE.RUNMODAL(0,LclItemJournalBatch) = ACTION::LookupOK THEN
                 "Batch Name" := LclItemJournalBatch.Name;
                //ZY1.0 <<
                */
            end;

            trigger OnValidate()
            var
                LclItemJournalBatch: Record "Item Journal Batch";
                InventorySetup: Record "Inventory Setup";
            begin
                /*
                //ZY1.0 >>
                TESTFIELD("Company Code");
                TESTFIELD("Template Name");
                IF ("Batch Name" <> xRec."Batch Name") AND ("Batch Name" <> '') THEN BEGIN
                  LclItemJournalBatch.RESET;
                  LclItemJournalBatch.CHANGECOMPANY("Company Code");
                  IF NOT LclItemJournalBatch.GET("Template Name","Batch Name") THEN
                   ERROR(Text004,"Company Code");
                 InventorySetup.CHANGECOMPANY("Company Code");
                 IF InventorySetup.GET THEN BEGIN
                  InventorySetup."Auto Transfer Template Name" := "Template Name";
                  InventorySetup."Auto Transfer Batch Name" := "Batch Name";
                  InventorySetup.MODIFY;
                 END;
                END;
                //ZY1.0 <<
                */
            end;
        }
        field(50003; "In-Transit Location"; Code[10])
        {
            Description = 'ZY1.0 - Auto Item Journal';

            trigger OnLookup()
            var
                LclLocation: Record Location;
            begin
                /*
                //ZY1.0 >>
                TESTFIELD("Company Code");
                LclLocation.RESET;
                LclLocation.CHANGECOMPANY("Company Code");
                LclLocation.SETRANGE(LclLocation."Use As In-Transit",TRUE);
                IF PAGE.RUNMODAL(0,LclLocation) = ACTION::LookupOK THEN
                 "In-Transit Location" := LclLocation.Code;
                //ZY1.0 <<
                */
            end;

            trigger OnValidate()
            var
                LclLocation: Record Location;
            begin
                /*
                //ZY1.0 >>
                IF ("In-Transit Location" <> xRec."In-Transit Location") AND ("In-Transit Location" <> '') THEN BEGIN
                  TESTFIELD("Company Code");
                  LclLocation.RESET;
                  LclLocation.CHANGECOMPANY("Company Code");
                  LclLocation.SETRANGE(LclLocation."Use As In-Transit",TRUE);
                  LclLocation.SETRANGE(Code,"In-Transit Location");
                  IF NOT LclLocation.FINDFIRST THEN ERROR(Text005,"In-Transit Location");
                END;
                //ZY1.0 <<
                */
            end;
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

            trigger OnLookup()
            var
                LocalItemJnlTemplate: Record "Item Journal Template";
            begin
            end;

            trigger OnValidate()
            var
                LocalItemJnlTemplate: Record "Item Journal Template";
            begin
            end;
        }
        field(50009; "PurchJnl Batch Name"; Code[10])
        {
            Description = 'ZY2.0 - Auto Purchase Journal';

            trigger OnLookup()
            var
                LclItemJournalBatch: Record "Item Journal Batch";
            begin
            end;

            trigger OnValidate()
            var
                LclItemJournalBatch: Record "Item Journal Batch";
                InventorySetup: Record "Inventory Setup";
            begin
            end;
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
            Description = '15-02-19 ZY-LD 002';
            TableRelation = SBU.Code where(Type = const(SBU));
            ValidateTableRelation = false;
        }
        field(50041; "SBU Filter SP"; Code[50])
        {
            Caption = 'SBU Filter SP';
            Description = '15-02-19 ZY-LD 002';
            TableRelation = SBU.Code where(Type = const(SBU));
            ValidateTableRelation = false;
        }
        field(50042; "EiCard Vendor No. CH"; Code[20])
        {
            Caption = 'EiCard Vendor No. CH';
            Description = '31-03-19 ZY-LD 003';
            TableRelation = Vendor."No.";
        }
        field(50043; "EMEA Vendor No."; Code[20])
        {
            Caption = 'EMEA Vendor No.';
            Description = '08-07-19 ZY-LD 004';
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
    }

    var
        Text000: Label 'Information can only be entered in %1 Company.';
        Text002: Label 'Item Journal Template Name does not exist in %1';
        Text003: Label 'Company %1 does not exist.';
        Text004: Label 'Item Journal Batch Name does not exist in %1';
        Text005: Label 'In-Transit location %1 does not exist.';


}
