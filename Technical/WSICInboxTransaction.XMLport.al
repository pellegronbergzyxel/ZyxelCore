XmlPort 50034 "WS IC Inbox Transaction"
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/RepIcInbTrans';
    Encoding = UTF8;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("IC Inbox Transaction"; "IC Inbox Transaction")
            {
                MinOccurs = Zero;
                XmlName = 'ICInboxTransaction';
                UseTemporary = true;
                fieldelement(TranactionNo; "IC Inbox Transaction"."Transaction No.")
                {
                }
                fieldelement(IcPartnerCode; "IC Inbox Transaction"."IC Partner Code")
                {
                }
                fieldelement(TransactionSource; "IC Inbox Transaction"."Transaction Source")
                {
                }
                fieldelement(DocumentType; "IC Inbox Transaction"."Document Type")
                {
                }
                fieldelement(eCommerce; "IC Inbox Transaction".eCommerce)
                {
                }
                fieldelement(SourceType; "IC Inbox Transaction"."Source Type")
                {
                }
                fieldelement(DocumentNo; "IC Inbox Transaction"."Document No.")
                {
                }
                fieldelement(OrgDocumentNo; "IC Inbox Transaction"."Original Document No.")
                {
                }
                fieldelement(PostingDate; "IC Inbox Transaction"."Posting Date")
                {
                }
                fieldelement(DocumentDate; "IC Inbox Transaction"."Document Date")
                {
                }
                fieldelement(LineAction; "IC Inbox Transaction"."Line Action")
                {
                }
                fieldelement(IcPartGlAccNo; "IC Inbox Transaction"."IC Account No.")
                {
                }
                fieldelement(SourceLineNo; "IC Inbox Transaction"."Source Line No.")
                {
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


    procedure SetDate(pICInboxTransaction: Record "IC Inbox Transaction")
    begin
        "IC Inbox Transaction" := pICInboxTransaction;
        "IC Inbox Transaction".Insert;
    end;


    procedure ReplicateData()
    var
        recICInboxTrans: Record "IC Inbox Transaction";
        recHandICInboxTrans: Record "Handled IC Inbox Trans.";
        lText001: label 'Transaction %1 for %2 %3 already exists in the %4 table.';
    begin
        if "IC Inbox Transaction".FindSet then
            repeat
                if recICInboxTrans.Get(
                    "IC Inbox Transaction"."Transaction No.", "IC Inbox Transaction"."IC Partner Code",
                    "IC Inbox Transaction"."Transaction Source", "IC Inbox Transaction"."Document Type")
                then
                    Error(
                      lText001, recICInboxTrans."Transaction No.", recICInboxTrans.FieldCaption("IC Partner Code"),
                      recICInboxTrans."IC Partner Code", recHandICInboxTrans.TableCaption);

                recICInboxTrans := "IC Inbox Transaction";
                recICInboxTrans.Insert(true);
            until "IC Inbox Transaction".Next() = 0;
    end;
}
