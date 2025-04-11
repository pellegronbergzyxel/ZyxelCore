Page 50014 "SCM Zyxel RTC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1902304208; "SCM Activities")
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
            action("Customer/Item Sales")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer/Item Sales';
                Image = "Report";
                RunObject = Report "Customer/Item Sales";
            }
            action("Item Ship (Qty.) per Month")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Ship (Qty.) per Month';
                Image = "Report";
                RunObject = Report "Item Ship (Qty.) per Month";
            }
            action("Availability pr. Location")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Availability pr. Location';
                Image = "Report";
                RunObject = Report "Availability pr. Location";
            }
            action("Confirmation Backlog")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Confirmation Backlog';
                Image = "Report";
                RunObject = Report "Confirmation Backlog";
            }
            action("Backlog Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Backlog Report';
                Image = "Report";
                RunObject = Report "Backlog Report";
            }
            action("MR Inventory Template - Detailed")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'MR Inventory Template - Detailed';
                Image = "Report";
                RunObject = Report "MR Inventory Template";
            }
        }
        area(embedding)
        {
            action(Items)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
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
            action(Eicard)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Eicard';
                RunObject = Page "Purchase Order List";
                RunPageView = where("Location Code" = filter('EICARD'));
            }
            action("Sales Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            action(Action9)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse';
                Image = "Order";
                RunObject = Page "Sales Order List";
                RunPageView = where("Sales Order Type" = filter(<> EICard));
            }
            action(Action2)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Eicard';
                Image = "Order";
                RunObject = Page "Sales Order List";
                RunPageView = where("Sales Order Type" = const(EICard));
            }
            action("Transfer Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Transfer Orders';
                RunObject = Page "Transfer Orders";
            }
            action("Picking Dates")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Picking Dates';
                RunObject = Page "Picking Date Confirmed";
            }
            action("Delivery Documents")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Documents';
                RunObject = Page "VCK Delivery Document List";
            }
            action(Vendors)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
            }
            action(Customers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action("Posted Purchase Receipts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted Purchase Receipts';
                RunObject = Page "Posted Purchase Receipts";
            }
            action(Action30)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse';
                RunObject = Page "Posted Purchase Receipts";
                RunPageView = where("Location Code" = filter(<> 'EICARD'));
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
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
                action(Action5)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
            }
        }
        area(creation)
        {
            action("Purchase Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Order';
                Image = NewOrder;
                RunObject = Page "Purchase Order";
            }
        }
        area(processing)
        {
            action("Forecast Overview")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Forecast Overview';
                Image = Forecast;
                RunObject = Page "Forecast Overview";
            }
            action("Freight Approval No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Freight Approval No.';
                Image = Dimensions;
                RunObject = Page "Freight Approval No.";
            }
            action("MDM Safety Buffer List")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'MDM Safety Buffer List';
                Image = List;
                RunObject = Page "MDM Safety Buffer List";
            }
            action("Goods in Transit (GIT)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Goods in Transit (GIT)';
                Image = TransferReceipt;
                RunObject = Page "VCK Container Details";
            }
            action(Action19)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Journals';
                Image = Journals;
                RunObject = Page "Item Journal";
            }
            action("Item Reclass. Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Reclass. Journal';
                Image = Journal;
                RunObject = Page "Item Reclass. Journal";
            }
            group(History)
            {
                Caption = 'History';
                action("Change Log Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log Entries';
                    Image = ChangeLog;
                    RunObject = Page "Change Log Entries";
                }
                action("Navi&gate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Navi&gate';
                    Image = Navigate;
                    RunObject = Page Navigate;
                }
            }
            group("Report")
            {
                Caption = 'Report';
                action(Action17)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer/Item Sales';
                    Image = "Report";
                    RunObject = Report "Customer/Item Sales";
                }
                action(Action36)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Ship (Qty.) per Month';
                    Image = "Report";
                    RunObject = Report "Item Ship (Qty.) per Month";
                }
                action(Action120)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Availability pr. Location';
                    Image = "Report";
                    RunObject = Report "Availability pr. Location";
                }
                action(Action15)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Confirmation Backlog';
                    Image = "Report";
                    RunObject = Report "Confirmation Backlog";
                }
                action(Action4)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Backlog Report';
                    Image = "Report";
                    RunObject = Report "Backlog Report";
                }
                action(Action122)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'MR Inventory Template - Detailed';
                    Image = "Report";
                    RunObject = Report "MR Inventory Template";
                }
            }
            separator(Action89)
            {
                Caption = 'History';
                IsHeader = true;
            }
        }
    }
}
