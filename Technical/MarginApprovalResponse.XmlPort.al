namespace ZyxelCore.ZyxelCore;

xmlport 50010 MarginApprovalResponse
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/PoStatus';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;


    schema
    {
        textelement(Root)
        {
            tableelement(Response; "Margin Approval")
            {
                XmlName = 'Response';
                UseTemporary = true;
                Textelement(EntryNo)
                {
                }
                textelement(Is_Approved)
                {
                }
                textelement(Approver)
                {
                }
                textelement(Comment)
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
    begin
    end;
}


