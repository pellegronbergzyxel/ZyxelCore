Page 50080 "Availability pr Location"
{
    // 001.  DT1.00  01-07-2010  SH
    //  .Object created
    // 
    // 002.  DT1.02  02-07-2010  SH
    //  .Decimal places set to 0 for following fields
    //   Inventory
    //   "Qty. in Sales Order"
    //   "Qty. in Purchase Order"
    //   Available
    // 003: BS 18.12.2012 added ActualAvailable, PO Qty., Qty. in Receipt Line, ExpectedAvailable
    // 004. 02-10-19 ZY-LD 2019100210000058 - GIT is calculated as ""Qty. on Shipping Detail" - "Qty. on Ship. Detail Received"".
    // 005. 10-12-20 ZY-LD 2020121110000052 - Buy-from Vendor No. Filter.

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Availability pr Location";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            field(DateFilter; DateFilter)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Date Filter';

                trigger OnValidate()
                var
                    FilterTokens: Codeunit "Filter Tokens";
                begin
                    FilterTokens.MakeDateFilter(DateFilter);
                    DateFilterOnAfterValidate;
                end;
            }
            field(LocationFilter; LocationFilter)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Location Filter';

                trigger OnLookup(var Text: Text): Boolean
                var
                    location: Record Location;
                    LocationList: Page "Location List";
                begin
                    LocationList.SetTableview(location);
                    LocationList.LookupMode := true;
                    if LocationList.RunModal = Action::LookupOK then begin
                        LocationList.GetRecord(location);
                        Text := location.Code;
                        exit(true);
                    end else
                        exit(false);
                end;

                trigger OnValidate()
                begin
                    LocationFilterOnAfterValidate;
                end;
            }
            field(ItemFilter; ItemFilter)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Filter';

                trigger OnLookup(var Text: Text): Boolean
                var
                    Item: Record Item;
                    ItemList: Page "Item List";
                begin
                    ItemList.SetTableview(Item);
                    ItemList.LookupMode := true;
                    if ItemList.RunModal = Action::LookupOK then begin
                        ItemList.GetRecord(Item);
                        Text := Item."No.";
                        exit(true);
                    end else
                        exit(false);
                end;

                trigger OnValidate()
                begin
                    ItemFilterOnAfterValidate;
                end;
            }
            repeater(Control1000000000)
            {
                IndentationColumn = ActualExpansionStatus;
                IndentationControls = Item, Location;
                ShowAsTree = true;
                field(Parent; Rec.Parent)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Item; Rec.Item)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = tStyle;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = tStyle;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    StyleExpr = tStyle;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    StyleExpr = tStyle;

                    trigger OnDrillDown()
                    var
                        lrItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        lrItemLedgerEntry.SetCurrentkey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
                        lrItemLedgerEntry.SetRange("Item No.", Rec.Item);
                        lrItemLedgerEntry.SetRange(Open, true);
                        if not Rec.Parent then
                            if Rec.Location = DT001 then
                                lrItemLedgerEntry.SetRange("Location Code", '')
                            else
                                lrItemLedgerEntry.SetRange("Location Code", Rec.Location);

                        Page.RunModal(0, lrItemLedgerEntry);
                    end;
                }
                field("Qty. in Sales Order"; Rec."Qty. in Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    StyleExpr = tStyle;

                    trigger OnDrillDown()
                    var
                        lrSalesLine: Record "Sales Line";
                    begin
                        lrSalesLine.SetCurrentkey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
                        lrSalesLine.SetRange("Document Type", lrSalesLine."document type"::Order);
                        lrSalesLine.SetRange(Type, lrSalesLine.Type::Item);
                        lrSalesLine.SetRange("No.", Rec.Item);
                        if not Rec.Parent then
                            if Rec.Location = DT001 then
                                lrSalesLine.SetRange("Location Code", '')
                            else
                                lrSalesLine.SetRange("Location Code", Rec.Location);

                        if DateFilter <> '' then
                            lrSalesLine.SetFilter(lrSalesLine."Shipment Date", DateFilter);

                        Page.RunModal(0, lrSalesLine);
                    end;
                }
                field(ActualAvailable; Rec.ActualAvailable)
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    StyleExpr = tStyle;
                }
                field("Qty. in Receipt Line"; Rec."Qty. in Receipt Line")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    StyleExpr = tStyle;
                }
                field("Qty. on Shipping Detail"; Rec."Qty. on Shipping Detail")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Goods in transit';
                    DecimalPlaces = 0 : 0;
                    StyleExpr = tStyle;
                }
                field("HQ Unshipped Purchase Order"; Rec."HQ Unshipped Purchase Order")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 0;
                    StyleExpr = tStyle;
                }
                field("PO Qty."; Rec."PO Qty.")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    StyleExpr = tStyle;
                }
                field(ExpectedAvailable; Rec.ExpectedAvailable)
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    StyleExpr = tStyle;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Item")
            {
                Caption = '&Item';
                action("Export to Ex&cel")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Export to Ex&cel';
                    Image = ExportToExcel;

                    trigger OnAction()
                    begin
                        ExportToExcel;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if IsExpanded(Rec) then
            ActualExpansionStatus := 1
        else
            if HasChildren(Rec) then
                ActualExpansionStatus := 0
            else
                ActualExpansionStatus := 2;
        if Rec.Parent then
            TStyle := 'Strong'
        else
            TStyle := '';
    end;

    trigger OnOpenPage()
    begin
        InitTempTable;
    end;

    var
        rExcelBuf: Record "Excel Buffer" temporary;
        [InDataSet]
        ActualExpansionStatus: Integer;
        iDummy: Integer;
        DateFilter: Text[250];
        DT001: label 'BLANK';
        ItemFilter: Text[250];
        DT002: label 'Saving list,Exporting,Recreating list';
        LocationFilter: Text[250];
        [InDataSet]
        TStyle: Text;
        ZGT: Codeunit "ZyXEL General Tools";


    procedure InitTempTable()
    begin
        CopyItemToTemp(false);
    end;


    procedure ExportToExcel()
    var
        liRow: Integer;
        Window: Dialog;
        lRec: Record "Availability pr Location" temporary;
    begin
        rExcelBuf.DeleteAll;
        if Rec.FindFirst then begin
            Window.Open('#1#############\' +
                        '#2#############');
            Window.Update(1, SelectStr(1, DT002));
            repeat
                Window.Update(2, Rec.Item);
                lRec := Rec;
                lRec.Insert;
            until Rec.Next() = 0;

            Window.Update(1, SelectStr(2, DT002));
            CopyItemToTemp(false);
            Rec.FindFirst;
            liRow := 1;
            ToExcelBuf(liRow, 1, Rec.FieldCaption(Rec.Item), true);
            ToExcelBuf(liRow, 2, Rec.FieldCaption(Rec.Description), true);
            ToExcelBuf(liRow, 3, Rec.FieldCaption(Rec.Location), true);
            ToExcelBuf(liRow, 4, Rec.FieldCaption(Rec.Inventory), true);
            ToExcelBuf(liRow, 5, Rec.FieldCaption(Rec."Qty. in Sales Order"), true);
            ToExcelBuf(liRow, 6, Rec.FieldCaption(Rec."Qty. in Purchase Order"), true);
            ToExcelBuf(liRow, 7, Rec.FieldCaption(Rec.Available), true);
            repeat
                Window.Update(2, Rec.Item);
                liRow += 1;
                ToExcelBuf(liRow, 1, Rec.Item, Rec.Parent);
                ToExcelBuf(liRow, 2, Rec.Description, Rec.Parent);
                ToExcelBuf(liRow, 3, Rec.Location, Rec.Parent);
                ToExcelBuf(liRow, 4, Format(Rec.Inventory), Rec.Parent);
                ToExcelBuf(liRow, 5, Format(Rec."Qty. in Sales Order"), Rec.Parent);
                ToExcelBuf(liRow, 6, Format(Rec."Qty. in Purchase Order"), Rec.Parent);
                ToExcelBuf(liRow, 7, Format(Rec.Available), Rec.Parent);
            until Rec.Next() = 0;
            //15-51643 - new rules apply in V2016
            //  rExcelBuf.CreateBook;
            //  rExcelBuf.CreateSheet(TABLECAPTION, CurrPage.OBJECTID, CompanyName(), UserId());
            //  rExcelBuf.GiveUserControl;
            rExcelBuf.CreateBook('', Rec.TableCaption);
            rExcelBuf.WriteSheet(CurrPage.ObjectId, CompanyName(), UserId());
            rExcelBuf.CloseBook;
            rExcelBuf.OpenExcel;
            //15-51643 +
            Window.Update(1, SelectStr(3, DT002));
            lRec.FindFirst;
            Rec.DeleteAll;
            repeat
                Window.Update(2, lRec.Item);
                Rec := lRec;
                Rec.Insert;
            until lRec.Next() = 0;

        end;
    end;


    procedure ToExcelBuf(pRow: Integer; pColumn: Integer; pValue: Text[250]; pBold: Boolean)
    begin
        rExcelBuf.Validate(rExcelBuf."Row No.", pRow);
        rExcelBuf.Validate(rExcelBuf."Column No.", pColumn);
        rExcelBuf."Cell Value as Text" := pValue;
        rExcelBuf.Bold := pBold;
        rExcelBuf.Insert(true);
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        InitTempTable;
        CurrPage.Update(false);
    end;

    local procedure ItemFilterOnAfterValidate()
    begin
        InitTempTable;
        CurrPage.Update(false);
    end;

    local procedure LocationFilterOnAfterValidate()
    begin
        InitTempTable;
        CurrPage.Update(false);
    end;

    local procedure CopyItemToTemp(OnlyRoot: Boolean)
    var
        lritem: Record Item;
        lrlocation: Record Location;
        VendorEvent: Codeunit "Vendor Event";
    begin

        Rec.Reset;
        Rec.DeleteAll;
        Rec.SetCurrentkey(Rec.Item);

        if ItemFilter <> '' then
            lritem.SetFilter(lritem."No.", ItemFilter)
        else
            lritem.SetFilter(lritem."No.", '');
        if DateFilter <> '' then
            lritem.SetFilter(lritem."Date Filter", DateFilter)
        else
            lritem.SetFilter(lritem."Date Filter", '');

        lritem.SetRange("Buy-from Vendor No. Filter", VendorEvent.GetFilterZyxelVendors(0, false));  // 10-12-20 ZY-LD 005

        if lritem.FindFirst then begin
            ZGT.OpenProgressWindow('', lritem.Count);  // 02-10-19 ZY-LD 004
            repeat
                ZGT.UpdateProgressWindow(lritem."No.", 0, true);  // 02-10-19 ZY-LD 004
                                                                  //003 >>
                if LocationFilter <> '' then
                    lritem.SetFilter(lritem."Location Filter", LocationFilter)
                else
                    //003 <<
                    lritem.SetFilter(lritem."Location Filter", '');
                lritem.CalcFields(lritem.Inventory, lritem."Qty. on Purch. Order",
                                  lritem."Qty. on Sales Order", lritem."Qty. on Reciept Lines",
                                  lritem."Qty. on Shipping Detail",
                                  lritem."Qty. on Ship. Detail Received", lritem."HQ Unshipped Purchase Order");  // 23-04-20 ZY-LD 005
                Rec.Item := lritem."No.";
                Rec.Description := lritem.Description;
                Rec.Location := '';
                Rec.Inventory := lritem.Inventory;
                Rec."Qty. in Sales Order" := lritem."Qty. on Sales Order";
                Rec."Qty. in Purchase Order" := lritem."Qty. on Purch. Order";
                Rec.Available := Rec.Inventory - Rec."Qty. in Sales Order" + Rec."Qty. in Purchase Order";
                Rec.ActualAvailable := Rec.Inventory - Rec."Qty. in Sales Order";
                Rec."Qty. in Receipt Line" := lritem."Qty. on Reciept Lines";
                Rec."PO Qty." := Rec."Qty. in Purchase Order";
                // "PO Qty." :=  "Qty. in Purchase Order" -  ("Qty. in Receipt Line" + lrItem."Qty. on Shipping Detail");   RD insert before
                Rec."Qty. on Shipping Detail" := lritem."Qty. on Shipping Detail" - lritem."Qty. on Ship. Detail Received";  // 23-04-20 ZY-LD 005
                Rec."HQ Unshipped Purchase Order" := lritem."HQ Unshipped Purchase Order";  // 23-04-20 ZY-LD 005
                Rec.ExpectedAvailable := Rec.Available;
                Rec.Parent := true;
                Rec.Insert;

                if not OnlyRoot then begin
                    // Blank location
                    if not lrlocation.IsEmpty then begin
                        // Check to see if any are on other than blank
                        /*//003 >>
                        IF LocationFilter <> '' THEN
                          lrItem.SETFILTER(lrItem."location filter", locationFilter)
                        ELSE
                        //003 <<
                         */
                        lritem.SetFilter(lritem."Location Filter", '<>%1', '');
                        lritem.CalcFields(lritem.Inventory, lritem."Qty. on Purch. Order",
                                          lritem."Qty. on Sales Order", lritem."Qty. on Reciept Lines",
                                          lritem."Qty. on Shipping Detail",
                                          lritem."Qty. on Ship. Detail Received", lritem."HQ Unshipped Purchase Order");  // 23-04-20 ZY-LD 005
                        if (lritem.Inventory <> 0) or (lritem."Qty. on Purch. Order" <> 0) or (lritem."Qty. on Sales Order" <> 0) then begin
                            lritem.SetFilter(lritem."Location Filter", '%1', '');
                            lritem.CalcFields(lritem.Inventory, lritem."Qty. on Purch. Order", lritem."Qty. on Sales Order");
                            if (lritem.Inventory <> 0) or (lritem."Qty. on Purch. Order" <> 0) or (lritem."Qty. on Sales Order" <> 0) then begin
                                Rec.Item := lritem."No.";
                                Rec.Description := 'Blank';
                                Rec.Location := DT001;
                                Rec.Inventory := lritem.Inventory;
                                Rec."Qty. in Sales Order" := lritem."Qty. on Sales Order";
                                Rec."Qty. in Purchase Order" := lritem."Qty. on Purch. Order";
                                Rec.Available := Rec.Inventory - Rec."Qty. in Sales Order" + Rec."Qty. in Purchase Order";
                                Rec.ActualAvailable := Rec.Inventory - Rec."Qty. in Sales Order";
                                Rec."Qty. in Receipt Line" := lritem."Qty. on Reciept Lines";
                                Rec."PO Qty." := Rec."Qty. in Purchase Order";
                                //"PO Qty." :=  "Qty. in Purchase Order" -  ("Qty. in Receipt Line" + lrItem."Qty. on Shipping Detail"); RD
                                Rec."Qty. on Shipping Detail" := lritem."Qty. on Shipping Detail" - lritem."Qty. on Ship. Detail Received";  // 23-04-20 ZY-LD 005
                                Rec."HQ Unshipped Purchase Order" := lritem."HQ Unshipped Purchase Order";  // 23-04-20 ZY-LD 005
                                Rec.ExpectedAvailable := Rec.Available;

                                Rec.Parent := false;
                                Rec.Insert;
                            end;
                        end;
                    end;

                    //003 >>
                    if LocationFilter <> '' then
                        lrlocation.SetFilter(Code, LocationFilter);
                    //003 <<

                    if lrlocation.FindFirst then
                        repeat
                            lritem.SetFilter(lritem."Location Filter", '%1', lrlocation.Code);
                            lritem.CalcFields(lritem.Inventory, lritem."Qty. on Purch. Order",
                                              lritem."Qty. on Sales Order", lritem."Qty. on Reciept Lines",
                                              lritem."Qty. on Shipping Detail",
                                              lritem."Qty. on Ship. Detail Received", lritem."HQ Unshipped Purchase Order");  // 23-04-20 ZY-LD 005
                            if (lritem.Inventory <> 0) or (lritem."Qty. on Purch. Order" <> 0) or (lritem."Qty. on Sales Order" <> 0) then begin
                                Rec.Item := lritem."No.";
                                Rec.Description := lrlocation.Name;
                                Rec.Location := lrlocation.Code;
                                Rec.Inventory := lritem.Inventory;
                                Rec."Qty. in Sales Order" := lritem."Qty. on Sales Order";
                                Rec."Qty. in Purchase Order" := lritem."Qty. on Purch. Order";
                                Rec.Available := Rec.Inventory - Rec."Qty. in Sales Order" + Rec."Qty. in Purchase Order";
                                Rec.ActualAvailable := Rec.Inventory - Rec."Qty. in Sales Order";
                                Rec."Qty. in Receipt Line" := lritem."Qty. on Reciept Lines";
                                Rec."PO Qty." := Rec."Qty. in Purchase Order";
                                //"PO Qty." :=  "Qty. in Purchase Order" -  ("Qty. in Receipt Line" + lrItem."Qty. on Shipping Detail");
                                Rec."Qty. on Shipping Detail" := lritem."Qty. on Shipping Detail" - lritem."Qty. on Ship. Detail Received";
                                Rec."HQ Unshipped Purchase Order" := lritem."HQ Unshipped Purchase Order";  // 23-04-20 ZY-LD 005
                                Rec.ExpectedAvailable := Rec.Available;  // 23-04-20 ZY-LD 005

                                Rec.Parent := false;
                                Rec.Insert;
                            end;
                        until lrlocation.Next() = 0;
                end;
            until lritem.Next() = 0;

            ZGT.CloseProgressWindow;  // 02-10-19 ZY-LD 004
        end;

    end;

    local procedure IsExpanded(prec: Record "Availability pr Location"): Boolean
    var
        irec: Record "Availability pr Location";
    begin

        if prec.Parent then begin
            prec.SetRange(prec.Item, prec.Item);
            prec.SetRange(prec.Parent, false);
            iDummy := prec.Count;
            prec.SetRange(prec.Item);
            prec.SetRange(prec.Parent);
            exit(iDummy > 0);
        end else
            exit(false);
    end;

    local procedure HasChildren(prec: Record "Availability pr Location"): Boolean
    var
        lritem: Record Item;
        lrlocation: Record Location;
    begin

        if not Rec.Parent then
            exit(false);

        lritem.Get(prec.Item);
        if lrlocation.FindSet then
            repeat
                lritem.SetFilter(lritem."Location Filter", '%1', lrlocation.Code);
                lritem.CalcFields(lritem.Inventory, lritem."Qty. on Purch. Order", lritem."Qty. on Sales Order");
                if (lritem.Inventory <> 0) or (lritem."Qty. on Purch. Order" <> 0) or (lritem."Qty. on Sales Order" <> 0) then
                    exit(true);
            until lrlocation.Next() = 0;
    end;

    local procedure ToggleExpandCollapse(prec: Record "Availability pr Location")
    var
        lritem: Record Item;
        lrlocation: Record Location;
        lrxRec: Record "Availability pr Location";
    begin

        lrxRec := Rec;
        if ActualExpansionStatus = 0 then begin
            if DateFilter <> '' then
                lritem.SetFilter(lritem."Date Filter", DateFilter)
            else
                lritem.SetFilter(lritem."Date Filter", '');
            lritem.Get(prec.Item);
            // Blank location
            if not lrlocation.IsEmpty then begin
                /*
                //003 >>
                IF LocationFilter <> '' THEN
                  lrItem.SETFILTER(lrItem."location filter", locationFilter)
                ELSE
                //003 <<
                */
                lritem.SetFilter(lritem."Location Filter", '%1', '');
                lritem.CalcFields(lritem.Inventory, lritem."Qty. on Purch. Order", lritem."Qty. on Sales Order",
                                  lritem."Qty. on Reciept Lines", lritem."Qty. on Shipping Detail");
                if (lritem.Inventory <> 0) or (lritem."Qty. on Purch. Order" <> 0) or (lritem."Qty. on Sales Order" <> 0) then begin
                    Rec.Item := lritem."No.";
                    Rec.Description := 'Blank';
                    Rec.Location := DT001;
                    Rec.Inventory := lritem.Inventory;
                    Rec."Qty. in Sales Order" := lritem."Qty. on Sales Order";
                    Rec."Qty. in Purchase Order" := lritem."Qty. on Purch. Order";
                    Rec.Available := Rec.Inventory - Rec."Qty. in Sales Order" + Rec."Qty. in Purchase Order";
                    Rec.ActualAvailable := Rec.Inventory - Rec."Qty. in Sales Order";
                    Rec."Qty. in Receipt Line" := lritem."Qty. on Reciept Lines";
                    Rec."PO Qty." := Rec."Qty. in Purchase Order";
                    //"PO Qty." :=  "Qty. in Purchase Order" -  ("Qty. in Receipt Line" + lrItem."Qty. on Shipping Detail");
                    Rec.ExpectedAvailable := Rec.Available;

                    Rec.Parent := false;
                    Rec.Insert;
                end;
            end;
            //003 >>
            if LocationFilter <> '' then
                lrlocation.SetFilter(Code, LocationFilter);
            //003 <<

            if lrlocation.FindFirst then
                repeat
                    lritem.SetFilter(lritem."Location Filter", '%1', lrlocation.Code);
                    lritem.CalcFields(lritem.Inventory, lritem."Qty. on Purch. Order", lritem."Qty. on Sales Order",
                                      lritem."Qty. on Reciept Lines", lritem."Qty. on Shipping Detail");
                    if (lritem.Inventory <> 0) or (lritem."Qty. on Purch. Order" <> 0) or (lritem."Qty. on Sales Order" <> 0) then begin
                        Rec.Item := lritem."No.";
                        Rec.Description := lrlocation.Name;
                        Rec.Location := lrlocation.Code;
                        Rec.Inventory := lritem.Inventory;
                        Rec."Qty. in Sales Order" := lritem."Qty. on Sales Order";
                        Rec."Qty. in Purchase Order" := lritem."Qty. on Purch. Order";
                        Rec.Available := Rec.Inventory - Rec."Qty. in Sales Order" + Rec."Qty. in Purchase Order";
                        Rec.ActualAvailable := Rec.Inventory - Rec."Qty. in Sales Order";
                        Rec."Qty. in Receipt Line" := lritem."Qty. on Reciept Lines";
                        Rec."PO Qty." := Rec."Qty. in Purchase Order";
                        //"PO Qty." :=  "Qty. in Purchase Order" -  ("Qty. in Receipt Line" + lrItem."Qty. on Shipping Detail");
                        Rec.ExpectedAvailable := Rec.Available;

                        Rec.Parent := false;
                        Rec.Insert;
                    end;
                until lrlocation.Next() = 0;
        end else
            if ActualExpansionStatus = 1 then begin
                prec.SetRange(Item, prec.Item);
                prec.SetRange(Parent, false);
                Rec.DeleteAll;
                prec.SetRange(Item);
                prec.SetRange(Parent);
            end;
        Rec := lrxRec;
        CurrPage.Update(false);

    end;


    procedure InitiatePage(pItemFilter: Text)
    begin
        ItemFilter := pItemFilter;
    end;
}
