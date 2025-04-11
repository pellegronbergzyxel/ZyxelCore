pageextension 50198 ItemAvailByLocationLinesZX extends "Item Avail. by Location Lines"
{
    trigger OnOpenPage()
    begin
        Rec.SetRange("Use As In-Transit", false);
        Rec.SetRange("In Use", true);
        Rec.SetFilter("Include in Item Availability", '%1|%2', Rec."Include in Item Availability"::EMEA, Rec."Include in Item Availability"::"OLAP & EMEA");
        if Rec.FindFirst() then;
    end;
}
