Page 50194 "Sales Order List - Invoiced"
{
    // 001. 27-10-17 ZY-LD Sort Decending
    // 002. 12-12-17 ZY-LD Release and Re-open has been set to false because there are changes to the same functions on page 42.
    // 003. 25-04-18 ZY-LD 000 - Set reject change log.
    // 004. 16-11-18 PAB Added EDI Buttons
    // 005. 13-02-19 ZY-LD 2019013110000038 - Change log is added.
    // 006. 02-05-19 ZY-LD P0202 - PostButton must be hidden.
    // 007. 01-11-19 ZY-LD P0332 - Post if not "Combine Shipments".
    // 008. 19-02-20 ZY-LD 2020021810000041 - Setup sorting by user setup.

    ApplicationArea = Basic, Suite;
    Caption = 'Invoiced Sales Orders';
    CardPageID = "Sales Order";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Order),
                            "Completely Invoiced" = const(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(EDI; Rec.EDI)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EDI Order';
                    Editable = false;
                    ToolTip = 'EDI Order';
                    Visible = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Create User ID"; Rec."Create User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Completely Shipped"; Rec."Completely Shipped")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Job Queue Status"; Rec."Job Queue Status")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = JobQueueActive;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            part(Control1902018507; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = field("Bill-to Customer No."),
                              "Date Filter" = field("Date Filter");
                Visible = true;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                SubPageLink = "No." = field("Bill-to Customer No."),
                              "Date Filter" = field("Date Filter");
                Visible = true;
            }
            part(Control43; "Warehouse Status FactBox")
            {
                Caption = 'Warehouse Status Details';
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No."),
                              Type = const(Item),
                              "Outstanding Quantity" = filter(<> 0);
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ShowFilter = false;
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlVisibility;
        CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions;  // 02-05-19 ZY-LD 006
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 003
    end;

    trigger OnOpenPage()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        //>> 19-02-20 ZY-LD 008
        if not recUserSetup.Get(UserId()) then;
        if not recUserSetup."Sort Sales Order by Prim. Key" then begin
            Rec.SetCurrentkey(Rec."Document Type", Rec."Order Date");
            Rec.Ascending(false);
        end else
            Rec.Ascending(false);
        //<< 19-02-20 ZY-LD 008
        if not Rec.FindFirst then;  // 27-10-17 ZY-LD 001
        Rec.SetCurrentkey(Rec."No.");
        if UserMgt.GetSalesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange(Rec."Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FilterGroup(0);
        end;

        Rec.SetRange(Rec."Date Filter", 0D, WorkDate - 1);

        JobQueueActive := SalesSetup.JobQueueActive;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 003

        SetActions;  // 02-05-19 ZY-LD 006
    end;

    var
        recUserSetup: Record "User Setup";
        DocPrint: Codeunit "Document-Print";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        [InDataSet]
        JobQueueActive: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CRMIntegrationEnabled: Boolean;
        AllInCreateDeliveryDocument: Codeunit "Delivery Document Management";
        SI: Codeunit "Single Instance";
        Text001: label 'This is not an EDI order.';
        Text002: label 'EDI Document could not be found.';
        ZyXELVCK: Codeunit "ZyXEL VCK";
        PostButtonsEnabled: Boolean;


    procedure ShowPreview()
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesPostYesNo.Preview(Rec);
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;


    procedure GetSelectionFilter(): Code[250]
    var
        SalesOrder: Record "Sales Header";
        FirstItem: Code[30];
        LastItem: Code[30];
        SelectionFilter: Code[250];
        ItemCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(SalesOrder);
        ItemCount := SalesOrder.Count;
        if ItemCount > 0 then begin
            SalesOrder.Find('-');
            while ItemCount > 0 do begin
                ItemCount := ItemCount - 1;
                SalesOrder.MarkedOnly(false);
                FirstItem := SalesOrder."No.";
                LastItem := FirstItem;
                More := (ItemCount > 0);
                while More do
                    if SalesOrder.Next() = 0 then
                        More := false
                    else
                        if not SalesOrder.Mark then
                            More := false
                        else begin
                            LastItem := SalesOrder."No.";
                            ItemCount := ItemCount - 1;
                            if ItemCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstItem = LastItem then
                    SelectionFilter := SelectionFilter + FirstItem
                else
                    SelectionFilter := SelectionFilter + FirstItem + '..' + LastItem;
                if ItemCount > 0 then begin
                    SalesOrder.MarkedOnly(true);
                    SalesOrder.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;


    procedure SetSelection(var SalesOrder: Record "Sales Header")
    begin
        CurrPage.SetSelectionFilter(SalesOrder);
    end;


    procedure SetItemFilter(ItemFilter: Text[1024])
    begin
        //ItemListFilter := ItemFilter;
    end;

    local procedure SetActions()
    var
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
    begin
        PostButtonsEnabled :=
          not Rec."Combine Shipments" or  // 01-11-19 ZY-LD 007
          SalesHeadEvent.HidePostButtons(Rec."Location Code", Rec."No.");  // 02-05-19 ZY-LD 006
    end;
}
