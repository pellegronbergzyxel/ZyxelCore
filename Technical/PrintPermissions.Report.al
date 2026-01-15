Report 50002 "Print Permissions"
{
    Caption = 'Print Permissions';
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(User; User)
        {
            RequestFilterFields = "Expiry Date";
            dataitem(SecurityGroupMemberBuffer; "Security Group Member Buffer")
            {
                DataItemLink = "User Security ID" = field("User Security ID");
                DataItemTableView = sorting("Security Group Code", "User Security ID");

                trigger OnAfterGetRecord()
                begin
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn(User."Full Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(User."User Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(recEmployee."Job Title", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(SecurityGroupMemberBuffer."Security Group Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(SecurityGroupMemberBuffer."Security Group Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);

                    UserGroupMemberFound := true;
                end;

                trigger OnPreDataItem()
                var
                    SecurityGroup: Codeunit "Security Group";
                begin
                    UserGroupMemberFound := false;
                    SecurityGroup.GetMembers(SecurityGroupMemberBuffer);
                end;
            }
            dataitem("Access Control"; "Access Control")
            {
                CalcFields = "Role Name";
                DataItemLink = "User Security ID" = field("User Security ID");
                DataItemTableView = sorting("User Security ID", "Role ID", "Company Name", Scope, "App ID");

                trigger OnAfterGetRecord()
                begin
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn(User."Full Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(User."User Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(recEmployee."Job Title", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn("Access Control"."Role ID", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn("Access Control"."Role Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn("Access Control"."Company Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
                end;

                trigger OnPreDataItem()
                begin
                    if UserGroupMemberFound then
                        CurrReport.Break();
                end;
            }

            trigger OnAfterGetRecord()
            var
                FilterStr: Text;
            begin
                if (user."Contact Email" <> '') AND (StrPos(user."Contact Email", '@') <> 0) then begin
                    recEmployee.SetAutocalcFields("Job Title");
                    FilterStr := StrSubstNo('%1*', CopyStr(User."Contact Email", 1, StrPos(User."Contact Email", '@') - 1));
                    recEmployee.Setfilter("E-Mail", FilterStr);
                    if not recEmployee.FindFirst() then
                        Clear(recEmployee);
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        CreateExcelbook;
    end;

    trigger OnPreReport()

    begin
        //12-01-2026 BK #Print User Permissions Report
        if zgt.IsEMEADatabaseServer() then
            if not ZGT.IsRhq then
                if ZGT.IsZComCompany then
                    Error(Text001, ZGT.GetRHQCompanyName)
                else
                    Error(Text001, ZGT.GetSistersCompanyName(1));

        if zgt.IsITDatabaseServer() then
            if not ZGT.IsZComCompany then
                Error(Text001, ZGT.GetSistersCompanyName(14));

        if zgt.IsTRDatabaseServer() then
            if not ZGT.IsZComCompany then
                Error(Text001, ZGT.GetSistersCompanyName(15));

        MakeExcelHead();
        SI.UseOfReport(3, 50002, 3);
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        recEmployee: Record "ZyXEL Employee";
        UserGroupMemberFound: Boolean;
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        Text001: label 'The report can only run in "%1".';


    procedure CreateExcelbook()
    var
        lText001: label 'User Permissions';
    begin
        ExcelBuf.CreateBook('', lText001);
        ExcelBuf.WriteSheet(lText001, CompanyName(), UserId());

        ExcelBuf.CloseBook;
        if GuiAllowed then begin
            ExcelBuf.OpenExcel;
        end;
    end;


    procedure MakeExcelHead()
    var
        i: Integer;
        lText001: label 'Date Filter: ..%1';
        lText002: label 'Run time: %1';
        lText003: label 'User Id: %1';
        lText004: label 'Triviality Limit: %1';
        VariantVar: Variant;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('User Name', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Account Name', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Job Title', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('User Group Code', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('User Group Name', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Company Name', false, '', true, false, false, '', ExcelBuf."cell type"::Text);
    end;
}
