codeunit 50027 BacklogReportJobQueue
{
    trigger OnRun()
    begin
        if not EmailAdd.Get('BACKLOGSAL') then
            exit;

        Cust.SetFilter(BacklogEmailAddress, '<>''''');
        if Cust.FindSet() then begin
            SalesSetup.Get();
            BacklogComment := SalesSetup.GetBacklogComment();

            DayOfWeek := Date2DMY(Today(), 1);
            case DayOfWeek of
                1:  // Monday
                    CountryPickingDay.SetRange(Tuesday, true);
                2:  // Tuesday
                    CountryPickingDay.SetRange(Wednesday, true);
                3:  // Wednesday
                    CountryPickingDay.SetRange(Thursday, true);
                4:  // Thursday
                    CountryPickingDay.SetRange(Friday, true);
                7:  // Sunday
                    CountryPickingDay.SetRange(Monday, true);
                else
                    exit;
            end;

            if CountryPickingDay.FindSet() then
                repeat
                    Cust.SetRange("Country/Region Code", CountryPickingDay."Country Code");
                    if Cust.FindSet() then
                        repeat
                            Clear(BacklogReportAuto);
                            Clear(EmailAddMgt);

                            ServerFileName := FileMgt.ServerTempFileName('');

                            SalesLine.SetRange("Sell-to Customer No.", Cust."No.");
                            SalesLine.CalcSums("Outstanding Amount (LCY)");
                            if SalesLine."Outstanding Amount (LCY)" < CountryPickingDay."Min. Amount to Ship" then
                                BacklogReportAuto.InitRequest(0, Cust."No.", BacklogComment)
                            else
                                BacklogReportAuto.InitRequest(0, Cust."No.", '');
                            BacklogReportAuto.SaveAsExcel(ServerFileName);

                            EmailAddMgt.CreateNewEmail(EmailAdd.Code, Cust."Language Code", Cust.BacklogEmailAddress);
                            EmailAddMgt.AddAttachment(ServerFileName, StrSubstNo(BacklogReportExcelFileNameLbl, SalesOrderLbl, CurrentDateTime()), false);
                            EmailAddMgt.Send();

                            FileMgt.DeleteServerFile(ServerFileName);
                        until Cust.Next() = 0;
                until CountryPickingDay.Next() = 0;
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        SalesLine: Record "Sales Line";
        CountryPickingDay: Record "VCK Country Shipment Days";
        EmailAdd: Record "E-mail address";
        BacklogReportAuto: Report BacklogReportAutomation;
        FileMgt: Codeunit "File Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        BacklogComment: Text;
        ServerFileName: Text;
        DayOfWeek: Integer;
        BacklogReportExcelFileNameLbl: label 'Backlog Report %1 %2.xlsx';
        SalesOrderLbl: label 'Sales Order';
}
