tableextension 50112 VendorZX extends Vendor
{
    fields
    {
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        field(13650; "Giro Acc. No."; Code[10])
        {
            Caption = 'Giro Acc. No.';

            trigger OnValidate()
            begin
                if Rec."Giro Acc. No." <> '' then
                    Rec."Giro Acc. No." := PadStr('', MaxStrLen(Rec."Giro Acc. No.") - StrLen(Rec."Giro Acc. No."), '0') + Rec."Giro Acc. No.";
            end;
        }
        field(50000; "Related Company"; Boolean)
        {
        }
        field(50001; "IC Partner Code Zyxel"; Code[10])
        {
            Caption = 'IC Partner Code Zyxel';
            Description = '09-07-19 ZY-LD 003';
            TableRelation = "IC Partner";
        }
        field(50002; "FTP Code Normal"; Code[20])
        {
            Caption = 'FTP Code Normal';
            Description = '04-11-19 ZY-LD 004';
            TableRelation = "FTP Folder";
        }
        field(50003; "FTP Code EiCard"; Code[20])
        {
            Caption = 'FTP Code EiCard';
            Description = '04-11-19 ZY-LD 004';
            TableRelation = "FTP Folder";
        }
        field(50004; "SBU Company"; Option)
        {
            Caption = 'Zyxel Company';
            Description = '04-11-19 ZY-LD 004';
            OptionCaption = ' ,ZCom HQ,ZNet HQ,ZCom EMEA,ZNet EMEA';
            OptionMembers = " ","ZCom HQ","ZNet HQ","ZCom EMEA","ZNet EMEA";
        }
        field(50005; "Add. EMEA Purchace Price %"; Decimal)
        {
            Caption = 'Additional EMEA Purchace Price %';
            Description = '02-01-20 ZY-LD 005';
            MaxValue = 10;
            MinValue = 0;
        }
        field(50006; "Sample Vendor"; Boolean)  // 02-05-24 - ZY-LD 000
        {
            Caption = 'Sample Vendor';
        }
        field(50040; "Intercompany Purchase"; Code[10])
        {
            Caption = 'Intercompany Purchase';
        }
        field(50050; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'CO4.20';
        }
        field(50051; "Tax Office Code"; Code[20])
        {
            Caption = 'Tax Office Code';
            Description = 'PAB 1.0';
        }
        field(50052; "VAT ID"; Text[20])
        {
            Caption = 'VAT ID';
            Description = 'PAB 1.0';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                VATRegNoFormat.Test(Rec."VAT ID", Rec."Country/Region Code", Rec."No.", Database::Vendor);
            end;
        }
        field(50053; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }
}
