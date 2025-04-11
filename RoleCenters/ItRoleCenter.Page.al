Page 50212 "It Role Center"
{
    Caption = 'It Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part("It Department Activities"; "It Department Activities")
                {
                    Caption = 'Activities';
                }
                part(Control3; "Report Inbox Part")
                {
                }
            }
            group(Control2)
            {
                part("Company Logo"; "Company Logo")
                {
                    Caption = 'Company Logo';
                    Editable = false;
                    Enabled = true;
                    ShowFilter = false;
                }
                systempart(Control5; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action("Windows User")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Windows User';
                RunObject = Page Users;
            }
            action("Permission Sets")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Permission Sets';
                RunObject = Page "Permission Sets";
            }
        }
        area(processing)
        {
            action(Permissions)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Permissions';
                Image = Permission;
                RunObject = Page "Expanded Permissions";
            }
        }
    }
}
