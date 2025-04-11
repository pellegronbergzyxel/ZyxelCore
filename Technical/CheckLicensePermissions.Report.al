report 50037 "Check License Permissions"
{
    RDLCLayout = './Layouts/CheckPermissions.rdlc';
    Caption = 'Check License Permissions';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;

    dataset
    {


        dataitem(LicenseInformation; "License Information")
        {
            DataItemTableView = sorting("Line No.");
            column(LicenseText; Text)
            {

            }
        }
        dataitem(AllObjWithCaption; AllObjWithCaption)
        {
            RequestFilterFields = "Object Type", "Object ID";

            column(ObjectType; "Object Type")
            {
                IncludeCaption = true;
            }
            column(ObjectID; "Object ID")
            {
                IncludeCaption = true;
            }
            column(ObjectName; "Object Name")
            {
                IncludeCaption = true;
            }
            column(ObjectCaption; "Object Caption")
            {
                IncludeCaption = true;
            }
            column(CompanyName; CompanyName())
            {

            }

            trigger OnAfterGetRecord()
            var
                LicPerm: record "License Permission";
                Type2: Integer;
            begin
                case "Object Type" of
                    14:
                        Type2 := "Object Type"::Page;
                    15:
                        Type2 := "Object Type"::Table;
                    else
                        type2 := "Object Type";
                end;
                if LicPerm.Get(Type2, "Object ID") then
                    if "Object Type" in ["Object Type"::Table, "Object Type"::TableData] then begin
                        if LicPerm."Read Permission" > LicPerm."Read Permission"::" " then
                            CurrReport.Skip();
                    end else
                        if LicPerm."Execute Permission" > LicPerm."Execute Permission"::" " then
                            CurrReport.Skip();
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    labels
    {
        ReportNameLabel = 'Check Permissions';
        PageLabel = 'Page';
    }
}
