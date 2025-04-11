tableextension 50174 ChangeLogEntryZX extends "Change Log Entry"
{
    keys
    {
        key(Key50000; "Table No.", "Date and Time", "Primary Key Field 1 Value", "Primary Key Field 2 Value", "Primary Key Field 3 Value")
        {
        }
        key(Key50001; "Date and Time", "Table No.", "Field No.", "Type of Change")
        {
        }
        key(Key50002; "Table No.", "Type of Change", "Primary Key Field 1 Value", "Field No.", "Date and Time")
        {
        }
        key(Key50003; "Table No.", "Field No.", "Type of Change", Protected, "Primary Key Field 1 Value", "Old Value")
        {
        }
    }
}
