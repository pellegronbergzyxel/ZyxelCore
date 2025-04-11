Report 50182 "Release Sales Orders"
{
    Caption = 'Release Sales Orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order), Status = const(Released));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Sales Header"."No.", 0, true);

                recSalesLine.SetRange("Document Type", "Sales Header"."Document Type");
                recSalesLine.SetRange("Document No.", "Sales Header"."No.");
                recSalesLine.SetRange(Status, recSalesLine.Status::Open);
                recSalesLine.SetRange("No.", 'ZNET-AIR');
                recSalesLine.SetRange("Freight Cost Related Line No.", 0);
                if not recSalesLine.FindFirst then begin
                    recSalesLine.SetRange("Freight Cost Related Line No.");
                    recSalesLine.SetFilter("No.", '<>%1', '');
                    if recSalesLine.FindFirst then begin
                        "Sales Header".SetHideValidationDialog(true);
                        ReleaseSalesDoc.PerformManualReopen("Sales Header");
                        ReleaseSalesDoc.PerformManualRelease("Sales Header");
                        "Sales Header".SetHideValidationDialog(false);
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
                SI.SetHideSalesDialog(false);
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "Sales Header".Count);
                SI.SetHideSalesDialog(true);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        recSalesLine: Record "Sales Line";
        ZGT: Codeunit "ZyXEL General Tools";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        SI: Codeunit "Single Instance";
}
