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
                    EmailAddMgt.AddAttachment(SIServerFilename, StrSubstNo(Text001, Text002, DelChr(recCompInfo.Name, '=', '.')), false);
                if PIServerFilename <> '' then
                    EmailAddMgt.AddAttachment(PIServerFilename, StrSubstNo(Text001, Text003, DelChr(recCompInfo.Name, '=', '.')), false);

                EmailAddMgt.Send;
                FileMgt.DeleteServerFile(SIServerFilename);
                FileMgt.DeleteServerFile(PIServerFilename);
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

    local procedure SiiSalesInvoice()
    var
        recSalesInv: Record "Sales Invoice Header";
        FileMgt: Codeunit "File Management";
    begin
        recSalesInv.SetFilter("Posting Date", '%1..', 20230101D);
        recSalesInv.SetRange("SII Spain - Document Sent", false);
        if recSalesInv.FindFirst then begin
            SIServerFilename := FileMgt.ServerTempFileName('.xlsx');
            Report.SaveAsExcel(Report::"SII Spain - Sales Invoice", SIServerFilename, recSalesInv);
        end;
    end;

    local procedure SiiPurchaseInvoice()
    var
        recPurchInv: Record "Purch. Inv. Header";
        FileMgt: Codeunit "File Management";
    begin
        recPurchInv.SetFilter("Posting Date", '%1..', 20230101D);
        recPurchInv.SetRange("Buy-from Country/Region Code", 'ES');
        recPurchInv.SetRange("SII Spain - Document Sent", false);
        if recPurchInv.FindFirst then begin
            PIServerFilename := FileMgt.ServerTempFileName('.xlsx');
            Report.SaveAsExcel(Report::"SII Spain - Purchase Invoice", PIServerFilename, recPurchInv);
        end;
    end;
}
