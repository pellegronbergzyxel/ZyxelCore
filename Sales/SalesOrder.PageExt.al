PageExtension 50126 SalesOrderZX extends "Sales Order"
{
    // 001. 05-02-24 ZY-LD 000 - We have made our own "Item Warehouse Detail" because of the location filter.
    // 002. 12-03-24 ZY-LD #1536814 - "Ship-to Address" is made editable.
    // 003. 11-04-24 ZY-LD #2386066 - ItemBudgMgt.GetSOForecast has been add an extra parameter.
    // 004. 20-05-24 ZY-LD 000 - "Ship-to Code Del. Doc";
    layout
    {
        addlast("Foreign Trade")
        {
            // 473070 >>
            // removed -> standard
            field("Send IC Document"; Rec."Send IC Document")
            {
                ApplicationArea = Basic, Suite;
                Visible = true;
            }
            // 473070 >>

        }
        modify("Promised Delivery Date")
        {
            Visible = false;
        }
        modify("Quote No.")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Opportunity No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Job Queue Status")
        {
            Visible = false;
        }
        modify(Status)
        {
            ShowMandatory = true;
        }
        modify("Direct Debit Mandate ID")
        {
            Visible = false;
        }
        movebefore("Sell-to"; "Location Code")
        modify("Outbound Whse. Handling Time")
        {
            Visible = false;
        }
        modify("Shipping Time")
        {
            Visible = false;
        }
        modify("Package Tracking No.")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = true;
        }
        modify("Currency Code")
        {
            ToolTip = 'The invoice between the regional head quarter and the subsidary will be invoiced with the "Currency Code" from "Bill-to Customer No.". The invoice to the customer from the subsidary will be invoiced with the "Currency Code" from the "Sell-to Customer".';
        }
        modify("Transaction Type")
        {
            Visible = false;
        }
        modify("Transaction Specification")
        {
            Visible = false;
        }
        modify("Exit Point")
        {
            Visible = false;
        }
        modify("Area")
        {
            Visible = false;
        }
        modify(Control1900201301)
        {
            Visible = false;
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                SetActions();  // 01-02-19 ZY-LD 016
                CurrPage.UPDATE(FALSE);
            end;
        }
        modify("Late Order Shipping")
        {
            Visible = false;
        }
        modify(Control1901796907)
        {
            Visible = false;  // 05-02-24 ZY-LD 001
        }
        //>> 05-02-24 ZY-LD 001
        addafter(Control1907012907)
        {
            part(ItemWarehouseFactBoxPart; "Item Warehouse FactBox")
            {
                ApplicationArea = Basic, Suite;
                Provider = SalesLines;
                SubPageLink = "No." = field("No."),
                            "Location Filter" = field("Location Code");
                Visible = true;
            }
            part(MarginApprovalFacxbox; "Margin Approval FacxBox")
            {
                ApplicationArea = Basic, Suite;
                Provider = SalesLines;
                SubPageLink = "Source Type" = const("Sales"),
                              "Sales Document Type" = field("Document Type"),
                              "Source No." = field("Document No."),
                              "Source Line No." = field("Line No.");
                Visible = false;
            }
        }
        //<< 05-02-24 ZY-LD 001
        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                begin
                    //15-51643 -
                    //>> 25-06-19 ZY-LD 020
                    //IF "Sales Order Type" = "Sales Order Type"::EICard THEN
                    //  EnableEiCards(TRUE) ELSE EnableEiCards(FALSE)
                    //15-51643 +
                    SetActions();
                    //<< 25-06-19 ZY-LD 020
                end;
            }
        }
        addafter("No. of Archived Versions")
        {
            field("Shipping Request Notes"; Rec."Shipping Request Notes")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShipReqNotesVisible;
            }
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                SetActions();  // 01-02-19 ZY-LD 016
            end;
        }
        addafter("Location Code")
        {
            field("Eicard Type"; Rec."Eicard Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = EiCardVisible;
            }
            group(ExternalRef)
            {
                ShowCaption = false;
                field("External Document No. End Cust"; Rec."External Document No. End Cust")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-Invoice Comment"; Rec."E-Invoice Comment")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = EInvoiceCommentEnable;
                    ShowMandatory = EInvoiceCommentEnable;
                }
            }
            field("Customer Document No."; Rec."Customer Document No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("SAP No."; Rec."SAP No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("Backlog Comment"; Rec."Backlog Comment")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        movebefore("External Document No. End Cust"; "External Document No.")
        addafter("Salesperson Code")
        {
            field("Order Desk Resposible Code"; Rec."Order Desk Resposible Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field(SystemCreatedBy; CreatedUserName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Created By';
                Visible = false;
            }

        }
        addafter(SalesLines)
        {
            part(Control199; "EiCard Cue SubPage")
            {
                Caption = 'EiCards';
                Enabled = EiCardEnable;
                SubPageLink = "Sales Order No." = field("No.");
                Visible = EiCardVisible;
            }
        }
        addbefore("VAT Bus. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
        }
        modify("VAT Registration No.")
        {
            ApplicationArea = Basic, Suite;
            Visible = true;
        }
        addafter("VAT Registration No.")
        {
            field("Ship-to VAT"; Rec."Ship-to VAT")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                //Visible = VATRegistrationNoSellToVisible;  // 12-02-24 ZY-LD 000
            }
            field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("Send Mail"; Rec."Send Mail")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        modify("Ship-to Country/Region Code")
        {
            trigger OnAfterValidate()
            begin
                SetActions();  // 01-02-19 ZY-LD 016
            end;
        }
        modify("Ship-to Address 2")
        {
            Editable = true;  // 12-03-24 ZY-LD 
            ToolTip = 'If you want the contact person shown on the delivery note from the warehouse you must there it here.';
        }
        addafter("Currency Code")
        {
            field("<Currency Code>"; Rec."Currency Code Sales Doc SUB")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Currency Code on Sales Invoice SUB';
                Importance = Promoted;
                ToolTip = 'If you fill this field, the value will be used on the sales invoice in the subsidary instead of the "Currency Code" from the "Sell-to Customer.';
            }
        }
        addfirst("Shipping and Billing")
        {
            field("Ship-to Code Del. Doc"; Rec."Ship-to Code Del. Doc")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShipToCodeDelDocVisible;
                ToolTip = 'Fill this field only if the products must be sent to rework on a different location (ex. DK-Office). In all other situations the field must be left blank.';
            }
        }
        addlast("Invoice Details")
        {
            field(AmazonePoNo; Rec.AmazonePoNo)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field(AmazconfirmationStatus; Rec.AmazconfirmationStatus)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field(AmazonpurchaseOrderState; Rec.AmazonpurchaseOrderState)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field(AmazonSellpartyid; Rec.AmazonSellpartyid)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }

    }

    actions
    {
        modify(Plan)
        {
            Visible = false;
        }
        modify("Request Approval")
        {
            Visible = false;
        }
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
        modify(PostAndNew)
        {
            Enabled = PostButtonsEnabled;

            trigger OnBeforeAction()
            begin
                ZyXELVCK.CheckDeliveryDocumentLines(Rec."No.");
            end;
        }
        modify("Work Order")
        {
            Visible = false;
        }
        modify("Pick Instruction")
        {
            Visible = false;
        }
        modify(SendEmailConfirmation)
        {
            Promoted = true;
            PromotedCategory = Process;
            trigger OnBeforeAction()
            var
                CustReptMgt: Codeunit "Custom Report Management";
                CustomReportSelection: Record "Custom Report Selection";
                tempmail2: text;
                temptext: text;
            begin
                Tempmail := rec."Sell-to E-Mail";
                if strlen(CustReptMgt.GetEmailAddress(Database::Customer, Rec."Sell-to Customer No.", CustomReportSelection.Usage::"S.Order", tempmail2)) > 80 then begin
                    temptext := CustReptMgt.GetEmailAddress(Database::Customer, Rec."Sell-to Customer No.", CustomReportSelection.Usage::"S.Order", tempmail2);
                    temptext := CopyStr(temptext, 1, StrPos(temptext, ';') - 1);
                    rec."Sell-to E-Mail" := temptext;
                end else
                    rec."Sell-to E-Mail" := CustReptMgt.GetEmailAddress(Database::Customer, Rec."Sell-to Customer No.", CustomReportSelection.Usage::"S.Order", tempmail2);
            end;

            trigger OnAfterAction()
            begin
                rec."Sell-to E-Mail" := Tempmail;
            end;
        }
        addafter("Warehouse Shipment Lines")
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



        addafter(Prepayment)
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
                    page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                end;
            }
            group(EiCard)
            {
                Caption = 'EiCard';
                action("EiCard Queue")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EiCard Queue';
                    Image = AllocatedCapacity;
                    RunObject = Page "EiCard Queue";
                    RunPageLink = "Sales Order No." = field("No.");
                    Visible = EiCardVisible;
                }
            }
        }
        addfirst(Processing)
        {
            group("Import Sales Order")
            {
                Caption = 'Import Sales Order';
                action("Import Sales Order Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Sales Order Lines';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Import: Report "Import Sales Order Lines";
                    begin
                        Import.SetDocumentNo(Rec."No.");
                        Import.Run
                    end;
                }
                action("GLC-Eicard")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'GLC-Eicard';
                    Image = ImportExcel;
                    RunObject = Page "Config. Package Card";
                    RunPageView = where(Code = const('GLS-EICARD'));
                }
            }
        }
        addafter("Send IC Sales Order")
        {
            action("Disable Additional Items")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Disable Additional Items';
                Image = DisableAllBreakpoints;
                Visible = DisableAddtionalItemsVisible;

                trigger OnAction()
                begin
                    //>> 09-04-18 ZY-LD 006
                    SalesHeadEvent.DisableEnableAdditionalItems(Rec);
                    SetActions();
                    CurrPage.Update;
                    //<< 09-04-18 ZY-LD 006
                end;
            }
            action("Enable Additional Items")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Enable Additional Items';
                Image = EnableAllBreakpoints;
                Visible = enableAddtionalItemsVisible;

                trigger OnAction()
                begin
                    //>> 09-04-18 ZY-LD 006
                    SalesHeadEvent.DisableEnableAdditionalItems(Rec);
                    SetActions();
                    CurrPage.Update;
                    //<< 09-04-18 ZY-LD 006
                end;
            }
        }

        addLast("F&unctions")
        {
            group("Amazon")
            {
                Caption = 'Amazon';
                Image = Documents;
                Action(updateStatus)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Update status';
                    Image = UpdateXML;

                    trigger OnAction()
                    var
                        AmazonHelper: Codeunit AmazonHelper;
                        texttemp: text;
                    begin
                        AmazonHelper.UpdateAmazonstatus(rec);

                    end;
                }
                Action(SendAcknowledge)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send order acknowledgement to Anazon';
                    Image = UpdateXML;

                    trigger OnAction()
                    var
                        AmazonHelper: Codeunit AmazonHelper;
                        Confirmtext: Label 'have you updated quantities on all lines? ';
                    begin
                        if confirm(Confirmtext, true) then
                            AmazonHelper.SetAmazonOrderRejected(rec, rec.AmazonSellpartyid);

                    end;
                }
                action(packingSlips)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Download packingSlips';
                    Image = Approval;

                    trigger OnAction()
                    var
                        AmazonHelper: Codeunit AmazonHelper;
                        texttemp: text;
                    begin
                        if AmazonHelper.GETAmazonOrderpackingSlips(texttemp, rec.AmazonSellpartyid, rec) then
                            message(texttemp);
                    end;
                }
            }
        }
        addafter("F&unctions")
        {
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
                        //>> 30-12-20 ZY-LD 029
                        //AutoConfirm;  // 20-08-18 ZY-LD 001
                        SI.SetValidateFromPage(false);
                        AutoConfirm.PerformManuelConfirm(0, Rec."No.");
                        SI.SetValidateFromPage(true);
                        //<< 30-12-20 ZY-LD 029
                    end;
                }
                action(PrintPickList1SO)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Picking List (for single SO only)';
                    Visible = false;

                    trigger OnAction()
                    begin

                        if (Rec."No." <> '') then begin
                            Clear(SalesOrderHeader);
                            SalesOrderHeader.SetFilter("No.", '%1', Rec."No.");
                            Report.RunModal(62005, true, false, SalesOrderHeader);
                        end;
                    end;
                }
                action("Update Additional Items")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Update Additional Items';
                    Image = UpdateDescription;

                    trigger OnAction()
                    begin
                        //>> 20-11-18 ZY- 014
                        if Confirm(Text007) then
                            AddItemMgt.UpdateAdditionalItems(Rec."Document Type", Rec."No.", Rec."Ship-to Country/Region Code");
                        //<< 20-11-18 ZY- 014
                    end;
                }
                action("Create Spec. Purchase Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Spec. Purchase Order';
                    Enabled = CreatePurchaseOrderEnable;
                    Image = CreateDocument;

                    trigger OnAction()
                    begin
                        //>> 24-02-20 ZY-LD 028
                        Rec.TestField(Rec.Status, Rec.Status::Released);
                        recSalesHead.SetRange("Document Type", Rec."Document Type");
                        recSalesHead.SetRange("No.", Rec."No.");
                        Report.RunModal(Report::"Create Purchase Order", true, false, recSalesHead);
                        //<< 24-02-20 ZY-LD 028
                    end;
                }
            }
            group(ActionGroup1000000001)
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
                        DelDocMgt.PerformManuelCreation;
                    end;
                }
                action("Create Delivery Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Delivery Document';
                    Image = Document;
                    ToolTip = 'Create Delivery Document for current sales order.';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.Run(Rec);
                        DelDocMgt.PerformCreationForSingleOrder(Rec."No.");  // 14-06-21 ZY-LD 030
                    end;
                }
            }
            group(ActionGroup1000000000)
            {
                Caption = 'EiCard';
                action(Queue)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Add to EiCard Queue';
                    Enabled = EiCardEnable;
                    Image = Apply;
                    Visible = EiCardVisible;

                    trigger OnAction()
                    var
                        EiCardCodeUnit: Codeunit "ZyXEL EiCards";
                        recCust: Record Customer;
                    begin
                        if Rec.Status <> Rec.Status::Released then
                            Error(zyText002);

                        //>> 31-01-20 ZY-LD 027
                        recCust.Get(Rec."Sell-to Customer No.");
                        if recCust.Blocked <> recCust.Blocked::" " then
                            recCust.FieldError(Blocked);
                        //<< 31-01-20 ZY-LD 027

                        //>> 06-09-19 ZY-LD 023
                        recEiCardQueue.SetRange(Active, true);
                        recEiCardQueue.SetRange("Sales Order No.", Rec."No.");
                        if recEiCardQueue.FindFirst then
                            Error(zyText003, Rec."No.");
                        //<< 06-09-19 ZY-LD 023
                        EiCardCodeUnit.CreatePO(Rec);
                    end;
                }
                action(EiCardQueue)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EiCard Queue';
                    Image = AllocatedCapacity;
                    RunObject = Page "EiCard Queue";
                    RunPageLink = "Sales Order No." = field("No.");
                    Visible = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();  // 09-04-18 ZY-LD 006
        SI.SetRejectChangeLog(FALSE);  // 25-04-18 ZY-LD 007

        //>> 30-09-19 ZY-LD 025
        IF (Rec."Sell-to Customer No." = '200122') OR (Rec."Sell-to Customer No." = '200150') THEN
            IF NOT recEiCardQueue.GET(Rec."No.") THEN BEGIN
                recEiCardQueue.VALIDATE("Sales Order No.", Rec."No.");
                recEiCardQueue.VALIDATE("Customer No.", Rec."Sell-to Customer No.");
                recEiCardQueue.INSERT(TRUE);
            END;
        //<< 30-09-19 ZY-LD 025
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(FALSE);  // 25-04-18 ZY-LD 007
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Control1901796907.Page.SetLocationFilter(Rec."Location Code");
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();

        CreatedUserName := ZGT.GetFullUserName(Rec.SystemCreatedBy);
    end;

    var
        SalesOrderHeader: Record "Sales Header";
        recSalesReceivablesSetup: Record "Sales & Receivables Setup";
        recCust: Record Customer;
        recEiCardQueue: Record "EiCard Queue";
        recSalesHead: Record "Sales Header";
        recServEnviron: Record "Server Environment";
        DelDocMgt: Codeunit "Delivery Document Management";
        ItemBudgetManagement: Codeunit "Item Budget Management";
        SI: Codeunit "Single Instance";
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
        ZyXELVCK: Codeunit "ZyXEL VCK";
        AddItemMgt: Codeunit "ZyXEL Additional Items Mgt";
        ZGT: Codeunit "ZyXEL General Tools";
        ItemView: Boolean;
        EIFieldsEnable: Boolean;
        DisableAddtionalItemsVisible: Boolean;
        EnableAddtionalItemsVisible: Boolean;
        EInvoiceCommentEnable: Boolean;
        PostButtonsEnabled: Boolean;
        ShipToCodeDelDocVisible: Boolean;  // 20-05-24 ZY-LD 000
        EiCardVisible: Boolean;
        EiCardEnable: Boolean;
        ShipReqNotesVisible: Boolean;
        CreatePurchaseOrderEnable: Boolean;
        VATRegistrationNoSellToVisible: Boolean;
        DeliveryDays: Integer;
        SuggestedZone: Text[30];
        CreatedUserName: Text[80];
        LogContentString: Text[100];
        Tempmail: text;
        Text003: label 'You must specify a Distributor PO number before the order can be added to the queue.';
        Text004: label 'Please enter "%1" on item no. %2. (Line %3).';
        Text005: label 'This is Not an EDI Order.';
        Text006: label 'An EDI Document Could not be found.';
        Text007: label 'Do you want to update Additional Items?';
        zyText001: label 'Contact navsupport@zyxel.eu.';
        zyText002: label 'Status must be released before you can add to eicard queue.';
        zyText003: label 'EiCard Queue is already crated on sales order %1.';
        zyText004: label 'Please customize ribbon, and restore defaults in the buttom right corner of the page.';
        TextLabel1: label 'These are pre-defined post codes for the selected delivery zone. Please note that other post codes may be covered by this zone.';

    local procedure TouchItemRecords()
    var
        recSalesLine: Record "Sales Line";
        recItem: Record Item;
    begin
        recSalesLine.SetFilter("Document No.", Rec."No.");
        recSalesLine.SetRange(Type, recSalesLine.Type::Item);
        if recSalesLine.FindFirst then begin
            repeat
                recItem.Reset;
                recItem.SetFilter("No.", recSalesLine."No.");
                if recItem.FindFirst then begin
                    recItem.Modify;
                    Commit;
                end;
            until recSalesLine.Next() = 0;
        end;
    end;

    procedure EnableEiCards(Enable: Boolean)
    var
        recSetup: Record "Sales & Receivables Setup";
        IsEnabled: Boolean;
    begin
        if recSetup.FindFirst then begin
            IsEnabled := recSetup."EiCard Automation Enabled";
        end;
        if IsEnabled = false then
            Enable := false;
        EIFieldsEnable := Enable;
    end;

    procedure FindRec(OrderNo: Code[20])
    begin
        Rec."No." := OrderNo;
        Rec.Find('=');
    end;

    local procedure AutoConfirm()
    var
        recSalesLine: Record "Sales Line";
        recItem: Record Item;
        Forecast: Decimal;
        ItemBudgetManagement: Codeunit "Item Budget Management Ext.";
        UpdateShip: Boolean;
        AllinDates: Codeunit "Delivery Document Management";
        ShipmentMonth: Integer;
        ShipmentYear: Integer;
        BeginDate: Date;
        EndDate: Date;
        DateFormula: DateFormula;
        MonthFormula: Text[10];
        YearFormula: Text[10];
        CountryFilter: Text;
    begin
        //>> 05-07-19 ZY-LD 021
        UpdateShip := Confirm('Do you want to update the shipment dates?');

        ShipmentMonth := Date2dmy(Today, 2);
        ShipmentYear := Date2dmy(Today, 3);
        BeginDate := Dmy2date(1, ShipmentMonth, ShipmentYear);
        EndDate := CalcDate('CM', CalcDate('<3M>', BeginDate));

        recSalesLine.LockTable;
        recSalesLine.SetRange("Document Type", Rec."Document Type");
        recSalesLine.SetRange("Document No.", Rec."No.");
        recSalesLine.SetRange("Shipment Date Confirmed", false);
        recSalesLine.SetRange(recSalesLine.Type, recSalesLine.Type::Item);
        recSalesLine.SetRange("Shipment Date", BeginDate, EndDate);
        recSalesLine.SetRange("Additional Item Line No.", 0);
        if recSalesLine.FindSet(true) then
            repeat
                recSalesLine.SetConfirmedDate(true);
                recSalesLine.SetDontUpdateDeliveryDates(not UpdateShip);
                recItem.SetRange("Location Filter", Rec."Location Code");
                if recItem.Get(recSalesLine."No.") then begin
                    // Calculate forecast
                    MonthFormula := Format(Date2dmy(recSalesLine."Shipment Date", 2) - Date2dmy(Today, 2)) + 'M';
                    YearFormula := Format(Date2dmy(recSalesLine."Shipment Date", 3) - Date2dmy(Today, 3)) + 'Y';
                    Evaluate(DateFormula, MonthFormula + '+' + YearFormula);
                    Forecast := ItemBudgetManagement.GetSOForecast(recSalesLine."Sell-to Customer No.", '', recSalesLine."No.", recSalesLine."Shortcut Dimension 1 Code", DateFormula, CountryFilter, false, false, false, false);

                    if (recSalesLine.Quantity <= recItem.CalcAvailableStock(false)) and
                       (recSalesLine.Quantity <= Forecast)
                    then begin
                        recSalesLine.Validate("Shipment Date Confirmed", true);
                        recSalesLine.Modify;
                    end;
                end;
            until recSalesLine.Next() = 0;
        //<< 05-07-19 ZY-LD 021
    end;

    local procedure SetActions()
    var
        recInvSetup: Record "Inventory Setup";
        recSalesSetup: Record "Sales & Receivables Setup";
        recPurchHead: Record "Purchase Header";
        Cust: Record Customer;
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
    begin
        DisableAddtionalItemsVisible := not Rec."Disable Additional Items";  // 09-04-18 ZY-LD 006
        EnableAddtionalItemsVisible := Rec."Disable Additional Items";  // 09-04-18 ZY-LD 006
        recInvSetup.Get;  // 01-02-19 ZY-LD 016
        EInvoiceCommentEnable := (Rec."Bill-to Country/Region Code" = 'IT') and (Rec."Location Code" = recInvSetup."AIT Location Code");  // 01-02-19 ZY-LD 016
        PostButtonsEnabled :=
          not Rec."Combine Shipments" or  // 01-11-19 ZY-LD 026
          SalesHeadEvent.HidePostButtons(Rec."Location Code", Rec."No.");  // 13-03-19 ZY-LD 006
        //>> 25-06-19 ZY-LD 020
        recSalesSetup.Get;
        EiCardVisible := Rec."Sales Order Type" = Rec."sales order type"::EICard;
        EiCardEnable := recSalesSetup."EiCard Automation Enabled";
        EIFieldsEnable := recSalesSetup."EiCard Automation Enabled";
        //<< 25-06-19 ZY-LD 020
        ShipReqNotesVisible := (Rec."Sell-to Customer No." = recSalesSetup."Customer No. on Sister Company");  // 16-08-19 ZY-LD 022
        //>> 24-02-20 ZY-LD 028
        recPurchHead.SetRange("Special Order Sales No.", Rec."No.");
        CreatePurchaseOrderEnable :=
          (Rec."Sales Order Type" = Rec."sales order type"::"Spec. Order") and
          ZGT.IsRhq and ZGT.IsZNetCompany and
          not recPurchHead.FindFirst;
        //<< 24-02-20 ZY-LD 028
        //>> 18-08-21 ZY-LD 032
        VATRegistrationNoSellToVisible :=
          ZGT.IsRhq and
          ((ZGT.IsZComCompany and (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.")) or  //<< 18-08-21 ZY-LD 032
           (ZGT.IsZComCompany and (Rec."Ship-to Country/Region Code" <> Rec."Sell-to Country/Region Code")) or  // 09-02-24 ZY-LD 032
           (ZGT.IsZNetCompany and (Rec."VAT Registration No." <> Rec."Ship-to VAT")));  // 28-10-21 ZY-LD 032
        //>> 20-05-24 ZY-LD 005 
        IF Cust.Get(Rec."Sell-to Customer No.") then
            ShipToCodeDelDocVisible := ZGT.IsRhq and ZGT.IsZComCompany and Cust."Sample Account" and (Rec."Document Type" = Rec."Document Type"::Order) and (Rec."Sales Order Type" <> Rec."sales order type"::EICard);
        //<< 20-05-24 ZY-LD 005
    end;

    local procedure ChangeSubCurrencyCode()
    var
        recCurrency: Record Currency;
        GenericInputPage: Page "Generic Input Page";
        lText001: label 'Currency Code Sales Document SUB';
        lText002: label 'New SUB Currency Code';
        NewCurr: Code[10];
        lText003: label 'Current value of "%1" is "%2".';
    begin
        //>> 05-03-20 ZY-LD 029
        GenericInputPage.SetPageCaption(lText001);
        GenericInputPage.SetFieldCaption(lText002);
        GenericInputPage.SetCode20(Rec."Currency Code Sales Doc SUB");
        GenericInputPage.SetVisibleField(3);
        if GenericInputPage.RunModal = Action::OK then begin
            NewCurr := GenericInputPage.GetCode20;
            if NewCurr <> Rec."Currency Code Sales Doc SUB" then begin
                if NewCurr <> '' then
                    recCurrency.Get(NewCurr);
                Rec.Validate(Rec."Currency Code Sales Doc SUB", NewCurr);
                Rec.Modify(true);
            end;
        end;
        Message(lText003, Rec.FieldCaption(Rec."Currency Code Sales Doc SUB"), Rec."Currency Code Sales Doc SUB");
        //<< 05-03-20 ZY-LD 029
    end;
}
