Page 50286 "Intrastat Setup - Country"
{
    Caption = 'Intrastat Setup - Country';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Country/Region";

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
                field("EU Country/Region Code"; Rec."EU Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Intrastat Code"; Rec."Intrastat Code")
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
