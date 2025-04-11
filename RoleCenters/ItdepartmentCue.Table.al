Table 50061 "It department Cue"
{
    Caption = 'It department Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Enabled Users"; Integer)
        {
            CalcFormula = count(User where(State = const(Enabled),
                                            "Expiry Date" = field("Date Filter Today.."),
                                            "Contact Email" = filter('')));
            Caption = 'Enabled Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Disabled Users"; Integer)
        {
            CalcFormula = count(User where(State = const(Disabled),
                                            "Contact Email" = filter('')));
            Caption = 'Disabled Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Expired Users"; Integer)
        {
            CalcFormula = count(User where(State = const(Enabled),
                                            "Expiry Date" = field("Date Filter ..Today"),
                                            "Contact Email" = filter('')));
            Caption = 'Expired Users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "System Accounts"; Integer)
        {
            CalcFormula = count(User where(State = const(Enabled),
                                            "Expiry Date" = field("Date Filter Today.."),
                                            "Contact Email" = filter(<> '')));
            Caption = 'System Accounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Date Filter ..Today"; DateTime)
        {
            Caption = 'Date Filter ..Today';
            FieldClass = FlowFilter;
        }
        field(52; "Date Filter Today.."; DateTime)
        {
            Caption = 'Date Filter Today..';
            FieldClass = FlowFilter;
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
