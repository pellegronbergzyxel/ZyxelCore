tableextension 50001 EmployeeAbsenceZX extends "Employee Absence"
{
    fields
    {
        modify("Employee No.")
        {
            TableRelation = "ZyXEL Employee";

            trigger OnBeforeValidate()
            begin
                //>> 08-04-19 ZY-LD 001
                if ZGT.IsRhq() and ZGT.IsZComCompany() then
                    exit;
                //<< 08-04-19 ZY-LD 001
            end;
        }
        modify("From Date")
        {
            trigger OnBeforeValidate()
            begin
                //>> 08-04-19 ZY-LD 001
                if ZGT.IsRhq() and ZGT.IsZComCompany() then
                    exit;
                //<< 08-04-19 ZY-LD 001
            end;
        }
        modify("Cause of Absence Code")
        {
            trigger OnBeforeValidate()
            begin
                //>> 08-04-19 ZY-LD 001
                if ZGT.IsRhq() and ZGT.IsZComCompany() then
                    exit;
                //<< 08-04-19 ZY-LD 001
            end;
        }
        modify(Quantity)
        {
            trigger OnBeforeValidate()
            begin
                //>> 08-04-19 ZY-LD 001
                if ZGT.IsRhq() and ZGT.IsZComCompany() then
                    exit;
                //<< 08-04-19 ZY-LD 001
            end;
        }
        field(50000; "Free Text"; Text[50])
        {
            Caption = 'Free Text';
            DataClassification = CustomerContent;
        }
    }

    var
        ZGT: Codeunit "ZyXEL General Tools";
}
