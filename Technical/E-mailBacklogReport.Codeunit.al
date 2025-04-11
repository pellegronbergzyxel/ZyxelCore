Codeunit 50047 "E-mail Backlog Report"
{
    // 001. 12-06-18 ZY-LD 2018060810000306 - Created.


    trigger OnRun()
    begin
        // All orders
        if recEmailAdd.Get('BACKLOG') and (recEmailAdd.Recipients <> '') then begin
            ServerFilename := FileMgt.ServerTempFileName('');
            BacklogReport.InitRequest(3, '');
            BacklogReport.SaveAsExcel(ServerFilename);

            EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
            EmailAddMgt.AddAttachment(ServerFilename, StrSubstNo(Text001, Text002, CurrentDatetime), false);
            EmailAddMgt.Send;
            FileMgt.DeleteServerFile(ServerFilename);
        end;

        // Sales Orders
        if recEmailAdd.Get('BACKLOGSAL') and (recEmailAdd.Recipients <> '') then begin
            Clear(BacklogReport);
            Clear(EmailAddMgt);
            ServerFilename := FileMgt.ServerTempFileName('');
            BacklogReport.InitRequest(0, '');
            BacklogReport.SaveAsExcel(ServerFilename);

            EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
            EmailAddMgt.AddAttachment(ServerFilename, StrSubstNo(Text001, Text003, CurrentDatetime), false);
            EmailAddMgt.Send;
            FileMgt.DeleteServerFile(ServerFilename);
        end;

        // Transfer Orders
        if recEmailAdd.Get('BACKLOGTRA') and (recEmailAdd.Recipients <> '') then begin
            Clear(BacklogReport);
            Clear(EmailAddMgt);
            ServerFilename := FileMgt.ServerTempFileName('');
            BacklogReport.InitRequest(1, '200153');
            BacklogReport.SaveAsExcel(ServerFilename);

            EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
            EmailAddMgt.AddAttachment(ServerFilename, StrSubstNo(Text001, Text004, CurrentDatetime), false);
            EmailAddMgt.Send;
            FileMgt.DeleteServerFile(ServerFilename);
        end;

        // Assembly Orders
        if recEmailAdd.Get('BACKLOGASS') and (recEmailAdd.Recipients <> '') then begin
            Clear(BacklogReport);
            Clear(EmailAddMgt);
            ServerFilename := FileMgt.ServerTempFileName('');
            BacklogReport.InitRequest(2, '');
            BacklogReport.SaveAsExcel(ServerFilename);

            EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
            EmailAddMgt.AddAttachment(ServerFilename, StrSubstNo(Text001, Text005, CurrentDatetime), false);
            EmailAddMgt.Send;
            FileMgt.DeleteServerFile(ServerFilename);
        end;
    end;

    var
        recEmailAdd: Record "E-mail address";
        BacklogReport: Report "Backlog Report";
        FileMgt: Codeunit "File Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        ServerFilename: Text;
        Text001: label 'Backlog Report %1 %2.xlsx';
        Text002: label 'All';
        Text003: label 'Sales Order';
        Text004: label 'Transfer Order';
        Text005: label 'Assembly Order';
}
