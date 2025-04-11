pageextension 50110 GLAccountCardZX extends "G/L Account Card"
{
    layout
    {
        addafter(Blocked)
        {
            field(Hidden; Rec.Hidden)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fixed Asset Account (Concur)"; Rec."Fixed Asset Account (Concur)")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Cost Type No.")
        {
            group("HQ Account Mapping")
            {
                Caption = 'HQ Account Mapping';
                field("HQ Account No."; Rec."No. 2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'HQ G/L Account No.';
                }
                field("HQ Account Name"; Rec."Name 2")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("RHQ Account Mapping")
            {
                Caption = 'RHQ Account Mapping';
                field("RHQ G/L Account No."; Rec."RHQ G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("RHQ G/L Account Name"; Rec."RHQ G/L Account Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        addafter("G/L Register")
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
                    RunPageLink = "Primary Key Field 1 Value" = field("No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(15));
                }
            }
        }
    }
}
