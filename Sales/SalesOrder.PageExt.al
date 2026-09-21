PageExtension 50126 SalesOrderZX extends "Sales Order"
{
    layout
    {
        addlast("Foreign Trade")
        {
            field("Send IC Document"; Rec."Send IC Document")
            {
                ApplicationArea = Basic, Suite;
                Visible = true;
                ToolTip = 'Specification of send IC documents';
            }

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
                SetActions();
                CurrPage.UPDATE(FALSE);
            end;
        }
        modify("Late Order Shipping")
        {
            Visible = false;
        }
        modify(Control1901796907)
        {
            Visible = false;
        }
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
        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specification of Sales Order Type';

                trigger OnValidate()
                begin
                    SetActions();
                end;
            }
        }
        addafter("No. of Archived Versions")
        {
            field("Shipping Request Notes"; Rec."Shipping Request Notes")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShipReqNotesVisible;
                ToolTip = 'Specification of Shipping Request Notes';
            }
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                SetActions();
            end;
        }
        addafter("Location Code")
        {
            field("Eicard Type"; Rec."Eicard Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = EiCardVisible;
                ToolTip = 'Specification of Eicard Type';
            }
            group(ExternalRef)
            {
                ShowCaption = false;
                field("External Document No. End Cust"; Rec."External Document No. End Cust")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specification of Exernal Document No. End Cust';
                }
                field("E-Invoice Comment"; Rec."E-Invoice Comment")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = EInvoiceCommentEnable;
                    ShowMandatory = EInvoiceCommentEnable;
                    ToolTip = 'Specification of E-Invoice Comment';
                }
            }
            field("Customer Document No."; Rec."Customer Document No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specification of Customer Document No.';
            }
            field("SAP No."; Rec."SAP No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specification of SAP No.';
            }
            field("Backlog Comment"; Rec."Backlog Comment")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specification of Backlog Comment';
            }
        }
        movebefore("External Document No. End Cust"; "External Document No.")
        addafter("Salesperson Code")
        {
            field("Order Desk Resposible Code"; Rec."Order Desk Resposible Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specification of Order Desk Resposible Code';
            }
            field(SystemCreatedBy; CreatedUserName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Created By';
                Visible = false;
                ToolTip = 'Specification of Created User Name';
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
                ToolTip = 'Specification of Ship-to VAT';
            }
            field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specification of VAT Registration No. Zyxel';
            }
            field("Send Mail"; Rec."Send Mail")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specification of Send Mail';
            }
        }
        modify("Ship-to Country/Region Code")
        {
            trigger OnAfterValidate()
            begin
                SetActions();
            end;
        }
        modify("Ship-to Address 2")
        {
            Editable = true;
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
                ToolTip = 'Specification of Amazone PO. No.';
            }
            field(AmazconfirmationStatus; Rec.AmazconfirmationStatus)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ToolTip = 'Specification of Amazon confirmation Status';
            }
            field(AmazonpurchaseOrderState; Rec.AmazonpurchaseOrderState)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ToolTip = 'Specification of Amazon Purchase Order State';
            }
            field(AmazonSellpartyid; Rec.AmazonSellpartyid)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ToolTip = 'Specification of Amazon Sell party ID';
            }
        }
        addafter("Combine Shipments") //17-09-2026 BK #576888
        {
            field("Combine Eicard Shipments"; Rec."Combine Eicard Shipments")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Combine Eicard Shipments';
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
                CustomReportSelection: Record "Custom Report Selection";
                CustReptMgt: Codeunit "Custom Report Management";
                tempmail2: text;
                temptext: text;
            begin
                Tempmail := rec."Sell-to E-Mail";
                if strlen(CustReptMgt.GetEmailAddress(Database::Customer, Rec."Sell-to Customer No.", CustomReportSelection.Usage::"S.Order", tempmail2)) > 80 then begin
                    temptext := CustReptMgt.GetEmailAddress(Database::Customer, Rec."Sell-to Customer No.", CustomReportSelection.Usage::"S.Order", tempmail2);
                    temptext := CopyStr(temptext, 1, StrPos(temptext, ';') - 1);
                    rec."Sell-to E-Mail" := copystr(temptext, 1, 80);
                end else
                    rec."Sell-to E-Mail" := copystr(CustReptMgt.GetEmailAddress(Database::Customer, Rec."Sell-to Customer No.", CustomReportSelection.Usage::"S.Order", tempmail2), 1, 80);
            end;

            trigger OnAfterAction()
            begin
                rec."Sell-to E-Mail" := copystr(Tempmail, 1, 80);
            end;
        }
        addafter("Warehouse Shipment Lines")
        {
            action("Delivery Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Document';
                ToolTip = 'Specification of Warehouse Shipment Lines';
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
                ToolTip = 'Specification of Change Log';

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
                    ToolTip = 'Specification of Eicard Queue';
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
                    ToolTip = 'Specification of Import Sales Order Lines';

                    trigger OnAction()
                    var
                        Import: Report "Import Sales Order Lines";
                    begin
                        Import.SetDocumentNo(Rec."No.");
                        Import.Run();
                    end;
                }
                action("GLC-Eicard")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'GLC-Eicard';
                    Image = ImportExcel;
                    RunObject = Page "Config. Package Card";
                    RunPageView = where(Code = const('GLS-EICARD'));
                    ToolTip = 'Specification of GLC Eicard';
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
                ToolTip = 'Specification of Disable Additional Items';

                trigger OnAction()
                begin
                    SalesHeadEvent.DisableEnableAdditionalItems(Rec);
                    SetActions();
                    CurrPage.Update();
                end;
            }
            action("Enable Additional Items")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Enable Additional Items';
                Image = EnableAllBreakpoints;
                Visible = enableAddtionalItemsVisible;
                ToolTip = 'Specification of Enable Additional Items';

                trigger OnAction()
                begin
                    SalesHeadEvent.DisableEnableAdditionalItems(Rec);
                    SetActions();
                    CurrPage.Update();
                end;
            }
        }

        addLast("F&unctions")
        {
            group("Amazon")
            {
                Caption = 'Amazon';
                Image = Documents;
                Action(SendAcknowledge)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send order acknowledgement to Anazon';
                    Image = UpdateXML;
                    ToolTip = 'Specification of Send Order Acknowledgement to Anazon';

                    trigger OnAction()
                    var
                        AmazonHelper: Codeunit AmazonHelper;
                        Confirmtext: Label 'have you updated quantities on all lines? ';
                    begin
                        if confirm(Confirmtext, true) then begin
                            AmazonHelper.SetAmazonOrderRejected(rec, copystr(rec.AmazonSellpartyid, 1, 10));
                            commit();
                            AmazonHelper.UpdateAmazonstatus(rec);
                        end;

                    end;
                }
                Action(updateStatus)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Update status';
                    Image = UpdateXML;
                    ToolTip = 'Specification of Update Status';

                    trigger OnAction()
                    var
                        AmazonHelper: Codeunit AmazonHelper;
                    begin
                        AmazonHelper.UpdateAmazonstatus(rec);

                    end;
                }

                Action(Rule1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Check rule - delivery window';
                    Image = UpdateXML;
                    ToolTip = 'Specification of Check Rule - Delivery Window';
                    trigger OnAction()
                    var
                        AmazonHelper: Codeunit AmazonHelper;
                    begin
                        AmazonHelper.autorejectSalesheader(rec);

                    end;
                }
                Action(Rule2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Check rule - low order value';
                    Image = UpdateXML;
                    ToolTip = 'Specification of Check Rule - Low Order Value';

                    trigger OnAction()
                    var
                        AmazonHelper: Codeunit AmazonHelper;
                    begin
                        AmazonHelper.autorejectSalesheaderLowAmount(rec);

                    end;
                }
                action(Submitshippinglabelrequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Submit Shipping Label Request';
                    Image = PostMail;
                    ToolTip = 'Specification of Submit Shipping Label Request';

                    trigger OnAction()
                    var
                        AmazonHelper: Codeunit AmazonHelper;

                    begin
                        AmazonHelper.SubmitShippingLabelRequest(rec);

                    end;
                }

                action(packingSlips)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Download packingSlips';
                    Image = Approval;
                    ToolTip = 'Specification of Download PackingSlip';

                    trigger OnAction()
                    var
                        AmazonHelper: Codeunit AmazonHelper;
                        texttemp: text;
                    begin
                        if AmazonHelper.GETAmazonOrderpackingSlips(texttemp, copystr(rec.AmazonSellpartyid, 1, 10), rec) then
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
                    ToolTip = 'Specification of Auto Confirm';

                    trigger OnAction()
                    var
                        AutoConfirm: Codeunit "Pick. Date Confirm Management";
                    begin
                        SI.SetValidateFromPage(false);
                        AutoConfirm.PerformManuelConfirm(0, Rec."No.");
                        SI.SetValidateFromPage(true);
                    end;
                }
                action(PrintPickList1SO)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print Picking List (for single SO only)';
                    Visible = false;
                    ToolTip = 'Specification of Print Picking List';

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
                    ToolTip = 'Specification of Update Additional Items';

                    trigger OnAction()
                    begin
                        if Confirm(Text007) then
                            AddItemMgt.UpdateAdditionalItems(Rec."Document Type", Rec."No.", Rec."Ship-to Country/Region Code");
                    end;
                }
                action("Create Spec. Purchase Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Spec. Purchase Order';
                    Enabled = CreatePurchaseOrderEnable;
                    Image = CreateDocument;
                    ToolTip = 'Specification of Create Spec. Purchase Order';

                    trigger OnAction()
                    begin
                        Rec.TestField(Rec.Status, Rec.Status::Released);
                        recSalesHead.SetRange("Document Type", Rec."Document Type");
                        recSalesHead.SetRange("No.", Rec."No.");
                        Report.RunModal(Report::"Create Purchase Order", true, false, recSalesHead);
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
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.Run(Rec);
                        DelDocMgt.PerformCreationForSingleOrder(Rec."No.");
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
                    ToolTip = 'Specification of Add to Eicard Queue';

                    trigger OnAction()
                    var
                        recCust: Record Customer;
                        EiCardCodeUnit: Codeunit "ZyXEL EiCards";
                    begin
                        if Rec.Status <> Rec.Status::Released then
                            Error(zyText002);

                        recCust.Get(Rec."Sell-to Customer No.");
                        if recCust.Blocked <> recCust.Blocked::" " then
                            recCust.FieldError(Blocked);

                        recEiCardQueue.SetRange(Active, true);
                        recEiCardQueue.SetRange("Sales Order No.", Rec."No.");
                        if recEiCardQueue.FindFirst() then
                            Error(zyText003, Rec."No.");
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
                    ToolTip = 'Specification of Eicard Queue';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();
        SI.SetRejectChangeLog(FALSE);

        IF (Rec."Sell-to Customer No." = '200122') OR (Rec."Sell-to Customer No." = '200150') THEN
            IF NOT recEiCardQueue.GET(Rec."No.") THEN BEGIN
                recEiCardQueue.VALIDATE("Sales Order No.", Rec."No.");
                recEiCardQueue.VALIDATE("Customer No.", Rec."Sell-to Customer No.");
                recEiCardQueue.INSERT(TRUE);
            END;
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(FALSE);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Control1901796907.Page.SetLocationFilter(Rec."Location Code");
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();

        CreatedUserName := copystr(ZGT.GetFullUserName(Rec.SystemCreatedBy), 1, 80);
    end;

    var
        SalesOrderHeader: Record "Sales Header";
        recEiCardQueue: Record "EiCard Queue";
        recSalesHead: Record "Sales Header";
        DelDocMgt: Codeunit "Delivery Document Management";
        SI: Codeunit "Single Instance";
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
        ZyXELVCK: Codeunit "ZyXEL VCK";
        AddItemMgt: Codeunit "ZyXEL Additional Items Mgt";
        ZGT: Codeunit "ZyXEL General Tools";
        EIFieldsEnable: Boolean;
        DisableAddtionalItemsVisible: Boolean;
        EnableAddtionalItemsVisible: Boolean;
        EInvoiceCommentEnable: Boolean;
        PostButtonsEnabled: Boolean;
        ShipToCodeDelDocVisible: Boolean;
        EiCardVisible: Boolean;
        EiCardEnable: Boolean;
        ShipReqNotesVisible: Boolean;
        CreatePurchaseOrderEnable: Boolean;
        VATRegistrationNoSellToVisible: Boolean;
        CreatedUserName: Text[80];
        Tempmail: text;
        Text007: label 'Do you want to update Additional Items?';
        zyText002: label 'Status must be released before you can add to eicard queue.';
        zyText003: label 'EiCard Queue is already crated on sales order %1.';

    procedure EnableEiCards(Enable: Boolean)
    var
        recSetup: Record "Sales & Receivables Setup";
        IsEnabled: Boolean;
    begin
        if recSetup.FindFirst() then begin
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

    local procedure SetActions()
    var
        recInvSetup: Record "Inventory Setup";
        recSalesSetup: Record "Sales & Receivables Setup";
        recPurchHead: Record "Purchase Header";
        Cust: Record Customer;
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
    begin
        DisableAddtionalItemsVisible := not Rec."Disable Additional Items";
        EnableAddtionalItemsVisible := Rec."Disable Additional Items";
        recInvSetup.Get();
        EInvoiceCommentEnable := (Rec."Bill-to Country/Region Code" = 'IT') and (Rec."Location Code" = recInvSetup."AIT Location Code");
        PostButtonsEnabled :=
          not Rec."Combine Shipments" or
          SalesHeadEvent.HidePostButtons(Rec."Location Code", Rec."No.");
        recSalesSetup.Get();
        EiCardVisible := Rec."Sales Order Type" = Rec."sales order type"::EICard;
        EiCardEnable := recSalesSetup."EiCard Automation Enabled";
        EIFieldsEnable := recSalesSetup."EiCard Automation Enabled";
        ShipReqNotesVisible := (Rec."Sell-to Customer No." = recSalesSetup."Customer No. on Sister Company");
        recPurchHead.SetRange("Special Order Sales No.", Rec."No.");
        CreatePurchaseOrderEnable :=
          (Rec."Sales Order Type" = Rec."sales order type"::"Spec. Order") and
          ZGT.IsRhq() and ZGT.IsZNetCompany() and
          not recPurchHead.FindFirst();
        VATRegistrationNoSellToVisible :=
          ZGT.IsRhq() and
          ((ZGT.IsZComCompany() and (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.")) or
           (ZGT.IsZComCompany() and (Rec."Ship-to Country/Region Code" <> Rec."Sell-to Country/Region Code")) or
           (ZGT.IsZNetCompany() and (Rec."VAT Registration No." <> Rec."Ship-to VAT")));
        IF Cust.Get(Rec."Sell-to Customer No.") then
            ShipToCodeDelDocVisible := ZGT.IsRhq() and ZGT.IsZComCompany() and Cust."Sample Account" and (Rec."Document Type" = Rec."Document Type"::Order) and (Rec."Sales Order Type" <> Rec."sales order type"::EICard);
    end;
}
