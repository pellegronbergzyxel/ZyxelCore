Page 50006 "Invoice Description Card"
{
    Caption = 'Invoice Description Card';
    PageType = Card;
    SourceTable = "Invoice Description";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            part(Control6; "Invoice Line Text Subform")
            {
                SubPageLink = "Invoice Description Code" = field(Code);
            }
        }
    }

    actions
    {
    }
}
