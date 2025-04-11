pageextension 50284 ConfigTemplateSubformZX extends "Config. Template Subform"
{
    layout
    {
        addafter(Type)
        {
            field("Field ID"; Rec."Field ID")
            {
                ApplicationArea = Basic, Suite;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    FieldIDLookup;  // 15-03-18 ZY-LD 001
                end;
            }
        }
    }

    local procedure FieldIDLookup()
    var
        recField: Record "Field";
    begin
        //>> 15-03-18 ZY-LD 001
        if Rec.Type = Rec.Type::field then begin
            recField.SetRange(TableNo, Rec."Table ID");
            if Page.RunModal(Page::"Fields Lookup", recField) = Action::LookupOK then
                Rec.Validate(Rec."Field ID", recField."No.");
        end;
        //<< 15-03-18 ZY-LD 001
    end;
}
