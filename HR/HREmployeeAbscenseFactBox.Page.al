Page 50187 "HR Employee Abscense Fact Box"
{
    Caption = 'Holiday/Sick';
    DelayedInsert = false;
    DeleteAllowed = false;
    Description = 'Holiday/Sick';
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group("This Year")
            {
                Caption = 'This Year';
                field("HRMod.HolidaysDaysThisYear(""No."")"; HRMod.HolidaysDaysThisYear(Rec."No."))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Holiday Taken';
                    Editable = false;
                    Importance = Promoted;
                }
                field("HRMod.HolidaysRemainingThisYear(""No."")"; HRMod.HolidaysRemainingThisYear(Rec."No."))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Holiday Remaining';
                    Editable = false;
                    Importance = Promoted;
                }
                field("HRMod.SickDaysThisYear(""No."")"; HRMod.SickDaysThisYear(Rec."No."))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sick';
                    Description = 'Sick';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Sick';
                }
            }
        }
    }

    actions
    {
    }

    var
        HRMod: Codeunit "ZyXEL HR Module";
}
