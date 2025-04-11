Page 50243 "EiCard Link Subform"
{
    Caption = 'EiCard Link Subform';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "EiCard Link Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Link; Rec.Link)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Filename; Rec.Filename)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Size (MB)"; Rec."Size (MB)")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show File")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show File';
                Image = ExportFile;

                trigger OnAction()
                begin
                    Hyperlink(Rec.Filename);
                end;
            }
            action("Download File")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Download File';
                Image = WorkCenterLoad;

                trigger OnAction()
                begin
                    Rec.DownloadFile;
                end;
            }
        }
    }
}
