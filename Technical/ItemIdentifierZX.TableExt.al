tableextension 50005 ItemIdentifierZX extends "Item Identifier"
{
    fields
    {
        field(50000; ExtendedCodeZX; Code[30])
        {
            Caption = 'Extended Code';
            DataClassification = CustomerContent;
        }
        modify(Code)
        {
            trigger OnAfterValidate()
            begin
                if ExtendedCodeZX = '' then begin
                    ExtendedCodeZX := Code;
                    if modify(false) then;
                end;
            end;
        }
    }
}
