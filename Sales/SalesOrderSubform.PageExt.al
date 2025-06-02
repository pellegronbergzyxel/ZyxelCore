pageextension 50129 SalesOrderSubformZX extends "Sales Order Subform"
{
    layout
    {
        modify(Control1)
        {
            Editable = LineEditable;
        }
        modify("No.")
        {
            StyleExpr = StyleExprAdditionalItem;

            trigger OnAfterValidate()
            begin
                // PAB
                CurrPage.SAVERECORD();

                if not DisableAddItem then  // 09-04-18 ZY-LD 006
                    ZyXELAdditionalItems.InsertAdditionalItems(Rec."Document Type", Rec."Document No.", Rec."No.", Rec."Line No.");
                CurrPage.Update();
            end;
        }
        modify("Location Code")
        {
            Editable = false;
        }
        modify("Line Discount %")
        {
            Editable = LineDiscountEditable;
        }
        modify("Line Discount Amount")
        {
            Editable = LineDiscountEditable;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                UpdateAdditionalLine(Rec.FieldNo(Quantity), Rec.Quantity);  // 04-01-18 ZY-LD 002        
            end;
        }
        modify("Qty. to Ship")
        {
            trigger OnAfterValidate()
            begin
                UpdateAdditionalLine(Rec.FieldNo("Qty. to Ship"), Rec."Qty. to Ship");  // 04-01-18 ZY-LD 002
            end;
        }
        modify("Qty. to Invoice")
        {
            trigger OnAfterValidate()
            begin
                UpdateAdditionalLine(Rec.FieldNo("Qty. to Invoice"), Rec."Qty. to Invoice");  // 04-01-18 ZY-LD 002
            end;
        }
        modify("Shipment Date")
        {
            trigger OnBeforeValidate()
            begin
                if Rec."Shipment Date Confirmed" then
                    Error(Text004); //15-51643
            end;

            trigger OnAfterValidate()
            begin
                UpdateAdditionalLine(Rec.FieldNo("Shipment Date"), Rec."Shipment Date");  // 04-01-18 ZY-LD 002
            end;
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }
        addfirst(Control1)
        {
            field("Hide Line"; Rec."Hide Line")
            {
                ApplicationArea = Basic, Suite;
            }
        }

        Addlast(Control1)
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                Editable = true;
            }
            field(AmazconUnitprice; Rec.AmazconUnitprice)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                Editable = false;
                StyleExpr = amazStyle;
            }
            field(AmazconfirmationStatus; Rec.AmazconfirmationStatus)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                Editable = false;
            }
            field(AmazonpurchaseOrderState; Rec.AmazonpurchaseOrderState)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                Editable = false;
            }
        }
        addafter("No.")
        {
            field(AdditionalRelation; AdditionalRelation)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Additional Item Relation';
                Editable = false;
                StyleExpr = StyleExprAdditionalItem;
                Visible = false;
            }
            field("Freight Cost Related Line No."; Rec."Freight Cost Related Line No.")
            {
                ApplicationArea = Basic, Suite;
                Enabled = FreightCostRelatedLineNoEnable;
            }
        }
        addafter("Variant Code")
        {
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Quantity)
        {
            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ApplicationArea = Basic, Suite;
            }
            field(getTotalQTYperCarton; item.getTotalQTYperCarton(Rec."No."))
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                caption = 'Total Qty. per Carton';
                BlankZero = true;
            }
        }
        addafter("Shipment Date")
        {
            field("Shipment Date Confirmed"; Rec."Shipment Date Confirmed")
            {
                ApplicationArea = Basic, Suite;
                Enabled = ShipmentDateConfirmedEnable;

                trigger OnValidate()
                begin
                    UpdateAdditionalLine(Rec.FieldNo(Rec."Shipment Date Confirmed"), Rec."Shipment Date Confirmed");  // 04-01-18 ZY-LD 002
                end;
            }
            field("Edit Additional Sales Line"; Rec."Edit Additional Sales Line")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Unconfirmed Additional Line"; Rec."Unconfirmed Additional Line")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Delivery Document No."; Rec."Delivery Document No.")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Warehouse Status"; Rec."Warehouse Status")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Line No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("External Document Position No."; Rec."External Document Position No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Backlog Comment"; Rec."Backlog Comment")
            {
                ApplicationArea = Basic, Suite;
            }
            field("IC Payment Terms"; Rec."IC Payment Terms")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Ext Vend Purch. Order No."; Rec."Ext Vend Purch. Order No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Ext Vend Purch. Order Line No."; Rec."Ext Vend Purch. Order Line No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Overshipment Line No."; Rec."Overshipment Line No.")
            {
                ApplicationArea = Basic, Suite;
                Enabled = OvershipmentAccrualEnable;
                Visible = false;
            }
            field("Zero Unit Price Accepted"; Rec."Zero Unit Price Accepted")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Invoice Disc. Pct.")
        {
            field(TotalSalesHeaderLineDiscountAmount; TotalSalesHeader."Line Discount Amount")
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = StrSubstNo(zText002, Rec."Currency Code");
                Caption = 'Line Discount Amount';
                Editable = false;
            }
            field(TotalSalesLineAmountPlusTotalSalesLineLineDiscountAmount; TotalSalesLine.Amount + TotalSalesHeader."Line Discount Amount")
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = StrSubstNo(zText001, Rec."Currency Code");
                Caption = 'Total Amount Excl. Disc.';
                DecimalPlaces = 2 : 2;
                Editable = false;
                Style = Strong;
                StyleExpr = true;
            }
        }
    }

    actions
    {
        addafter(OrderPromising)
        {
            Action("EMS Machine Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EMS Machine Code';
                Visible = EMSLicenseVisible;

                trigger OnAction()
                var
                    recAddEicardOrderInfo: Record "Add. Eicard Order Info";
                    pageAddEicardOrderInfo: Page "Add. Eicard Order Info";
                begin
                    recAddEicardOrderInfo.SetRange("Document Type", Rec."Document Type");
                    recAddEicardOrderInfo.SetRange("Document No.", Rec."Document No.");
                    recAddEicardOrderInfo.SetRange("Sales Line Line No.", Rec."Line No.");
                    pageAddEicardOrderInfo.SetTableView(recAddEicardOrderInfo);
                    pageAddEicardOrderInfo.Init(0);
                    pageAddEicardOrderInfo.RunModal;
                end;
            }
            Action("GLC Serial No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'GLC Serial No.';
                Visible = GLCLicenseVisible;

                trigger OnAction()
                var
                    recAddEicardOrderInfo: Record "Add. Eicard Order Info";
                    pageAddEicardOrderInfo: Page "Add. Eicard Order Info";
                begin
                    recAddEicardOrderInfo.SetRange("Document Type", Rec."Document Type");
                    recAddEicardOrderInfo.SetRange("Document No.", Rec."Document No.");
                    recAddEicardOrderInfo.SetRange("Sales Line Line No.", Rec."Line No.");
                    pageAddEicardOrderInfo.SetTableView(recAddEicardOrderInfo);
                    pageAddEicardOrderInfo.Init(1);
                    pageAddEicardOrderInfo.RunModal;
                end;
            }
        }
        addafter(DeferralSchedule)
        {
            Action("Warehouse Response")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Response';
                RunObject = Page "Shipment Response List";
                RunPageLink = "Customer Reference" = field("Delivery Document No.");
            }
            Action(ActDeliveryDocument)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Document';

                trigger OnAction()
                begin
                    Rec.DeliveryDocument;
                end;
            }
            Action("Why will Delivery Document not Create")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Why will Delivery Document not Create';

                trigger OnAction()
                var
                    DelDocMgt: Codeunit "Delivery Document Management";
                begin
                    DelDocMgt.WhyCanDelDocNotRelase(Rec);  // 19-04-21 ZY-LD 017
                end;
            }
        }
        addfirst("F&unctions")
        {
            Action("Copy Line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy Line';
                Image = Copy;
                ShortcutKey = 'Ctrl+Alt+c';

                trigger OnAction()
                begin
                    CopySalesLine;  // 28-06-19 ZY-LD 011
                end;
            }
        }
        addafter("O&rder")
        {
            Action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;

                trigger OnAction()
                var
                    ChangeLogEntry: Record "Change Log Entry";
                begin
                    ChangeLogEntry.SetCurrentKey("Table No.", "Date and Time");
                    ChangeLogEntry.SetAscending("Date and Time", false);
                    ChangeLogEntry.SetRange("Table No.", Database::"Sales Line");
                    ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(Rec."Document Type", 0, 9));
                    ChangeLogEntry.SetRange("Primary Key Field 2 Value", Rec."Document No.");
                    ChangeLogEntry.SetRange("Primary Key Field 3 Value", Format(Rec."Line No."));
                    Page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                end;

            }
        }
    }

    trigger OnOpenPage()
    begin
        Currency.InitRoundingPrecision();

        SetActions;  // 26-10-17 ZY-LD 001
        SI.SetManualChange(true);  // 003 18-01-18 ZY-LD
        SI.SetValidateFromPage(true);  // 06-01-21 ZY-LD 015
    end;

    trigger OnClosePage()
    begin
        SI.SetManualChange(false);  // 003 18-01-18 ZY-LD
        SI.SetValidateFromPage(false);  // 06-01-21 ZY-LD 015
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 26-10-17 ZY-LD 001
        makestyleAmazonPrice(); // amazon
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SOHeader: Record "Sales Header";
    begin
        //15-51643 -
        Clear(SOHeader);
        if SOHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            Rec."Sales Order Type" := SOHeader."Sales Order Type";
        end;
        //15-51643 +
        SetActions();  // 26-10-17 ZY-LD 001
    end;

    trigger OnDeleteRecord(): Boolean
    var
        SH: record "Sales Header";
        SLAmaz: label 'You are not allowed to delete line, set QTY to 0 pcs instead';
    begin
        //  Amazon >>
        if SH.get(rec."Document Type", rec."Document No.") then
            if SH.AmazonePoNo <> '' then
                error(SLAmaz);
        // amazon <<

        SalesLineEvent.OnAfterDeleteSalesLinePage(Rec);  // 31-01-18 ZY-LD 004
    end;

    var
        Item: Record Item;
        Currency: Record Currency;
        UserSetup: Record "User Setup";
        Text002: Label 'No Source Document for this line has been specified yet.';
        Text003: Label 'The selected line is not on any delivery documents.';
        Text004: Label 'The shipment date cannot be changed as it has been confirmed. \ \Press the Esc key to cancel your changes.';
        ShipmentDateComfirmedEditable: Boolean;
        LineEditable: Boolean;
        ZyXELAdditionalItems: Codeunit "ZyXEL Additional Items Mgt";
        SI: Codeunit "Single Instance";
        SalesLineEvent: Codeunit "Sales Header/Line Events";
        AdditionalRelation: Text[20];
        StyleExprAdditionalItem: Text;
        zText001: Label 'Total Excl. Disc (%1)';
        zText002: Label 'Line Discount Amount (%1)';
        ZGT: Codeunit "ZyXEL General Tools";
        LineDiscountEditable: Boolean;
        OvershipmentAccrualEnable: Boolean;
        FreightCostRelatedLineNoEnable: Boolean;
        ShipmentDateConfirmedEnable: Boolean;
        EMSLicenseVisible: Boolean;
        GLCLicenseVisible: Boolean;

        amazStyle: text;

    local procedure SetActions()
    var
        recUserSetup: Record "User Setup";
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recAddItem: Record "Additional Item";
        lText001: Label 'Missing';
        recCust: Record Customer;
        recItem: Record Item;
    begin
        //>> 26-10-17 ZY-LD 001
        if recUserSetup.Get(UserId()) then
            ShipmentDateComfirmedEditable := recUserSetup."Confirm Shipment Date on SL";
        //<< 26-10-17 ZY-LD 001

        //>> 16-03-18 ZY-LD 005
        if ZGT.IsRhq then begin  // 25-10-19 ZY-LD 012
            AdditionalRelation := '';
            if Rec."Additional Item Line No." <> 0 then
                AdditionalRelation := Format(Rec."Additional Item Line No.")
            else begin
                recSalesLine.SetRange("Document Type", Rec."Document Type");
                recSalesLine.SetRange("Document No.", Rec."Document No.");
                recSalesLine.SetRange("Additional Item Line No.", Rec."Line No.");
                if recSalesLine.FindFirst() then
                    AdditionalRelation := Format(Rec."Line No.")
                else begin
                    if recSalesHead.Get(Rec."Document Type", Rec."Document No.") then begin
                        recAddItem.SetRange("Item No.", Rec."No.");
                        //>> 20-11-18 ZY-LD 008
                        //recAddItem.SETRANGE("Ship-to Country/Region",recSalesHead."Ship-to Country/Region Code");
                        recAddItem.SetFilter("Ship-to Country/Region", '%1|%2', '', recSalesHead."Ship-to Country/Region Code");
                        if Rec."Sell-to Customer No." <> '' then begin
                            recCust.Get(Rec."Sell-to Customer No.");
                            recCust.TestField("Forecast Territory");
                            recAddItem.SetFilter("Forecast Territory", '%1|%2', '', recCust."Forecast Territory");
                            if recCust."Additional Items" then
                                recAddItem.SetRange("Customer No.", recCust."No.")
                            else
                                recAddItem.SetFilter("Customer No.", '%1', '');
                        end;
                        //<< 20-11-18 ZY-LD 008
                        if recAddItem.FindLast() then
                            AdditionalRelation := lText001;
                    end;
                end;
            end;

            //>> 23-05-23 ZY-LD 019
            if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                recItem.Get(Rec."No.");
                EMSLicenseVisible := recItem."Enter Security for Eicard on" = recItem."enter security for eicard on"::"EMS License";
                GLCLicenseVisible := recItem."Enter Security for Eicard on" = recItem."enter security for eicard on"::"GLC License";
            end;
            //<< 23-05-23 ZY-LD 019
        end;
        //<< 16-03-18 ZY-LD 005

        LineEditable :=
          (Rec."Additional Item Line No." = 0) or
          (Rec."Edit Additional Sales Line");  // 08-10-20 ZY-LD 014

        //>> 16-03-18 ZY-LD 005
        StyleExprAdditionalItem := 'Standard';
        if not LineEditable then
            StyleExprAdditionalItem := 'Subordinate';
        //<< 16-03-18 ZY-LD 005

        //LineDiscountEditable := ZGT.UserIsAccManager('DK');  // 07-04-21 ZY-LD 016
        if UserSetup.get(UserId) then
            LineDiscountEditable := not UserSetup."Block Change of Line Discount";
        //>> 06-10-21 ZY-LD 018
        Rec.CalcFields(Rec."Gen. Prod. Post. Grp. Type");
        OvershipmentAccrualEnable := Rec."Gen. Prod. Post. Grp. Type" <> Rec."gen. prod. post. grp. type"::Overshipment;
        //<< 06-10-21 ZY-LD 018

        Rec.CalcFields(Rec."Freight Cost Item");
        FreightCostRelatedLineNoEnable := Rec."Freight Cost Item";
        ShipmentDateConfirmedEnable := not Rec."Freight Cost Item";
    end;

    local procedure UpdateAdditionalLine(pFieldNo: Integer; pFieldValue: Variant)
    var
        recSalesHead: Record "Sales Header";
        lSalesLine: Record "Sales Line";
        DecVar: Decimal;
    begin
        //>> 04-01-18 ZY-LD 002
        if not DisableAddItem then begin
            lSalesLine.SetRange("Document Type", Rec."Document Type");
            lSalesLine.SetRange("Document No.", Rec."Document No.");
            lSalesLine.SetRange("Additional Item Line No.", Rec."Line No.");
            if lSalesLine.FindSet() then begin
                repeat
                    case pFieldNo of
                        Rec.FieldNo(Rec.Quantity):
                            begin
                                Evaluate(DecVar, Format(pFieldValue));
                                lSalesLine.Validate(Quantity, DecVar * lSalesLine."Additional Item Quantity");
                            end;
                        Rec.FieldNo(Rec."Qty. to Ship"):
                            begin
                                Evaluate(DecVar, Format(pFieldValue));
                                lSalesLine.Validate("Qty. to Ship", DecVar * lSalesLine."Additional Item Quantity");
                            end;
                        Rec.FieldNo(Rec."Qty. to Invoice"):
                            begin
                                Evaluate(DecVar, Format(pFieldValue));
                                lSalesLine.Validate("Qty. to Invoice", DecVar * lSalesLine."Additional Item Quantity");
                            end;
                        Rec.FieldNo(Rec."Shipment Date"):
                            lSalesLine."Shipment Date" := pFieldValue;
                        Rec.FieldNo(Rec."Shipment Date Confirmed"):
                            lSalesLine."Shipment Date Confirmed" := pFieldValue;
                    end;
                    lSalesLine.modify();
                until lSalesLine.Next() = 0;
                CurrPage.Update();
            end;
        end;
        //<< 04-01-18 ZY-LD 002
    end;

    local procedure DisableAddItem(): Boolean
    var
        recSalesHead: Record "Sales Header";
    begin
        //>> 09-04-18 ZY-LD 006
        recSalesHead.Get(Rec."Document Type", Rec."Document No.");
        exit(recSalesHead."Disable Additional Items");
        //<< 09-04-18 ZY-LD 006
    end;

    local procedure CopySalesLine()
    var
        lText001: Label 'Do you want to copy the line?';
        recSalesLine: Record "Sales Line";
        recSalesLine2: Record "Sales Line";
        NextLineNo: Integer;
    begin
        //>> 28-06-19 ZY-LD 011
        if Confirm(lText001, true) then begin
            recSalesLine := Rec;
            recSalesLine.SetRange("Document Type", Rec."Document Type");
            recSalesLine.SetRange("Document No.", Rec."Document No.");
            if recSalesLine.Next <> 0 then
                NextLineNo := Rec."Line No." + Round((recSalesLine."Line No." - Rec."Line No.") / 2, 1, '<')
            else
                NextLineNo := Rec."Line No." + 10000;

            recSalesLine2 := Rec;
            recSalesLine2."Line No." := NextLineNo;
            recSalesLine2.Insert();
        end;
        //<< 28-06-19 ZY-LD 011
    end;


    procedure makestyleAmazonPrice()
    var

    begin
        if rec.Type <> rec.Type::Item then
            amazStyle := 'Standard';
        if rec.compareAmazonprices then
            amazStyle := 'Unfavorable'
        else
            amazStyle := 'Favorable';
    end;
}
