pageextension 50235 EmployeeAbsencesZX extends "Employee Absences"
{
    Caption = 'HR Employee Absences';

    layout
    {
        modify(Quantity)
        {
            Caption = 'Days';
        }
        addfirst(FactBoxes)
        {
            part(EmployeePart; "HR Employee Fact Box")
            {
                Caption = 'Employee';
                Editable = false;
                ShowFilter = false;
                SubPageLink = "No." = field("Employee No.");
            }
            part(AbsencePart; "HR Employee Abscense Fact Box")
            {
                Caption = 'Holiday/Sick';
                Editable = false;
                SubPageLink = "No." = field("Employee No.");
            }
        }
    }
}
