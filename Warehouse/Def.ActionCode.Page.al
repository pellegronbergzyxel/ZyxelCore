Page 50081 "Def. Action Code"
{
    // 001. 06-04-22 ZY-LD 000 - We don´t use the lines anymore.

    Caption = 'Default Action Codes';
    DataCaptionFields = "Source Type", "Source Code";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Default Action";

    layout
    {
        area(content)
        {
            part(DACHeader; "Default Action Code")
            {
                Caption = 'Action Codes on Delivery Document Header';
                ShowFilter = false;
                SubPageLink = "Source Type" = field("Source Type"),
                              "Source Code" = field("Source Code"),
                              "Customer No." = field("Customer No."),
                              "Header / Line" = const(Header);
                SubPageView = sorting("Source Type", "Source Code", "Comment Type", Sequence);
            }
            part(DACLine; "Default Action Code")
            {
                Caption = 'Action Codes on Delivery Document Line';
                ShowFilter = false;
                SubPageLink = "Source Type" = field("Source Type"),
                              "Source Code" = field("Source Code"),
                              "Customer No." = field("Customer No."),
                              "Header / Line" = const(Line);
                SubPageView = sorting("Source Type", "Source Code", "Comment Type", Sequence);
                Visible = ActionCodeCustomerVisible;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Action Codes - Customer")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Action Codes - Customer';
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ActionCodeCustomerVisible;

                trigger OnAction()
                begin
                    DelDocMgt.EnterActionCode(Rec."Customer No.", Rec."Customer No.", 1);
                end;
            }
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

                    trigger OnAction()
                    var
                        ChangeLogEntry: Record "Change Log Entry";
                    begin
                        ChangeLogEntry.SetCurrentKey("Table No.", "Date and Time");
                        ChangeLogEntry.SetAscending("Date and Time", false);
                        ChangeLogEntry.SetRange("Table No.", Database::"Default Action");
                        ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(Rec."Source Type"));
                        ChangeLogEntry.SetRange("Primary Key Field 2 Value", Format(Rec."Source Code"));
                        ChangeLogEntry.SetRange("Primary Key Field 3 Value", Format(Rec."Customer No."));
                        page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.DACHeader.Page.InitPage(Rec."Source Type", Rec."Source Code", Rec."Customer No.", 0);
        CurrPage.DACLine.Page.InitPage(Rec."Source Type", Rec."Source Code", Rec."Customer No.", 1);
    end;

    trigger OnInit()
    begin
        CurrPage.DACHeader.Page.InitPage(Rec."Source Type", Rec."Source Code", Rec."Customer No.", 0);
        CurrPage.DACLine.Page.InitPage(Rec."Source Type", Rec."Source Code", Rec."Customer No.", 1);
    end;

    trigger OnOpenPage()
    begin
        //ActionCodeCustomerVisible := "Source Type" = "Source Type"::"Ship-to Address";  // 06-04-22 ZY-LD 001
    end;

    var
        DelDocMgt: Codeunit "Delivery Document Management";
        ActionCodeCustomerVisible: Boolean;
}
