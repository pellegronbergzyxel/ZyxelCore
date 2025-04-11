Table 50032 "Concur Setup"
{
    // 001. 16-11-21 ZY-LD 000 - New field.

    Caption = 'Concur Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Import Folder - Travel Expense"; Text[80])
        {
            Caption = 'Import Folder - Travel Expense';

            trigger OnValidate()
            begin
                "Import Folder - Travel Expense" := DelChr("Import Folder - Travel Expense", '>', '\');
                "Import Folder - Travel Expense" := "Import Folder - Travel Expense" + '\';
            end;
        }
        field(3; "Import Folder - Invoice Captur"; Text[80])
        {
            Caption = 'Import Folder - Invoice Captur';

            trigger OnValidate()
            begin
                "Import Folder - Invoice Captur" := DelChr("Import Folder - Invoice Captur", '>', '\');
                "Import Folder - Invoice Captur" := "Import Folder - Invoice Captur" + '\';
            end;
        }
        field(4; "Import Error E-mail Code"; Code[10])
        {
            Caption = 'Import Error E-mail Code';
            TableRelation = "E-mail address";
        }
        field(5; "Uploaded Folder"; Text[10])
        {
            Caption = 'Uploaded Folder';

            trigger OnValidate()
            begin
                "Uploaded Folder" := DelChr("Uploaded Folder", '>', '\');
                "Uploaded Folder" := "Uploaded Folder" + '\';
            end;
        }
        field(6; "Error Folder"; Text[10])
        {
            Caption = 'Error Folder';

            trigger OnValidate()
            begin
                "Error Folder" := DelChr("Error Folder", '>', '\');
                "Error Folder" := "Error Folder" + '\';
            end;
        }
        field(7; "Archive Folder"; Text[10])
        {
            Caption = 'Archive Folder';

            trigger OnValidate()
            begin
                "Archive Folder" := DelChr("Archive Folder", '>', '\');
                "Archive Folder" := "Archive Folder" + '\';
            end;
        }
        field(8; "From Concur Folder"; Text[15])
        {
            Caption = 'From Concur Folder';

            trigger OnValidate()
            begin
                "From Concur Folder" := DelChr("From Concur Folder", '>', '\');
                "From Concur Folder" := "From Concur Folder" + '\';
            end;
        }
        field(9; "Import Success E-mail Code"; Code[10])
        {
            Caption = 'Import Success E-mail Code';
            TableRelation = "E-mail address";
        }
        field(10; "No Lines to Import E-mail Code"; Code[10])
        {
            Caption = 'No Lines to Import E-mail Code';
            TableRelation = "E-mail address";
        }
        field(11; "Rejected E-mail Code"; Code[10])
        {
            Caption = 'Rejected E-mail Code';
            TableRelation = "E-mail address";
        }
        field(12; "Vendor Nos."; Code[10])
        {
            Caption = 'Vendor Nos.';
            TableRelation = "No. Series";
        }
        field(13; "Invoice Nos."; Code[10])
        {
            Caption = 'Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(14; "Gen. Bus. Posting Group Dom."; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group - Domestic';
            TableRelation = "Gen. Business Posting Group";
        }
        field(15; "Vendor Posting Group Dom."; Code[10])
        {
            Caption = 'Vendor Posting Group - Domestic';
            TableRelation = "Vendor Posting Group";
        }
        field(16; "Gen. Bus. Posting Group EU"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group - EU';
            TableRelation = "Gen. Business Posting Group";
        }
        field(17; "Vendor Posting Group EU"; Code[10])
        {
            Caption = 'Vendor Posting Group - EU';
            TableRelation = "Vendor Posting Group";
        }
        field(18; "Gen. Bus. Posting Group Non-EU"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group - NON-EU';
            TableRelation = "Gen. Business Posting Group";
        }
        field(19; "Vendor Posting Group Non-EU"; Code[10])
        {
            Caption = 'Vendor Posting Group - NON-EU';
            TableRelation = "Vendor Posting Group";
        }
        field(20; "Vendor Form Name"; Text[30])
        {
            Caption = 'Vendor Form Name';
        }
        field(21; "To Concur Folder"; Text[10])
        {
            Caption = 'To Concur Folder';

            trigger OnValidate()
            begin
                "To Concur Folder" := DelChr("To Concur Folder", '>', '\');
                "To Concur Folder" := "To Concur Folder" + '\';
            end;
        }
        //TODO: LD Reference to Lessor
        // field(22;"Travel Exp. Pay Type Code";Code[10])
        // {
        //     Caption = 'Travel Exp. Pay Type Code';
        //     TableRelation = "Pay Type";
        // }
        field(23; "Travel Exp. Pay Type Mail Add."; Code[10])
        {
            Caption = 'Travel Exp. Pay Type Mail Add.';
            TableRelation = "E-mail address";
        }
        field(24; "Travel Exp. Gen. Jnl. Template"; Code[10])
        {
            Caption = 'Travel Exp. Gen. Jnl. Template';
            TableRelation = "Gen. Journal Template";
        }
        field(25; "Travel Exp. Gen. Jnl. Batch"; Code[10])
        {
            Caption = 'Travel Exp. Gen. Jnl. Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Travel Exp. Gen. Jnl. Template"));
        }
        field(26; "Travel Exp. Concur Id Nos"; Code[10])
        {
            Caption = 'Travel Exp. Concur Id Nos';
            TableRelation = "No. Series";
        }
        field(27; "Travel Expense Nos."; Code[10])
        {
            Caption = 'Travel Expense Nos.';
            TableRelation = "No. Series";
        }
        field(28; "Cash Advance Account No."; Code[20])
        {
            Caption = 'Cash Advance Account No.';
            Description = '16-11-21 ZY-LD 001';
            TableRelation = "G/L Account";
        }
        field(29; "Freight in Transit Account No."; Code[20])
        {
            Caption = 'Freight in Transit Account No.';
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
