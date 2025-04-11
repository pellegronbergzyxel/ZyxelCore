tableextension 50121 ReportSelectionsZX extends "Report Selections"
{
    fields
    {
        field(50000; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = '16-02-18 ZY-LD 001';
            TableRelation = "Country/Region";
        }
    }
}
