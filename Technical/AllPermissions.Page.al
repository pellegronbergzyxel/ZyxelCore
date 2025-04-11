Page 50232 "All Permissions"
{
    Editable = false;
    PageType = List;
    SourceTable = "Expanded Permission";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Role ID"; Rec."Role ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Role Name"; Rec."Role Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Read Permission"; Rec."Read Permission")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Insert Permission"; Rec."Insert Permission")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Modify Permission"; Rec."Modify Permission")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Delete Permission"; Rec."Delete Permission")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Execute Permission"; Rec."Execute Permission")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Security Filter"; Rec."Security Filter")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
