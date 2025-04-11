report 50025 "Batch Post eCommerce Orders"
{
    // 001. 28-12-21 ZY-LD 000 - When running through the web service, the web service will stop processing after 10 min. Therefore we stop the posting after 9 min. This will not happen often.
    // 002. 17-10-22 ZY-LD 000 - 
    // 003. 15-08-23 ZY-LD 000 - Forece Creation.
    // 004. 06-09-23 ZY-LD 000 - Somehow it happens, that the document has been posted, but it gets to the error part of the code and canÂ´t find the document.
    // 005. 24-10-23 ZY-LD 000 - SaveValues must be false, otherwise will the job queue not run because SaveValues does not have any affect.

    Caption = 'Batch Post eCommerce Orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem("eCommerce Order Header"; "eCommerce Order Header")
        {
            CalcFields = "Amount Including VAT";
            DataItemTableView = sorting("eCommerce Order Id", "Invoice No.") where(Open = const(true));
            RequestFilterFields = "Order Date", "Marketplace ID", "Transaction Type", "eCommerce Order Id";
            RequestFilterHeading = 'eCommerce Order';

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("eCommerce Order Header"."eCommerce Order Id", 0, true);

                "eCommerce Order Header".ValidateDocument;
                if ("eCommerce Order Header"."Error Description" = '') OR
                   ForceCreation  // 15-08-23 ZY-LD 003
                then begin
                    if "eCommerce Order Header"."Error Description" = '' then begin
                        Clear(eCommerceOrdertoInvoice);
                        eCommerceOrdertoInvoice.InitCodeunit(ReplacePostingDate, PostingDateReq);
                        if eCommerceOrdertoInvoice.Run("eCommerce Order Header") then begin
                            eCommerceOrdertoInvoice.GetDocument(recSalesHead);
                            recSalesHead.CalcFields("Amount Including VAT");
                            if (recSalesHead."Document Type" = recSalesHead."document type"::"Credit Memo") and ("eCommerce Order Header"."Transaction Type" = "eCommerce Order Header"."transaction type"::Order) then
                                recSalesHead."Amount Including VAT" := -recSalesHead."Amount Including VAT";

                            if ZGT.IsZComCompany or (Abs("eCommerce Order Header"."Amount Including VAT" - recSalesHead."Amount Including VAT") < 1) then begin
                                Clear(SalesPost);
                                if PostSalesDoc then begin
                                    if ReplacePostingDate then begin
                                        if (ReplacePostingDate or ("Posting Date" = 0D)) then begin
                                            recSalesHead."Posting Date" := PostingDateReq;
                                            recSalesHead.Validate("Currency Code");
                                        end;

                                        if (ReplaceDocumentDate or (recSalesHead."Document Date" = 0D)) then
                                            recSalesHead.Validate("Document Date", PostingDateReq);
                                    end;

                                    if SalesPost.Run(recSalesHead) then
                                        CounterPosted["eCommerce Order Header"."Sales Document Type".AsInteger() - 1] += 1
                                    else begin
                                        //>> 27-02-23 ZY-LD 002
                                        recSalesHead.SetHideValidationDialog(true);
                                        //recSalesHead.Get(recSalesHead."Document Type", recSalesHead."No.");  // 05-04-24 ZY-LD 000 - Same line is right below.
                                        IF recSalesHead.GET(recSalesHead."Document Type", recSalesHead."No.") THEN  // 06-09-23 ZY-LD 004
                                            recSalesHead.Delete(true);
                                        recSalesHead.SetHideValidationDialog(false);
                                        //CounterCreated["Sales Document Type" - 1] += 1;
                                        //<< 27-02-23 ZY-LD 002

                                        CounterRejected += 1;
                                        "eCommerce Order Header"."Error Description" := CopyStr(GetLastErrorText, 1, MaxStrLen("eCommerce Order Header"."Error Description"));
                                        "eCommerce Order Header".Modify(true);
                                        Commit();
                                    end;
                                end else begin
                                    CounterCreated["eCommerce Order Header"."Sales Document Type".AsInteger() - 1] += 1;
                                    "eCommerce Order Header".Open := false;
                                    "eCommerce Order Header".Modify(true);
                                    Commit();
                                end;
                            end else begin
                                //>> 15-08-23 ZY-LD 003
                                IF ForceCreation THEN BEGIN
                                    "Error Description" := STRSUBSTNO(Text012, USERID);
                                    CounterCreated["Sales Document Type".AsInteger() - 1] += 1;
                                    Open := FALSE;
                                END ELSE BEGIN  //<< 15-08-23 ZY-LD 003                            
                                    "eCommerce Order Header"."Error Description" := StrSubstNo(Text010, recSalesHead."Amount Including VAT", "eCommerce Order Header"."Amount Including VAT");
                                    //>> 17-10-22 ZY-LD 002
                                    recSalesHead.SetHideValidationDialog(true);
                                    recSalesHead.Delete(true);
                                    recSalesHead.SetHideValidationDialog(false);
                                    //<< 17-10-22 ZY-LD 002

                                    CounterRejected += 1;
                                    "eCommerce Order Header".Modify(true);
                                    Commit();
                                end;

                                if "eCommerce Order Header".MarkedOnly then
                                    "eCommerce Order Header".Mark(false);
                            end;
                        end else begin
                            CounterRejected += 1;
                            "eCommerce Order Header".Modify(true);
                            Commit();
                        end;
                    end;

                    //>> 28-12-21 ZY-LD 001
                    if not GuiAllowed() then
                        if CurrentDatetime - StartTime > (1000 * 60 * 9) then
                            CurrReport.Break();
                    //<< 28-12-21 ZY-LD 001
                end;
            end;

            trigger OnPostDataItem()
            var
                MessageText: Text;
                lText001: Label '\%1 %2(s) has been created.';
                lText002: Label '\%1 %2(s) has been posted.';
                lText003: Label '\%1 document(s) has been rejected.';
                lText004: Label 'invoice';
                lText005: Label 'credit memo';
            begin
                ZGT.CloseProgressWindow;

                MessageText := StrSubstNo(Text006, CounterTotal);
                if CounterCreated[1] > 0 then
                    MessageText += StrSubstNo(lText001, CounterCreated[1], lText004);
                if CounterPosted[1] > 0 then
                    MessageText += StrSubstNo(lText002, CounterPosted[1], lText004);
                if CounterCreated[2] > 0 then
                    MessageText += StrSubstNo(lText001, CounterCreated[2], lText005);
                if CounterPosted[2] > 0 then
                    MessageText += StrSubstNo(lText002, CounterPosted[2], lText005);
                if CounterRejected <> 0 then
                    MessageText += StrSubstNo(lText003, CounterRejected);
                Message(MessageText);
            end;

            trigger OnPreDataItem()
            begin
                if ReplacePostingDate and (PostingDateReq = 0D) then
                    Error(Text000);

                //>> 15-08-23 ZY-LD 003
                IF ForceCreation AND (COUNT > 1) THEN
                    ERROR(Text011);
                //<< 15-08-23 ZY-LD 003

                CounterTotal := "eCommerce Order Header".Count();
                ZGT.OpenProgressWindow('', "eCommerce Order Header".Count());
            end;
        }
    }

    requestpage
    {
        SaveValues = false;  // 24-10-23 ZY-LD 005

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostSalesDoc; PostSalesDoc)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Sales Document';
                        trigger OnValidate()
                        begin
                            //>> 15-08-23 ZY-LD 003
                            IF PostSalesDoc THEN
                                ForceCreation := FALSE;
                            //<< 15-08-23 ZY-LD 003
                        end;
                    }
                    Field(ForceCreation; ForceCreation)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Force Creation of Sales Document';
                        trigger OnValidate()
                        begin
                            //>> 15-08-23 ZY-LD 003
                            IF ForceCreation THEN
                                PostSalesDoc := FALSE;
                            //<< 15-08-23 ZY-LD 003
                        end;
                    }
                    field(PostingDate; PostingDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                    }
                    field(ReplacePostingDate; ReplacePostingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Replace Posting Date';

                        trigger OnValidate()
                        begin
                            if ReplacePostingDate then
                                Message(Text003);
                        end;
                    }
                    field(ReplaceDocumentDate; ReplaceDocumentDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Replace Document Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ReplacePostingDate := false;
            ReplaceDocumentDate := false;
        end;
    }

    trigger OnPostReport()
    begin
        SI.SetHideSalesDialog(false);
    end;

    trigger OnPreReport()
    begin
        SI.SetHideSalesDialog(true);

        SI.UseOfReport(3, 50025, 2);  // 14-10-20 ZY-LD 000
        StartTime := CurrentDatetime;  // 28-12-21 ZY-LD 001
    end;

    var
        recSalesHead: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        eCommerceOrdertoInvoice: Codeunit "eCommerce-Order to Invoice";
        ZGT: Codeunit "ZyXEL General Tools";
        PostingDateReq: Date;
        CounterTotal: Integer;
        CounterPosted: array[2] of Integer;
        CounterCreated: array[2] of Integer;
        CounterRejected: Integer;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        PostSalesDoc: Boolean;
        ForceCreation: Boolean;  // 15-08-23 ZY-LD 003
        SI: Codeunit "Single Instance";
        StartTime: DateTime;
        Text000: Label 'Enter the posting date.';
        Text001: Label 'Posting invoices   #1########## @2@@@@@@@@@@@@@';
        Text002: Label '%1 invoices out of a total of %2 have now been posted.';
        Text003: Label 'The exchange rate associated with the new posting date on the sales header will not apply to the sales lines.';
        Text006: Label 'Out of a total of %1 documents has:';
        Text010: Label 'Amount on Sales Header %1 do not equal amount %2.';
        Text011: Label 'You can only create one document if you force the creation.';
        Text012: Label 'Creation of sales document was forced by %1.';

    procedure InitReport(NewPostSalesDoc: Boolean; NewPostingDate: Date; NewReplacePostingDate: Boolean; NewReplaceDocumentDate: Boolean)
    begin
        PostSalesDoc := NewPostSalesDoc;
        PostingDateReq := NewPostingDate;
        ReplacePostingDate := NewReplacePostingDate;
        ReplaceDocumentDate := NewReplaceDocumentDate;
    end;
}
