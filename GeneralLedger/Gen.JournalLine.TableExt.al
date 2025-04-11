tableextension 50123 GenJournalLineZX extends "Gen. Journal Line"
{
    fields
    {
        field(13650; "Giro Acc. No."; Code[10])
        {
            Caption = 'Giro Acc. No.';

            trigger OnValidate()
            begin
                if Rec."Giro Acc. No." <> '' then
                    Rec."Giro Acc. No." := PadStr('', MaxStrLen(Rec."Giro Acc. No.") - StrLen(Rec."Giro Acc. No."), '0') + Rec."Giro Acc. No.";
            end;
        }
        field(50000; "Posted from Cash Reg"; Boolean)
        {
            Caption = 'Posted from Cash Reg';
            Description = 'CO4.20.1';
        }
        field(50001; "Performance Country Code"; Code[10])
        {
            Caption = 'Performance Country Code';
            Description = 'CO4.20.1';
            TableRelation = if ("Account Type" = const(Customer)) "Registration Country"."Country Code" where(Type = const(Customer),
                                                                                                             "No." = field("Account No."))
            else
            if ("Account Type" = const(Vendor)) "Registration Country"."Country Code" where(Type = const(Vendor),
                                                                                                                                                                                                 "No." = field("Account No."));

            trigger OnValidate()
            begin
                //CO4.20: Controling - Basic: Firm Registration More Country;
                if Rec."Performance Country Code" <> '' then begin
                    Rec."Currency Code VAT" := Rec."Currency Code";
                    Rec."Currency Factor VAT" := Rec."Currency Factor";
                end else begin
                    Rec."Currency Code VAT" := '';
                    Rec."Currency Factor VAT" := 0;
                end;
                //CO4.20
            end;
        }
        field(50002; "Currency Factor VAT"; Decimal)
        {
            Caption = 'Currency Factor VAT';
            DecimalPlaces = 0 : 15;
            Description = 'CO4.20.1';
            Editable = false;
            MinValue = 0;
        }
        field(50003; "Currency Code VAT"; Code[10])
        {
            Caption = 'Currency Code VAT';
            Description = 'CO4.20.1';
        }
        field(50004; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            Description = 'CO4.20.1';
            TableRelation = "Item Ledger Entry";
        }
        field(50005; "VAT Settlement Date"; Date)
        {
            Caption = 'VAT Date';
        }
        field(50006; "Sales Order posted in RHQ"; Boolean)
        {
            Description = 'ZY2.0 - Auto Purchase Journal routine';
        }
        field(50007; "Cost Split Type"; Code[20])
        {
        }
        field(50008; "Shortcut Dimension 3 Code"; Code[20])
        {
            Description = 'RD 1.0 CZ import journal lines';
        }
        field(50009; "Shortcut Dimension 4 Code"; Code[20])
        {
            Description = 'RD 1.0 CZ import journal lines';
        }
        field(50010; "Advanced Payment No."; Text[30])
        {
            Description = 'PAB 1.0';
        }
        field(50011; "Vendor Full Name"; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Account No.")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
    }
}
