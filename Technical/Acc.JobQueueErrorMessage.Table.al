Table 62000 "Acc. Job Queue Error Message"
{
    Caption = 'Accepted Job Queue Error Message';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Message; Text[250])
        {
            Caption = 'Message';

            trigger OnValidate()
            begin
                if Message <> '' then
                    if ZGT.IsRhq then begin
                        recAccJobQueueErrorMessage.ChangeCompany(ZGT.GetSistersCompanyName(1));
                        recAccJobQueueErrorMessage.SetRange(Message, Message);
                        if not recAccJobQueueErrorMessage.FindFirst then begin
                            recAccJobQueueErrorMessage.Message := Message;
                            recAccJobQueueErrorMessage.Insert(true);
                        end;
                    end;
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Message)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if ZGT.IsRhq then begin
            recAccJobQueueErrorMessage.ChangeCompany(ZGT.GetSistersCompanyName(1));
            recAccJobQueueErrorMessage.SetRange(Message, Message);
            if recAccJobQueueErrorMessage.FindFirst then begin
                recAccJobQueueErrorMessage.Delete;
            end;
        end;
    end;

    var
        recAccJobQueueErrorMessage: Record "Acc. Job Queue Error Message";
        ZGT: Codeunit "ZyXEL General Tools";
}
