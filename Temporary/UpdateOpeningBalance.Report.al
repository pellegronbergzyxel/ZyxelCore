report 50070 "Update Opening Balance"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Update Opening Balance';
    UsageCategory = Tasks;
    Permissions = tabledata "G/L Entry" = m;
    ProcessingOnly = true;
    Description = 'This report is to update entries, so Precision Point are able to read the deferral entries. The report can be deleted again after running.';
    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = where("Document No." = filter('OPEN.BAL.G/L-RHQ'),
                                      "Posting Date" = filter('>31-01-24'));
            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(Format("Entry No."), 0, true);

                "Reason Code" := 'DEF. READ';
                Modify;
            end;

            trigger OnPreDataItem()
            begin
                IF not Confirm('No of Entries: %1', false, Count) then
                    Error('');

                ZGT.OpenProgressWindow('', Count);
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        IF not ZGT.UserIsDeveloper() then
            Error('You are not allowed to run the report.');
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
}
