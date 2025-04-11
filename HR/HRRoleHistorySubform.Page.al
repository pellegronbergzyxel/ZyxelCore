Page 50201 "HR Role History Subform"
{
    // 001. 03-05-18 ZY-LD 2018050310000201 - New field.
    // 002. 05-06-18 ZY-LD 2018060410000242 - New fields.

    Caption = 'Role / Job Details';
    CardPageID = "HR Role History Card";
    DataCaptionFields = "Employee No.";
    PageType = ListPart;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "HR Role History";
    SourceTableView = sorting("Employee No.", "Start Date")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field(Division; Rec.Division)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Cost Centre"; Rec."Cost Centre")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("People Manager"; Rec."People Manager")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Line Manager"; Rec."Line Manager")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Line Manager Name"; Rec."Line Manager Name")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Vice President No."; Rec."Vice President No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Vice President Name"; Rec."Vice President Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Employment Hours Type"; Rec."Employment Hours Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Part Time Hours Per Week"; Rec."Part Time Hours Per Week")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Full Time Hours Per Week"; Rec."Full Time Hours Per Week")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Working Pattern"; Rec."Working Pattern")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Overtime Paid"; Rec."Overtime Paid")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field(FTE; Rec.FTE)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Job Specification"; Rec."Job Specification")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Specification Attached';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50203, Rec);
                    end;
                }
                field("Third Party Staff"; Rec."Third Party Staff")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tracking Document Id"; Rec."Tracking Document Id")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Tracking Document Attached"; Rec."Tracking Document Attached")
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
            action("Co&mments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Human Resource Comment Sheet";
                RunPageLink = "Table Name" = const("Human Resources Comment Table Name"::"HR Role History"),
                              "Table Line No." = field(UID);
            }
            action(Edit)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit';
                Image = Edit;
                RunObject = Page "HR Role History Card";
                RunPageLink = UID = field(UID),
                              "Employee No." = field("Employee No."),
                              "Job Title" = field("Job Title"),
                              "Start Date" = field("Start Date");
                ShortCutKey = 'Shift+Ctrl+e';
            }
        }
    }
}
