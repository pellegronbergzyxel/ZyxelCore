pageextension 50160 PostedSalesCreditMemosZX extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("No.")
        {
            field("Pre-Assigned No."; Rec."Pre-Assigned No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'eCommerce No.';
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field(ExternalDocumentSL; ExternalDocumentSL)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'External Document No. 2';
                ToolTip = 'External Document No. 2 comes from the sales invoice line';
                Visible = false;
            }
        }
        addafter("Amount Including VAT")
        {
            field(VATAmount; VATAmount)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT Amount';
                DecimalPlaces = 2 : 2;
            }
        }
        addafter("Sell-to Post Code")
        {
            field("Intercompany Purchase"; Rec."Intercompany Purchase")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Document Exchange Status")
        {
            field(ICInfoPurch; ICInfoPurch)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase IC Invoice No.';
            }
            field(PostingDateInDifferentMonth; PostingDateInDifferentMonth)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted in Different Months';
            }
            field(ICInfoSale; ICInfoSale)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales IC Invoice No.';
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Company VAT Registration Code"; Rec."Company VAT Registration Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                Editable = false;
            }
            field("Send Mail"; Rec."Send Mail")
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
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Return Reason Code"; Rec."Return Reason Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addlast(Control1)
        {
            field("RHQ Credit Memo No"; Rec."RHQ Credit Memo No")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("NL to DK Rev. Charge Posted"; Rec."NL to DK Rev. Charge Posted")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }

            field("Order Desk Resposible Code"; Rec."Order Desk Resposible Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        addafter(ActivityLog)
        {
            group(Zyxel)
            {
                Caption = 'Zyxel';
                action("Create IC Outbox Transaction")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create IC Outbox Transaction';
                    Image = CreateCreditMemo;

                    trigger OnAction()
                    begin
                        CreateOutboxOnSalesCrMemo;  // 18-10-19 ZY-LD 001
                    end;
                }
                action("Search On External Document No")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Search On External Document No';
                    Image = Find;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SearchOnExtDocNo;
                    end;
                }
                action("Reverse value of Send Mail")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reverse value of "Send Mail"';
                    Image = ReverseLines;

                    trigger OnAction()
                    begin
                        //ReverseValueOfSendMail;  // 25-09-19 ZY-LD 008
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 20-10-17 ZY-LD 002
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CALCFIELDS("Amount Including VAT", Amount);
        VATAmount := Rec."Amount Including VAT" - Rec.Amount;
        ExternalDocumentSL := SalesHeaderLineEvent.GetExternalDocNoFromSalesCrMemoLine(Rec."No.");  // 21-09-18 ZY-LD 005
    end;

    var
        VATAmount: Decimal;
        ICInfoSale: Code[50];
        ICInfoPurch: Code[50];
        PostingDateInDifferentMonth: Boolean;
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        SalesHeaderLineEvent: Codeunit "Sales Header/Line Events";
        ExternalDocumentSL: Text;

    local procedure CreateOutboxOnSalesCrMemo()
    var
        lSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        lHandledICOutboxTrans: Record "Handled IC Outbox Trans.";
        lICOutboxTransaction: Record "IC Outbox Transaction";
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        lText001: Label 'Do you want to create an outbox transaction on %1 invoices?';
        lText002: Label '%1 created in %2.\%3 rejected. Look in %2.';
        QtyRejected: Integer;
        QtyCreated: Integer;
        TransactionNo: Integer;
    begin
        //>> 18-10-19 ZY-LD 001
        CurrPage.SetSelectionFilter(lSalesCrMemoHeader);
        if Confirm(lText001, false, lSalesCrMemoHeader.Count()) then begin
            lSalesCrMemoHeader.FindSet();
            repeat
                lICOutboxTransaction.SetRange("Document Type", lICOutboxTransaction."document type"::"Credit Memo");
                lICOutboxTransaction.SetRange("Document No.", lSalesCrMemoHeader."No.");
                lHandledICOutboxTrans.SetRange("Document Type", lHandledICOutboxTrans."document type"::"Credit Memo");
                lHandledICOutboxTrans.SetRange("Document No.", lSalesCrMemoHeader."No.");
                if lICOutboxTransaction.FindFirst() or lHandledICOutboxTrans.FindFirst() then begin
                    QtyRejected += 1;
                    if lICOutboxTransaction."Transaction No." <> 0 then
                        TransactionNo := lICOutboxTransaction."Transaction No."
                    else
                        TransactionNo := lHandledICOutboxTrans."Transaction No.";
                end else begin
                    ICInboxOutboxMgt.CreateOutboxSalesCrMemoTrans(lSalesCrMemoHeader);
                    QtyCreated += 1;
                end;
            until lSalesCrMemoHeader.Next() = 0;
            Message(lText002, QtyCreated, lHandledICOutboxTrans.TableCaption(), QtyRejected, lICOutboxTransaction.FieldCaption("Transaction No."), TransactionNo);
        end;
        //<< 18-10-19 ZY-LD 001
    end;

    local procedure ShowInterCompanyInfo()
    var
        lBillToCust: Record Customer;
        lICPartner: Record "IC Partner";
        lSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        lPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        lText001: Label 'EXPECTED';
        lText002: Label 'CREDITED';
        lHandledICOutboxTrans: Record "Handled IC Outbox Trans.";
        lHandledICInboxTrans: Record "Handled IC Inbox Trans.";
        lCustLedgEntry: Record "Cust. Ledger Entry";
        lAppCustLedgEntry: Record "Cust. Ledger Entry";
        lDetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        lText003: Label 'DELETED';
    begin
        //>> 01-11-17 ZY-LD 003
        ICInfoSale := '';
        ICInfoPurch := '';
        PostingDateInDifferentMonth := false;
        if lBillToCust.Get(Rec."Bill-to Customer No.") then begin
            if lBillToCust."IC Partner Code" <> '' then
                if lICPartner.Get(lBillToCust."IC Partner Code") and (lICPartner."Inbox Type" = lICPartner."inbox type"::Database) then begin
                    if Rec.Amount <> 0 then begin
                        if lSalesCrMemoHeader.ChangeCompany(lICPartner."Inbox Details") then
                            if lSalesCrMemoHeader.ReadPermission then begin  // 26-04-22 ZY-LD 007
                                lSalesCrMemoHeader.SetRange("External Document No.", Rec."No.");
                                if lSalesCrMemoHeader.FindFirst() then
                                    ICInfoSale := lSalesCrMemoHeader."No."
                                else begin
                                    lCustLedgEntry.SetRange("Customer No.", lBillToCust."No.");
                                    lCustLedgEntry.SetRange("Document Type", lCustLedgEntry."document type"::"Credit Memo");
                                    lCustLedgEntry.SetRange("Document No.", Rec."No.");
                                    if lCustLedgEntry.FindFirst() then begin
                                        lAppCustLedgEntry.SetCurrentkey("Closed by Entry No.");
                                        lAppCustLedgEntry.SetRange("Closed by Entry No.", lCustLedgEntry."Entry No.");
                                        if lAppCustLedgEntry.FindFirst() then begin
                                            ICInfoSale := lText002;
                                            ICInfoPurch := ICInfoSale;
                                        end else begin
                                            lDetCustLedgEntry.SetRange("Cust. Ledger Entry No.", lCustLedgEntry."Entry No.");
                                            lDetCustLedgEntry.SetRange("Entry Type", lDetCustLedgEntry."entry type"::Application);
                                            if lDetCustLedgEntry.FindFirst() then begin
                                                if lAppCustLedgEntry.Get(lDetCustLedgEntry."Applied Cust. Ledger Entry No.") and
                                                    (lAppCustLedgEntry."Document Type" = lAppCustLedgEntry."document type"::Invoice)
                                                then begin
                                                    ICInfoSale := lText002;
                                                    ICInfoPurch := ICInfoSale;
                                                end;

                                                if ICInfoSale = '' then begin
                                                    lHandledICInboxTrans.ChangeCompany(lICPartner."Inbox Details");
                                                    lHandledICInboxTrans.SetRange("Source Type", lHandledICInboxTrans."source type"::"Purchase Document");
                                                    lHandledICInboxTrans.SetRange("Document Type", lHandledICInboxTrans."document type"::"Credit Memo");
                                                    lHandledICInboxTrans.SetRange("Document No.", Rec."No.");
                                                    if lHandledICInboxTrans.FindFirst() then begin
                                                        ICInfoSale := 'IC: ' + Format(lHandledICInboxTrans.Status) + ' ' + lICPartner."Inbox Details";
                                                        ICInfoPurch := ICInfoSale;
                                                    end else begin
                                                        lHandledICOutboxTrans.SetRange("Source Type", lHandledICOutboxTrans."source type"::"Sales Document");
                                                        lHandledICOutboxTrans.SetRange("Document Type", lHandledICOutboxTrans."document type"::"Credit Memo");
                                                        lHandledICOutboxTrans.SetRange("Document No.", Rec."No.");
                                                        if lHandledICOutboxTrans.FindFirst() then begin
                                                            ICInfoSale := 'IC: ' + Format(lHandledICOutboxTrans.Status) + ' ' + CompanyName();
                                                            ICInfoPurch := ICInfoSale
                                                        end;
                                                    end;
                                                end else
                                                    ICInfoSale := lText001;
                                            end else
                                                ICInfoSale := lText001;
                                        end;
                                    end else
                                        ICInfoSale := lText001;
                                end;

                                if ICInfoPurch = '' then begin
                                    lPurchCrMemoHdr.ChangeCompany(lICPartner."Inbox Details");
                                    if lPurchCrMemoHdr.ReadPermission then begin  // 26-04-22 ZY-LD 007
                                        lPurchCrMemoHdr.SetRange("Vendor Cr. Memo No.", Rec."No.");
                                        if lPurchCrMemoHdr.FindFirst() then begin
                                            ICInfoPurch += lPurchCrMemoHdr."No.";
                                            if Date2dmy(Rec."Posting Date", 2) <> Date2dmy(lPurchCrMemoHdr."Posting Date", 2) then
                                                PostingDateInDifferentMonth := true;
                                        end else
                                            ICInfoPurch := lText001;
                                    end;
                                end;
                            end;
                    end else begin
                        ICInfoSale := lText003;
                        ICInfoPurch := lText003;
                    end;
                end;
        end;
        //<< 01-11-17 ZY-LD 003
    end;

    local procedure SearchOnExtDocNo()
    var
        lSaleInvHead: Record "Sales Invoice Header";
        lSaleInvHeadTmp: Record "Sales Invoice Header" temporary;
        lSaleInvLine: Record "Sales Invoice Line";
        lSaleCrMemoHead: Record "Sales Cr.Memo Header";
        lSaleCrMemoHeadTmp: Record "Sales Cr.Memo Header" temporary;
        lSaleCrMemoLine: Record "Sales Cr.Memo Line";
        GenericInputPage: Page "Generic Input Page";
        lText001: Label 'Search for External Document No.';
        lText002: Label 'Search String';
        FilterStr: Text;
    begin
        //>> 20-12-17 ZY-LD 002
        GenericInputPage.SetPageCaption(lText001);
        GenericInputPage.SetFieldCaption(lText002);
        GenericInputPage.SetVisibleField(0);  // Text
        if GenericInputPage.RunModal = Action::OK then begin
            FilterStr := StrSubstNo('*%1*', UpperCase(GenericInputPage.GetText));

            lSaleInvLine.SetCurrentkey("External Document No.");
            lSaleInvLine.SetFilter("External Document No.", FilterStr);
            if lSaleInvLine.FindSet() then begin
                ZGT.OpenProgressWindow('', lSaleInvLine.Count());
                repeat
                    ZGT.UpdateProgressWindow(lSaleInvLine."Document No.", 0, true);
                    lSaleInvHead.Get(lSaleInvLine."Document No.");
                    lSaleInvHeadTmp := lSaleInvHead;
                    if not lSaleInvHeadTmp.Insert() then;
                until lSaleInvLine.Next() = 0;
                ZGT.CloseProgressWindow;
            end;

            lSaleCrMemoLine.SetCurrentkey("External Document No.");
            lSaleCrMemoLine.SetFilter("External Document No.", FilterStr);
            if lSaleCrMemoLine.FindSet() then begin
                ZGT.OpenProgressWindow('', lSaleCrMemoLine.Count());
                repeat
                    ZGT.UpdateProgressWindow(lSaleCrMemoLine."Document No.", 0, true);
                    lSaleCrMemoHead.Get(lSaleCrMemoLine."Document No.");
                    lSaleCrMemoHeadTmp := lSaleCrMemoHead;
                    if not lSaleCrMemoHeadTmp.Insert() then;
                until lSaleCrMemoLine.Next() = 0;
                ZGT.CloseProgressWindow;
            end;

            if not lSaleInvHeadTmp.IsEmpty() then
                Page.RunModal(Page::"Posted Sales Invoices", lSaleInvHeadTmp);

            if not lSaleCrMemoHeadTmp.IsEmpty() then
                Page.RunModal(Page::"Posted Sales Credit Memos", lSaleCrMemoHeadTmp);
        end;
        //<< 20-12-17 ZY-LD 002
    end;

    local procedure ReverseValueOfSendMail()
    var
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
        lText001: Label 'Do you want to reverse "%1" on %2 invoices?';
    begin
        //>> 25-09-19 ZY-LD 008
        CurrPage.SetSelectionFilter(recSalesCrMemoHead);
        recSalesCrMemoHead.SetRange("No. Printed", 0);
        if Confirm(lText001, true, Rec.FieldCaption(Rec."Send Mail"), recSalesCrMemoHead.Count()) then
            if recSalesCrMemoHead.FindSet(true) then
                repeat
                    recSalesCrMemoHead."Send Mail" := not recSalesCrMemoHead."Send Mail";
                    recSalesCrMemoHead.Modify(true);
                until recSalesCrMemoHead.Next() = 0;
        //<< 25-09-19 ZY-LD 008
    end;
}
