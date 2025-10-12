pageextension 50132 PurchaseOrderZX extends "Purchase Order"
{
    layout
    {
        modify(Status)
        {
            trigger OnAfterValidate()
            begin
                SetButtons();
            end;
        }

        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                IsGroupedPurchaseLinesEditable := Rec.PurchaseLinesEditable();
            end;
        }
        addafter("No. of Archived Versions")
        {
            field(IsEICard; Rec.IsEICard)
            {
                Editable = false;

                trigger OnValidate()
                begin
                    EnableEiCards(Rec.IsEICard);
                    SetButtons();
                end;
            }
            field("Shipping Request Notes"; Rec."Shipping Request Notes")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Quote No.")
        {
            field(LocationCode2; Rec."Location Code")
            {
                ApplicationArea = Basic, Suite;
                Importance = Promoted;
            }
        }
        addafter(Status)
        {
            field(EShopOrderSent2; Rec."EShop Order Sent")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sent to EShop';
                Editable = false;
            }
            field("FTP Code"; Rec."FTP Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Create User ID"; Rec."Create User ID")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(PurchLines)
        {
            part(GroupedPurchLines; "Purchase Order Subform")
            {
                Visible = false;  // 05-02-24 ZY-LD - Can be removed when we go live.
                ApplicationArea = Basic, Suite;
                Caption = 'Lines (Grouped)';
                Editable = IsGroupedPurchaseLinesEditable;
                Enabled = IsGroupedPurchaseLinesEditable;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }

        }
        addafter("VAT Bus. Posting Group")
        {
            field("Post Order Without HQ Document"; Rec."Post Order Without HQ Document")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Ship-to Contact")
        {
            field("Ship-from Country/Region Code"; Rec."Ship-from Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Normally "Buy-from Country/Region Code" is used on the "Item Ledger Entries", but on Intercompany Transactions it will give us a wrong "Country/Region Code". This field is therefore filled with the "Country/Region Code" from the "Location Code" on Intercompany Transactions.\Beside that you use the field for normal vendors, if they ship from another country than the "Buy-from Country/Region Code" country.';
            }
            field("Sent to HQ"; Rec."Sent to HQ")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Do not send to HQ';
            }
            field("Completely Received"; Rec."Completely Received")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Inbound Whse. Handling Time")
        {
            field("Transport Method 2"; Rec."Transport Method")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Expected Receipt Date")
        {
            field("Requested Date From Factory"; Rec."Requested Date From Factory")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Prepayment)
        {
            group(EiCards)
            {
                Caption = 'EiCards';
                group("Order Details")
                {
                    Caption = 'Order Details';
                    field("Dist. PO#"; Rec."Dist. Purch. Order No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Enabled = EIFieldsEnable;
                    }
                    field("Dist. E-mail"; Rec."Dist. E-mail")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("EShop Information")
                {
                    Caption = 'EShop Information';
                    field("EShop Order Sent"; Rec."EShop Order Sent")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sent to EShop';
                        Enabled = not EIFieldsEnable;
                    }
                    field("EShop Message"; Rec."EShop Message")
                    {
                        ApplicationArea = Basic, Suite;
                        Enabled = not EIFieldsEnable;
                    }
                }
            }
            group("Warehouse Status Log")
            {
                Caption = 'Warehouse Status Log';
                part(Control118; "Warehouse Indbound FactBox")
                {
                    SubPageLink = "No. Series" = field("No.");
                }
            }
        }
        addfirst(FactBoxes)
        {
            part(Control165; "Item Warehouse FactBox")
            {
                Provider = PurchLines;
                SubPageLink = "No." = field("No."),
                              "Location Filter" = field("Location Code");
            }
            part(Control166; "Goods in Transit FactBox")
            {
                Provider = PurchLines;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
                Visible = ShowGITFactBox;
            }
            part(Control167; "Container Details FactBox")
            {
                Provider = PurchLines;
                SubPageLink = "Purchase Order No." = field("Document No."),
                              "Purchase Order Line No." = field("Line No."),
                              Archive = const(false);
                Visible = ShowGITFactBox;
            }
            part(Control265; "Item Warehouse FactBox")
            {
                Caption = 'Item Details - Warehouse (Grouped)';
                Provider = GroupedPurchLines;
                SubPageLink = "No." = field("No."),
                              "Location Filter" = field("Location Code");
            }
            part(Control266; "Goods in Transit FactBox")
            {
                Caption = 'Goods in Transit Details (Grouped)';
                Provider = GroupedPurchLines;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
                Visible = ShowGITFactBox;
            }
            part(Control267; "Container Details FactBox")
            {
                Caption = 'Goods in Transit Details (Grouped)';
                Provider = GroupedPurchLines;
                SubPageLink = "Purchase Order No." = field("Document No."),
                              "Purchase Order Line No." = field("Line No."),
                              Archive = const(false);
                Visible = ShowGITFactBox;
            }
            part(ItemCommentFactBox; "Item Comment FactBox")
            {
                ApplicationArea = All;
                Caption = 'Item Comment';
                Visible = false;
                SubPageLink = "Table Name" = const(Item),
                              "No." = field("No.");
                Provider = PurchLines;
            }

        }
        addafter(Control3)
        {
            part(Control168; "Item Warehouse FactBox")
            {
                Provider = PurchLines;
                SubPageLink = "No." = field("No.");
            }
            part(Control268; "Item Warehouse FactBox")
            {
                Caption = 'Item Details - Warehouse (Grouped)';
                Provider = GroupedPurchLines;
                SubPageLink = "No." = field("No.");
            }
        }
        moveafter("No. of Archived Versions"; "Payment Reference")
    }

    actions
    {
        modify(Post)
        {
            Enabled = PostButtonsEnabled;
        }
        modify(PostAndNew)
        {
            Enabled = PostButtonsEnabled;
        }
        modify("Post and &Print")
        {
            Enabled = PostButtonsEnabled;
        }
        modify("Post &Batch")
        {
            Enabled = PostButtonsEnabled;
        }
        addafter(IncomingDocument)
        {
            group("ZyXEL Functions")
            {
                Caption = 'ZyXEL Functions';
                Image = Documents;
                action(ShippingDetail)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Shipping Detail';

                    trigger OnAction()
                    var
                        recShippingDetail: Record "VCK Shipping Detail";
                        frmShippingDetail: Page "VCK Shipping Detail";
                    begin
                        recShippingDetail.SetFilter("Purchase Order No.", Rec."No.");
                        if not recShippingDetail.FindFirst() then begin
                            Message(Text009);
                            exit;
                        end;
                        frmShippingDetail.SetFilter(Rec."No.");
                        frmShippingDetail.RunModal;
                    end;
                }
                action(ResendShopOrder)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re-send EShop Order';

                    trigger OnAction()
                    var
                        Release: Codeunit "Release Purchase Document";
                        lText001: Label 'This order will be re-sent to EShop.\Are you sure you want to continue?';
                    begin
                        //>> 26-03-24 ZY-LD 000
                        //if not AllIn.CheckTransportType(Rec."No.") then
                        //    Error(Text008);
                        //<< 26-03-24 ZY-LD 000
                        AllIn.CheckTransportType(Rec);
                        if not AllIn.CheckRequestedDate(Rec."No.") then
                            Error(Text007);
                        if AllIn.CheckRequestedDate(Rec."No.") then
                            if Confirm(lText001) then begin
                                Rec."EShop Order Sent" := false;  // 26-02-21 ZY-LD 012
                                Rec.Modify();  // 26-02-21 ZY-LD 012

                                AllIn.SendToHQ(Rec."No.", true);
                            end;
                    end;
                }
                action("Send ZBO")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send ZBO';

                    trigger OnAction()
                    begin
                        SendZBO;
                    end;
                }
            }
        }
        addafter(Receipts)
        {
            Action(receiptlines)
            {
                Caption = 'Receipt lines';
                image = ReceiptLines;
                RunObject = page "Posted Purchase Receipt Lines";
                RunPageLink = "Order No." = FIELD("No.");
                Promoted = true;
                PromotedCategory = Category8;

            }
        }
        addlast("F&unctions")
        {
            group(Correction)
            {
                Caption = 'Correction';
                action(QTYError)
                {
                    Caption = 'QTY Base error correction';
                    ApplicationArea = all;
                    Image = Warning;
                    trigger OnAction()
                    var
                        tempcorrection: codeunit TempCorrection;
                    begin
                        if confirm('Do want to check and correct qty<>qty (base) for this PI and posted ledgers') then begin
                            tempcorrection.CorPIfromPH(rec);
                            CurrPage.Update(false);
                        end
                    end;
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        IsGroupedPurchaseLinesEditable := Rec.PurchaseLinesEditable();
        CurrPage.GroupedPurchLines.Page.SetIsGroupedLines();
    end;

    trigger OnAfterGetRecord()
    begin
        EnableEiCards(Rec.IsEICard);
        SetButtons();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetButtons();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SetButtons();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        SetButtons();
    end;

    trigger OnAfterGetCurrRecord()
    var
        CurrentGroupedLinesPageActive: Boolean;
    begin
        EnableEiCards(Rec.IsEICard);
        SetButtons();
        IsGroupedPurchaseLinesEditable := Rec.PurchaseLinesEditable();
        CurrPage.GroupedPurchLines.Page.SetupGroupedLines(Rec."No.");
        SetActions();
    end;

    var
        ServEnviron: Record "Server Environment";
        PostCheckForPO: Codeunit "Check Vendor Invoice No";
        AllIn: Codeunit "ZyXEL VCK";
        ZGT: Codeunit "ZyXEL General Tools";
        VckXmlMgt: Codeunit "VCK Communication Management";
        [InDataSet]
        EIFieldsEnable: Boolean;
        [InDataSet]
        ResendEshopVisible: Boolean;
        [InDataSet]
        IsGroupedPurchaseLinesEditable: Boolean;
        SendToHqVisible: Boolean;
        ShowGITFactBox: Boolean;
        PostButtonsEnabled: Boolean;
        Text003: Label 'The Purchase Order has no associated HQ invoices yet. Please try again later.';
        Text004: Label 'No Lines could be matched with the associated HQ Invoice.';
        Text005: Label 'The Purchase Order lines have been partialy matched.';
        Text006: Label 'The Purchase Order Lines have been completley matched. This Purchase Order Can now be posted.';
        Text007: Label 'The Purchase Order Cannot be sent to EShop because not all lines have an Expected from Factory Date.';
        Text008: Label 'The Purchase Order Cannot be sent to EShop because a Transport Method has not been set.';
        Text009: Label 'No Shipping Detail is available for this Purchase Order yet.';
        Text010: Label 'Are you sure that you want to resend %1 to VCK?';
        Text011: Label '%1 has been resent to VCK.';
        Text012: Label 'It was not possible to send %1.';

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

        /* Redundant code
        CurrForm."Dist. PO#".ENABLED := Enable;
        CurrForm."EiCard Distributor Reference".ENABLED := Enable;
        CurrForm."EiCard Send HTML Email".ENABLED := Enable;
        CurrForm."From User".ENABLED := Enable;
        CurrForm."From E-Mail Address".ENABLED := Enable;
        CurrForm."From E-Mail Signature".ENABLED := Enable;
        CurrForm."EiCard Email Subject".ENABLED := Enable;
        CurrForm."EiCard To Email".ENABLED := Enable;
        CurrForm."EiCard To Email 1".ENABLED := Enable;
        CurrForm."EiCard To Email 2".ENABLED := Enable;
        CurrForm."EiCard To Email 3".ENABLED := Enable;
        CurrForm."EiCard To Email 4".ENABLED := Enable;
        CurrForm."EiCard To Email 5".ENABLED := Enable;
        CurrForm."EiCard Additional Information".ENABLED := Enable;
        CurrForm."EiCard Additional Information1".ENABLED := Enable;
        CurrForm."EiCard Status".ENABLED := Enable;
        CurrForm."Vendor Status".VISIBLE := NOT Enable;
        CurrForm."Warehouse Status".VISIBLE := NOT Enable;
        CurrForm."EShop Order Sent".ENABLED := NOT Enable;
        CurrForm."EShop Message".ENABLED := NOT Enable;
        */
    end;

    procedure FindRec(OrderNo: Code[20])
    begin
        Rec.SetFilter("No.", OrderNo);
    end;

    procedure SetButtons()
    var
        recSetup: Record "Purchases & Payables Setup";
        CanShow: Boolean;
        VendorNo: Code[20];
    begin
        if recSetup.FindFirst() then begin
            VendorNo := recSetup."EShop Vendor No.";
        end;
        if Rec.Status = Rec.Status::Open then begin
            if Rec.IsEICard = false then begin
                if Rec."EShop Order Sent" = true then begin
                    if Rec."Buy-from Vendor No." = VendorNo then
                        CanShow := true
                end;
            end;
        end;
        ResendEshopVisible := CanShow;

        SendToHqVisible := ServEnviron.TestEnvironment;  // 28-09-18 ZY-LD 005
        ShowGITFactBox := not ZGT.IsEicard(Rec."Location Code");  // 14-01-19 ZY-LD 006
    end;

    local procedure SetActions()
    var
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
    begin
        PostButtonsEnabled := SalesHeadEvent.HidePostButtons(Rec."Location Code", '');  // 13-03-19 ZY-LD 007
    end;

    local procedure SendZBO()
    var
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        lText001: Label 'Do you want to send order no. %1 to "%2"?';
    begin
        if Confirm(lText001, false, Rec."No.", Rec."Buy-from Vendor Name") then
            if ZyWebServMgt.SendSalesOrderFrance(Rec."No.") then begin
                // Update sent here.
                Rec.Modify();
                Message('Order has been sent.');
            end;
    end;
}
