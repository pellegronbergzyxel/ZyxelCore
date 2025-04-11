reportextension 50006 CombineReturnReceiptsZX extends "Combine Return Receipts"
{
    procedure InitializeRequestZX(NewPostingDate: Date; NewDocumentDate: Date; NewCalcInvDisc: Boolean; NewPostCreditMemo: Boolean)
    var
        GLSetupZX: Record "General Ledger Setup";
    begin
        PostingDateReq := NewPostingDate;
        DocDateReq := NewDocumentDate;
        VATDateReq := GLSetupZX.GetVATDate(PostingDateReq, DocDateReq);
        CalcInvDisc := NewCalcInvDisc;
        PostInv := NewPostCreditMemo;
    end;
}
