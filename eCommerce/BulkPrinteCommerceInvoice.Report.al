report 50082 "Bulk Print eCommerce Invoice"
{
    Caption = 'Bulk Print eCommerce Invoice';
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "External Document No.", "External Invoice No.";

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Sales Invoice Header"."No.", 0, true);

                recAmzOrdArch.Get("Sales Invoice Header"."External Document No.", "Sales Invoice Header"."External Invoice No.");

                recSaleInvHead.SetRange("No.", "Sales Invoice Header"."No.");

                if recAmzOrdArch."Sell-to Type" = recAmzOrdArch."sell-to type"::Business then begin
                    ClientFilename := StrSubstNo(Text001, recAmzSetup."Posted Document Path", "Sales Invoice Header"."External Document No.", 'xlsx');
                    Report.SaveAsExcel(Report::"Sales - Invoice eCommerce", ServerFilename, recSaleInvHead);
                end else begin
                    ClientFilename := StrSubstNo(Text001, recAmzSetup."Posted Document Path", "Sales Invoice Header"."External Document No.", 'pdf');
                    Report.SaveAsPdf(Report::"Sales - Invoice eCommerce", ServerFilename, recSaleInvHead);
                end;

            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                recAmzSetup.Get();
                recAmzSetup.TestField("Posted Document Path");
                if FileMgt.ServerDirectoryExists(recAmzSetup."Posted Document Path") then
                    FileMgt.ServerCreateDirectory(recAmzSetup."Posted Document Path");
                ZGT.OpenProgressWindow('', "Sales Invoice Header".Count());
            end;
        }
    }

    var
        recAmzSetup: Record "eCommerce Setup";
        recSaleInvHead: Record "Sales Invoice Header";
        recAmzOrdArch: Record "eCommerce Order Archive";
        FileMgt: Codeunit "File Management";
        ZGT: Codeunit "ZyXEL General Tools";
        ServerFilename: Text;
        ClientFilename: Text;
        Text001: Label '%1Sales Invoice on %2.%3';
}
