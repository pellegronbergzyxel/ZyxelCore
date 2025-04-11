page 50320 "FTP Folders"
{
    ApplicationArea = Basic, Suite;
    Caption = 'FTP Setup';
    CardPageID = "FTP Folder Card";
    DataCaptionExpression = Rec.Code;
    Description = 'FTP Folders List';
    Editable = false;
    PageType = List;
    SourceTable = "FTP Folder";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Server Environment"; Rec."Server Environment")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Hostname; Rec.Hostname)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Username; Rec.Username)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Direction; Rec.Direction)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Local Folder"; Rec."Local Folder")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Remote Folder"; Rec."Remote Folder")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Delete Local File"; Rec."Delete Local File")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Archive Local File"; Rec."Archive Local File")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Archive Folder"; Rec."Archive Folder")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("File Mask"; Rec."File Mask")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Delete Remote"; Rec."Delete Remote")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Secure; Rec.Secure)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Use Passive"; Rec."Use Passive")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(VCK; Rec.VCK)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            Action(Action12)
            {
                Caption = 'Zyxel File Management Entries';
                ApplicationArea = Basic, Suite;
                Image = Entries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Zyxel File Management Entries";
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                Action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field(Code);
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(62016));
                }
            }
        }
        area(processing)
        {
            Action("Test Connection")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Test Connection';
                Image = TestFile;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.TestConnection;
                end;
            }
        }
    }

    var
        FtpMgt: Codeunit "VisionFTP Management";
}
