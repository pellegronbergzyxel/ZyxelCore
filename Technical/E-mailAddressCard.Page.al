Page 50253 "E-mail Address Card"
{
    // 001. 14-05-18 ZY-LD 2018051410000154 - New action.
    // 002. 06-11-18 ZY-LD 000 - New action.
    // 003. 30-11-18 ZY-LD 000 - Replicate.
    // 004. 21-01-20 ZY-LD 000 - Copy to sister company.

    PageType = Card;
    SourceTable = "E-mail address";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = PageEditable;
                }
                group(Control25)
                {
                    ShowCaption = false;
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = PageEditable;
                    }
                    field("Document Usage"; Rec."Document Usage")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = PageEditable;
                    }
                    field("Delay on Automated E-mail"; Rec."Delay on Automated E-mail")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Recipients; Rec.Recipients)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = PageEditable;
                    }
                    field(BCC; Rec.BCC)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Control26)
                {
                    ShowCaption = false;
                    field("Sender Name"; Rec."Sender Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Sender Address"; Rec."Sender Address")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Subject; Rec.Subject)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = PageEditable;

                        trigger OnAssistEdit()
                        begin
                            recEmailAddSub.SetRange("E-mail Address Code", Rec.Code);
                            Page.RunModal(Page::"E-mail Address Subjects", recEmailAddSub);
                        end;
                    }
                    field("Html Formatted"; Rec."Html Formatted")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = PageEditable;
                    }
                }
                group(Control27)
                {
                    ShowCaption = false;
                    field("E-mail HTML file"; Rec."E-mail HTML file")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Color Scheme"; Rec."Color Scheme")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Footer E-Mail"; Rec."Footer E-Mail")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            part(Control14; "E-mail address Subform")
            {
                SubPageLink = "E-mail Address Code" = field(Code);
                UpdatePropagation = Both;
            }
            group(Control19)
            {
                Caption = 'Replicate';
                Visible = PageVisible;
                field("Do Not Replicate"; Rec."Do Not Replicate")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control11; Notes)
            {
            }
            systempart(Control12; MyNotes)
            {
            }
            systempart(Control13; Links)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Subjects pr. Language")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Subjects pr. Language';
                Image = BeginningText;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "E-mail Address Subjects";
                RunPageLink = "E-mail Address Code" = field(Code);
            }
            action("Show Possible Merge Fields")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Possible Merge Fields';
                Image = Link;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Hyperlink('http://helpcenter/NAV/Shelf/DynamicsNAV/DynamicsNAV.htm?b=Finance&r=E-mail%20address%20Setup');
                end;
            }
        }
        area(processing)
        {
            action(Replicate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Replicate';
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //>> 30-11-18 ZY-LD 003
                    if Confirm(Text001, true, Rec.Description) then
                        ZyWebServMgt.ReplicateEmailAddress('', Rec.Code);  // 30-11-18 ZY-LD 003
                    //<< 30-11-18 ZY-LD 003
                end;
            }
            action("Copy to Sister Company")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy to Sister Company';
                Image = Copy;

                trigger OnAction()
                begin
                    //>> 21-01-20 ZY-LD 004
                    if Confirm(Text002, true, Rec.Description, ZGT.GetSistersCompanyName(1)) then
                        ZyWebServMgt.ReplicateEmailAddress(ZGT.GetSistersCompanyName(1), Rec.Code);
                    //<< 21-01-20 ZY-LD 004
                end;
            }
            action("Test of Email (LD)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Test of Email';
                Image = TestFile;
                trigger OnAction()
                var
                    MailAddMgt: Codeunit "E-mail Address Management";
                    lText001: Label 'Do you want to send simple email "LD"?';
                begin
                    if Confirm(lText001, true) then begin
                        MailAddMgt.CreateSimpleEmail('LD', '', '');
                        MailAddMgt.Send();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;
    end;

    trigger OnOpenPage()
    begin
        SetActions;
    end;

    var
        recEmailAddSub: Record "E-mail Address Subject";
        PageEditable: Boolean;
        PageVisible: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        Text001: label 'Do you want to replicate "%1"?';
        Text002: label 'Do you want to copy "%1" to %2?';

    local procedure SetActions()
    begin
        if ZGT.IsRhq then
            PageEditable := true
        else
            PageEditable := not Rec.Replicated;
        PageVisible := ZGT.IsRhq;
    end;
}
