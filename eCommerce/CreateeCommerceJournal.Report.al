report 50135 "Create eCommerce Journal"
{
    Caption = 'Create eCommerce Journal';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("eCommerce Payment"; "eCommerce Payment")
        {
            DataItemTableView = sorting(Date, "Transaction Summary", "eCommerce Market Place");

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(Format("eCommerce Payment".UID), 0, true);

                recAmzPayHead.SetRange("Transaction Summary", "eCommerce Payment"."Transaction Summary");
                //recAmzPayHead.SETRANGE("Market Place ID","eCommerce Market Place");
                if recAmzPayHead.FindFirst() then begin
                    "eCommerce Payment"."Journal Batch No." := recAmzPayHead."No.";
                    "eCommerce Payment".Modify();

                    if recAmzPayHead."Market Place ID" = '' then begin
                        recAmzPayHead."Market Place ID" := "eCommerce Payment"."eCommerce Market Place";
                        recAmzPayHead.Modify();
                    end;

                end else begin
                    recAmzPayHead.Reset();
                    recAmzPayHead."No." := NoSeriesMgt.GetNextNo(recAmzSetup."Payment Batch Nos.", Today, true);
                    recAmzPayHead."Transaction Summary" := "eCommerce Payment"."Transaction Summary";
                    recAmzPayHead.Date := "eCommerce Payment".Date;
                    recAmzPayHead."Market Place ID" := "eCommerce Payment"."eCommerce Market Place";
                    recAmzPayHead.Insert();

                    "eCommerce Payment"."Journal Batch No." := recAmzPayHead."No.";
                    "eCommerce Payment".Modify();
                end;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "eCommerce Payment".Count());
            end;
        }
    }

    trigger OnPreReport()
    begin
        recAmzSetup.Get();
        recAmzPayHead.DeleteAll();

        SI.UseOfReport(3, 50135, 2);  // 14-10-20 ZY-LD 000
    end;

    var
        recAmzPayHead: Record "eCommerce Payment Header";
        recAmzSetup: Record "eCommerce Setup";
        PrevMarketPlace: Code[10];
        PrevSummary: Code[100];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
}
