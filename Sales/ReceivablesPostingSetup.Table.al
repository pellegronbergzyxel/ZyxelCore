Table 75000 "Receivables Posting Setup"
{

    fields
    {
        field(1; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            NotBlank = true;
            TableRelation = "Customer Posting Group".Code;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            InitValue = Payment;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(3; "Receivable Type"; Code[10])
        {
            Caption = 'Receivable Type';
            TableRelation = "Receivable Type";
        }
        field(10; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            var
                ltcChange: label 'Do you want change %1 although exists open payments?';
            begin
                CheckGLAcc("Account No.");

                if OpenEntriesExist then
                    if not Confirm(ltcChange, false, FieldCaption("Account No.")) then
                        Error('');
            end;
        }
    }

    keys
    {
        key(Key1; "Customer Posting Group", "Document Type", "Receivable Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ltcNoDelete: label '%1 cannot be deleted when open payments exist!';
    begin
        if OpenEntriesExist then
            Error(StrSubstNo(ltcNoDelete, TableCaption));
    end;

    trigger OnInsert()
    begin
        if "Document Type" <> "document type"::Payment then
            TestField("Receivable Type");
    end;

    trigger OnModify()
    begin
        if "Document Type" <> "document type"::Payment then
            TestField("Receivable Type");
    end;

    trigger OnRename()
    begin
        Error(Text003, TableCaption);
    end;

    var
        Text003: label 'You cannot rename a %1.';

    local procedure CheckGLAcc(lcoAccNo: Code[20])
    var
        lreGLAcc: Record "G/L Account";
    begin
        if lcoAccNo <> '' then begin
            lreGLAcc.Get(lcoAccNo);
            lreGLAcc.CheckGLAcc;
        end;
    end;


    procedure OpenEntriesExist(): Boolean
    var
        lreCustEntry: Record "Cust. Ledger Entry";
    begin
        lreCustEntry.SetCurrentkey(Open);
        //15-51643 -Receivable Type does not exist on Cust Ledger Entry
        //lreCustEntry.SETRANGE("Receivable Type","Receivable Type");
        //15-51643 +
        lreCustEntry.SetRange("Customer Posting Group", "Customer Posting Group");
        if "Document Type" <> "document type"::" " then
            lreCustEntry.SetRange("Document Type", "Document Type");
        lreCustEntry.SetRange(Open, true);

        exit(not lreCustEntry.IsEmpty);
    end;
}
