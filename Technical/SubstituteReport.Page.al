page 50107 "Substitute Report"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Substitute Report';
    PageType = List;
    SourceTable = "Substitute Report";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Report Id"; Rec."Report Id") { }
                field("Report Description"; Rec."Report Caption") { }
                field("New Report Id"; Rec."New Report Id") { }
                field("New Report Description"; Rec."New Report Caption") { }
                field("New Report Name"; Rec."New Report Name") { }
            }
        }
    }
}
