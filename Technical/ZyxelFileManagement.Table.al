Table 66002 "Zyxel File Management"
{
    // 001. 09-01-20 ZY-LD 000 - Delete only file if it's production.
    // 002. 24-02-22 ZY-LD P0767 - New type.
    // 003. 25-05-24 ZY-LD 000 - New Type.

    Caption = 'Zyxel File Management';
    DrillDownPageID = "Zyxel File Management Entries";
    LookupPageID = "Zyxel File Management Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = " ","VCK Purch. Response","VCK Ship. Response","VCK Inventory",LMR,"VCK Stock Correction";
        }
        field(3; Filename; Text[250])
        {
            Caption = 'Filename';

            trigger OnValidate()
            begin
                GetFileType;
            end;
        }
        field(4; Open; Boolean)
        {
            Caption = 'Open';
            InitValue = true;
        }
        field(11; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
        }
        field(12; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(51; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
        }
        field(52; "Error Date"; Date)
        {
            Caption = 'Error Date';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Creation Date", Open)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if recServEnviron.ProductionEnvironment then  // 09-01-20 ZY-LD 001
            FileMgt.DeleteServerFile(Filename);
    end;

    trigger OnInsert()
    begin
        "Entry No." := GetNextEntryNo;
        "Creation Date" := CurrentDatetime;

        recFileMgt.SetRange(Filename, Filename);
        if recFileMgt.FindFirst then begin
            Open := false;

        end;
    end;

    var
        recServEnviron: Record "Server Environment";
        recFileMgt: Record "Zyxel File Management";
        FileMgt: Codeunit "File Management";

    local procedure GetNextEntryNo(): Integer
    var
        recZyFileMgt: Record "Zyxel File Management";
    begin
        if recZyFileMgt.FindLast then
            exit(recZyFileMgt."Entry No." + 1)
        else
            exit(1);
    end;

    local procedure GetFileType(): Integer
    var
        MyFile: File;
        StreamInTest: InStream;
        Buffer: Text;
        SOType: Integer;
        lText001: label 'PurchaseOrderResponse';
        lText002: label 'ShippingOrderResponse';
        lText003: label 'InventoryRequestResponse';
        lText004: label 'StockCorrectionNotification';
        lText005: label 'Zyxel_20';
    begin
        MyFile.Open(Filename);
        MyFile.CreateInstream(StreamInTest);
        while not StreamInTest.eos do begin
            StreamInTest.ReadText(Buffer);
            break;
        end;
        MyFile.Close;

        if StrPos(UpperCase(Buffer), UpperCase(lText001)) > 0 then
            Type := Type::"VCK Purch. Response"
        else
            if StrPos(UpperCase(Buffer), UpperCase(lText002)) > 0 then
                Type := Type::"VCK Ship. Response"
            else
                if StrPos(UpperCase(Buffer), UpperCase(lText003)) > 0 then
                    Type := Type::"VCK Inventory"
                else
                    //>> 24-02-22 ZY-LD 002
                    if StrPos(UpperCase(Buffer), UpperCase(lText004)) > 0 then
                        Type := Type::"VCK Stock Correction"  //<< 24-02-22 ZY-LD 002
                    else
                        //>> 25-05-24 ZY-LD 003
                        if StrPos(UpperCase(Filename), UpperCase(lText005)) > 0 then
                            Type := Type::LMR;  //<< 25-05-24 ZY-LD 003

    end;
}
