XmlPort 50012 "WS Use of Report"
{
    Caption = 'WS Use of Report';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/useofreport';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Use of Report Entry"; "Use of Report Entry")
            {
                MinOccurs = Zero;
                XmlName = 'UseOfReport';
                UseTemporary = true;
                fieldelement(CompanyName; "Use of Report Entry"."Company Name")
                {
                }
                fieldelement(ObjectType; "Use of Report Entry"."Object Type")
                {
                }
                fieldelement(ObjectId; "Use of Report Entry"."Object Id")
                {
                }
                fieldelement(ObjectDescription; "Use of Report Entry"."Object Description 2")
                {
                }
                fieldelement(UserId; "Use of Report Entry"."User Id")
                {
                }
                fieldelement(Date; "Use of Report Entry".Date)
                {
                }
                fieldelement(ReportType; "Use of Report Entry"."Report Type")
                {
                }
                fieldelement(Month; "Use of Report Entry".Month)
                {
                }
                fieldelement(Year; "Use of Report Entry".Year)
                {
                }
                fieldelement(Quantity; "Use of Report Entry".Quantity)
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
        SI: Codeunit "Single Instance";


    procedure SetData(var pUseOfReportTmp: Record "Use of Report Entry" temporary): Boolean
    begin
        if pUseOfReportTmp.FindSet then
            repeat
                "Use of Report Entry" := pUseOfReportTmp;
                "Use of Report Entry".Insert;
            until pUseOfReportTmp.Next() = 0;

        exit(true);
    end;


    procedure InsertData()
    var
        recUseofRep: Record "Use of Report Entry";
        recAutoSetup: Record "Automation Setup";
        SI: Codeunit "Single Instance";
    begin
        SI.InsertUseOfReport("Use of Report Entry");
        /*recAutoSetup.GET;
        IF recAutoSetup."Register Use of Report" THEN
          IF "Use of Report Entry".FINDSET THEN
            REPEAT
              recUseofRep.SETRANGE("Company Name","Use of Report Entry"."Company Name");
              recUseofRep.SETRANGE("Object Type","Use of Report Entry"."Object Type");
              recUseofRep.SETRANGE("Object Id","Use of Report Entry"."Object Id");
              recUseofRep.SETRANGE("User Id","Use of Report Entry"."User Id");
              recUseofRep.SETRANGE(Month,"Use of Report Entry".Month);
              recUseofRep.SETRANGE(Year,"Use of Report Entry".Year);
              IF recUseofRep.FINDFIRST THEN BEGIN
                recUseofRep.Quantity += "Use of Report Entry".Quantity;
                recUseofRep.MODIFY;
              END ELSE BEGIN
                CLEAR(recUseofRep);
                recUseofRep.RESET;
                recUseofRep.TRANSFERFIELDS("Use of Report Entry");
                recUseofRep."Entry No." := 0;
                recUseofRep.INSERT;
              END;
            UNTIL "Use of Report Entry".Next() = 0;*/

    end;
}
