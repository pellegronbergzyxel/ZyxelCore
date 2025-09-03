report 50053 "Update Purchase Order / Unship"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Update Purchase Order / Unship';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(UnshippedPurchaseOrder; "Unshipped Purchase Order")
        {
            DataItemTableView = sorting("Purchase Order No.", "Purchase Order Line No.");

            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            var
                UnshipPurchOrder: Record "Unshipped Purchase Order";
            begin

            end;

            trigger OnPostDataItem()
            begin

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
}
