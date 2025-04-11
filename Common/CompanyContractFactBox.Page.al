page 50248 "Company Contract FactBox"
{
    Caption = 'Company Contract FactBox';
    Editable = false;
    PageType = ListPart;
    Permissions = TableData "Customer Contract" = m;
    SourceTable = "Customer Contract";
    SourceTableView = where(Status = filter(<> Cancled));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Filename; Rec.Filename)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Comment; Rec.Comment)
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
            action("Download")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Download';
                Image = Document;

                trigger OnAction()
                begin
                    Rec.DownloadToClient();
                end;
            }
        }
    }
}
