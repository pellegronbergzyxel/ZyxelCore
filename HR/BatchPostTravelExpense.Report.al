Report 50075 "Batch Post Travel Expense"
{
    Caption = 'Batch Post Travel Expense';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Travel Expense Header"; "Travel Expense Header")
        {
            DataItemTableView = where("Document Status" = filter(Open | Released));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Travel Expense Header"."No.", 0, true);

                if "Travel Expense Header"."Concur Company Name" = CompanyName() then begin
                    TrExpPost.SetPostJournal(PostJournal);
                    TrExpPost.Run("Travel Expense Header");
                end;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "Travel Expense Header".Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PostJournal; PostJournal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Journal';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 50075, 2);  // 14-10-20 ZY-LD 000
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";
        TrExpPost: Codeunit "TravelExpense-Post";
        PostJournal: Boolean;
        SI: Codeunit "Single Instance";
}
