XmlPort 50023 "HQ ECommerce Payment"
{
    Caption = 'HQ ECommerce Payment';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/ecom_payment';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("eCommerce Payment Header"; "eCommerce Payment Header")
            {
                XmlName = 'Header';
                UseTemporary = true;
                fieldelement(Date; "eCommerce Payment Header".Date)
                {
                    trigger OnAfterAssignField()
                    var
                        ImpDate: Date;
                    begin
                        ImpDate := "eCommerce Payment Header".Date;
                    end;
                }
                fieldelement(TotalTransferredAmount; "eCommerce Payment Header"."Transfered Amount")
                {
                }
                tableelement("eCommerce Payment"; "eCommerce Payment")
                {
                    XmlName = 'Line';
                    UseTemporary = true;
                    fieldelement(MarketPlace; "eCommerce Payment"."eCommerce Market Place")
                    {
                    }
                    fieldelement(OrderID; "eCommerce Payment"."Order ID")
                    {
                    }
                    fieldelement(InvoiceID; "eCommerce Payment"."eCommerce Invoice No.")
                    {

                        trigger OnAfterAssignField()
                        begin
                            "eCommerce Payment"."eCommerce Invoice No." := UpperCase("eCommerce Payment"."eCommerce Invoice No.");
                        end;
                    }
                    fieldelement(TransactionType; "eCommerce Payment"."Transaction Type")
                    {

                        trigger OnAfterAssignField()
                        begin
                            if "eCommerce Payment"."Transaction Type" = 0 then
                                "eCommerce Payment"."New Transaction Type" := Format("eCommerce Payment"."transaction type"::Order)
                            else
                                "eCommerce Payment"."New Transaction Type" := Format("eCommerce Payment"."transaction type"::Refund);
                        end;
                    }
                    fieldelement(PaymentType; "eCommerce Payment"."Amount Type")
                    {
                        FieldValidate = no;
                    }
                    fieldelement(PaymentDetail; "eCommerce Payment"."Amount Description")
                    {
                        FieldValidate = Yes;

                        trigger OnAfterAssignField()
                        begin
                            if "eCommerce Payment"."Amount Description" = '' then
                                "eCommerce Payment"."Amount Description" := Text002;
                        end;
                    }
                    fieldelement(CurrencyCode; "eCommerce Payment"."Currency Code")
                    {
                    }
                    fieldelement(Amount; "eCommerce Payment".Amount)
                    {
                    }

                    trigger OnBeforeInsertRecord()
                    begin
                        NewLineNo += 10000;
                        "eCommerce Payment".UID := NewLineNo;
                    end;
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
        Text001: label 'Payment Type "%1" is unknown.';
        NewLineNo: Integer;
        Text002: label 'BLANK';


    procedure GetData(var pAmzHeadTmp: Record "eCommerce Payment Header" temporary; var pAmzLineTmp: Record "eCommerce Payment" temporary)
    begin
        if "eCommerce Payment Header".FindSet then
            repeat
                pAmzHeadTmp := "eCommerce Payment Header";
                pAmzHeadTmp.Insert;

                if "eCommerce Payment".FindSet then
                    repeat
                        pAmzLineTmp := "eCommerce Payment";
                        pAmzLineTmp.Insert;
                    until "eCommerce Payment".Next() = 0;
            until "eCommerce Payment Header".Next() = 0;
    end;
}
