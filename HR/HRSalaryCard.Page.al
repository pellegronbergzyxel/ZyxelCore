Page 50183 "HR Salary Card"
{
    Caption = 'Salary';
    DataCaptionFields = "Employee No.", "Full Name";
    Description = 'Salary';
    InsertAllowed = true;
    InstructionalText = 'Please enter salary details below. If this is a first salary entry, please leave the "To Date" blank.';
    PageType = Card;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SaveValues = true;
    ShowFilter = false;
    SourceTable = "HR Salary Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Valid From"; Rec."Valid From")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Valid To"; Rec."Valid To")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Base Salary P.A."; Rec."Base Salary P.A.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Commission Pay P.A."; Rec."Commission Pay P.A.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Salary Reimbursement"; Rec."Salary Reimbursement")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No of Salaries - Decimal"; Rec."No of Salaries - Decimal")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(KPI)
                {
                    Caption = 'KPI';
                    field("KPI Plan Payment"; Rec."KPI Plan Payment")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("KPI Plan Attached"; Rec."KPI Plan Attached")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("KPI Holdback %"; Rec."KPI Holdback %")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Company Car")
                {
                    Caption = 'Company Car';
                    field("Car Allowance P.A."; Rec."Car Allowance P.A.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Company Car P.A."; Rec."Company Car P.A.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Car Level"; Rec."Car Level")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Car Registration No"; Rec."Car Registration No")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Car Leasing Company"; Rec."Car Leasing Company")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Car Lease Valid From"; Rec."Car Lease Valid From")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Car Lease Valid To"; Rec."Car Lease Valid To")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000000; Links)
            {
                Visible = true;
            }
            systempart(Control1000000001; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Salary)
            {
                Caption = 'Salary';
                Image = Absence;
                action("Co&mments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = const("Human Resources Comment Table Name"::"HR Salary Line"),
                                  "Table Line No." = field(UID);
                }
                action("Car Levels")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Car Levels';
                    Image = Delivery;
                    RunObject = Page "HR Car Levels List";
                    ToolTip = 'Edit List of Car Levels used by the HR module';
                }
            }
        }
    }

}
