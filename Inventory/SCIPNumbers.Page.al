page 50105 "SCIP Numbers"
{
    // 001. 16-04-24 ZY-LD 000 - Created.

    ApplicationArea = Basic, Suite;
    Caption = 'SCIP Numbers';
    PageType = List;
    SourceTable = "SCIP Number";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    Visible = false;
                }
                field("SCIP No."; Rec."SCIP No.")
                { }
            }
        }
    }
}
