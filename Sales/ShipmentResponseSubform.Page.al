Page 50054 "Shipment Response Subform"
{
    // 001. 19-02-19 PAB - Updated for new NAV XML
    // 002. 01-08-22 ZY-LD 000 - Lookup Transfer order.

    Caption = 'List';
    DeleteAllowed = false;
    Description = 'Shipment Response Subform';
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Ship Response Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Product No."; Rec."Product No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Alt. Product No."; Rec."Alt. Product No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Warehouse; Rec.Warehouse)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Ordered Quantity"; Rec."Ordered Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sales Order Qty. Shipped"; Rec."Sales Order Qty. Shipped")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Customer Order No."; Rec."Customer Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Order Line No."; Rec."Customer Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Value 1"; Rec."Value 1")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Value 2"; Rec."Value 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 3"; Rec."Value 3")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 4"; Rec."Value 4")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 5"; Rec."Value 5")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 6"; Rec."Value 6")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 7"; Rec."Value 7")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 8"; Rec."Value 8")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Value 9"; Rec."Value 9")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Control27; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Previously Posted"; Rec."Previously Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Delivery Document Line Posted"; Rec."Delivery Document Line Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Error Text"; Rec."Error Text")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Quantity on Delivery Document"; Rec."Quantity on Delivery Document")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("No. of Serial No."; Rec."No. of Serial No.")
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
            action("Show Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Order';
                Image = ViewOrder;

                trigger OnAction()
                var
                    recDelDocHead: Record "VCK Delivery Document Header";
                    recSalesHead: Record "Sales Header";
                    recTransHead: Record "Transfer Header";
                begin
                    //>> 01-08-22 ZY-LD 002
                    recDelDocHead.Get(Rec."Sales Order No.");
                    case recDelDocHead."Document Type" of
                        recDelDocHead."document type"::Sales:
                            if recSalesHead.Get(recSalesHead."document type"::Order, Rec."Customer Order No.") then
                                Page.Run(Page::"Sales Order", recSalesHead);
                        recDelDocHead."document type"::Transfer:
                            if recTransHead.Get(Rec."Customer Order No.") then
                                Page.Run(Page::"Transfer Order", recTransHead);
                    end;
                    //<< 01-08-22 ZY-LD 002
                end;
            }
            group("Set Line(s) to")
            {
                Caption = 'Set Line(s) to';
                action(Closed)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Closed';
                    Image = Close;

                    trigger OnAction()
                    begin
                        if Confirm(Text001) then
                            if Confirm(Text002) then begin
                                CurrPage.SetSelectionFilter(recShipRespLine);
                                if recShipRespLine.FindSet(true) then
                                    repeat
                                        recShipRespLine.Open := false;
                                        recShipRespLine.Modify;
                                    until recShipRespLine.Next() = 0;
                                CurrPage.Update;
                            end;
                    end;
                }
                action(Open)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Open';
                    Image = Open;

                    trigger OnAction()
                    begin
                        if Confirm(Text003) then
                            if Confirm(Text002) then begin
                                CurrPage.SetSelectionFilter(recShipRespLine);
                                if recShipRespLine.FindSet(true) then
                                    repeat
                                        recShipRespLine.Open := true;
                                        recShipRespLine.Modify;
                                    until recShipRespLine.Next() = 0;
                                CurrPage.Update;
                            end;
                    end;
                }
            }
            action("Recreate Line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Recreate Line';
                Image = CreateWarehousePick;
                ToolTip = 'If a delivery document line has been delted, but the warehouse has shipped it, you can recreate the delivery document line by using this function.';
                trigger OnAction()
                var
                    DelDocLine: Record "VCK Delivery Document Line";
                    CustOrderNo: Code[20];
                    CustOrderLineNo: Integer;
                begin
                    if Rec."Customer Order Line No." = 0 then begin
                        DelDocLine.RecreateLineFromChangeLog(Rec."Sales Order No.", Rec."Sales Order Line No.", CustOrderNo, CustOrderLineNo);
                        Rec."Customer Order No." := CustOrderNo;
                        Rec."Customer Order Line No." := CustOrderLineNo;
                        Rec.Modify(true);
                    end;
                end;
            }
        }
    }

    var
        recShipRespLine: Record "Ship Response Line";
        VCKXML: Codeunit "VCK Communication Management";
        Text001: label 'Do you want to close the line(s)?';
        Text002: label 'Are you sure?';
        Text003: label 'Do you want to open the line(s)?';
}
