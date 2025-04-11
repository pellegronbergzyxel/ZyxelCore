Table 50085 "ZY Logistics Cue"
{
    // 001. 12-03-18 ZY-LD 2018030910000257 - New field.
    // 002. 09-04-18 ZY-LD 000 - New field.
    // 003. 18-09-18 ZY-LD 000 - New fields.
    // 004. 15-11-18 ZY-LD 000 - New fields.
    // 005. 03-04-19 ZY-LD 2019032210000177 - New fields.
    // 006. 24-05-19 ZY-LD 000 - New fields.
    // 007. 11-07-19 ZY-LD P0213 - New field.
    // 008. 05-08-19 ZY-LD Released New - Filter added to "Released New".
    // 009. 07-11-19 ZY-LD New fields.
    // 010. 14-11-19 ZY-LD P0332 - New field.
    // 011. 13-12-19 ZY-LD 000 "Warehouse Status" is added to "Sales Orders Not Invoiced"
    // 012. 04-05-20 ZY-LD P0420 - New field.
    // 013. 21-09-20 ZY-LD P0476 - New fields.
    // 014. 22-12-20 ZY-LD P0499 - New fields.
    // 015. 27-01-22 ZY-LD P0751 - New fields.


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Released Posted"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where("Document Status" = const(Released),
                                                                      "Warehouse Status" = const(Posted)));
            Caption = 'Released / Posted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Released Delivered"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where("Document Status" = const(Released),
                                                                      "Warehouse Status" = const(Delivered)));
            Caption = 'Released / Delivered';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Released Waiting"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where("Document Status" = const(Released),
                                                                      "Warehouse Status" = const("Waiting for invoice")));
            Caption = 'Released / Waiting';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Released Ready"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where("Document Status" = const(Released),
                                                                      "Warehouse Status" = const("Ready to Pick")));
            Caption = 'Released / Ready';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Released New"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where("Document Status" = const(Released),
                                                                      "Warehouse Status" = const(New),
                                                                      SentToAllIn = const(false)));
            Caption = 'Released / New';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; New; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where("Document Status" = const(Open)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Sales Orders - Open"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const(Order),
                                                      Status = const(Open),
                                                      "Completely Invoiced" = const(false)));
            Caption = 'All Sales Orders - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Sales Invoices - Open"; Integer)
        {
            AccessByPermission = TableData "Sales Header" = R;
            CalcFormula = count("Sales Header" where("Document Type" = filter(Invoice),
                                                      Status = filter(Open)));
            Caption = 'Sales Invoices - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Sales Credit Memos - Open"; Integer)
        {
            AccessByPermission = TableData "Sales Header" = R;
            CalcFormula = count("Sales Header" where("Document Type" = filter("Credit Memo"),
                                                      Status = filter(Open)));
            Caption = 'Sales Credit Memos - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Error on Ship-to Address"; Integer)
        {
            CalcFormula = count("Ship-to Address");
            Caption = 'Error on Ship-to Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Sales Orders Not Invoiced"; Integer)
        {
            CalcFormula = count("Sales Line" where("Document Type" = const(Order),
                                                    Type = const(Item),
                                                    "Location Code" = field("Location Filter"),
                                                    "Qty. Shipped Not Invoiced" = filter(> 0),
                                                    "Warehouse Status" = field("Warehouse Status Filter")));
            Caption = 'Sales Orders Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "My Sales Orders"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const(Order),
                                                      "Completely Invoiced" = const(false),
                                                      "Salesperson Code" = field("Sales Person Code Filter")));
            Caption = 'My Sales Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "IC Inbox Transaction"; Integer)
        {
            CalcFormula = count("IC Inbox Transaction");
            Caption = 'IC Inbox Transaction';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "IC Outbox Transaction"; Integer)
        {
            CalcFormula = count("IC Outbox Transaction");
            Caption = 'IC Outbox Transaction';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Transfer Orders"; Integer)
        {
            CalcFormula = count("Transfer Header");
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Transfer Orders Wait for Reciv"; Integer)
        {
            CalcFormula = count("Transfer Header" where("Shipping Advice" = const(Partial)));
            Caption = 'Transfer Orders Wait for Recive';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "My Released Ready to Invoice"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where("Document Status" = const(Released),
                                                                      "Warehouse Status" = filter(Posted | "In Transit" | Packed | Delivered | "Waiting for invoice"),
                                                                      "Salesperson Code" = field("Sales Person Code Filter")));
            Caption = 'My Released / Ready to Invoice';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "My EiCards"; Integer)
        {
            CalcFormula = count("EiCard Queue" where("Created By" = field("User ID Filter"),
                                                      Active = const(true)));
            Caption = 'My EiCards';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "SCM New Orders"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const(Order),
                                                      Status = const(Released),
                                                      "Confirmed Shipments" = const(0)));
            Caption = 'New Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "SCM Orders Under Treatment"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const(Order),
                                                      Status = const(Released),
                                                      "Confirmed Shipments" = filter(> 0),
                                                      "Unconfirmed Shipments" = filter(> 0)));
            Caption = 'Orders Under Treatment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Purchase Invoices - Open"; Integer)
        {
            AccessByPermission = TableData "Purchase Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Invoice),
                                                         Status = filter(Open),
                                                         "Related Company" = const(true)));
            Caption = 'Purchase Invoices - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Purchase Credit Memos - Open"; Integer)
        {
            AccessByPermission = TableData "Purchase Header" = R;
            CalcFormula = count("Purchase Header" where("Document Type" = filter("Credit Memo"),
                                                         Status = filter(Open),
                                                         "Related Company" = const(true)));
            Caption = 'Purchase Credit Memos - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Items not Invoiced"; Integer)
        {
            CalcFormula = count("Item Ledger Entry" where("Posting Date" = filter(010118 ..),
                                                           "Invoiced Quantity" = const(0)));
            FieldClass = FlowField;
        }
        field(27; "Not Processed"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where(SentToAllIn = const(true),
                                                                      "Warehouse Status" = const(New),
                                                                      "Warehouse Response Received" = const(false),
                                                                      "Release Date" = field("Release Date Filter")));
            Description = '12-03-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Order Lines Not Shipped"; Integer)
        {
            CalcFormula = count("Sales Line" where("Document Type" = const(Order),
                                                    "Warehouse Status" = filter("Waiting for invoice" | "In Transit" | Posted | Delivered),
                                                    "Quantity Shipped" = const(0),
                                                    "Delivery Document No." = filter(<> '')));
            Caption = 'Order Lines Not Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "Item Can Not Replicate to VCK"; Integer)
        {
            CalcFormula = count(Item where(Inactive = const(false),
                                            Status = filter(<> "End of Life"),
                                            "Tariff No." = filter(''),
                                            "No Tariff Code" = const(false),
                                            IsEICard = const(false)));
            Description = '09-04-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Ship-to Code is missing"; Integer)
        {
            CalcFormula = count("Sales Line" where("Shipment Date Confirmed" = const(true),
                                                    "Shipment Date" = field("Shipment Date Filter"),
                                                    Status = const(Released),
                                                    "Delivery Document No." = filter('DD*'),
                                                    "Location Code" = const('EU2'),
                                                    "BOM Item No." = filter(< '1'),
                                                    "Outstanding Quantity" = filter(> 0),
                                                    "Ship-to Code" = filter('')));
            Caption = 'Ship-to Code is missing';
            Description = '18-09-18 ZY-LD 003';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Ready to Release"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where("Document Status" = const(Open),
                                                                      "Expected Release Date" = field("Requested Delivery Date Filter")));
            Description = '15-11-18 ZY-LD 004';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Unposted EiCard Orders"; Integer)
        {
            CalcFormula = count("EiCard Queue" where(Active = const(true),
                                                      "Purchase Order Status" = const(Posted),
                                                      "Sales Order Status" = const("EiCard Sent to Customer")));
            Caption = 'Unposted EiCard Orders';
            Description = '07-11-19 ZY-LD 009';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Sales Invoices to be Printed"; Integer)
        {
            CalcFormula = count("Sales Invoice Header" where("No. Printed" = const(0),
                                                              "Mark Invoice as Printed" = const(false),
                                                              "Send E-mail at" = field("Send E-mail at Filter 2"),
                                                              "Location Code" = filter(<> 'PP'),
                                                              "Deleted Document" = const(false)));
            Caption = 'Sales Invoices to be Printed';
            Description = '07-11-19 ZY-LD 009';
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "Sales Invoices to be E-mailed"; Integer)
        {
            CalcFormula = count("Sales Document E-mail Entry" where(Sent = const(false),
                                                                     "Send E-mail at" = field("Send E-mail at Filter")));
            Caption = 'Sales Invoices to be E-mailed';
            Description = '07-11-19 ZY-LD 009';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Warehouse Inventory Diff."; Integer)
        {
            BlankZero = true;
            Caption = 'Warehouse Inventory Difference';
            Editable = false;
        }
        field(36; "Sales Quotes"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const(Quote)));
            Caption = 'Sales Quotes';
            FieldClass = FlowField;
        }
        field(37; "Marked Picking Date"; Integer)
        {
            CalcFormula = count("Picking Date Confirmed" where("Marked Entry" = const(true),
                                                                "Outstanding Quantity" = filter(<> 0)));
            Caption = 'Marked Picking Date';
            Description = '22-12-20 ZY-LD 014';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Unconfirmed Picking Date"; Integer)
        {
            CalcFormula = count("Picking Date Confirmed" where("Picking Date Confirmed" = const(false),
                                                                "Outstanding Quantity" = filter(<> 0)));
            Caption = 'Unconfirmed Picking Date';
            Description = '22-12-20 ZY-LD 014';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Confirmed Picking Date"; Integer)
        {
            CalcFormula = count("Picking Date Confirmed" where("Picking Date Confirmed" = const(true),
                                                                "Outstanding Quantity" = filter(<> 0)));
            Caption = 'Confirmed Picking Date';
            Description = '22-12-20 ZY-LD 014';
            FieldClass = FlowField;
        }
        field(40; "RMA Open Tickets"; Integer)
        {
            CalcFormula = count("LMR Open RMAs");
            Caption = 'Open Tickets';
            Description = '27-01-22 ZY-LD 015';
            FieldClass = FlowField;
        }
        field(41; "RMA Required Inventory"; Integer)
        {
            CalcFormula = count("LMR Required Stock");
            Caption = 'Required Inventory';
            Description = '27-01-22 ZY-LD 015';
            FieldClass = FlowField;
        }
        field(42; "Transferred Not Posted"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Line" where("Document Type" = const(Sales),
                                                                    Posted = const(false),
                                                                    "Warehouse Status" = filter("In Transit" | Delivered),
                                                                    "Creation Date" = filter(010122 ..)));
            Caption = 'Transferred Not Posted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Sales Person Code Filter"; Code[10])
        {
            Caption = 'Sales Person Code Filter';
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser";
        }
        field(52; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }
        field(53; "Release Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(54; "Shipment Date Filter"; Date)
        {
            Caption = 'Shipment Date Filter';
            Description = '18-09-18 ZY-LD 003';
            FieldClass = FlowFilter;
        }
        field(55; "Requested Delivery Date Filter"; Date)
        {
            Caption = 'Requested Delivery Date Filter';
            Description = '15-11-18 ZY-LD 004';
            FieldClass = FlowFilter;
        }
        field(56; "Sales Orders - EDI"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const(Order),
                                                      Status = const(Open),
                                                      "Completely Invoiced" = const(false),
                                                      EDI = const(true)));
            Caption = 'Sales Orders - EDI';
            Description = 'Sales Orders - EDI';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Container Details Over Due"; Integer)
        {
            CalcFormula = count("VCK Shipping Detail" where(Archive = const(false),
                                                             "Order Type" = const("Purchase Order"),
                                                             "Expected Receipt Date" = field("Expected Receipt Date Filter")));
            Caption = 'Container Details Over Due';
            Description = '03-04-19 ZY-LD 005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Whse. Purcase Resp. not Posted"; Integer)
        {
            CalcFormula = count("Rcpt. Response Header" where(Open = const(true)));
            Caption = 'Whse. Purcase Response  not Posted';
            Description = '24-05-19 ZY-LD 006';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Whse. Ship Resp. not Posted"; Integer)
        {
            CalcFormula = count("Ship Response Header" where(Open = const(true)));
            Caption = 'Whse. Shipment Response not Posted';
            Description = '24-05-19 ZY-LD 006';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Not Invoiced"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where("Document Status" = filter(Released),
                                                                      "Warehouse Status" = field("Warehouse Status Filter"),
                                                                      "Document Type" = const(Sales),
                                                                      "Sales Invoice is Created" = const(false)));
            Caption = 'Not Invoiced';
            Description = '14-11-19 ZY-LD 010';
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Send Invoice to Customer"; Integer)
        {
            CalcFormula = count("VCK Delivery Document Header" where("Document Status" = filter(Released | Posted),
                                                                      "Warehouse Status" = filter("In Transit" | Delivered),
                                                                      "Document Type" = const(Sales),
                                                                      "Send Invoice When Delivered" = const(true)));
            Caption = 'Send Invoice to Customer';
            Description = '14-11-19 ZY-LD 010';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Return Order Not Credited"; Integer)
        {
            CalcFormula = count("Warehouse Inbound Header" where("Warehouse Status" = const("On Stock"),
                                                                  "Document Status" = const(Released),
                                                                  "Order Type" = const("Sales Return Order"),
                                                                  "Sales Credit Memo is Created" = const(false)));
            Caption = 'Return Order Not Credited';
            Description = '04-05-20 ZY-LD 012';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "Qty. on Sales Order New"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = count("Picking Date Confirmed" where("Picking Date Confirmed" = const(false),
                                                                "Marked Entry" = const(true)));
            Caption = 'Qty. on Sales Order Confirmed (New)';
            Description = '21-09-20 ZY-LD 013';
            Editable = false;
            FieldClass = FlowField;
        }
        field(67; "Qty. on Sales Order Unconf."; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = count("Picking Date Confirmed" where("Picking Date Confirmed" = const(false),
                                                                "Marked Entry" = const(false)));
            Caption = 'Qty. on Sales Order Unconfirmed';
            Description = '21-09-20 ZY-LD 013';
            Editable = false;
            FieldClass = FlowField;
        }
        field(68; "Purchase Orders - Open"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order),
                                                         "Completely Received" = const(false),
                                                         Status = const(Open),
                                                         IsEICard = const(false)));
            Caption = 'Purchase Orders - Open';
            FieldClass = FlowField;
        }
        field(69; "Purchase Orders - Not Sent"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order),
                                                         "FTP Code" = filter(<> ''),
                                                         "EShop Order Sent" = const(false),
                                                         IsEICard = const(false),
                                                         "Completely Received" = const(false)));
            FieldClass = FlowField;
        }
        field(70; "Purchase Orders - Active"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order),
                                                         "Completely Received" = const(false),
                                                         IsEICard = const(false)));
            FieldClass = FlowField;
        }
        field(101; "Expected Receipt Date Filter"; Date)
        {
            Description = '03-04-19 ZY-LD 005';
            FieldClass = FlowFilter;
        }
        field(102; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            Description = '11-07-19 ZY-LD 007';
            FieldClass = FlowFilter;
        }
        field(103; "Send E-mail at Filter"; DateTime)
        {
            Caption = 'Send E-mail at Filter';
            Description = '07-11-19 ZY-LD 009';
            FieldClass = FlowFilter;
        }
        field(104; "Warehouse Status Filter"; Option)
        {
            Caption = 'Warehouse Status Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'New,Backorder,Ready to Pick,Picking,Packed,Waiting for invoice,Invoice Received,Posted,In Transit,Delivered,Error';
            OptionMembers = New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        }
        field(105; "Send E-mail at Filter 2"; DateTime)
        {
            Caption = 'Send E-mail at Filter 2';
            Description = '07-11-19 ZY-LD 009';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure NotInvoiced(var recDelDocHead: Record "VCK Delivery Document Header")
    var
        recCust: Record Customer;
    begin
        recDelDocHead.Reset;
        recDelDocHead.SetCurrentkey("Document Type", "Document Status", "Warehouse Status", "Send Invoice When Delivered");
        recDelDocHead.SetRange("Document Type", recDelDocHead."document type"::Sales);
        recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Released);
        recDelDocHead.SetRange("Sales Invoice is Created", false);
        recDelDocHead.SetFilter("Warehouse Status", '%1..%2|%3..',
          recDelDocHead."warehouse status"::"Waiting for invoice",
          recDelDocHead."warehouse status"::"Invoice Received",
          recDelDocHead.GetWhseStatusToInvoiceOn(false));

        if recDelDocHead.FindSet then begin
            repeat
                if recDelDocHead."Warehouse Status" in [recDelDocHead."warehouse status"::"Waiting for invoice", recDelDocHead."warehouse status"::"Invoice Received"] then begin
                    recCust.Get(recDelDocHead."Sell-to Customer No.");
                    if recCust."Run Auto. Inv. Hand. on WaitFI" then
                        recDelDocHead.Mark(true);
                end else
                    recDelDocHead.Mark(true);
            until recDelDocHead.Next() = 0;
            recDelDocHead.MarkedOnly(true);
        end;
    end;
}
