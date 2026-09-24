Table 50078 "Rcpt. Response Header"
{
    Caption = 'Rcpt. Response Header';
    DataCaptionFields = "No.";
    Description = 'VCK PO Response Header';
    DrillDownPageID = "Rcpt. Response List";
    LookupPageID = "Rcpt. Response List";

    fields
    {
        field(1; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(2; Status; Code[20])
        {
            Caption = 'Status';
        }
        field(3; "Cost Center"; Code[20])
        {
            Caption = 'Cost Center';
        }
        field(4; "Order Type"; Code[20])
        {
            Caption = 'Order Type';
        }
        field(5; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
        }
        field(6; "Shipper Reference"; Code[20])
        {
            Caption = 'Shipper Reference';
        }
        field(7; "Customer Reference"; Text[250])
        {
            Caption = 'Customer Reference';

            trigger OnValidate()
            begin
                recRcptRespLine.SetRange("Response No.", "No.");
                if recRcptRespLine.FindSet(true) then
                    repeat
                        if recRcptRespLine."Source Order No." = xRec."Customer Reference" then begin
                            recRcptRespLine.Validate("Source Order No.", "Customer Reference");
                            recRcptRespLine.Modify(true);
                        end;
                    until recRcptRespLine.Next() = 0;
            end;
        }
        field(8; "Customer Message No."; Text[250])
        {
            Caption = 'Customer Message No.';
        }
        field(9; "System Date Time"; DateTime)
        {
            Caption = 'System Date Time';
        }
        field(10; "Receipt Date Time"; DateTime)
        {
            Caption = 'Receipt Date Time';
        }
        field(11; "Posting Date Time"; DateTime)
        {
            Caption = 'Posting Date Time';
        }
        field(13; "Delivery Terms"; Code[20])
        {
            Caption = 'Delivery Terms';
        }
        field(14; "Mode of Transport"; Code[20])
        {
            Caption = 'Mode of Transport';
        }
        field(15; Connote; Code[20])
        {
            Caption = 'Connote';
        }
        field(16; Carrier; Code[20])
        {
            Caption = 'Carrier';
        }
        field(17; Colli; Integer)
        {
            Caption = 'Colli';
        }
        field(18; "Colli Specified"; Boolean)
        {
            Caption = 'Colli Specified';
        }
        field(19; Weight; Decimal)
        {
            Caption = 'Weight';
        }
        field(20; "Weight Specified"; Boolean)
        {
            Caption = 'Weight Specified';
        }
        field(21; Volume; Decimal)
        {
            Caption = 'Volume';
        }
        field(22; "Volume Specified"; Boolean)
        {
            Caption = 'Volume Specified';
        }
        field(23; "Value 1"; Text[250])
        {
            Caption = 'Value 1';
        }
        field(24; "Value 2"; Text[250])
        {
            Caption = 'Value 2';
        }
        field(25; "Value 3"; Text[250])
        {
            Caption = 'Value 3';
        }
        field(26; "Value 4"; Text[250])
        {
            Caption = 'Value 4';
        }
        field(27; "Value 5"; Text[250])
        {
            Caption = 'Value 5';
        }
        field(28; "Value 6"; Text[250])
        {
            Caption = 'Value 6';
        }
        field(29; "Value 7"; Text[250])
        {
            Caption = 'Value 7';
        }
        field(30; "Value 8"; Text[250])
        {
            Caption = 'Value 8';
        }
        field(31; "Value 9"; Text[250])
        {
            Caption = 'Value 9';
        }
        field(32; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(33; Incoterm; Code[20])
        {
            Caption = 'Incoterm';
        }
        field(34; City; Text[250])
        {
            Caption = 'City';
        }
        field(100; "On Hold"; Code[3])
        {
        }
        field(101; Open; Boolean)
        {
            CalcFormula = min("Rcpt. Response Line".Open where("Response No." = field("No."),
                                                                Open = const(true)));
            Caption = 'Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Warehouse Status"; Option)
        {
            Caption = 'Warehouse Status';
            OptionCaption = ' ,Order Sent,Order Sent (2),Goods Received,Putting Away,On Stock';
            OptionMembers = " ","Order Sent","Order Sent (2)","Goods Received","Putting Away","On Stock";
        }
        field(103; "File Management Entry No."; Integer)
        {
            Caption = 'File Management Entry No.';
            TableRelation = "Zyxel File Management";
        }
        field(104; Filename; Text[250])
        {
            CalcFormula = lookup("Zyxel File Management".Filename where("Entry No." = field("File Management Entry No.")));
            Caption = 'Filename';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Import Date"; DateTime)
        {
            Caption = 'Import Date';
        }
        field(108; "Order Type Option"; Option)
        {
            Caption = 'Order Type';
            Editable = false;
            OptionCaption = 'Purchase Order,Sales Return Order,Transfer Order';
            OptionMembers = "Purchase Order","Sales Return Order","Transfer Order";
        }
        field(109; "Receipt Posted"; Boolean)
        {
            Caption = 'Receipt Posted';
        }
        field(110; "Lines With Error"; Boolean)
        {
            BlankZero = true;
            CalcFormula = exist("Rcpt. Response Line" where("Response No." = field("No."),
                                                             "Error Text" = filter(<> '')));
            Caption = 'Lines With Error';
            Editable = false;
            FieldClass = FlowField;
        }
        field(111; "Response Document Send"; Boolean)
        {
            Caption = 'Response Document Send';
        }
        field(112; "Order has been Updated"; Boolean)
        {
            Caption = 'Order has been Updated';
        }
        field(113; "Ship Posted"; Boolean)
        {
            Caption = 'Ship Posted';
        }
        field(201; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(210; "After Post Description"; Text[250])
        {
            Caption = 'After Post Description';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer Reference", "Warehouse Status")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        recRcptRespLine.SetRange("Response No.", "No.");
        if recRcptRespLine.FindSet(true) then
            repeat
                recRcptRespLine.Delete(true);
            until recRcptRespLine.Next() = 0;

        if Open then
            if recZyFileMgt.Get("File Management Entry No.") then begin
                recZyFileMgt.Open := true;
                recZyFileMgt.Modify;
            end;
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            recWhseSetup.Get;
            recWhseSetup.TestField(recWhseSetup."Whse. Rcpt Response Nos.");
            "No." := NoSeriesMgt.GetNextNo(recWhseSetup."Whse. Rcpt Response Nos.", Today, true);
        end;
        "Import Date" := CurrentDatetime;
    end;

    var
        recRcptRespLine: Record "Rcpt. Response Line";
        recZyFileMgt: Record "Zyxel File Management";
        recWhseSetup: Record "Warehouse Setup";
        NoSeriesMgt: Codeunit "No. Series"; //UpgradeReady


    procedure DownloadPhysicalDocument()
    var
        FileMgt: Codeunit "File Management";
        lText001: label 'Download document';
        ZyxelFileManagement: record "Zyxel File Management";
    begin
        // Cloud ready new
        if ZyxelFileManagement.get(rec."Entry No.") then
            ZyxelFileManagement.DownloadBlobToFile(ZyxelFileManagement.Filename);
    end;

    procedure UpdateWarehouseStatus()
    var
        PostRespMgt: Codeunit "Post Rcpt. Response Mgt.";
        lText001: Label 'Do you want to update warehouse status?';
    begin
        if Confirm(lText001, true) then begin
            CalcFields("Lines With Error");
            PostRespMgt.UpdateInboundDocument(Rec);
        end;
    end;

}
