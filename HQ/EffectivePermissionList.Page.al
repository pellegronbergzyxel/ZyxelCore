page 50110 "Effective Permission List"
{
    ApplicationArea = Admin;
    Caption = 'User Effective Permission List';
    PageType = List;
    SourceTable = EffectivePermissionList;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User Security ID"; Rec."User Security ID")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the user security ID.';
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the user name.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the company name.';
                }
                field("App Name"; Rec."App Name")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the application name.';
                }
                field("Role ID"; Rec."Role ID")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the role ID.';
                }
                field("Role Name"; Rec."Role Name")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the role name.';
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the object type.';
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the object ID.';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the object name.';
                }
                field("Read Permission"; Rec."Read Permission")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the read permission.';
                }
                field("Modify Permission"; Rec."Modify Permission")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the modify permission.';
                }
                field("Insert Permission"; Rec."Insert Permission")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the insert permission.';
                }
                field("Execute Permission"; Rec."Execute Permission")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the execute permission.';
                }
                field("Delete Permission"; Rec."Delete Permission")
                {
                    ApplicationArea = All;
                    tooltip = 'Specifies the delete permission.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        AccessControl: Record "Access Control";
        RecPermission: Record "Expanded Permission"; //UpgradeReady
    begin
        AccessControl.Reset();
        AccessControl.SetAutoCalcFields("Role Name", "User Name");
        Rec.LineNo := 0;
        if AccessControl.FindSet() then
            repeat
                RecPermission.Reset();
                RecPermission.SetRange("Role ID", AccessControl."Role ID");
                RecPermission.SetAutoCalcFields("Object Name");
                if RecPermission.FindSet() then
                    repeat
                        Rec.LineNo := Rec.LineNo + 1;
                        Rec.Init();
                        Rec."User Security ID" := AccessControl."User Security ID";
                        Rec."Role ID" := AccessControl."Role ID";
                        Rec."Role Name" := AccessControl."Role Name";
                        Rec."Company Name" := AccessControl."Company Name";
                        Rec."User Name" := AccessControl."User Name";
                        Rec."App Name" := AccessControl."App Name";
                        Rec."Object Type" := RecPermission."Object Type";
                        Rec."Object ID" := RecPermission."Object ID";
                        Rec."Object Name" := RecPermission."Object Name";
                        Rec."Insert Permission" := RecPermission."Insert Permission";
                        Rec."Modify Permission" := RecPermission."Modify Permission";
                        Rec."Execute Permission" := RecPermission."Execute Permission";
                        Rec."Delete Permission" := RecPermission."Delete Permission";
                        Rec."Read Permission" := RecPermission."Read Permission";
                        Rec.Insert();
                    until RecPermission.Next() = 0;
            until AccessControl.Next() = 0;
    end;
}