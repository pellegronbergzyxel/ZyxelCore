Codeunit 50024 "Process SII Spain"
{

    trigger OnRun()
    var
        FileMgt: Codeunit "File Management";
    begin
        if ZGT.IsRhq then
            ZyWebServMgt.ProcessSiiSpain
        else begin
            SiiSalesInvoice;
            SiiPurchaseInvoice;

            if (SIServerFilename <> '') or (PIServerFilename <> '') then begin
                recCompInfo.Get;

                EmailAddMgt.CreateSimpleEmail('SII', '', '');
                if SIServerFilename <> '' then
                    EmailAddMgt.AddAttachment(tempBlob, StrSubstNo(Text001, Text002, DelChr(recCompInfo.Name, '=', '.')));
                if PIServerFilename <> '' then
                    EmailAddMgt.AddAttachment(tempBlob3, StrSubstNo(Text001, Text003, DelChr(recCompInfo.Name, '=', '.')));

                EmailAddMgt.Send;
                // CLOUD READY DELETE;
                //  FileMgt.DeleteServerFile(SIServerFilename);
                //FileMgt.DeleteServerFile(PIServerFilename);
            end;
        end;
    end;

    var
        recCompInfo: Record "Company Information";
        SIServerFilename: Text;
        PIServerFilename: Text;
        EmailAddMgt: Codeunit "E-mail Address Management";
        Text001: label 'SII - %1 %2.xlsx';
        Text002: label 'SALES';
        Text003: label 'PURCHASES';
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        tempblob: Codeunit "Temp Blob";
        tempblob3: codeunit "Temp Blob";
        varoutstream: outstream;
        varoutstream3: outstream;
        dummy: text;



    local procedure SiiSalesInvoice()
    var
        recSalesInv: Record "Sales Invoice Header";
        FileMgt: Codeunit "File Management";
        runReport: report "SII Spain - Sales Invoice";
    begin
        recSalesInv.SetFilter("Posting Date", '%1..', 20230101D);
        recSalesInv.SetRange("SII Spain - Document Sent", false);
        if recSalesInv.FindFirst then begin
            SIServerFilename := 'Sales.xlsx';
            tempBlob.CreateOutstream(varoutstream);
            runReport.SetTableView(recSalesInv);
            runReport.SaveAs(Dummy, ReportFormat::Excel, varoutstream);
        end;
    end;

    local procedure SiiPurchaseInvoice()
    var
        recPurchInv: Record "Purch. Inv. Header";
        FileMgt: Codeunit "File Management";
        runReport: report "SII Spain - Purchase Invoice";
    begin
        recPurchInv.SetFilter("Posting Date", '%1..', 20230101D);
        recPurchInv.SetRange("Buy-from Country/Region Code", 'ES');
        recPurchInv.SetRange("SII Spain - Document Sent", false);
        if recPurchInv.FindFirst then begin
            PIServerFilename := 'Purchase.xlsx';
            tempBlob3.CreateOutstream(varoutstream3);
            runReport.SetTableView(recPurchInv);
            runReport.SaveAs(Dummy, ReportFormat::Excel, varoutstream3);
        end;
    end;
}
