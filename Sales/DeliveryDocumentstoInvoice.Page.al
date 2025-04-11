page 50044 "Delivery Documents to Invoice"
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
    // 012. 23-08-22 ZY-LD 000 - Post response.

    Caption = 'Delivery Documents Ready to Invoice';
    CardPageID = "VCK Delivery Document";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "VCK Delivery Document Header";
    SourceTableView = order(descending);

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
                field("Customs/Shipping Invoice Sent"; Rec."Customs/Shipping Invoice Sent")
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
            part(Control3; "Sales Comment Line FactBox")
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
            part(Control23; "Del. Doc. Action Factbox")
            {
                Caption = 'Action Code - Line';
                SubPageLink = "Delivery Document No." = field("No."),
                              "Header / Line" = const(Line);
                SubPageView = sorting("Delivery Document No.", "Comment Type", Sequence);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            Action("Serial Numbers")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Serial Numbers';
                Image = CopySerialNo;

                trigger OnAction()
                var
                    frmSerials: Page "VCK Delivery Document SNos";
                begin
                    frmSerials.FilterByDeliveryDocument(Rec."No.");
                    frmSerials.RunModal();
                end;
            }
            Action(Customer)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Customer Card";
                RunPageLink = "No." = field("Sell-to Customer No.");
                Visible = Rec."Document Type" = Rec."Document Type"::Sales;

                trigger OnAction()
                var
                    recCustomer: Record Customer;
                    recLocaions: Record Location;
                    CustomerCard: Page "Customer Card";
                begin
                end;
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                Action("Warehouse Response")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Warehouse Response';
                    Image = WarehouseRegisters;
                    RunObject = Page "Shipment Response List";
                    RunPageLink = "Customer Message No." = field("No.");
                }
                Action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
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
            Action("Create Sales Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Sales Invoice';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = CreateSalesInvoiceVisible;

                trigger OnAction()
                begin
                    Rec.CreateSalesInvoice(false);  // 15-11-19 ZY-LD 014
                    CurrPage.Update();
                end;
            }
            Action("Change Status")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Status';
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Change: Report "Change Warehouse Status";
                begin
                    Change.InitReport(
                      Rec."No.",
                      Rec."Warehouse Status",
                      Rec."Document Status",  // 18-11-19 ZY-LD 010
                      true);  // 23-08-22 ZY-LD 012
                    Change.Run;
                    CurrPage.Update();
                end;
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
        if not Rec.FindFirst() then;  // 11-10-18 ZY-LD 004

        //UpdateActionCodes;  // 31-01-20 ZY-LD 011
    end;

    var
        Text001: Label 'The Delivery Document %1 has already been released.';
        Text002: Label 'Delivery Document %1 has been released.';
        Text003: Label 'Are you sure that you want to releses selected delivery order(s)? \Once released they will be sent to All-In Logistics and cannot be changed.';
        Text004: Label 'You cannot delete a Released Delivery Document.';
        recCtryChipDay: Record "VCK Country Shipment Days";
        Delivery: Codeunit "Delivery Document Management";
        DocumentStatus: Option All,New,Released;
        DocumentType: Option All,Sales,Transfer;
        WarehouseStatus: Option All,New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        MakeBold: Boolean;
        Color: Integer;
        Text005: Label 'Are you sure that you want to delete Delivery Document %1?';
        Text006: Label 'Delivery Document %1 cannot be deleted as it has been released.';
        Text007: Label 'The Release Delivery Document Cannot be deleted has it contains lines.';
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
        Text008: Label 'Do you want to create delivery documents?';
        Text19013128: Label 'Orders Sent to VCK but not yet Acknowledged:';
        StyleText: Text[30];
        StyleTextAmount: Text;
        CreateSalesInvoiceVisible: Boolean;
        SendSalesInvoiceVisible: Boolean;
        DelDocMgt: Codeunit "Delivery Document Management";
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SetFilters()
    begin
        Rec.Reset();
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
    end;

    local procedure DocumentStatusOnAfterValidate()
    begin
        SetFilters;
        CurrPage.Update();
    end;

    local procedure DocumentTypeOnAfterValidate()
    begin
        SetFilters;
        CurrPage.Update();
    end;

    local procedure WarehouseStatusOnAfterValidate()
    begin
        SetFilters;
        CurrPage.Update();
    end;

    local procedure UpdateActionCodes()
    var
        recDelDocHead: Record "VCK Delivery Document Header";
        recDefAction: Record "Default Action";
        recDelDocAction: Record "Delivery Document Action Code";
    begin
        //>> 31-01-20 ZY-LD 011
        recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Open);
        if recDelDocHead.FindSet() then begin
            ZGT.OpenProgressWindow('', recDelDocHead.Count());

            repeat
                ZGT.UpdateProgressWindow(recDelDocHead."No.", 0, true);

                recDefAction.Reset();
                recDefAction.SetRange("Source Type", recDefAction."source type"::Customer, recDefAction."source type"::"Ship-to Address");
                recDefAction.SetFilter("Source Code", '%1|%2',
                  recDelDocHead."Sell-to Customer No.",
                  CopyStr(recDelDocHead."Ship-to Code", StrPos(recDelDocHead."Ship-to Code", '.') + 1, StrLen(recDelDocHead."Ship-to Code")));
                recDefAction.SetRange("Customer No.", recDelDocHead."Sell-to Customer No.");
                if recDefAction.FindSet() then
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
