Page 50046 "VCK Ship Resp. SNos FaxtBox"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Ship Responce Serial Nos.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Identical Serial Numbers"; Rec."Identical Serial Numbers")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}
