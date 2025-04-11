tableextension 50006 "IC Setup" extends "IC Setup"
{
    fields
    {
        field(50000; "Sample Item"; Code[20])  // 02-05-24 - ZY-LD 000
        {
            Caption = 'Sample Item';
            TableRelation = Item;
            DataClassification = ToBeClassified;
        }
    }
}
