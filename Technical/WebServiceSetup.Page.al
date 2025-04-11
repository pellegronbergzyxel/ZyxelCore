Page 50290 "Web Service Setup"
{
    // 001. 02-11-18 ZY-LD 2018110110000112 - DMY items is missing in the replication.
    // 002. 27-05-19 ZY-LD P0213 - Force replication on customers.

    ApplicationArea = Basic, Suite;
    Caption = 'Web Service Setup';
    PageType = List;
    SourceTable = "Web Service Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Trace Mode"; Rec."Trace Mode")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Test Name"; Rec."Test Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(HTTP; Rec.HTTP)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the value of the User Name field.';
                    Visible = false;
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.';
                    Visible = false;
                }
                field("Server Name"; Rec."Server Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Port No."; Rec."Port No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Tier Name"; Rec."Service Tier Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("HTTP (Test)"; Rec."HTTP (Test)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Server Name (Test)"; Rec."Server Name (Test)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Port No. (Test)"; Rec."Port No. (Test)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Tier Name (Test)"; Rec."Service Tier Name (Test)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("HTTP (Dev)"; Rec."HTTP (Dev)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Server Name (Dev)"; Rec."Server Name (Dev)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Port No. (Dev)"; Rec."Port No. (Dev)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Service Tier Name (Dev)"; Rec."Service Tier Name (Dev)")
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
    }

    var
        ZyxelHQWebServiceRequest: Codeunit "Zyxel HQ Web Service Request";
        Text001: label 'Do you want to run?';
        ZyxelWebServiceRequest: Codeunit "Zyxel Web Service Request";
        ZyxelWebServiceManagement: Codeunit "Zyxel Web Service Management";
        ZGT: Codeunit "ZyXEL General Tools";
}
