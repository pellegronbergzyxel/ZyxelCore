tableextension 50198 DeferralTemplateZX extends "Deferral Template"
{
    fields
    {
        field(50000; "Deferral Line Description"; Option)
        {
            Caption = 'Deferral Line Description';
            Description = '28-01-20 ZY-LD 001';
            OptionMembers = "Template Period Description","Header Schedule Description";
        }
    }
}
