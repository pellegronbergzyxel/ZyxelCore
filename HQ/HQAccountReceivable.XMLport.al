XmlPort 50018 "HQ Account Receivable"
{
    Caption = 'HQ Account Receivable';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/ar';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Account Pay./Receiv Buffer"; "Account Pay./Receiv Buffer")
            {
                MinOccurs = Zero;
                XmlName = 'AccountReceivable';
                UseTemporary = true;
                fieldelement(Subsidary; "Account Pay./Receiv Buffer"."HQ Company Name")
                {
                }
                fieldelement(Customer; "Account Pay./Receiv Buffer"."Source Name")
                {
                }
                fieldelement(CurrencyCode; "Account Pay./Receiv Buffer"."TXN Currency Code")
                {
                }
                fieldelement(PaymentTerms; "Account Pay./Receiv Buffer"."Payment Terms")
                {
                }
                fieldelement(Balance; "Account Pay./Receiv Buffer"."TXN Ending Balance")
                {
                }
                fieldelement(NotDueBalance; "Account Pay./Receiv Buffer"."Not Due Balance")
                {
                }
                fieldelement(DueBalance; "Account Pay./Receiv Buffer"."Due Balance")
                {
                }
                fieldelement(Over90DaysBalance; "Account Pay./Receiv Buffer"."Due Balance over XX Days")
                {
                }
                fieldelement(DueCurrentMonth; "Account Pay./Receiv Buffer"."Due Balance Curr. Month")
                {
                }
                fieldelement(DueCurrMonthPlus1; "Account Pay./Receiv Buffer"."Due Balance Curr. Month Pl. 1")
                {
                }
                fieldelement(DueCurrMonthPlus2; "Account Pay./Receiv Buffer"."Due Balance Curr. Month Pl. 2")
                {
                }
                fieldelement(DueCurrMonthPlus3; "Account Pay./Receiv Buffer"."Due Balance Curr. Month Pl. 3")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }


    procedure SetData()
    var
        recAccReceivTmp: Record "Account Pay./Receiv Buffer" temporary;
        repAccRecDet: Report "HQ Account Receivable Details";
        FileMgt: Codeunit "File Management";
        ServerFilename: Text;
    begin
        ServerFilename := FileMgt.ServerTempFileName('');
        // Get account receivable from all companies in either ZCom or ZNet.
        repAccRecDet.InitReqest(Today, 1);
        repAccRecDet.SaveAsExcel(ServerFilename);
        repAccRecDet.GetData(recAccReceivTmp);

        // Merge the columns, because HQ needs it in another format.
        if recAccReceivTmp.FindSet then begin
            repeat
                "Account Pay./Receiv Buffer".SetRange("Company Name", recAccReceivTmp."Company Name");
                "Account Pay./Receiv Buffer".SetRange("Source No.", recAccReceivTmp."Source No.");
                "Account Pay./Receiv Buffer".SetRange("TXN Currency Code", recAccReceivTmp."TXN Currency Code");
                "Account Pay./Receiv Buffer".SetRange("Payment Terms", recAccReceivTmp."Payment Terms");
                if not "Account Pay./Receiv Buffer".FindFirst then begin
                    Clear("Account Pay./Receiv Buffer");
                    "Account Pay./Receiv Buffer".Init;
                    "Account Pay./Receiv Buffer"."Entry No." := recAccReceivTmp."Entry No.";
                    "Account Pay./Receiv Buffer"."Company Name" := recAccReceivTmp."Company Name";
                    "Account Pay./Receiv Buffer"."HQ Company Name" := recAccReceivTmp."HQ Company Name";
                    "Account Pay./Receiv Buffer"."Source No." := recAccReceivTmp."Source No.";
                    "Account Pay./Receiv Buffer"."Source Name" := recAccReceivTmp."Source Name";
                    "Account Pay./Receiv Buffer"."TXN Currency Code" := recAccReceivTmp."TXN Currency Code";
                    "Account Pay./Receiv Buffer"."Payment Terms" := recAccReceivTmp."Payment Terms";
                    "Account Pay./Receiv Buffer".Insert;
                end;

                "Account Pay./Receiv Buffer"."TXN Ending Balance" += recAccReceivTmp."TXN Ending Balance";
                if recAccReceivTmp."Due Date" <= Today then begin
                    "Account Pay./Receiv Buffer"."Due Balance" += recAccReceivTmp."TXN Ending Balance";
                    if Today - recAccReceivTmp."Due Date" > 90 then
                        "Account Pay./Receiv Buffer"."Due Balance over XX Days" += recAccReceivTmp."TXN Ending Balance";
                end else begin
                    "Account Pay./Receiv Buffer"."Not Due Balance" += recAccReceivTmp."TXN Ending Balance";

                    if (recAccReceivTmp."Due Date" >= CalcDate('<-CM>', Today)) and
                        (recAccReceivTmp."Due Date" <= CalcDate('<CM>', Today))
                    then
                        "Account Pay./Receiv Buffer"."Due Balance Curr. Month" += recAccReceivTmp."TXN Ending Balance"
                    else
                        if (recAccReceivTmp."Due Date" >= CalcDate('<-CM+1M>', Today)) and
                            (recAccReceivTmp."Due Date" <= CalcDate('<1M+CM>', Today))
                        then
                            "Account Pay./Receiv Buffer"."Due Balance Curr. Month Pl. 1" += recAccReceivTmp."TXN Ending Balance"
                        else
                            if (recAccReceivTmp."Due Date" >= CalcDate('<-CM+2M>', Today)) and
                                (recAccReceivTmp."Due Date" <= CalcDate('<2M+CM>', Today))
                            then
                                "Account Pay./Receiv Buffer"."Due Balance Curr. Month Pl. 2" += recAccReceivTmp."TXN Ending Balance"
                            else
                                if (recAccReceivTmp."Due Date" >= CalcDate('<-CM+3M>', Today)) and
                                    (recAccReceivTmp."Due Date" <= CalcDate('<3M+CM>', Today))
                                then
                                    "Account Pay./Receiv Buffer"."Due Balance Curr. Month Pl. 3" += recAccReceivTmp."TXN Ending Balance";
                end;
                "Account Pay./Receiv Buffer".Modify;
            until recAccReceivTmp.Next() = 0;

            "Account Pay./Receiv Buffer".Reset;
        end;

        // Delete the file. We don´t need it.
        FileMgt.DeleteServerFile(ServerFilename);
    end;
}
