XmlPort 50037 "WS Replicate G/L Account"
{
    // 001. 17-09-18 ZY-LD 000 - It's easyer for PP when RHQ G/L Account No. is filled.
    // 002. 03-01-19 ZY-LD 2019010310000064 - Hidden.
    // 003. 11-02-21 ZY-LD P0464 - Fixed Asset Account.
    // 004. 07-06-23 ZY-LD 000 - We don´t want to replicate "Freight Approval No." to al companies.

    DefaultNamespace = 'urn:microsoft-dynamics-nav/Replicate';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("G/L Account"; "G/L Account")
            {
                MinOccurs = Zero;
                XmlName = 'GlAccount';
                UseTemporary = true;
                fieldelement(No; "G/L Account"."No.")
                {
                }
                fieldelement(Name; "G/L Account".Name)
                {
                }
                fieldelement(SearchName; "G/L Account"."Search Name")
                {
                }
                fieldelement(AccountType; "G/L Account"."Account Type")
                {
                }
                fieldelement(GlobalDim1; "G/L Account"."Global Dimension 1 Code")
                {
                }
                fieldelement(GlobalDim2; "G/L Account"."Global Dimension 2 Code")
                {
                }
                fieldelement(IncomeBalance; "G/L Account"."Income/Balance")
                {
                }
                fieldelement(DebitCredit; "G/L Account"."Debit/Credit")
                {
                }
                fieldelement(No2; "G/L Account"."No. 2")
                {
                }
                fieldelement(Blocked; "G/L Account".Blocked)
                {
                }
                fieldelement(Hidden; "G/L Account".Hidden)
                {
                }
                fieldelement(DirectPosting; "G/L Account"."Direct Posting")
                {
                }
                fieldelement(NewPage; "G/L Account"."New Page")
                {
                }
                fieldelement(NoOfBlankLines; "G/L Account"."No. of Blank Lines")
                {
                }
                fieldelement(Indentation; "G/L Account".Indentation)
                {
                }
                fieldelement(LastDateMod; "G/L Account"."Last Date Modified")
                {
                }
                fieldelement(Totaling; "G/L Account".Totaling)
                {
                }
                fieldelement(ConsolTranslMethod; "G/L Account"."Consol. Translation Method")
                {
                }
                fieldelement(ConsolDebAcc; "G/L Account"."Consol. Debit Acc.")
                {
                }
                fieldelement(ConsolCredAcc; "G/L Account"."Consol. Credit Acc.")
                {
                }
                fieldelement(GenPostType; "G/L Account"."Gen. Posting Type")
                {
                }
                fieldelement(GenBusPostGrp; "G/L Account"."Gen. Bus. Posting Group")
                {
                }
                fieldelement(GenProdPostGrp; "G/L Account"."Gen. Prod. Posting Group")
                {
                }
                fieldelement(AutoExtText; "G/L Account"."Automatic Ext. Texts")
                {
                }
                fieldelement(TaxAreaCode; "G/L Account"."Tax Area Code")
                {
                }
                fieldelement(TaxLiable; "G/L Account"."Tax Liable")
                {
                }
                fieldelement(TaxGrpCode; "G/L Account"."Tax Group Code")
                {
                }
                fieldelement(VatBusPostGrp; "G/L Account"."VAT Bus. Posting Group")
                {
                }
                fieldelement(VatProdPostGrp; "G/L Account"."VAT Prod. Posting Group")
                {
                }
                fieldelement(ExchangeRateAdj; "G/L Account"."Exchange Rate Adjustment")
                {
                }
                fieldelement(DefaultIcParGlAccNo; "G/L Account"."Default IC Partner G/L Acc. No")
                {
                }
                fieldelement(OmitDefDesJnl; "G/L Account"."Omit Default Descr. in Jnl.")
                {
                }
                fieldelement(CostTypeNo; "G/L Account"."Cost Type No.")
                {
                }
                fieldelement(DefDefTempCode; "G/L Account"."Default Deferral Template Code")
                {
                }
                fieldelement(Name2; "G/L Account"."Name 2")
                {
                }
                fieldelement(SubGLAccountNo; "G/L Account"."RHQ G/L Account No.")
                {
                }
                fieldelement(SubGlAccountName; "G/L Account"."RHQ G/L Account Name")
                {
                }
                fieldelement(FixedAssetAccount; "G/L Account"."Fixed Asset Account (Concur)")
                {
                }
                tableelement("Default Dimension"; "Default Dimension")
                {
                    MinOccurs = Zero;
                    XmlName = 'DefaultDimension';
                    SourceTableView = where("Table ID" = const(15));
                    UseTemporary = true;
                    fieldelement(TableID; "Default Dimension"."Table ID")
                    {
                    }
                    fieldelement(DimNo; "Default Dimension"."No.")
                    {
                    }
                    fieldelement(DimCode; "Default Dimension"."Dimension Code")
                    {
                    }
                    fieldelement(DimValueCode; "Default Dimension"."Dimension Value Code")
                    {
                    }
                    fieldelement(ValuePosting; "Default Dimension"."Value Posting")
                    {
                    }
                    fieldelement(MultiSelectAction; "Default Dimension"."Multi Selection Action")
                    {
                    }
                    fieldelement(ForceUpdateInSub; "Default Dimension"."Force Update in Subsidary")
                    {
                    }

                    trigger OnPreXmlItem()
                    begin
                        "Default Dimension".SetRange("Table ID", 15);
                        "Default Dimension".SetRange("No.", "G/L Account"."No.");
                    end;
                }
            }
            tableelement("IC G/L Account"; "IC G/L Account")
            {
                MinOccurs = Zero;
                XmlName = 'ICGlAccount';
                UseTemporary = true;
                fieldelement(IcNo; "IC G/L Account"."No.")
                {
                }
                fieldelement(IcName; "IC G/L Account".Name)
                {
                }
                fieldelement(IcAccountType; "IC G/L Account"."Account Type")
                {
                }
                fieldelement(IcIncomeBalance; "IC G/L Account"."Income/Balance")
                {
                }
                fieldelement(IcBlocked; "IC G/L Account".Blocked)
                {
                }
                fieldelement(IcMapToGlAccount; "IC G/L Account"."Map-to G/L Acc. No.")
                {
                }
                fieldelement(IcIndentation; "IC G/L Account".Indentation)
                {
                }
            }
            tableelement(Dimension; Dimension)
            {
                MinOccurs = Zero;
                XmlName = 'Dimension';
                UseTemporary = true;
                fieldelement(DCode; Dimension.Code)
                {
                }
                fieldelement(DName; Dimension.Name)
                {
                }
                fieldelement(DDescription; Dimension.Description)
                {
                }
                fieldelement(DBlocked; Dimension.Blocked)
                {
                }
                fieldelement(DConsoladtionCode; Dimension."Consolidation Code")
                {
                }
                fieldelement(DMapToIcDim; Dimension."Map-to IC Dimension Code")
                {
                }
            }
            tableelement("Dimension Value"; "Dimension Value")
            {
                MinOccurs = Zero;
                XmlName = 'DimensionValue';
                UseTemporary = true;
                fieldelement(DvDimCode; "Dimension Value"."Dimension Code")
                {
                }
                fieldelement(DvCode; "Dimension Value".Code)
                {
                }
                fieldelement(DvName; "Dimension Value".Name)
                {
                }
                fieldelement(DvDimValue; "Dimension Value"."Dimension Value Type")
                {
                }
                fieldelement(DvTotaling; "Dimension Value".Totaling)
                {
                }
                fieldelement(DvBlocked; "Dimension Value".Blocked)
                {
                }
                fieldelement(DvConso; "Dimension Value"."Consolidation Code")
                {
                }
                fieldelement(DvIndentation; "Dimension Value".Indentation)
                {
                }
                fieldelement(DvGlobalDim1; "Dimension Value"."Global Dimension No.")
                {
                }
                fieldelement(DvMapToIcDimCode; "Dimension Value"."Map-to IC Dimension Code")
                {
                }
                fieldelement(DvMapToIcDimValue; "Dimension Value"."Map-to IC Dimension Value Code")
                {
                }
                fieldelement(DvDimValueID; "Dimension Value"."Dimension Value ID")
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

    var
        xAccountType: Integer;
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SetData(pNo: Code[20])
    var
        recGLAcc: Record "G/L Account";
        recICGLAcc: Record "IC G/L Account";
        recDefDim: Record "Default Dimension";
        recDim: Record Dimension;
        recDimValue: Record "Dimension Value";
        ICChartofAccPage: Page "IC Chart of Accounts";
        GLAccountIndent: Codeunit "G/L Account-Indent";
    begin
        if pNo <> '' then
            recGLAcc.SetRange("No.", pNo);

        if recGLAcc.FindSet then
            repeat
                "G/L Account" := recGLAcc;
                "G/L Account".Insert;

                recDefDim.SetRange("Table ID", Database::"G/L Account");
                recDefDim.SetRange("No.", recGLAcc."No.");
                if recDefDim.FindSet then
                    repeat
                        "Default Dimension" := recDefDim;
                        "Default Dimension".Insert;

                        if not Dimension.Get("Default Dimension"."Dimension Code") then begin
                            recDim.Get("Default Dimension"."Dimension Code");
                            Dimension := recDim;
                            Dimension.Insert;
                        end;
                    until recDefDim.Next() = 0;

                //>> 17-09-18 ZY-LD 001
                if recGLAcc."RHQ G/L Account No." = '' then begin
                    recGLAcc."RHQ G/L Account No." := recGLAcc."No.";
                    recGLAcc."RHQ G/L Account Name" := recGLAcc.Name;
                    recGLAcc.Modify;
                end;
            //<< 17-09-18 ZY-LD 001
            until recGLAcc.Next() = 0;

        if pNo = '' then begin
            CopyFromChartOfAccounts;
            IndentICAccount;

            if recICGLAcc.FindSet then
                repeat
                    "IC G/L Account" := recICGLAcc;
                    "IC G/L Account".Insert;
                until recICGLAcc.Next() = 0;
        end;

        Dimension.SetRange("Replicate Together with CoA", true);  // 07-06-23 ZY-LD 004
        if Dimension.FindSet then
            repeat
                recDimValue.SetRange("Dimension Code", Dimension.Code);
                if recDimValue.FindSet then
                    repeat
                        if not "Dimension Value".Get(recDimValue."Dimension Code", recDimValue.Code) then begin
                            "Dimension Value" := recDimValue;
                            "Dimension Value".Insert;
                        end;
                    until recDimValue.Next() = 0;
            until Dimension.Next() = 0;
    end;


    procedure ReplicateData()
    var
        recGLAcc: Record "G/L Account";
        recICGLAcc: Record "IC G/L Account";
        recDefDim: Record "Default Dimension";
        recDim: Record Dimension;
        recDimValue: Record "Dimension Value";
        recServEnviron: Record "Server Environment";
        lText001: label 'You are trying to import into a wrong table. Please change table no.';
    begin
        if "G/L Account".FindSet then
            repeat
                if recServEnviron.TurkishServer then begin  // Turkey
                    recGLAcc.SetRange("RHQ G/L Account No.", "G/L Account"."No.");
                    if recGLAcc.FindFirst then
                        repeat
                            recGLAcc."No. 2" := "G/L Account"."No. 2";
                            recGLAcc."RHQ G/L Account Name" := "G/L Account".Name;
                            recGLAcc."Name 2" := "G/L Account"."Name 2";
                            recGLAcc."Fixed Asset Account (Concur)" := "G/L Account"."Fixed Asset Account (Concur)";  // 11-02-21 ZY-LD 003
                            recGLAcc.Modify;

                            "Default Dimension".SetRange("Table ID", Database::"G/L Account");
                            "Default Dimension".SetRange("No.", "G/L Account"."No.");
                            if "Default Dimension".FindSet then
                                repeat
                                    if not recDefDim.Get("Default Dimension"."Table ID", recGLAcc."No.", "Default Dimension"."Dimension Code") then begin
                                        recDefDim := "Default Dimension";
                                        recDefDim."No." := recGLAcc."No.";
                                        recDefDim.Insert;
                                    end;
                                until "Default Dimension".Next() = 0;
                        until recGLAcc.Next() = 0;
                end else begin  // All other companies
                    if not recGLAcc.Get("G/L Account"."No.") then begin
                        recGLAcc.Init;
                        recGLAcc."No." := "G/L Account"."No.";
                        recGLAcc."No. 2" := "G/L Account"."No. 2";
                        recGLAcc.Name := "G/L Account".Name;
                        recGLAcc."Search Name" := "G/L Account"."Search Name";
                        recGLAcc."Account Type" := "G/L Account"."Account Type";
                        recGLAcc."Global Dimension 1 Code" := "G/L Account"."Global Dimension 1 Code";
                        recGLAcc."Global Dimension 2 Code" := "G/L Account"."Global Dimension 2 Code";
                        recGLAcc."Income/Balance" := "G/L Account"."Income/Balance";
                        recGLAcc."Debit/Credit" := "G/L Account"."Debit/Credit";
                        recGLAcc.Blocked := "G/L Account".Blocked;
                        recGLAcc.Hidden := "G/L Account".Hidden;  // 03-01-19 ZY-LD 002
                        recGLAcc."Direct Posting" := "G/L Account"."Direct Posting";
                        recGLAcc."Reconciliation Account" := "G/L Account"."Reconciliation Account";
                        recGLAcc."New Page" := "G/L Account"."New Page";
                        recGLAcc."No. of Blank Lines" := "G/L Account"."No. of Blank Lines";
                        recGLAcc.Indentation := "G/L Account".Indentation;
                        recGLAcc.Totaling := "G/L Account".Totaling;
                        recGLAcc."Consol. Translation Method" := "G/L Account"."Consol. Translation Method";
                        recGLAcc."Consol. Debit Acc." := "G/L Account"."Consol. Debit Acc.";
                        recGLAcc."Consol. Credit Acc." := "G/L Account"."Consol. Credit Acc.";
                        recGLAcc."Gen. Posting Type" := "G/L Account"."Gen. Posting Type";
                        recGLAcc."Gen. Bus. Posting Group" := "G/L Account"."Gen. Bus. Posting Group";
                        recGLAcc."Gen. Prod. Posting Group" := "G/L Account"."Gen. Prod. Posting Group";
                        recGLAcc."Automatic Ext. Texts" := "G/L Account"."Automatic Ext. Texts";
                        recGLAcc."Tax Area Code" := "G/L Account"."Tax Area Code";
                        recGLAcc."Tax Liable" := "G/L Account"."Tax Liable";
                        recGLAcc."Tax Group Code" := "G/L Account"."Tax Group Code";
                        recGLAcc."VAT Bus. Posting Group" := "G/L Account"."VAT Bus. Posting Group";
                        recGLAcc."VAT Prod. Posting Group" := "G/L Account"."VAT Prod. Posting Group";
                        recGLAcc."Default IC Partner G/L Acc. No" := "G/L Account"."Default IC Partner G/L Acc. No";
                        //recGLAcc."Cost Split Type" := "G/L Account"."Cost Split Type";
                        //recGLAcc."Cost Split Type Mandatory" := "G/L Account"."Cost Split Type Mandatory";
                        recGLAcc."Name 2" := "G/L Account"."Name 2";
                        //>> 17-09-18 ZY-LD 001
                        recGLAcc."RHQ G/L Account No." := "G/L Account"."No.";
                        recGLAcc."RHQ G/L Account Name" := "G/L Account".Name;
                        //<< 17-09-18 ZY-LD 001
                        recGLAcc."Fixed Asset Account (Concur)" := "G/L Account"."Fixed Asset Account (Concur)";  // 11-02-21 ZY-LD 003
                        recGLAcc.Insert;
                    end else begin
                        recGLAcc."No. 2" := "G/L Account"."No. 2";
                        recGLAcc.Name := "G/L Account".Name;
                        recGLAcc."Search Name" := "G/L Account"."Search Name";
                        recGLAcc."Account Type" := "G/L Account"."Account Type";
                        recGLAcc."Global Dimension 1 Code" := "G/L Account"."Global Dimension 1 Code";
                        recGLAcc."Global Dimension 2 Code" := "G/L Account"."Global Dimension 2 Code";
                        recGLAcc."Income/Balance" := "G/L Account"."Income/Balance";
                        recGLAcc."Debit/Credit" := "G/L Account"."Debit/Credit";
                        recGLAcc.Blocked := "G/L Account".Blocked;
                        recGLAcc.Hidden := "G/L Account".Hidden;  // 03-01-19 ZY-LD 002
                        recGLAcc."Direct Posting" := "G/L Account"."Direct Posting";
                        recGLAcc."Reconciliation Account" := "G/L Account"."Reconciliation Account";
                        recGLAcc."New Page" := "G/L Account"."New Page";
                        recGLAcc."No. of Blank Lines" := "G/L Account"."No. of Blank Lines";
                        recGLAcc.Indentation := "G/L Account".Indentation;
                        recGLAcc.Totaling := "G/L Account".Totaling;
                        recGLAcc."Budget Filter" := "G/L Account"."Budget Filter";
                        recGLAcc."Consol. Translation Method" := "G/L Account"."Consol. Translation Method";
                        recGLAcc."Consol. Debit Acc." := "G/L Account"."Consol. Debit Acc.";
                        recGLAcc."Consol. Credit Acc." := "G/L Account"."Consol. Credit Acc.";
                        recGLAcc."Business Unit Filter" := "G/L Account"."Business Unit Filter";
                        recGLAcc."Automatic Ext. Texts" := "G/L Account"."Automatic Ext. Texts";
                        recGLAcc."Default IC Partner G/L Acc. No" := "G/L Account"."Default IC Partner G/L Acc. No";
                        //recGLAcc."Cost Split Type" := "G/L Account"."Cost Split Type";
                        //recGLAcc."Cost Split Type Mandatory" := "G/L Account"."Cost Split Type Mandatory";
                        recGLAcc."Name 2" := "G/L Account"."Name 2";
                        //>> 17-09-18 ZY-LD 001
                        recGLAcc."RHQ G/L Account No." := "G/L Account"."No.";
                        recGLAcc."RHQ G/L Account Name" := "G/L Account".Name;
                        //<< 17-09-18 ZY-LD 001
                        recGLAcc."Fixed Asset Account (Concur)" := "G/L Account"."Fixed Asset Account (Concur)";  // 11-02-21 ZY-LD 003
                        recGLAcc.Modify;
                    end;

                    "Default Dimension".SetRange("Table ID", Database::"G/L Account");
                    "Default Dimension".SetRange("No.", "G/L Account"."No.");
                    if "Default Dimension".FindSet then
                        repeat
                            if not recDefDim.Get("Default Dimension"."Table ID", "Default Dimension"."No.", "Default Dimension"."Dimension Code") then begin
                                recDefDim := "Default Dimension";
                                recDefDim.Insert;
                            end else begin
                                if "Default Dimension"."Force Update in Subsidary" or recDefDim."Force Update in Subsidary" then begin
                                    recDefDim := "Default Dimension";
                                    recDefDim.Modify;
                                end;
                            end;
                        until "Default Dimension".Next() = 0;
                end;
            until "G/L Account".Next() = 0;

        if Dimension.FindSet then
            repeat
                if not recDim.Get(Dimension.Code) then begin
                    recDim := Dimension;
                    recDim.Insert;
                end;

                "Dimension Value".SetRange("Dimension Code", Dimension.Code);
                if "Dimension Value".FindSet then
                    repeat
                        if not recDimValue.Get("Dimension Value"."Dimension Code", "Dimension Value".Code) then begin
                            recDimValue := "Dimension Value";
                            recDimValue.Insert;
                        end;
                    until "Dimension Value".Next() = 0;
            until Dimension.Next() = 0;

        // In Italian and Tyrkish Navision the tables must be replaced with 50033
        //if ZGT.ItalianServer or ZGT.TurkishServer then  // 06-02-24 ZY-LD 
        if ZGT.TurkishServer then  // 06-02-24 ZY-LD 
            if recICGLAcc.TableName = "IC G/L Account".TableName then
                Error(lText001);

        if "IC G/L Account".FindSet then
            repeat
                // In Turkey we will use the local Turkish account, but only if it's one to one.
                if ZGT.TurkishServer then begin
                    recGLAcc.SetRange("RHQ G/L Account No.", "IC G/L Account"."No.");
                    if recGLAcc.Count = 1 then begin
                        recGLAcc.FindFirst;
                        "IC G/L Account"."Map-to G/L Acc. No." := recGLAcc."No.";
                    end else
                        "IC G/L Account"."Map-to G/L Acc. No." := '';
                end;

                if recICGLAcc.Get("IC G/L Account"."No.") then begin
                    if "IC G/L Account"."Map-to G/L Acc. No." <> recICGLAcc."Map-to G/L Acc. No." then begin
                        recICGLAcc.TransferFields("IC G/L Account");
                        recICGLAcc.Modify;
                    end;
                end else begin
                    recICGLAcc.TransferFields("IC G/L Account");
                    recICGLAcc.Insert;
                end;
            until "IC G/L Account".Next() = 0;
    end;

    local procedure CopyFromChartOfAccounts()
    var
        GLAccount: Record "G/L Account";
        ICAccount: Record "IC G/L Account";
        PrevIndentation: Integer;
    begin
        //Copied from Page 605
        ICAccount.LockTable();
        if GLAccount.Find('-') then
            repeat
                if GLAccount."Account Type" = GLAccount."Account Type"::"End-Total" then
                    PrevIndentation := PrevIndentation - 1;
                if (not GLAccount.Blocked) and (not ICAccount.GET(GLAccount."No.")) then begin
                    ICAccount.Init();
                    ICAccount."No." := GLAccount."No.";
                    ICAccount.Name := GLAccount.Name;
                    ICAccount."Account Type" := GLAccount."Account Type";
                    ICAccount."Income/Balance" := GLAccount."Income/Balance";
                    ICAccount.Validate(Indentation, PrevIndentation);
                    //>> 04-09-18 ZY-LD 001
                    //Remember to change in ICChartofAccounts_OnCopyFromChartOfAccountsOnBeforeICGLAccInsert in Codeunit 50085 "General Ledger Event" if new changes are made
                    IF ZGT.IsRhq THEN
                        ICAccount."Map-to G/L Acc. No." := ICAccount."No.";
                    //<< 04-09-18 ZY-LD 001

                    ICAccount.Insert();
                end;
                PrevIndentation := GLAccount.Indentation;
                if GLAccount."Account Type" = GLAccount."Account Type"::"Begin-Total" then
                    PrevIndentation := PrevIndentation + 1;
            until GLAccount.Next() = 0;
    end;


    local procedure IndentICAccount()
    var
        ICGLAcc: Record "IC G/L Account";
        i: Integer;
        Text005: Label 'End-Total %1 is missing a matching Begin-Total.';
    begin
        //Copy from Codeunit 3, Status Windows removed
        with ICGLAcc do
            if Find('-') then
                repeat

                    if "Account Type" = "Account Type"::"End-Total" then begin
                        if i < 1 then
                            Error(
                              Text005,
                              "No.");
                        i := i - 1;
                    end;

                    Validate(Indentation, i);
                    Modify();

                    if "Account Type" = "Account Type"::"Begin-Total" then begin
                        i := i + 1;
                    end;
                until Next() = 0;
    end;
}
