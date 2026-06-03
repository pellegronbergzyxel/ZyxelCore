Table 76150 "HQ Invoice Header"
{
    // 001. 02-03-22 ZY-LD P0747 - Update purchase invoice.
    // 002. 10-07-24 ZY-LD 000 - We have seen that only a part of the purchase order has been posted.

    Caption = 'HQ Sales Document Header';
    DataCaptionFields = "No.";
    PasteIsValid = false;
    Permissions = TableData "HQ Invoice Header" = rm;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            Description = 'PAB 1.0';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            Description = 'PAB 1.0';
            OptionCaption = 'Normal,EiCard';
            OptionMembers = Normal,EiCard;
        }
        field(4; "Buy-from Vendor No."; Text[30])
        {
            Caption = 'Buy-from Vendor No.';
            Description = 'PAB 1.0';
        }
        field(5; "Buy-from Vendor Name"; Text[50])
        {
            Caption = 'Buy-from Vendor Name';
            Description = 'PAB 1.0';
        }
        field(6; "Buy-from Vendor Name 2"; Text[50])
        {
            Caption = 'Buy-from Vendor Name 2';
            Description = 'PAB 1.0';
        }
        field(7; "Buy-from Address"; Text[50])
        {
            Caption = 'Buy-from Address';
            Description = 'PAB 1.0';
        }
        field(8; "Buy-from Address 2"; Text[50])
        {
            Caption = 'Buy-from Address 2';
            Description = 'PAB 1.0';
        }
        field(9; "Buy-from City"; Text[30])
        {
            Caption = 'Buy-from City';
            Description = 'PAB 1.0';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(10; "Buy-from Contact"; Text[50])
        {
            Caption = 'Buy-from Contact';
            Description = 'PAB 1.0';
        }
        field(11; "Buy-from Post Code"; Text[30])
        {
            Caption = 'Buy-from Post Code';
            Description = 'PAB 1.0';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(12; "Buy-from County"; Text[30])
        {
            Caption = 'Buy-from County';
            Description = 'PAB 1.0';
        }
        field(13; "Buy-from Country/Region Code"; Text[30])
        {
            Caption = 'Buy-from Country/Region Code';
            Description = 'PAB 1.0';
        }
        field(14; "Invoice Date"; Date)
        {
            Caption = 'Order Date';
            Description = 'PAB 1.0';
        }
        field(15; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Description = 'PAB 1.0';
            TableRelation = Currency;
        }
        field(16; Processed; Boolean)
        {
            Caption = 'Processed';
            Description = 'PAB 1.0';
        }
        field(17; Division; Code[30])
        {
            Description = 'PAB 1.0';
        }
        field(18; "Invoice Total"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 2 : 2;
            Description = 'PAB 1.0';
        }
        field(19; "Details Updated"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(22; "Purchase Document No."; Code[250])
        {
            Caption = 'Purchase Document No.';
            Description = 'HQ sends more than one no. on normal invoices';
            TableRelation = "Purchase Header";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(23; "Company Type"; Option)
        {
            Caption = 'Company Type';
            OptionCaption = 'Zyxel,ZNet';
            OptionMembers = Zyxel,ZNet;
        }
        field(24; Filename; Text[50])
        {
            Caption = 'Filename';
        }
        field(25; "File Path"; Text[80])
        {
        }
        field(26; Status; Option)
        {
            OptionCaption = 'Created,Document is Downloaded,Purchase Order is Updated,Document is Posted';
            OptionMembers = Created,"Document is Downloaded","Purchase Order is Updated","Document is Posted";
        }
        field(27; "Total Amount"; Decimal)
        {
            CalcFormula = sum("HQ Invoice Line"."Total Price" where("Document Type" = field("Document Type"),
                                                                     "Document No." = field("No.")));
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Purchase Order No."; Code[20])
        {
            CalcFormula = lookup("HQ Invoice Line"."Purchase Order No." where("Document Type" = field("Document Type"),
                                                                               "Document No." = field("No.")));
            Caption = 'Purchase Order No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "EiCard Queue Exists"; Boolean)
        {
            CalcFormula = exist("EiCard Queue" where("Purchase Order No." = field("Purchase Order No."),
                                                      Active = const(true)));
            Caption = 'EiCard Queue Exists';
            FieldClass = FlowField;
        }
        field(30; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
        }

          field(100; filblob; blob)
        {

            Caption = 'File blob';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        recHQInvoiceLine: Record "HQ Invoice Line";
    begin
        Error(Text001, TableCaption);
    end;

    trigger OnInsert()
    begin
        "Creation Date" := CurrentDatetime;  // 02-03-22 ZY-LD 001
    end;

    var
        Text001: label 'You can not delete "%1".';


    procedure GetFilename(): Text
    begin
        exit("File Path" + Filename);
    end;


    procedure DownloadDocument(pShowError: Boolean) rValue: Boolean
    var
        recServEnviron: Record "Server Environment";
        VisionFTPMgt: Codeunit "VisionFTP Management";
        FileMgt: Codeunit "File Management";
        lText001: label 'Downloading document';
        ZGT: Codeunit "ZyXEL General Tools";
        varoutsteam: OutStream;
    begin
        LockTable;

        if "File Path" = '' then begin
            ZGT.OpenProgressWindow('', 1);

            ZGT.UpdateProgressWindow(lText001, 0, true);
            if recServEnviron.ProductionEnvironment then begin
                // CLOUD READY NEW 
                //"File Path" := VisionFTPMgt.DownloadFile('HQ-SALES-DOC', Filename, pShowError);
                rec.filblob.CreateOutStream(varoutsteam);
                "File Path" := VisionFTPMgt.DownloadFilestream('HQ-SALES-DOC', Filename,pShowError,varoutsteam);
                // CLOUD READY DELETE >>
                //VisionFTPMgt.DownloadFile('HQ-SALES-DOC', Filename, pShowError);
                //"File Path" := FileMgt.GetDirectoryName("File Path") + '\';
            end;
            if FileMgt.ServerFileExists(GetFilename) or recServEnviron.TestEnvironment then begin
                Status := Status::"Document is Downloaded";
                Modify;
                Commit;
                rValue := true;
            end;

            ZGT.CloseProgressWindow;
        end;
    end;


    procedure UpdatePurchaseOrder(var pPurchHead: Record "Purchase Header")
    var
        recHqSaleDocLine: Record "HQ Invoice Line";
        recPurchLine: Record "Purchase Line";
        recEiCardQueue: Record "EiCard Queue";
        PrevPurchOrderNo: Code[20];
        lText001: label 'Different Purchase Order No. occur on %1 %2.';
        lText002: label 'Different Item No. occur on %1 %2.';
    begin
        pPurchHead.LockTable;
        recPurchLine.LockTable;
        LockTable;
        recHqSaleDocLine.LockTable;

        if (Status = Status::"Document is Downloaded") and ("Document Type" = "document type"::Invoice) then begin
            CalcFields("Total Amount");

            PrevPurchOrderNo := '';

            recHqSaleDocLine.SetRange("Document Type", "Document Type");
            recHqSaleDocLine.SetRange("Document No.", "No.");
            if recHqSaleDocLine.FindSet then begin
                repeat
                    if Type = Type::EiCard then begin
                        if (recHqSaleDocLine."Purchase Order No." <> PrevPurchOrderNo) and
                            (PrevPurchOrderNo <> '')
                        then
                            Error(lText001, TableCaption, "No.");
                    end;

                    recPurchLine.Get(recPurchLine."document type"::Order, recHqSaleDocLine."Purchase Order No.", recHqSaleDocLine."Purchase Order Line No.");
                    if recPurchLine."No." <> recHqSaleDocLine."No." then
                        Error(lText002, TableCaption, "No.");

                    //>> 10-07-24 ZY-LD 002
                    //if (recPurchLine."Direct Unit Cost" <> recHqSaleDocLine."Unit Price") then begin
                    if (recpurchLine."Outstanding Quantity" <> 0) and
                       ((recPurchLine."Qty. to Receive" <> recpurchLine."Outstanding Quantity") or  //<< 10-07-24 ZY-LD 002
                        (recPurchLine."Direct Unit Cost" <> recHqSaleDocLine."Unit Price"))
                    then begin
                        recPurchLine.SuspendStatusCheck(true);
                        recPurchLine.Validate("Qty. to Receive", recPurchLine."Outstanding Quantity");  // 10-07-24 ZY-LD 002
                        recPurchLine.Validate("Direct Unit Cost", recHqSaleDocLine."Unit Price");
                        recPurchLine.Modify;
                        recPurchLine.SuspendStatusCheck(false);
                    end;
                    PrevPurchOrderNo := recHqSaleDocLine."Purchase Order No.";
                until recHqSaleDocLine.Next() = 0;

                if Type = Type::EiCard then begin
                    pPurchHead.Validate("Vendor Invoice No.", "No.");
                    pPurchHead.Modify(true);

                    pPurchHead.CalcFields("Total Amount");
                    recEiCardQueue.SetRange("Purchase Order No.", recHqSaleDocLine."Purchase Order No.");
                    recEiCardQueue.FindFirst;
                    if pPurchHead."Total Amount" = "Total Amount" then
                        recEiCardQueue.Validate("Purchase Order Status", recEiCardQueue."purchase order status"::"Fully Matched")
                    else
                        recEiCardQueue.Validate("Purchase Order Status", recEiCardQueue."purchase order status"::"Partially Matched");
                    recEiCardQueue.Modify(true);
                end;
            end;

            Status := Status::"Purchase Order is Updated";
            Modify;

            Commit;
        end;
    end;


    procedure UpdatePurchaseInvoice(var pPurchHead: Record "Purchase Header")
    var
        recPurchRcptLine: Record "Purch. Rcpt. Line";
        recPurchLine: Record "Purchase Line";
        recHqSaleDocLine: Record "HQ Invoice Line";
    begin
        //>> 02-03-22 ZY-LD 001
        recPurchRcptLine.SetRange("Vendor Invoice No", "No.");
        if recPurchRcptLine.FindSet then
            repeat
                recPurchLine.SetRange("Document Type", pPurchHead."Document Type");
                recPurchLine.SetRange("Document No.", pPurchHead."No.");
                recPurchLine.SetRange("Receipt No.", recPurchRcptLine."Document No.");
                recPurchLine.SetRange("Receipt Line No.", recPurchRcptLine."Line No.");
                if recPurchLine.FindFirst then begin
                    recHqSaleDocLine.SetRange("Document No.", "No.");
                    recHqSaleDocLine.SetRange("Purchase Order No.", recPurchRcptLine."Order No.");
                    recHqSaleDocLine.SetRange("Purchase Order Line No.", recPurchRcptLine."Order Line No.");
                    recHqSaleDocLine.FindFirst;

                    recPurchLine.SuspendStatusCheck(true);
                    recPurchLine.Validate("Direct Unit Cost", recHqSaleDocLine."Unit Price");
                    recPurchLine.Modify;
                    recPurchLine.SuspendStatusCheck(false);
                end;
            until recPurchRcptLine.Next() = 0;
        //<< 02-03-22 ZY-LD 001
    end;

    procedure DownloadToClient()
    var
        FileMgt: Codeunit "File Management";
        lText001: Label 'Download Document';
    begin
        rec.DownloadBlobToFile('');
        // FileMgt.DownloadHandler(GetFilename, lText001, '', 'PDF(*.pdf)|*.pdf|All files(*.*)|*.*', Filename);
    end;


procedure LoadFileToBlob(FilePath: Text): Boolean
    var
        FileIn: File;
        FileStream: InStream;
        outstream: OutStream;
    begin
        if not File.Exists(FilePath) then
            exit(false);

        FileIn.Open(FilePath);
        FileIn.CreateInstream(FileStream);
        filblob.CreateOutStream(outstream);
        CopyStream(outstream, FileStream);
        modify();
        FileIn.Close;
        exit(true);
    end;

    procedure DownloadBlobToFile(DownloadPath: Text): Boolean
    var
        FileOut: File;
        FileStream: OutStream;
        InStr: instream;
    begin
        Rec.CalcFields("Filblob");
        if filblob.HasValue then begin
        //    FileOut.Create(DownloadPath);
          //  FileOut.CreateOutstream(FileStream);
          Rec.filblob.CreateInStream(InStr, TextEncoding::Windows);
                    DownloadFromStream(InStr, 'Download', '', '', Filename);
        end;
        exit(false);
    end;

    procedure GetBlobInStream(var BlobStream: InStream): Boolean
    begin
        if filblob.HasValue then begin
            filblob.CreateInStream(BlobStream);
            exit(true);
        end;
        exit(false);
    end;

    procedure GetBlobOutStream(var BlobStream: OutStream): Boolean
    begin
        filblob.CreateOutStream(BlobStream);
        exit(true);
    end;

    // procedure LoadFileToBase64(FilePath: Text): Boolean
    // var
    //     FileIn: File;
    //     FileStream: InStream;
    //     Base64: Codeunit "Base64 Convert";
    //     BlobStream: OutStream;
    //     Base64Content: Text;
    // begin
    //     if not File.Exists(FilePath) then
    //         exit(false);

    //     FileIn.Open(FilePath);
    //     FileIn.CreateInstream(FileStream);
    //     Base64Content := Base64.ToBase64(FileStream);
    //     FileIn.Close;

    //     filblob.CreateOutStream(BlobStream);
    //     BlobStream.WriteText(Base64Content);
    //     exit(true);
    // end;

    // procedure DownloadBlobFromBase64(DownloadPath: Text): Boolean
    // var
    //     FileOut: File;
    //     FileStream: OutStream;
    //     Base64: Codeunit "Base64 Convert";
    //     BlobStream: InStream;
    //     Base64Content: Text;
    // begin
    //     if not filblob.HasValue then
    //         exit(false);

    //     filblob.CreateInStream(BlobStream);
    //     BlobStream.ReadText(Base64Content);

    //     FileOut.Create(DownloadPath);
    //     FileOut.CreateOutstream(FileStream);
    //     Base64.FromBase64(Base64Content, FileStream);
    //     FileOut.Close;
    //     exit(true);
    // end;

    procedure GetBlobAsBase64(var Base64Content: Text): Boolean
    var
        Base64: Codeunit "Base64 Convert";
        BlobStream: InStream;
    begin
        if filblob.HasValue then begin
            filblob.CreateInStream(BlobStream);
            Base64Content := Base64.ToBase64(BlobStream);
            exit(true);
        end;
        exit(false);
    end;

    procedure SetBlobFromBase64(Base64Content: Text): Boolean
    var
        Base64: Codeunit "Base64 Convert";
        BlobStream: OutStream;
    begin
        filblob.CreateOutStream(BlobStream);
        Base64.FromBase64(Base64Content, BlobStream);
        exit(true);
    end;


   





}
