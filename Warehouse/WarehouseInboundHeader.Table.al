Table 50024 "Warehouse Inbound Header"
{
    // 001. 06-02-20 ZY-LD P0388 - Created.
    // 002. 09-07-20 ZY-LD P0455 - Caption on "Shipment Method Code" has changed to "Shipment Method Code / Incoterms".
    // 003. 14-10-21 ZY-LD 2021101210000089 - Handling errors.
    // 004. 21-04-22 ZY-LD 000 - New field.
    // 005. 19-05-22 ZY-LD 2022051910000119 - New field.
    // 006. 13-03-23 ZY-LD 000 - Rename document no.

    Caption = 'Warehouse Inbound Header';
    DrillDownPageID = "Warehouse Inbound List";
    LookupPageID = "Warehouse Inbound List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(3; "Warehouse Status"; Option)
        {
            Caption = 'Warehouse Status';
            Editable = false;
            OptionCaption = ' ,Order Sent,Order Sent (2),Goods Received,Putting Away,On Stock';
            OptionMembers = " ","Order Sent","Order Sent (2)","Goods Received","Putting Away","On Stock";

            trigger OnValidate()
            begin
                "Last Status Update Date" := CurrentDatetime;
            end;
        }
        field(4; "Sender No."; Code[20])
        {
            Caption = 'Sender No.';
            TableRelation = if ("Order Type" = const("Purchase Order")) Vendor
            else
            if ("Order Type" = const("Sales Return Order")) Customer;

            trigger OnValidate()
            begin
                if "Sender No." <> '' then begin
                    case "Order Type" of
                        "order type"::"Purchase Order", "order type"::"Purchase INvoice":
                            begin
                                recVend.Get("Sender No.");
                                "Sender Name" := recVend.Name;
                                "Sender Name 2" := recVend."Name 2";
                                "Sender Address" := recVend.Address;
                                "Sender Address 2" := recVend."Address 2";
                                "Sender Post Code" := recVend."Post Code";
                                "Sender City" := recVend.City;
                                "Sender Country/Region Code" := recVend."Country/Region Code";
                            end;
                        "order type"::"Transfer Order":
                            begin
                                recLocation.Get("Sender No.");
                                "Sender Name" := recLocation.Name;
                                "Sender Name 2" := recLocation."Name 2";
                                "Sender Address" := recLocation.Address;
                                "Sender Address 2" := recLocation."Address 2";
                                "Sender Post Code" := recLocation."Post Code";
                                "Sender City" := recLocation.City;
                                "Sender Country/Region Code" := recLocation."Country/Region Code";
                            end;
                    end;
                end else begin
                    "Sender Name" := '';
                    "Sender Name 2" := '';
                    "Sender Address" := '';
                    "Sender Address 2" := '';
                    "Sender Post Code" := '';
                    "Sender City" := '';
                    "Sender Country/Region Code" := '';
                end;
            end;
        }
        field(5; "Sender Name"; Text[100])
        {
            Caption = 'Sender Name';
            Editable = false;
        }
        field(6; "Sender Name 2"; Text[50])
        {
            Caption = 'Sender Name 2';
            Editable = false;
        }
        field(7; "Sender Address"; Text[100])
        {
            Caption = 'Sender Address';
            Editable = false;
        }
        field(8; "Sender Address 2"; Text[50])
        {
            Caption = 'Sender Address 2';
            Editable = false;
        }
        field(9; "Sender Post Code"; Code[20])
        {
            Caption = 'Sender Post Code';
            Editable = false;
        }
        field(10; "Sender City"; Text[50])
        {
            Caption = 'Sender City';
            Editable = false;
        }
        field(11; "Sender Country/Region Code"; Code[10])
        {
            Caption = 'Sender Country/Region Code';
            Editable = false;
        }
        field(12; "Bill of Lading No."; Code[30])
        {
            Caption = 'Bill of Lading No.';

            trigger OnValidate()
            begin
                Validate("Shipper Reference");
            end;
        }
        field(13; "Container No."; Code[20])
        {
            Caption = 'Container No.';

            trigger OnValidate()
            begin
                Validate("Shipper Reference");
            end;
        }
        field(14; "Estimated Date of Departure"; Date)
        {
            Caption = 'ETD Date';

            trigger OnValidate()
            begin
                recWhseShipDetail.SetRange("Document No.", "No.");
                if recWhseShipDetail.FindSet(true) then begin
                    repeat
                        recWhseShipDetail.ETD := "Estimated Date of Departure";
                        recWhseShipDetail.Modify(true);
                    until recWhseShipDetail.Next() = 0;
                    Message(Text003);
                end;
            end;
        }
        field(15; "Estimated Date of Arrival"; Date)
        {
            Caption = 'ETA Date';

            trigger OnValidate()
            begin
                recWhseShipDetail.SetRange("Document No.", "No.");
                if recWhseShipDetail.FindSet(true) then begin
                    repeat
                        recWhseShipDetail.ETA := "Estimated Date of Arrival";
                        recWhseShipDetail.Modify(true);
                    until recWhseShipDetail.Next() = 0;
                    Message(Text003);
                end;
            end;
        }
        field(16; "Shipping Method"; Code[10])
        {
            Caption = 'Shipping Method Code / Incoterms';
            TableRelation = "Shipment Method";
        }
        field(17; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(18; "Sent to Warehouse Date"; DateTime)
        {
            Caption = 'Sent to Warehouse Date';
            Editable = false;
        }
        field(19; "Last Status Update Date"; DateTime)
        {
            Caption = 'Last Status Update Date';
            Editable = false;
        }
        field(20; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            begin
                recWhseShipDetail.LockTable;
                recWhseShipDetail.SetCurrentkey("Document No.", "Line No.");
                recWhseShipDetail.SetRange("Document No.", "No.");
                if recWhseShipDetail.FindSet(true) then
                    repeat
                        recWhseShipDetail.Location := "Location Code";
                        recWhseShipDetail.Modify(true);
                    until recWhseShipDetail.Next() = 0;

                CalcFields(Warehouse, "Warehouse Name", "Warehouse Address", "Warehouse Country/Region Code");
            end;
        }
        field(21; Warehouse; Option)
        {
            CalcFormula = lookup(Location.Warehouse where(Code = field("Location Code")));
            Caption = 'Warehouse';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,VCK';
            OptionMembers = " ",VCK;
        }
        field(22; "Warehouse Name"; Text[100])
        {
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
            Caption = 'Warehouse Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Warehouse Address"; Text[100])
        {
            CalcFormula = lookup(Location.Address where(Code = field("Location Code")));
            Caption = 'Warehouse Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Warehouse Country/Region Code"; Code[10])
        {
            CalcFormula = lookup(Location."Country/Region Code" where(Code = field("Location Code")));
            Caption = 'Warehouse Country/Region Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Shipper Reference"; Code[30])
        {
            Caption = 'Shipper Reference';
            Editable = false;

            trigger OnValidate()
            begin
                if ZGT.IsZComCompany then
                    ShipperCompany := 'ZCOM'
                else
                    ShipperCompany := 'ZNET';

                if "Container No." <> '' then
                    "Shipper Reference" := StrSubstNo('%1-%2', ShipperCompany, "Container No.")
                else
                    if "Bill of Lading No." <> '' then
                        "Shipper Reference" := StrSubstNo('%1-%2', ShipperCompany, "Bill of Lading No.");
            end;
        }
        field(26; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';

            trigger OnValidate()
            begin
                recWhseShipDetail.SetRange("Document No.", "No.");
                if recWhseShipDetail.FindSet(true) then begin
                    repeat
                        recWhseShipDetail."Expected Receipt Date" := "Expected Receipt Date";
                        recWhseShipDetail.Modify(true);
                    until recWhseShipDetail.Next() = 0;
                    Message(Text003);
                end;
            end;
        }
        field(27; "Sender County"; Code[10])
        {
            Caption = 'Sender County';
        }
        field(28; "Sender Contact"; Text[50])
        {
            Caption = 'Sender Contact';
        }
        field(31; "Completely Received"; Boolean)
        {
            CalcFormula = min("VCK Shipping Detail".Archive where("Document No." = field("No.")));
            Caption = 'Completely Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Warehouse Message No."; Code[10])
        {
            Caption = 'Warehouse Message No.';
        }
        field(33; "Document Status"; Option)
        {
            Caption = 'Document Status';
            OptionCaption = 'Open,Released,Posted,Error';
            OptionMembers = Open,Released,Posted,Error;

            trigger OnValidate()
            begin
                "Last Status Update Date" := CurrentDatetime;
            end;
        }
        field(34; "Message No."; Code[10])
        {
            Caption = 'Message No.';
        }
        field(35; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
        }
        field(36; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            SQLDataType = Integer;
        }
        field(37; "Invoice No."; Code[20])
        {
            CalcFormula = min("VCK Shipping Detail"."Invoice No." where("Document No." = field("No.")));
            Caption = 'Invoice No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Item No. Filter"; Code[20])
        {
            Caption = 'Item No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Item;
        }
        field(39; "No of Inbound Lines"; Integer)
        {
            CalcFormula = count("VCK Shipping Detail" where("Document No." = field("No."),
                                                             "Item No." = field("Item No. Filter")));
            Caption = 'No of Inbound Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Automatic Created"; Boolean)
        {
            Caption = 'Automatic Created';
        }
        field(41; "Error Description"; Text[250])
        {
            Caption = 'Error Description';
        }
        field(43; "Vessel Code"; Code[50])
        {
            Caption = 'Vessel Code';
            Description = '19-05-22 ZY-LD 005';
            TableRelation = Vessel;
        }
        field(97; "Sales Credit Memo is Created"; Boolean)
        {
            CalcFormula = exist("Sales Line" where("Document Type" = const("Credit Memo"),
                                                    "Warehouse Inbound No." = field("No.")));
            Caption = 'Sales Credit Memo is Created';
            Editable = false;
            FieldClass = FlowField;
        }
        field(98; "Automatic Invoice Handling"; Option)
        {
            CalcFormula = lookup(Customer."Automatic Invoice Handling" where("No." = field("Sender No.")));
            Caption = 'Automatic Invoice Handling';
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ","Create Invoice","Create and Post Invoice";
        }
        field(103; "Order Type"; Option)
        {
            Caption = 'Order Type';
            Editable = false;
            OptionCaption = 'Purchase Order,Sales Return Order,Transfer Order,Purchase Invoice';
            OptionMembers = "Purchase Order","Sales Return Order","Transfer Order","Purchase Invoice";
        }
        field(104; "Sent To Warehouse"; Boolean)
        {
            Caption = 'Sent To Warehouse';
        }
        field(105; "Container Details is Sent"; Boolean)
        {
            Caption = 'Container Details is Sent';
        }
        field(106; Comment; Text[250])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Shipper Reference")
        {
        }
        key(Key3; "Expected Receipt Date")
        {
        }
        key(Key4; "Warehouse Status", "Expected Receipt Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        case "Document Status" of
            "document status"::Open,
            "document status"::Error:  // 14-10-21 ZY-LD 003
                begin
                    recWhseShipDetail.LockTable;
                    recWhseShipDetail.SetCurrentkey("Document No.", "Line No.");
                    recWhseShipDetail.SetRange("Document No.", "No.");
                    if recWhseShipDetail.FindSet then
                        repeat
                            recWhseShipDetail2 := recWhseShipDetail;
                            recWhseShipDetail2."Document No." := '';
                            recWhseShipDetail2."Line No." := 0;
                            recWhseShipDetail2.Modify;
                        until recWhseShipDetail.Next() = 0;
                end;
            "document status"::Released:
                begin
                    if "Warehouse Status" < "warehouse status"::"Goods Received" then begin
                        recWhseShipDetail.LockTable;
                        recWhseShipDetail.SetCurrentkey("Document No.", "Line No.");
                        recWhseShipDetail.SetRange("Document No.", "No.");
                        if recWhseShipDetail.FindSet then
                            repeat
                                recWhseShipDetail2 := recWhseShipDetail;
                                recWhseShipDetail2."Document No." := '';
                                recWhseShipDetail2."Line No." := 0;
                                recWhseShipDetail2.Modify;
                            until recWhseShipDetail.Next() = 0;

                        SI.SetMergefield(100, "No.");
                        EmailAddMgt.CreateSimpleEmail('LOGDELWIO', '', '');
                        EmailAddMgt.Send;
                    end else
                        Error(Text002);
                end;
            "document status"::Posted:
                Error(Text001);
        end;
    end;

    trigger OnInsert()
    var
        WarehouseSetup: Record "Warehouse Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            WarehouseSetup.Get;
            WarehouseSetup.TestField("Whse. Inbound Order Nos.");
            NoSeriesMgt.InitSeries(WarehouseSetup."Whse. Inbound Order Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Creation Date" := CurrentDatetime;
    end;

    trigger OnRename()
    begin
        //>> 13-03-23 ZY-LD 006
        recWhseShipDetail.LockTable;
        recWhseShipDetail.SetCurrentkey("Document No.", "Line No.");
        recWhseShipDetail.SetRange("Document No.", xRec."No.");
        if recWhseShipDetail.FindSet then
            repeat
                recWhseShipDetail2 := recWhseShipDetail;
                recWhseShipDetail2."Document No." := "No.";
                recWhseShipDetail2.Modify(true);
            until recWhseShipDetail.Next() = 0;
        //<< 13-03-23 ZY-LD 006
    end;

    var
        recWhseShipDetail: Record "VCK Shipping Detail";
        recWhseShipDetail2: Record "VCK Shipping Detail";
        recVend: Record Vendor;
        recLocation: Record Location;
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        VCKComMgt: Codeunit "VCK Communication Management";
        Text001: label 'You can not delete a posted document.';
        Text002: label 'You can not delete a released document, if goods are received.';
        ZGT: Codeunit "ZyXEL General Tools";
        ShipperCompany: Code[10];
        Text003: label 'Container Details are updated.';


    procedure AssistEdit(): Boolean
    var
        WarehouseSetup: Record "Warehouse Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        WarehouseSetup.Get;
        WarehouseSetup.TestField("Whse. Inbound Order Nos.");
        if NoSeriesMgt.SelectSeries(WarehouseSetup."Whse. Inbound Order Nos.", xRec."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;


    procedure SendContainerDetails(): Boolean
    var
        recServerEnviron: Record "Server Environment";
        ServerFilename: Text;
        FileMgt: Codeunit "File Management";
        recContainerDetail: Record "VCK Shipping Detail";
        repContainerDetail: Report "Container Details";
        lText001: label 'Zyxel Container Details, Inbound Order No. %1.xlsx';
    begin
        if recServerEnviron.ProductionEnvironment then begin
            ServerFilename := FileMgt.ServerTempFileName('xlsx');
            recContainerDetail.Reset;
            recContainerDetail.SetRange("Document No.", "No.");
            repContainerDetail.SetTableview(recContainerDetail);
            repContainerDetail.SaveAsExcel(ServerFilename);
            Clear(EmailAddMgt);
            SI.SetMergefield(100, "No.");
            SI.SetMergefield(101, "Invoice No.");
            SI.SetMergefield(102, "Shipper Reference");
            EmailAddMgt.CreateEmailWithAttachment('HQCONTDET2', '', '', ServerFilename, StrSubstNo(lText001, "No."), false);
            EmailAddMgt.Send;
            FileMgt.DeleteServerFile(ServerFilename);

            "Container Details is Sent" := true;
            Modify;
            Commit;
        end;

        exit(true);
    end;


    procedure PrintContainerDetails()
    var
        recContDetail: Record "VCK Shipping Detail";
    begin
        recContDetail.SetRange("Document No.", "No.");
        Report.RunModal(Report::"Container Details", true, true, recContDetail);
    end;


    procedure CreateSalesCreditMemo(Post: Boolean)
    var
        recSalesHead: Record "Sales Header";
        CreateNormalSalesInvoice: Codeunit "Create Normal Sales Invoice";
    begin
        CreateNormalSalesInvoice.ProcessCreditMemo("No.", Post, true);
        if not Post then begin
            recSalesHead.SetRange("Document Type", recSalesHead."document type"::"Credit Memo");
            recSalesHead.SetRange("Sell-to Customer No.", "Sender No.");
            if recSalesHead.FindLast then begin
                Commit;
                Page.RunModal(Page::"Sales Credit Memo", recSalesHead);
            end;
        end;
    end;


    procedure NewLine()
    var
        recWhseIndbLine: Record "VCK Shipping Detail";
        recWhseIndbLineTmp: Record "VCK Shipping Detail" temporary;
        NextLineno: Integer;
    begin
        recWhseIndbLineTmp.Init;
        recWhseIndbLineTmp.Validate("Container No.", "Container No.");
        recWhseIndbLineTmp.Validate("Shipping Method", "Shipping Method");
        recWhseIndbLineTmp.Validate(ETA, "Estimated Date of Arrival");
        recWhseIndbLineTmp.Validate(ETD, "Estimated Date of Departure");
        recWhseIndbLineTmp.Validate("Expected Receipt Date", "Expected Receipt Date");
        recWhseIndbLineTmp.Validate("Bill of Lading No.", "Bill of Lading No.");
        recWhseIndbLineTmp.Validate(Location, "Location Code");
        recWhseIndbLineTmp.Validate("Document No.", "No.");
        recWhseIndbLineTmp.Validate("Order Type", "Order Type");
        recWhseIndbLineTmp.Insert;
        if Page.RunModal(Page::"Warehouse Document Line Card", recWhseIndbLineTmp) = Action::LookupOK then begin
            recWhseIndbLine.SetRange("Document No.", "No.");
            if recWhseIndbLine.FindLast then
                NextLineno := recWhseIndbLine."Line No." + 10000
            else
                NextLineno := 10000;
            recWhseIndbLine.Reset;

            recWhseIndbLine := recWhseIndbLineTmp;
            recWhseIndbLine."Line No." := NextLineno;
            recWhseIndbLine.Insert(true);
        end;
    end;


    procedure ShowXMLdocument()
    var
        recWhseInbHead: Record "Warehouse Inbound Header";
        WarehouseInboundDocument: XmlPort "Send Inbound Order Request";
    begin
        recWhseInbHead.SetRange("No.", "No.");
        WarehouseInboundDocument.SetTableview(recWhseInbHead);
        WarehouseInboundDocument.Run;
    end;
}
