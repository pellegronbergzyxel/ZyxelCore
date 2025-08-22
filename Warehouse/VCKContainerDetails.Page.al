Page 50101 "VCK Container Details"
{

    ApplicationArea = Basic, Suite;
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "VCK Shipping Detail";
    SourceTableView = sorting(Archive, "Batch No.")
                      order(descending)
                      where(Archive = const(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ToolTip = 'Container No. is the unique identifier for the container.';
                }
                field("Bill of Lading No."; Rec."Bill of Lading No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ToolTip = 'Bill of Lading No. is the unique identifier for the bill of lading.';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ToolTip = 'Invoice No. is the unique identifier for the invoice.';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ToolTip = 'Purchase Order No. is the unique identifier for the purchase order.';
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ToolTip = 'Purchase Order Line No. is the unique identifier for the purchase order line';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ToolTip = 'Item No. is the unique identifier for the item.';
                }
                field("Pallet No."; Rec."Pallet No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ToolTip = 'Pallet No. is the unique identifier for the pallet.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity to Receive';
                    Visible = false;
                    ToolTip = 'Quantity to Receive is the total quantity of items expected in the container.';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Quantity Received';
                    ToolTip = 'Quantity Received is the total quantity of items that have been received in the container.';
                }
                field("Quantity-""Quantity Received"""; Rec.Quantity - Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Quantity is the difference between the total quantity expected and the quantity received.';
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'ETA Date';
                    ToolTip = 'ETA Date is the expected time of arrival for the container.';
                }
                field(ETD; Rec.ETD)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'ETD Date';
                    ToolTip = 'ETD Date is the expected time of departure for the container.';
                }
                field("Shipping Method"; Rec."Shipping Method")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Shipping Method';
                    ToolTip = 'Shipping Method indicates the method used for shipping the container.';
                    Editable = true;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Order No.';
                    ToolTip = 'Order No. is the unique identifier for the order associated with the container.';
                    Editable = true;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expected Receipt Date';
                    ToolTip = 'Expected Receipt Date is the date when the items in the container are expected to be received.';
                    Editable = true;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Batch No.';
                    ToolTip = 'Batch No. is the unique identifier for the batch of items in the container.';
                    Editable = false;
                }
                field("Previous Batch No."; Rec."Previous Batch No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Previous Batch No.';
                    ToolTip = 'Previous Batch No. is the unique identifier for the previous batch of items in the container.';
                }
                field("Data Received Created"; Rec."Data Received Created")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Data Received Created';
                    ToolTip = 'Data Received Created indicates the date and time when the data for the container was created.';

                }
                field("Data Received Updated"; Rec."Data Received Updated")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Data Received Updated';
                    ToolTip = 'Data Received Updated indicates the date and time when the data for the container was last updated.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Buy-from Vendor No.';
                    ToolTip = 'Buy-from Vendor No. is the unique identifier for the vendor from whom the items are purchased.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Location';
                    ToolTip = 'Location indicates the warehouse or location where the items are stored.';

                }
                field("Original ETA Date"; Rec."Original ETA Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Original ETA Date';
                    ToolTip = 'Original ETA Date is the initial expected time of arrival for the container.';

                }
                field("Previous ETA Date"; Rec."Previous ETA Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Previous ETA Date';
                    ToolTip = 'Previous ETA Date is the last expected time of arrival for the container before the current one.';
                }
                field("Expected Shipping Days"; Rec."Expected Shipping Days")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Expected Shipping Days';
                    ToolTip = 'Expected Shipping Days indicates the number of days expected for shipping the container.';

                }
                field("Original Shipping Days"; Rec."Original Shipping Days")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Original Shipping Days';
                    ToolTip = 'Original Shipping Days indicates the initial number of days expected for shipping the container.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Amount';
                    ToolTip = 'Amount is the total cost of the items in the container, calculated as Quantity * Direct Unit Cost.';
                }
                field("""Expected Shipping Days""-""Original Shipping Days"""; Rec."Expected Shipping Days" - Rec."Original Shipping Days")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Delayed Shipping Days';
                    Visible = false;
                    ToolTip = 'Delayed Shipping Days indicates the difference between the expected and original shipping days.';
                }
                field("Item Category 1 Code"; Rec."Item Category 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Item Category 1 Code';
                    ToolTip = 'Item Category 1 Code is the code for the first category of the item.';
                }
                field("Item Category 2 Code"; Rec."Item Category 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Item Category 2 Code';
                    ToolTip = 'Item Category 2 Code is the code for the second category of the item.';
                }
                field("Item Category 3 Code"; Rec."Item Category 3 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Item Category 3 Code';
                    ToolTip = 'Item Category 3 Code is the code for the third category of the item.';
                }
                // #490711
                field(tobeETA; Rec.tobeETA)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Move to be ETA';
                    ToolTip = 'Move to be ETA indicates whether the item is to be moved to the to-be ETA status.';
                }
                // #490711
                field("Main Warehouse"; Rec."Main Warehouse")
                {   //20-08-2025 BK #523968
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Main Warehouse';
                    ToolTip = 'Main Warehouse indicates the primary warehouse for the item.';
                    Editable = true;
                }

            }
        }
        area(factboxes)
        {
            part(Control8; "VCK Ship. Detail Received")
            {
                Caption = 'Received Details';
                SubPageLink = "Container No." = field("Container No."),
                              "Invoice No." = field("Invoice No."),
                              "Purchase Order No." = field("Purchase Order No."),
                              "Purchase Order Line No." = field("Purchase Order Line No."),
                              "Pallet No." = field("Pallet No."),
                              "Item No." = field("Item No."),
                              Quantity = field(Quantity),
                              "Shipping Method" = field("Shipping Method"),
                              "Order No." = field("Order No.");
            }
            part(Control26; "Warehouse Indbound FactBox")
            {
                Caption = 'Warehouse Indbound Details';
                SubPageLink = "No." = field("Document No.");
            }
            part(Control25; "Purchase Order FactBox")
            {
                Caption = 'Purchase Order Details';
                SubPageLink = "Document Type" = const(Order),
                              "No." = field("Purchase Order No.");
            }
            part(Control3; "Purchase Order Line FactBox")
            {
                SubPageLink = "Document Type" = const(Order),
                              "Document No." = field("Purchase Order No."),
                              "Line No." = field("Purchase Order Line No.");
            }
            part(Control13; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("Item No."),
                              "Location Filter" = field(Location);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Archive Multiple Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Archive Lines';
                Image = Archive;
                ToolTip = 'Archive the selected lines';

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if Confirm(Text001, true, Rec.Count) then
                        if Rec.FindSet(false) then
                            repeat
                                Rec.Archive := true;
                                Rec.Modify();
                            until Rec.Next() = 0;
                end;
            }
            action("Change ETA Date")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change ETA Date';
                Description = 'Change ETA';
                Image = ChangeDate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Change ETA';

                trigger OnAction()
                begin
                    Report.RunModal(50169);
                end;
            }
            action("Update VCK Inbound Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update VCK Inbound Lines';
                Image = UpdateShipment;
                Visible = CreateVCKInboundVisible;
                ToolTip = 'Update VCK Inbound Lines';

                trigger OnAction()
                begin
                    CreateVCKInbound();
                end;
            }
            action("tobeETA Move")
            {
                ApplicationArea = all;
                caption = 'Move to be ETA > ETA';
                Image = MoveDown;
                ToolTip = 'Move to be ETA > ETA';

                trigger OnAction()
                begin
                    rec.movetobeETA();
                end;
            }
        }
        area(navigation)
        {
            action("Warehouse Inbound")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Inbound';
                ToolTip = 'View the warehouse inbound details for the selected container.';
                Image = Document;
                RunObject = Page "Warehouse Inbound Card";
                RunPageLink = "No." = field("Document No.");
            }
            action("Purchase Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Order';
                ToolTip = 'View the purchase order details for the selected container.';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageLink = "No." = field("Purchase Order No.");
                RunPageView = where("Document Type" = const(Order));
            }
            action("Unshipped Quantity")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unshipped Quantity';
                ToolTip = 'View the unshipped quantity for the selected container.';

                Image = Shipment;
                RunObject = Page "Purchase Lines";
                RunPageLink = "Document Type" = const(Order), Type = const(Item), OriginalLineNo = filter(<> 0);

            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                ToolTip = 'View the history of changes made to the container details.';
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    ToolTip = 'View the change log entries for the selected container.';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ChangeLogEntry: Record "Change Log Entry";
                    begin
                        ChangeLogEntry.SetCurrentKey("Table No.", "Date and Time");
                        ChangeLogEntry.SetAscending("Date and Time", false);
                        ChangeLogEntry.SetRange("Table No.", Database::"VCK Shipping Detail");
                        ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(Rec."Entry No."));
                        page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                    end;
                }
            }
        }
        area(reporting)
        {
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print';
                ToolTip = 'Print the container details report.';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    PrintContainerDetails();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Rec."Quantity Received", Rec."Direct Unit Cost");
        Rec."Calculated Quantity" := Rec.Quantity - Rec."Quantity Received";
        Rec.Amount := Rec."Calculated Quantity" * Rec."Direct Unit Cost";
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Data Received Created" <> 0DT then
            if not Confirm(Text003, false) then
                Error(Text002);
    end;

    trigger OnOpenPage()
    begin
        if UserId() = 'jkral' then
            CurrPage.Editable := true;

        SetActions();
    end;

    var
        CreateVCKInboundVisible: Boolean;
        Text001: label 'Do you want to archive %1 line(s)?';
        Text002: label 'You are not allowed to modify lines received after 25-01-19.';
        Text003: label 'The data has been received from electronically.\Are you sure you want to change the line?';

    local procedure CreateVCKInbound()
    var
    begin

    end;

    local procedure SetActions()
    var
        recServEnviron: Record "Server Environment";
    begin
        CreateVCKInboundVisible := not recServEnviron.ProductionEnvironment();
    end;

    local procedure PrintContainerDetails()
    var
        recContDetail: Record "VCK Shipping Detail";
    begin
        recContDetail.SetRange("Batch No.", Rec."Batch No.");
        Report.RunModal(Report::"Container Details", true, true, recContDetail);
    end;
}
