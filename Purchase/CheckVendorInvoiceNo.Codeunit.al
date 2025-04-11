Codeunit 62051 "Check Vendor Invoice No"
{

    trigger OnRun()
    begin
    end;


    procedure CheckPOLineVendorInvoiceNo(var POHeader: Record "Purchase Header") ExistFunction: Boolean
    var
        POErrMsg1: label 'Vendor Inovice Number in the Purchase Line must be the same when posting PO Receive!';
        LineVendorInvoiceNo: Text[30];
        POLine: Record "Purchase Line";
        countPOLine: Integer;
        POErrMsg2: label 'Vendor Invoice Number in the Purchase Liine can not be blank when posting PO Receive!';
        PONo: Text[30];
    begin
        //Add by Andrew 20100802(+)
        countPOLine := 0;
        LineVendorInvoiceNo := '';
        ExistFunction := false;
        PONo := POHeader."No.";
        POLine.Reset;
        POLine.SetRange(POLine."Document No.", PONo);
        if POLine.FindFirst then;
        begin
            for countPOLine := 1 to POLine.Count
             do begin
                //Find the "Qty to Receive" that is not zero
                if (POLine."Qty. to Receive" <> 0) then begin
                    //If the local temp variable has no value, assign POLine's Invoice No
                    if LineVendorInvoiceNo = '' then begin
                        LineVendorInvoiceNo := POLine."Vendor Invoice No";
                    end;
                    if (LineVendorInvoiceNo <> POLine."Vendor Invoice No") and (POLine."Vendor Invoice No" <> '') then begin
                        Error(POErrMsg1);
                        ExistFunction := true;
                    end else
                        if (POLine."Vendor Invoice No" = '') then begin
                            Error(POErrMsg2);
                            ExistFunction := true;
                        end;
                end;
                POLine.Next;
            end;
        end;
        if (ExistFunction = false) and (LineVendorInvoiceNo <> '') then begin
            POHeader."Vendor Invoice No." := LineVendorInvoiceNo;
            POHeader.Modify;
        end;
        //Add by Andrew 20100802(-)
    end;


    procedure CheckPOHeaderVendorInvoiceNo(var POHeader: Record "Purchase Header") ExistFunction: Boolean
    var
        POErrMsg1: label 'The Vendor Invoice No in the Purchase Header cannot be blank!';
    begin
        //Add by Andrew 20100802(+)
        ExistFunction := false;
        POHeader.Reset;
        if POHeader."Vendor Invoice No." = '' then begin
            Message(POErrMsg1);
            ExistFunction := true;
        end;
        //Add by Andrew 20100802(-)
    end;
}
