codeunit 50019 "API Management"
{
    trigger OnRun()
    begin
        ImportTaxLibDocument;
    end;

    var
        NewRecords: Integer;

    procedure ImportTaxLibDocument()
    var
        MyFile: Record File;
        Setup: Record "eCommerce Setup";
        orderRec: Record "eCommerce Order Header";
        recServerEnviron: Record "Server Environment";
        recAmzOrderHead: Record "eCommerce Order Header";
        inputStream: InStream;
        orderFile: File;
        orderXML: XmlPort "eCommerce Tax Doc. Import";
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";
        lText001: Label '%1 new order(s) has been inserted.';
    begin
        Setup.Get();
        MyFile.SetRange(Path, Setup."API Import Path");
        MyFile.SetRange("Is a file", true);
        MyFile.SetFilter(Name, '*.csv');
        if MyFile.FindSet() then begin
            ZGT.OpenProgressWindow('', MyFile.Count());
            repeat
                ZGT.UpdateProgressWindow(MyFile.Name, 0, true);

                if MyFile.Size <> 0 then begin
                    if StrPos(UpperCase(MyFile.Name), 'TAX') <> 0 then begin
                        Clear(orderFile);
                        Clear(inputStream);
                        Clear(orderXML);
                        orderFile.Open(Setup."API Import Path" + MyFile.Name);
                        orderFile.CreateInstream(inputStream);
                        orderXML.InitXmlPort(MyFile.Size);
                        orderXML.SetSource(inputStream);
                        orderXML.Filename(Setup."API Import Path" + MyFile.Name);

                        if orderXML.Import then begin
                            NewRecords += orderXML.GetQuantityImported;
                            orderFile.Close();
                            Commit();

                            Sleep(500);

                            //CleanUpFiles(Setup."API Import Archive Path",Setup."API Import Path" + MyFile.Name);  // 26-01-22 ZY-LD 002
                            if recServerEnviron.ProductionEnvironment then begin
                                if orderXML.GetQuantityImported > 0 then  // 26-01-22 ZY-LD 002
                                    File.Copy(Setup."API Import Path" + MyFile.Name, Setup."API Import Archive Path" + MyFile.Name);
                                File.Erase(Setup."API Import Path" + MyFile.Name);
                            end;
                        end else begin
                            // If an error occur during the import will the order not be marked as "Completely Imported". Therefore we delete the orders, so they can be imported again later.
                            recAmzOrderHead.SetRange("RHQ Creation Date", Today);
                            recAmzOrderHead.SetRange("Completely Imported", false);
                            if recAmzOrderHead.FindSet(true) then
                                repeat
                                    recAmzOrderHead.Delete(true);
                                until recAmzOrderHead.Next() = 0;

                            if recServerEnviron.ProductionEnvironment then begin
                                //>> 03-03-23 ZY-LD 003
                                EmailAddMgt.CreateEmailWithAttachment('AMZERRIMP', '', '', Setup."API Import Path" + MyFile.Name, MyFile.Name, false);
                                EmailAddMgt.Send;
                                //<< 03-03-23 ZY-LD 003
                                orderFile.Close();
                                if File.Copy(Setup."API Import Path" + MyFile.Name, Setup."API Import Error Path" + MyFile.Name) then
                                    File.Erase(Setup."API Import Path" + MyFile.Name);
                            end;
                        end;
                    end;
                end;
            until MyFile.Next() = 0;
            ZGT.CloseProgressWindow;
            Message(lText001, NewRecords);
        end else begin
            EmailAddMgt.CreateSimpleEmail('AMZNOFILES', '', '');
            EmailAddMgt.Send;
        end;
    end;

    procedure ImportFulfilledOrders()
    var
        MyFile: Record File;
        Setup: Record "eCommerce Setup";
        orderRec: Record "eCommerce Order Header";
        recServerEnviron: Record "Server Environment";
        recAmzOrderHead: Record "eCommerce Order Header";
        inputStream: InStream;
        orderFile: File;
        orderXML: XmlPort "eComm. Fulfilled Ship. Import";
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";
        lText001: Label '%1 new order(s) has been inserted.';
        FileMgt: Codeunit "ZyXEL File Management";
        SourceFilename: Text;
        ArchiveFilename: Text;
    begin
        Setup.Get();
        MyFile.SetRange(Path, Setup."API Import Fulfil. Order  Path");
        MyFile.SetRange("Is a file", true);
        MyFile.SetFilter(Name, '*.csv');
        if MyFile.FindSet() then begin
            ZGT.OpenProgressWindow('', MyFile.Count());
            repeat
                ZGT.UpdateProgressWindow(MyFile.Name, 0, true);

                if MyFile.Size <> 0 then begin
                    Clear(orderFile);
                    Clear(inputStream);
                    Clear(orderXML);

                    SourceFilename := Setup."API Import Fulfil. Order  Path" + MyFile.Name;
                    ArchiveFilename := Setup."API Import Fulfi. Archive Path" + MyFile.Name;

                    orderFile.Open(SourceFilename);
                    orderFile.CreateInstream(inputStream);
                    orderXML.InitXmlPort(MyFile.Size);
                    orderXML.SetSource(inputStream);
                    orderXML.Filename(SourceFilename);

                    if orderXML.Import then begin
                        NewRecords += orderXML.GetQuantityImported;
                        orderFile.Close();
                        Commit();

                        Sleep(500);

                        //CleanUpFiles(Setup."API Import Archive Path",Setup."API Import Path" + MyFile.Name);  // 26-01-22 ZY-LD 002
                        if recServerEnviron.ProductionEnvironment then
                            FileMgt.MoveServerFile(SourceFilename, ArchiveFilename);
                    end else begin
                        // If an error occur during the import will the order not be marked as "Completely Imported". The validation will mark it in the error description.
                        recAmzOrderHead.SetRange("RHQ Creation Date", Today);
                        recAmzOrderHead.SetRange("Completely Imported", false);
                        if recAmzOrderHead.FindSet(true) then
                            repeat
                                recAmzOrderHead.ValidateDocument;
                            until recAmzOrderHead.Next() = 0;

                        orderFile.Close();
                        if recServerEnviron.ProductionEnvironment then begin
                            FileMgt.MoveServerFile(SourceFilename, Setup."API Import Fulfi. Error Path" + MyFile.Name);
                        end;
                    end;
                end;
            until MyFile.Next() = 0;
            ZGT.CloseProgressWindow;
            Message(lText001, NewRecords);
        end else begin
            EmailAddMgt.CreateSimpleEmail('AMZNOFILES', '', '');
            EmailAddMgt.Send;
        end;
    end;

    procedure ImportFbaCustReturns()
    var
        MyFile: Record File;
        Setup: Record "eCommerce Setup";
        orderRec: Record "eCommerce Order Header";
        recServerEnviron: Record "Server Environment";
        recAmzOrderHead: Record "eCommerce Order Header";
        inputStream: InStream;
        orderFile: File;
        orderXML: XmlPort "eComm. Fulfilled Return Imp.";
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";
        lText001: Label '%1 new order(s) has been inserted.';
        FileMgt: Codeunit "ZyXEL File Management";
        SourceFilename: Text;
        ArchiveFilename: Text;
    begin
        Setup.Get();
        MyFile.SetRange(Path, Setup."API Import Return Order  Path");
        MyFile.SetRange("Is a file", true);
        MyFile.SetFilter(Name, '*.csv');
        if MyFile.FindSet() then begin
            ZGT.OpenProgressWindow('', MyFile.Count());
            repeat
                ZGT.UpdateProgressWindow(MyFile.Name, 0, true);

                if MyFile.Size <> 0 then begin
                    Clear(orderFile);
                    Clear(inputStream);
                    Clear(orderXML);

                    SourceFilename := Setup."API Import Return Order  Path" + MyFile.Name;
                    ArchiveFilename := Setup."API Import Return Archive Path" + MyFile.Name;

                    orderFile.Open(SourceFilename);
                    orderFile.CreateInstream(inputStream);
                    orderXML.InitXmlPort(MyFile.Size);
                    orderXML.SetSource(inputStream);
                    orderXML.Filename(SourceFilename);

                    if orderXML.Import then begin
                        NewRecords += orderXML.GetQuantityImported;
                        orderFile.Close();
                        Commit();

                        Sleep(500);

                        //CleanUpFiles(Setup."API Import Archive Path",Setup."API Import Path" + MyFile.Name);  // 26-01-22 ZY-LD 002
                        if recServerEnviron.ProductionEnvironment then
                            FileMgt.MoveServerFile(SourceFilename, ArchiveFilename);
                    end else begin
                        // If an error occur during the import will the order not be marked as "Completely Imported". The validation will mark it in the error description.
                        recAmzOrderHead.SetRange("RHQ Creation Date", Today);
                        recAmzOrderHead.SetRange("Completely Imported", false);
                        if recAmzOrderHead.FindSet(true) then
                            repeat
                                recAmzOrderHead.ValidateDocument;
                            until recAmzOrderHead.Next() = 0;

                        orderFile.Close();
                        if recServerEnviron.ProductionEnvironment then begin
                            FileMgt.MoveServerFile(SourceFilename, Setup."API Import Return Error Path" + MyFile.Name);
                        end;
                    end;
                end;
            until MyFile.Next() = 0;
            ZGT.CloseProgressWindow;
            Message(lText001, NewRecords);
        end else begin
            EmailAddMgt.CreateSimpleEmail('AMZNOFILES', '', '');
            EmailAddMgt.Send;
        end;
    end;

    procedure ImportPayments()
    var
        MyFile: Record File;
        Setup: Record "eCommerce Setup";
        recServerEnviron: Record "Server Environment";
        inputStream: InStream;
        PaymentFile: File;
        PaymentXML: XmlPort "eCommerce Payment Import";
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";
        lText001: Label '%1 new order(s) has been inserted.';
        ZyxelFileMgt: Codeunit "Zyxel File Management";
        FileMgt: Codeunit "File Management";
        SourceFilename: Text;
        ArchiveFilename: Text;
        FileMovedToError: Boolean;
        lText002: Label 'An error occured, and at least one file has been moved to "%1".\\%2';
    begin
        Setup.Get();
        MyFile.SetRange(Path, Setup."API Import Payment Path");
        MyFile.SetRange("Is a file", true);
        MyFile.SetFilter(Name, '*.txt');
        if MyFile.FindSet() then begin
            ZGT.OpenProgressWindow('', MyFile.Count());
            repeat
                ZGT.UpdateProgressWindow(MyFile.Name, 0, true);

                if MyFile.Size <> 0 then begin
                    //IF StrPos(UPPERCASE(MyFile.Name),'TAX') <> 0 THEN BEGIN
                    Clear(PaymentFile);
                    Clear(inputStream);
                    Clear(PaymentXML);

                    SourceFilename := Setup."API Import Payment Path" + MyFile.Name;

                    PaymentFile.Open(SourceFilename);
                    PaymentFile.CreateInstream(inputStream);
                    PaymentXML.InitXmlPort(MyFile.Size);
                    PaymentXML.SetSource(inputStream);
                    PaymentXML.Filename(SourceFilename);

                    if PaymentXML.Import then begin
                        NewRecords += PaymentXML.GetQuantityImported;
                        PaymentFile.Close();
                        Commit();

                        Sleep(500);

                        //CleanUpFiles(Setup."API Import Archive Path",Setup."API Import Path" + MyFile.Name);  // 26-01-22 ZY-LD 002
                        if recServerEnviron.ProductionEnvironment then begin
                            if PaymentXML.GetQuantityImported > 0 then begin  // 26-01-22 ZY-LD 002
                                ArchiveFilename := StrSubstNo('%1%2\', Setup."API Import Payment Arch. Path", PaymentXML.GetMarketPlaceID);
                                if not FileMgt.ServerDirectoryExists(ArchiveFilename) then
                                    FileMgt.ServerCreateDirectory(ArchiveFilename);
                                ArchiveFilename := ArchiveFilename + MyFile.Name;
                                ZyxelFileMgt.MoveServerFile(SourceFilename, ArchiveFilename);
                            end else
                                FileMgt.DeleteServerFile(SourceFilename);
                        end;
                    end else begin
                        PaymentFile.Close();
                        if recServerEnviron.ProductionEnvironment then
                            ZyxelFileMgt.MoveServerFile(SourceFilename, Setup."API Import Payment Error Path" + MyFile.Name);
                        FileMovedToError := true;
                    end;
                    //END;
                end;
            until MyFile.Next() = 0;
            ZGT.CloseProgressWindow;
            if FileMovedToError then
                Message(lText002, Setup."API Import Payment Error Path", GetLastErrorCode);
            Message(lText001, NewRecords);
        end else begin
            EmailAddMgt.CreateSimpleEmail('AMZNOFILES', '', '');
            EmailAddMgt.Send;
        end;
    end;

    procedure ImportArchiveAdjustment()
    var
        MyFile: Record File;
        Setup: Record "eCommerce Setup";
        orderRec: Record "eCommerce Order Header";
        recServerEnviron: Record "Server Environment";
        recAmzOrderHead: Record "eCommerce Order Header";
        inputStream: InStream;
        orderFile: File;
        orderXML: XmlPort "Adj. eCommerce Tax Doc. Import";
        ZGT: Codeunit "ZyXEL General Tools";
        EmailAddMgt: Codeunit "E-mail Address Management";
        lText001: Label '%1 new order(s) has been inserted.';
    begin
        Setup.Get();
        MyFile.SetRange(Path, Setup."API Import Archive Path");
        MyFile.SetRange("Is a file", true);
        MyFile.SetFilter(Name, '*.csv');
        MyFile.SetFilter(Date, '%1..', 20220601D);
        if MyFile.FindSet() then begin
            ZGT.OpenProgressWindow('', MyFile.Count());
            repeat
                ZGT.UpdateProgressWindow(MyFile.Name, 0, true);

                if MyFile.Size <> 0 then begin
                    if StrPos(UpperCase(MyFile.Name), 'TAX') <> 0 then begin
                        Clear(orderFile);
                        Clear(inputStream);
                        Clear(orderXML);
                        orderFile.Open(Setup."API Import Archive Path" + MyFile.Name);
                        orderFile.CreateInstream(inputStream);
                        orderXML.InitXmlPort(MyFile.Size);
                        orderXML.SetSource(inputStream);
                        orderXML.Filename(Setup."API Import Archive Path" + MyFile.Name);

                        if orderXML.Import then begin
                            NewRecords += orderXML.GetQuantityImported;
                            orderFile.Close();
                            Commit();

                            Sleep(500);
                        end;
                    end;
                end;
            until MyFile.Next() = 0;
            ZGT.CloseProgressWindow;
            Message(lText001, NewRecords);
        end else begin
            EmailAddMgt.CreateSimpleEmail('AMZNOFILES', '', '');
            EmailAddMgt.Send;
        end;
    end;
}
