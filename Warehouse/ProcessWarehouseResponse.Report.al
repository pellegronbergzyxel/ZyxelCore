report 50059 "Process Warehouse Response"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Process Warehouse';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    trigger OnPreReport()

    var
        WhsePostMgt: Codeunit "Zyxel VCK Post Management";
    begin
        WhsePostMgt.Run();
    end;
}
