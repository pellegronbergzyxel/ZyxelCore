page 50203 "HR Role History Card"
{
    // 001. 03-05-18 ZY-LD 2018050310000201 - New field.
    // 002. 07-06-18 ZY-LD 2018060410000242 - New field.

    Caption = 'Role / Job Details';
    DataCaptionFields = "Employee No.", "Job Title";
    PageType = Card;
    PopulateAllFields = true;
    SaveValues = true;
    SourceTable = "HR Role History";

    layout
    {
        area(content)
        {
            group(General)
            {
                group(Role)
                {
                    Caption = 'Role';
                    field("Start Date"; Rec."Start Date")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("End Date"; Rec."End Date")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Job Title"; Rec."Job Title")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Job Specification"; Rec."Job Specification")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Job Specification Attached';
                    }
                    field("Employee Type"; Rec."Employee Type")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Third Party Staff"; Rec."Third Party Staff")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Manager)
                {
                    Caption = 'Manager';
                    field("People Manager"; Rec."People Manager")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Line Manager"; Rec."Line Manager")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Line Manager Name"; Rec."Line Manager Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Vice President No."; Rec."Vice President No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Vice President Name"; Rec."Vice President Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Department)
                {
                    Caption = 'Department';
                    field(Control6; Rec.Department)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Division; Rec.Division)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Cost Centre"; Rec."Cost Centre")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Hours)
                {
                    Caption = 'Hours';
                    field("Employment Hours Type"; Rec."Employment Hours Type")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Part Time Hours Per Week"; Rec."Part Time Hours Per Week")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Full Time Hours Per Week"; Rec."Full Time Hours Per Week")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Working Pattern"; Rec."Working Pattern")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Overtime Paid"; Rec."Overtime Paid")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(FTE; Rec.FTE)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Tracking Document")
                {
                    Caption = 'Tracking Document';
                    field("Tracking Document Id"; Rec."Tracking Document Id")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Tracking Document Attached"; Rec."Tracking Document Attached")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000001; Links)
            {
                Visible = true;
            }
            systempart(Control1000000000; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            Action("Co&mments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Human Resource Comment Sheet";
                RunPageLink = "Table Name" = const("Human Resources Comment Table Name"::"HR Role History"),
                                  "Table Line No." = field(UID);
            }
            Action("Working Patterns")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Working Patterns';
                Image = ChangeDate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "HR Working Pattern List";
                ToolTip = 'Edit List of Working Patterns used by the HR module';
            }
        }
    }
}
