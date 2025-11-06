Table 66004 "Ship Response Header"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 09-01-20 ZY-LD 000 - Ask before delete.
    // 003. 03-12-20 ZY-LD P0499 - New field.
    // 004. 06-08-22 ZY-LD 000 - We need to block the post of single responses with errors.

    Caption = 'Ship Response Header';
    DataCaptionFields = "No.";
    Description = 'Ship Response Header';
    DrillDownPageID = "Shipment Response List";
    LookupPageID = "Shipment Response List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Description = 'PAB 1.0';
        }
        field(2; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            Description = 'PAB 1.0';
        }
        field(3; Status; Code[20])
        {
            Caption = 'Status';
            Description = 'PAB 1.0';
        }
        field(4; "Cost Center"; Code[20])
        {
            Caption = 'Cost Center';
            Description = 'PAB 1.0';
        }
        field(5; "Order Type"; Code[20])
        {
            Caption = 'Order Type';
            Description = 'PAB 1.0';
        }
        field(6; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            Description = 'PAB 1.0';
        }
        field(7; "Receiver Reference"; Code[20])
        {
            Caption = 'Shipper Reference';
            Description = 'PAB 1.0';
        }
        field(8; "Customer Reference"; Text[50])
        {
            Caption = 'Customer Reference';
            Description = 'PAB 1.0';
        }
        field(9; "Customer Message No."; Text[50])
        {
            Caption = 'Customer Message No.';
            Description = 'PAB 1.0';
        }
        field(10; "Picking Date Time"; DateTime)
        {
            Caption = 'Picking Date Time';
            Description = 'PAB 1.0';
        }
        field(11; "Loading Date Time"; DateTime)
        {
            Caption = 'Loading Date Time';
            Description = 'PAB 1.0';
        }
        field(12; "Planned Shipment Date Time"; DateTime)
        {
            Caption = 'Planned Shipment Date Time';
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
        field(23; Incoterm; Code[20])
        {
            Caption = 'Incoterm';
            Description = 'PAB 1.0';
        }
        field(24; City; Text[50])
        {
            Caption = 'City';
            Description = 'PAB 1.0';
        }
        field(25; "Actual Shipment Date Time"; DateTime)
        {
            Caption = 'Actual Shipment Date Time';
            Description = 'PAB 1.0';
        }
        field(26; "Delivery Date Time"; DateTime)
        {
            Caption = 'Delivery Date Time';
            Description = 'PAB 1.0';
        }
        field(27; "System Date Time"; DateTime)
        {
            Caption = 'System Date Time';
            Description = 'PAB 1.0';
        }
        field(28; "Posting Date Time"; DateTime)
        {
            Caption = 'Posting Date Time';
            Description = 'PAB 1.0';
        }
        field(29; "Mode of Transport 2"; Text[30])
        {
            Caption = 'Mode of Transport 2';
            Description = 'PAB 1.0';
        }
        field(30; "Signed By"; Text[250])
        {
            Caption = 'Signed By';
            Description = 'PAB 1.0';
        }
        field(31; "Delivery Remark"; Text[250])
        {
            Caption = 'Delivery Remark';
            Description = 'PAB 1.0';
        }
        field(32; "Delivery Status"; Text[30])
        {
            Caption = 'Delivery Status';
            Description = 'PAB 1.0';
        }
        field(33; "Value 1"; Text[250])
        {
            Caption = 'Value 1';
            Description = 'PAB 1.0';
        }
        field(34; "Value 2"; Text[250])
        {
            Caption = 'Value 2';
            Description = 'PAB 1.0';
        }
        field(35; "Value 3"; Text[250])
        {
            Caption = 'Value 3';
            Description = 'PAB 1.0';
        }
        field(36; "Value 4"; Text[250])
        {
            Caption = 'Value 4';
            Description = 'PAB 1.0';
        }
        field(37; "Value 5"; Text[250])
        {
            Caption = 'Value 5';
            Description = 'PAB 1.0';
        }
        field(38; "Value 6"; Text[250])
        {
            Caption = 'Value 6';
            Description = 'PAB 1.0';
        }
        field(39; "Value 7"; Text[250])
        {
            Caption = 'Value 7';
            Description = 'PAB 1.0';
        }
        field(40; "Value 8"; Text[250])
        {
            Caption = 'Value 8';
            Description = 'PAB 1.0';
        }
        field(41; "Value 9"; Text[250])
        {
            Caption = 'Value 9';
            Description = 'PAB 1.0';
        }
        field(42; "Carrier Service"; Text[50])
        {
            Caption = 'Carrier Service';
            Description = 'PAB 1.0';
        }
        field(43; Pallets; Integer)
        {
            Caption = 'Pallets';
            Description = 'PAB 1.0';
        }
        field(44; Cartons; Integer)
        {
            Caption = 'Cartons';
            Description = 'PAB 1.0';
        }
        field(45; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            Description = 'PAB 1.0';
        }
        field(46; "Nett Weight"; Decimal)
        {
            Caption = 'Nett Weight';
            Description = 'PAB 1.0';
        }
        field(47; "Container ID"; Text[50])
        {
            Caption = 'Container ID';
            Description = 'PAB 1.0';
        }
        field(48; "Container Type"; Code[20])
        {
            Caption = 'Container Type';
            Description = 'PAB 1.0';
        }
        field(49; "Container Height"; Decimal)
        {
            Caption = 'Container Height';
            Description = 'PAB 1.0';
        }
        field(50; "Container Width"; Decimal)
        {
            Caption = 'Container Width';
            Description = 'PAB 1.0';
        }
        field(51; "Container Depth"; Decimal)
        {
            Caption = 'Container Depth';
            Description = 'PAB 1.0';
        }
        field(52; "Container Volume"; Decimal)
        {
            Caption = 'Container Volume';
            Description = 'PAB 1.0';
        }
        field(53; "Container Gross Weight"; Decimal)
        {
            Caption = 'Container Gross Weight';
            Description = 'PAB 1.0';
        }
        field(54; "Container New Weight"; Decimal)
        {
            Caption = 'Container New Weight';
            Description = 'PAB 1.0';
        }
        field(55; "Container Customer Reference"; Text[200])
        {
            Caption = 'Container Customer Reference';
            Description = 'PAB 1.0';
        }
        field(56; "Invoicing Logistic Handling"; Decimal)
        {
            Caption = 'Invoicing Logistic Handling';
            Description = 'PAB 1.0';
        }
        field(57; "Invoicing Handling Charges"; Decimal)
        {
            Caption = 'Invoicing Handling Charges';
            Description = 'PAB 1.0';
        }
        field(58; "Invoicing Transport Cost"; Decimal)
        {
            Caption = 'Invoicing Transport Cost';
            Description = 'PAB 1.0';
        }
        field(59; "Invocing Fuel Surcharge"; Decimal)
        {
            Caption = 'Invocing Fuel Surcharge';
            Description = 'PAB 1.0';
        }
        field(60; "Invoicing Air freight"; Decimal)
        {
            Caption = 'Invoicing Air freight';
            Description = 'PAB 1.0';
        }
        field(61; "Invoicing Third Party Cost"; Decimal)
        {
            Caption = 'Invoicing Third Party Cost';
            Description = 'PAB 1.0';
        }
        field(62; "Invoicing Miscellaneous Cost"; Decimal)
        {
            Caption = 'Invoicing Miscellaneous Cost';
            Description = 'PAB 1.0';
        }
        field(100; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
            Description = '06-08-22 ZY-LD 004';
        }
        field(101; Open; Boolean)
        {
            CalcFormula = exist("Ship Response Line" where("Response No." = field("No."),
                                                            Open = const(true)));
            Caption = 'Open';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
            InitValue = true;
        }
        field(102; "Warehouse Status"; Option)
        {
            Caption = 'Warehouse Status';
            OptionCaption = 'New,Backorder,Ready to Pick,Picking,Packed,Waiting for invoice,Invoice Received,Posted,In Transit,Delivered,Error';
            OptionMembers = New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        }
        field(103; "File Management Entry No."; Integer)
        {
            Caption = 'File Management Entry No.';
            TableRelation = "Zyxel File Management";
        }
        field(104; "Lines With Error"; Boolean)
        {
            BlankZero = true;
            CalcFormula = exist("Ship Response Line" where("Response No." = field("No."),
                                                            "Error Text" = filter(<> '')));
            Caption = 'Lines With Error';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Import Date"; DateTime)
        {
            Caption = 'Import Date';
        }
        field(106; "Qty. Response Lines"; Integer)
        {
            CalcFormula = count("Ship Response Line" where("Response No." = field("No.")));
            Caption = 'Number of Response Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(107; "Qty. Delivery Doc. Lines"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Line" where("Document No." = field("Customer Reference")));
            Caption = 'Number of Delivery Doc. Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(108; "Delivery Document Type"; Option)
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Document Type" where("No." = field("Customer Reference")));
            Caption = 'Delivery Document Type';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Sales,Transfer';
            OptionMembers = Sales,Transfer;
        }
        field(109; "Ship Posted"; Boolean)
        {
            Caption = 'Ship Posted';
        }
        field(110; "Delivery Document is Updated"; Boolean)
        {
            Caption = 'Delivery Document is Updated';
        }
        field(111; "Receipt Posted"; Boolean)
        {
            Caption = 'Receipt Posted';
            Description = '03-12-20 ZY-LD 003';
        }
        field(201; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(210; "After Post Description"; Text[250])
        {
            Caption = 'After Post Description';
        }
        field(211; "Sell-to Customer No."; Code[20])
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Sell-to Customer No." where("No." = field("Customer Reference")));
            Caption = 'Sell-to Customer No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Customer;
        }
        field(212; "Forecast Territory"; Code[20])
        {
            CalcFormula = lookup(Customer."Forecast Territory" where("No." = field("Sell-to Customer No.")));
            Caption = 'Forecast Territory';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Forecast Territory";
        }
        field(213; "Sell-to Customer Name"; Code[100])
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Sell-to Customer Name" where("No." = field("Customer Reference")));
            Caption = 'Sell-to Customer Name';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Customer;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer Reference", "Warehouse Status", "Import Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        recVCKShipResponseLine.SetRange("Response No.", "No.");
        if recVCKShipResponseLine.FindSet(true) then
            repeat
                recVCKShipResponseLine.Delete(true);
            until recVCKShipResponseLine.Next() = 0;

        if recZyFileMgt.Get("File Management Entry No.") then begin
            CalcFields(Open);
            if Open then begin
                if not GuiAllowed or
                   Confirm(Text001)
                then begin
                    recZyFileMgt.Open := true;
                    recZyFileMgt.Modify;
                end;
            end else
                recZyFileMgt.Delete(true);
        end;
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            recWhseSetup.Get;
            recWhseSetup.TestField(recWhseSetup."Whse. Ship Response Nos.");
            "No." := NoSeriesMgt.GetNextNo(recWhseSetup."Whse. Ship Response Nos.", Today, true);
        end;
        "Import Date" := CurrentDatetime;
    end;

    var
        recVCKShipResponseLine: Record "Ship Response Line";
        recZyFileMgt: Record "Zyxel File Management";
        recWhseSetup: Record "Warehouse Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: label 'Do you want to import the document again?';


    procedure ShowResponseFile()
    var
        recZyFileMgt: Record "Zyxel File Management";
        FileMgt: Codeunit "File Management";
        lText001: label 'Save file';
        lText004: label 'GDPdU data for %1 %2 - %3';
    begin
        if recZyFileMgt.Get("File Management Entry No.") then
            FileMgt.DownloadHandler(
              recZyFileMgt.Filename,
              lText001,
              '',
              'XML(*.xml)|*.xml',
              FileMgt.StripNotsupportChrInFileName(FileMgt.GetFileName(recZyFileMgt.Filename)));
    end;


    procedure CloseResponse()
    var
        recRespLine: Record "Ship Response Line";
    begin
        recRespLine.SetRange("Response No.", "No.");
        if recRespLine.FindSet(true) then
            repeat
                recRespLine.Open := false;
                recRespLine.Modify(true);
            until recRespLine.Next() = 0;
    end;
}
