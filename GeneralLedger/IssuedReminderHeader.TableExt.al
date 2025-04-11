tableextension 50151 IssuedReminderHeaderZX extends "Issued Reminder Header"
{
    procedure SendAsEmailCustomer(pCustNo: Code[20]): Boolean
    var
        recCustRepSel: Record "Custom Report Selection";
        recCust: Record Customer;
    begin
        //>> 03-08-18 CD-LD 001
        if recCust.Get(pCustNo) and (recCust."E-Mail Reminder") then begin
            recCustRepSel.SetRange("Source Type", Database::Customer);
            recCustRepSel.SetRange("Source No.", pCustNo);
            recCustRepSel.SetRange(Usage, recCustRepSel.Usage::Reminder);
            if recCustRepSel.FindFirst() and (recCustRepSel."Send To Email" <> '') then
                exit(true)
            else
                if recCust."E-Mail" <> '' then
                    exit(true);
        end;
        //<< 03-08-18 CD-LD 001
    end;
}
