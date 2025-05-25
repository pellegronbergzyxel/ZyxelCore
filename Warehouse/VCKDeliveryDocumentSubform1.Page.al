Page 50088 "VCK Delivery Document Subform1"
{
    // 001. 06-10-17 ZY-LD 000 - Edit Quantity
    // 002. 09-08-19 ZY-LD 000 - View sales invoice.
    // 003. 18-05-22 ZY-LD 2022011110000088 - We don´t want to see "Freight Cost Items" on the DD.

    Caption = 'Delivery Document Lines';
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = "VCK Delivery Document Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = false;
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field(Control1000000005; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = QuantityEditable;
                }

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(getTotalQTYperCarton; item.getTotalQTYperCarton(Rec."Item No."))
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    caption = 'Total Qty. per Carton';
                    BlankZero = true;
                }


                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
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
                field("Customer Order Position No."; Rec."Customer Order Position No.") //23-05-2025 BK #508124
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    Style = Strong;
                    StyleExpr = true;
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
                field("No of Serial No."; Rec."No of Serial No.")
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
            action(ShowAllLines)
            {
                Caption = 'Show Freight Lines';
                Image = ClearFilter;
                trigger OnAction()
                begin
                    Rec.SetRange("Freight Cost Item");
                end;
            }

            group(View)
            {
                Caption = 'View';
                Image = View;
                action("Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Order';
                    Image = "Order";

                    trigger OnAction()
                    begin
                        Rec.CalcFields(Rec."Document Type");
                        case Rec."Document Type" of
                            Rec."document type"::Sales:
                                ViewSalesOrder;
                            Rec."document type"::Transfer:
                                ViewTransferOrder;
                        end;
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
                    Visible = false;
                }
                action("Sales Shipment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Shipment';
                    Image = SalesShipment;
                    RunObject = Page "Posted Sales Shipment";
                    RunPageLink = "Order No." = field("Sales Order No.");
                }
                action("Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Invoice';
                    Image = Invoice;

                    trigger OnAction()
                    begin
                        ViewSalesInvoice;  // 09-08-19 ZY-LD 002
                    end;
                }
            }
            group(Edit)
            {
                Caption = 'Edit';
                Visible = EditButtonVisible;
                Image = Edit;
                action(Delete)
                {
                    Caption = 'Delete Line';
                    Image = Delete;
                    trigger OnAction()
                    var
                        lText001: Label 'Go ahead and delete?';
                    begin
                        if Confirm(lText001) then
                            Rec.Delete(true);
                    end;
                }
                action(Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity';
                    Image = Edit;

                    trigger OnAction()
                    begin
                        ZyXELVCKEditDeliveryDoc.EditQuantity(Rec);  // 06-10-17 ZY-LD 001
                    end;
                }
                action("Edit Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unit Price Excl. VAT';
                    Image = Edit;

                    trigger OnAction()
                    begin
                        ZyXELVCKEditDeliveryDoc.EditUnitPriceExclVAT(Rec);  // 27-11-23 ZY-LD 001
                    end;

                }
                action("Validate Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Validate Amount';
                    Image = EditLines;

                    trigger OnAction()
                    begin
                        if Confirm(Text003, true) then begin
                            Rec.Validate(Rec.Amount);
                            Rec.Modify(true);
                        end;
                    end;
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
        SetActions;

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
        PickingDateTimeOnFormat;
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
        SetActions;
        Rec.SetRange(Rec."Freight Cost Item", false);  // 18-05-22 ZY-LD 001
    end;

    var
        item: Record Item;
        MakeBold: Boolean;
        Color: Integer;
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
        "Picking Date TimeEmphasize": Boolean;
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
        QuantityEditable: Boolean;
        ZyXELVCKEditDeliveryDoc: Codeunit "ZyXEL VCK Edit Delivery Doc.";
        EditButtonVisible: Boolean;
        Text003: label 'Do you want to validate Amount?';


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
        if recSalesOrder.Get(recSalesOrder."document type"::Order, Rec."Sales Order No.") then
            Page.RunModal(Page::"Sales Order", recSalesOrder);
    end;


    procedure ViewTransferOrder()
    var
        recTransferOrder: Record "Transfer Header";
    begin
        if recTransferOrder.Get(Rec."Sales Order No.") then
            Page.RunModal(Page::"Transfer Order", recTransferOrder);
    end;

    local procedure ViewSalesInvoice()
    var
        recSalesShipLine: Record "Sales Shipment Line";
        recSalesInvLine: Record "Sales Invoice Line";
        recSalesInvHead: Record "Sales Invoice Header";
    begin
        //>> 09-08-19 ZY-LD 002
        recSalesShipLine.SetRange("Order No.", Rec."Sales Order No.");
        recSalesShipLine.SetRange("Order Line No.", Rec."Sales Order Line No.");
        if recSalesShipLine.FindFirst then begin
            recSalesInvLine.SetRange("Shipment No.", recSalesShipLine."Document No.");
            recSalesInvLine.SetRange("Shipment Line No.", recSalesShipLine."Line No.");
            if recSalesInvLine.FindFirst then begin
                recSalesInvHead.Get(recSalesInvLine."Document No.");
                Page.RunModal(Page::"Posted Sales Invoice", recSalesInvHead);
            end;
        end;
        //>> 09-08-19 ZY-LD 002
    end;


    procedure CheckStatus()
    begin
        MakeBold := false;
        Color := 0;
        if Rec."Warehouse Status" = Rec."warehouse status"::Error then begin
            MakeBold := true;
            Color := 255;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Backorder then begin
            MakeBold := true;
            Color := 16711680;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Ready to Pick" then begin
            MakeBold := true;
            Color := 5458;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Picking then begin
            MakeBold := true;
            Color := 5458;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Packed then begin
            MakeBold := true;
            Color := 5458;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Waiting for invoice" then begin
            MakeBold := true;
            Color := 255;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"Invoice Received" then begin
            MakeBold := true;
            Color := 32768;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Posted then begin
            MakeBold := true;
            Color := 32768;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::"In Transit" then begin
            MakeBold := true;
            Color := 32768;
        end;
        if Rec."Warehouse Status" = Rec."warehouse status"::Delivered then begin
            MakeBold := true;
            Color := 32768;
        end;
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

    local procedure PickingDateTimeOnFormat()
    begin
        CheckStatus;
        "Picking Date TimeEmphasize" := MakeBold;
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

    local procedure SetActions()
    begin
        EditButtonVisible := Rec."Warehouse Status" < Rec."warehouse status"::Posted;
    end;
}
