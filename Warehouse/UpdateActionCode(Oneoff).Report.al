Report 50076 "Update Action Code (One off)"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Action Codes"; "Action Codes")
        {
            dataitem("Default Action"; "Default Action")
            {
                DataItemLink = "Action Code" = field(Code);

                trigger OnAfterGetRecord()
                begin
                    "Default Action"."Comment Type" := "Action Codes"."Default Comment Type";
                    "Default Action".Modify;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Action Codes".Code, 0, true);

                if (StrPos(UpperCase("Action Codes".Description), 'PRE-ADV') <> 0) and
                   (StrPos("Action Codes".Description, '@') <> 0)
                then begin
                    "Action Codes"."Default Comment Type" := "Action Codes"."default comment type"::"E-mail Notification (Pre-Adv)";
                    "Action Codes"."Original Description" := "Action Codes".Description;
                    "Action Codes".Description := ConvertStr("Action Codes".Description, '&', ';');
                    "Action Codes".Description := CopyStr("Action Codes".Description, StrPos("Action Codes".Description, ':'), StrLen("Action Codes".Description));
                    "Action Codes".Description := ZGT.ValidateEmailAdd("Action Codes".Description);
                    "Action Codes".Modify;
                end;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "Action Codes".Count);
            end;
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

    labels
    {
    }

    var
        ZGT: Codeunit "ZyXEL General Tools";
}
