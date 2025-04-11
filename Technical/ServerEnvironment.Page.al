page 50028 "Server Environment"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Server Environment';
    PageType = List;
    SourceTable = "Server Environment";
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Environment; Rec.Environment)
                {
                    ToolTip = 'Specifies the value of the Environment field.';
                }
                field(Server; Rec.Server)
                {
                    ToolTip = 'Specifies the value of the Server field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    Visible = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    Visible = false;
                }
            }
        }
    }



}
