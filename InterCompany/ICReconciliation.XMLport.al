XmlPort 50006 "IC Reconciliation"
{
    Caption = 'IC Reconciliation';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/IcRecon';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("IC Reconciliation Name"; "IC Reconciliation Name")
            {
                MinOccurs = Zero;
                XmlName = 'IcReconName';
                UseTemporary = true;
                fieldelement(StateTempName; "IC Reconciliation Name"."Reconciliation Template Name")
                {
                }
                fieldelement(Name; "IC Reconciliation Name".Name)
                {
                }
                fieldelement(Description; "IC Reconciliation Name".Description)
                {
                }
                textelement(ReportingCurrency)
                {
                }
                tableelement("IC Reconciliation Line"; "IC Reconciliation Line")
                {
                    LinkFields = "Reconciliation Template Name" = field("Reconciliation Template Name"), "Reconciliation Name" = field(Name);
                    LinkTable = "IC Reconciliation Name";
                    MinOccurs = Zero;
                    XmlName = 'IcReconLine';
                    UseTemporary = true;
                    fieldelement(TemplateName; "IC Reconciliation Line"."Reconciliation Template Name")
                    {
                    }
                    fieldelement(BatchName; "IC Reconciliation Line"."Reconciliation Name")
                    {
                    }
                    fieldelement(LineNo; "IC Reconciliation Line"."Line No.")
                    {
                    }
                    fieldelement(RowNo; "IC Reconciliation Line"."Row No.")
                    {
                    }
                    fieldelement(Type; "IC Reconciliation Line".Type)
                    {
                    }
                    fieldelement(Totaling; "IC Reconciliation Line".Totaling)
                    {
                    }
                    fieldelement(RowTotaling; "IC Reconciliation Line"."Row Totaling")
                    {
                    }
                    fieldelement(AmountType; "IC Reconciliation Line"."Amount Type")
                    {
                    }
                    textelement(StartDateText)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            if StartDateText <> '' then begin
                                Evaluate(DD, CopyStr(StartDateText, 9, 2));
                                Evaluate(MM, CopyStr(StartDateText, 6, 2));
                                Evaluate(YYYY, CopyStr(StartDateText, 1, 4));
                                StartDate := Dmy2date(DD, MM, YYYY);
                            end;

                        end;
                    }
                    textelement(EndDateText)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            if EndDateText <> '' then begin
                                Evaluate(DD, CopyStr(EndDateText, 9, 2));
                                Evaluate(MM, CopyStr(EndDateText, 6, 2));
                                Evaluate(YYYY, CopyStr(EndDateText, 1, 4));
                                EndDate := Dmy2date(DD, MM, YYYY);
                            end;
                        end;
                    }
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
        StartDate: Date;
        EndDate: Date;
        DD: Integer;
        MM: Integer;
        YYYY: Integer;
        ZGT: Codeunit "ZyXEL General Tools";


    procedure SetData(IcreconName: Record "IC Reconciliation Name"; IcReconLine: Record "IC Reconciliation Line"; pStartDate: Date; pEndDate: Date; var pReportingCurrency: Code[10])
    begin
        "IC Reconciliation Name" := IcreconName;
        "IC Reconciliation Name".Insert;
        "IC Reconciliation Line" := IcReconLine;
        "IC Reconciliation Line".Insert;

        StartDateText := Format(pStartDate, 0, 9);
        EndDateText := Format(pEndDate, 0, 9);
        ReportingCurrency := pReportingCurrency;
    end;


    procedure GetData() rValue: Text
    var
        repIcRecon: Report "IC Reconciliation";
        lStartDate: Date;
        lEndDate: Date;
        TotalAmount: Decimal;
    begin
        if not "IC Reconciliation Name".FindFirst then
            Clear("IC Reconciliation Name");

        if "IC Reconciliation Line".FindSet then
            repeat
                if (StartDate <> 0D) or (EndDate <> 0D) then
                    "IC Reconciliation Line".SetRange("Date Filter", StartDate, EndDate);
                repIcRecon.InitializeRequest("IC Reconciliation Name", "IC Reconciliation Line", ReportingCurrency);
                repIcRecon.CalcLineTotal("IC Reconciliation Line", TotalAmount, 0);
                rValue := repIcRecon.FinalizeRequest + Format(TotalAmount, 0, 9);
            until "IC Reconciliation Line".Next() = 0;
    end;
}
