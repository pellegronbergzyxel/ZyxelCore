xmlport 50011 "HQ Margin Approval Response"
{
    Caption = 'HQ Margin Approval MarginApproval';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/MarAppResp';
    Direction = Both;
    Format = Xml;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;
    schema
    {
        textelement(root)
        {
            tableelement(MarginApproval; "Margin Approval")
            {
                XmlName = 'response';
                MinOccurs = Once;
                MaxOccurs = Unbounded;
                UseTemporary = true;
                fieldelement(EntryNo; MarginApproval."Entry No.")
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                textelement(IsApproved)
                {
                    XmlName = 'Is_Approved';
                    MinOccurs = Once;
                    MaxOccurs = Once;

                    trigger OnAfterAssignVariable()
                    begin
                        MarginApproval.requeststatusDT := CurrentDateTime;
                        case UpperCase(IsApproved) of
                            'C':
                                MarginApproval.Status := MarginApproval.Status::"Waiting for User Comment";
                            'N':
                                begin
                                    MarginApproval.Status := MarginApproval.Status::Rejected;
                                    MarginApproval.requeststatus := MarginApproval.requeststatus::RejectedPrice;
                                end;
                            'Y':
                                begin
                                    MarginApproval.Status := MarginApproval.Status::Approved;
                                    MarginApproval.requeststatus := MarginApproval.requeststatus::closed;

                                end;
                        end;
                    end;

                }
                fieldelement(Approver; MarginApproval."Approved/Rejected by")
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                    FieldValidate = No;
                }
                textelement(Comment)
                {
                    XmlName = 'Comment';
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }

            }
        }

    }



    procedure ProcessData()
    var
        MarginApp: Record "Margin Approval";
        ZGT: Codeunit "ZyXEL General Tools";
        CurrDT: DateTime;
        ReceivedComment: Text;
        CrLf: Text[2];
    begin
        CurrDT := CurrentDateTime;
        CrLf[1] := 13;
        CrLf[2] := 10;

        if MarginApproval.FindSet() then
            repeat
                MarginApp.get(MarginApproval."Entry No.");
                MarginApp.Validate(Status, MarginApproval.Status);
                MarginApp."Approved/Rejected by" := MarginApproval."Approved/Rejected by";
                if Comment <> '' then begin
                    ReceivedComment := StrSubstNo('%1 %2:%3"%4".', Format(CurrDT, 0, 0), MarginApproval.Status, CrLf, Comment);
                    if MarginApp.GetComment(1) <> '' then
                        MarginApp.SetComment(1, StrSubstNo('%1 %2%2 %3', ReceivedComment, CrLf, MarginApp.GetComment(1)))
                    else
                        MarginApp.SetComment(1, ReceivedComment);
                end;
                MarginApp.requeststatusDT := CurrentDateTime;
                MarginApp.Status := MarginApproval.Status;
                MarginApp.requeststatus := MarginApproval.requeststatus;
                MarginApp.Modify(true);
                if MarginApp.Status = MarginApp.Status::Approved then begin
                    if MarginApp."Source Type" = MarginApp."Source Type"::"Price Book" then
                        MarginApp.Setapprovedpricebookline(MarginApproval);
                end;

            until MarginApproval.Next() = 0;
    end;
}
