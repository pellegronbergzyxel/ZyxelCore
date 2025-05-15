pageextension 50303 SalesOrderListZX extends "Sales Order List"
{
    layout
    {
        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Salesperson Code")
        {
            field("Order Desk Resposible Code"; Rec."Order Desk Resposible Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Create User ID"; Rec."Create User ID")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Job Queue Status")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Customer Document No."; Rec."Customer Document No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("SAP No."; Rec."SAP No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter(Control1900316107)
        {
            part(Control43; "Warehouse Status FactBox")
            {
                Caption = 'Warehouse Status Details';
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No."),
                              Type = const(Item),
                              "Outstanding Quantity" = filter(<> 0);
            }
        }
        addlast(Control1)
        {
            field("No of Lines"; Rec."No of Lines")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(AmazonePoNo; Rec.AmazonePoNo)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Visible = false;
            }
            field(AmazconfirmationStatus; Rec.AmazconfirmationStatus)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Visible = false;
            }
            field(AmazonpurchaseOrderState; Rec.AmazonpurchaseOrderState)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Visible = false;
            }
            field(AmazonSellpartyid; Rec.AmazonSellpartyid)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Visible = false;
            }
        }
    }
    actions
    {
        modify(Post)
        {
            Enabled = PostButtonsEnabled;

            trigger OnBeforeAction()
            begin
                ZyXELVCK.CheckDeliveryDocumentLines(Rec."No.");
            end;
        }
        modify(PostAndSend)
        {
            Enabled = PostButtonsEnabled;

            trigger OnBeforeAction()
            begin
                ZyXELVCK.CheckDeliveryDocumentLines(Rec."No.");
            end;
        }
        modify("Post &Batch")
        {
            Enabled = PostButtonsEnabled;
        }
        modify("Email Confirmation")
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        addafter("In&vt. Put-away/Pick Lines")
        {
            action("Delivery Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Document';
                Image = Delivery;
                RunObject = Page "VCK Delivery Document List";
                RunPageLink = "Sell-to Customer No." = field("Sell-to Customer No."),
                              "Warehouse Status" = const(New);
            }
        }
        addafter(ActionGroupCRM)
        {
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ChangeLogEntry: Record "Change Log Entry";
                begin
                    ChangeLogEntry.SetCurrentKey("Table No.", "Date and Time");
                    ChangeLogEntry.SetAscending("Date and Time", false);
                    ChangeLogEntry.SetRange("Table No.", Database::"Sales Header");
                    ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(Rec."Document Type", 0, 9));
                    ChangeLogEntry.SetRange("Primary Key Field 2 Value", Rec."No.");
                    Page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                end;
            }
        }
        addafter("Send IC Sales Order Cnfmn.")
        {
            action("Skip Posting Group Validation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Skip Posting Group Validation';
                Image = ChangeTo;

                trigger OnAction()
                begin
                    SkipPostGrpValidation();  // 28-06-21 ZY-LD 004
                end;
            }
            group("Order")
            {
                Caption = 'Order';
                Image = Documents;
                action(Autoconfirm)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Auto Confirm';
                    Image = Approval;

                    trigger OnAction()
                    var
                        AutoConfirm: Codeunit "Pick. Date Confirm Management";
                    begin
                        //AutoConfirm;  // 20-08-18 ZY-LD 001  // 30-12-20 ZY-LD 029
                        AutoConfirm.PerformManuelConfirm(0, Rec."No.");  // 30-12-20 ZY-LD 029
                    end;
                }
            }
            group(ActionGroup26)
            {
                Caption = 'Delivery Document';
                Visible = true;
                action(CreateDeliveryDocuments)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Delivery Documents';
                    Image = Shipment;
                    ToolTip = 'Create Delivery Documents for all sales orders.';
                    Visible = true;

                    trigger OnAction()
                    begin
                        DelDocMgt.PerformManuelCreation();
                    end;
                }
                action("Create Delivery Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Delivery Document';
                    Image = Document;
                    ToolTip = 'Create Delivery Document for current sales order.';

                    trigger OnAction()
                    begin
                        DelDocMgt.PerformCreationForSingleOrder(Rec."No.");  // 14-06-21 ZY-LD 030
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        recUserSetup: Record "User Setup";
    begin
        //>> 19-02-20 ZY-LD 008
        if not recUserSetup.Get(UserId()) then;
        if not recUserSetup."Sort Sales Order by Prim. Key" then begin
            Rec.SetCurrentKey("Document Type", "Order Date");
            Rec.ASCENDING(false);
        end else
            Rec.ASCENDING(false);
        //<< 19-02-20 ZY-LD 008
        Rec.SetRange("Completely Invoiced", false); // RD1.0
        if not Rec.FindFirst() then;  // 27-10-17 ZY-LD 001
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 003
        SetActions();  // 02-05-19 ZY-LD 006
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 003
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 02-05-19 ZY-LD 006
    end;

    var
        DelDocMgt: Codeunit "Delivery Document Management";
        SI: Codeunit "Single Instance";
        ZyXELVCK: Codeunit "ZyXEL VCK";
        PostButtonsEnabled: Boolean;

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
        ItemCount := SalesOrder.Count();
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

    local procedure SkipPostGrpValidation()
    var
        recSalesHead: Record "Sales Header";
        SalesHeaderEvent: Codeunit "Sales Header/Line Events";
        lText001: Label 'Do you want to skip posting group validation for %1 Sales Order(s)?';
    begin
        //>> 28-06-21 ZY-LD 009
        CurrPage.SetSelectionFilter(recSalesHead);
        if Confirm(lText001, false, recSalesHead.Count(), CurrPage.Caption) then
            SalesHeaderEvent.SkipPostGrpValidation(recSalesHead);
        //<< 28-06-21 ZY-LD 009
    end;
}
