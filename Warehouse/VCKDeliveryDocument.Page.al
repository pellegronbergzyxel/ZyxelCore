Page 50086 "VCK Delivery Document"
{
    // 001. 12-09-17 ZY-LD 000 - Validation before realiseing deliver document.
    // 002. 04-10-17 ZY-LD 000 - TRUE is added to the delete.
    // 003. 23-04-18 ZY-LD 2018042010000117 - Code has moved to a function.
    // 004. 30-07-18 ZY-LD 2018073010000147 - Test on quantity before release.
    // 005. 19-03-19 ZY-LD 2019031910000031 - Test on picking date before release.
    // 006. 01-04-19 ZY-LD 000 - Release button can be blocked.
    // 007. 30-04-19 ZY-LD P0225 "Re-Release" is set to Visible = FALSE.
    // 13-07-19 .. 02-07-19 PAB 2019071710000072 - Changes made for Project Rock Go-live.  // 05-08-19 ZY-LD - The code has been made active again.
    // 008. 05-08-19 ZY-LD 2019080510000084 - Reopen the document, if it hasn't been sent.
    // 009. 15-08-19 ZY-LD 2019081510000074 - It has happend that the DD No. on the sales line was blank at the release time.
    // 010. 21-08-19 ZY-LD 2019082110000115 - Unblock customer.
    // 011. 26-08-19 ZY-LD 2019082610000062 - Check if additional items are confirmed.
    // 012. 30-10-19 ZY-LD 2019103010000077 - Update only date if status is New.
    // 013. 07-11-19 ZY-LD 000 - Confirm delete.
    // 014. 18-11-19 ZY-LD 000 - Print Serial No.
    // 015. 14-10-20 ZY-LD 2020101410000131 - Additional items can be editable on the sales line, and can also be deleted.
    // 016. 29-03-22 ZY-LD 000 - Block release from automation.
    // 017. 23-08-22 ZY-LD 000 - Post response.

    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "VCK Delivery Document Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = PageEditable;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Agent Code"; Rec."Shipment Agent Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Shipment Agent Service"; Rec."Shipment Agent Service")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = true;
                    Importance = Additional;
                }
                field("Picking Date Time"; Rec."Picking Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Loading Date Time"; Rec."Loading Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Delivery Date Time"; Rec."Delivery Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Delivery Remark"; Rec."Delivery Remark")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Release Date"; Rec."Release Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Release Time"; Rec."Release Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Mode Of Transport"; Rec."Mode Of Transport")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Delivery Terms Terms"; Rec."Delivery Terms Terms")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Delivery Terms City"; Rec."Delivery Terms City")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Delivery Zone"; Rec."Delivery Zone")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Expected Release Date"; Rec."Expected Release Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Requested Ship Date"; Rec."Requested Ship Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Notification Email"; Rec."Notification Email")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Confirmation Email"; Rec."Confirmation Email")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Receiver Reference"; Rec."Receiver Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Shipper Reference"; Rec."Shipper Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Signed By"; Rec."Signed By")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Create User ID"; Rec."Create User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Create Date"; Rec."Create Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Create Time"; Rec."Create Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Spec. Order No."; Rec."Spec. Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
            }
            group(Lines)
            {
                Caption = 'Lines';
                Editable = PageEditable;
            }
            part(DocumentLinesop1; "VCK Delivery Document Subform1")
            {
                SubPageLink = "Document No." = field("No.");
            }
            group("Bill-to")
            {
                Caption = 'Bill-to';
                Editable = PageEditable;
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Bill-to Name 2"; Rec."Bill-to Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to County"; Rec."Bill-to County")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to TaxID"; Rec."Bill-to TaxID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Bill-to Email"; Rec."Bill-to Email")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Bill-to Phone"; Rec."Bill-to Phone")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
            }
            group("Ship-to")
            {
                Caption = 'Ship-to';
                group(Control3)
                {
                    Caption = 'Ship-to';
                    Editable = PageEditable;
                    field("Ship-to Code"; Rec."Ship-to Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field("Ship-to Name"; Rec."Ship-to Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-to Name 2"; Rec."Ship-to Name 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Ship-to Address"; Rec."Ship-to Address")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-to Address 2"; Rec."Ship-to Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Ship-to Post Code"; Rec."Ship-to Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-to City"; Rec."Ship-to City")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-to County"; Rec."Ship-to County")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-to TaxID"; Rec."Ship-to TaxID")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Ship-to Contact"; Rec."Ship-to Contact")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Ship-to Email"; Rec."Ship-to Email")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("Ship-to Phone"; Rec."Ship-to Phone")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                    }
                    field("NCTS No."; Rec."NCTS No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group("Ship-from")
            {
                Caption = 'Ship-from';
                Editable = PageEditable;
                field("Ship-From Code"; Rec."Ship-From Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ship-From Name"; Rec."Ship-From Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ship-From Name 2"; Rec."Ship-From Name 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Ship-From Address"; Rec."Ship-From Address")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ship-From Address 2"; Rec."Ship-From Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Ship-From City"; Rec."Ship-From City")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ship-From County"; Rec."Ship-From County")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                }
                field("Ship-From Post Code"; Rec."Ship-From Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ship-From Country/Region Code"; Rec."Ship-From Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ship-From TaxID"; Rec."Ship-From TaxID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-From Contact"; Rec."Ship-From Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ship From Contact';
                    Importance = Additional;
                }
                field("Ship-From Email"; Rec."Ship-From Email")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Ship-From Phone"; Rec."Ship-From Phone")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
            }
            group("Delivery Note")
            {
                Caption = 'Delivery Note';
                Editable = PageEditable;
                part(DeliveryNote; "VCK Delivery Comment Sub Form")
                {
                    SubPageLink = "Delivery Document No." = field("No.");
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
            part(Control46; "Sales Comment Line FactBox")
            {
                Caption = 'Comment Line';
                SubPageLink = "Document Type" = const("Delivery Document"),
                              "No." = field("No."),
                              "Document Line No." = const(0);
            }
            part(Control30; "Del. Doc. Action Factbox")
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
                    CustomerCard: Page "Customer Card";
                begin
                    //>> 03-10-17 ZY-LD 001
                    recCustomer.SetFilter("No.", Rec."Sell-to Customer No.");
                    CustomerCard.SetTableview(recCustomer);
                    CustomerCard.Editable(false);
                    CustomerCard.RunModal;
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
                    //<< 03-10-17 ZY-LD 001
                end;
            }
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
                action(Action27)
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
                      true);  // 23-08-22 ZY-LD 017
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
            group(Update)
            {
                Caption = 'Update';
                action("Update Picking Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Update Picking Date';
                    Enabled = ChangePickingDateEnabled;
                    Image = UpdateShipment;

                    trigger OnAction()
                    begin
                        UpdatePickingDate;
                    end;
                }
                action("Update Backlog Comment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Update Backlog Comment';
                    Enabled = ChangePickingDateEnabled;
                    Image = UpdateDescription;

                    trigger OnAction()
                    begin
                        UpdateBacklogComment;
                    end;
                }
            }
            group("Function")
            {
                Caption = 'Function';
                action("Create Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Sales Invoice';
                    Image = Invoice;

                    trigger OnAction()
                    begin
                        Rec.CreateSalesInvoice(false);  // 15-11-19 ZY-LD 014
                    end;
                }
                action("Create and Post Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create and Post Invoice';
                    Image = Post;

                    trigger OnAction()
                    begin
                        Rec.CreateSalesInvoice(true);  // 15-11-19 ZY-LD 014
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
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.PrintSerialNo(Rec."No.");  // 18-11-19 ZY-LD 014
                    end;
                }
            }
        }
        area(reporting)
        {
            action("XML - Warehouse Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'XML - Warehouse Document';
                Image = XMLFile;

                trigger OnAction()
                begin
                    ShowXMLdocument;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 01-04-19 ZY-LD 006
    end;

    trigger OnOpenPage()
    begin
        SetActions();  // 01-04-19 ZY-LD 006
    end;

    var
        recDelDocHead: Record "VCK Delivery Document Header";
        recAutoSetup: Record "Automation Setup";
        DelDocMgt: Codeunit "Delivery Document Management";
        FieldEnabled: Boolean;
        ReleaseEnabled: Boolean;
        ChangePickingDateEnabled: Boolean;
        PageEditable: Boolean;
        ReleaseDeliveryDocumentEnable: Boolean;

    local procedure SetActions()
    var
        recCountryShip: Record "VCK Country Shipment Days";
        recCountry: Record "Country/Region";
    begin
        //>> 01-04-19 ZY-LD 006
        if not recCountryShip.Get(Rec."Ship-to Country/Region Code") then;

        if recAutoSetup.Get() then  // 29-03-22 ZY-LD 016
            ReleaseEnabled := (Rec."Document Status" <> Rec."document status"::Released) and
                              recAutoSetup."Release Deliver Document" and  // 29-03-22 ZY-LD 016
                              ((CurrentDatetime < recCountryShip."Block DD Release from") or (recCountryShip."Block DD Release from" = 0DT));
        //<< 01-04-19 ZY-LD 006

        ChangePickingDateEnabled :=
          (Rec."Document Type" = Rec."document type"::Sales) and
          (Rec."Document Status" = Rec."document status"::Open) and
          (Rec."Warehouse Status" = Rec."warehouse status"::New);

        //CurrPage.EDITABLE("Document Status" = "Document Status"::New);  // 30-10-19 ZY-LD 012
        PageEditable := Rec."Document Status" = Rec."document status"::Open;
    end;

    local procedure UpdatePickingDate()
    var
        recCtryShipDaySub: Record "VCK Country Shipm. Day Sub";
        recSalesLine: Record "Sales Line";
        GenericInputPage: Page "Generic Input Page";
        lText001: label 'Update Picking Date';
        lText002: label 'New Picking Date (%1)';
        DelDocMgt: Codeunit "Delivery Document Management";
        NewPickingDate: Date;
        lText003: label 'Do you want to update "%1" to %2\on %3 sales order line(s)?';
    begin
        NewPickingDate := Today;
        recCtryShipDaySub.SetRange("Country Code", Rec."Ship-to Country/Region Code");
        recCtryShipDaySub.SetFilter("Week Day", '%1..', Date2dwy(NewPickingDate, 1));
        if not recCtryShipDaySub.FindFirst then
            recCtryShipDaySub.SetRange("Week Day");
        if recCtryShipDaySub.FindFirst then
            NewPickingDate := DelDocMgt.GetNextWeekday(recCtryShipDaySub."Week Day", NewPickingDate);

        GenericInputPage.SetPageCaption(lText001);
        GenericInputPage.SetFieldCaption(StrSubstNo(lText002, Rec."Ship-to Country/Region Code"));
        GenericInputPage.SetVisibleField(4);
        GenericInputPage.SetDate(NewPickingDate);

        if GenericInputPage.RunModal = Action::OK then begin
            NewPickingDate := GenericInputPage.GetDate;

            Rec."Expected Release Date" := NewPickingDate - 1;
            if Date2dwy(Rec."Expected Release Date", 1) > 5 then
                Rec."Expected Release Date" := DelDocMgt.GetPrevWeekday(5, Rec."Expected Release Date");

            recSalesLine.SetRange("Document Type", recSalesLine."document type"::Order);
            recSalesLine.SetRange("Delivery Document No.", Rec."No.");
            if recSalesLine.FindSet(true) then
                if Confirm(lText003, false, recSalesLine.FieldCaption("Shipment Date"), NewPickingDate, recSalesLine.Count) then begin
                    repeat
                        recSalesLine."Shipment Date" := NewPickingDate;
                        recSalesLine.Modify;
                    until recSalesLine.Next() = 0;
                end;
        end;
    end;

    local procedure UpdateBacklogComment()
    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        GenericInputPage: Page "Generic Input Page";
        lText001: label 'Update Backlog Comment';
        lText002: label 'New Backlog Comment';
        lText003: label 'Do you want to update "%1" to %2\on %3 sales order line(s)?';
    begin
        GenericInputPage.SetPageCaption(lText001);
        GenericInputPage.SetFieldCaption(StrSubstNo(lText002, Rec."Ship-to Country/Region Code"));
        GenericInputPage.SetVisibleField(9);

        if GenericInputPage.RunModal = Action::OK then begin
            recSalesHead."Backlog Comment" := GenericInputPage.GetOption;
            recSalesLine.SetRange("Document Type", recSalesLine."document type"::Order);
            recSalesLine.SetRange("Delivery Document No.", Rec."No.");
            if recSalesLine.FindSet(true) then
                if Confirm(lText003, false, recSalesLine.FieldCaption("Backlog Comment"), Format(recSalesHead."Backlog Comment"), recSalesLine.Count) then begin
                    repeat
                        recSalesLine."Backlog Comment" := recSalesHead."Backlog Comment";
                        recSalesLine.Modify;
                    until recSalesLine.Next() = 0;
                end;
        end;
    end;

    local procedure ShowXMLdocument()
    var
        recDelDocHead: Record "VCK Delivery Document Header";
        SendDeliveryDocument: XmlPort "Send Delivery Document";
    begin
        recDelDocHead.SetRange("No.", Rec."No.");
        SendDeliveryDocument.SetTableview(recDelDocHead);
        SendDeliveryDocument.Run;
    end;
}
