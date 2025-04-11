tableextension 50155 SalesReceivablesSetupZX extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Autocreate Customer Dimension"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(50001; "Sales Template"; Code[20])
        {
            Description = 'ZY2.0 - Copy "No." from the Sales Header Template defined in  RHQ Live - RHQ LIVE';
        }
        field(50002; "HO Company"; Text[30])
        {
            Description = 'ZY2.0 - Copy RHQ Live company name in this field. - ZYND CZ company';
        }
        field(50003; "Customer No. on Sister Company"; Code[20])
        {
            Caption = 'Customer No. on Sister Company';
            Description = '11-07-19 ZY-LD 001';
            TableRelation = Customer;
        }
        field(50004; "Additional EMEA Purchase %"; Decimal)
        {
            Caption = 'Additional EMEA Purchase %';
            Description = '05-12-19 ZY-LD 002';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50005; "Disallow Negative Inventory"; Boolean)
        {
        }
        field(50006; "Zero Unit cost on Sales line"; Boolean)
        {
        }
        field(50007; "EiCard Automation Enabled"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50008; "Auto Post EiCard Orders"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50009; "Forecast Locked"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50010; "Last Forecast Confirmation"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50011; "All-In Logistics Location"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = Location.Code;
        }
        field(50012; "Delivery Document Nos."; Code[10])
        {
            Caption = 'Delivery Document Nos.';
            Description = 'PAB 1.0';
            TableRelation = "No. Series";
        }
        field(50013; "Delivery Days to Add"; Integer)
        {
            Description = 'PAB 1.0';
            InitValue = 2;
        }
        field(50014; "Shipment Days to Add"; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(50015; "Last Delivery Doc No."; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(50016; "Delivery Document Prefix"; Code[10])
        {
            Description = 'PAB 1.0';
            InitValue = 'DD';
        }
        field(50017; "EiCard Queue Busy"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50018; "VCK Message No"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(50019; "VCK CustomerID"; Text[30])
        {
            Caption = 'Customer ID';
            Description = 'PAB 1.0';
        }
        field(50020; "eCommerce Folder"; Text[250])
        {
            Description = 'eCommerce';
        }
        field(50021; "VCK Pass Code"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(50022; "VCK Message Number Series"; Code[20])
        {
            Caption = 'Message Number Series';
            Description = 'PAB 1.0';
            TableRelation = "No. Series".Code;
        }
        field(50023; "VCK Project Code"; Code[20])
        {
            Caption = 'Project Code';
            Description = 'PAB 1.0';
        }
        field(50024; "VCK Out FTP"; Code[10])
        {
            Caption = 'VCK Upload FTP';
            Description = 'PAB 1.0';
            TableRelation = "FTP Folder".Code;
        }
        field(50025; "VCK In FTP"; Code[10])
        {
            Caption = 'VCK Download FTP';
            Description = 'PAB 1.0';
            TableRelation = "FTP Folder".Code;
        }
        field(50026; "Full Pallet / Carton Ordering"; Boolean)
        {
            Caption = 'Carton Ordering Enabled';
            Description = '31-05-21 ZY-LD 003';
        }
        field(50027; "Del. Doc. Creation Calculation"; DateFormula)
        {
            Caption = 'Delivery Doc. Creation Calculation';
        }
        field(50028; "Default Shipment Date"; Date)
        {
            Caption = 'Default Shipment Date';
            Description = '22-06-21 ZY-LD 004';
        }
        field(50029; "Print Req. Del. Date on O.Conf"; Boolean)
        {
            Caption = 'Print Req. Del. Date on Order Line';
        }
        field(50030; "Calculate Shipment Date"; Boolean)
        {
            Caption = 'Calculate Shipment Date';
            Description = '20-09-21 ZY-LD 005';
        }
        field(50031; "Calc. Local VAT for Currency"; Code[10])
        {
            Caption = 'Calc. Local VAT for Currency';
            Description = '28-01-22 ZY-LD 006';
            TableRelation = Currency;
        }
        field(50032; "Skip Salesperson Dimension"; Boolean)  // 10-06-24 ZY-LD 000
        {
            Caption = 'Skip Salesperson Dimension';
            Description = 'The field can be deleted. It´s not in use.';
        }
        field(50033; "Margin Approval"; Boolean)  // 20-06-24 ZY-LD 000
        {
            Caption = 'Margin Approval';
        }
        field(50034; "NL to DK Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(50035; "NL to DK Debit Account No."; Code[20])
        {
            Caption = 'Debit Account No.';
            TableRelation = "G/L Account";
        }
        field(50036; "NL to DK Credit Account No."; Code[20])
        {
            Caption = 'Credit Account No.';
            TableRelation = "G/L Account";
        }
        field(50037; "NL to DK VAT Prod. Post. Grp."; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(50038; "Run NL to DK Posting"; Boolean)
        {
            Caption = 'Run NL to DK Posting';
        }
        field(50039; "Calc. Sales Price Based on"; Option)  // 13-09-24 ZY-LD 000
        {
            Caption = 'Calc. Sales Price Based on';
            OptionMembers = "Document Date","Requested Delivery Date";
            OptionCaption = 'Document Date (Default),Requested Delivery Date';
        }
        field(62000; "Check Ext. Doc. for SO release"; Boolean)
        {
            Caption = 'Check Ext. Doc. for SO release';
            Description = 'Tectura Taiwan';
        }
        field(62001; "MDM Customer No."; Code[20])
        {
            Description = 'Tectura Taiwan';
        }
        field(62002; "AVL Buffer Customer No."; Code[20])
        {
            Description = 'Tectura Taiwan';
        }
        field(62017; "Sales Order Type Mandatory"; Boolean)
        {
            Caption = 'Sales Order Type Mandatory';
            Description = 'Tectura Taiwan';

            trigger OnValidate()
            var
                LEMSG000: Label 'Sales Order Type can not be change!';
                LocationRec: Record Location;
                LEMSG001: Label 'Sales Order Type %1 can not match with Location %2!';
                LEMSG002: Label 'Location %1 not exist!';
                LEMSG003: Label 'Can not find default location for Sales Order Type %1!';
                SOLine: Record "Sales Line";
                Item: Record Item;
                LEMSG004: Label 'Item %1 is not match %2!';
            begin
            end;
        }
        field(62018; "Use Sell-to text code filter"; Boolean)
        {
        }
        field(66001; "DSV Workorder No Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(66002; "Elisa Company"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(66003; "Elisa Organization No."; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(66004; "Elisa E-Invoice Address"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(66005; "Elisa PO Box"; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(66006; "Elisa Contract No."; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(66007; "Elisa Customer Ref No."; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(66008; "Elisa Email Address"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(66009; "Next Message No"; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(66010; "Next Saved Message No"; Integer)
        {
            Description = 'PAB 1.0';
        }
        field(66011; "Transfer Order Delivery Terms"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(66012; "Sales Order Delivery Terms"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(66013; "LMR Trigger Folder"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(66014; "LMR Item Journal Batch Name"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(66015; "LMR Item Journal Template Name"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Item Journal Template".Name;
        }
        field(66016; "LMR Gen. Prod. Posting Group"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(66017; "LMR Description"; Text[20])
        {
            Description = 'PAB 1.0';
        }
        field(66018; "LMR Division"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DIVISION'));
        }
        field(66019; "LMR Department"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('DEPARTMENT'));
        }
        field(66020; "LMR Value Bin"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(66021; "LMR Source Code"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(66022; "LMR Country Code"; Code[20])
        {
            Description = 'PAB 1.0';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('COUNTRY'));
        }
        field(70000; BacklogCmtUnderMinAmount; Blob)
        {
            Caption = 'Backlog Comment under Min. Amount';
            DataClassification = CustomerContent;
        }
    }

    trigger OnModify()
    var
        MarginApp: Record "Margin Approval";
    begin
        if Rec."Margin Approval" and not xRec."Margin Approval" then
            MarginApp.UpdateOnSetup();
    end;

    procedure SetBacklogComment(NewBacklogComment: Text)
    var
        OutStream: OutStream;
    begin
        Clear(BacklogCmtUnderMinAmount);
        BacklogCmtUnderMinAmount.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(DelChr(NewBacklogComment, '<>'));
        Modify();
    end;

    procedure GetBacklogComment(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(BacklogCmtUnderMinAmount);
        BacklogCmtUnderMinAmount.CreateInStream(InStream, TextEncoding::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName(BacklogCmtUnderMinAmount)));
    end;
}
