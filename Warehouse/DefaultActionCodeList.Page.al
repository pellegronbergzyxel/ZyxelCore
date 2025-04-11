Page 50076 "Default Action Code List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Default Action Code List';
    DataCaptionFields = "Source Type", "Source Code";
    Editable = false;
    PageType = List;
    SourceTable = "Default Action";
    SourceTableView = sorting("Source Type", "Source Code", "Comment Type", Sequence);
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Header / Line"; Rec."Header / Line")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Comment Type"; Rec."Comment Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Action Code"; Rec."Action Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Action Description"; Rec."Action Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}
