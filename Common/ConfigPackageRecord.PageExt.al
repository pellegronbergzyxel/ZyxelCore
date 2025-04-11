pageextension 50004 ConfigPackageRecordsZX extends "Config. Package Records"
{
    layout
    {
        addafter(Invalid)
        {
            field("Error Text"; Rec."Error Text")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
