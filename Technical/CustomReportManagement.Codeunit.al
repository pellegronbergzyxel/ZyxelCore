Codeunit 50053 "Custom Report Management"
{
    // 001. 27-09-18 ZY-LD 000 - Get and update e-mail address.
    // 002. 27-05-19 ZY-LD P0213 - Force replication on customers.


    trigger OnRun()
    begin
        UpdateAllCustomers;
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        CustChanged: Boolean;


    procedure GetEmailAddress(pSourceType: Integer; pSourceNo: Code[20]; pUsage: Enum "Report Selection Usage"; pEmailAdd: Text): Text
    var
        recCustRepSelect: Record "Custom Report Selection";
    begin
        recCustRepSelect.SetRange("Source Type", pSourceType);
        recCustRepSelect.SetRange("Source No.", pSourceNo);
        recCustRepSelect.SetRange(Usage, pUsage);
        if recCustRepSelect.FindFirst and (recCustRepSelect."Send To Email" <> '') then
            exit(recCustRepSelect."Send To Email")
        else
            exit(pEmailAdd);
    end;


    procedure UpdateEmailAddress(pSourceType: Integer; pSourceNo: Code[20]; pUsage: Enum "Report Selection Usage"; pEmailAdd: Text) rValue: Boolean
    var
        recCustEmail: Record "Custom Report Selection";
    begin
        pEmailAdd := ZGT.ValidateEmailAdd(pEmailAdd);
        recCustEmail.SetRange("Source Type", pSourceType);
        recCustEmail.SetRange("Source No.", pSourceNo);
        recCustEmail.SetRange(Usage, pUsage);
        if recCustEmail.FindFirst then begin
            if recCustEmail."Send To Email" <> pEmailAdd then begin
                recCustEmail."Send To Email" := pEmailAdd;
                recCustEmail.Modify;
                rValue := true;
            end
        end else begin
            recCustEmail."Source Type" := pSourceType;
            recCustEmail."Source No." := pSourceNo;
            recCustEmail.Usage := pUsage;
            recCustEmail.Sequence := 0;
            recCustEmail."Send To Email" := pEmailAdd;
            recCustEmail.Insert;
            rValue := true;
        end;
    end;


    procedure UpdateAllCustomers()
    var
        recCust: Record Customer;
        recBillToCust: Record Customer;
        recSubCust: Record Customer;
        recICPartner: Record "IC Partner";
        recCustRepSelect: Record "Custom Report Selection";
        lText001: label 'Do you want to update e-mail address for all customers?';
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        CustomerChanged: Boolean;
    begin
        if Confirm(lText001, true) then begin
            recCust.SetFilter("E-Mail", '<>%1', '');
            if recCust.FindFirst then begin
                ZGT.OpenProgressWindow('', recCust.Count);
                repeat
                    ZGT.UpdateProgressWindow(recCust."No.", 0, true);
                    CustChanged := false;

                    if ZGT.IsRhq then
                        if recBillToCust.Get(recCust."Bill-to Customer No.") then
                            if recICPartner.Get(recBillToCust."IC Partner Code") then begin
                                recSubCust.ChangeCompany(recICPartner."Inbox Details");
                                if recSubCust.Get(recCust."No.") and (recSubCust."E-Mail" <> '') then
                                    if (recCust."E-Mail" = '') or
                                       (recCust."E-Mail" in ['OD_ZyDE@zyxel.de', 'logistics@zyxel.dk', 'orders@zyxel.eu'])
                                    then begin
                                        recCust."E-Mail" := recSubCust."E-Mail";
                                        CustChanged := true;
                                    end;

                                if recCust."Reminder Terms Code" <> recSubCust."Reminder Terms Code" then begin
                                    recCust."Reminder Terms Code" := recSubCust."Reminder Terms Code";
                                    CustChanged := true;
                                end;
                                if recCust."Language Code" <> recSubCust."Language Code" then begin
                                    recCust."Language Code" := recSubCust."Language Code";
                                    CustChanged := true;
                                end;
                                if recCust."Payment Terms Code" <> recSubCust."Payment Terms Code" then begin
                                    recCust."Payment Terms Code" := recSubCust."Payment Terms Code";
                                    CustChanged := true;
                                end;
                                if recCust."Payment Method Code" <> recSubCust."Payment Method Code" then begin
                                    recCust."Payment Method Code" := recSubCust."Payment Method Code";
                                    CustChanged := true;
                                end;
                                if recCust."E-Mail Reminder" <> recSubCust."E-Mail Reminder" then begin
                                    recCust."E-Mail Reminder" := recSubCust."E-Mail Reminder";
                                    CustChanged := true;
                                end;
                                if recCust."E-Mail Statement" <> recSubCust."E-Mail Statement" then begin
                                    recCust."E-Mail Statement" := recSubCust."E-Mail Statement";
                                    CustChanged := true;
                                end;
                                if recCust."Print Statements" <> recSubCust."Print Statements" then begin
                                    recCust."Print Statements" := recSubCust."Print Statements";
                                    CustChanged := true;
                                end;
                                if recCust."Statement Type" <> recSubCust."Statement Type" then begin
                                    recCust."Statement Type" := recSubCust."Statement Type";
                                    CustChanged := true;
                                end;
                                if (recCust."VAT Registration Code" = '') and (recSubCust."VAT Registration Code" <> '') then begin
                                    recCust."VAT Registration Code" := recSubCust."VAT Registration Code";
                                    CustChanged := true;
                                end;
                                if recCust."Invoice Copies" <> recSubCust."Invoice Copies" then begin
                                    recCust."Invoice Copies" := recSubCust."Invoice Copies";
                                    CustChanged := true;
                                end;
                                if recCust."FCST Region ID" <> recSubCust."FCST Region ID" then begin
                                    recCust."FCST Region ID" := recSubCust."FCST Region ID";
                                    CustChanged := true;
                                end;

                                if CustChanged then
                                    recCust.Modify;
                            end;

                    if (recCust."E-Mail" <> '') and
                       (recCust."E-Mail" <> 'OD_ZyDE@zyxel.de') and
                       (recCust."E-Mail" <> 'logistics@zyxel.dk') and
                       (recCust."E-Mail" <> 'orders@zyxel.eu')
                    then begin
                        CustomerChanged := false;
                        if UpdateEmailAddress(Database::Customer, recCust."No.", recCustRepSelect.Usage::"S.Invoice", recCust."E-Mail") then
                            CustomerChanged := true;
                        if UpdateEmailAddress(Database::Customer, recCust."No.", recCustRepSelect.Usage::"S.Cr.Memo", recCust."E-Mail") then
                            CustomerChanged := true;
                        if UpdateEmailAddress(Database::Customer, recCust."No.", recCustRepSelect.Usage::"S.Order", recCust."E-Mail") then
                            CustomerChanged := true;

                    end;

                    if CustChanged or CustomerChanged then
                        ZyWebServMgt.ReplicateCustomers('', recCust."No.", false);
                until recCust.Next() = 0;
                ZGT.CloseProgressWindow;
            end;
        end;
    end;
}
