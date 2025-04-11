Page 50287 "Intrastat Setup - Location"
{
    Caption = 'Intrastat Setup - Location';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Location;
    SourceTableView = where("In Use" = const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
