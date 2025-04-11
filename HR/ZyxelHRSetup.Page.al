Page 50024 "Zyxel HR Setup"
{
    Caption = 'Zyxel HR Setup';
    SourceTable = "Zyxel HR Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Probation Reminder"; Rec."Probation Reminder")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Probation Reminder 2"; Rec."Probation Reminder 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Leaving Reminder"; Rec."Leaving Reminder")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Leaving Reminder 2"; Rec."Leaving Reminder 2")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Probation E-mail Code"; Rec."Probation E-mail Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Leaving E-mail Code"; Rec."Leaving E-mail Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Long Service Ann. E-mail Code"; Rec."Long Service Ann. E-mail Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then
            Rec.Insert;
    end;
}
