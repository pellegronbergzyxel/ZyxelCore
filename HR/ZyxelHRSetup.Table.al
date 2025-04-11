Table 62017 "Zyxel HR Setup"
{
    // 001. 18-09-19 ZY-LD 2019082810000121 - New field.

    Caption = 'Zyxel HR Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(11; "Probation Reminder"; DateFormula)
        {
            Caption = 'Probation Reminder';
        }
        field(12; "Probation Reminder 2"; DateFormula)
        {
            Caption = 'Probation Reminder 2';
        }
        field(13; "Leaving Reminder"; DateFormula)
        {
            Caption = 'Leaving Reminder';
        }
        field(14; "Leaving Reminder 2"; DateFormula)
        {
            Caption = 'Leaving Reminder 2';
        }
        field(15; "Probation E-mail Code"; Code[10])
        {
            Caption = 'Probation E-mail Code';
            TableRelation = "E-mail address";
        }
        field(16; "Leaving E-mail Code"; Code[10])
        {
            Caption = 'Leaving E-mail Code';
            TableRelation = "E-mail address";
        }
        field(17; "Long Service Ann. E-mail Code"; Code[10])
        {
            Caption = 'Long Service Anniversary E-mail Code';
            Description = '18-09-19 ZY-LD 001';
            TableRelation = "E-mail address";
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
