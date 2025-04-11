pageextension 50166 CashReceiptJournalZX extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Direct Debit Mandate ID")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    var
        Text002: Label 'You must specify Amount and Amount (LCY) before you can apply a cost split.';
        Text003: Label 'You must specify an account number before you can apply a cost split.';
        Text004: Label 'You must specify a description before you can apply a cost split.';

    procedure AddJournalLineDimensionCountry(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; JournalLineNo: Integer; CountryCode: Code[20])
    begin
        //15-51643 Table 356 no longer exists, so rework required
        /*
        recJournalLineDimension.SETFILTER("Journal Template Name",JournalTemplateName);
        recJournalLineDimension.SETFILTER("Journal Batch Name",JournalBatchName);
        recJournalLineDimension.SETFILTER("Journal Line No.",FORMAT(JournalLineNo));
        recJournalLineDimension.SETFILTER("Dimension Code",'COUNTRY');
        recJournalLineDimension.SETFILTER("Dimension Value Code",CountryCode);
        IF NOT recJournalLineDimension.FINDFIRST THEN BEGIN
          recJournalLineDimension.INIT;
          recJournalLineDimension."Table ID" := 81;
          recJournalLineDimension."Journal Template Name" := JournalTemplateName;
          recJournalLineDimension."Journal Batch Name" := JournalBatchName;
          recJournalLineDimension."Journal Line No." := JournalLineNo;
          recJournalLineDimension."Dimension Code" := 'COUNTRY';
          recJournalLineDimension."Dimension Value Code" := CountryCode;
          recJournalLineDimension.INSERT;
        END;
        *///15-51643
    end;

    local procedure AddCountryDimension(var TheGJL: Record "Gen. Journal Line"; TheCountry: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
        tDSE: Record "Dimension Set Entry" temporary;
        NewDSID: Integer;
    begin
        //15-51643 Function replaces AddJournalLineDimensionCountry()
        tDSE.DeleteAll();
        DimMgt.GetDimensionSet(tDSE, TheGJL."Dimension Set ID");
        tDSE.SetRange("Dimension Code", 'COUNTRY');
        if not tDSE.FindFirst() then begin
            tDSE.Init();
            tDSE.Validate("Dimension Code", 'COUNTRY');
            tDSE.Validate("Dimension Value Code", TheCountry);
            tDSE.Insert();
        end;
        tDSE.Reset();
        NewDSID := DimMgt.GetDimensionSetID(tDSE);
        if TheGJL."Dimension Set ID" <> NewDSID then begin
            TheGJL."Dimension Set ID" := NewDSID;
            TheGJL.Modify();
        end;
    end;
}
