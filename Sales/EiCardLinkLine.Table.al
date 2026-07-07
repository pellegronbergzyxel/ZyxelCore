Table 76153 "EiCard Link Line"
{
    //30-06-2026 BK #581893

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
        field(100; filblob; blob)
        {

            Caption = 'File blob';
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

    var
        FileMgt: Codeunit "File Management";


    procedure DownloadFile() // CLOUD READY NEW
    var
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        ContentInStream: InStream;
        //OutFile: File;
        OutStream: OutStream;
        FileMgt: Codeunit "File Management";
        Filename: Text;
        newFilename: text;
    begin
        if HttpClient.Get(Link, HttpResponse) and HttpResponse.IsSuccessStatusCode() then begin
            HttpResponse.Content.ReadAs(ContentInStream);
            newFilename := rec."Item No." + '_EICARD.xlsx';
            if DownloadFromStream(ContentInStream, 'Export', '', 'All Files (*.*)|*.*', newFilename) then
                message('fil downloaded');
        end;

    end;
}
