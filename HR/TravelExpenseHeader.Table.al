Table 50118 "Travel Expense Header"
{
    Caption = 'Travel Expense Header';
    DrillDownPageID = "Travel Expense List";
    LookupPageID = "Travel Expense List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Concur Report Name"; Text[50])
        {
            Caption = 'Concur Report Name';
        }
        field(3; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(4; "Concur Report ID"; Code[20])
        {
            Caption = 'Concur Report ID';
        }
        field(11; "Concur Batch ID"; Code[10])
        {
            Caption = 'Concur Batch ID';
        }
        field(12; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(13; "Cost Type Name"; Code[20])
        {
            Caption = 'Cost Type Name';
            TableRelation = "Cost Type Name";
        }
        field(14; "Employee Name"; Text[50])
        {
            CalcFormula = lookup("Cost Type Name".Name where(Code = field("Cost Type Name")));
            Caption = 'Employee Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Concur Company Name"; Text[20])
        {
            Caption = 'Concur Company Name';
            TableRelation = Company;
            ValidateTableRelation = false;
        }
        field(16; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          Blocked = const(false));
        }
        field(17; Amount; Decimal)
        {
            CalcFormula = sum("Travel Expense Line".Amount where("Document No." = field("No."),
                                                                  "Show Expense" = const(true)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Currency Code"; Code[10])
        {
            CalcFormula = lookup("Travel Expense Line"."Currency Code" where("Document No." = field("No.")));
            Caption = 'Currency Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "G/L Document No."; Code[20])
        {
            Caption = 'G/L Document No.';
        }
        field(20; Open; Boolean)
        {
            CalcFormula = max("Travel Expense Line".Open where("Document No." = field("No.")));
            Caption = 'Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Document Status"; Option)
        {
            Caption = 'Document Status';
            OptionCaption = 'Importing,Open,Released,Posted,Transferred,Mailed';
            OptionMembers = Importing,Open,Released,Posted,Transferred,Mailed;
        }
        field(23; "Importing Date"; DateTime)
        {
            Caption = 'Importing Date';
        }
        field(24; "G/L Posting Date"; Date)
        {
        }
        field(25; "Debit Amount"; Decimal)
        {
            CalcFormula = sum("Travel Expense Line".Amount where("Document No." = field("No."),
                                                                  "Debit / Credit Type" = const(DR),
                                                                  "Show Expense" = const(true)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Credit Amount"; Decimal)
        {
            CalcFormula = sum("Travel Expense Line".Amount where("Document No." = field("No."),
                                                                  "Debit / Credit Type" = const(CR),
                                                                  "Show Expense" = const(true)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Concur Company Name")
        {
        }
        key(Key3; "G/L Document No.", "G/L Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Concur Report Name")
        {
        }
    }

    trigger OnDelete()
    var
        TravelExpenseLine: Record "Travel Expense Line";
    begin
        TravelExpenseLine.SetRange("Document No.", "No.");
        TravelExpenseLine.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        recConcurSetup: Record "Concur Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            recConcurSetup.Get;
            recConcurSetup.TestField("Travel Expense Nos.");
            NoSeriesMgt.InitSeries(recConcurSetup."Travel Expense Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";


    procedure AssistEdit(): Boolean
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        recConcurSetup: Record "Concur Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        recConcurSetup.Get;
        recConcurSetup.TestField("Travel Expense Nos.");
        if NoSeriesMgt.SelectSeries(recConcurSetup."Travel Expense Nos.", xRec."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;


    procedure SetToTransferred()
    var
        lText001: label 'Do you want to set "%1" to transferred?';
    begin
        if Confirm(lText001, false, "No.") then begin
            "Document Status" := "document status"::Transferred;
            Modify(true);
        end;
    end;
}
