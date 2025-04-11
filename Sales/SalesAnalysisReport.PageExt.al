pageextension 50273 SalesAnalysisReportZX extends "Sales Analysis Report"
{
    Caption = 'Forecast Analysis';
    actions
    {
        addafter("Set Up &Columns")
        {
            action(Update)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update';

                trigger OnAction()
                var
                    recItemAnalysisView: Record "Item Analysis View";
                begin
                    if recItemAnalysisView.FindFirst() then begin
                        repeat
                            Codeunit.Run(7150, recItemAnalysisView)
                        until recItemAnalysisView.Next() = 0;
                    end;
                end;
            }
        }
    }
}
