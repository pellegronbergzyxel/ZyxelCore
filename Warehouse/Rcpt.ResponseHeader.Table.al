Table 50078 "Rcpt. Response Header"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 23-10-19 ZY-LD 2019102210000083 - New field.
    // 003. 08-12-21 ZY-LD 2021120810000039 - It happens that delete a document and send a new one to the warehouse. Sometimes the warehouse respond on the wrong document no.
    // 004. 06-05-22 ZY-LD 000 - On Hold.
    // 005. 09-05-22 ZY-LD 000 - New field.
    // 006. 02-11-23 ZY-LD 000 - New field.
    // 007. 04-04-24 ZY-LD 00 - New procedure.

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
            Description = 'PAB 1.0';
        }
        field(2; Status; Code[20])
        {
            Caption = 'Status';
            Description = 'PAB 1.0';
        }
        field(3; "Cost Center"; Code[20])
        {
            Caption = 'Cost Center';
            Description = 'PAB 1.0';
        }
        field(4; "Order Type"; Code[20])
        {
            Caption = 'Order Type';
            Description = 'PAB 1.0';
        }
        field(5; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            Description = 'PAB 1.0';
        }
        field(6; "Shipper Reference"; Code[20])
        {
            Caption = 'Shipper Reference';
            Description = 'PAB 1.0';
        }
        field(7; "Customer Reference"; Text[250])
        {
            Caption = 'Customer Reference';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                //>> 08-12-21 ZY-LD 003
                recRcptRespLine.SetRange("Response No.", "No.");
                if recRcptRespLine.FindSet(true) then
                    repeat
                        if recRcptRespLine."Source Order No." = xRec."Customer Reference" then begin
                            recRcptRespLine.Validate("Source Order No.", "Customer Reference");
                            recRcptRespLine.Modify(true);
                        end;
                    until recRcptRespLine.Next() = 0;
                //<< 08-12-21 ZY-LD 003
            end;
        }
        field(8; "Customer Message No."; Text[250])
        {
            Caption = 'Customer Message No.';
            Description = 'PAB 1.0';
        }
        field(9; "System Date Time"; DateTime)
        {
            Caption = 'System Date Time';
            Description = 'PAB 1.0';
        }
        field(10; "Receipt Date Time"; DateTime)
        {
            Caption = 'Receipt Date Time';
            Description = 'PAB 1.0';
        }
        field(11; "Posting Date Time"; DateTime)
        {
            Caption = 'Posting Date Time';
            Description = 'PAB 1.0';
        }
        field(13; "Delivery Terms"; Code[20])
        {
            Caption = 'Delivery Terms';
            Description = 'PAB 1.0';
        }
        field(14; "Mode of Transport"; Code[20])
        {
            Caption = 'Mode of Transport';
            Description = 'PAB 1.0';
        }
        field(15; Connote; Code[20])
        {
            Caption = 'Connote';
            Description = 'PAB 1.0';
        }
        field(16; Carrier; Code[20])
        {
            Caption = 'Carrier';
            Description = 'PAB 1.0';
        }
        field(17; Colli; Integer)
        {
            Caption = 'Colli';
            Description = 'PAB 1.0';
        }
        field(18; "Colli Specified"; Boolean)
        {
            Caption = 'Colli Specified';
            Description = 'PAB 1.0';
        }
        field(19; Weight; Decimal)
        {
            Caption = 'Weight';
            Description = 'PAB 1.0';
        }
        field(20; "Weight Specified"; Boolean)
        {
            Caption = 'Weight Specified';
            Description = 'PAB 1.0';
        }
        field(21; Volume; Decimal)
        {
            Caption = 'Volume';
            Description = 'PAB 1.0';
        }
        field(22; "Volume Specified"; Boolean)
        {
            Caption = 'Volume Specified';
            Description = 'PAB 1.0';
        }
        field(23; "Value 1"; Text[250])
        {
            Caption = 'Value 1';
            Description = 'PAB 1.0';
        }
        field(24; "Value 2"; Text[250])
        {
            Caption = 'Value 2';
            Description = 'PAB 1.0';
        }
        field(25; "Value 3"; Text[250])
        {
            Caption = 'Value 3';
            Description = 'PAB 1.0';
        }
        field(26; "Value 4"; Text[250])
        {
            Caption = 'Value 4';
            Description = 'PAB 1.0';
        }
        field(27; "Value 5"; Text[250])
        {
            Caption = 'Value 5';
            Description = 'PAB 1.0';
        }
        field(28; "Value 6"; Text[250])
        {
            Caption = 'Value 6';
            Description = 'PAB 1.0';
        }
        field(29; "Value 7"; Text[250])
        {
            Caption = 'Value 7';
            Description = 'PAB 1.0';
        }
        field(30; "Value 8"; Text[250])
        {
            Caption = 'Value 8';
            Description = 'PAB 1.0';
        }
        field(31; "Value 9"; Text[250])
        {
            Caption = 'Value 9';
            Description = 'PAB 1.0';
        }
        field(32; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Description = 'PAB 1.0';
        }
        field(33; Incoterm; Code[20])
        {
            Caption = 'Incoterm';
            Description = 'PAB 1.0';
        }
        field(34; City; Text[250])
        {
            Caption = 'City';
            Description = 'PAB 1.0';
        }
        field(100; "On Hold"; Code[3])
        {
            Description = '06-05-22 ZY-LD 004';
        }
        field(101; Open; Boolean)
        {
            CalcFormula = min("Rcpt. Response Line".Open where("Response No." = field("No."),
                                                                Open = const(true)));
            Caption = 'Open';
            Description = 'PAB 1.0';
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
            Description = '23-10-19 ZY-LD 002';
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
            Description = 'PAB 1.0';
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
            Description = '09-05-22 ZY-LD 005';
        }
        field(112; "Order has been Updated"; Boolean)
        {
            Caption = 'Order has been Updated';
            Description = '09-05-22 ZY-LD 005';
        }
        field(113; "Ship Posted"; Boolean)  // 02-11-23 ZY-LD 006
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
        NoSeriesMgt: Codeunit NoSeriesManagement;


    procedure DownloadPhysicalDocument()
    var
        FileMgt: Codeunit "File Management";
        lText001: label 'Download document';
    begin
        CalcFields(Filename);
        FileMgt.DownloadHandler(Filename, lText001, '', 'XML(*.xml)|*.xml|All files(*.*)|*.*', FileMgt.GetFileName(Filename));
    end;

    procedure UpdateWarehouseStatus()  // 04-04-24 ZY-LD 007
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
