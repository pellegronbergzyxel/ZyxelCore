Page 50038 "Company Logo"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    ShowFilter = false;
    SourceTable = "Company Information";

    layout
    {
        area(content)
        {
            field("Logo Screen"; Rec."Logo Screen")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Enabled = false;
                ShowCaption = false;
            }
        }
    }
}
