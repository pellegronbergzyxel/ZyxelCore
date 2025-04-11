XmlPort 50005 "WS Travel Expense"
{
    // 001. 21-09-21 ZY-LD 2021092110000038 - They use different codes in Turkey.

    Caption = 'WS Travel Expense';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/transfer';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            textelement(PostDocument)
            {

                trigger OnAfterAssignVariable()
                begin
                    Evaluate(gPostDocument, PostDocument);
                end;
            }
            tableelement("Travel Expense Header"; "Travel Expense Header")
            {
                MinOccurs = Zero;
                XmlName = 'TravelExpenseHeader';
                UseTemporary = true;
                fieldelement(No; "Travel Expense Header"."No.")
                {
                }
                fieldelement(ReportName; "Travel Expense Header"."Concur Report Name")
                {
                }
                fieldelement(ReportID; "Travel Expense Header"."Concur Report ID")
                {
                }
                fieldelement(BatchID; "Travel Expense Header"."Concur Batch ID")
                {
                }
                fieldelement(PostingDate; "Travel Expense Header"."Posting Date")
                {
                }
                fieldelement(CostTypeName; "Travel Expense Header"."Cost Type Name")
                {
                }
                fieldelement(CompanyName; "Travel Expense Header"."Concur Company Name")
                {
                }
                fieldelement(CountryCode; "Travel Expense Header"."Country Code")
                {
                }
                tableelement("Travel Expense Line"; "Travel Expense Line")
                {
                    LinkFields = "Document No." = field("No.");
                    LinkTable = "Travel Expense Header";
                    MinOccurs = Zero;
                    XmlName = 'TravelExpenseLine';
                    UseTemporary = true;
                    fieldelement(DocumentNo; "Travel Expense Line"."Document No.")
                    {
                    }
                    fieldelement(LineNo; "Travel Expense Line"."Line No.")
                    {
                    }
                    fieldelement(BusinessPurpose; "Travel Expense Line"."Business Purpose")
                    {
                    }
                    fieldelement(SequenceNo; "Travel Expense Line"."Concur Sequence No.")
                    {
                    }
                    fieldelement(Debit_Credit; "Travel Expense Line"."Debit / Credit Type")
                    {
                    }
                    fieldelement(Type; "Travel Expense Line".Type)
                    {
                    }
                    fieldelement(ExpenseType; "Travel Expense Line"."Expense Type")
                    {
                    }
                    fieldelement(AccountType; "Travel Expense Line"."Account Type")
                    {
                    }
                    fieldelement(AccountNo; "Travel Expense Line"."Account No.")
                    {
                    }
                    fieldelement(VendorName; "Travel Expense Line"."Vendor Name")
                    {
                    }
                    fieldelement(VendorDescription; "Travel Expense Line"."Vendor Description")
                    {
                    }
                    fieldelement(CurrencyCode; "Travel Expense Line"."Currency Code")
                    {
                    }
                    fieldelement(Amount; "Travel Expense Line".Amount)
                    {
                    }
                    fieldelement(BalAccountType; "Travel Expense Line"."Bal. Account Type")
                    {
                    }
                    fieldelement(BalAccountNo; "Travel Expense Line"."Bal. Account No.")
                    {
                    }
                    fieldelement(DivisionCode; "Travel Expense Line"."Division Code - Concur")
                    {
                    }
                    fieldelement(DepartmentCode; "Travel Expense Line"."Department Code - Zyxel")
                    {
                    }
                    fieldelement(DivisionCodeZyxel; "Travel Expense Line"."Division Code - Zyxel")
                    {
                    }
                    fieldelement(PurchasingAmount; "Travel Expense Line"."Purchasing Amount")
                    {
                    }
                    fieldelement(PurchasingCurrencyCode; "Travel Expense Line"."Purchasing Currency Code")
                    {
                    }
                    fieldelement(VatProdPostGrp; "Travel Expense Line"."VAT Prod. Posting Group")
                    {
                    }
                    fieldelement(CarBusinessDistance; "Travel Expense Line"."Car Business Distance")
                    {
                    }
                    fieldelement(CarPersonalDistance; "Travel Expense Line"."Car Personal Distance")
                    {
                    }
                    fieldelement(VehicleId; "Travel Expense Line"."Vehicle Id")
                    {
                    }
                    fieldelement(OriginalAmount; "Travel Expense Line"."Original Amount")
                    {
                    }
                    fieldelement(PayerPaymentType; "Travel Expense Line"."Payer Payment Type")
                    {
                    }
                    fieldelement(ShowExpense; "Travel Expense Line"."Show Expense")
                    {
                    }
                    fieldelement(CostType; "Travel Expense Line"."Cost Type")
                    {
                    }
                    fieldelement(CountryCode; "Travel Expense Line"."Country Code")
                    {
                    }
                    fieldelement(DepartmentCodeConcur; "Travel Expense Line"."Department Code - Concur")
                    {
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        gPostDocument: Boolean;


    procedure SetData(var pTrExpHead: Record "Travel Expense Header"; NewPostDocument: Boolean): Boolean
    var
        recTrExpLine: Record "Travel Expense Line";
        recVatProdPostGrp: Record "VAT Product Posting Group";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        PostDocument := Format(NewPostDocument);
        if pTrExpHead.FindSet then
            repeat
                "Travel Expense Header" := pTrExpHead;
                "Travel Expense Header".Insert;

                recTrExpLine.SetRange("Document No.", pTrExpHead."No.");
                if recTrExpLine.FindFirst then
                    repeat
                        "Travel Expense Line" := recTrExpLine;
                        //>> 21-09-21 ZY-LD 001
                        if ("Travel Expense Header"."Concur Company Name" = ZGT.GetCompanyName(15)) or
                           ("Travel Expense Header"."Concur Company Name" = ZGT.GetSistersCompanyName(15))
                        then
                            if recVatProdPostGrp.Get(recTrExpLine."VAT Prod. Posting Group") and (recVatProdPostGrp."Turkish Code" <> '') then
                                "Travel Expense Line"."VAT Prod. Posting Group" := recVatProdPostGrp."Turkish Code";
                        //<< 21-09-21 ZY-LD 001
                        "Travel Expense Line".Insert;
                    until recTrExpLine.Next() = 0;
            until pTrExpHead.Next() = 0;
        exit(true);
    end;


    procedure InsertData(Automation: Boolean): Boolean
    var
        recTrExpHead: Record "Travel Expense Header";
        recTrExpLine: Record "Travel Expense Line";
        lText001: label '"%1" %2 has already been %3 in %4.';
        recTrExpType: Record "Travel Exp. Expense Type";
        TravelExpPost: Codeunit "TravelExpense-Post";
    begin
        if "Travel Expense Header".FindSet then
            repeat
                recTrExpHead.SetRange("Concur Report ID", "Travel Expense Header"."Concur Report ID");
                if recTrExpHead.FindFirst then
                    if recTrExpHead."Document Status" < recTrExpHead."document status"::Posted then
                        recTrExpHead.Delete(true)
                    else
                        if Automation then
                            exit(false)
                        else
                            Error(lText001, "Travel Expense Header".FieldCaption("Concur Report ID"), "Travel Expense Header"."Concur Report ID", recTrExpHead."Document Status", CompanyName());

                recTrExpHead := "Travel Expense Header";
                recTrExpHead."No." := '';
                recTrExpHead.Insert(true);

                "Travel Expense Line".SetRange("Document No.", "Travel Expense Header"."No.");
                if "Travel Expense Line".FindSet then
                    repeat
                        recTrExpLine := "Travel Expense Line";
                        recTrExpLine."Document No." := recTrExpHead."No.";
                        recTrExpLine.Validate("Currency Code");
                        recTrExpLine.Validate("Purchasing Amount");
                        recTrExpLine.Validate(Amount);
                        recTrExpLine.Validate("Bal. Account No.");
                        recTrExpLine.Insert(true);

                        if not recTrExpType.Get(recTrExpLine."Expense Type") then begin
                            recTrExpType.Code := recTrExpLine."Expense Type";
                            recTrExpType.Name := recTrExpLine."Expense Type";
                            recTrExpType.Insert;
                        end;
                    until "Travel Expense Line".Next() = 0;

                if gPostDocument then begin
                    Clear(TravelExpPost);
                    TravelExpPost.SetPostJournal(gPostDocument);
                    TravelExpPost.Run(recTrExpHead);
                    Commit;
                end;
            until "Travel Expense Header".Next() = 0;
        exit(true);
    end;
}
