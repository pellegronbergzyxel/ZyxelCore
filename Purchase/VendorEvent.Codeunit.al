Codeunit 62006 "Vendor Event"
{
    // 001. 25-11-20 ZY-LD 2020112510000037 - Set filter on Zyxel Vendors.
    // 002. 11-02-21 ZY-LD P0464 - "VAT Registration No.".


    trigger OnRun()
    begin
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnBeforeRename(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    var
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        lText001: label '%1 is created as "Concur Vendor", and is not allowed to rename.';
    begin
        if ZyWebServMgt.VendorCreatedInConcur(Rec."No.") then
            Error(lText001, Rec."No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeValidateEvent', 'SBU Company', false, false)]
    local procedure OnBeforeValidateSBUCompany(var Rec: Record Vendor; var xRec: Record Vendor; CurrFieldNo: Integer)
    var
        recVend: Record Vendor;
        lText001: label '"%1" %2 is already used on %3.';
        lText002: label 'You canÍs use "%1" %2 in %3.';
    begin
        begin
            if (ZGT.IsZNetCompany and (Rec."SBU Company" = Rec."sbu company"::"ZNet EMEA")) or
               (not ZGT.IsZNetCompany and (Rec."SBU Company" = Rec."sbu company"::"ZCom EMEA"))
            then
                Error(lText002, Rec.FieldCaption(Rec."SBU Company"), Rec."SBU Company", CompanyName());

            recVend.SetRange("SBU Company", Rec."SBU Company");
            recVend.SetFilter("No.", '<>%1', Rec."No.");
            if recVend.FindFirst then
                Error(lText001, Rec.FieldCaption(Rec."SBU Company"), Rec."SBU Company", recVend."No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeValidateEvent', 'VAT Registration No.', false, false)]
    local procedure OnBeforeValidateVATRegistrationNo(var Rec: Record Vendor; var xRec: Record Vendor; CurrFieldNo: Integer)
    var
        Int: Integer;
        lText001: label '"%1" must start with country code like this "DK12345678".';
    begin
        begin
            //>> 11-02-21 ZY-LD 002
            Rec."VAT Registration No." := DelChr(Rec."VAT Registration No.", '=', ' ,.-;:_!"#¤%&/()=*/\<>');
            if Evaluate(Int, CopyStr(Rec."VAT Registration No.", 1, 1)) or Evaluate(Int, CopyStr(Rec."VAT Registration No.", 2, 1)) then
                Error(lText001, Rec.FieldCaption(Rec."VAT Registration No."));
            //<< 11-02-21 ZY-LD 002
        end;
    end;


    procedure GetFilterZyxelVendors(Type: Option HQ,EMEA; DifferenctFrom: Boolean) rValue: Text
    var
        recVendor: Record Vendor;
        lText001: label 'No Zyxel vendors was found.';
    begin
        //>> 25-11-20 ZY-LD 001
        if ZGT.IsRhq then begin
            case Type of
                Type::HQ:
                    recVendor.SetRange("SBU Company", recVendor."sbu company"::"ZCom HQ", recVendor."sbu company"::"ZNet HQ");
                Type::EMEA:
                    recVendor.SetRange("SBU Company", recVendor."sbu company"::"ZCom EMEA", recVendor."sbu company"::"ZNet EMEA");
            end;

            if recVendor.FindSet then
                repeat
                    if DifferenctFrom then
                        rValue += StrSubstNo('<>%1&', recVendor."No.")
                    else
                        rValue += StrSubstNo('%1|', recVendor."No.");
                until recVendor.Next() = 0;

            rValue := DelChr(rValue, '>', '&|');
            if rValue = '' then
                Error(lText001);
        end;
        //<< 25-11-20 ZY-LD 001
    end;

    [EventSubscriber(ObjectType::Report, Report::"Create Conts. from Vendors", 'OnBeforeContactInsert', '', false, false)]
    local procedure CreateContsfromVendors_OnBeforeContactInsert(Vendor: Record Vendor; var Contact: Record Contact)
    var
        RMSetup: Record "Marketing Setup";
    begin
        RMSetup.Get();
        if RMSetup."Use Cust and Vend No. for Cont" then
            Contact."No." := Vendor."No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VendCont-Update", 'OnBeforeOnInsert', '', false, false)]
    local procedure VendContUpdate_OnBeforeOnInsert(var IsHandled: Boolean)
    var
        RMSetup: Record "Marketing Setup";
    begin
        RMSetup.Get();
        if RMSetup."Use Cust and Vend No. for Cont" then
            IsHandled := true;
    end;

}
