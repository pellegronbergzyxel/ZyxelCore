page 50258 "eCommerce Payment Journal"
{
    Caption = 'eCommerce Payment Journal';
    CardPageID = "eCommerce Payment Card";
    DataCaptionFields = "Journal Batch No.", "Transaction Summary";
    Description = 'eCommerce Payments List';
    PageType = Worksheet;
    PromotedActionCategories = 'New_caption,Process_caption,Reports_caption,Fees And Charges,Setup,Catrgory6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = "eCommerce Payment";
    SourceTableView = sorting("Journal Batch No.", "Line No.");

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Group)
            {
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                }
                field("Payment is Posted"; Rec."Payment is Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                }
                field("eCommerce Market Place"; Rec."eCommerce Market Place")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Order ID"; Rec."Order ID")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'eCommerce Order No.';
                }
                field("eCommerce Invoice No."; Rec."eCommerce Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'eCommerce Invoice No.';
                }
                field("Sales Document No."; Rec."Sales Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source Invoice No."; Rec."Source Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sales Credit No."; Rec."Sales Credit No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Purchase Invoice No."; Rec."Purchase Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Fee Purchase Invoice No."; Rec."Fee Purchase Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Fee Purchase Invoice No.';
                    Visible = false;
                }
                field("New Transaction Type"; Rec."New Transaction Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount Description"; Rec."Amount Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Detail Text"; Rec."Payment Detail Text")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship To Country"; Rec."Ship To Country")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Product Title"; Rec."Product Title")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Description';
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Currency Code"; Rec."Posting Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Amount Posting Type"; Rec."Amount Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transaction Summary"; Rec."Transaction Summary")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Journal Line Created"; Rec."Journal Line Created")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Journal Line Posted"; Rec."Journal Line Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Total Line Payment"; Rec."Total Line Payment")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Payment Statement Type"; Rec."Payment Statement Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Payment Statement Description"; Rec."Payment Statement Description")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Payment Detail"; Rec."Payment Detail")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shipment ID"; Rec."Shipment ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
            group(Control18)
            {
                ShowCaption = false;
                group(Control9)
                {
                    ShowCaption = false;
                    field(TotalBalance; TotalBalance)
                    {
                        ApplicationArea = Basic, Suite;
                        AutoFormatType = 1;
                        Caption = 'Total Balance';
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            Action("Process Fees and Charges")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Process Fees and Charges';
                Description = 'Process Fees and Charges';
                Image = Process;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Process Fees and Charges';

                trigger OnAction()
                var
                    eCommercePaymenttoJournal: Codeunit "eCommerce-Payment to Journal";
                begin
                    eCommercePaymenttoJournal.RunWithConfirm(Rec);
                    CurrPage.Update();
                end;
            }
            Action("Payments Matrix List")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payments Matrix List';
                Description = 'Payments Matrix List';
                Ellipsis = true;
                Image = ProdBOMMatrixPerVersion;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "eCommerce Payments Matrix List";
                ToolTip = 'Payments Matrix List';
                Visible = false;
            }
            Action(eCommerceTransactionSummary)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce Transaction Summary';
                Description = 'eCommerce Transaction Summary';
                Image = Transactions;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page "eCommerce Transaction Summary";
                ToolTip = 'eCommerce Transaction Summary';
                Visible = false;
            }
            Action(Reopen)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reopen';
                Image = ReOpen;
                Visible = false;

                trigger OnAction()
                var
                    eCommercePayments: Record "eCommerce Payment";
                begin
                    ReOpenEntries;
                end;
            }
            Action("Close Entry")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Close Entry';
                Image = Close;
                Visible = false;

                trigger OnAction()
                begin
                    CloseEntry;
                end;
            }
            Action("Cash Receipt Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Receipt Journal';
                Image = CashReceiptJournal;
                RunObject = Page "Cash Receipt Journal";
            }
            Action("eCommerce Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce Orders';
                Image = OrderList;

                trigger OnAction()
                begin
                    ShoweCommerceOrders;
                end;
            }
        }
        area(navigation)
        {
            Action("Payment Matrix")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment Matrix';
                Image = ShowMatrix;
                RunObject = Page "eCommerce Pay. Matrix List";
            }
            Action("eCommerce Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce Order';
                Image = Document;
                RunObject = Page "eCommerce Order Archive List";
                RunPageLink = "eCommerce Order Id" = field("Order ID");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateBalance;
    end;

    trigger OnOpenPage()
    begin
        //CurrentJnlBatchName := "Journal Batch No.";
    end;

    var
        Text0001: Label 'Setting selection to Open.\';
        Text0002: Label 'Are you sure that you want to change the selection to Open?';
        Text0003: Label 'Setting selection to Closed.\';
        Text0004: Label 'Are you sure that you want to change the selection to Closed?';
        Err0001: Label 'The Company does not exist in the eCommerce Setup.';
        Err0002: Label 'The Company is not Active in the eCommerce Setup.';
        Err0003: Label 'The eCommerce Setup is not complete.';
        ChargeAccount: Code[20];
        FeeAccount: Code[20];
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        CurrencyCode: Code[20];
        Vendor: Code[20];
        PostingCompanyName: Code[20];
        Err0004: Label 'General Journal Batch %1 Cannot be found.';
        GenJnlManagement: Codeunit GenJnlManagement;
        Text0005: Label 'Are you sure that you want to delete all the eCommerce Journal Lines?';
        Text0006: Label 'Deleting eCommerce Journal Lines.\';
        eCommerceUpdatePayments: Codeunit "eCommerce Update Payments";
        ZGT: Codeunit "ZyXEL General Tools";
        CurrentJnlBatchName: Code[100];
        TotalBalance: Decimal;

    procedure Init(NewCurrentJnlBatchName: Code[20])
    begin
        CurrentJnlBatchName := NewCurrentJnlBatchName;
    end;

    local procedure ReOpenEntries()
    var
        leCommercePayments: Record "eCommerce Payment";
        lText001: Label 'Do you want to open "%1"?';
        leCommerceTransactionSummary: Record "eCommerce Transaction Summary";
    begin
        leCommercePayments.SetRange("Journal Batch No.", Rec."Journal Batch No.");
        if Confirm(lText001, false, Rec."Journal Batch No.") then begin
            leCommercePayments.ModifyAll(Open, true);
            if leCommerceTransactionSummary.Get(Rec."Transaction Summary") then begin
                leCommerceTransactionSummary.Open := true;
                leCommerceTransactionSummary.Modify();
            end;
            CurrPage.Update();
        end;
    end;

    local procedure CloseEntry()
    var
        lText001: Label 'Do you want to close entry?';
    begin
        if Rec.Open then
            if Confirm(lText001) then begin
                Rec.Open := false;
                Rec.Modify();
                CurrPage.Update();
            end;
    end;

    local procedure ShoweCommerceOrders()
    var
        receCommerceSalesHead: Record "eCommerce Order Header";
    begin
        if ZGT.IsUK then
            receCommerceSalesHead.ChangeCompany(ZGT.GetRHQCompanyName);
        receCommerceSalesHead.SetRange("eCommerce Order Id", Rec."Order ID");
        Page.RunModal(Page::"eCommerce Orders", receCommerceSalesHead);
    end;

    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var recAmzPayJnl: Record "eCommerce Payment")
    begin
        recAmzPayJnl.FilterGroup := 2;
        recAmzPayJnl.SetRange("Transaction Summary", CurrentJnlBatchName);
        recAmzPayJnl.FilterGroup := 0;
    end;

    procedure CheckName(CurrentJnlBatchName: Code[10]; var recAmzPayJnl: Record "eCommerce Payment")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        recAmzPayBatch: Record "eCommerce Payment Header";
    begin
        recAmzPayBatch.Get(recAmzPayJnl.GetRangeMax("Journal Batch No."), CurrentJnlBatchName);
    end;

    procedure SetName(CurrentJnlBatchName: Code[10]; var recAmzPayJnl: Record "eCommerce Payment")
    begin
        recAmzPayJnl.FilterGroup := 2;
        recAmzPayJnl.SetRange("Journal Batch No.", CurrentJnlBatchName);
        recAmzPayJnl.FilterGroup := 0;
        if recAmzPayJnl.FindFirst() then;
    end;

    procedure LookupName(var CurrentJnlBatchName: Code[10]; var recAmzPayJnl: Record "eCommerce Payment")
    var
        recAmzPayBatch: Record "eCommerce Payment Header";
    begin
        Commit();
        recAmzPayBatch."No." := recAmzPayJnl.GetRangeMax("Journal Batch No.");
        recAmzPayBatch.FilterGroup(2);
        recAmzPayBatch.SetRange("No.", recAmzPayBatch."No.");
        recAmzPayBatch.FilterGroup(0);
        if Page.RunModal(0, recAmzPayBatch) = Action::LookupOK then begin
            CurrentJnlBatchName := recAmzPayBatch."No.";
            SetName(CurrentJnlBatchName, recAmzPayJnl);
        end;
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure UpdateBalance()
    var
        recAmzPayBatch: Record "eCommerce Payment Header";
    begin
        recAmzPayBatch.SetAutoCalcFields("Line Amount");
        //recAmzPayBatch.GET(CurrentJnlBatchName);
        TotalBalance := recAmzPayBatch."Line Amount";
    end;
}
