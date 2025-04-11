Page 50160 "HR Activities Zyxel2"
{
    // 001. 26-06-19 ZY-LD 2019062410000088 - Created.

    Caption = 'Activities';
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Zyxel HR Cue";

    layout
    {
        area(content)
        {
            cuegroup("Upcoming Events")
            {
                Caption = 'Upcoming Events';
                field(Birth1; Rec.BIRTHDAYS)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text001;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = Calendar;
                    Style = Favorable;
                }
                field(Prob1; Rec.PROBATION)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text002;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = Calendar;
                    Style = Attention;
                }
                field(Disc1; Rec.DISCIPLINARY)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text003;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = Calendar;
                    Style = Unfavorable;
                }
            }
            cuegroup(Control1)
            {
                Caption = 'Employees';
                field("Active Employees"; Rec."Active Employees")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text004;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field("Inactive Employees"; Rec."Inactive Employees")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text005;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company0; Rec.ALL)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text006;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = Library;
                }
                field("Changes in History"; Rec."Changes in History")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text024;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                }
                field("Left Zyxel Six Years Ago"; Rec."Left Zyxel Six Years Ago")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text025;
                    Caption = ' ';
                }
            }
            cuegroup("Employees By Company")
            {
                Caption = 'Employees By Company';
                CueGroupLayout = Wide;
                field(Company1; Rec.SPHAIRON)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text007;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company18; Rec."ZYXEL AE")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text021;
                    Caption = ' ';
                    Image = People;
                }
                field(Company3; Rec."ZYXEL CZ")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text009;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field("ZYXEL BE"; Rec."ZYXEL BE")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text026;
                    Caption = ' ';
                }
                field(Company4; Rec."ZYXEL DE")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text010;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company5; Rec."ZYXEL DK")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text011;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company2; Rec."ZYXEL ES")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text008;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company6; Rec."ZYXEL FI")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text012;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field("ZYXEL FR"; Rec."ZYXEL FR")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text023;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
            }
            cuegroup("Employees By Company 2")
            {
                Caption = 'Employees By Company 2';
                CueGroupLayout = Wide;
                field(Company13; Rec."ZYXEL HU")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text018;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company7; Rec."ZYXEL IT")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text013;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company8; Rec."ZYXEL NL")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text014;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company9; Rec."ZYXEL NO")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text015;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company14; Rec."ZYXEL PL")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text019;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company19; Rec."ZYXEL RU")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text022;
                    Caption = ' ';
                    Image = People;
                }
                field(Company11; Rec."ZYXEL SE")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text016;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company16; Rec."ZYXEL TK")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text020;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
                field(Company12; Rec."ZYXEL UK")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Text017;
                    Caption = ' ';
                    DrillDownPageID = "Zyxel HR Employee List";
                    Image = People;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Employees)
            {
                Caption = 'Employees';
                action("HR Employee List1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Employees';
                    Image = Employee;
                    RunObject = Page "Zyxel HR Employee List";
                }
                action("HR Absence Registration1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Absence Registration';
                    Image = Absence;
                    RunObject = Page "Absence Registration";
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
                action(Action30)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Excel Report';
                    Image = Excel;
                    RunObject = Page "Excel Report List";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
        CalcBirthdays;  // 25-01-18 ZY-LD 001
        Rec.SetRange("Date Filter", Today, CalcDate('14D', Today));
        Rec.SetFilter(Rec."Leving Date Filter", '..%1&<>%2', CalcDate('<-6Y>', Today), 0D);  // 15-10-18 ZY-LD 004
        Rec.SetRange(Rec."Company Option Filter", Rec."company option filter"::Zyxel);
    end;

    var
        recEmpTmp: Record "ZyXEL Employee" temporary;
        Text001: label 'Future Birthdays';
        Text002: label 'Future Probation Meetings';
        Text003: label 'Future Disciplinary Meetings';
        Text004: label 'Active Employees';
        Text005: label 'Inactive Employees';
        Text006: label 'All Employees';
        Text007: label 'Sphairon';
        Text008: label 'Spain';
        Text009: label 'Czech Republic';
        Text010: label 'Germany';
        Text011: label 'Denmark';
        Text012: label 'Finland';
        Text013: label 'Italy';
        Text014: label 'Netherlands';
        Text015: label 'Norway';
        Text016: label 'Sweden';
        Text017: label 'United Kingdom';
        Text018: label 'Hungary';
        Text019: label 'Poland';
        Text020: label 'Turkey';
        Text021: label 'UAE';
        Text022: label 'Russia';
        Text023: label 'France';
        Text024: label 'Changes in History';
        Text025: label 'Left Zyxel Six Years Ago';
        Text026: label 'Belgium';

    local procedure CalcBirthdays()
    var
        recEmp: Record "ZyXEL Employee";
        NextBirthday: Date;
    begin
        //>> 25-01-18 ZY-LD 001
        // recEmp.SETRANGE("Active employee",TRUE);
        // recEmp.SETFILTER("Birth Date",'<>%1',0D);

        if recEmp.FindSet then
            repeat
                recEmp."Active employee" := (recEmp."Employment Date" <= Today) and ((recEmp."Leaving Date" = 0D) or (recEmp."Leaving Date" >= Today));  // 19-09-18 ZY-LD 003
                if recEmp."Active employee" and (recEmp."Birth Date" <> 0D) then begin
                    recEmp."Next Birth Date" := Dmy2date(Date2dmy(recEmp."Birth Date", 1), Date2dmy(recEmp."Birth Date", 2), Date2dmy(Today, 3));
                    if recEmp."Next Birth Date" < Today then
                        recEmp."Next Birth Date" := Dmy2date(Date2dmy(recEmp."Birth Date", 1), Date2dmy(recEmp."Birth Date", 2), Date2dmy(Today, 3) + 1);
                end;
                recEmp.Modify;
            until recEmp.Next() = 0;
        //<< 25-01-18 ZY-LD 001
    end;
}
