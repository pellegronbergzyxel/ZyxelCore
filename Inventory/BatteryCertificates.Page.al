Page 50268 "Battery Certificates"
{
    Caption = 'Battery Certificates';
    Editable = false;
    PageType = List;
    SourceTable = "Battery Certificate";
    SourceTableView = order(descending);

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Date Imported"; Rec."Date Imported")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
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
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Rec."File Path" = '' then
                        Rec.DownloadDocument;
                    Rec.DownloadToClient();
                end;
            }
            action("Download Certificates")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Download Certificates';
                Image = Import;

                trigger OnAction()
                begin
                    if Confirm(lText001, true) then
                        Rec.DownloadDocument;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then;
    end;

    var
        lText001: label 'Do you want to download cerfiticates?';
}
