Page 50087 "VCK Delivery Document Subform"
{
    // 001. 18-05-22 ZY-LD 2022011110000088 - We don´t want to see "Freight Cost Items" on the DD.

    Caption = 'Delivery Document Lines';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "VCK Delivery Document Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = true;
                    Editable = false;
                    Visible = false;

                    trigger OnAssistEdit()
                    var
                        recSalesHeader: Record "Sales Header";
                    begin
                        recSalesHeader.SetFilter("No.", Rec."Sales Order No.");
                        if not recSalesHeader.FindFirst then Error(Text0001);
                        Page.RunModal(42, recSalesHeader)
                    end;
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Customer Order No."; Rec."Customer Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    Visible = false;
                }
                field("Loading Date Time"; Rec."Loading Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Delivery Date Time"; Rec."Delivery Date Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Delivery Remark"; Rec."Delivery Remark")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Receiver Reference"; Rec."Receiver Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shipper Reference"; Rec."Shipper Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Signed By"; Rec."Signed By")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Has Serial No"; Rec."Has Serial No")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(View)
            {
                Caption = 'View';
                action("Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Order';
                    Image = "Order";

                    trigger OnAction()
                    begin
                        ViewSalesOrder;
                    end;
                }
                action("Sales Invoice Line")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Invoice Line';
                    Image = Line;
                    RunObject = Page "Sales Invoice Line";
                    RunPageLink = "Picking List No." = field("Document No."),
                                  Type = const(Item),
                                  "No." = field("Item No.");
                }
            }
            action("Serial Numbers")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Serial Numbers';
                Image = SerialNo;
                RunObject = Page "VCK Delivery Document SNos";
                RunPageLink = "Delivery Document No." = field("Document No."),
                              "Delivery Document Line No." = field("Line No.");
                RunPageView = sorting("Serial No.", "Delivery Document No.", "Delivery Document Line No.");

                trigger OnAction()
                var
                    frmSerials: Page "VCK Delivery Document SNos";
                begin
                    //frmSerials.FilterByDeliveryDocument(Rec."No.");
                    //frmSerials.RUNMODAL;
                end;
            }
            action("Export Excel")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export Excel';
                Image = ExportToExcel;
                ToolTip = 'Export lines to Excel';

                trigger OnAction()
                begin
                    ExportExcel;
                end;
            }
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;
                RunObject = Page "Change Log Entries";
                RunPageLink = "Primary Key Field 1 Value" = field("Document No.");
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(50042));
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ItemNoOnFormat;
        DescriptionOnFormat;
        ActionCodeOnFormat;
        SalespersonCodeOnFormat;
        QuantityOnFormat;
        UnitPriceOnFormat;
        CurrencyCodeOnFormat;
        LocationOnFormat;
        SalesOrderNoOnFormat;
        TransferOrderNoOnFormat;
        CustomerOrderNoOnFormat;
        WarehouseStatusOnFormat;
        LoadingDateTimeOnFormat;
        DeliveryDateTimeOnFormat;
        DeliveryRemarkOnFormat;
        DeliveryStatusOnFormat;
        ReceiverReferenceOnFormat;
        ShipperReferenceOnFormat;
        SignedByOnFormat;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Rec."Freight Cost Item", false);  // 18-05-22 ZY-LD 001
    end;

    var
        MakeBold: Boolean;
        color: Integer;
        Text001: label 'Are you sure that you want to delete the line %1?';
        [InDataSet]
        "Item No.Emphasize": Boolean;
        [InDataSet]
        DescriptionEmphasize: Boolean;
        [InDataSet]
        "Action CodeEmphasize": Boolean;
        [InDataSet]
        "Salesperson CodeEmphasize": Boolean;
        [InDataSet]
        QuantityEmphasize: Boolean;
        [InDataSet]
        "Unit PriceEmphasize": Boolean;
        [InDataSet]
        "Currency CodeEmphasize": Boolean;
        [InDataSet]
        LocationEmphasize: Boolean;
        [InDataSet]
        "Sales Order No.Emphasize": Boolean;
        [InDataSet]
        "Transfer Order No.Emphasize": Boolean;
        [InDataSet]
        "Customer Order No.Emphasize": Boolean;
        [InDataSet]
        "Warehouse StatusEmphasize": Boolean;
        [InDataSet]
        "Loading Date TimeEmphasize": Boolean;
        [InDataSet]
        "Delivery Date TimeEmphasize": Boolean;
        [InDataSet]
        "Delivery RemarkEmphasize": Boolean;
        [InDataSet]
        "Delivery StatusEmphasize": Boolean;
        [InDataSet]
        "Receiver ReferenceEmphasize": Boolean;
        [InDataSet]
        "Shipper ReferenceEmphasize": Boolean;
        [InDataSet]
        "Signed ByEmphasize": Boolean;
        Text0001: label 'The Sales Order is no longer available.';
        Text0002: label 'The Transfer Order is no longer available.';
        TempExcelBuffer: Record "Excel Buffer" temporary;


    procedure CheckStatus()
    begin
        MakeBold := false;
        color := 0;
        if Rec."Warehouse Status" = Rec."warehouse status"::Error then begin
            MakeBold := true;
            color := 255;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Backorder then begin
            MakeBold := true;
            color := 16711680;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Ready to Pick" then begin
            MakeBold := true;
            color := 5458;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Picking then begin
            MakeBold := true;
            color := 5458;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Packed then begin
            MakeBold := true;
            color := 5458;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Waiting for invoice" then begin
            MakeBold := true;
            color := 255;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Invoice Received" then begin
            MakeBold := true;
            color := 32768;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Posted then begin
            MakeBold := true;
            color := 32768;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"In Transit" then begin
            MakeBold := true;
            color := 32768;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Delivered then begin
            MakeBold := true;
            color := 32768;
        end;
    end;


    procedure ViewItemCard(Show: Boolean)
    var
        recItem: Record Item;
    begin
        if Rec."Item No." <> '' then begin
            recItem.SetFilter("No.", Rec."Item No.");
            if recItem.FindFirst then
                Page.RunModal(30, recItem);
        end;
    end;


    procedure ViewSerialNo()
    var
        frmSerials: Page "VCK Delivery Document SNos";
    begin
        if not Rec."Has Serial No" then
            Error('The selected line does not have any serial numbers.');

        //frmSerials.FilterByDeliveryDocumentAndLin(Rec."Document No.",Rec."Line No.");
        frmSerials.RunModal;
    end;


    procedure ViewSalesOrder()
    var
        recSalesOrder: Record "Sales Header";
    begin
        if Rec."Sales Order No." = '' then
            Error('The selected line does not have a Sales Order.');

        recSalesOrder.SetFilter("No.", Rec."Sales Order No.");
        if recSalesOrder.FindFirst then
            Page.RunModal(42, recSalesOrder);
    end;


    procedure ViewTransferOrder()
    var
        recTransferOrder: Record "Transfer Header";
    begin
        if Rec."Transfer Order No." = '' then
            Error('The selected line does not have a Transfer Order.');

        recTransferOrder.SetFilter("No.", Rec."Transfer Order No.");
        if recTransferOrder.FindFirst then
            Page.RunModal(5740, recTransferOrder);
    end;


    procedure DeleteLine()
    var
        recSalesLine: Record "Sales Line";
    begin
        if Confirm(Text001, false, Rec."Item No.") then begin
            if Rec."Ignore In Posting" = false then begin
                recSalesLine.SetFilter("Document No.", Rec."Sales Order No.");
                recSalesLine.SetRange("Line No.", Rec."Sales Order Line No.");
                if recSalesLine.FindFirst then begin
                    recSalesLine."Delivery Document No." := '';
                    recSalesLine.Modify;
                end;
            end;
            Rec.Delete;
        end;
    end;

    local procedure ItemNoOnFormat()
    begin
        CheckStatus;
        "Item No.Emphasize" := MakeBold;
    end;

    local procedure DescriptionOnFormat()
    begin
        CheckStatus;
        DescriptionEmphasize := MakeBold;
    end;

    local procedure ActionCodeOnFormat()
    begin
        CheckStatus;
        "Action CodeEmphasize" := MakeBold;
    end;

    local procedure SalespersonCodeOnFormat()
    begin
        CheckStatus;
        "Salesperson CodeEmphasize" := MakeBold;
    end;

    local procedure QuantityOnFormat()
    begin
        CheckStatus;
        QuantityEmphasize := MakeBold;
    end;

    local procedure UnitPriceOnFormat()
    begin
        CheckStatus;
        "Unit PriceEmphasize" := MakeBold;
    end;

    local procedure CurrencyCodeOnFormat()
    begin
        CheckStatus;
        "Currency CodeEmphasize" := MakeBold;
    end;

    local procedure LocationOnFormat()
    begin
        CheckStatus;
        LocationEmphasize := MakeBold;
    end;

    local procedure SalesOrderNoOnFormat()
    begin
        CheckStatus;
        "Sales Order No.Emphasize" := MakeBold;
    end;

    local procedure TransferOrderNoOnFormat()
    begin
        CheckStatus;
        "Transfer Order No.Emphasize" := MakeBold;
    end;

    local procedure CustomerOrderNoOnFormat()
    begin
        CheckStatus;
        "Customer Order No.Emphasize" := MakeBold;
    end;

    local procedure WarehouseStatusOnFormat()
    begin
        CheckStatus;
        "Warehouse StatusEmphasize" := MakeBold;
    end;

    local procedure LoadingDateTimeOnFormat()
    begin
        CheckStatus;
        "Loading Date TimeEmphasize" := MakeBold;
    end;

    local procedure DeliveryDateTimeOnFormat()
    begin
        CheckStatus;
        "Delivery Date TimeEmphasize" := MakeBold;
    end;

    local procedure DeliveryRemarkOnFormat()
    begin
        CheckStatus;
        "Delivery RemarkEmphasize" := MakeBold;
    end;

    local procedure DeliveryStatusOnFormat()
    begin
        CheckStatus;
        "Delivery StatusEmphasize" := MakeBold;
    end;

    local procedure ReceiverReferenceOnFormat()
    begin
        CheckStatus;
        "Receiver ReferenceEmphasize" := MakeBold;
    end;

    local procedure ShipperReferenceOnFormat()
    begin
        CheckStatus;
        "Shipper ReferenceEmphasize" := MakeBold;
    end;

    local procedure SignedByOnFormat()
    begin
        CheckStatus;
        "Signed ByEmphasize" := MakeBold;
    end;

    local procedure ExportExcel()
    var
        ddnumber: Code[30];
        recDeliveryDocumentLine: Record "VCK Delivery Document Line";
        Window: Dialog;
        RecNo: Integer;
        TotalRecNo: Integer;
        RowNo: Integer;
        Text000: label 'Analyzing Data...\\';
    begin

        ddnumber := Rec."Document No.";
        recDeliveryDocumentLine.SetFilter("Document No.", ddnumber);
        Window.Open(Text000 + '@1@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        RecNo := 0;
        TempExcelBuffer.DeleteAll;
        Clear(TempExcelBuffer);
        RowNo := 1;
        EnterCell(RowNo, 1, 'Document No.', true, false, false);
        EnterCell(RowNo, 2, 'Line No.', true, false, false);
        EnterCell(RowNo, 3, 'Item No.', true, false, false);
        EnterCell(RowNo, 4, 'Description', true, false, false);
        EnterCell(RowNo, 5, 'Quantity', true, false, false);
        EnterCell(RowNo, 6, 'Unit Price', true, false, false);
        EnterCell(RowNo, 7, 'Location', true, false, false);
        EnterCell(RowNo, 8, 'Sales Order No.', true, false, false);
        EnterCell(RowNo, 9, 'Customer Order No.', true, false, false);
        EnterCell(RowNo, 10, 'Warehouse Status', true, false, false);
        EnterCell(RowNo, 11, 'Action Code', true, false, false);
        EnterCell(RowNo, 12, 'Sales Order Line No.', true, false, false);
        EnterCell(RowNo, 13, 'Transfer Order Line No.', true, false, false);
        EnterCell(RowNo, 14, 'Transfer Order No.', true, false, false);
        EnterCell(RowNo, 15, 'Currency Code', true, false, false);
        EnterCell(RowNo, 16, 'Picking Date Time', true, false, false);
        EnterCell(RowNo, 17, 'Loading Date Time', true, false, false);
        EnterCell(RowNo, 18, 'Delivery Date Time', true, false, false);
        EnterCell(RowNo, 19, 'Delivery Remark', true, false, false);
        EnterCell(RowNo, 20, 'Delivery Status', true, false, false);
        EnterCell(RowNo, 21, 'Receiver Reference', true, false, false);
        EnterCell(RowNo, 22, 'Shipper Reference', true, false, false);
        EnterCell(RowNo, 23, 'Signed By', true, false, false);
        EnterCell(RowNo, 24, 'Shipment Date', true, false, false);
        EnterCell(RowNo, 25, 'Salesperson Code', true, false, false);
        EnterCell(RowNo, 26, 'PickDate', true, false, false);
        EnterCell(RowNo, 27, 'Requested Delivery Date', true, false, false);
        EnterCell(RowNo, 28, 'Release Date', true, false, false);
        EnterCell(RowNo, 29, 'Requested Ship Date', true, false, false);
        TotalRecNo := recDeliveryDocumentLine.Count;
        if recDeliveryDocumentLine.FindFirst then begin
            repeat
                RowNo := RowNo + 1;
                EnterCell(RowNo, 1, recDeliveryDocumentLine."Document No.", false, false, false);
                EnterCell(RowNo, 2, Format(recDeliveryDocumentLine."Line No."), false, false, false);
                EnterCell(RowNo, 3, recDeliveryDocumentLine."Item No.", false, false, false);
                EnterCell(RowNo, 4, recDeliveryDocumentLine.Description, false, false, false);
                EnterCell(RowNo, 5, Format(recDeliveryDocumentLine.Quantity), false, false, false);
                EnterCell(RowNo, 6, Format(recDeliveryDocumentLine."Unit Price"), false, false, false);
                EnterCell(RowNo, 7, recDeliveryDocumentLine.Location, false, false, false);
                EnterCell(RowNo, 8, recDeliveryDocumentLine."Sales Order No.", false, false, false);
                EnterCell(RowNo, 9, recDeliveryDocumentLine."Customer Order No.", false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 0 then EnterCell(RowNo, 10, 'New', false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 1 then EnterCell(RowNo, 10, 'Backorder', false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 2 then EnterCell(RowNo, 10, 'Ready to Pick', false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 3 then EnterCell(RowNo, 10, 'Picking', false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 4 then EnterCell(RowNo, 10, 'Packed', false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 5 then EnterCell(RowNo, 10, 'Waiting for Invoice', false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 6 then EnterCell(RowNo, 10, 'Invoice Received', false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 7 then EnterCell(RowNo, 10, 'Posted', false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 8 then EnterCell(RowNo, 10, 'In Transit', false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 9 then EnterCell(RowNo, 10, 'Delivered', false, false, false);
                if recDeliveryDocumentLine."Warehouse Status" = 10 then EnterCell(RowNo, 10, 'Error', false, false, false);
                EnterCell(RowNo, 11, recDeliveryDocumentLine."Action Code", false, false, false);
                EnterCell(RowNo, 12, Format(recDeliveryDocumentLine."Sales Order Line No."), false, false, false);
                EnterCell(RowNo, 13, Format(recDeliveryDocumentLine."Transfer Order Line No."), false, false, false);
                EnterCell(RowNo, 14, recDeliveryDocumentLine."Transfer Order No.", false, false, false);
                EnterCell(RowNo, 15, recDeliveryDocumentLine."Currency Code", false, false, false);
                EnterCell(RowNo, 16, recDeliveryDocumentLine."Picking Date Time", false, false, false);
                EnterCell(RowNo, 17, recDeliveryDocumentLine."Loading Date Time", false, false, false);
                EnterCell(RowNo, 18, recDeliveryDocumentLine."Delivery Date Time", false, false, false);
                EnterCell(RowNo, 19, recDeliveryDocumentLine."Delivery Remark", false, false, false);
                EnterCell(RowNo, 20, recDeliveryDocumentLine."Delivery Status", false, false, false);
                EnterCell(RowNo, 21, recDeliveryDocumentLine."Receiver Reference", false, false, false);
                EnterCell(RowNo, 22, recDeliveryDocumentLine."Shipper Reference", false, false, false);
                EnterCell(RowNo, 23, recDeliveryDocumentLine."Signed By", false, false, false);
                EnterCell(RowNo, 24, Format(recDeliveryDocumentLine."Shipment Date"), false, false, false);
                EnterCell(RowNo, 25, recDeliveryDocumentLine."Salesperson Code", false, false, false);
                EnterCell(RowNo, 26, Format(recDeliveryDocumentLine.PickDate), false, false, false);
                EnterCell(RowNo, 27, Format(recDeliveryDocumentLine."Requested Delivery Date"), false, false, false);
                EnterCell(RowNo, 28, Format(recDeliveryDocumentLine."Release Date"), false, false, false);
                EnterCell(RowNo, 29, Format(recDeliveryDocumentLine."Requested Ship Date"), false, false, false);
                Window.Update(1, ROUND(RowNo / TotalRecNo * 10000, 1));
            until recDeliveryDocumentLine.Next() = 0;
        end;
        Window.Close;
        TempExcelBuffer.CreateBook('', 'Delivery Document Lines');
        TempExcelBuffer.WriteSheet('Delivery Document Lines', CompanyName(), UserId());
        TempExcelBuffer.CloseBook;
        TempExcelBuffer.OpenExcel;
    end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean)
    begin
        TempExcelBuffer.Init;
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.Insert;
    end;
}
