Table 50041 "VCK Delivery Document Header"
{
    // 001. 18-09-18 ZY-LD 2018091010000047 - New field.
    // 002. 09-10-18 ZY-LD 2018091010000047 - Field captions and Table relations is added.
    // 003. 19-11-18 ZY-LD 2018111910000035 - New field.
    // 004. 19-02-19 PAB - Updated for new NAV XML
    // 005. 14-08-19 ZY-LD 2019081410000058 - Sales Person Code is extented from 20 to 50
    // 006. 14-08-19 ZY-LD 000 - Send e-mail if delivery document has been deleted.
    // 007. 01-11-19 ZY-LD P0332 - Invoiced is added to "Document Status", new field.
    // 008. 18-11-19 ZY-LD 000 - Print Serial No.
    // 009. 31-01-20 ZY-LD 000 - Delete lines from Delivery Document Action.
    // 010. 25-02-20 ZY-LD P0398 - New field.
    // 011. 08-04-20 ZY-LD 2020040810000056 - Do not delete DD when warehouse status is picking or larger.
    // 012. 09-07-20 ZY-LD P0455 - Caption on Delivery Terms is changed to "Shipment Method Code / Incoterms".
    // 013. 09-07-20 ZY-LD P0455 - Caption on "Shipment Method Code" has changed to "Shipment Method Code / Incoterms".
    // 014. 14-09-20 ZY-LD 000 - New field.
    // 015. 17-11-20 ZY-LD P0499 - New field. Field 68 and 69 has been shortened from 200 to 80 characters.
    // 016. 26-10-21 ZY-LD 000 - New field.
    // 017. 05-11-21 ZY-LD 2021110310000031 - Delete Comments.
    // 018. 01-12-21 ZY-LD 2021113010000114 - Set "VAT Registration No. Zyxel".
    // 019. 20-12-21 ZY-LD 000 - Code can´t be run from a activity page.
    // 020. 17-02-22 ZY-LD 2022021710000039 - "Ingoterms City" was not set correct.
    // 021. 21-02-22 ZY-LD 000 - "Document Status" is changed to "Open,Released,Posted".
    // 022. 03-03-22 ZY-LD 2022020410000063 - E-mail Delivery Note.
    // 023. 12-04-22 ZY-LD 000 - Field to locate if the warehouse has responded to the shipment.
    // 024. 20-05-22 ZY-LD 000 - New field.
    // 025. 17-10-23 ZY-LD 000 - New field "Order Desk Responsible Code".
    // 026. 18-12-23 ZY-LD 000 - On sample orders we must calculate amount without unit price to post them automatic.
    DrillDownPageID = "VCK Delivery Document List";
    LookupPageID = "VCK Delivery Document List";
    Permissions = TableData "Automation Setup" = m;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Description = 'PAB 1.0';
            NotBlank = true;
        }
        field(2; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            Description = 'PAB 1.0';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(3; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name';
            Description = 'PAB 1.0';
        }
        field(4; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
            Description = 'PAB 1.0';
        }
        field(5; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill-to Address';
            Description = 'PAB 1.0';
        }
        field(6; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
            Description = 'PAB 1.0';
        }
        field(7; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
            Description = 'PAB 1.0';
        }
        field(8; "Bill-to Contact"; Text[100])
        {
            Caption = 'Bill-to Contact';
            Description = 'PAB 1.0';
        }
        field(9; "Bill-to County"; Text[30])
        {
            Caption = 'Bill-to County';
            Description = 'PAB 1.0';
        }
        field(10; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            Description = 'PAB 1.0';
            TableRelation = "Country/Region";
        }
        field(11; "Bill-to Phone"; Text[50])
        {
            Caption = 'Bill-to Phone';
            Description = 'PAB 1.0';
        }
        field(12; "Bill-to TaxID"; Text[50])
        {
            Caption = 'VAT Registration No. (Bill-to)';
            Description = 'PAB 1.0';
        }
        field(13; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            Description = 'PAB 1.0';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(14; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            Description = 'PAB 1.0';
        }
        field(15; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
            Description = 'PAB 1.0';
        }
        field(16; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
            Description = 'PAB 1.0';
        }
        field(17; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
            Description = 'PAB 1.0';
        }
        field(18; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            Description = 'PAB 1.0';
        }
        field(19; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
            Description = 'PAB 1.0';
        }
        field(20; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            Description = 'PAB 1.0';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(21; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
            Description = 'PAB 1.0';
        }
        field(22; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            Description = 'PAB 1.0';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                SetZyxelVATRegistrationNo;  // 01-12-21 ZY-LD 018
            end;
        }
        field(23; "Ship-to Phone"; Text[50])
        {
            Caption = 'Ship-to Phone';
            Description = 'PAB 1.0';
        }
        field(24; "Ship-to TaxID"; Text[50])
        {
            Caption = 'VAT Registration No. (Ship-to)';
            Description = 'PAB 1.0';
        }
        field(25; "Ship-From Code"; Code[10])
        {
            Caption = 'Ship-From Code';
            Description = 'PAB 1.0';
            TableRelation = Location;

            trigger OnValidate()
            begin
                SetZyxelVATRegistrationNo;  // 01-12-21 ZY-LD 018
                Validate("Delivery Terms Terms"); // #492702
            end;
        }
        field(26; "Ship-From Name"; Text[100])
        {
            Caption = 'Ship-From Name';
            Description = 'PAB 1.0';
        }
        field(27; "Ship-From Name 2"; Text[50])
        {
            Caption = 'Ship-From Name 2';
            Description = 'PAB 1.0';
        }
        field(28; "Ship-From Address"; Text[100])
        {
            Caption = 'Ship-From Address';
            Description = 'PAB 1.0';
        }
        field(29; "Ship-From Address 2"; Text[50])
        {
            Caption = 'Ship-From Address 2';
            Description = 'PAB 1.0';
        }
        field(30; "Ship-From City"; Text[30])
        {
            Caption = 'Ship-From City';
            Description = 'PAB 1.0';
        }
        field(31; "Ship-From Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
            Description = 'PAB 1.0';
        }
        field(32; "Ship-From Post Code"; Code[20])
        {
            Caption = 'Ship-From Post Code';
            Description = 'PAB 1.0';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(33; "Ship-From County"; Text[30])
        {
            Caption = 'Ship-From County';
            Description = 'PAB 1.0';
        }
        field(34; "Ship-From Country/Region Code"; Code[10])
        {
            Caption = 'Ship-From Country/Region Code';
            Description = 'PAB 1.0';
            TableRelation = "Country/Region";
        }
        field(35; "Ship-From Phone"; Text[50])
        {
            Caption = 'Ship-From Phone';
            Description = 'PAB 1.0';
        }
        field(36; "Ship-From TaxID"; Text[50])
        {
            Caption = 'Ship-From TaxID';
            Description = 'PAB 1.0';
        }
        field(37; "Bill-to Email"; Text[200])
        {
            Caption = 'Bill-to Email';
            Description = 'PAB 1.0';
        }
        field(38; "Ship-to Email"; Text[200])
        {
            Caption = 'Ship-to Email';
            Description = 'PAB 1.0';
        }
        field(39; "Ship-From Email"; Text[200])
        {
            Caption = 'Ship-From Email';
            Description = 'PAB 1.0';
        }
        field(41; Forwarder; Code[10])
        {
            Caption = 'Forwarder';
            Description = 'PAB 1.0';
            TableRelation = "Shipping Agent".Code;
        }
        field(42; "Delivery Terms City"; Text[50])
        {
            Caption = 'Incoterms City';
            Description = 'PAB 1.0';
        }
        field(43; "Delivery Terms Terms"; Code[20])
        {
            Caption = 'Shipment Method Code / Incoterms';
            Description = 'PAB 1.0';
            TableRelation = "Shipment Method".Code;

            trigger OnValidate()
            begin
                //>> 17-02-22 ZY-LD 020
                if "Delivery Terms Terms" <> '' then begin
                    recShipMethod.Get("Delivery Terms Terms");
                    case recShipMethod."Read Incoterms City From" of
                        recShipMethod."read incoterms city from"::"Ship-to City":
                            "Delivery Terms City" := "Ship-to City";
                        recShipMethod."read incoterms city from"::"Location City":
                            begin
                                recLocation.Get("Ship-From Code");
                                "Delivery Terms City" := recLocation.City;
                            end;
                    end;
                end;
                //<< 17-02-22 ZY-LD 020
            end;
        }
        field(44; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            Description = 'PAB 1.0';
        }
        field(45; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
            Description = 'PAB 1.0';
        }
        field(46; "Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address';
            Description = 'PAB 1.0';
        }
        field(47; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
            Description = 'PAB 1.0';
        }
        field(48; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City';
            Description = 'PAB 1.0';
        }
        field(49; "Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';
            Description = 'PAB 1.0';
        }
        field(50; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
            Description = 'PAB 1.0';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(51; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to County';
            Description = 'PAB 1.0';
        }
        field(52; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            Description = 'PAB 1.0';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                SetZyxelVATRegistrationNo;  // 01-12-21 ZY-LD 018
            end;
        }
        field(53; "Mode Of Transport"; Code[10])
        {
            Caption = 'Mode Of Transport';
            Description = 'PAB 1.0';
            TableRelation = "Transport Method".Code;
        }
        field(54; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            Description = 'PAB 1.0';
        }
        field(55; "Requested Ship Date"; Date)
        {
            Caption = 'Requested Ship Date';
            Description = 'PAB 1.0';
        }
        field(58; "Create User ID"; Code[50])
        {
            Caption = 'Create User ID';
            Description = 'PAB 1.0';
        }
        field(59; "Create Date"; Date)
        {
            Caption = 'Create Date';
            Description = 'PAB 1.0';
        }
        field(60; "Create Time"; Time)
        {
            Caption = 'Create Time';
            Description = 'PAB 1.0';
        }
        field(61; "Project Code"; Code[20])
        {
            Caption = 'Project Code';
            Description = 'PAB 1.0';
        }
        field(62; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Description = 'PAB 1.0';
        }
        field(63; "Warehouse Status"; Option)
        {
            Caption = 'Warehouse Status';
            Description = 'PAB 1.0';
            OptionCaption = 'New,Backorder,Ready to Pick,Picking,Packed,Waiting for invoice,Invoice Received,Posted,In Transit,Delivered,Error';
            OptionMembers = New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;

            trigger OnValidate()
            var
                recDelDocLine: Record "VCK Delivery Document Line";
            begin
                //>> 03-12-20 ZY-LD 015
                recDelDocLine.SetRange("Document No.", "No.");
                if recDelDocLine.FindSet(true) then
                    repeat
                        recDelDocLine.Validate("Warehouse Status", "Warehouse Status");
                        recDelDocLine.Modify;
                    until recDelDocLine.Next() = 0;
                //<< 03-12-20 ZY-LD 015
            end;
        }
        field(64; "Document Type"; Option)
        {
            Caption = 'Source Type';
            Description = 'PAB 1.0';
            OptionCaption = 'Sales,Transfer';
            OptionMembers = Sales,Transfer;
        }
        field(65; "Document Status"; Option)
        {
            Caption = 'Document Status';
            Description = 'PAB 1.0';
            OptionCaption = 'Open,Released,Posted';
            OptionMembers = Open,Released,Posted;
        }
        field(66; SentToAllIn; Boolean)
        {
            Caption = 'Sent to Warehouse';
            Description = 'PAB 1.0';
        }
        field(67; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            Description = 'PAB 1.0';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(68; "Notification Email"; Text[80])
        {
            Caption = 'Notification E-mail';
            Description = 'PAB 1.0';
        }
        field(69; "Confirmation Email"; Text[80])
        {
            Caption = 'Confirmation E-mail';
            Description = 'PAB 1.0';
        }
        field(70; "Picking Date Time"; Text[50])
        {
            Caption = 'Picking Date Time';
            Description = 'PAB 1.0';
        }
        field(71; "Loading Date Time"; Text[50])
        {
            Caption = 'Loading Date Time';
            Description = 'PAB 1.0';
        }
        field(72; "Delivery Date Time"; Text[50])
        {
            Caption = 'Delivery Date Time';
            Description = 'PAB 1.0';
        }
        field(73; "Delivery Remark"; Text[50])
        {
            Caption = 'Delivery Remark';
            Description = 'PAB 1.0';
        }
        field(74; "Delivery Status"; Text[50])
        {
            Caption = 'Delivery Status';
            Description = 'PAB 1.0';
        }
        field(75; "Receiver Reference"; Text[50])
        {
            Caption = 'Receiver Reference';
            Description = 'PAB 1.0';
        }
        field(76; "Shipper Reference"; Text[50])
        {
            Caption = 'Shipper Reference';
            Description = 'PAB 1.0';
        }
        field(77; "Signed By"; Text[50])
        {
            Caption = 'Signed By';
            Description = 'PAB 1.0';
        }
        field(78; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Description = 'PAB 1.0';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                SetZyxelVATRegistrationNo;  // 01-12-21 ZY-LD 018
            end;
        }
        field(79; "Salesperson Code"; Code[50])
        {
            Caption = 'Salesperson Code';
            Description = 'PAB 1.0';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
            end;
        }
        field(80; "Shipment Agent Code"; Code[10])
        {
            Caption = 'Shipment Agent Code';
            Description = 'PAB 1.0';
            TableRelation = "VCK Shipment Agent Code".Code;
        }
        field(81; "Shipment Agent Service"; Code[10])
        {
            Caption = 'Shipment Agent Service';
            Description = 'PAB 1.0';
            TableRelation = "VCK Shipment Agent Service".Code where("Shipment Agent Code" = field("Shipment Agent Code"));
        }
        field(82; PickDate; Date)
        {
            Caption = 'Picking Date';
            Description = 'PAB 1.0';
        }
        field(83; "Delivery Zone"; Option)
        {
            Caption = 'Delivery Zone';
            Description = 'PAB 1.0';
            OptionCaption = 'Zone 1,Zone 2,Zone 3,Zone 4,Zone 5,Zone 6,Zone 7,Zone 8,Zone 9,Zone 10';
            OptionMembers = "Zone 1","Zone 2","Zone 3","Zone 4","Zone 5","Zone 6","Zone 7","Zone 8","Zone 9","Zone 10";
        }
        field(84; "Delivery Days"; Integer)
        {
            Caption = 'Delivery Days';
            Description = 'PAB 1.0';
        }
        field(85; "Expected Delivery Date"; Date)
        {
            Caption = 'Expected Delivery Date';
            Description = 'PAB 1.0';
        }
        field(86; "Delivery Days Adjustment"; Integer)
        {
            Caption = 'Delivery Days Adjustment';
            Description = 'PAB 1.0';
        }
        field(87; "Release Date"; Date)
        {
            Caption = 'Release Date';
            Description = 'PAB 1.0';
        }
        field(88; Weight; Decimal)
        {
            Caption = 'Weight';
            Description = 'PAB 1.0';
        }
        field(89; "Release Time"; Time)
        {
            Caption = 'Release Time';
            Description = 'PAB 1.0';
        }
        field(90; "Order Acknowledged"; Boolean)
        {
            Caption = 'Order Acknowledged';
            Description = 'PAB 1.0';
        }
        field(91; Amount; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("VCK Delivery Document Line"."Line Amount" where("Document No." = field("No."),
                                                                               "Sales Order No." = field("Sales Order No. Filter"),
                                                                               "Do not Calculate Amount" = const(false)));  // 18-12-23 ZY-LD 026
            Caption = 'Amount Excl. VAT';
            DecimalPlaces = 2 : 2;
            Description = '18-09-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(92; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Description = '18-09-18 ZY-LD 001';
            Editable = false;
            TableRelation = Currency;
        }
        field(93; "Division Code"; Code[20])
        {
            CalcFormula = lookup(Customer."Global Dimension 1 Code" where("No." = field("Sell-to Customer No.")));
            Caption = 'Division Code';
            Description = '19-11-18 ZY-LD 003';
            Editable = false;
            FieldClass = FlowField;
        }
        field(94; "Delivery Document is Invoiced"; Boolean)
        {
            CalcFormula = exist("Sales Invoice Line" where("Picking List No." = field("No.")));
            Caption = 'Delivery Document is Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(95; "Send Invoice When Delivered"; Boolean)
        {
            Caption = 'Send Invoice When Delivered';
            Description = '01-11-19 ZY-LD 007';
        }
        field(96; "Is Invoiced"; Boolean)
        {
            CalcFormula = exist("Sales Invoice Line" where("Picking List No." = field("No.")));
            Caption = 'Is Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(97; "Sales Invoice is Created"; Boolean)
        {
            CalcFormula = exist("Sales Line" where("Document Type" = const(Invoice),
                                                    "Picking List No." = field("No.")));
            Caption = 'Sales Invoice is Created';
            Description = '01-11-19 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
        }
        field(98; "No of Lines"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Line" where("Document No." = field("No."),
                                                                    Quantity = filter(<> 0),
                                                                    "Sales Order No." = field("Sales Order No. Filter")));
            Caption = 'No of Lines';
            Description = '01-11-19 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99; "Total Quantity"; Integer)
        {
            CalcFormula = sum("VCK Delivery Document Line".Quantity where("Document No." = field("No."),
                                                                           Quantity = filter(<> 0),
                                                                           "Sales Order No." = field("Sales Order No. Filter")));
            Caption = 'Total Quantity';
            Description = '01-11-19 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Send Invoice to Warehouse"; Boolean)
        {
            CalcFormula = lookup("Shipment Method"."Send Invoice to Warehouse" where(Code = field("Delivery Terms Terms")));
            Caption = 'Send Invoice to Warehouse';
            Description = '01-11-19 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Expected Release Date"; Date)
        {
            Caption = 'Expected Release Date';
            Description = '01-11-19 ZY-LD 007';
        }
        field(102; "Loading Date"; DateTime)
        {
            Caption = 'Loading Date';
        }
        field(103; "Automatic Invoice Handling"; Option)
        {
            CalcFormula = lookup(Customer."Automatic Invoice Handling" where("No." = field("Sell-to Customer No.")));
            Caption = 'Automatic Invoice Handling';
            Description = '14-11-19 ZY-LD 028';
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ","Create Invoice","Create and Post Invoice";
        }
        field(104; "Spec. Order No."; Code[20])
        {
            Caption = 'Spec. Order No.';
            Description = '25-02-20 ZY-LD 010';
        }
        field(105; "Sales Order No. Filter"; Code[20])
        {
            Caption = 'Source No. Filter';
            Description = '14-09-20 ZY-LD 014';
            FieldClass = FlowFilter;
        }
        field(106; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Description = '17-11-20 ZY-LD 015';
            TableRelation = if ("Document Type" = const(Transfer)) "Transfer Header";
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Customs/Shipping Invoice Sent"; Boolean)
        {
            Caption = 'Customs/Shipping Invoice Sent';
            Description = '26-10-21 ZY-LD 016';
        }
        field(109; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Description = '20-05-22 ZY-LD 024';
            TableRelation = Location;
        }
        field(110; "Order Desk Resposible Code"; Code[20])
        {
            Caption = 'Order Desk Resposible Code';
            Description = '17-10-23 ZY-LD 025';
            TableRelation = "Salesperson/Purchaser";
        }
        field(131; "NCTS No."; Code[10])
        {
            Caption = 'NCTS No.';
        }
        field(132; Comment; Boolean)
        {
            CalcFormula = exist("Sales Comment Line" where("Document Type" = const("Delivery Document"),
                                                            "No." = field("No."),
                                                            "Document Line No." = const(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(133; "Handle Waiting for Invoice"; DateTime)
        {
            Caption = 'Handle Waiting for Invoice';
        }
        field(134; "VAT Registration No. Zyxel"; Code[20])
        {
            Caption = 'VAT Registration No. Zyxel';
        }
        field(135; "Run Auto. Inv. Hand. on WaitFI"; Boolean)
        {
            CalcFormula = lookup(Customer."Run Auto. Inv. Hand. on WaitFI" where("No." = field("Sell-to Customer No.")));
            Caption = 'Run Auto. Inv. Handling on Waiting for Invoice';
            Description = '03-12-21 ZY-LD 041';
            Editable = false;
            FieldClass = FlowField;
        }
        field(136; "Warehouse Response Received"; Boolean)
        {
            CalcFormula = exist("Ship Response Header" where("Customer Reference" = field("No.")));
            //"Import Date" = filter(20190701 00:00:00.000..)));
            Caption = 'Warehouse Response Received';
            Description = '12-04-22 ZY-LD 023';
            Editable = false;
            FieldClass = FlowField;
        }
        field(137; "Outstanding Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("VCK Delivery Document Line"."Outstanding Amount (LCY)" where("Document No." = field("No.")));
            Caption = 'Outstanding Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(138; "All Lines are Posted"; Boolean)
        {
            BlankZero = true;
            CalcFormula = - exist("VCK Delivery Document Line" where("Document No." = field("No."),
                                                                     Posted = const(false)));
            Caption = 'All Lines are Posted';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Document Status", "Warehouse Status", "Send Invoice When Delivered")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        recDeliveryNoteComments: Record "VCK Delivery Note Comments";
        recDeliveryDocumentLine: Record "VCK Delivery Document Line";
        recSerialNos: Record "VCK Delivery Document SNos";
        recSalesLine: Record "Sales Line";
        recSalesComLine: Record "Sales Comment Line";
    begin
        //>> 08-04-20 ZY-LD 011
        if "Warehouse Status" > "warehouse status"::Packed then
            Error(Text002, "No.", FieldCaption("Warehouse Status"), "Warehouse Status")
        else
            if "Warehouse Status" > "warehouse status"::Picking then begin
                if not Confirm(Text005, false, "Warehouse Status") then
                    Error('');
            end else
                if SentToAllIn then
                    if not Confirm(Text003, true, FieldCaption("Warehouse Status"), "Warehouse Status") then
                        Error('');
        //<< 08-04-20 ZY-LD 011

        // recSalesLine.SETFILTER("Delivery Document No.","No.");
        // IF recSalesLine.FINDFIRST THEN BEGIN
        //  REPEAT
        //    recSalesLine."Delivery Document No." := '';
        //    recSalesLine.MODIFY;
        //  UNTIL recSalesLine.Next() = 0;
        // END;

        recDeliveryNoteComments.SetRange("Delivery Document No.", "No.");
        if recDeliveryNoteComments.FindFirst then
            recDeliveryNoteComments.Delete(true);

        //>> 05-11-21 ZY-LD 017
        recSalesComLine.SetRange("Document Type", recSalesComLine."document type"::"Delivery Document");
        recSalesComLine.SetRange("No.", "No.");
        recSalesComLine.SetRange("Document Line No.", 0);
        recSalesComLine.DeleteAll(true);
        //<< 05-11-21 ZY-LD 017

        recSerialNos.SetRange("Delivery Document No.", "No.");
        if recSerialNos.FindSet(true) then begin
            ZGT.OpenProgressWindow('', recSerialNos.Count);
            repeat
                ZGT.UpdateProgressWindow(Text006, 0, true);
                recSerialNos.Delete(true);
            until recSerialNos.Next() = 0;
            ZGT.CloseProgressWindow;
        end;

        recDeliveryDocumentLine.SetRange("Document No.", "No.");
        if recDeliveryDocumentLine.FindSet(true) then begin
            recDeliveryDocumentLine.DeletingFromHeader(true);
            repeat
                recDeliveryDocumentLine.Delete(true);
            until recDeliveryDocumentLine.Next() = 0;
            recDeliveryDocumentLine.DeletingFromHeader(false);
        end;

        DeleteActionCodes;  // 31-01-20 ZY-LD 009

        //>> 14-08-19 ZY-LD 006
        if SentToAllIn then begin
            SI.SetMergefield(100, "No.");
            EmailAddMgt.CreateSimpleEmail('LOGDELDD', '', '');
            EmailAddMgt.Send;
        end;
        //<< 14-08-19 ZY-LD 006
    end;

    trigger OnInsert()
    var
        WarehouseSetup: Record "Warehouse Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "No." = '' then begin
            WarehouseSetup.Get;
            WarehouseSetup.TestField("Whse. Delivery Document Nos.");
            NoSeriesMgt.InitSeries(WarehouseSetup."Whse. Delivery Document Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Create User ID" := UserId;
        "Create Date" := Today;
        "Create Time" := Time;
    end;

    trigger OnModify()
    begin
        //>> 31-01-20 ZY-LD 009
        if "Warehouse Status" = "warehouse status"::Delivered then
            DeleteActionCodes;
        //<< 31-01-20 ZY-LD 009
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        recShiptoAdd: Record "Ship-to Address";
        recShiptoFDAdd: Record "Ship-to Address";
        recShipMethod: Record "Shipment Method";
        recLocation: Record Location;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recDeliveryNoteComments: Record "VCK Delivery Note Comments";
        Text001: label 'You must cancel the approval process if you wish to change the %1.';
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        Text002: label 'The document %1 can not be deleted. "%2" is %3.';
        Text003: label 'The document has been released and sent to the warehouse.\"%1" is %2.\Are you sure you want to delete it?';
        Text004: label 'Deletion is cancled.';
        Text005: label 'The document has warehouse status "%1".\Serial numbers attached to this document will also be deleted.\\Are you sure you want to delete?';
        ZGT: Codeunit "ZyXEL General Tools";
        Text006: label 'Delete Serial No.';
        Text007: label '"%1" and "%2" must not be identical.';
        showwarningLabel: Label 'The customer do not allow invoice before delivered status, do want to check Del. document before invoocing';
        showwarningerror: Label 'invoice-create stopped';

    procedure InitRecord()
    begin
    end;

    procedure AssistEdit(): Boolean
    var
        WarehouseSetup: Record "Warehouse Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        WarehouseSetup.Get;
        WarehouseSetup.TestField("Whse. Delivery Document Nos.");
        if NoSeriesMgt.SelectSeries(WarehouseSetup."Whse. Delivery Document Nos.", xRec."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;

    procedure CreateSalesInvoice(Post: Boolean)
    var
        recSalesHead: Record "Sales Header";
        CreateNormalSalesInvoice: Codeunit "Create Normal Sales Invoice";
        Customer: record Customer;
    begin
        //>> 01-11-19 ZY-LD 007
        // 453154 >>
        if GuiAllowed then
            if customer.get(rec."Sell-to Customer No.") then
                if customer."Warning on Not-delivery" and (rec."Warehouse Status" <> rec."warehouse status"::Delivered) then
                    if not confirm(showwarninglabel, true) then
                        error(showwarningerror);
        // 453154 <<

        CreateNormalSalesInvoice.ProcessInvoice("No.", Post, true);
        if not Post then begin
            recSalesHead.SetRange("Document Type", recSalesHead."document type"::Invoice);
            recSalesHead.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
            if recSalesHead.FindLast then begin
                Commit;
                if recSalesHead.Count = 1 then
                    Page.Run(Page::"Sales Invoice", recSalesHead)
                else
                    Page.Run(Page::"Sales Invoice List", recSalesHead);
            end;
        end;
        //<< 01-11-19 ZY-LD 007
    end;

    procedure PrintSerialNo(pDelDocNo: Code[20])
    var
        recDelDocHead: Record "VCK Delivery Document Header";
        SerialNofromDeliveryDoc: Report "Serial No. from Delivery Doc";
    begin
        //>> 18-11-19 ZY-LD 008
        recDelDocHead.SetRange("No.", pDelDocNo);
        SerialNofromDeliveryDoc.SetTableview(recDelDocHead);
        SerialNofromDeliveryDoc.RunModal;
        //<< 18-11-19 ZY-LD 008
    end;

    procedure GetWhseStatusToInvoiceOn(SendWarningEmail: Boolean) rValue: Integer
    var
        recAutoSetup: Record "Automation Setup";
        recEmailAdd: Record "E-mail address";
        ZGT: Codeunit "ZyXEL General Tools";
        LastSendDate: Date;
        lText001: label '"%1" must be set in "%2" before you can create invoice.';
    begin
        recAutoSetup.Get;
        if ZGT.IsRhq and (recAutoSetup."Create Invoice on Whse. Status" < recAutoSetup."create invoice on whse. status"::"In Transit") then
            Error(lText001, recAutoSetup.FieldCaption("Create Invoice on Whse. Status"), recAutoSetup.TableCaption);
        rValue := recAutoSetup."Create Invoice on Whse. Status";
        if (Date2dmy(Today, 2) = 12) and  // December
           (Date2dmy(Today, 1) >= recAutoSetup."Date for EOY Warehouse Status") and
           (recAutoSetup."Date for EOY Warehouse Status" <> 0) and
           (recAutoSetup."Create Inv. on Whse. St. EOY" >= recAutoSetup."create inv. on whse. st. eoy"::"In Transit")
        then begin
            if recEmailAdd.Get('LOGENDOY') then begin
                LastSendDate := Dt2Date(recEmailAdd."Last E-mail Send Date Time");
                if LastSendDate = 0D then
                    LastSendDate := CalcDate('<-1Y>', Today);
                if (Date2dmy(LastSendDate, 3) < Date2dmy(Today, 3)) and
                   (SendWarningEmail)  // 20-12-21 ZY-LD 019
                then begin
                    SI.SetMergefield(100, Format(recAutoSetup."Create Inv. on Whse. St. EOY"));
                    SI.SetMergefield(101, Format(recAutoSetup."Date for EOY Warehouse Status"));
                    SI.SetMergefield(102, Format(recAutoSetup."Create Invoice on Whse. Status"));
                    EmailAddMgt.CreateSimpleEmail(recEmailAdd.Code, '', '');
                    EmailAddMgt.Send;

                    recEmailAdd."Last E-mail Send Date Time" := CurrentDatetime;
                    recEmailAdd.Modify;
                end;
            end;

            rValue := recAutoSetup."Create Inv. on Whse. St. EOY";
        end;
    end;

    local procedure DeleteActionCodes()
    var
        recDelDocAction: Record "Delivery Document Action Code";
    begin
        //>> 31-01-20 ZY-LD 009
        recDelDocAction.SetRange("Delivery Document No.", "No.");
        if recDelDocAction.FindSet(true) then
            repeat
                recDelDocAction.Delete(true);
            until recDelDocAction.Next() = 0;
        //<< 31-01-20 ZY-LD 009
    end;

    procedure EmailCustomsInvoice(ReSend: Boolean)
    var
        recShipToCountry: Record "Country/Region";
        recDelDocHead: Record "VCK Delivery Document Header";
        repCustomsInv: Report "Del. Doc. - Customs Invoice";
        recCust: Record Customer;
        ServerFilename: Text;
        FileMgt: Codeunit "File Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        lText001: label 'Shipping Invoice %1.pdf';
        lText002: Label 'Customs invoice has been sent to the warehouse.';
        lText003: Label 'Email was not sent.\The field "%1" must be ticked off in either "%2" %3 or on "%4" %5 in order to send the customs invoice.';

    begin
        //>> 26-10-21 ZY-LD 029
        if (not "Customs/Shipping Invoice Sent") or ReSend then begin
            if not recCust.Get("Sell-to Customer No.") then;
            recShipToCountry.Get("Ship-to Country/Region Code");
            if recShipToCountry."E-mail Shipping Inv. to Whse." or
               recCust."E-mail Shipping Inv. to Whse."
            then begin
                ServerFilename := FileMgt.ServerTempFileName('');
                recDelDocHead.SetRange("No.", "No.");
                repCustomsInv.SetTableview(recDelDocHead);
                repCustomsInv.UseRequestPage(false);
                repCustomsInv.SaveAsPdf(ServerFilename);

                SI.SetMergefield(64, "No.");
                EmailAddMgt.CreateEmailWithAttachment('VCKSHIPINV', '', '', ServerFilename, StrSubstNo(lText001, "No."), false);
                EmailAddMgt.Send;

                "Customs/Shipping Invoice Sent" := true;
                Modify(true);

                if ReSend then
                    Message(lText002);
            end else
                if ReSend then
                    Message(lText003, recShipToCountry.FieldCaption("E-mail Shipping Inv. to Whse."), recShipToCountry.TableCaption, "Ship-to Country/Region Code", recCust.TableCaption, "Sell-to Customer No.");
        end;
        //<< 26-10-21 ZY-LD 029
    end;

    procedure EmailCustomsInvoiceWithConfirmation()
    var
        lText001: label 'Do you want to e-mail "Customs/Shipping Invoice" %1 to the warehouse?';
    begin
        if Confirm(lText001, true, "No.") then
            EmailCustomsInvoice(true);
    end;

    procedure EmailDeliveryNote()
    var
        recDelDocHead: Record "VCK Delivery Document Header";
        repDeliryNote: Report "Del. Doc. - Delivery Note";
        CustomReportSelection: Record "Custom Report Selection";
        recCust: Record Customer;
        FileMgt: Codeunit "File Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        lText001: label 'Delivery Note %1.pdf';
        CustReptMgt: Codeunit "Custom Report Management";
        ServerFilename: Text;
        OrderEmailAdd: Text;
    begin
        //>> 03-03-22 ZY-LD 022
        if recCust.Get("Sell-to Customer No.") and (recCust."E-mail Deliv. Note at Release") then begin
            CustReptMgt.GetEmailAddress(Database::Customer, "Sell-to Customer No.", CustomReportSelection.Usage::"S.Order", OrderEmailAdd);
            if OrderEmailAdd <> '' then begin
                ServerFilename := FileMgt.ServerTempFileName('');
                recDelDocHead.SetRange("No.", "No.");
                repDeliryNote.SetTableview(recDelDocHead);
                repDeliryNote.UseRequestPage(false);
                repDeliryNote.SaveAsPdf(ServerFilename);

                SI.SetMergefield(64, "No.");
                EmailAddMgt.CreateEmailWithAttachment('DELIRYNOTE', '', '', ServerFilename, StrSubstNo(lText001, "No."), false);
                EmailAddMgt.Send;
            end;
        end;
        //<< 03-03-22 ZY-LD 022
    end;

    local procedure SetZyxelVATRegistrationNo()
    var
        recVATRegNoMatrix: Record "VAT Reg. No. pr. Location";
        lText001: label 'There is no "%1" within the filter.\\%2\\Please contact the Finance Department for the setup.';
        xxxx: Record Customer;
    begin
        //>> 01-12-21 ZY-LD 018
        if not IsTemporary then
            "VAT Registration No. Zyxel" :=
              recVATRegNoMatrix."GetZyxelVATReg/EoriNo"(0, "Ship-From Code", "Ship-to Country/Region Code", "Sell-to Country/Region Code", "Sell-to Customer No.");
        //<< 01-12-21 ZY-LD 018
    end;

    procedure GetShiptoCode() rValue: Code[10]
    begin
        if "Ship-to Code" <> '' then
            if StrPos("Ship-to Code", '.') <> 0 then
                rValue := CopyStr("Ship-to Code", StrPos("Ship-to Code", '.') + 1, MaxStrLen("Ship-to Code"));
    end;
}
