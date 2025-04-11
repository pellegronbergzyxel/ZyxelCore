page 50016 "Sales Manager ZYXEL RTC"
{
    Caption = 'Role Center';
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
                part(Control15; "Sales Revenue Activities")
                {
                    Caption = 'Sales Revenue';
                }
                part(Control1907692008; "My Customers")
                {
                }
                part(Control7; "My Items")
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
                part(Control100; "Cash Flow Forecast Chart")
                {
                }
                part(Control1902476008; "My Vendors")
                {
                }
                part(Control108; "Report Inbox Part")
                {
                }
                /* TODO: Just remove...?
                part(Control1903012608; "Copy Profile")
                {
                }
                */
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
            Action("Backlog Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Backlog Report';
                Image = "Report";
                RunObject = Report "Backlog Report";
            }
            Action("Stock- and Warehouse Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Stock- and Warehouse Report';
                RunObject = Report "Stock- and Warehouse Report";
            }
            Action("Item Ship (Qty.) per Month")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Ship (Qty.) per Month';
                Image = "Report";
                RunObject = Report "Item Ship (Qty.) per Month";
            }
            Action("Availability pr. Location")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Availability pr. Location';
                Image = "Report";
                RunObject = Report "Availability pr. Location";
            }
        }
        area(embedding)
        {
            Action(Items)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            Action(Customers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            Action(CustomersBalance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Customer List";
                RunPageView = where("Balance (LCY)" = filter(<> 0));
            }
            Action("Sales Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            Action("Transfer Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Transfer Orders';
                RunObject = Page "Transfer Orders";
            }
            Action("Backlog Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Backlog Orders';
                Image = OrderList;
                RunObject = Page "Backlog Orders";
            }
            Action("Sales Invoice Line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Invoice Line';
                RunObject = Page "Sales Invoice Line";
            }
            Action("Sales Credit Memo Line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Credit Memo Line';
                RunObject = Page "Sales Cr.Memo Line";
            }
            Action("Delivery Documents")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Documents';
                RunObject = Page "VCK Delivery Document List";
            }
            Action("Items (MDM List)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Items (MDM List)';
                Image = ItemGroup;
                RunObject = Page "Item List MDM View";
            }
            Action("Quantity Stock for Sales")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Quantity Stock for Sales';
                RunObject = Page "Quantity Stock for Sales";
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                Action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                Action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                }
                Action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                Action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                Action("Issued Reminders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                }
                Action("Issued Fin. Charge Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Issued Fin. Charge Memos';
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                }
                Action("G/L Registers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
                Action("Cost Accounting Registers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cost Accounting Registers';
                    RunObject = Page "Cost Registers";
                }
                Action("Cost Accounting Budget Registers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cost Accounting Budget Registers';
                    RunObject = Page "Cost Budget Registers";
                }
            }
            group("Company Contracts")
            {
                Caption = 'Company Contracts';
                Image = RegisteredDocs;
                Action(Contacts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contacts';
                    RunObject = Page "Company Contract List";
                }
                Action(Action22)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customers';
                    RunObject = Page "Company Contract List";
                    RunPageView = where("Business Relation Filter" = filter('CUSTOMER'),
                                        "Business Relation ZX" = const(true));
                }
                Action(Vendors)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendors';
                    RunObject = Page "Company Contract List";
                    RunPageView = where("Business Relation Filter" = filter('VENDOR'),
                                        "Business Relation ZX" = const(true));
                }
            }
        }
        area(processing)
        {
            Action("Items List MDM View")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Items List MDM View';
                Image = Item;
                RunObject = Page "Item List MDM View";
            }
            Action("Goods in Transit")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Goods in Transit';
                Image = Report2;
                RunObject = Page "Goods in Transit";
            }
            Action("Unshipped Purchase Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unshipped Purchase Orders';
                Image = Report2;
                RunObject = Page "Purchase Lines";
                RunPageLink = "Document Type" = const(Order), Type = const(Item), OriginalLineNo = filter(<> 0);
            }
            Action("BacklogOrders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Backlog Orders';
                Image = OrderList;
                RunObject = Page "Backlog Orders";
            }
            group("Report")
            {
                Caption = 'Report';
                Action(Action34)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Backlog Report';
                    Image = "Report";
                    RunObject = Report "Backlog Report";
                }
                Action(Action37)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Availability pr. Location';
                    Image = "Report";
                    RunObject = Report "Availability pr. Location";
                }
                Action(Action6)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Stock- and Warehouse Report';
                    Image = "Report";
                    RunObject = Report "Stock- and Warehouse Report";
                }
                Action(Action20)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Ship (Qty.) per Month';
                    Image = "Report";
                    RunObject = Report "Item Ship (Qty.) per Month";
                }
            }
            group(Navigate)
            {
                Caption = 'Navigate';
                Action("Navi&gate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Navi&gate';
                    Image = Navigate;
                    RunObject = Page Navigate;
                }
            }
        }
    }
}
