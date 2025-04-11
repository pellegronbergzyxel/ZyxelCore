Page 50345 "Battery Certificate FactBoc"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Battery Certificate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Date Imported"; Rec."Date Imported")
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
            action("Show Certificate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Certificate';
                Image = Certificate;

                trigger OnAction()
                begin
                    if Rec."File Path" = '' then
                        Rec.DownloadDocument;
                    Hyperlink(Rec.GetFilename);
                end;
            }
            action(Download)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Download';
                Image = Export;

                trigger OnAction()
                begin
                    Rec.DownloadToClient;
                end;
            }
        }
    }

    var
        FileMgt: Codeunit "File Management";
}
