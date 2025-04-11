tableextension 50245 EmailItemZX extends "Email Item"
{
    fields
    {
        field(50000; "E-mail Address Code"; Code[10])
        {
            Caption = 'E-mail Address Code';
            Description = 'PAB 1.0';
            TableRelation = "E-mail address".Code;
        }
        field(50001; "E-mail Language Code"; Code[10])
        {
            Caption = 'E-mail Language Code';
            Description = 'PAB 1.0';
            TableRelation = Language.Code;
        }
    }
}
