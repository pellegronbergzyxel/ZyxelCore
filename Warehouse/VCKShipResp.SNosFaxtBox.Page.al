Page 50046 "VCK Ship Resp. SNos FaxtBox"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Ship Responce Serial Nos.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Serial NO';
                    Visible = true;
                }
                field("Carrier ID"; Rec."Carrier ID") // 19-08-2026 BK #542568
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pallet ID';
                    ToolTip = 'Carrier ID';
                    Visible = true;
                }
                field("Identical Serial Numbers"; Rec."Identical Serial Numbers")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Identical Serial Numbers';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}
