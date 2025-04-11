Table 76153 "EiCard Link Line"
{
    // 001. 10-09-19 ZY-LD P0290 - Delete file.
    // 002. 20-04-22 ZY-LD 000 - To test download of secure link.

    Caption = 'EiCard Links';
    Description = 'EiCard Links';
    fields
    {
        field(1; UID; Integer)
        {
            AutoIncrement = true;
            Caption = 'UID';
            Description = 'PAB 1.0';
        }
        field(2; "Purchase Order No."; Code[250])
        {
            Caption = 'Purchase Order No.';
            Description = 'PAB 1.0';
            TableRelation = "Purchase Header"."No.";
            ValidateTableRelation = false;
        }
        field(3; "Item No."; Code[250])
        {
            Caption = 'Item No.';
            Description = 'PAB 1.0';
            TableRelation = Item;
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
            Description = 'PAB 1.0';
        }
        field(5; Link; Text[250])
        {
            Caption = 'Link';
            Description = 'PAB 1.0';
            ExtendedDatatype = URL;
        }
        field(6; Filename; Text[250])
        {
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                //>> 10-09-19 ZY-LD 001
                if Filename = '' then
                    if xRec.Filename <> '' then
                        if FileMgt.ServerFileExists(xRec.Filename) then
                            FileMgt.DeleteServerFile(xRec.Filename);
                //<< 10-09-19 ZY-LD 001
            end;
        }
        field(7; "Purchase Order Line No."; Integer)
        {
            Caption = 'Purchase Order Line No.';
        }
        field(8; "Line No."; Integer)
        {
        }
        field(9; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Size (MB)"; Decimal)
        {
            Caption = 'Size (MB)';
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(12; "Reject Description"; Text[250])
        {
            Caption = 'Reject Description';
        }
    }

    keys
    {
        key(Key1; UID)
        {
            Clustered = true;
        }
        key(Key2; "Purchase Order No.", "Purchase Order Line No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //>> 10-09-19 ZY-LD 001
        if Filename <> '' then
            if FileMgt.ServerFileExists(Filename) then
                FileMgt.DeleteServerFile(Filename);
        //<< 10-09-19 ZY-LD 001
    end;

    var
        FileMgt: Codeunit "File Management";


    procedure DownloadFile()
    var
        WebClient: dotnet WebClient;
        ServicePointManager: dotnet ServicePointManager;
        SecurityProtocolType: dotnet SecurityProtocolType;
        FileMgt: Codeunit "File Management";
        Filename: Text;
    begin
        //>> 20-04-22 ZY-LD 002
        Filename := FileMgt.ServerTempFileName('');
        if StrPos(Link, 'https') <> 0 then
            ServicePointManager.SecurityProtocol := SecurityProtocolType.Tls12;
        WebClient := WebClient.WebClient;
        WebClient.DownloadFile(Lowercase(Link), Filename);
        Hyperlink(Filename);
        FileMgt.DeleteServerFile(Filename);
        //<< 20-04-22 ZY-LD 002
    end;
}
