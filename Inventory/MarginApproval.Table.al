table 50071 "Margin Approval"
{
    //30-10-2025 BK #MarginApproval          
    Caption = 'Margin Approval';
    DataClassification = ToBeClassified;
    Permissions = tabledata "Margin Approval" = rmd;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Source Type"; Enum "Margin Approval Type")
        {
            Caption = 'Source Type';
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            // TableRelation = if ("Source Type" = const("Price Book")) "Price List Line" else
            // if ("Source Type" = const("Sales Order")) "Sales Header" where("Document Type" = const(Order)) else
            // if ("Source Type" = const("Sales Invoice")) "Sales Header" where("Document Type" = const(Invoice));
        }
        field(4; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "Waiting for Margin Approval","Waiting for User Comment","Waiting for Approval",Approved,Rejected;
            OptionCaption = 'Waiting for Margin Approval,Waiting for User Comment,Waiting for Approval,Approved,Rejected';
            trigger OnValidate()
            var
                MarginApp: Record "Margin Approval";
            begin
                "Status Date" := CurrentDateTime();

                if Status = Status::Approved then begin
                    MarginApp.SetRange("Approved by Entry No.", "Entry No.");
                    if MarginApp.FindSet() then
                        repeat
                            MarginApp.Status := Status;
                            MarginApp."Status Date" := "Status Date";
                            MarginApp."Below Margin" := "Below Margin";
                            MarginApp."Approved/Rejected by" := "Approved/Rejected by";
                        until MarginApp.Next() = 0;
                end
            end;
        }
        field(6; "User Name"; Code[50])
        {
            Caption = 'User Name';
        }
        field(7; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(8; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(9; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(10; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(11; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            BlankZero = true;
        }
        field(12; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            BlankZero = true;
        }
        field(13; "Approved/Rejected by"; Code[50])
        {
            Caption = 'Approved/Rejected by';
        }
        field(14; "Status Date"; DateTime)
        {
            Caption = 'Status Date';
        }
        field(15; "User Comment"; Blob)
        {
            Caption = 'User Comment';
        }
        field(16; "Approver Comment"; Blob)
        {
            Caption = 'Approver Comment';
        }
        field(17; "Commented by"; Code[50])
        {
            Caption = 'Commented by';
        }
        field(18; "Below Margin"; Boolean)
        {
            Caption = 'Below Margin';
            BlankZero = true;
        }
        field(19; "Approved by Entry No."; Integer)
        {
            Caption = 'Approved by Entry No.';
            Description = 'When sales order line is created, the price needs to be registered if it´s approved or not. We will find the approved price book and relate here.';
            BlankZero = true;
        }
        field(20; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(21; "Original Unit Price"; Decimal)
        {
            Caption = 'Original Unit price';
        }
        field(22; "Sales Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Sales Document Type';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "Source Type", "Sales Document Type", "Source No.", "Source Line No.")
        {
        }
    }
    trigger OnInsert()
    var
        MargenApp: Record "Margin Approval";
    begin
        Rec."User Name" := Copystr(UserId, 1, 50);

        if "Entry No." = 0 then
            if MargenApp.FindLast() then
                "Entry No." := MargenApp."Entry No." + 1
            else
                "Entry No." := 1;
    end;

    procedure ApproveSalesLine(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        //PriceLine: Record "Price List Line";
        MarginApp: Record "Margin Approval";
        PriceChangeType: Option Less,Equal,Higher;
    begin
        if MarginApprovalActive() then begin
            If (SalesLine."Document Type" IN [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) and
               (SalesLine.Type = SalesLine.Type::Item) and
               (SalesLine."Line No." <> 0)
            then begin
                MarginApp.SetCurrentKey("Source Type", "Sales Document Type", "Source No.", "Source Line No.");
                MarginApp.SetRange("Source Type", MarginApp."Source Type"::Sales);
                MarginApp.SetRange("Sales Document Type", SalesLine."Document Type");
                MarginApp.SetRange("Source No.", SalesLine."Document No.");
                MarginApp.SetRange("Source Line No.", SalesLine."Line No.");
                if not MarginApp.FindFirst() then begin
                    ApproveSalesLine2(SalesLine);
                end else begin
                    if (MarginApp."Original Unit Price" = 0) and (SalesLine."Unit Price" < MarginApp."Unit Price") or
                       (MarginApp."Original Unit Price" > 0) and (SalesLine."Unit Price" < MarginApp."Original Unit Price")
                    then
                        PriceChangeType := PriceChangeType::Less
                    else
                        if (MarginApp."Original Unit Price" <> 0) and (SalesLine."Unit Price" = MarginApp."Original Unit Price") then
                            PriceChangeType := PriceChangeType::Equal
                        else
                            if (MarginApp."Original Unit Price" <> 0) and (SalesLine."Unit Price" > MarginApp."Original Unit Price") or
                               (MarginApp."Original Unit Price" = 0) and (SalesLine."Unit Price" > MarginApp."Unit Price")
                            then
                                PriceChangeType := PriceChangeType::Higher
                            else
                                if SalesLine."Unit Price" <> MarginApp."Unit Price" then
                                    error('PriceChangeType is unknown.');

                    case PriceChangeType of
                        PriceChangeType::Less:
                            begin
                                if MarginApp."Original Unit Price" = 0 then
                                    MarginApp."Original Unit Price" := MarginApp."Unit Price";
                                MarginApp.Validate("Unit Price", SalesLine."Unit Price");
                                MarginApp.Validate(Status, MarginApp.Status::"Waiting for Margin Approval");
                                MarginApp."Below Margin" := false;
                                MarginApp."Approved/Rejected by" := '';
                                MarginApp."Approved by Entry No." := 0;
                                MarginApp.Modify(true);
                            end;
                        PriceChangeType::Equal:
                            begin
                                MarginApp.Delete(true);
                                ApproveSalesLine2(SalesLine);
                            end;
                        PriceChangeType::Higher:
                            begin
                                if MarginApp."Unit Price" <> 0 then begin
                                    MarginApp.Delete(true);
                                    ApproveSalesLine2(SalesLine);
                                    if MarginApp.FindFirst() and (MarginApp."Original Unit Price" = 0) then begin
                                        MarginApp."Original Unit Price" := MarginApp."Unit Price";
                                        MarginApp.Modify(true);
                                    end;
                                end;
                            end;
                    end;
                end;
            end;
        end;
    end;

    local procedure ApproveSalesLine2(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        PriceLine: Record "Price List Line";
        MarginApp: Record "Margin Approval";
        Cust: Record Customer;
    begin
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        Cust.get(SalesLine."Sell-to Customer No.");

        PriceLine.SetFilter("Source Type", '%1|%2', PriceLine."Source Type"::Customer, PriceLine."Source Type"::"Customer Price Group");
        PriceLine.SetFilter("Assign-to No.", '%1|%2', SalesLine."Sell-to Customer No.", SalesHeader."Customer Price Group");
        PriceLine.SetRange("Asset Type", PriceLine."Asset Type"::Item);
        PriceLine.SetRange("Product No.", SalesLine."No.");
        PriceLine.SetRange("Currency Code", SalesHeader."Currency Code");
        PriceLine.SetFilter("Starting Date", '..%1', SalesHeader."Order Date");
        PriceLine.SetFilter("Ending Date", '%1..', SalesHeader."Order Date");
        PriceLine.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
        if (PriceLine.FindFirst() and (SalesLine."Unit Price" >= PriceLine."Unit Price")) or
           Cust."Sample Account"
        then
            MarginApp.MarginApproved(
                MarginApp."Source Type"::Sales,
                SalesLine."Document Type",
                SalesLine."Document No.",
                SalesLine."Line No.",
                SalesLine."Sell-to Customer No.",
                SalesLine."No.",
                SalesLine."Currency Code",
                SalesLine."Unit Price",
                MarginApp.GetEntryNo(PriceLine."Price List Code", PriceLine."Line No."));  // Get the Entry no. from the price book, so it will be visible where it original was approved from.
    end;

    procedure MarginApproved(pSourcetype: Enum "Margin Approval Type"; pDocumentType: Enum "Sales Document Type"; pSourceNo: Code[20]; pSourceLineNo: Integer; pCustNo: Code[20]; pItemNo: Code[20]; pCurrCode: Code[20]; pUnitPrice: Decimal; pEntryNo: Integer) rValue: Boolean
    var
        MarginApp: Record "Margin Approval";
        MarginApp2: Record "Margin Approval";
    begin
        if MarginApprovalActive() then begin
            MarginApp.SetRange("Source Type", pSourceType);
            MarginApp.SetRange("Source No.", pSourceNo);
            MarginApp.SetRange("Source Line No.", pSourceLineNo);
            if not MarginApp.FindFirst() then begin
                MarginApp.Init();
                MarginApp.Validate("Source Type", pSourcetype);
                MarginApp.Validate("Sales Document Type", pDocumentType);
                MarginApp.Validate("Source No.", pSourceNo);
                MarginApp.Validate("Source Line No.", pSourceLineNo);
                MarginApp.Validate("Customer No.", pCustNo);
                MarginApp.Validate("Item No.", pItemNo);
                MarginApp.Validate("Unit Price", pUnitPrice);
                if pEntryNo <> 0 then begin
                    MarginApp2.get(pEntryNo);
                    MarginApp.Status := MarginApp2.Status;
                    MarginApp."Status Date" := MarginApp2."Status Date";
                    MarginApp."Below Margin" := MarginApp2."Below Margin";
                    MarginApp."Approved/Rejected by" := MarginApp2."Approved/Rejected by";
                    MarginApp."Approved by Entry No." := pEntryNo;
                end else
                    MarginApp.Validate(Status, MarginApp.Status::"Waiting for Margin Approval");
                MarginApp.Insert(true);
            end;

        end;
    end;

    procedure MarginApprovedSetup(pSourcetype: Enum "Margin Approval Type"; pDocumentType: Enum "Sales Document Type"; pSourceNo: Code[20]; pSourceLineNo: Integer; pCustNo: Code[20]; pItemNo: Code[20]; pCurrCode: Code[20]; pUnitPrice: Decimal; pEntryNo: Integer) rValue: Boolean
    var
        MarginApp: Record "Margin Approval";
        MarginApp2: Record "Margin Approval";
    begin
        MarginApp.SetRange("Source Type", pSourceType);
        MarginApp.SetRange("Source No.", pSourceNo);
        MarginApp.SetRange("Source Line No.", pSourceLineNo);
        if not MarginApp.FindFirst() then begin
            MarginApp.Init();
            MarginApp.Validate("Source Type", pSourcetype);
            MarginApp.Validate("Sales Document Type", pDocumentType);
            MarginApp.Validate("Source No.", pSourceNo);
            MarginApp.Validate("Source Line No.", pSourceLineNo);
            MarginApp.Validate("Customer No.", pCustNo);
            MarginApp.Validate("Item No.", pItemNo);
            MarginApp.Validate("Unit Price", pUnitPrice);
            MarginApp.Validate(Status, MarginApp.Status::Approved);
            MarginApp."Approved/Rejected by" := '';
            If Not MarginApp.Insert(true) then
                MarginApp.modify;

        end;
    end;

    procedure MarginApprovalActive(): Boolean
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.get();
        exit(SalesSetup."Margin Approval");
    end;

    procedure GetEntryNo(pSourceNo: Code[20]; pSourceLineNo: Integer): Integer
    var
        MarginApp: Record "Margin Approval";
    begin
        MarginApp.SetRange("Source Type", MarginApp."Source Type"::"Price Book");
        MarginApp.SetRange("Source No.", pSourceNo);
        MarginApp.SetRange("Source Line No.", pSourceLineNo);
        if not MarginApp.FindFirst() then;  // If there is no price book, it can be a sample.
        Exit(MarginApp."Entry No.");
    end;

    procedure UpdateOnSetup()
    var
        PriceLine: Record "Price List Line";
        MarginApp: Record "Margin Approval";
        SalesSetup: Record "Sales & Receivables Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        SalesDocType: Enum "Sales Document Type";
        lText001: Label 'Do you want to set margin "Status = Approved" for %1 price list lines?';
    begin
        SalesSetup.get();
        PriceLine.SetRange("Price Type", PriceLine."Price Type"::Sale);
        PriceLine.SetRange("Price List Code", SalesSetup."Default Price List Code");
        PriceLine.SetFilter("Ending Date", '%1|%2..', 0D, today);
        if PriceLine.FindSet() then
            If confirm(lText001, false, PriceLine.Count()) then begin
                ZGT.OpenProgressWindow('', PriceLine.Count());
                repeat
                    ZGT.UpdateProgressWindow(format(PriceLine."Line No."), 0, true);

                    MarginApp.MarginApprovedSetup(
                        MarginApp."Source Type"::"Price Book",
                        SalesDocType::Quote,  // Used for sales document
                        PriceLine."Price List Code",
                        PriceLine."Line No.",
                        PriceLine."Assign-to No.",
                        PriceLine."Product No.",
                        PriceLine."Currency Code",
                        PriceLine."Unit Price",
                        0);
                until PriceLine.Next() = 0;
                ZGT.CloseProgressWindow();
            end;
    end;

    procedure SetComment(CommentType: Option User,Approver; NewComment: Text)
    var
        OutStream: OutStream;
    begin
        Case CommentType of
            CommentType::Approver:
                begin
                    Clear("Approver Comment");
                    "Approver Comment".CreateOutStream(OutStream, TEXTENCODING::UTF8);
                    OutStream.WriteText(NewComment);
                    Modify();
                end;
            CommentType::User:
                begin
                    Clear("User Comment");
                    "User Comment".CreateOutStream(OutStream, TEXTENCODING::UTF8);
                    OutStream.WriteText(NewComment);
                    Modify();
                end;
        end;
    end;

    procedure GetComment(CommentType: Option User,Approver): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Case CommentType of
            CommentType::Approver:
                begin
                    CalcFields("Approver Comment");
                    "Approver Comment".CreateInStream(InStream, TEXTENCODING::UTF8);
                    exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Approver Comment")));
                end;
            CommentType::User:
                begin
                    CalcFields("User Comment");
                    "User Comment".CreateInStream(InStream, TEXTENCODING::UTF8);
                    exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("User Comment")));
                end;
        end;
    end;

    procedure EnterUserComment()
    var
        MarginApp: Record "Margin Approval";
        MarginAppUpdate: Page "Margin App. Update User Com.";
        PreviousComment: Text;
        ApprovalReqSent: Boolean;
    begin
        PreviousComment := Rec.GetComment(0);
        MarginApp.SetRange("Entry No.", Rec."Entry No.");
        MarginAppUpdate.SetTableView(MarginApp);
        MarginAppUpdate.RunModal();

        if Rec.GetComment(0) <> PreviousComment then begin
            case Rec."Source Type" of
                Rec."Source Type"::"Price Book":
                    begin
                        // Send Approval Request here;
                        ApprovalReqSent := false;
                    end;
                Rec."Source Type"::Sales:
                    begin
                        case Rec."Sales Document Type" of
                            Rec."Sales Document Type"::Order:
                                begin
                                    // Send Approval Request here;
                                    ApprovalReqSent := false;
                                end;
                            Rec."Sales Document Type"::Invoice:
                                begin
                                    // Send Approval Request here;
                                    ApprovalReqSent := false;
                                end;
                        end;
                    end;
            end;
            if ApprovalReqSent then begin
                Rec.Validate(Status, Rec.Status::"Waiting for Approval");
                Rec.Modify(true);
            end;
        end;
    end;

    procedure UserCommentEnabled(): Boolean
    Begin
        exit(Rec.Status = Rec.Status::"Waiting for User Comment");
    End;
}
