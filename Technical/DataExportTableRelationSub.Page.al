Page 50143 "Data Export Table Relation Sub"
{
    Caption = 'Data Export Table Relationships';
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Data Export Table Relation";

    layout
    {
        area(content)
        {
            repeater(Control1140000)
            {
                field("From Field No."; Rec."From Field No.")
                {
                    ApplicationArea = Basic, Suite;
                    LookupPageID = "Data Export Field List";
                }
                field("From Field Name"; Rec."From Field Name")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    Lookup = false;
                }
                field("To Field No."; Rec."To Field No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("To Field Name"; Rec."To Field Name")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    Lookup = false;
                }
            }
        }
    }

    actions
    {
    }
}
