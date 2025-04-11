Page 50085 "VCK Delivery Document List"
{
    // 001. 03-10-17 ZY-LD 000 - Confirm added.
    // 002. 05-06-18 ZY-LD 000 - VCK post has changed for a codeunit.
    // 003. 18-09-18 ZY-LD 2018091010000047 - New field "Amount".
    // 004. 11-10-18 ZY-LD 000 - Sorting reversed.
    // 005. 15-11-18 ZY-LD 000 - StyleTextAmount.
    // 006. 19-11-18 ZY-LD 2018111910000035 - New field.
    // 007. 30-04-19 ZY-LD P0225 - "Release Selected" deleted from the menu.
    // 008. 01-05-19 ZY-LD P0226 - "Create Delivery Document Transfer Order" is set to FALSE.
    // 009. 18-11-19 ZY-LD 000 - Print Serial No.
    // 010. 18-11-19 ZY-LD 000 - Change Document Status.
    // 011. 31-01-20 ZY-LD 000 - Update Action Code.
    // 012. 03-12-20 ZY-LD 000 - Release button can be blocked.
    // 013. 29-03-22 ZY-LD 000 - Block release from automation.
    // 014. 23-08-22 ZY-LD 000 - Post response.

    ApplicationArea = Basic, Suite;
    Caption = 'Delivery Document List';
    CardPageID = "VCK Delivery Document";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "VCK Delivery Document Header";
    SourceTableView = order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = true;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = true;
                    DrillDown = true;
                    DrillDownPageID = "VCK Delivery Document";
                    Editable = false;
                    Lookup = true;
                    LookupPageID = "VCK Delivery Document";
                    StyleExpr = StyleText;
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    StyleExpr = StyleText;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Order Desk Resposible Code"; Rec."Order Desk Resposible Code")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Bill-to Name 2"; Rec."Bill-to Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = true;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Bill-to County"; Rec."Bill-to County")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Bill-to Phone"; Rec."Bill-to Phone")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Bill-to TaxID"; Rec."Bill-to TaxID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-to Name 2"; Rec."Ship-to Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-to Phone"; Rec."Ship-to Phone")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-to TaxID"; Rec."Ship-to TaxID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Delivery Zone"; Rec."Delivery Zone")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From Code"; Rec."Ship-From Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From Name"; Rec."Ship-From Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From Name 2"; Rec."Ship-From Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From Address"; Rec."Ship-From Address")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From Address 2"; Rec."Ship-From Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From City"; Rec."Ship-From City")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From Contact"; Rec."Ship-From Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From Post Code"; Rec."Ship-From Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From County"; Rec."Ship-From County")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From Country/Region Code"; Rec."Ship-From Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From Phone"; Rec."Ship-From Phone")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From TaxID"; Rec."Ship-From TaxID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Bill-to Email"; Rec."Bill-to Email")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-to Email"; Rec."Ship-to Email")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Ship-From Email"; Rec."Ship-From Email")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field(Forwarder; Rec.Forwarder)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Delivery Terms City"; Rec."Delivery Terms City")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Delivery Terms Terms"; Rec."Delivery Terms Terms")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Notification Email"; Rec."Notification Email")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Confirmation Email"; Rec."Confirmation Email")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Mode Of Transport"; Rec."Mode Of Transport")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Requested Ship Date"; Rec."Requested Ship Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Create User ID"; Rec."Create User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Create Date"; Rec."Create Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Create Time"; Rec."Create Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Picking Date Time"; Rec."Picking Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Loading Date Time"; Rec."Loading Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Delivery Date Time"; Rec."Delivery Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Delivery Remark"; Rec."Delivery Remark")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Receiver Reference"; Rec."Receiver Reference")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Shipper Reference"; Rec."Shipper Reference")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Release Date"; Rec."Release Date")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Release Time"; Rec."Release Time")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Signed By"; Rec."Signed By")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTextAmount;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Division Code"; Rec."Division Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(SentToAllIn; Rec.SentToAllIn)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sent to Warehouse';
                }
                field("Automatic Invoice Handling"; Rec."Automatic Invoice Handling")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Spec. Order No."; Rec."Spec. Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("All Lines are Posted"; Rec."All Lines are Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part("Customer Details"; "Customer / DD FactBox")
            {
                Caption = 'Customer Details';
                SubPageLink = "No." = field("Sell-to Customer No.");
            }
            part(Control30; "Sales Comment Line FactBox")
            {
                Caption = 'Comment Line';
                SubPageLink = "Document Type" = const("Delivery Document"),
                              "No." = field("No."),
                              "Document Line No." = const(0);
            }
            part(Control21; "Del. Doc. Action Factbox")
            {
                Caption = 'Action Code - Header';
                SubPageLink = "Delivery Document No." = field("No."),
                              "Header / Line" = const(Header);
                SubPageView = sorting("Delivery Document No.", "Comment Type", Sequence);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Serial Numbers")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Serial Numbers';
                Image = SerialNo;
                RunObject = Page "VCK Delivery Document SNos";
                RunPageLink = "Delivery Document No." = field("No.");
                RunPageView = sorting("Serial No.", "Delivery Document No.", "Delivery Document Line No.");

                trigger OnAction()
                var
                    frmSerials: Page "VCK Delivery Document SNos";
                begin
                    //frmSerials.FilterByDeliveryDocument(Rec."No.");
                    //frmSerials.RUNMODAL;
                end;
            }
            action("Country Delivery Days")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Country Delivery Days';
                Image = CountryRegion;
                RunObject = Page "VCK Country Shipment Days";
            }
            action(Customer)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                Visible = Rec."Document Type" = Rec."Document Type"::Sales;

                trigger OnAction()
                var
                    recCustomer: Record Customer;
                    recLocaions: Record Location;
                    CustomerCard: Page "Customer Card";
                begin
                    //>> 03-10-17 ZY-LD 001
                    recCustomer.SetFilter("No.", Rec."Sell-to Customer No.");
                    CustomerCard.SetTableview(recCustomer);
                    CustomerCard.Editable(false);
                    CustomerCard.RunModal;

                    // IF "Document Type" = "Document Type"::Sales THEN BEGIN
                    //  recCustomer.SETFILTER("No.","Sell-to Customer No.");
                    //  IF recCustomer.FINDFIRST THEN BEGIN
                    //    PAGE.RUNMODAL(PAGE::"Customer Card",recCustomer);
                    //  END;
                    // END;
                    // IF "Document Type" = "Document Type"::Transfer THEN BEGIN
                    // recLocaions.SETFILTER(Code,"Sell-to Customer No.");
                    //  IF recLocaions.FINDFIRST THEN BEGIN
                    //    PAGE.RUNMODAL(5703,recLocaions);
                    //  END;
                    // END;
                    //<< 03-10-17 ZY-LD 001
                end;
            }
            action(Location)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Location';
                Image = Warehouse;
                Promoted = true;
                PromotedCategory = Process;
                Visible = Rec."Document Type" = Rec."Document Type"::Transfer;

                trigger OnAction()
                var
                    recLocaions: Record Location;
                    LocationCard: Page "Location Card";
                begin
                    //>> 03-10-17 ZY-LD 001
                    recLocaions.SetFilter(Code, Rec."Ship-to Code");
                    LocationCard.SetTableview(recLocaions);
                    LocationCard.Editable(false);
                    LocationCard.RunModal;

                    // IF "Document Type" = "Document Type"::Sales THEN BEGIN
                    //  recCustomer.SETFILTER("No.","Ship-to Code");
                    //  IF recCustomer.FINDFIRST THEN BEGIN
                    //    PAGE.RUNMODAL(21,recCustomer);
                    //  END;
                    // END;
                    // IF "Document Type" = "Document Type"::Transfer THEN BEGIN
                    // recLocaions.SETFILTER(Code,"Ship-to Code");
                    //  IF recLocaions.FINDFIRST THEN BEGIN
                    //    PAGE.RUNMODAL(PAGE::"Location Card",recLocaions);
                    //  END;
                    // END;
                    //<< 03-10-17 ZY-LD 001
                end;
            }
            action("Co&mments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Sales Comment Sheet";
                RunPageLink = "Document Type" = const("Delivery Document"),
                              "No." = field("No."),
                              "Document Line No." = const(0);
            }
            group("Action Codes")
            {
                Caption = 'Action Codes';
                action(Action25)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Action Codes';
                    Image = "Action";

                    trigger OnAction()
                    begin
                        DelDocMgt.EnterDelDocActionCode(Rec."No.");
                    end;
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Show Posted Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Posted Sales Invoice';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoice";
                    RunPageLink = "Picking List No." = field("No.");
                }
                action("Warehouse Response")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Response';
                    Image = WarehouseRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Shipment Response List";
                    RunPageLink = "Customer Message No." = field("No.");
                }
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field("No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(50041));
                }
            }
        }
        area(processing)
        {
            action("Change Status")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Status';
                Image = ChangeStatus;

                trigger OnAction()
                var
                    Change: Report "Change Warehouse Status";
                begin
                    Change.InitReport(
                      Rec."No.",
                      Rec."Warehouse Status",
                      Rec."Document Status",  // 18-11-19 ZY-LD 010
                      true);  // 23-08-22 ZY-LD 014
                    Change.Run;
                    CurrPage.Update;
                end;
            }
            action(Release)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Release';
                Enabled = ReleaseEnabled;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ReleaseDeliveryDoc: Codeunit "Release Delivery Document";
                begin
                    ReleaseDeliveryDoc.PerformManualRelease(Rec);
                end;
            }
            action(ReOpen)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'ReOpen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ReleaseDeliveryDoc: Codeunit "Release Delivery Document";
                begin
                    ReleaseDeliveryDoc.PerformManualReopen(Rec);
                end;
            }
            action("Create Delivery Documents Sales Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Delivery Documents Sales Order';
                Image = Shipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Create Delivery Documents for all sales orders.';

                trigger OnAction()
                begin
                    DelDocMgt.PerformManuelCreation;
                    CurrPage.Update;
                end;
            }
            group("Function")
            {
                Caption = 'Function';
                action("Create Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Sales Invoice';
                    Image = Invoice;
                    Visible = CreateSalesInvoiceVisible;

                    trigger OnAction()
                    begin
                        Rec.CreateSalesInvoice(false);  // 15-11-19 ZY-LD 014
                    end;
                }
                action("Send Sales Invoice to Customer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Sales Invoice to Customer';
                    Image = Invoice;
                    Visible = SendSalesInvoiceVisible;

                    trigger OnAction()
                    begin
                        Rec.CreateSalesInvoice(false);  // 15-11-19 ZY-LD 014
                    end;
                }
            }
            group("Report")
            {
                Caption = 'Report';
                action("Print Delivery Note")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Delivery Note';
                    Image = Print;

                    trigger OnAction()
                    begin
                        recDelDocHead.SetRange("No.", Rec."No.");
                        Report.Run(Report::"Del. Doc. - Delivery Note", true, false, recDelDocHead);
                    end;
                }
                action("Send Customs Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Customs Invoice';
                    Image = SendToMultiple;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.EmailCustomsInvoiceWithConfirmation;
                    end;
                }
                action("Print Customs Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Customs Invoice';
                    Image = Print;

                    trigger OnAction()
                    begin
                        recDelDocHead.SetRange("No.", Rec."No.");
                        Report.Run(Report::"Del. Doc. - Customs Invoice", true, false, recDelDocHead);
                    end;
                }
                action("Print Serial No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Serial No.';
                    Image = "Report";

                    trigger OnAction()
                    begin
                        Rec.PrintSerialNo(Rec."No.");  // 18-11-19 ZY-LD 009
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;  // 15-11-18 ZY-LD 005

        StyleText := '';
        if Rec."Warehouse Status" = Rec."warehouse status"::Error then begin
            StyleText := 'Unfavorable';
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Backorder then begin
            StyleText := 'Ambiguous';
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Ready to Pick" then begin
            StyleText := 'Ambiguous';
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Picking then begin
            StyleText := 'Ambiguous';
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Packed then begin
            StyleText := 'Ambiguous';
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Waiting for invoice" then begin
            StyleText := 'Ambiguous';
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Invoice Received" then begin
            StyleText := 'Ambiguous';
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Posted then begin
            StyleText := 'Favorable';
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"In Transit" then begin
            StyleText := 'Ambiguous';
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Delivered then begin
            StyleText := 'Favorable';
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."Document Status" = Rec."document status"::Released then
            Error(Text004);
    end;

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then;  // 11-10-18 ZY-LD 004

        //UpdateActionCodes;  // 31-01-20 ZY-LD 011
    end;

    var
        Text001: label 'The Delivery Document %1 has already been released.';
        Text002: label 'Delivery Document %1 has been released.';
        Text003: label 'Are you sure that you want to releses selected delivery order(s)? \Once released they will be sent to All-In Logistics and cannot be changed.';
        Text004: label 'You cannot delete a Released Delivery Document.';
        recCtryChipDay: Record "VCK Country Shipment Days";
        recDelDocHead: Record "VCK Delivery Document Header";
        recAutoSetup: Record "Automation Setup";
        DelDocMgt: Codeunit "Delivery Document Management";
        DocumentStatus: Option All,New,Released;
        DocumentType: Option All,Sales,Transfer;
        WarehouseStatus: Option All,New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        MakeBold: Boolean;
        Color: Integer;
        Text005: label 'Are you sure that you want to delete Delivery Document %1?';
        Text006: label 'Delivery Document %1 cannot be deleted as it has been released.';
        Text007: label 'The Release Delivery Document Cannot be deleted has it contains lines.';
        [InDataSet]
        "No.Emphasize": Boolean;
        [InDataSet]
        "Document StatusEmphasize": Boolean;
        [InDataSet]
        "Document TypeEmphasize": Boolean;
        [InDataSet]
        "Warehouse StatusEmphasize": Boolean;
        [InDataSet]
        "Document DateEmphasize": Boolean;
        [InDataSet]
        "Salesperson CodeEmphasize": Boolean;
        [InDataSet]
        "Sell-to Customer No.Emphasize": Boolean;
        [InDataSet]
        "Sell-to Customer NameEmphasize": Boolean;
        Text008: label 'Do you want to create delivery documents?';
        Text19013128: label 'Orders Sent to VCK but not yet Acknowledged:';
        StyleText: Text[30];
        StyleTextAmount: Text;
        CreateSalesInvoiceVisible: Boolean;
        SendSalesInvoiceVisible: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";
        ReleaseEnabled: Boolean;


    procedure SetFilters()
    begin
        Rec.Reset;
        if DocumentStatus <> Documentstatus::All then begin
            if DocumentStatus = Documentstatus::New then
                Rec.SetRange(Rec."Document Status", Rec."document status"::Open);
            if DocumentStatus = Documentstatus::Released then
                Rec.SetRange(Rec."Document Status", Rec."document status"::Released);
        end;
        if DocumentType <> Documenttype::All then begin
            if DocumentType = Documenttype::Sales then
                Rec.SetRange(Rec."Document Type", Rec."document type"::Sales);
            if DocumentType = Documenttype::Transfer then
                Rec.SetRange(Rec."Document Type", Rec."document type"::Transfer);
        end;

        if WarehouseStatus <> Warehousestatus::All then begin
            if WarehouseStatus = Warehousestatus::New then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::New);

            if WarehouseStatus = Warehousestatus::Backorder then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::Backorder);

            if WarehouseStatus = Warehousestatus::"Ready to Pick" then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::"Ready to Pick");

            if WarehouseStatus = Warehousestatus::Picking then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::Picking);

            if WarehouseStatus = Warehousestatus::Packed then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::Packed);

            if WarehouseStatus = Warehousestatus::"Waiting for invoice" then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::"Waiting for invoice");

            if WarehouseStatus = Warehousestatus::"Invoice Received" then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::"Invoice Received");

            if WarehouseStatus = Warehousestatus::Posted then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::Posted);

            if WarehouseStatus = Warehousestatus::"In Transit" then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::"In Transit");

            if WarehouseStatus = Warehousestatus::Delivered then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::Delivered);

            if WarehouseStatus = Warehousestatus::Error then
                Rec.SetRange(Rec."Warehouse Status", Rec."warehouse status"::Error);
        end;
    end;

    local procedure SetActions()
    var
        recCountryShip: Record "VCK Country Shipment Days";
    begin
        //>> 15-11-18 ZY-LD 005
        if recCtryChipDay.Get(Rec."Ship-to Country/Region Code") and
           (recCtryChipDay."Min. Amount to Ship" <> 0) and
           (Rec.Amount < recCtryChipDay."Min. Amount to Ship")
        then
            StyleTextAmount := 'Unfavorable'
        else
            StyleTextAmount := 'Standard';
        //<< 15-11-18 ZY-LD 005

        CreateSalesInvoiceVisible := not Rec."Send Invoice When Delivered";
        SendSalesInvoiceVisible := Rec."Send Invoice When Delivered";

        //>> 03-12-20 ZY-LD 012
        if not recCountryShip.Get(Rec."Ship-to Country/Region Code") then;

        recAutoSetup.Get;  // 29-03-22 ZY-LD 013
        ReleaseEnabled := (Rec."Document Status" <> Rec."document status"::Released) and
                          recAutoSetup."Release Deliver Document" and  // 29-03-22 ZY-LD 013
                          ((CurrentDatetime < recCountryShip."Block DD Release from") or (recCountryShip."Block DD Release from" = 0DT));
        //<< 03-12-20 ZY-LD 012
    end;

    local procedure DocumentStatusOnAfterValidate()
    begin
        SetFilters;
        CurrPage.Update;
    end;

    local procedure DocumentTypeOnAfterValidate()
    begin
        SetFilters;
        CurrPage.Update;
    end;

    local procedure WarehouseStatusOnAfterValidate()
    begin
        SetFilters;
        CurrPage.Update;
    end;

    local procedure UpdateActionCodes()
    var
        recDelDocHead: Record "VCK Delivery Document Header";
        recDefAction: Record "Default Action";
        recDelDocAction: Record "Delivery Document Action Code";
    begin
        //>> 31-01-20 ZY-LD 011
        recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Open);
        if recDelDocHead.FindSet then begin
            ZGT.OpenProgressWindow('', recDelDocHead.Count);

            repeat
                ZGT.UpdateProgressWindow(recDelDocHead."No.", 0, true);

                recDefAction.Reset;
                recDefAction.SetRange("Source Type", recDefAction."source type"::Customer, recDefAction."source type"::"Ship-to Address");
                recDefAction.SetFilter("Source Code", '%1|%2',
                  recDelDocHead."Sell-to Customer No.",
                  CopyStr(recDelDocHead."Ship-to Code", StrPos(recDelDocHead."Ship-to Code", '.') + 1, StrLen(recDelDocHead."Ship-to Code")));
                recDefAction.SetRange("Customer No.", recDelDocHead."Sell-to Customer No.");
                if recDefAction.FindSet then
                    repeat
                        recDelDocAction.InitLine(recDefAction);
                        recDelDocAction."Delivery Document No." := recDelDocHead."No.";
                        if not recDelDocAction.Insert(true) then;
                    until recDefAction.Next() = 0;
            until recDelDocHead.Next() = 0;

            ZGT.CloseProgressWindow;
        end;
        //<< 31-01-20 ZY-LD 011
    end;
}
