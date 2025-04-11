Page 50321 "Posted EiCard Queue"
{
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    Caption = 'Posted EiCard Queue';
    CardPageID = "EiCard Queue Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "EiCard Queue";
    SourceTableView = order(descending)
                      where(Active = const(false),
                            "Purchase Order Status" = filter(<> Created));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Distributor Reference"; Rec."Distributor Reference")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sales Order Status"; Rec."Sales Order Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Purchase Order Status"; Rec."Purchase Order Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Status Change Date"; Rec."Status Change Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Quantity Links"; Rec."Quantity Links")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Quantity Sales Order"; Rec."Quantity Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Size (Mb)"; Rec."Size (Mb)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("No. of EiCard Link Lines"; Rec."No. of EiCard Link Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field("Sales Order No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(50036));
                }
            }
        }
        area(processing)
        {
            action("Re-Send EiCard Link E-mail")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Re-Send EiCard Link E-mail';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SendEiCardLinkEmail(false);  // 03-09-19 ZY-LD 003
                end;
            }
            action("Re-Send (TEST)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Re-Send (TEST)';
                Image = TestReport;

                trigger OnAction()
                begin
                    SendEiCardLinkEmail(true);  // 03-09-19 ZY-LD 003
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then;
    end;

    var
        Text000: label 'Unable to execute this function while in view only mode.';
        Text001: label 'There are non posted Prepayment Amounts on %1.';
        Text002: label 'There are unpaid Prepayment Invoices related to %1.';
        Text003: label 'Sales Order %1 is already posted.';
        Text004: label 'Sales Order %1 cannot be viewed as it has been posted.';
        Text005: label 'Purchase Order %1 cannot be viewed as it has been posted.';
        Text006: label 'Purchase Order %1 is already posted.';
        Text007: label 'Are you sure that you want to re-send the Purchase Order to HQ?';
        Text008: label 'No Invoice Lines are available for Purchase Order %1.';
        Text009: label 'A Source Document is not available for Purchase Order %1.';
        Text010: label 'Sales Order %1 has been posted.';
        Text011: label 'There was an error posting Sales Order %1.';
        Text012: label 'Purchase Order %1 has been posted.';
        Text013: label 'There was an error posting Purchase Order %1.';
        Text014: label '%1 Sales Orders Posted.';
        Text015: label '%1 Purchase Orders Posted.';
        Text016: label 'Purchase Order %1 Not Fully Matched.';
        ZGT: Codeunit "ZyXEL General Tools";

    local procedure SendEiCardLinkEmail(Test: Boolean)
    var
        EiCardMgt: Codeunit "Process EiCard Links";
        lText001: label 'Do you want to send "EiCard Link E-mail" for sales order no. %1?';
        lText002: label 'The e-mail is sent to the customer.';
        lText003: label 'It was not possible to send the e-mail.';
        GenInputPage: Page "Generic Input Page";
        SendEmail: Boolean;
        lText004: label 'Enter Test E-mail Address';
        lText005: label 'Send to E-mail';
        lText006: label 'Do you want to send "EiCard Link E-mail" to "%1"?';
        TestEmailAdd: Text;
    begin
        //>> 03-09-19 ZY-LD 003
        if Test then begin
            GenInputPage.SetPageCaption(lText004);
            GenInputPage.SetFieldCaption(lText005);
            GenInputPage.SetVisibleField(0);  // Text
            GenInputPage.SetText := StrSubstNo('%1@zyxel.eu', CopyStr(Lowercase(UserId()), 6, StrLen(UserId())));
            if GenInputPage.RunModal = Action::OK then begin
                TestEmailAdd := GenInputPage.GetText;
                if TestEmailAdd <> '' then
                    SendEmail := Confirm(lText006, true, TestEmailAdd);
            end;
        end else
            SendEmail := Confirm(lText001, true, Rec."Sales Order No.");

        if SendEmail then
            if EiCardMgt.SendEiCardLinks(Rec."Sales Order No.", TestEmailAdd, true) then
                Message(lText002)
            else
                Message(lText003);
        //<< 03-09-19 ZY-LD 003
    end;
}
