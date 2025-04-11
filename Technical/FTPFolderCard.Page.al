Page 50048 "FTP Folder Card"
{
    Caption = 'FTP Setup Card';
    PageType = Card;
    SourceTable = "FTP Folder";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control8)
                {
                    ShowCaption = false;
                    field("Code"; Rec.Code)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Server Environment"; Rec."Server Environment")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Direction; Rec.Direction)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Active; Rec.Active)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Secure; Rec.Secure)
                    {
                        ApplicationArea = Basic, Suite;
                        trigger OnValidate()
                        begin
                            SetActions();
                        end;
                    }
                    field("Use Passive"; Rec."Use Passive")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }

                group(Control21)
                {
                    ShowCaption = false;
                    field(Hostname; Rec.Hostname)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Protocol; Rec.Protocol)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = SftpPortNoEditable;
                    }
                    field("SFTP Port No."; Rec."SFTP Port No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = SftpPortNoEditable;
                    }
                    field(Username; Rec.Username)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Password; Rec.Password)
                    {
                        ApplicationArea = Basic, Suite;
                        ExtendedDatatype = Masked;
                    }
                }
            }
            group(Folder)
            {
                Caption = 'Folder and File';
                group(Control18)
                {
                    ShowCaption = false;
                    field("Remote Folder"; Rec."Remote Folder")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Delete Remote"; Rec."Delete Remote")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Control19)
                {
                    ShowCaption = false;
                    field("Archive Local File"; Rec."Archive Local File")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Archive Folder"; Rec."Archive Folder")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Accept Creation of Sub Folder"; Rec."Accept Creation of Sub Folder")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Test Connection")
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
        area(navigation)
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
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
    }

    trigger OnOpenPage()
    begin
        SetActions();
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();
    end;

    procedure SetActions()
    Begin
        SftpPortNoEditable := Rec.Secure;
    End;

    var
        //FtpMgt: Codeunit "VisionFTP Management";
        //FileMgt: Codeunit "File Management";
        SftpPortNoEditable: Boolean;
}
