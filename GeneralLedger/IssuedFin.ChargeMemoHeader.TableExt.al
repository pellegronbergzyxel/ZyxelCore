tableextension 50153 IssuedFinChargeMemoHeaderZX extends "Issued Fin. Charge Memo Header"
{
    procedure SendAsEmailCustomer(pCustNo: Code[20]): Boolean
    var
        recCustRepSel: Record "Custom Report Selection";
        recCust: Record Customer;
    begin
        //>> 03-08-18 CD-LD 001
        if recCust.Get(pCustNo) then begin
            recCustRepSel.SetRange("Source Type", Database::Customer);
            recCustRepSel.SetRange("Source No.", pCustNo);
            recCustRepSel.SetRange(Usage, recCustRepSel.Usage::"Fin.Charge");
            if recCustRepSel.FindFirst() and (recCustRepSel."Send To Email" <> '') then
                exit(true)
            else
                if recCust."E-Mail" <> '' then
                    exit(true);
        end;
        //<< 03-08-18 CD-LD 001
    end;
}
