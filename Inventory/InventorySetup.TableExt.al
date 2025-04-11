tableextension 50157 InventorySetupZX extends "Inventory Setup"
{
    fields
    {
        field(50001; "Auto Transfer Template Name"; Code[10])
        {
            Description = 'ZY1.0';
            Editable = false;

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
        field(50002; "Auto Transfer Batch Name"; Code[10])
        {
            Description = 'ZY1.0';
            Editable = false;

            trigger OnLookup()
            var
                LclItemJournalBatch: Record "Item Journal Batch";
            begin
            end;

            trigger OnValidate()
            var
                LclItemJournalBatch: Record "Item Journal Batch";
            begin
            end;
        }
        field(50003; "Cr. Memo Report ID"; Integer)
        {
            Description = 'ZY2.0';
        }
        field(50004; "Prevent Empty Volume"; Boolean)
        {
            Caption = 'Prevent Empty Volume';
            Description = '15-03-22 ZY-LD 002';
        }
        field(62000; "Picking List Nos."; Code[10])
        {
            Caption = 'Picking List Nos.';
            TableRelation = "No. Series";
        }
        field(62001; "Packing Report ID"; Integer)
        {
        }
        field(62002; "Invoice Report ID"; Integer)
        {
        }
        field(62003; "Customer Dimension Code"; Code[20])
        {
            Caption = 'Customer Dimension Code';
            TableRelation = Dimension;
        }
        field(62004; "Partner Dimension Value"; Code[20])
        {
        }
        field(62005; "Sub Dimension Value"; Code[20])
        {
        }
        field(62007; "Hudig Notification E-Mail"; Text[120])
        {
            Caption = 'Hudig Notification E-Mail';
            ExtendedDatatype = EMail;
        }
        field(62008; "Sales Forecast Nos."; Code[10])
        {
            Caption = 'Sales Forecast Nos.';
            TableRelation = "No. Series";
        }
        field(62009; "Default Item Disc. Group"; Code[10])
        {
            Caption = 'Default Item Disc. Group';
            TableRelation = "Item Discount Group";
        }
        field(62010; "AIT Journal Template Name"; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = "Item Journal Template".Name;
        }
        field(62011; "AIT Batch Name"; Code[10])
        {
            Description = 'PAB 1.0';
        }
        field(62012; "AIT Location Code"; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = Location.Code;
        }
        field(62013; "AIT Inventory Posting Group"; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = "Inventory Posting Group".Code;
        }
        field(62014; "AIT Gen. Prod. Posting Group"; Code[10])
        {
            Description = 'PAB 1.0';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(62015; "AIT Last Journal Document No"; Code[10])
        {
            Description = 'PAB 1.0';
        }
        field(62016; "AIT Journal Description"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(62017; "AIT Batch Description"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(70000; GoodsInTransitLocationCode; Code[10])
        {
            Caption = 'Goods in Transit - Location Code';
            TableRelation = Location.Code where("Use As In-Transit" = const(false));
            AccessByPermission = TableData Location = r;
            DataClassification = CustomerContent;
        }
        field(70001; GoodsInTransitInTransitCode; Code[10])
        {
            Caption = 'Goods in Transit - In-Transit Code';
            TableRelation = Location.Code where("Use As In-Transit" = const(true));
            AccessByPermission = TableData Location = r;
            DataClassification = CustomerContent;
        }
    }
}
