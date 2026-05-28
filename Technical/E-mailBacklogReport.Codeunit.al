Codeunit 50047 "E-mail Backlog Report"
{
    // 001. 12-06-18 ZY-LD 2018060810000306 - Created.


    trigger OnRun()
    begin
        // All orders
        if recEmailAdd.Get('BACKLOG') and (recEmailAdd.Recipients <> '') then begin
            tempBlob.CreateOutstream(varoutstream);
            BacklogReport.InitRequest(3, '');
            BacklogReport.SaveAs(dummy,ReportFormat::Excel,varoutstream);
            EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
            EmailAddMgt.AddAttachment(tempblob, StrSubstNo(Text001, Text002, CurrentDatetime));
            EmailAddMgt.Send;

        end;

        // Sales Orders
        if recEmailAdd.Get('BACKLOGSAL') and (recEmailAdd.Recipients <> '') then begin
            Clear(BacklogReport);
            Clear(EmailAddMgt);
            clear(tempblob);
            clear(varoutstream);
            tempBlob.CreateOutstream(varoutstream);
            BacklogReport.InitRequest(0, '');
            BacklogReport.SaveAs(dummy,ReportFormat::Excel,varoutstream);
            EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
            EmailAddMgt.AddAttachment(tempblob, StrSubstNo(Text001, Text003, CurrentDatetime));
            EmailAddMgt.Send;
            
        end;

        // Transfer Orders
        if recEmailAdd.Get('BACKLOGTRA') and (recEmailAdd.Recipients <> '') then begin
            Clear(BacklogReport);
            Clear(EmailAddMgt);
            clear(tempblob);
            clear(varoutstream);
            tempBlob.CreateOutstream(varoutstream);
            BacklogReport.InitRequest(1, '200153');
            BacklogReport.SaveAs(dummy,ReportFormat::Excel,varoutstream);
            EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
            EmailAddMgt.AddAttachment(tempblob, StrSubstNo(Text001, Text004, CurrentDatetime));
            EmailAddMgt.Send;
            
        end;

        // Assembly Orders
        if recEmailAdd.Get('BACKLOGASS') and (recEmailAdd.Recipients <> '') then begin
            Clear(BacklogReport);
            Clear(EmailAddMgt);
            clear(tempblob);
            clear(varoutstream);
            tempBlob.CreateOutstream(varoutstream);
            BacklogReport.InitRequest(2, '');
            BacklogReport.SaveAs(dummy,ReportFormat::Excel,varoutstream);
            EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
            EmailAddMgt.AddAttachment(tempblob, StrSubstNo(Text001, Text005, CurrentDatetime));
            EmailAddMgt.Send;
            
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
          tempblob: Codeunit "Temp Blob";
        
        varoutstream: outstream;
        
        dummy: text;
}
