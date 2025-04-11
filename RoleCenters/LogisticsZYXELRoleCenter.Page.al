Page 50219 "Logistics ZYXEL Role Center"
{
    // 001. 05-06-18 ZY-LD 000 - VCK Post.
    // 002. 12-11-18 ZY-LD 2018111310000028 - New functions.

    Caption = 'Logistics ZYXEL Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control99; "Finance Performance")
                {
                    Visible = false;
                }
                part(Control13; "Logistics Activities")
                {
                }
                part(Control1907692008; "My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                part("Company Logo"; "Company Logo")
                {
                    Caption = 'Company Logo';
                    Editable = true;
                    ShowFilter = false;
                }
                part(Control103; "Trailing Sales Orders Chart")
                {
                    Visible = false;
                }
                part(Control106; "My Job Queue")
                {
                    Visible = false;
                }
                part(Control1902476008; "My Vendors")
                {
                }
                part(Control108; "Report Inbox Part")
                {
                }
                systempart(Control1901377608; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Backlog Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Backlog Report';
                Image = "Report";
                RunObject = Report "Backlog Report";
            }
            action("Customer/Item sales")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer/Item sales';
                Image = "Report";
                RunObject = Report "Customer/Item Sales";
            }
            action("Customer - Balance to Date")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer - Balance to Date';
                Image = "Report";
                RunObject = Report "Customer - Balance to Date";
            }
            action("Report Customer - Summary Aging LCY (Year)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Report Customer - Summary Aging LCY (Year)';
                Image = "Report";
                RunObject = Report "Customer - Summary Aging LCY 2";
            }
            action("MR Inventory by Location")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'MR Inventory by Location';
                Image = "Report";
                RunObject = Report "MR Inventory by Loc. Template";
            }
            group(Excel)
            {
                Caption = 'Excel';
                action("Export Customer/Item Sales")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Export Customer/Item Sales';
                    Image = Excel;
                    RunObject = Report "Export Customer/Item Sales";
                }
            }
        }
        area(embedding)
        {
            action("Sales Quotes")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Quotes';
                RunObject = Page "Sales Quotes";
            }
            action("Blanket Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Blanket Orders';
                RunObject = Page "Blanket Sales Orders";
            }
            action("Sales Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            action("Normal, Open")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Normal, Open';
                RunObject = Page "Sales Order List";
                RunPageLink = "Sales Order Type" = const(Normal),
                              Status = const(Open);
            }
            action("EICard, Open")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EICard, Open';
                RunObject = Page "Sales Order List";
                RunPageLink = "Sales Order Type" = const(EICard),
                              Status = const(Open);
            }
            action("Drop Shipment, Open")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Drop Shipment, Open';
                RunObject = Page "Sales Order List";
                RunPageLink = "Sales Order Type" = const("Drop Shipment"),
                              Status = const(Open);
            }
            action("Pending Approval")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pending Approval';
                RunObject = Page "Sales Order List";
                RunPageLink = Status = const("Pending Approval");
            }
            action("Pending Prepayment")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pending Prepayment';
                RunObject = Page "Sales Order List";
                RunPageLink = Status = const("Pending Prepayment");
            }
            action(Released)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Released';
                RunObject = Page "Sales Order List";
                RunPageLink = Status = const(Released);
            }
            action("Delivery Documents")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Documents';
                RunObject = Page "VCK Delivery Document List";
            }
            action("Warehouse Shipments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Shipments';
                RunObject = Page "Warehouse Shipment List";
            }
            action("Sales Return Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Return Orders';
                RunObject = Page "Sales Return Order List";
            }
            action("Sales Invoices")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Invoices';
                RunObject = Page "Sales Invoice List";
            }
            action("Sales Cr. Memos")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Cr. Memos';
                RunObject = Page "Sales Credit Memos";
            }
            action("Purchase Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action(Warehouse)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse';
                RunObject = Page "Purchase Order List";
                RunPageView = where("Location Code" = filter(<> 'EICARD'));
            }
            action(EiCard)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EiCard';
                RunObject = Page "Purchase Order List";
                RunPageView = where("Location Code" = filter('EICARD'));
            }
            action("Purchase Invoices")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
            }
            action("Purchase Cr. Memos")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Cr. Memos';
                RunObject = Page "Purchase Credit Memos";
            }
            action("Warehouse Inbound")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Inbound';
                RunObject = Page "Warehouse Inbound List";
            }
            action(Action123)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse';
                RunObject = Page "Warehouse Inbound List";
                RunPageView = where("Location Code" = filter('EU2' | 'VCK ZNET'));
            }
            action("Drop Shipments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Drop Shipments';
                RunObject = Page "Warehouse Inbound List";
                RunPageView = where("Location Code" = filter(<> 'EU2' & <> 'VCK ZNET'));
            }
            action("Warehouse Receipts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Receipts';
                RunObject = Page "Warehouse Receipts";
            }
            action("Transfer Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Transfer Orders';
                RunObject = Page "Transfer Orders";
            }
            action("Sales Document E-mail")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Document E-mail';
                RunObject = Page "Sales Document E-mail Entries";
            }
            action(Customers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action(Benelux)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Benelux';
                RunObject = Page "Customer List";
                RunPageLink = "Forecast Territory" = const('BNL'),
                              Blocked = const(" ");
            }
            action(Czech)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Czech';
                RunObject = Page "Customer List";
                RunPageLink = "Forecast Territory" = const('CZECH'),
                              Blocked = const(" ");
            }
            action(Germany)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Germany';
                RunObject = Page "Customer List";
                RunPageLink = "Forecast Territory" = const('GERMANY'),
                              Blocked = const(" ");
            }
            action("Great Britain")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Great Britain';
                RunObject = Page "Customer List";
                RunPageLink = "Forecast Territory" = const('GB'),
                              Blocked = const(" ");
            }
            action(Nordics)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Nordics';
                RunObject = Page "Customer List";
                RunPageLink = "Forecast Territory" = const('NORDICS'),
                              Blocked = const(" ");
            }
            action(Partner)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Partner';
                RunObject = Page "Customer List";
                RunPageLink = "Forecast Territory" = const('PARTNER*'),
                              Blocked = const(" ");
            }
            action(Russia)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Russia';
                RunObject = Page "Customer List";
                RunPageLink = "Forecast Territory" = const('RUSSIA'),
                              Blocked = const(" ");
            }
            action(Spain)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Spain';
                RunObject = Page "Customer List";
                RunPageLink = "Forecast Territory" = const('SPAIN'),
                              Blocked = const(" ");
            }
            action(Turkey)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Turkey';
                RunObject = Page "Customer List";
                RunPageLink = "Forecast Territory" = const('TURKEY'),
                              Blocked = const(" ");
            }
            action("Middle East")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Middle East';
                RunObject = Page "Customer List";
                RunPageLink = "Forecast Territory" = const('UAE'),
                              Blocked = const(" ");
            }
            action(Samples)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Samples';
                RunObject = Page "Customer List";
                RunPageLink = "Gen. Bus. Posting Group" = const('SAMPLE|PM ZAS'),
                              Blocked = const(" ");
            }
            action("IC Partner")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'IC Partner';
                RunObject = Page "Customer List";
                RunPageLink = "IC Partner Code" = const('<>'''''),
                              Blocked = const(" ");
            }
            action(eCommerce)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce';
                RunObject = Page "Customer List";
                RunPageLink = Name = const('*eCommerce*');
            }
            action(Vendors)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendors';
                RunObject = Page "Vendor List";
            }
            action(Channel)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Channel';
                RunObject = Page "Vendor List";
                RunPageLink = "Global Dimension 1 Code" = const('CH*');
            }
            action("Service Provider")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Service Provider';
                RunObject = Page "Vendor List";
                RunPageLink = "Global Dimension 1 Code" = const('SP*');
            }
            action(Items)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(Action76)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce';
                Image = Item;
                RunObject = Page "Item List";
            }
            action(Zyxel)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Zyxel';
                RunObject = Page "Item List";
                RunPageLink = "SBU Company" = const("ZCom HQ");
            }
            action(ZNet)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'ZNet';
                RunObject = Page "Item List";
                RunPageLink = "SBU Company" = const("ZNet HQ");
            }
            action("Model Phase (M1)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Model Phase (M1)';
                RunObject = Page "Item List";
                RunPageLink = "HQ Model Phase" = const('M1');
            }
            action("Model Phase (M2)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Model Phase (M2)';
                RunObject = Page "Item List";
                RunPageLink = "HQ Model Phase" = const('M2');
            }
            action("Model Phase (M3)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Model Phase (M3)';
                RunObject = Page "Item List";
                RunPageLink = "HQ Model Phase" = const('M3');
            }
            action("Model Phase (M4)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Model Phase (M4)';
                RunObject = Page "Item List";
                RunPageLink = "HQ Model Phase" = const('M4');
            }
            action("Items (Short)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Items (Short)';
                RunObject = Page "Item List (All fields)";
            }
            action("EICard Cueue")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EICard Cueue';
                RunObject = Page "EiCard Queue";
            }
            action("Sales Invoice Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Invoice Lines';
                RunObject = Page "Sales Invoice Line";
            }
            action(Action35)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EiCard';
                RunObject = Page "Sales Invoice Line";
                RunPageView = where("Sales Order Type" = const(EICard),
                                    "Location Code" = filter('EICARD'));
            }
            action(Normal)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Normal';
                RunObject = Page "Sales Invoice Line";
                RunPageView = where("Sales Order Type" = const(Normal),
                                    "Location Code" = filter('EU2' | 'UPS'));
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action(PurchaseJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Purchases),
                                        Recurring = const(false));
                }
                action(SalesJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Sales),
                                        Recurring = const(false));
                }
                action(CashReceiptJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Receipt Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const("Cash Receipts"),
                                        Recurring = const(false));
                }
                action(PaymentJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Payments),
                                        Recurring = const(false));
                }
                action(ICGeneralJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'IC General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Intercompany),
                                        Recurring = const(false));
                }
                action(GeneralJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(General),
                                        Recurring = const(false));
                }
                action("Item Journals")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                }
                action("Posted Transfer Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Transfer Shipments';
                    RunObject = Page "Posted Transfer Shipments";
                }
                action("Posted Transfer Receipts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Transfer Receipts';
                    RunObject = Page "Posted Transfer Receipts";
                }
                action("Posted Delivery Documents")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Delivery Documents';
                    RunObject = Page "Posted VCK Delivery Documents";
                }
                action("Posted EiCard Queue")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted EiCard Queue';
                    RunObject = Page "Posted EiCard Queue";
                }
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                action("Posted HQ Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted HQ Invoice';
                    RunObject = Page "Posted HQ Invoice";
                }
                action(Action115)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Normal';
                    RunObject = Page "Posted HQ Invoice";
                    RunPageView = where(Type = const(Normal));
                }
                action(Action116)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EiCard';
                    RunObject = Page "Posted HQ Invoice";
                    RunPageView = where(Type = const(EiCard));
                }
                action("Posted HQ Credit Memo")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted HQ Credit Memo';
                    RunObject = Page "Posted HQ Credit Memo";
                }
                action("Invoiced Sales Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoiced Sales Orders';
                    RunObject = Page "Sales Order List - Invoiced";
                }
            }
            group("Company Contracts")
            {
                Caption = 'Company Contracts';
                Image = RegisteredDocs;
                action(Contacts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contacts';
                    RunObject = Page "Company Contract List";
                }
                action(Action119)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customers';
                    RunObject = Page "Company Contract List";
                    RunPageView = where("Business Relation Filter" = filter('CUSTOMER'),
                                        "Business Relation ZX" = const(true));
                }
                action(Action120)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendors';
                    RunObject = Page "Company Contract List";
                    RunPageView = where("Business Relation Filter" = filter('VENDOR'),
                                        "Business Relation ZX" = const(true));
                }
            }
        }
        area(creation)
        {
            action("Sales Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Order';
                Image = NewOrder;
                RunObject = Page "Sales Order";
                RunPageMode = Create;
            }
            action("Sales Invoice")
            {
                AccessByPermission = Page "Sales Invoice List" = X;
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Invoice';
                Image = NewInvoice;
                RunObject = Page "Sales Invoice";
                RunPageMode = Create;
            }
            action("Sales Credit Memo")
            {
                AccessByPermission = Page "Sales Credit Memos" = X;
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Credit Memo';
                Image = NewDocument;
                RunObject = Page "Sales Credit Memo";
                RunPageMode = Create;
            }
            action("Transfer Order")
            {
                AccessByPermission = TableData "Transfer Header" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Transfer Order';
                Image = NewTransferOrder;
                RunObject = Page "Transfer Order";
                RunPageMode = Create;
            }
            action("Purchase Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Order';
                Image = NewOrder;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
            }
            action("Purchase Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Invoice';
                Image = NewInvoice;
                RunObject = Page "Purchase Invoice";
                RunPageMode = Create;
            }
            action("P&urchase Credit Memo")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&urchase Credit Memo';
                Image = NewDocument;
                RunObject = Page "Purchase Credit Memo";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            group(ActionGroup53)
            {
                Caption = 'Journals';
                action(Action85)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                }
                action("Item Reclass. Journal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Reclass. Journal';
                    Image = Worksheet;
                    RunObject = Page "Item Reclass. Journal";
                }
                action("Sales Price Worksheet")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Price Worksheet';
                    Image = Worksheet2;
                    RunObject = Page "Price Worksheet";
                }
            }
            group(VCK)
            {
                Caption = 'VCK';
                action("Process VCK")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Process VCK';
                    Image = Process;
                    RunObject = Codeunit "Zyxel VCK Post Management";
                }
            }
            group(ActionGroup61)
            {
                Caption = 'Warehouse';
                action("Items by Location")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Items by Location';
                    Image = ItemTrackingLedger;
                    RunObject = Page "Items by Location";
                }
                action("Item Ledger Analysis")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Ledger Analysis';
                    Image = AnalysisView;
                    RunObject = Page "Item Ledger Analysis";
                }
                action("Item List MDM View")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item List MDM View';
                    Image = ItemLines;
                    RunObject = Page "Item List MDM View";
                }
                action("Availability pr Location")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Availability pr Location';
                    Image = ItemAvailbyLoc;
                    RunObject = Report "Availability pr. Location";
                }
                action("Location List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Location List';
                    Image = ListPage;
                    RunObject = Page "Location List";
                }
                action("Serial No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Serial No.';
                    Image = SerialNo;
                    RunObject = Page "VCK Delivery Document SNos";
                }
            }
            group(Intercompany)
            {
                Caption = 'Intercompany';
                action("IC Inbox Transactions")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'IC Inbox Transactions';
                    Image = Intercompany;
                    RunObject = Page "IC Inbox Transactions";
                }
                action("IC Outbox Transactions")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'IC Outbox Transactions';
                    Image = IntercompanyOrder;
                    RunObject = Page "IC Outbox Transactions";
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action(Automation)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Automation';
                    Image = Setup;
                    RunObject = Page "Automation Setup";
                }
            }
            action("Navi&gate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
            action(Currencies)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Currencies';
                Image = Currencies;
                RunObject = Page Currencies;
            }
        }
    }

    var
        ZyVCKPost: Codeunit "Zyxel VCK Post Management";
        recWhseSetup: Record "Warehouse Setup";
}
