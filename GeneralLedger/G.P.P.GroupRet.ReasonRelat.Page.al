Page 50251 "G.P.P. Group Ret. Reason Relat"
{
    // 001. 17-06-19 ZY-LD 2019061210000065 - New field.

    Caption = 'Gen. Prod. Posting Group Return Reason Relation';
    PageType = List;
    SourceTable = "G.P.P. Group Ret. Reason Relat";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Return Reason Description"; Rec."Return Reason Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Unit Price Must be Zero"; Rec."Sales Unit Price Must be Zero")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Max. Sales Unit Price"; Rec."Max. Sales Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
