codeunit 62000 EmailClaimReportZX
{
    trigger OnRun()
    var
        AutoSetup: Record "Automation Setup";
    begin
        AutoSetup.Get();
        if AutoSetup.AutomationAllowed() then
            ProcessEmail(true);
    end;

    var
        SI: Codeunit "Single Instance";

    procedure ProcessEmail(Process: Boolean)
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        DailyEmailReport: Record "Daily E-mail Report";
        ClaimReport: Report SalesClaimRebateReportZX;
        FileMgt: Codeunit "File Management";
        EmailAddrMgt: Codeunit "E-mail Address Management";
        ServerFileName: Text;
        EmailFileName: Text;
        EmailFileNameLbl: Label 'Sales - Claim / Rebate %1.xlsx';
        ConfirmProcessMsg: Label 'Do you want to process "Email Claim Report"?';
    begin
        if not Process then
            Process := Confirm(ConfirmProcessMsg, true);

        if Process then begin
            DailyEmailReport.SetRange(Active, true);
            DailyEmailReport.SetRange("Source Type", DailyEmailReport."Source Type"::"Claim Report");
            if DailyEmailReport.FindSet() then
                repeat
                    ServerFileName := FileMgt.ServerTempFileName('');
                    EmailFileName := StrSubstNo(EmailFileNameLbl, CurrentDateTime());

                    SalesCrMemoLine.SetFilter("Posting Date", '%1..%2', CalcDate('<-CM-5M>', Today()), CalcDate('<CM>', Today()));
                    SalesCrMemoLine.SetFilter("Forecast Territory", DailyEmailReport."Forecast Territory Filter");

                    Clear(ClaimReport);
                    ClaimReport.SetTableView(SalesCrMemoLine);
                    ClaimReport.UseRequestPage(false);
                    ClaimReport.SaveAsExcel(ServerFilename);

                    SI.SetMergefield(100, DailyEmailReport."Source Code");
                    SI.SetMergefield(101, SalesCrMemoLine.GetFilter(SalesCrMemoLine."Posting Date"));

                    clear(EmailAddrMgt);
                    EmailAddrMgt.CreateEmailWithAttachment(
                        DailyEmailReport."E-mail Address Code",
                        '',
                        DailyEmailReport."E-mail",
                        ServerFileName,
                        EmailFileName,
                        false);
                    EmailAddrMgt.Send();

                    FileMgt.DeleteServerFile(ServerFileName);
                until DailyEmailReport.Next() = 0;
        end;
    end;
}
