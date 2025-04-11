pageextension 50313 PermissionSetsZX extends "Permission Sets"
{
    actions
    {
        addafter("Permission Set By Security Group")
        {
            action("All Permissions")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'All Permissions';
                Image = Permission;
                RunObject = Page "All Permissions";
            }
        }
        addafter(CopyPermissionSet)
        {
            action("Export/Import Permission Sets")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export/Import Permission Sets';
                Image = ImportExport;
                RunObject = XmlPort "Import/Export Permission Sets";
            }
            action("Export/Import Permissions")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export/Import Permissions';
                Image = ImportExport;
                RunObject = XmlPort "Import/Export Permissions";
            }
            action(Action24)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print Permissions';
                RunObject = Report "Print Permissions";
            }
        }
    }
}
