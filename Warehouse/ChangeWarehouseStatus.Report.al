Report 62015 "Change Warehouse Status"
{
    Caption = 'Change Warehouse Status - Outbound';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    usagecategory = reportsandanalysis;

    dataset
    {
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
                    field(DeliveryDoc; DeliveryDoc)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Delivery Document';
                        tooltip = 'Specifies the delivery document number for which you want to change the warehouse status.';
                        Editable = false;
                        Lookup = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            frmDelDoc: Page "VCK Delivery Document Header";
                        begin
                            frmDelDoc.LookupMode(true);
                            if frmDelDoc.RunModal() = Action::LookupOK then begin
                                Text := frmDelDoc.ReturnCode();
                                exit(true);
                            end;
                        end;
                    }
                    field(Status; Status)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Warehouse Status';
                        tooltip = 'Specifies the warehouse status for the delivery document.';
                        OptionCaption = 'New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error';
                    }
                    field(DocStatus; DocStatus)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Status';
                        tooltip = 'Specifies the document status for the delivery document.';
                        OptionCaption = 'Open,Released,Posted';
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

    trigger OnPostReport()
    begin
        if DeliveryDoc = '' then
            Error('You must specify a Delivery Document No.');
        //UpgradeReady
        if recDelDocHead.Get(DeliveryDoc) then begin
            recShipRespHead.SetRange("Customer Message No.", DeliveryDoc);
            if not recShipRespHead.FindLast() then
                Clear(recShipRespHead);

            if (recDelDocHead."Document Type" = recDelDocHead."document type"::Sales) or
                ((recDelDocHead."Document Type" = recDelDocHead."document type"::Transfer) and
                (recShipRespHead."Warehouse Status" = recShipRespHead."warehouse status"::Delivered))
            then begin
                if recDelDocHead."Warehouse Status" <> Status then
                    recDelDocHead.Validate("Warehouse Status", Status);
                if recDelDocHead."Document Status" <> DocStatus then
                    recDelDocHead.Validate("Document Status", DocStatus);
                recDelDocHead.Modify(true);
            end else begin
                ResponseNo := ReleaseDeliveryDoc.CreateResponse(recDelDocHead, true);
                if PostResponse and
                    (ResponseNo <> '')
                then
                    PostShipRespMgt.PostShippingOrderResponse(ResponseNo);
            end;
        end;
    end;

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 62015, 2);
    end;

    var
        recDelDocHead: Record "VCK Delivery Document Header";
        recShipRespHead: Record "Ship Response Header";
        ReleaseDeliveryDoc: Codeunit "Release Delivery Document";
        PostShipRespMgt: Codeunit "Post Ship Response Mgt.";
        SI: Codeunit "Single Instance";
        Status: Option New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        DocStatus: Option Open,Released,Posted;
        DeliveryDoc: Code[20];
        ResponseNo: Code[20];
        PostResponse: Boolean;


    procedure InitReport(NewDeliveryDoc: Code[20]; NewStatus: Option New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error; NewDocStatus: Option New,Released,Posted; NewPostResponse: Boolean)
    begin
        DeliveryDoc := NewDeliveryDoc;
        Status := NewStatus;
        DocStatus := NewDocStatus;
        PostResponse := NewPostResponse;
    end;
}

