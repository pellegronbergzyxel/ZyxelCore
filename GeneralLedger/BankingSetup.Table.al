table 75200 "Banking Setup"
{
    fields
    {
        field(1; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            NotBlank = true;
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                CalcFields("Bank Account Name");
            end;
        }
        field(2; "Bank Account Name"; Text[100])
        {
            CalcFormula = lookup("Bank Account".Name where("No." = field("Bank Account No.")));
            Caption = 'Bank Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Payment Order Nos."; Code[10])
        {
            Caption = 'Payment Order Nos.';
            TableRelation = "No. Series";
        }
        field(4; "Issued Payment Order Nos."; Code[10])
        {
            Caption = 'Issued Payment Order Nos.';
            TableRelation = "No. Series";
        }
        field(5; "Bank Statement Nos."; Code[10])
        {
            Caption = 'Bank Statement Nos.';
            TableRelation = "No. Series";
        }
        field(6; "Issued Bank Statement Nos."; Code[10])
        {
            Caption = 'Issued Bank Statement Nos.';
            TableRelation = "No. Series";
        }
        field(7; "Default Constant Symbol"; Code[10])
        {
            Caption = 'Default Constant Symbol';
            CharAllowed = '09';
            TableRelation = "Constant Symbol";
        }
        field(8; "Default Specific Symbol"; Code[20])
        {
            Caption = 'Default Specific Symbol';
            CharAllowed = '09';
        }
        field(9; "Gen. Journal Template"; Code[10])
        {
            Caption = 'Gen. Journal Template';
            TableRelation = "Gen. Journal Template";

            trigger OnValidate()
            begin
                if "Gen. Journal Template" <> xRec."Gen. Journal Template" then
                    Clear("Gen. Journal Batch");
            end;
        }
        field(10; "Gen. Journal Batch"; Code[10])
        {
            Caption = 'Gen. Journal Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Gen. Journal Template"));

            trigger OnValidate()
            var
                lreGenJnlBatch: Record "Gen. Journal Batch";
            begin
                lreGenJnlBatch.Get("Gen. Journal Template", "Gen. Journal Batch");
            end;
        }
        field(11; "Non Associated Payment Account"; Code[20])
        {
            Caption = 'Non Associated Payment Account';
            TableRelation = "G/L Account";
        }
        field(20; "Export Path"; Text[250])
        {
            Caption = 'Export Path';
        }
        field(21; "Export File Type"; Text[3])
        {
            Caption = 'Export File Type';
        }
        field(22; "Export Object Type"; Option)
        {
            BlankZero = true;
            Caption = 'Export Object Type';
            InitValue = Dataport;
            OptionMembers = ,,,"Report",Dataport,"Codeunit";

            trigger OnValidate()
            begin
                if "Export Object Type" <> xRec."Export Object Type" then
                    "Export Object No." := 0;
            end;
        }
        field(23; "Export Object No."; Integer)
        {
            BlankZero = true;
            Caption = 'Export Object No.';
            TableRelation = AllObj."Object ID" where("Object Type" = field("Export Object Type"));

            trigger OnLookup()
            var
                lreObject: Record "Object";
                lfoObject: Page Objects;
            begin
                if lreObject.Get("Export Object Type", '', "Export Object No.") then
                    lfoObject.SetRecord(lreObject);
                lreObject.FilterGroup(2);
                lreObject.SetRange(Type, "Export Object Type");
                lreObject.SetRange("Company Name", '');
                lfoObject.SetTableView(lreObject);
                lfoObject.LookupMode(true);
                if lfoObject.RunModal = Action::LookupOK then begin
                    lfoObject.GetRecord(lreObject);
                    "Export Object No." := lreObject.ID;
                end else
                    Error('');
            end;

            trigger OnValidate()
            var
                lreObject: Record "Object";
            begin
            end;
        }
        field(25; "Import Path"; Text[250])
        {
            Caption = 'Import Path';
        }
        field(26; "Import File Type"; Text[3])
        {
            Caption = 'Import File Type';
        }
        field(27; "Import Object Type"; Option)
        {
            BlankZero = true;
            Caption = 'Import Object Type';
            InitValue = Dataport;
            OptionMembers = ,,,"Report",Dataport,"Codeunit";

            trigger OnValidate()
            begin
                if "Import Object Type" <> xRec."Import Object Type" then
                    "Import Object No." := 0;
            end;
        }
        field(28; "Import Object No."; Integer)
        {
            BlankZero = true;
            Caption = 'Import Object No.';
            TableRelation = AllObj."Object ID" where("Object Type" = field("Import Object Type"));

            trigger OnLookup()
            var
                lreObject: Record "Object";
                lfoObject: Page Objects;
            begin
                if lreObject.Get("Import Object Type", '', "Import Object No.") then
                    lfoObject.SetRecord(lreObject);
                lreObject.FilterGroup(2);
                lreObject.SetRange(Type, "Import Object Type");
                lreObject.SetRange("Company Name", '');
                lfoObject.SetTableView(lreObject);
                lfoObject.LookupMode(true);
                if lfoObject.RunModal = Action::LookupOK then begin
                    lfoObject.GetRecord(lreObject);
                    "Import Object No." := lreObject.ID;
                end else
                    Error('');
            end;
        }
        field(30; "Payment Order Domectics"; Integer)
        {
            BlankZero = true;
            Caption = 'Payment Order Domectics';

            trigger OnLookup()
            var
                lreObject: Record "Object";
                lfoObject: Page Objects;
            begin
                if lreObject.Get("import object type"::Report, '', "Payment Order Domectics") then
                    lfoObject.SetRecord(lreObject);
                lreObject.FilterGroup(2);
                lreObject.SetRange(Type, lreObject.Type::Report);
                lreObject.SetRange("Company Name", '');
                lfoObject.SetTableView(lreObject);
                lfoObject.LookupMode(true);
                if lfoObject.RunModal = Action::LookupOK then begin
                    lfoObject.GetRecord(lreObject);
                    "Payment Order Domectics" := lreObject.ID;
                end else
                    Error('');
            end;
        }
        field(31; "Payment Order International"; Integer)
        {
            BlankZero = true;
            Caption = 'Payment Order International';

            trigger OnLookup()
            var
                lreObject: Record "Object";
                lfoObject: Page Objects;
            begin
                if lreObject.Get("import object type"::Report, '', "Payment Order International") then
                    lfoObject.SetRecord(lreObject);
                lreObject.FilterGroup(2);
                lreObject.SetRange(Type, "import object type"::Report);
                lreObject.SetRange("Company Name", '');
                lfoObject.SetTableView(lreObject);
                lfoObject.LookupMode(true);
                if lfoObject.RunModal = Action::LookupOK then begin
                    lfoObject.GetRecord(lreObject);
                    "Payment Order International" := lreObject.ID;
                end else
                    Error('');
            end;
        }
        field(35; "Import Pyament Order Path"; Text[250])
        {
            Caption = 'Import Pyament Order Path';
        }
        field(36; "Import Payment Order File Type"; Text[3])
        {
            Caption = 'Import Payment Order File Type';
        }
        field(37; "Import Pay. Ord. Object Type"; Option)
        {
            BlankZero = true;
            Caption = 'Import Pay. Ord. Object Type';
            OptionMembers = ,,,"Report",Dataport,"Codeunit";

            trigger OnValidate()
            begin
                if "Import Pay. Ord. Object Type" <> xRec."Import Pay. Ord. Object Type" then
                    "Import Payment Order Object No" := 0;
            end;
        }
        field(38; "Import Payment Order Object No"; Integer)
        {
            BlankZero = true;
            Caption = 'Import Payment Order Object No';
            TableRelation = AllObj."Object ID" where("Object Type" = field("Import Pay. Ord. Object Type"));

            trigger OnLookup()
            var
                lreObject: Record "Object";
                lfoObject: Page Objects;
            begin
                if lreObject.Get("Import Pay. Ord. Object Type", '', "Import Payment Order Object No") then
                    lfoObject.SetRecord(lreObject);
                lreObject.FilterGroup(2);
                lreObject.SetRange(Type, "Import Pay. Ord. Object Type");
                lreObject.SetRange("Company Name", '');
                lfoObject.SetTableView(lreObject);
                lfoObject.LookupMode(true);
                if lfoObject.RunModal = Action::LookupOK then begin
                    lfoObject.GetRecord(lreObject);
                    "Import Payment Order Object No" := lreObject.ID;
                end else
                    Error('');
            end;
        }
        field(39; "Payment Transport Account"; Code[20])
        {
            Caption = 'Payment Transport Account';
            TableRelation = "G/L Account";
        }
        field(50; "Apply by Variable Symbol Neg."; Boolean)
        {
            Caption = 'Apply by Variable Symbol Neg.';
        }
        field(52; "Apply by Account No. Neg."; Boolean)
        {
            Caption = 'Apply by Account No. Neg.';
        }
        field(54; "Apply by Amount Neg."; Boolean)
        {
            Caption = 'Apply by Amount Neg.';
        }
        field(55; "Variable S. to Description"; Boolean)
        {
            Caption = 'Variable S. to Description';
        }
        field(56; "Insert Conv. LCY Rndg. Lines"; Boolean)
        {
            Caption = 'Insert Conv. LCY Rndg. Lines';
        }
        field(57; "Variable S. to Variable S."; Boolean)
        {
            Caption = 'Variable S. to Variable S.';
        }
        field(58; "Variable S.to External Doc.No."; Boolean)
        {
            Caption = 'Variable S.to External Doc.No.';
        }
        field(60; "Post Per Line"; Boolean)
        {
            Caption = 'Post Per Line';
        }
        field(70; "Diff.Apply Neg.and Pos Entries"; Boolean)
        {
            Caption = 'Diff.Apply Neg.and Pos Entries';
        }
        field(80; "Apply by Variable Symbol Poz."; Boolean)
        {
            Caption = 'Apply by Variable Symbol Poz.';
        }
        field(84; "Apply by Account No. Poz."; Boolean)
        {
            Caption = 'Apply by Account No. Poz.';
        }
        field(86; "Apply by Amount Poz."; Boolean)
        {
            Caption = 'Apply by Amount Poz.';
        }
        field(90; "Dimension from Apply Entry"; Boolean)
        {
            Caption = 'Dimension from Apply Entry';
        }
        field(100; "Check Ext. No. by Current Year"; Boolean)
        {
            Caption = 'Check Ext. No. by Current Year';
        }
        field(110; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
        }
        field(120; "Payment Partly Suggestion"; Boolean)
        {
            Caption = 'Payment Partly Suggestion';
        }
        field(130; "Foreign Payment Orders"; Boolean)
        {
            Caption = 'Foreign Payment Orders';
        }
        field(135; "Foreign Export Path"; Text[250])
        {
            Caption = 'Foreign Export Path';
        }
        field(140; "Foreign Export File Type"; Text[3])
        {
            Caption = 'Foreign Export File Type';
        }
        field(145; "Foreign Export Object Type"; Option)
        {
            BlankZero = true;
            Caption = 'Foreign Export Object Type';
            InitValue = Dataport;
            OptionMembers = ,,,"Report",Dataport,"Codeunit";

            trigger OnValidate()
            begin
                if "Foreign Export Object Type" <> xRec."Foreign Export Object Type" then
                    "Foreign Export Object No." := 0;
            end;
        }
        field(150; "Foreign Export Object No."; Integer)
        {
            BlankZero = true;
            Caption = 'Foreign Export Object No.';
            TableRelation = AllObj."Object ID" where("Object Type" = field("Foreign Export Object Type"));

            trigger OnLookup()
            var
                lreObject: Record "Object";
                lfoObject: Page Objects;
            begin
                if lreObject.Get("Foreign Export Object Type", '', "Foreign Export Object No.") then
                    lfoObject.SetRecord(lreObject);
                lreObject.FilterGroup(2);
                lreObject.SetRange(Type, "Foreign Export Object Type");
                lreObject.SetRange("Company Name", '');
                lfoObject.SetTableView(lreObject);
                lfoObject.LookupMode(true);
                if lfoObject.RunModal = Action::LookupOK then begin
                    lfoObject.GetRecord(lreObject);
                    "Foreign Export Object No." := lreObject.ID;
                end else
                    Error('');
            end;
        }
        field(160; "Payment Order Line Description"; Text[50])
        {
            Caption = 'Payment Order Line Description';
        }
        field(200; "Automatic Posting"; Boolean)
        {
            Caption = 'Automatic Posting';
        }
        field(210; "Check Czech Format on Issue"; Boolean)
        {
            Caption = 'Check Czech Format on Issue';
        }
        field(220; "Use Applying Templates"; Boolean)
        {
            Caption = 'Use Applying Templates';
        }
        field(250; "Not Show"; Boolean)
        {
            Caption = 'Not Show';
        }
    }

    keys
    {
        key(Key1; "Bank Account No.")
        {
            Clustered = true;
        }
    }
}
