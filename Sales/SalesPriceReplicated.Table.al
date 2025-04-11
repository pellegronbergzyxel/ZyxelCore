Table 60004 "Price List Line Replicated"
{
    Caption = 'Price List Line Replicated';
    DataCaptionFields = "Asset No.";

    fields
    {
        field(1; "Price List Code"; Code[20])
        {
            Caption = 'Price List Code';
            DataClassification = CustomerContent;
            TableRelation = "Price List Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(3; "Source Type"; Enum "Price Source Type")
        {
            Caption = 'Assign-to Type';
            DataClassification = CustomerContent;

        }
        field(4; "Source No."; Code[20])
        {
            Caption = 'Assign-to No. (custom)';
            DataClassification = CustomerContent;

        }
        field(5; "Parent Source No."; Code[20])
        {
            Caption = 'Assign-to Parent No. (custom)';
            DataClassification = CustomerContent;

        }
        field(6; "Source ID"; Guid)
        {
            Caption = 'Assign-to ID';
            DataClassification = CustomerContent;

        }
        field(7; "Asset Type"; Enum "Price Asset Type")
        {
            Caption = 'Product Type';
            DataClassification = CustomerContent;
            InitValue = Item;

        }
        field(8; "Asset No."; Code[20])
        {
            Caption = 'Product No. (custom)';
            DataClassification = CustomerContent;
        }
        field(9; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code (custom)';
            DataClassification = CustomerContent;
        }
        field(10; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;

        }
        field(11; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            DataClassification = CustomerContent;
            TableRelation = "Work Type";
        }
        field(12; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(13; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(15; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code (custom)';
            DataClassification = CustomerContent;
        }
        field(16; "Amount Type"; Enum "Price Amount Type")
        {
            Caption = 'Defines';
            DataClassification = CustomerContent;

        }
        field(17; "Unit Price"; Decimal)
        {
            AccessByPermission = tabledata "Sales Price Access" = R;
            DataClassification = CustomerContent;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

        }
        field(18; "Cost Factor"; Decimal)
        {
            AccessByPermission = tabledata "Sales Price Access" = R;
            DataClassification = CustomerContent;
            Caption = 'Cost Factor';
        }
        field(19; "Unit Cost"; Decimal)
        {
            AccessByPermission = tabledata "Purchase Price Access" = R;
            DataClassification = CustomerContent;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;
        }
        field(20; "Line Discount %"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;

        }
        field(21; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            DataClassification = CustomerContent;

        }
        field(22; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            DataClassification = CustomerContent;

        }
        field(23; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
            DataClassification = CustomerContent;

        }
        field(24; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";

        }
        field(25; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Product Posting Group";
        }
        field(26; "Asset ID"; Guid)
        {
            Caption = 'Asset ID';
            DataClassification = CustomerContent;
        }
        field(27; "Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Line Amount';
            MinValue = 0;
            Editable = false;
        }
        field(28; "Price Type"; Enum "Price Type")
        {
            Caption = 'Price Type';
            DataClassification = CustomerContent;

        }
        field(29; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

        }
        field(30; Status; Enum "Price Status")
        {
            Caption = 'Price Status';
            DataClassification = CustomerContent;

        }
        field(31; "Direct Unit Cost"; Decimal)
        {
            AccessByPermission = tabledata "Purchase Price Access" = R;
            DataClassification = CustomerContent;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;

        }
        field(32; "Source Group"; Enum "Price Source Group")
        {
            Caption = 'Source Group';
            DataClassification = CustomerContent;
        }
        field(33; "Product No."; Code[20])
        {
            Caption = 'Product No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Asset Type" = CONST(Item)) Item where("No." = field("Product No."))
            ELSE
            IF ("Asset Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Asset Type" = CONST(Resource)) Resource
            ELSE
            IF ("Asset Type" = CONST("Resource Group")) "Resource Group"
            ELSE
            IF ("Asset Type" = CONST("Item Discount Group")) "Item Discount Group"
            ELSE
            IF ("Asset Type" = CONST("Service Cost")) "Service Cost";
            ValidateTableRelation = false;
        }
        field(34; "Assign-to No."; Code[20])
        {
            Caption = 'Assign-to No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Type" = CONST(Campaign)) Campaign
            ELSE
            IF ("Source Type" = CONST(Contact)) Contact
            ELSE
            IF ("Source Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Type" = CONST("Customer Disc. Group")) "Customer Discount Group"
            ELSE
            IF ("Source Type" = CONST("Customer Price Group")) "Customer Price Group"
            ELSE
            IF ("Source Type" = CONST(Job)) Job
            ELSE
            IF ("Source Type" = CONST("Job Task")) "Job Task"."Job Task No." where("Job No." = field("Parent Source No."), "Job Task Type" = CONST(Posting))
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor;
            ValidateTableRelation = false;

        }
        field(35; "Assign-to Parent No."; Code[20])
        {
            Caption = 'Assign-to Parent No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Type" = CONST("Job Task")) Job;
            ValidateTableRelation = false;

        }
        field(36; "Variant Code Lookup"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF ("Asset Type" = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("Asset No."));
            ValidateTableRelation = false;

        }
        field(37; "Unit of Measure Code Lookup"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF ("Asset Type" = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Asset No."))
            ELSE
            IF ("Asset Type" = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("Asset No."))
            ELSE
            IF ("Asset Type" = CONST("Resource Group")) "Unit of Measure";
            ValidateTableRelation = false;

        }
        field(50000; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
    }

    keys
    {
        key(PK; "Price List Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key1; "Asset Type", "Asset No.", "Source Type", "Source No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
        key(Key2; "Source Type", "Source No.", "Asset Type", "Asset No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
        key(Key3; Status, "Price Type", "Amount Type", "Currency Code", "Unit of Measure Code", "Source Type", "Source No.", "Asset Type", "Asset No.", "Variant Code", "Starting Date", "Ending Date", "Minimum Quantity")
        {
        }
        key(Key4; Status, "Price Type", "Amount Type", "Currency Code", "Unit of Measure Code", "Source Type", "Parent Source No.", "Source No.", "Asset Type", "Asset No.", "Work Type Code", "Starting Date", "Ending Date", "Minimum Quantity")
        {
        }
        key(Key5; "Product No.", "Asset No.")
        {
        }
    }

}
