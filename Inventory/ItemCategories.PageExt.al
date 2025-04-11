pageextension 50246 ItemCategoriesZX extends "Item Categories"
{
    Caption = 'Category 1 Code';
    Editable = false;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Blocked, false);
    end;
}
