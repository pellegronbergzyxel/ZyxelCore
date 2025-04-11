Table 50102 "Convert Characters"
{
    Caption = 'Convert Characters';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "From Character"; Text[1])
        {
        }
        field(3; "To Charracter"; Text[1])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure ConvertCharacters(pString: Text) rValue: Text
    var
        lConvChar: Record "Convert Characters";
    begin
        rValue := StripControlChars(pString);
        if lConvChar.FindSet then
            repeat
                if StrPos(rValue, lConvChar."From Character") <> 0 then
                    rValue := ConvertStr(rValue, lConvChar."From Character", lConvChar."To Charracter");
            until lConvChar.Next() = 0;
    end;


    procedure StripControlChars(InputString: Text) OutputString: Text
    var
        cr: Char;
        lf: Char;
        tab: Char;
    begin
        cr := 13;
        lf := 10;
        tab := 9;
        InputString := DelChr(InputString, '=', Format(cr));
        InputString := DelChr(InputString, '=', Format(lf));
        InputString := DelChr(InputString, '=', Format(tab));
        OutputString := InputString;
    end;
}
