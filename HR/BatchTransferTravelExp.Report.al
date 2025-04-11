Report 50055 "Batch Transfer Travel Exp."
{
    Caption = 'Batch Transfer Travel Exp.';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Replication Company"; "Replication Company")
        {
            DataItemTableView = sorting("Company Name");
            dataitem("Travel Expense Header"; "Travel Expense Header")
            {
                DataItemTableView = sorting("Concur Company Name") where("Document Status" = filter(Open | Released));
                RequestFilterFields = "No.", "Concur Company Name";

                trigger OnAfterGetRecord()
                begin
                    if ValidateDocument then begin
                        recTrExpHead.CopyFilters("Travel Expense Header");
                        if "Replication Company"."Travel Expense E-mail Address" <> '' then begin
                            Clear(TravelExpDoc);
                            TravelExpDoc.SetTableview("Travel Expense Header");
                            TravelExpDoc.UseRequestPage(false);
                            TravelExpDoc.InitReport(true);
                            TravelExpDoc.RunModal;
                            ServerFilename := TravelExpDoc.GetFilename;
                            if ServerFilename <> '' then begin
                                Clear(EmailAddMgt);
                                EmailAddMgt.CreateEmailWithAttachment("Replication Company"."Travel Expense E-mail Address", '', '', ServerFilename, StrSubstNo(Text001, Today), false);
                                EmailAddMgt.Send;
                                recTrExpHead.ModifyAll("Document Status", recTrExpHead."document status"::Mailed);
                                FileMgt.DeleteServerFile(ServerFilename);
                            end;
                        end else
                            ZyWebServMgt.SendTravelExpense(recTrExpHead, PostDocument);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "Travel Expense Header".SetRange("Travel Expense Header"."Concur Company Name", "Replication Company"."Company Name");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Replication Company"."Company Name", 0, true);
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "Replication Company".Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostDocument; PostDocument)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post';
                    }
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
        SI.UseOfReport(3, 50055, 2);  // 14-10-20 ZY-LD 000
    end;

    var
        recTrExpHead: Record "Travel Expense Header";
        TravelExpDoc: Report "Travel Expense Document";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        FileMgt: Codeunit "File Management";
        ZGT: Codeunit "ZyXEL General Tools";
        ServerFilename: Text;
        Text001: label 'Travel Expense %1.xlsx';
        SI: Codeunit "Single Instance";
        PostDocument: Boolean;


    procedure InitReport(NewPostDocument: Boolean)
    begin
        PostDocument := NewPostDocument;
    end;

    local procedure ValidateDocument() rValue: Boolean
    var
        recTrExpLine: Record "Travel Expense Line";
        recVatProdPostGrp: Record "VAT Product Posting Group";
    begin
        recTrExpLine.SetRange("Document No.", "Travel Expense Header"."No.");
        recTrExpLine.SetRange("Show Expense", true);
        if recTrExpLine.FindSet then
            repeat
                if recTrExpLine."VAT Prod. Posting Group" <> '' then
                    if not recVatProdPostGrp.Get(recTrExpLine."VAT Prod. Posting Group") then
                        exit(false);
            until recTrExpLine.Next() = 0;

        rValue := true;
    end;
}
