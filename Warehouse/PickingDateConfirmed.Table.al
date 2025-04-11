Table 50000 "Picking Date Confirmed"
{
    Caption = 'Picking Date Confirmed';
    DataCaptionFields = "Source Type", "Source No.", "Source Line No.";
    DrillDownPageID = "Picking Date Confirmed";
    LookupPageID = "Picking Date Confirmed";

    // 001. 07-03-24 ZY-LD 000 - We mark that the change comes from a page.

    fields
    {
        field(1; "Source Type"; Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'Sales Order,Transfer Order,Rework';
            OptionMembers = "Sales Order","Transfer Order",Rework;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
            TableRelation = if ("Source Type" = const("Sales Order")) "Sales Header"."No." where("Document Type" = const(Order))
            else
            if ("Source Type" = const("Transfer Order")) "Transfer Header";
        }
        field(3; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
            Editable = false;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(5; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(6; "Outstanding Quantity (Base)"; Decimal)
        {
            Caption = 'Outstanding Quantity (Base)';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(7; "Picking Date Confirmed"; Boolean)
        {
            Caption = 'Picking Date Confirmed';

            trigger OnValidate()
            begin
                case "Source Type" of
                    "source type"::"Sales Order":
                        if recSalesLine.Get(recSalesLine."document type"::Order, "Source No.", "Source Line No.") then begin
                            SI.SetValidateFromPage(true);
                            recSalesLine.SuspendStatusCheck(true);
                            recSalesLine.Validate("Shipment Date Confirmed", "Picking Date Confirmed");
                            recSalesLine.Modify(true);
                            recSalesLine.SuspendStatusCheck(false);
                            Get("Source Type", "Source No.", "Source Line No.");
                            SI.SetValidateFromPage(false);
                        end;
                    "source type"::"Transfer Order":
                        if recTransferLine.Get("Source No.", "Source Line No.") then begin
                            SI.SetValidateFromPage(true);
                            recTransferLine.Validate("Shipment Date Confirmed", "Picking Date Confirmed");
                            recTransferLine.Modify(true);
                            Get("Source Type", "Source No.", "Source Line No.");
                            SI.SetValidateFromPage(false);
                        end;
                end;
            end;
        }
        field(8; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location;
        }
        field(9; "Picking Date"; Date)
        {
            Caption = 'Picking Date';

            trigger OnValidate()
            begin
                case "Source Type" of
                    "source type"::"Sales Order":
                        if recSalesLine.Get(recSalesLine."document type"::Order, "Source No.", "Source Line No.") then begin
                            SI.SetValidateFromPage(true);  // 07-03-24 ZY-LD 001
                            recSalesLine.SuspendStatusCheck(true);
                            recSalesLine.Validate("Shipment Date", "Picking Date");
                            recSalesLine.Modify(true);
                            recSalesLine.SuspendStatusCheck(false);
                            Get("Source Type", "Source No.", "Source Line No.");
                            SI.SetValidateFromPage(false);  // 07-03-24 ZY-LD 001
                        end;
                    "source type"::"Transfer Order":
                        if recTransferLine.Get("Source No.", "Source Line No.") then begin
                            recTransferLine.Validate("Shipment Date", "Picking Date");
                            recTransferLine.Modify(true);
                            Get("Source Type", "Source No.", "Source Line No.");
                        end;
                end;
            end;
        }
        field(10; "Marked Entry"; Boolean)
        {
            Caption = 'Marked Entry';
            Editable = false;
            InitValue = true;
        }
        field(11; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(12; "Sell-to Customer No."; Code[20])
        {
            CalcFormula = lookup("Sales Line"."Sell-to Customer No." where("Document Type" = const(Order),
                                                                            "Document No." = field("Source No."),
                                                                            "Line No." = field("Source Line No.")));
            Caption = 'Sell-to Customer No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Customer;
        }
        field(13; "Transfer-to Code"; Code[10])
        {
            CalcFormula = lookup("Transfer Line"."Transfer-to Code" where("Document No." = field("Source No."),
                                                                           "Line No." = field("Source Line No.")));
            Caption = 'Transfer-to Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Sell-to Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
            Caption = 'Sell-to Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Country Code"; Code[20])
        {
            Caption = 'Country Code';
            Editable = false;
        }
        field(17; "Sales Order Line Exist"; Boolean)
        {
            CalcFormula = exist("Sales Line" where("Document No." = field("Source No."),
                                                    "Line No." = field("Source Line No.")));
            Caption = 'Sales Order Line Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Order Date"; Date)
        {
            CalcFormula = lookup("Sales Header"."Order Date" where("Document Type" = const(Order),
                                                                    "No." = field("Source No.")));
            Caption = 'Order Date';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Source Type", "Source No.", "Source Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Picking Date", "Picking Date Confirmed")
        {
        }
        key(Key3; "Country Code", "Picking Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        recSalesLine: Record "Sales Line";
        recTransferLine: Record "Transfer Line";
        SI: Codeunit "Single Instance";


    procedure UpdatePickingDate(var pPickDate: Record "Picking Date Confirmed")
    var
        recSalesLine: Record "Sales Line";
        recTransferLine: Record "Transfer Line";
        GenericInputPage: Page "Generic Input Page";
        lText001: label 'Set New Picking Date';
        lText002: label 'New Picking Date';
        NewPickingDate: Date;
        lText003: label 'Do you want to update "%1" on %2 line(s)?';
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if pPickDate.FindSet then begin
            GenericInputPage.SetPageCaption(lText001);
            GenericInputPage.SetFieldCaption(lText002);
            GenericInputPage.SetVisibleField(4);
            GenericInputPage.SetDate(Today);
            if GenericInputPage.RunModal = Action::OK then
                if Confirm(lText003, false, pPickDate.FieldCaption("Picking Date"), pPickDate.Count) then begin
                    NewPickingDate := GenericInputPage.GetDate;

                    ZGT.OpenProgressWindow('', pPickDate.Count);
                    repeat
                        ZGT.UpdateProgressWindow(pPickDate."Source No.", 0, true);

                        case pPickDate."Source Type" of
                            "source type"::"Sales Order":
                                begin
                                    if recSalesLine.Get(recSalesLine."document type"::Order, pPickDate."Source No.", pPickDate."Source Line No.") then begin
                                        recSalesLine.SuspendStatusCheck(true);
                                        recSalesLine.Validate("Shipment Date", NewPickingDate);
                                        recSalesLine.Modify(true);
                                        recSalesLine.SuspendStatusCheck(false);
                                    end;
                                end;
                            "source type"::"Transfer Order":
                                begin
                                    if recTransferLine.Get(pPickDate."Source No.", pPickDate."Source Line No.") then begin
                                        recTransferLine.Validate("Shipment Date", NewPickingDate);
                                        recTransferLine.Modify(true);
                                    end;
                                end;
                        end;
                    until pPickDate.Next() = 0;
                    ZGT.CloseProgressWindow;
                end;
        end;
    end;


    procedure DeleteSalesOrderLines(var pPickDate: Record "Picking Date Confirmed")
    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        lText001: label 'Do you want to delete %1 sales order lines?';
        ZGT: Codeunit "ZyXEL General Tools";
        lText002: label 'Are you sure?';
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        SaleHeadLineEvent: Codeunit "Sales Header/Line Events";
    begin
        if pPickDate.FindSet then
            if Confirm(lText001, false, pPickDate.Count) then
                if Confirm(lText002) then begin
                    ZGT.OpenProgressWindow('', pPickDate.Count);
                    repeat
                        ZGT.UpdateProgressWindow(pPickDate."Source No.", 0, true);

                        case pPickDate."Source Type" of
                            "source type"::"Sales Order":
                                begin
                                    recSalesHead.Get(recSalesHead."document type"::Order, pPickDate."Source No.");
                                    ReleaseSalesDoc.Reopen(recSalesHead);
                                    SaleHeadLineEvent.OnAfterActionEventReOpen(recSalesHead);

                                    if recSalesLine.Get(recSalesLine."document type"::Order, pPickDate."Source No.", pPickDate."Source Line No.") then begin
                                        recSalesLine.SuspendStatusCheck(true);
                                        recSalesLine.Delete(true);
                                        recSalesLine.SuspendStatusCheck(false);
                                    end;

                                    ReleaseSalesDoc.PerformManualRelease(recSalesHead);
                                    SaleHeadLineEvent.OnAfterActionEventRelease(recSalesHead);
                                end;
                        end;
                    until pPickDate.Next() = 0;
                end;
    end;
}
