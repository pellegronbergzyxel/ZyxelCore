table 76120 "User Setup Line"
{
    fields
    {
        field(1; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = "User Setup";
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Location (quantity increase),Location (quantity decrease),Bank Account,General Journal,Item Journal,BOM Journal,Resource Journal,Job Journal,Intrastat Journal,FA Journal,Insurance Journal,FA Reclass. Journal,Req. Worksheet,VAT Statement,Purchase Adv. Payments,Sales Adv. Payments,Whse. Journal,Whse. Worksheet,Payment Order,Bank Statement,Whse. Net Change Templates,Release Location (quantity increase),Release Location (quantity decrease),Tool Journal';
            OptionMembers = "Location (quantity increase)","Location (quantity decrease)","Bank Account","General Journal","Item Journal","BOM Journal","Resource Journal","Job Journal","Intrastat Journal","FA Journal","Insurance Journal","FA Reclass. Journal","Req. Worksheet","VAT Statement","Purchase Adv. Payments","Sales Adv. Payments","Whse. Journal","Whse. Worksheet","Paym. Order","Bank Stmt","Whse. Net Change Templates","Release Location (quantity increase)","Release Location (quantity decrease)","Tool Journal";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Code / Name"; Code[20])
        {
            Caption = 'Code / Name';

            trigger OnLookup()
            var
                lreLocation: Record Location;
                lreBankAcc: Record "Bank Account";
                lreGenLnlTemplate: Record "Gen. Journal Template";
                lreItemJnlTemplate: Record "Item Journal Template";
                lreBOMJnlTemplate: Record "Item Journal Template";
                lreResJnlTemplate: Record "Res. Journal Template";
                lreJobJnlTemplate: Record "Job Journal Template";
                lreFAJnlTemplate: Record "FA Journal Template";
                lreInsuranceJnlTemplate: Record "Insurance Journal Template";
                lreFAReclassJnlTemplate: Record "FA Reclass. Journal Template";
                lreReqestWkshTemplate: Record "Req. Wksh. Template";
                lreVATStatementTemplate: Record "VAT Statement Template";
                lreWhseJournalTemplate: Record "Warehouse Journal Template";
                lreWhseSheetTemplate: Record "Whse. Worksheet Template";
                lreBankingSetup: Record "Banking Setup";
                lreWhseNetChangeTemplate: Record "Whse. Net Change Template";
            begin
                //15-51643 - needs rework
                /*
               CASE Type OF
                 Type::"Location (quantity increase)",Type::"Location (quantity decrease)",
                 Type::"Release Location (quantity increase)",Type::"Release Location (quantity decrease)":
                   IF FORM.RUNMODAL(0,lreLocation) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreLocation.Code);

                   Type::"Bank Account":
                   IF FORM.RUNMODAL(0,lreBankAcc) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreBankAcc."No.");

                 Type::"General Journal":
                   IF FORM.RUNMODAL(0,lreGenLnlTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreGenLnlTemplate.Name);

                 Type::"Item Journal":
                   IF FORM.RUNMODAL(0,lreItemJnlTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreItemJnlTemplate.Name);
               //15-51643 - Table 88 no longer in database
               //  Type::"BOM Journal":
               //    IF FORM.RUNMODAL(0,lreBOMJnlTemplate) = ACTION::LookupOK THEN
               //      VALIDATE("Code / Name",lreBOMJnlTemplate.Name);
               //15-51643 +
                 Type::"Resource Journal":
                   IF FORM.RUNMODAL(0,lreResJnlTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreResJnlTemplate.Name);

                 Type::"Job Journal":
                   IF FORM.RUNMODAL(0,lreJobJnlTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreJobJnlTemplate.Name);

                 Type::"Intrastat Journal":
                   IF FORM.RUNMODAL(0,lreIntrastatJnlTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreIntrastatJnlTemplate.Name);

                 Type::"FA Journal":
                   IF FORM.RUNMODAL(0,lreFAJnlTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreFAJnlTemplate.Name);

                 Type::"Insurance Journal":
                   IF FORM.RUNMODAL(0,lreInsuranceJnlTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreInsuranceJnlTemplate.Name);

                 Type::"FA Reclass. Journal":
                   IF FORM.RUNMODAL(0,lreFAReclassJnlTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreFAReclassJnlTemplate.Name);


                 Type::"Req. Worksheet":
                   IF FORM.RUNMODAL(0,lreReqestWkshTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreReqestWkshTemplate.Name);

                 Type::"VAT Statement":
                   IF FORM.RUNMODAL(0,lreVATStatementTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreVATStatementTemplate.Name);

                 Type::"Whse. Journal":
                   IF FORM.RUNMODAL(0,lreWhseJournalTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreWhseJournalTemplate.Name);

                 Type::"Whse. Worksheet":
                   IF FORM.RUNMODAL(0,lreWhseSheetTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreWhseSheetTemplate.Name);

                 //ES4.10: Automatic Banking;
                 Type::"Paym. Order" :
                   IF FORM.RUNMODAL(0, lreBankingSetup) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name", lreBankingSetup."Bank Account No.");

                 Type::"Bank Stmt" :
                   IF FORM.RUNMODAL(0, lreBankingSetup) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name", lreBankingSetup."Bank Account No.");
                 //ES4.10

                 //EZ4.30: Purchase advanced payment;
                 Type::"Purchase Adv. Payments":
                   IF FORM.RUNMODAL(0,lrePurchPaymentTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lrePurchPaymentTemplate.Name);
                 //EZ4.30

                 //EZ4.20: Sales advanced payment;
                 Type::"Sales Adv. Payments":
                   IF FORM.RUNMODAL(0,lreSalesPaymentTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreSalesPaymentTemplate.Name);
                 //EZ4.20

                 //CO4.20: Controling - Basic: Whse. Net Change Templates;
                 Type::"Whse. Net Change Templates":
                   IF FORM.RUNMODAL(0,lreWhseNetChangeTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreWhseNetChangeTemplate.Name);
                 //CO4.20
                 //PT4.00: Production Tools;
                 Type::"Tool Journal":
                   IF FORM.RUNMODAL(0,lreToolJnlTemplate) = ACTION::LookupOK THEN
                     VALIDATE("Code / Name",lreToolJnlTemplate.Name);
                 //PT4.00

               END;
               */
            end;
        }
    }

    keys
    {
        key(Key1; "User ID", Type, "Line No.")
        {
            Clustered = true;
        }
    }
}
