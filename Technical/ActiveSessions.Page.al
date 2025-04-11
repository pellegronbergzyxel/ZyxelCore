Page 50149 "Active Sessions"
{
    ApplicationArea = Basic, Suite;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Active Session";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User SID"; Rec."User SID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Server Instance ID"; Rec."Server Instance ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Session ID"; Rec."Session ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Server Instance Name"; Rec."Server Instance Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Server Computer Name"; Rec."Server Computer Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Client Type"; Rec."Client Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Client Computer Name"; Rec."Client Computer Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Login Datetime"; Rec."Login Datetime")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Database Name"; Rec."Database Name")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Kill)
            {
                Caption = 'Kill Sessions';
                ApplicationArea = Basic, Suite;
                Image = CoupledUser;
                ToolTip = 'Kill Selected Session';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //CurrPage.SETSELECTIONFILTER(Rec);
                    //IF FINDSET(FALSE,FALSE) THEN BEGIN
                    //  REPEAT
                    StopSession(Rec."Session ID");
                    //  UNTIL NEXT = 0;
                    //END;
                    //MARKEDONLY(FALSE);
                    CurrPage.Update;
                end;
            }
        }
    }
}
