Codeunit 50044 "Daily Sales Report Email"
{
    // 001. 09-07-19 ZY-LD P0213 - Changed the code to use "E-mail Address Management".
    // 002. 17-02-22 ZY-LD 000 - Changed to run on the sales invoice header so we can see if it has been sent before.
    // 003. 01-05-24 ZY-LD 000 - Added marketing report to the daily sales every 16th in the month.
    Permissions = tabledata "Sales Invoice Header" = m;

    trigger OnRun()
    begin
        ProcessAll;
    end;

    var
        cr: Char;
        lf: Char;
        Text001: label 'Marketing Data %1..%2.xlsx';
        FilePath: label '\\ZYEU-NAVSQL02\SalesReports';
        EmailAddMgt: Codeunit "E-mail Address Management";
        ServerFilename: Text;
        StartDate: Date;
        EndDate: Date;
        FileMkt: Codeunit "File Management";
        repMarketingReport: Report "Marketing Report";

    local procedure ProcessAll()
    var
        recDailyEmailRep: Record "Daily E-mail Report";
    begin
        recDailyEmailRep.SetRange("Source Type", recDailyEmailRep."source type"::"Daily Sales Report");
        recDailyEmailRep.SetFilter("Forecast Territory Filter", '<>%1', '');
        recDailyEmailRep.SetRange(Active, true);
        if recDailyEmailRep.FindSet then
            repeat
                recDailyEmailRep.TestField(Filename);
                Process(recDailyEmailRep, WorkDate);
            until recDailyEmailRep.Next() = 0;
    end;


    procedure Process(pDailyEmailRep: Record "Daily E-mail Report"; pDate: Date)
    var
        xrecCust: Record Customer;
        recSaleInvHead: Record "Sales Invoice Header";
        recSaleInvLine: Record "Sales Invoice Line";
        MyFile: File;
        MyOutStream: OutStream;
        OutputLine: Text;
    begin
        if pDailyEmailRep."Forecast Territory Filter" <> '' then begin
            cr := 13;
            lf := 10;
            //>> 17-02-22 ZY-LD 002
            //recCust.SETFILTER("No.",pDailyEmailRep."Forecast Territory Filter");
            //IF recCust.FINDSET THEN
            recSaleInvHead.SetCurrentkey("Sell-to Customer No.");
            recSaleInvHead.SetFilter("Sell-to Customer No.", pDailyEmailRep."Forecast Territory Filter");
            recSaleInvHead.SetRange("Specification is Sent", false);
            if recSaleInvHead.FindSet(true) then begin  //<< 17-02-22 ZY-LD 002
                MyFile.Create(FilePath + '\' + pDailyEmailRep.Filename);
                MyFile.CreateOutstream(MyOutStream);

                repeat
                    //recsaleinvline.SETRANGE("Sell-to Customer No.",recCust."No.");  // 17-02-22 ZY-LD 002
                    recSaleInvLine.SetRange("Document No.", recSaleInvHead."No.");  // 17-02-22 ZY-LD 002
                    recSaleInvLine.SetRange(Type, recSaleInvLine.Type::Item);
                    //recsaleinvline.SETRANGE("Posting Date",pDate);  // 17-02-22 ZY-LD 002
                    recSaleInvLine.SetFilter(Quantity, '<>0');
                    if recSaleInvLine.FindSet then
                        repeat
                            OutputLine := '';
                            if (recSaleInvLine."Picking List No." <> '') then
                                OutputLine := OutputLine + recSaleInvLine."Picking List No." + ';'
                            else
                                OutputLine := OutputLine + recSaleInvLine."Document No." + ';';

                            OutputLine := OutputLine + Format(recSaleInvLine."Posting Date", 0, '<Day,2>.<Month,2>.<Year>') + ';';
                            OutputLine := OutputLine + recSaleInvLine."No." + ';';
                            OutputLine := OutputLine + Format(recSaleInvLine.Quantity) + ';';
                            OutputLine := OutputLine + recSaleInvLine."External Document No.";
                            MyOutStream.WriteText(OutputLine + Format(cr, 0, '<CHAR>') + Format(lf, 0, '<CHAR>'));
                        until recSaleInvLine.Next() = 0;

                    recSaleInvHead."Specification is Sent" := true;  // 17-02-22 ZY-LD 002
                    recSaleInvHead.Modify;  // 17-02-22 ZY-LD 002
                until recSaleInvHead.Next() = 0;

                MyFile.Close;
            end;

            //>> 09-07-19 ZY-LD 001
            EmailAddMgt.CreateEmailWithAttachment(
              pDailyEmailRep."E-mail Address Code",
              '',
              pDailyEmailRep."E-mail",
              FilePath + '\' + pDailyEmailRep.Filename,
              pDailyEmailRep.Filename,
              false);

            //>> 01-05-24 ZY-LD 003
            if Date2dmy(Today, 1) = 16 then begin
                EndDate := Today;
                StartDate := CalcDate('-1Y', EndDate);
                ServerFilename := FileMkt.ServerTempFileName('');
                repMarketingReport.InitReport(StartDate, EndDate, 'CH', '54750|54825|54850|54860|54900|54950|55050|55100|55150|55200|54800|55000|55020|55250|55255|55300|55350');
                repMarketingReport.SaveAsExcel(ServerFilename);

                EmailAddMgt.AddAttachment(ServerFilename, StrSubstNo(Text001, StartDate, EndDate), false);
            end;
            //<< 01-05-24 ZY-LD 003

            EmailAddMgt.Send;
            FileMkt.DeleteServerFile(ServerFilename);  // 01-05-24 ZY-LD 003
                                                       //<< 09-07-19 ZY-LD 00
        end;
    end;
}
