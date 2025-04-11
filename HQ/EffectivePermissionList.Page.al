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
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                }
                field("App Name"; Rec."App Name")
                {
                    ApplicationArea = All;
                }
                field("Role ID"; Rec."Role ID")
                {
                    ApplicationArea = All;
                }
                field("Role Name"; Rec."Role Name")
                {
                    ApplicationArea = All;
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                }
                field("Read Permission"; Rec."Read Permission")
                {
                    ApplicationArea = All;
                }
                field("Modify Permission"; Rec."Modify Permission")
                {
                    ApplicationArea = All;
                }
                field("Insert Permission"; Rec."Insert Permission")
                {
                    ApplicationArea = All;
                }
                field("Execute Permission"; Rec."Execute Permission")
                {
                    ApplicationArea = All;
                }
                field("Delete Permission"; Rec."Delete Permission")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        AccessControl: Record "Access Control";
        RecPermission: Record Permission;
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