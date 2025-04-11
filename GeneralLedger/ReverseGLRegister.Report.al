Report 50063 "Reverse G/L Register"
{
    Caption = 'Reverse G/L Register';
    ProcessingOnly = true;

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            RequestFilterFields = "No.";
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                CalcFields = Amount;
                DataItemTableView = sorting("Entry No.");

                trigger OnAfterGetRecord()
                begin
                    LineNo += 10000;
                    Clear(recGenJnl);
                    recGenJnl.Init;
                    recGenJnl.Validate("Journal Template Name", recGenJnlTemplate.Name);
                    recGenJnl.Validate("Journal Batch Name", "G/L Register"."Journal Batch Name");
                    recGenJnl.Validate("Line No.", LineNo);
                    case "Cust. Ledger Entry"."Document Type" of
                        "Cust. Ledger Entry"."document type"::Payment:
                            recGenJnl.Validate("Document Type", "Cust. Ledger Entry"."document type"::Refund);
                        "Cust. Ledger Entry"."document type"::Refund:
                            recGenJnl.Validate("Document Type", "Cust. Ledger Entry"."document type"::Payment);
                    end;
                    recGenJnl.Validate("Document No.", DocNo);
                    recGenJnl.Validate("Account Type", recGenJnl."account type"::Customer);
                    recGenJnl.Validate("Account No.", "Cust. Ledger Entry"."Customer No.");
                    recGenJnl.Validate("External Document No.", "Cust. Ledger Entry"."External Document No.");
                    recGenJnl.Validate("Posting Date", PostingDate);
                    recGenJnl.Description := CopyStr(recGenJnl.Description + Text001, 1, MaxStrLen(recGenJnl.Description));
                    recGenJnl.Validate(Amount, -"Cust. Ledger Entry".Amount);
                    if "Cust. Ledger Entry".Open then begin
                        //recGenJnl.VALIDATE("Applies-to Doc. Type","Document Type");
                        //recGenJnl.VALIDATE("Applies-to Doc. No.","Document No.");
                    end;
                    recGenJnl.Insert(true);
                end;

                trigger OnPostDataItem()
                begin
                    Message(Text004, recGenJnlTemplate.Name, "G/L Register"."Journal Batch Name");
                end;

                trigger OnPreDataItem()
                begin
                    "Cust. Ledger Entry".SetRange("Cust. Ledger Entry"."Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");

                    recGenJnl.SetRange("Journal Template Name", recGenJnlTemplate.Name);
                    recGenJnl.SetRange("Journal Batch Name", "G/L Register"."Journal Batch Name");
                    if recGenJnl.FindLast then
                        LineNo := recGenJnl."Line No.";
                    recGenJnl.Reset;
                end;
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                CalcFields = Amount;

                trigger OnAfterGetRecord()
                begin
                    LineNo += 10000;
                    Clear(recGenJnl);
                    recGenJnl.Init;
                    recGenJnl.Validate("Journal Template Name", recGenJnlTemplate.Name);
                    recGenJnl.Validate("Journal Batch Name", "G/L Register"."Journal Batch Name");
                    recGenJnl.Validate("Line No.", LineNo);
                    case "Vendor Ledger Entry"."Document Type" of
                        "Vendor Ledger Entry"."document type"::Payment:
                            recGenJnl.Validate("Document Type", "Vendor Ledger Entry"."document type"::Refund);
                        "Vendor Ledger Entry"."document type"::Refund:
                            recGenJnl.Validate("Document Type", "Vendor Ledger Entry"."document type"::Payment);
                    end;
                    recGenJnl.Validate("Document No.", DocNo);
                    recGenJnl.Validate("Account Type", recGenJnl."account type"::Vendor);
                    recGenJnl.Validate("Account No.", "Vendor Ledger Entry"."Vendor No.");
                    recGenJnl.Validate("External Document No.", "Vendor Ledger Entry"."External Document No.");
                    recGenJnl.Validate("Posting Date", PostingDate);
                    recGenJnl.Description := CopyStr(recGenJnl.Description + Text001, 1, MaxStrLen(recGenJnl.Description));
                    recGenJnl.Validate(Amount, -"Vendor Ledger Entry".Amount);
                    if "Vendor Ledger Entry".Open then begin
                        //recGenJnl.VALIDATE("Applies-to Doc. Type","Document Type");
                        //recGenJnl.VALIDATE("Applies-to Doc. No.","Document No.");
                    end;
                    recGenJnl.Insert(true);
                end;

                trigger OnPreDataItem()
                begin
                    "Vendor Ledger Entry".SetRange("Vendor Ledger Entry"."Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");

                    recGenJnl.SetRange("Journal Template Name", recGenJnlTemplate.Name);
                    recGenJnl.SetRange("Journal Batch Name", "G/L Register"."Journal Batch Name");
                    if recGenJnl.FindLast then
                        LineNo := recGenJnl."Line No.";
                    recGenJnl.Reset;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("recGenJnlTemplate.Name"; recGenJnlTemplate.Name)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Template Name';
                        TableRelation = "Gen. Journal Template";
                    }
                    field("recGenJournalBatch.Name"; recGenJournalBatch.Name)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Batch Name';
                        TableRelation = "Gen. Journal Batch";

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            recGenJournalBatch.SetRange("Journal Template Name", recGenJnlTemplate.Name);
                            if Page.RunModal(Page::"General Journal Batches", recGenJournalBatch) = Action::LookupOK then
                                recGenJournalBatch.Name := recGenJournalBatch.Name;
                        end;
                    }
                    field(DocNo; DocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document No.';
                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if "G/L Register".GetFilter("No.") = '' then
            Error(Text003, "G/L Register".FieldCaption("No."));

        if DocNo = '' then
            Error(Text002);

        SI.UseOfReport(3, 50063, 2);  // 14-10-20 ZY-LD 000
    end;

    var
        recGenJnl: Record "Gen. Journal Line";
        recGenJnlTemplate: Record "Gen. Journal Template";
        recGenJournalBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        Text001: label ' - Reversed';
        DocNo: Code[20];
        Text002: label 'Document No. must have a value.';
        Text003: label 'Set a filter on %1.';
        Text004: label 'Lines is added to %1 %2.';
        PostingDate: Date;
        SI: Codeunit "Single Instance";
}
