Page 50346 "Del. Doc. Action Factbox"
{
    Caption = 'Del. Doc. Action Factbox';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Delivery Document Action Code";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Action Code"; Rec."Action Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Action Description"; Rec."Action Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Comment Type"; Rec."Comment Type")
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
            action(Edit)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit';
                Image = Edit;

                trigger OnAction()
                var
                    DelDocMgt: Codeunit "Delivery Document Management";
                begin
                    DelDocMgt.EnterDelDocActionCode(Rec."Delivery Document No.");
                end;
            }
        }
    }
}
