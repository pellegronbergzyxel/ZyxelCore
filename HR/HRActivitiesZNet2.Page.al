Page 50159 "HR Activities ZNet2"
{
    // 001. 26-06-19 ZY-LD 2019062410000088 - Created.

    Caption = 'Activities';
    PageType = CardPart;
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
            cuegroup(Employees)
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
        Rec.SetRange(Rec."Company Option Filter", Rec."company option filter"::ZNet);
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
