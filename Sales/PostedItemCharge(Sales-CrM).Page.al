Page 50078 "Posted Item Charge (Sales-CrM)"
{
    Caption = 'Posted Item Charge Assignment (Sales Cr. Memo)';
    Editable = false;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Posted Item Charge (Sales-CrM)";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Applies-to Doc. Line No."; Rec."Applies-to Doc. Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. to Assign"; Rec."Qty. to Assign")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. Assigned"; Rec."Qty. Assigned")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount to Assign"; Rec."Amount to Assign")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    var
        Text000: label 'The sign of %1 must be the same as the sign of %2 of the item charge.';
}
