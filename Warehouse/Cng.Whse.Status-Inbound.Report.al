Report 62016 "Cng. Whse. Status - Inbound"
{
    Caption = 'Change Warehouse Status - Inbound';
    ProcessingOnly = true;
    ShowPrintStatus = false;

    dataset
    {
        dataitem("Warehouse Inbound Header"; "Warehouse Inbound Header")
        {
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            begin
                if "Warehouse Inbound Header"."Warehouse Status" <> WhseStatus then
                    "Warehouse Inbound Header"."Warehouse Status" := WhseStatus;

                if "Warehouse Inbound Header"."Document Status" <> DocStatus then
                    "Warehouse Inbound Header"."Document Status" := DocStatus;

                if "Warehouse Inbound Header"."Location Code" <> LocationCode then
                    "Warehouse Inbound Header".Validate("Warehouse Inbound Header"."Location Code", LocationCode);

                "Warehouse Inbound Header".Modify(true);
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
                    field(WhseStatus; WhseStatus)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Warehouse Status';
                    }
                    field(DocStatus; DocStatus)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Document Status';
                    }
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Location Code';
                        TableRelation = Location;
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
        if "Warehouse Inbound Header".GetFilter("No.") = '' then
            Error(Text001);

        SI.UseOfReport(3, 62016, 2);  // 14-10-20 ZY-LD 000
    end;

    var
        WhseStatus: Option " ","Order Sent","Order Sent (2)","Goods Received","Putting Away","On Stock";
        DocStatus: Option Open,Released,Posted;
        Text001: label 'Please enter a filter in "No."';
        LocationCode: Code[10];
        SI: Codeunit "Single Instance";


    procedure InitReport(NewWhseStatus: Option " ","Order Sent","Order Sent (2)","Goods Received","Putting Away","On Stock"; NewDocStatus: Option Open,Released,Posted; NewLocationCode: Code[10])
    begin
        WhseStatus := NewWhseStatus;
        DocStatus := NewDocStatus;
        LocationCode := NewLocationCode;
    end;
}
