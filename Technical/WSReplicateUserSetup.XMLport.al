XmlPort 50051 "WS Replicate User Setup"
{
    Caption = 'WS Replicate User Setup';
    DefaultNamespace = 'urn:microsoft-dynamics-nav/Replicate';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("User Setup"; "User Setup")
            {
                MinOccurs = Zero;
                XmlName = 'UserSetup';
                UseTemporary = true;
                fieldelement(UserID; "User Setup"."User ID")
                {
                }
                fieldelement(Email; "User Setup"."E-Mail")
                {
                }
                fieldelement(UseUserEmailOnDoc; "User Setup"."Use User E-mail on Documents")
                {
                }
                fieldelement(EmailSignature; "User Setup"."EMail Signature")
                {
                }
                fieldelement(FooterName; "User Setup"."E-Mail Footer Name")
                {
                }
                fieldelement(FooterAddress; "User Setup"."E-mail Footer Address")
                {
                }
                fieldelement(FooterAddress2; "User Setup"."E-mail Footer Address 2")
                {
                }
                fieldelement(FooterAddress3; "User Setup"."E-mail Footer Address 3")
                {
                }
                fieldelement(FooterMobile; "User Setup"."E-mail Footer Phone No.")
                {
                }
                fieldelement(FooterPhone; "User Setup"."E-mail Footer Mobile Phone No.")
                {
                }
                fieldelement(FooterSkype; "User Setup"."E-mail Footer Skype")
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


    procedure SetData(pCode: Code[50])
    var
        recUserSetup: Record "User Setup";
    begin
        if recUserSetup.Get(pCode) then begin
            "User Setup" := recUserSetup;
            "User Setup".Insert;
        end;
    end;


    procedure ReplicateData()
    var
        recUserSetup: Record "User Setup";
    begin
        if "User Setup".FindSet then
            repeat
                if recUserSetup.Get("User Setup"."User ID") then begin
                    recUserSetup."E-Mail" := "User Setup"."E-Mail";
                    recUserSetup."Use User E-mail on Documents" := "User Setup"."Use User E-mail on Documents";
                    recUserSetup."EMail Signature" := "User Setup"."EMail Signature";
                    recUserSetup."E-Mail Footer Name" := "User Setup"."E-Mail Footer Name";
                    recUserSetup."E-mail Footer Address" := "User Setup"."E-mail Footer Address";
                    recUserSetup."E-mail Footer Address 2" := "User Setup"."E-mail Footer Address 2";
                    recUserSetup."E-mail Footer Address 3" := "User Setup"."E-mail Footer Address 3";
                    recUserSetup."E-mail Footer Phone No." := "User Setup"."E-mail Footer Phone No.";
                    recUserSetup."E-mail Footer Mobile Phone No." := "User Setup"."E-mail Footer Mobile Phone No.";
                    recUserSetup."E-mail Footer Skype" := "User Setup"."E-mail Footer Skype";
                    recUserSetup.Modify;
                end else begin
                    recUserSetup := "User Setup";
                    recUserSetup.Insert;
                end;
            until "User Setup".Next() = 0;
    end;
}
