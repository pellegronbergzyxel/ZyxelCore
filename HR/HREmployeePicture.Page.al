Page 50184 "HR Employee Picture"
{
    Caption = 'Employee Picture';
    DeleteAllowed = true;
    InsertAllowed = true;
    LinksAllowed = false;
    PageType = CardPart;
    SaveValues = true;
    ShowFilter = false;
    SourceTable = "ZyXEL Employee";

    layout
    {
        area(content)
        {
            field(Picture; Rec.Picture)
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("New Picture")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'New Picture';
                Image = Picture;
                ToolTip = 'Assign a new picture to this employee';

                trigger OnAction()
                var
                    FileMgt: Codeunit "File Management";
                    SelectedFile: Text[250];
                begin
                    SelectedFile := FileMgt.UploadFileWithFilter('New Employee Picture', SelectedFile, 'Image Files(*.BMP;*.JPG;*.GIF)|*.BMP;*.JPG;*.GIF|Bitmap files (*.BMP)|*.BMP|PNG files (*.PNG)|*.PNG|JPEG files (*.JPG)|*.JPG|GIF files (*.GIF)|*.GIF|All files (*.*)|*.*', '*.BMP;*.JPG;*.GIF');
                    if SelectedFile <> '' then begin
                        Rec.Picture.Import(SelectedFile);
                        Rec.Modify;
                    end;
                end;
            }
            action(Delete)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete';
                Image = Delete;
                ToolTip = 'Delete the employee picture';

                trigger OnAction()
                begin
                    if Rec.Picture.Hasvalue then begin
                        if Confirm('Are you sure that you want to delete the Employees picture?', false) = false then exit
                    end;
                    Rec.CalcFields(Picture);
                    Clear(Rec.Picture);
                    Rec.Modify;
                end;
            }
        }
    }
}
