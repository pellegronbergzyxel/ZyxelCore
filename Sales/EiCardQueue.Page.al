page 50073 "EiCard Queue"
{
    // 001. 01-04-19 ZY-LD 2019032610000026 - New parameter.
    // 002. 27-08-19 ZY-LD 2019082710000042 - Post buttons enabled.
    // 003. 03-09-19 ZY-LD 000 - Send EiCard E-mail.
    // 004. 20-09-19 ZY-LD P0302 - Post sales invoice through new function.
    // 005. 24-09-19 ZY-LD P0290 - Post Purchase Orders.
    // 006. 08-11-19 ZY-LD P0334 - Show message at resend.
    // 007. 07-01-20 ZY-LD P0368 - Send to eShop with delay.
    // 008. 14-02-20 ZY-LD 000 - Resend invoice reminder.
    // 009. 09-12-20 ZY-LD 000 - Extra Parameter.

    ApplicationArea = Basic, Suite;
    Caption = 'EiCard Queue';
    CardPageID = "EiCard Queue Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "EiCard Queue";
    SourceTableView = order(descending)
                      where(Active = const(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Control11)
            {
                Visible = EndOfMonthVisible;
                field("recAutoSetup.AutomationBlockedByEOM"; recAutoSetup.AutomationBlockedByEOM)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = true;
                }
            }
            repeater(Control1000000000)
            {
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Distributor Reference"; Rec."Distributor Reference")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleText;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Sales Order Status"; Rec."Sales Order Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Purchase Order Status"; Rec."Purchase Order Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Status Change Date Time"; Rec."Status Change Date Time")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Links"; Rec."Quantity Links")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Quantity Sales Order"; Rec."Quantity Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Size (Mb)"; Rec."Size (Mb)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("No. of Sales Order Lines"; Rec."No. of Sales Order Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("No. of EiCard Link Lines"; Rec."No. of EiCard Link Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("HQ Invoice Received"; Rec."HQ Invoice Received")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Invoice Reminder Sent"; Rec."Invoice Reminder Sent")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Eicard Type"; Rec."Eicard Type")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Sales Order")
            {
                Caption = 'Sales Order';
                Action(ViewSalesOrder)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'View Sales Order';
                    Image = ViewOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View Sales Order';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        if Rec."Sales Order Status" = Rec."sales order status"::Posted then
                            Error(Text004, Rec."Sales Order No.");

                        SalesHeader.SetFilter("No.", Rec."Sales Order No.");
                        if SalesHeader.FindFirst() then
                            Page.Run(Page::"Sales Order", SalesHeader);
                    end;
                }
            }
            group("Purchase Order")
            {
                Caption = 'Purchase Order';
                Action(ViewPurchaseOrder)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'View Purchase Order';
                    Image = ViewOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View Purchase Order';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        if Rec."Purchase Order Status" = Rec."purchase order status"::Posted then
                            Error(Text005, Rec."Purchase Order No.");

                        PurchaseHeader.SetFilter("No.", Rec."Purchase Order No.");
                        if PurchaseHeader.FindFirst() then begin
                            case PurchaseHeader."Document Type" of
                                PurchaseHeader."document type"::Quote:
                                    Page.Run(Page::"Purchase Quote", PurchaseHeader);
                                PurchaseHeader."document type"::"Blanket Order":
                                    Page.Run(Page::"Blanket Purchase Order", PurchaseHeader);
                                PurchaseHeader."document type"::Order:
                                    Page.Run(Page::"Purchase Order", PurchaseHeader);
                                PurchaseHeader."document type"::Invoice:
                                    Page.Run(Page::"Purchase Invoice", PurchaseHeader);
                                PurchaseHeader."document type"::"Return Order":
                                    Page.Run(Page::"Purchase Return Order", PurchaseHeader);
                                PurchaseHeader."document type"::"Credit Memo":
                                    Page.Run(Page::"Purchase Credit Memo", PurchaseHeader);
                            end;
                        end;
                    end;
                }
                Action(InvoiceLines)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'HQ Invoice';
                    Image = ItemLines;
                    ToolTip = 'View HQ Invoice';
                    RunObject = page "HQ Sales Header Card";
                    RunPageLink = "Purchase Order No." = field("Purchase Order No.");
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                Action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field("Sales Order No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(50036));
                }
            }
        }
        area(processing)
        {
            group(ActionGroup13)
            {
                Caption = 'Sales Order';
                Action(PostSalesOrderAction)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Sales Order';
                    Enabled = SalesPostButtonsEnabled;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PostSalesOrder;  // 24-09-19 ZY-LD 005
                    end;
                }
                Action("Post All Selected")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post All Selected';
                    Image = PostDocument;
                    ToolTip = 'Post All Selected Purchase Orders';

                    trigger OnAction()
                    var
                        "count": Integer;
                    begin
                        PostSelectedSalesOrder; // 24-09-19 ZY-LD 005
                    end;
                }
                Action("Post All")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post All';
                    Image = PostBatch;

                    trigger OnAction()
                    var
                        "count": Integer;
                    begin
                        PostAllSalesOrders; // 24-09-19 ZY-LD 005
                    end;
                }
            }
            group(ActionGroup9)
            {
                Caption = 'Purchase Order';
                Action(PostPurchaseOrderAction)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Purchase Order';
                    Enabled = PurchPostButtonsEnabled;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Post Purchase Order';

                    trigger OnAction()
                    begin
                        PostPurchaseOrder;  // 24-09-19 ZY-LD 005
                    end;
                }
                Action(Action6)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post All Selected';
                    Image = PostDocument;
                    ToolTip = 'Post All Selected Purchase Orders';

                    trigger OnAction()
                    var
                        "count": Integer;
                    begin
                        PostSelectedPurchaseOrder; // 24-09-19 ZY-LD 005
                    end;
                }
                Action(Action20)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post All';
                    Image = PostBatch;

                    trigger OnAction()
                    var
                        "count": Integer;
                    begin
                        PostAllPurchaseOrders; // 24-09-19 ZY-LD 005
                    end;
                }
                Action(Send)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send';
                    Image = PostSendTo;
                    ToolTip = 'Send the EiCard to eShop';
                    Visible = SendToEshopVisible;

                    trigger OnAction()
                    begin
                        //>> 07-01-19 ZY-LD 007
                        if Confirm(Text019, true, Rec."Purchase Order No.") then
                            if EiCardCodeUnit.SendToHQ(Rec, false) then
                                Message(Text018, Rec."Purchase Order No.");
                        //<< 07-01-19 ZY-LD 007
                    end;
                }
                Action(Resend)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re-Send';
                    Image = PostSendTo;
                    ToolTip = 'Re-Send the EiCard to eShop';
                    Visible = ResendToEshopVisible;

                    trigger OnAction()
                    begin
                        if Dialog.Confirm(Text007) then
                            if EiCardCodeUnit.SendToHQ(
                              Rec,
                              true)  // 01-04-19 ZY-LD 001
                            then
                                Message(Text017, Rec."Purchase Order No.");  // 08-11-19 ZY-LD 006
                    end;
                }
            }
            group(Reminder)
            {
                Caption = 'Reminder';
                Action("Re-send purchase invoice reminder")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re-send purchase invoice reminder';
                    Image = SendMail;

                    trigger OnAction()
                    begin
                        //>> 14-02-20 ZY-LD 008
                        if Confirm(Text020, true) then begin
                            Rec."Invoice Reminder Sent" := false;
                            Rec.Modify();
                        end;
                        //<< 14-02-20 ZY-LD 008
                    end;
                }
            }
            Action("Send EiCard Link E-mail")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send EiCard Link E-mail';
                Enabled = SendEiCardEmailEnabled;
                Image = SendTo;

                trigger OnAction()
                begin
                    SendEiCardLinkEmail(false);  // 03-09-19 ZY-LD 003
                end;
            }
            Action("Test - Send EiCard Link E-mail")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Test - Send EiCard Link E-mail';
                Enabled = SendEiCardEmailEnabledTest;
                Image = Questionaire;

                trigger OnAction()
                begin
                    SendEiCardLinkEmail(true);  // 03-09-19 ZY-LD 003
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst() then;  // 03-09-19 ZY-LD 003
        SetActions();  // 27-08-19 ZY-LD 002
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 27-08-19 ZY-LD 002
    end;

    var
        Text000: Label 'Unable to execute this function while in view only mode.';
        Text001: Label 'There are non posted Prepayment Amounts on %1.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1.';
        Text003: Label 'Sales Order %1 is already posted.';
        Text004: Label 'Sales Order %1 cannot be viewed as it has been posted.';
        Text005: Label 'Purchase Order %1 cannot be viewed as it has been posted.';
        Text006: Label 'Purchase Order %1 is already posted.';
        Text007: Label 'Are you sure that you want to re-send the Purchase Order to eShop?';
        Text008: Label 'No Invoice Lines are available for Purchase Order %1.';
        Text009: Label 'A Source Document is not available for Purchase Order %1.';
        recHqSalesDoc: Record "HQ Invoice Header";
        recAutoSetup: Record "Automation Setup";
        EiCardCodeUnit: Codeunit "ZyXEL EiCards";
        Text010: Label 'Sales Order %1 has been posted.';
        Text011: Label 'There was an error posting Sales Order %1.';
        Text012: Label 'Purchase Order %1 has been posted.';
        Text013: Label 'There was an error posting Purchase Order %1.';
        Text014: Label '%1 Sales Orders Posted.';
        Text015: Label '%1 Purchase Orders Posted.';
        Text016: Label 'Purchase Order %1 Not Fully Matched.';
        HqSaleDocMgt: Codeunit "HQ Sales Document Management";
        StyleText: Text[30];
        SalesPostButtonsEnabled: Boolean;
        PurchPostButtonsEnabled: Boolean;
        SendEiCardEmailEnabled: Boolean;
        SendEiCardEmailEnabledTest: Boolean;
        SendToEshopVisible: Boolean;
        ResendToEshopVisible: Boolean;
        EndOfMonthVisible: Boolean;
        Text017: Label 'EiCard Order for Purchase Order %1 re-sent to eShop';
        Text018: Label 'EiCard Order for Purchase Order %1 sent to eShop';
        Text019: Label 'Do you want to send Purchase Order %1 to eShop?';
        Text020: Label 'Do you want to re-send purchase invoice reminder?';

    local procedure SendEiCardLinkEmail(Test: Boolean)
    var
        EiCardMgt: Codeunit "Process EiCard Links";
        lText001: Label 'Do you want to send "EiCard Link E-mail" for sales order no. %1?';
        lText002: Label 'The e-mail is sent to the customer.';
        lText003: Label 'It was not possible to send the e-mail.';
        GenInputPage: Page "Generic Input Page";
        SendEmail: Boolean;
        lText004: Label 'Enter Test E-mail Address';
        lText005: Label 'Send to E-mail';
        lText006: Label 'Do you want to send "EiCard Link E-mail" to "%1"?';
        TestEmailAdd: Text;
    begin
        //>> 03-09-19 ZY-LD 003
        if Test then begin
            GenInputPage.SetPageCaption(lText004);
            GenInputPage.SetFieldCaption(lText005);
            GenInputPage.SetVisibleField(0);  // Text
            GenInputPage.SetText := StrSubstNo('%1@zyxel.eu', CopyStr(LowerCase(UserId()), 6, StrLen(UserId())));
            if GenInputPage.RunModal = Action::OK then begin
                TestEmailAdd := GenInputPage.GetText;
                if TestEmailAdd <> '' then
                    SendEmail := Confirm(lText006, true, TestEmailAdd);
            end;
        end else
            SendEmail := Confirm(lText001, true, Rec."Sales Order No.");

        if SendEmail then
            if EiCardMgt.SendEiCardLinks(Rec."Sales Order No.", TestEmailAdd, false) then
                Message(lText002)
            else
                Message(lText003);
        //<< 03-09-19 ZY-LD 003
    end;

    local procedure SetActions()
    var
        recSalesHead: Record "Sales Header";
        recPurchHead: Record "Purchase Header";
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
    begin
        StyleText := '';

        if Rec."Purchase Order Status" = Rec."purchase order status"::Created then
            StyleText := 'Standard';
        if Rec."Purchase Order Status" = Rec."purchase order status"::"EiCard Order Sent to HQ" then
            StyleText := 'Standard';
        if Rec."Purchase Order Status" = Rec."purchase order status"::"EiCard Order Accepted" then
            StyleText := 'Standard';
        if Rec."Purchase Order Status" = Rec."purchase order status"::"EiCard Order Rejected" then
            StyleText := 'Unfavorable';
        if Rec."Purchase Order Status" = Rec."purchase order status"::"Fully Matched" then
            StyleText := 'Favorable';
        if Rec."Purchase Order Status" = Rec."purchase order status"::"Posting Error" then
            StyleText := 'Unfavorable';
        if Rec."Purchase Order Status" = Rec."purchase order status"::Posted then
            StyleText := 'Favorable';
        if Rec."Purchase Order Status" = Rec."purchase order status"::"Partially Matched" then
            StyleText := 'Ambiguous';

        //>> 27-08-19 ZY-LD 002
        if recSalesHead.Get(recSalesHead."document type"::Order, Rec."Sales Order No.") then
            SalesPostButtonsEnabled :=
              (Rec."Sales Order Status" = Rec."sales order status"::"EiCard Sent to Customer") and  // 07-01-20 ZY-LD 007
              SalesHeadEvent.HidePostButtons(recSalesHead."Location Code", '');
        if recPurchHead.Get(recPurchHead."document type"::Order, Rec."Purchase Order No.") then
            PurchPostButtonsEnabled :=
              (Rec."Purchase Order Status" = Rec."purchase order status"::"EiCard Order Accepted") and  // 07-01-20 ZY-LD 007
              SalesHeadEvent.HidePostButtons(recPurchHead."Location Code", '');
        //<< 27-08-19 ZY-LD 002

        SendEiCardEmailEnabled := (Rec."Purchase Order Status" >= Rec."purchase order status"::"EiCard Order Accepted") and  // 09-12-20 ZY-LD 009
                                  (Rec."Sales Order Status" < Rec."sales order status"::"EiCard Sent to Customer");  // 03-09-19 ZY-LD 003
        SendEiCardEmailEnabledTest := Rec."Purchase Order Status" >= Rec."purchase order status"::"EiCard Order Accepted";  // 09-12-20 ZY-LD 009
        //>> 07-01-20 ZY-LD 007
        SendToEshopVisible := Rec."Purchase Order Status" = Rec."purchase order status"::Created;
        ResendToEshopVisible := Rec."Purchase Order Status" in [Rec."purchase order status"::"EiCard Order Sent to HQ", Rec."purchase order status"::"Fully Matched"];
        //<< 07-01-20 ZY-LD 007
        if recAutoSetup.Get() then
            if recAutoSetup.AutomationBlockedByEOM <> '' then
                EndOfMonthVisible := true;
    end;

    local procedure OnTimer()
    begin
        SelectLatestVersion;
        CurrPage.Update(false);
    end;

    local procedure PostPurchaseOrder()
    var
        lText001: Label 'Do you want to post Purchase Order %1?';
    begin
        //>> 24-09-19 ZY-LD 005
        if Confirm(lText001, true, Rec."Purchase Order No.") then begin
            if Rec."Purchase Order Status" = Rec."purchase order status"::Posted then
                Error(Text006, Rec."Purchase Order No.");

            HqSaleDocMgt.PostEiCardPurchaseOrders(Rec."Purchase Order No.", false);
        end;
        //<< 24-09-19 ZY-LD 005
    end;

    local procedure PostSelectedPurchaseOrder()
    var
        recEiCardQueue: Record "EiCard Queue";
        Qty: Integer;
        lText001: Label 'Do you want to post %1 EiCard Purchace Orders?';
        lText002: Label '%1 orders out of a total of %2 have now been posted.';
        Total: Integer;
    begin
        //>> 24-09-19 ZY-LD 005
        CurrPage.SetSelectionFilter(recEiCardQueue);
        recEiCardQueue.SetRange("HQ Invoice Received", true);
        Total := recEiCardQueue.Count();
        if Confirm(lText001, true, Total) then
            if recEiCardQueue.FindSet(false) then begin
                repeat
                    if HqSaleDocMgt.PostEiCardPurchaseOrders(recEiCardQueue."Purchase Order No.", true) then
                        Qty += 1;
                until recEiCardQueue.Next() = 0;
                Message(lText002, Qty, Total);
            end;
        //<< 24-09-19 ZY-LD 005
    end;

    local procedure PostAllPurchaseOrders()
    var
        lText001: Label 'Do you want to post all EiCard Purchace Orders?';
    begin
        //>> 24-09-19 ZY-LD 005
        if Confirm(lText001, true) then
            HqSaleDocMgt.PostEiCardPurchaseOrders('', false);
        //<< 24-09-19 ZY-LD 005
    end;

    local procedure PostSalesOrder()
    var
        lText001: Label 'Do you want to post Sales Order %1?';
    begin
        //>> 24-09-19 ZY-LD 005
        if Confirm(lText001, true, Rec."Sales Order No.") then begin
            if Rec."Sales Order Status" = Rec."sales order status"::Posted then
                Error(Text006, Rec."Sales Order No.");

            HqSaleDocMgt.PostEiCardSalesOrders(Rec."Sales Order No.", false);
        end;
        //<< 24-09-19 ZY-LD 005
    end;

    local procedure PostSelectedSalesOrder()
    var
        recEiCardQueue: Record "EiCard Queue";
        Qty: Integer;
        lText001: Label 'Do you want to post %1 EiCard Sales Orders?';
        lText002: Label '%1 orders out of a total of %2 have now been posted.';
        Total: Integer;
    begin
        //>> 24-09-19 ZY-LD 005
        CurrPage.SetSelectionFilter(recEiCardQueue);
        recEiCardQueue.SetRange("Comparision of Qty and Link Ok", true);
        Total := recEiCardQueue.Count();
        if Confirm(lText001, true, Total) then
            if recEiCardQueue.FindSet(false) then begin
                repeat
                    if HqSaleDocMgt.PostEiCardSalesOrders(recEiCardQueue."Sales Order No.", true) then
                        Qty += 1;
                until recEiCardQueue.Next() = 0;
                Message(lText002, Qty, Total);
            end;
        //<< 24-09-19 ZY-LD 005
    end;

    local procedure PostAllSalesOrders()
    var
        lText001: Label 'Do you want to post all EiCard Sales Orders?';
    begin
        //>> 24-09-19 ZY-LD 005
        if Confirm(lText001, true) then
            HqSaleDocMgt.PostEiCardSalesOrders('', false);
        //<< 24-09-19 ZY-LD 005
    end;
}
