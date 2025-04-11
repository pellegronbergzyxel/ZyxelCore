Page 50323 "Sales Document E-mail Entries"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Document E-mail Entries';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Sales Document E-mail Entry";
    UsageCategory = Lists;
    Permissions = tabledata "Sales Invoice Header" = rm;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Send E-mail at"; Rec."Send E-mail at")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Sent; Rec.Sent)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("E-mail Sent at"; Rec."E-mail Sent at")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("E-mail Address Code"; Rec."E-mail Address Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Show Sent Documents")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Sent Documents';
                Image = PostMail;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowSentVisible;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    Rec.SetRange(Rec.Sent, true);
                    Rec.FilterGroup(0);

                    ShowSentVisible := false;
                    ShowUnSentVisible := true;
                end;
            }
            action("Show Documents Ready to Send")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Documents Ready to Send';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowUnSentVisible;

                trigger OnAction()
                begin
                    Rec.FilterGroup(2);
                    Rec.SetRange(Rec.Sent, false);
                    Rec.FilterGroup(0);

                    ShowSentVisible := true;
                    ShowUnSentVisible := false;
                end;
            }
        }
        area(processing)
        {
            action("Send all Invoices")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send all Invoices';
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowSentVisible;

                trigger OnAction()
                begin
                    ProcessSalesDocumentEmail.SendSalesInvoices(true);
                end;
            }
            action("Reopen Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reopen Invoice';
                Image = ReOpen;

                trigger OnAction()
                begin
                    ReopenInvoice;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange(Rec.Sent, false);
        Rec.FilterGroup(0);
        ShowSentVisible := true;
    end;

    var
        ShowSentVisible: Boolean;
        ShowUnSentVisible: Boolean;
        ProcessSalesDocumentEmail: Codeunit "Process Sales Document E-mail";

    local procedure SetActions()
    begin
    end;

    local procedure ReopenInvoice()
    var
        lText001: label 'Do you want to reopen invoice no. %1?';
        recSaleInvHead: Record "Sales Invoice Header";
    begin
        if Confirm(lText001, true, Rec."Document No.") then begin
            Rec.Sent := false;
            Rec.Modify;

            recSaleInvHead.Get(Rec."Document No.");
            recSaleInvHead."No. Printed" := 0;
            recSaleInvHead.Modify;
        end;
    end;
}
