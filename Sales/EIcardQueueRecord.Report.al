Report 50125 "EiCard Queue Record"
{
    Caption = 'EiCard Queue Record';
    DefaultLayout = Word;
    UsageCategory = ReportsandAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(EiCardQueue; "EiCard Queue")
        {
            RequestFilterFields = "Sales Order No.", "Purchase Order No.", "Customer No.", "Sales Order Status", "Purchase Order Status", "Active";
            column(SalesOrderNo; EiCardQueue."Sales Order No.")
            {
                IncludeCaption = true;
            }
            column(PurchaseOrderNo; EiCardQueue."Purchase Order No.")
            {
                IncludeCaption = true;
            }
            column(CustomerNo; EiCardQueue."Customer No.")
            {
                IncludeCaption = true;
            }
            column(CustomerName; EiCardQueue."Customer Name")
            {
                IncludeCaption = true;
            }
            column(SalesOrderStatus; EiCardQueue."Sales Order Status")
            {
                IncludeCaption = true;
            }
            column(PurchaseOrderStatus; EiCardQueue."Purchase Order Status")
            {
                IncludeCaption = true;
            }
            column(StatusChangeDate; EiCardQueue."Status Change Date")
            {
                IncludeCaption = true;
            }
            column(CreationDate; EiCardQueue."Creation Date")
            {
                IncludeCaption = true;
            }
            column(Active; EiCardQueue.Active)
            {
                IncludeCaption = true;
            }
            column(EicardType; EiCardQueue."Eicard Type")
            {
                IncludeCaption = true;
            }
            column(DistributorEmail; EiCardQueue."Distributor E-mail")
            {
                IncludeCaption = true;
            }
            column(CreatedBy; EiCardQueue."Created By")
            {
                IncludeCaption = true;
            }
            column(External_Document_No_; EiCardQueue."External Document No.")
            {
                IncludeCaption = true;
            }
            column(Distributor_Reference; EiCardQueue."Distributor Reference")
            {
                IncludeCaption = true;
            }

            dataitem(EiCardLinkLine; "EiCard Link Line")
            {
                DataItemLink = "Purchase Order No." = field("Purchase Order No.");
                DataItemLinkReference = EiCardQueue;
                column(UID; EiCardLinkLine.UID)
                {
                    IncludeCaption = true;
                }
                column(LinkLineItemNo; EiCardLinkLine."Item No.")
                {
                    IncludeCaption = true;
                }
                column(LinkLineDescription; EiCardLinkLine.Description)
                {
                    IncludeCaption = true;
                }
                column(LinkLineLink; EiCardLinkLine.Link)
                {
                    IncludeCaption = true;
                }
                column(LinkLineFilename; EiCardLinkLine.Filename)
                {
                    IncludeCaption = true;
                }
                column(LinkLineQuantity; EiCardLinkLine.Quantity)
                {
                    IncludeCaption = true;
                }
                column(LinkLineSizeMB; EiCardLinkLine."Size (MB)")
                {
                    IncludeCaption = true;
                }
                column(LinkLinePurchOrderLineNo; EiCardLinkLine."Purchase Order Line No.")
                {
                    IncludeCaption = true;
                }
                column(LinkLineLineNo; EiCardLinkLine."Line No.")
                {
                    IncludeCaption = true;
                }
                column(RejectDescription; EiCardLinkLine."Reject Description")
                {
                    IncludeCaption = true;
                }
                Column(Item_Description; EiCardLinkLine."Item Description")
                {
                    IncludeCaption = true;
                }

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }
        actions
        {
        }
    }
}
