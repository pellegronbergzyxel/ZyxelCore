report 50072 "Update VIES VAT Entry"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Update VIES VAT Entry';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    Permissions = tabledata "VAT Entry" = m;
    dataset
    {
        dataitem(VATEntry; "VAT Entry")
        {
            DataItemTableView = where("Document Type" = const("Credit Memo"));
            trigger OnAfterGetRecord()
            var
                recSalesInvHead: Record "Sales Invoice Header";
                recSalesCrMemoHead: Record "Sales Cr.Memo Header";
            begin
                ZGT.UpdateProgressWindow(Format("Entry No."), 0, true);

                "VAT Registration No. VIES" := "VAT Registration No.";
                if type = type::Sale then begin
                    case "Document Type" of
                        "document type"::Invoice:
                            if recSalesInvHead.Get("Document No.") then begin
                                If (recSalesInvHead."Bill-to Country/Region Code" <> recSalesInvHead."Ship-to Country/Region Code") and
                                   (recSalesInvHead."Ship-to VAT" <> '')
                                 then
                                    "VAT Registration No. VIES" := recSalesInvHead."Ship-to VAT";
                            end;
                        "document type"::"Credit Memo":
                            if recSalesCrMemoHead.Get("Document No.") then begin
                                If (recSalesCrMemoHead."Bill-to Country/Region Code" <> recSalesCrMemoHead."Rcvd.-from Count./Region Code") and
                                   (recSalesCrMemoHead."Rcvd.-from Count./Region Code" <> '') and
                                   (recSalesCrMemoHead."Ship-to VAT" <> '')
                                 then
                                    "VAT Registration No. VIES" := recSalesCrMemoHead."Ship-to VAT";
                            end;
                    end;
                end;
                Modify;
            end;

            trigger OnPreDataItem()
            begin
                if not Confirm('Do you want to update %1 VAT Entries?', false, Count) then
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
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        ZGT: Codeunit "ZyXEL General Tools";

}
