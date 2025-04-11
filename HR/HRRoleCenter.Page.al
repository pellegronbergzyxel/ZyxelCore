Page 50208 "HR Role Center"
{
    // 001. 26-06-19 ZY-LD 2019062410000088 - New activity buttons.

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part("HR Activities"; "HR Activities")
                {
                    Caption = 'Activities';
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Employee - Staff Absences")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Staff Absences';
                Image = "Report";
                RunObject = Report "Employee - Staff Absences";
            }
            action("Employee - Absences by Causes")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Absences by Causes';
                Image = "Report";
                RunObject = Report "Employee - Absences by Causes";
            }
            action("Employee - Addresses")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Addresses';
                Image = "Report";
                RunObject = Report "Employee - Addresses";
            }
            action("Employee - Birthdays")
            {
                ApplicationArea = Basic, Suite;
                Caption = ' Birthdays';
                Image = "Report";
                RunObject = Report "Employee - Birthdays";
            }
            action("Employee - Contracts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contracts';
                Image = "Report";
                RunObject = Report "Employee - Contracts";
            }
            action("Employee - Labels")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Labels';
                Image = "Report";
                RunObject = Report "Employee - Labels";
            }
            action("Employee - List")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employee List';
                Image = "Report";
                RunObject = Report "Employee - List";
            }
            action("Employee - Misc. Article Info.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Misc. Article Info.';
                Image = "Report";
                RunObject = Report "Employee - Misc. Article Info.";
            }
            action("Employee - Phone Nos.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Phone Nos.';
                Image = "Report";
                RunObject = Report "Employee - Phone Nos.";
            }
            action("Employee - Qualifications")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Qualifications';
                Image = "Report";
                RunObject = Report "Employee - Qualifications";
            }
            action("Import KPI / Bonus")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import KPI / Bonus';
                RunObject = Report "Import HR KPI/Bonus";
            }
        }
        area(embedding)
        {
            action("Zyxel Employees")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employees';
                Image = Employee;
                RunObject = Page "Zyxel HR Employee List";
            }
        }
        area(processing)
        {
            group(General)
            {
                Caption = 'General';
                action("HR Employee List1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Employees';
                    Image = Employee;
                    RunObject = Page "Zyxel HR Employee List";
                    Visible = false;
                }
                action("HR Absence Registration1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Absence Registration';
                    Image = Absence;
                    RunObject = Page "Absence Registration";
                    Visible = false;
                }
                action(Action45)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import KPI / Bonus';
                    Image = ImportExcel;
                    RunObject = Report "Import HR KPI/Bonus";
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action("Human Res. Units of Measure1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Units of Measure';
                    Image = UnitOfMeasure;
                    RunObject = Page "Human Res. Units of Measure";
                }
                action("HR Causes of Absence1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Causes of Absence';
                    Image = AbsenceCategories;
                    RunObject = Page "Causes of Absence";
                }
                action("HR Disiplinary Code List1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Disciplinary Codes';
                    Image = Warning;
                    RunObject = Page "HR Disiplinary Code List";
                    ToolTip = 'Edit List of Disciplinary Codes used by the HR module';
                }
                action("HR Grounds for Termination1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Grounds for Termination';
                    Image = TerminationDescription;
                    RunObject = Page "Grounds for Termination";
                }
                action("HR Employment Contracts1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Employment Contracts';
                    Image = EmployeeAgreement;
                    RunObject = Page "Employment Contracts";
                }
                action("HR Relatives1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Relatives';
                    Image = Relatives;
                    RunObject = Page Relatives;
                }
                action("HR Misc. Articles1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Misc. Articles';
                    Image = Documents;
                    RunObject = Page "Misc. Articles";
                }
                action("HR Confidential1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Confidential';
                    Image = ConfidentialOverview;
                    RunObject = Page Confidential;
                }
                action("HR Qualifications1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    RunObject = Page Qualifications;
                }
                action("HR Employee Statistics Groups1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Employee Statistics Groups';
                    Image = Statistics;
                    RunObject = Page "Employee Statistics Groups";
                }
                action("HR Company List1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Companies';
                    Image = Company;
                    RunObject = Page "HR Offices List";
                }
                action("HR Department List1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Departments';
                    Image = IntercompanyOrder;
                    RunObject = Page "HR Department List";
                }
                action("HR Division List1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Divisions';
                    Image = CustomerGroup;
                    RunObject = Page "HR Division List";
                }
                action("HR Cost Center List1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cost Centers';
                    Image = CostCenter;
                    RunObject = Page "HR Cost Center List";
                }
                action("HR Working Pattern List1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Working Patterns';
                    Image = ServiceHours;
                    RunObject = Page "HR Working Pattern List";
                }
                action("HR Car Levels List1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Car Levels';
                    Image = Delivery;
                    RunObject = Page "HR Car Levels List";
                }
                action("HR Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'HR Setup';
                    Image = Setup;
                    RunObject = Page "Zyxel HR Setup";
                }
            }
            group("Excel Report")
            {
                Caption = 'Excel Report';
                action(Action15)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Excel Report';
                    Image = Excel;
                    RunObject = Page "Excel Report List";
                }
            }
        }
        area(sections)
        {
            group("Zyxel Communications")
            {
                Caption = 'Zyxel Communications';
                Image = HRSetup;
                action(Home)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Home';
                    RunObject = Page "HR Activities Zyxel";
                }
            }
            group("Zyxel Networks (ZNet)")
            {
                Caption = 'Zyxel Networks (ZNet)';
                Image = HumanResources;
                action(Action41)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Home';
                    RunObject = Page "HR Activities ZNet";
                }
            }
            group("Customer Contracts")
            {
                Caption = 'Customer Contracts';
                Image = RegisteredDocs;
                action(Customers)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customers';
                    RunObject = Page "Company Contract List";
                }
            }
        }
    }
}
