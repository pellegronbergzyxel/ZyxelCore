Report 50034 "Delete Sales Return Order Ver."
{
    // 001. 19-08-21 ZY-LD 000 - This report didn´t exist by default.

    Caption = 'Delete Archived Sales Return Order Versions';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Sales Header Archive"; "Sales Header Archive")
        {
            DataItemTableView = sorting("Document Type", "No.", "Doc. No. Occurrence", "Version No.") where("Document Type" = const("Return Order"), "Interaction Exist" = const(false));
            RequestFilterFields = "No.", "Date Archived", "Sell-to Customer No.";

            trigger OnAfterGetRecord()
            var
                SalesHeader: Record "Sales Header";
            begin
                SalesHeader.SetRange("Document Type", SalesHeader."document type"::"Return Order");
                SalesHeader.SetRange("No.", "Sales Header Archive"."No.");
                SalesHeader.SetRange("Doc. No. Occurrence", "Sales Header Archive"."Doc. No. Occurrence");
                if not SalesHeader.FindFirst then
                    "Sales Header Archive".Delete(true);
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

    trigger OnPostReport()
    begin
        Message(Text000);
    end;

    var
        Text000: label 'Archived versions deleted.';
}
