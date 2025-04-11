codeunit 50096 EmailRMAStockControlZX
{
    Permissions = TableData "Country/Region" = r,
                  TableData Location = r;

    trigger OnRun()
    var
        Country: Record "Country/Region";
        TempLocation: Record Location temporary;
        FileMgt: Codeunit "File Management";
        EmailAddrMgt: Codeunit "E-mail Address Management";
        RMAStockControl: Report RMAStockControlZX;
        OutputText: Text;
        ServerFileName: Text;
        I: Integer;
        FileNameLbl: Label 'RMA Stock Control.xlsx';
    begin
        Country.SetFilter("RMA Location Code", '<>''''');
        if Country.FindSet() then
            repeat
                TempLocation.Code := Country."RMA Location Code";
                if not TempLocation.Insert() then;
            until Country.Next() = 0;

        if TempLocation.FindSet() then
            repeat
                OutputText := TempLocation.Code + ': ';

                Country.SetRange("RMA Location Code", TempLocation.Code);
                if Country.FindSet() then
                    repeat
                        OutputText += Country.Name + ', ';
                    until Country.Next() = 0;

                OutputText := DelChr(OutputText, '>', ', ');
                OutputText += '.';

                SI.SetMergefield(100 + I, OutputText);
                I += 1;
            until TempLocation.Next() = 0;

        ServerFileName := FileMgt.ServerTempFileName('xlsx');
        RMAStockControl.SaveAsExcel(ServerFileName);

        EmailAddrMgt.CreateEmailWithAttachment('LOGRMASTOK', '', '', ServerFilename, FileNameLbl, false);
        EmailAddrMgt.Send();

        FileMgt.DeleteServerFile(ServerFileName);
    end;

    var
        SI: Codeunit "Single Instance";
}
