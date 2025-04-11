Page 50227 "Company Contract Tag FactBox"
{
    Caption = 'Contract Tags';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Customer Contract Tag";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Tag; Rec.Tag)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Remove Tag")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Remove Tag';
                Image = Delete;

                trigger OnAction()
                begin
                    Rec.Delete();
                    CurrPage.Update();
                end;
            }
        }
    }
}
