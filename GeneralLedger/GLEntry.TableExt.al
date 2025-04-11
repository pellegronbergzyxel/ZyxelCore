tableextension 50109 GLEntryZX extends "G/L Entry"
{
    fields
    {
        field(50000; "Related Company"; Boolean)
        {
            CalcFormula = lookup(Customer."Related Company" where("No." = field("Source No.")));
            Caption = 'Related Company ';
            Description = '01-09-20 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "Applied Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Detailed G/L Entry".Amount where("G/L Entry No." = field("Entry No."),
                                                                "Posting Date" = field("Date Filter")));
            Caption = 'Applied Amount';
            Description = 'CO4.20';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = 'CO4.20';
            FieldClass = FlowFilter;
        }
        field(50012; "Applies-to ID"; Code[20])
        {
            Caption = 'Applies-to ID';
            Description = 'CO4.20';

            trigger OnValidate()
            begin
                //CO4.20: Controling - Basic: Applying G/L Entries;
                Rec.TestField(Rec.Closed, false);
                //CO4.20
            end;
        }
        field(50013; Closed; Boolean)
        {
            Caption = 'Closed';
            Description = 'CO4.20';
        }
        field(50014; "Applying Entry"; Boolean)
        {
            Caption = 'Applying Entry';
            Description = 'CO4.20';
        }
        field(50015; "Amount to Apply"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount to Apply';
            Description = 'CO4.20';

            trigger OnValidate()
            var
                ltcText000: Label 'must have the same sign as %1';
                ltcText001: Label 'must not be larger than %1';
            begin
                //CO4.20: Controling - Basic: Applying G/L Entries;
                Rec.TestField(Rec.Closed, false);
                if Rec."Amount to Apply" * Rec.Amount < 0 then
                    Rec.FieldError(Rec."Amount to Apply", StrSubstNo(ltcText000, Rec.FieldCaption(Rec.Amount)));

                if Abs(Rec."Amount to Apply") > Abs(Rec.Amount) then
                    Rec.FieldError(Rec."Amount to Apply", StrSubstNo(ltcText001, Rec.FieldCaption(Rec.Amount)));
                //CO4.20
            end;
        }
        field(50020; Country; Code[20])
        {
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Dimension Code" = const('COUNTRY')));
            Caption = 'Country Code';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50021; "Cost Type"; Code[20])
        {
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Dimension Code" = const('COSTTYPE')));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50022; "Ignore Country Dimension"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50023; "Ignore Cost Type Dimension"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50024; Blocked; Boolean)
        {
            CalcFormula = lookup("G/L Account".Blocked where("No." = field("G/L Account No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50025; "Return Reason Code"; Code[10])
        {
            CalcFormula = lookup("Item Ledger Entry"."Return Reason Code" where("Document No." = field("Document No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        // field(50026; "Remaining Amount"; Decimal)
        // {
        //     Caption = 'Remaining Amount';
        //     Editable = false;
        //     BlankZero = true;
        //     FieldClass = FlowField;
        //     CalcFormula = sum("G/L Entry".Amount where("Reviewed Identifier" = field("Reviewed Identifier")));//,
        //                                                                                                       //                          "Entry No." = field("Entry No. Filter")));
        // }
    }

    keys
    {
        key(ZKey1; "G/L Account No.", "Gen. Posting Type", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date")
        {
        }
    }
}
