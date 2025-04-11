Report 62015 "Change Warehouse Status"
{
    // 001. 18-11-19 ZY-LD 000 - Change Document Status
    // 002. 03-12-20 ZY-LD P0499 - Create a response on transfer delivered.
    // 003. 23-08-22 ZY-LD 000 - Post Response.

    Caption = 'Change Warehouse Status - Outbound';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;

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
                        Editable = false;
                        Lookup = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            frmDelDoc: Page "VCK Delivery Document Header";
                        begin
                            frmDelDoc.LookupMode(true);
                            if frmDelDoc.RunModal = Action::LookupOK then begin
                                Text := frmDelDoc.ReturnCode;

                                exit(true);
                            end;
                        end;
                    }
                    field(Status; Status)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Warehouse Status';
                    }
                    field(DocStatus; DocStatus)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Status';
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

        // 18-11-19 ZY-LD 001
        //recDeliveryDocumentHeader.SETFILTER("No.",DeliveryDoc);
        //IF NOT recDeliveryDocumentHeader.FINDFIRST THEN
        //  ERROR('The Delivery Document Does Not Exist!');

        //IF recDeliveryDocumentHeader.FINDfirst THEN BEGIN
        with recDelDocHead do
            if Get(DeliveryDoc) then begin  // 18-11-19 ZY-LD 001
                recShipRespHead.SetRange("Customer Message No.", DeliveryDoc);
                if not recShipRespHead.FindLast then
                    Clear(recShipRespHead);

                if ("Document Type" = "document type"::Sales) or
                   (("Document Type" = "document type"::Transfer) and
                    (recShipRespHead."Warehouse Status" = recShipRespHead."warehouse status"::Delivered))
                then begin
                    if "Warehouse Status" <> Status then
                        Validate("Warehouse Status", Status);
                    if "Document Status" <> DocStatus then
                        Validate("Document Status", DocStatus);  // 18-11-19 ZY-LD 001
                    Modify(true);
                end else begin
                    //>> 03-12-20 ZY-LD 002
                    ResponseNo := ReleaseDeliveryDoc.CreateResponse(recDelDocHead, true);
                    if PostResponse and  // 23-08-22 ZY-LD 003
                       (ResponseNo <> '')
                    then
                        PostShipRespMgt.PostShippingOrderResponse(ResponseNo);
                    //<< 03-12-20 ZY-LD 002
                end;
            end;
    end;

    trigger OnPreReport()
    begin
        SI.UseOfReport(3, 62015, 2);  // 14-10-20 ZY-LD 000
    end;

    var
        recDelDocHead: Record "VCK Delivery Document Header";
        recShipRespHead: Record "Ship Response Header";
        ReleaseDeliveryDoc: Codeunit "Release Delivery Document";
        PostShipRespMgt: Codeunit "Post Ship Response Mgt.";
        SI: Codeunit "Single Instance";
        DeliveryDoc: Code[20];
        ResponseNo: Code[20];
        Status: Option New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;
        DocStatus: Option Open,Released,Posted;
        Text001: label 'Please specify a Delivery Document No.';
        PostResponse: Boolean;


    procedure InitReport(NewDeliveryDoc: Code[20]; NewStatus: Option New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error; NewDocStatus: Option New,Released,Posted; NewPostResponse: Boolean)
    begin
        DeliveryDoc := NewDeliveryDoc;
        Status := NewStatus;
        DocStatus := NewDocStatus;  // 18-11-19 ZY-LD 001
        PostResponse := NewPostResponse;  // 23-08-22 ZY-LD 003
    end;
}

