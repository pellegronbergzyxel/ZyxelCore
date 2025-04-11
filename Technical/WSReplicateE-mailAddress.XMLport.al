XmlPort 50050 "WS Replicate E-mail Address"
{
    // 001. 22-11-19 ZY-LD 2019112110000029 - Bill-to Customer No. is added.
    // 002. 04-12-19 ZY-LD 000 - Footer information was missing.

    Caption = 'WS Replicate E-mail Address';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/Replicate';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("E-mail address"; "E-mail address")
            {
                MinOccurs = Zero;
                XmlName = 'EmailAddress';
                UseTemporary = true;
                fieldelement(Code; "E-mail address".Code)
                {
                }
                fieldelement(Description; "E-mail address".Description)
                {
                }
                fieldelement(Recipients; "E-mail address".Recipients)
                {
                }
                fieldelement(Subject; "E-mail address".Subject)
                {
                }
                fieldelement(HtmlFormatted; "E-mail address"."Html Formatted")
                {
                }
                fieldelement(Bcc; "E-mail address".BCC)
                {
                }
                fieldelement(DocumentUsage; "E-mail address"."Document Usage")
                {
                }
                fieldelement(HtmlFile; "E-mail address"."E-mail HTML file")
                {
                }
                fieldelement(ColorScheme; "E-mail address"."Color Scheme")
                {
                }
                tableelement("E-mail Address Subject"; "E-mail Address Subject")
                {
                    LinkFields = "E-mail Address Code" = field(Code);
                    LinkTable = "E-mail address";
                    MinOccurs = Zero;
                    XmlName = 'EmailAddSubject';
                    UseTemporary = true;
                    fieldelement(sEmailAddCode; "E-mail Address Subject"."E-mail Address Code")
                    {
                    }
                    fieldelement(sLanguageCode; "E-mail Address Subject"."Language Code")
                    {
                    }
                    fieldelement(sBillToCustNo; "E-mail Address Subject"."Sell-to Customer No.")
                    {
                    }
                    fieldelement(sSubject; "E-mail Address Subject".Subject)
                    {
                    }
                }
                tableelement("E-mail address Body"; "E-mail address Body")
                {
                    LinkFields = "E-mail Address Code" = field(Code);
                    LinkTable = "E-mail address";
                    MinOccurs = Zero;
                    XmlName = 'EmailAddBody';
                    UseTemporary = true;
                    fieldelement(bEmailAddCode; "E-mail address Body"."E-mail Address Code")
                    {
                    }
                    fieldelement(bLanguageCode; "E-mail address Body"."Language Code")
                    {
                    }
                    fieldelement(bLineNo; "E-mail address Body"."Line No.")
                    {
                    }
                    fieldelement(bBodyText; "E-mail address Body"."Body Text")
                    {
                    }
                }
                tableelement("E-mail HTML files"; "E-mail HTML files")
                {
                    MinOccurs = Zero;
                    XmlName = 'EmailHtmlFile';
                    UseTemporary = true;
                    fieldelement(hCode; "E-mail HTML files".Code)
                    {
                    }
                    fieldelement(hFilename; "E-mail HTML files".Filename)
                    {
                    }
                }
                tableelement("E-mail HTML Color Schemes"; "E-mail HTML Color Schemes")
                {
                    MinOccurs = Zero;
                    XmlName = 'EmailHtmlColor';
                    UseTemporary = true;
                    fieldelement(cCode; "E-mail HTML Color Schemes".Code)
                    {
                    }
                    fieldelement(cRvalue; "E-mail HTML Color Schemes"."R Value")
                    {
                    }
                    fieldelement(cGvalue; "E-mail HTML Color Schemes"."G Value")
                    {
                    }
                    fieldelement(cBvalue; "E-mail HTML Color Schemes"."B Value")
                    {
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
        Text001: label 'You are not allowed to replicate "%1" to "%2".';


    procedure SetData(pCode: Code[20])
    var
        recEmailAdd: Record "E-mail address";
        recEmailAddSubj: Record "E-mail Address Subject";
        recEmailAddBody: Record "E-mail address Body";
        recEmailHTMLFile: Record "E-mail HTML files";
        recEmailHTMLColor: Record "E-mail HTML Color Schemes";
    begin
        recEmailAdd.SetRange("Do Not Replicate", false);
        if recEmailAdd.Get(pCode) then begin
            "E-mail address" := recEmailAdd;
            "E-mail address".Insert;

            recEmailAddSubj.SetRange("E-mail Address Code", recEmailAdd.Code);
            if recEmailAddSubj.FindSet then
                repeat
                    "E-mail Address Subject" := recEmailAddSubj;
                    "E-mail Address Subject".Insert;
                until recEmailAddSubj.Next() = 0;

            recEmailAddBody.SetRange("E-mail Address Code", recEmailAdd.Code);
            if recEmailAddBody.FindSet then
                repeat
                    "E-mail address Body" := recEmailAddBody;
                    "E-mail address Body".Insert;
                until recEmailAddBody.Next() = 0;

            if recEmailHTMLFile.Get(recEmailAdd."E-mail HTML file") then
                if not "E-mail HTML files".Get(recEmailAdd."E-mail HTML file") then begin
                    "E-mail HTML files" := recEmailHTMLFile;
                    if not "E-mail HTML files".Insert then;
                end;

            recEmailHTMLColor.SetRange(Code, recEmailAdd."Color Scheme");
            if recEmailHTMLColor.FindSet then
                repeat
                    "E-mail HTML Color Schemes" := recEmailHTMLColor;
                    if not "E-mail HTML Color Schemes".Insert then;
                until recEmailHTMLColor.Next() = 0;
        end;
    end;


    procedure ReplicateData()
    var
        recEmailAdd: Record "E-mail address";
        recEmailAddSubj: Record "E-mail Address Subject";
        recEmailAddBody: Record "E-mail address Body";
        recEmailHTMLFile: Record "E-mail HTML files";
        recEmailHTMLColor: Record "E-mail HTML Color Schemes";
    begin
        if "E-mail address".FindSet then
            repeat
                if recEmailAdd.Get("E-mail address".Code) then begin
                    if not recEmailAdd.Replicated then
                        Error(Text001, "E-mail address".Code, CompanyName());

                    recEmailAdd.Description := "E-mail address".Description;
                    recEmailAdd.Recipients := "E-mail address".Recipients;
                    recEmailAdd.Subject := "E-mail address".Subject;
                    recEmailAdd."Html Formatted" := "E-mail address"."Html Formatted";
                    recEmailAdd.BCC := "E-mail address".BCC;
                    recEmailAdd."Document Usage" := "E-mail address"."Document Usage";
                    //>> 04-12-19 ZY-LD 002
                    recEmailAdd."E-mail HTML file" := "E-mail address"."E-mail HTML file";
                    recEmailAdd."Color Scheme" := "E-mail address"."Color Scheme";
                    recEmailAdd."Footer E-Mail" := "E-mail address"."Footer E-Mail";
                    //<< 04-12-19 ZY-LD 002
                    recEmailAdd.Replicated := true;
                    recEmailAdd.Modify(true);
                end else begin
                    recEmailAdd := "E-mail address";
                    recEmailAdd.Replicated := true;
                    recEmailAdd.Insert(true);
                end;

                recEmailAddSubj.SetRange("E-mail Address Code", "E-mail address".Code);
                recEmailAddSubj.DeleteAll(true);
                recEmailAddSubj.SetRange("E-mail Address Code");
                "E-mail Address Subject".SetRange("E-mail Address Code", "E-mail address".Code);
                if "E-mail Address Subject".FindSet then
                    repeat
                        recEmailAddSubj := "E-mail Address Subject";
                        recEmailAddSubj.Insert(true);
                    until "E-mail Address Subject".Next() = 0;

                recEmailAddBody.SetRange("E-mail Address Code", "E-mail address".Code);
                recEmailAddBody.DeleteAll(true);
                recEmailAddBody.SetRange("E-mail Address Code");
                "E-mail address Body".SetRange("E-mail Address Code", "E-mail address".Code);
                if "E-mail address Body".FindSet then
                    repeat
                        recEmailAddBody := "E-mail address Body";
                        recEmailAddBody.Insert(true);
                    until "E-mail address Body".Next() = 0;
            until "E-mail address".Next() = 0;

        if "E-mail HTML files".FindSet then
            repeat
                recEmailHTMLFile := "E-mail HTML files";
                if not recEmailHTMLFile.Modify then
                    recEmailHTMLFile.Insert;
            until "E-mail HTML files".Next() = 0;

        if "E-mail HTML Color Schemes".FindSet then
            repeat
                recEmailHTMLColor := "E-mail HTML Color Schemes";
                if not recEmailHTMLColor.Modify then
                    recEmailHTMLColor.Insert;
            until "E-mail HTML Color Schemes".Next() = 0;
    end;
}
