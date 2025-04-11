tableextension 50108 GLAccountZX extends "G/L Account"
{
    fields
    {
        field(50000; "Cost Split Type"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(50001; "Cost Split Type Mandatory"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50005; Hidden; Boolean)
        {
            Caption = 'Hidden';
            Description = '03-01-19 ZY-LD 003';

            trigger OnValidate()
            begin
                //>> 03-01-19 ZY-LD 003
                if Rec.Hidden then
                    Rec.Blocked := Rec.Hidden;
                //<< 03-01-19 ZY-LD 003
            end;
        }
        field(50006; "Fixed Asset Account (Concur)"; Boolean)
        {
            Caption = 'Fixed Asset Account (Concur)';
            Description = '11-02-21 ZY-LD 005';
        }
        field(50010; "Name 2"; Text[30])
        {
        }
        field(50021; "RHQ G/L Account No."; Code[20])
        {
            Caption = 'RHQ G/L Account No.';
            Description = '13-06-18 ZY-LD 002';
        }
        field(50022; "RHQ G/L Account Name"; Text[50])
        {
            Description = '13-06-18 ZY-LD 002';
        }
    }
}
