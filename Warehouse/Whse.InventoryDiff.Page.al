Page 50319 "Whse. Inventory Diff."
{
    ApplicationArea = Basic, Suite;
    Caption = 'Warehouse Inventory Difference';
    Editable = true;
    PageType = List;
    SourceTable = Item;
    SourceTableView = where("Quanty Type Filter" = Const("On Hand"), IsEICard = const(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(LastEntryDate; LastEntryDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Latest Adjustment Date';
                }
                field("Net Change"; Rec."Net Change")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inventory';
                    BlankZero = true;
                }
                field("Warehouse Inventory"; Rec."Warehouse Inventory")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Physical Whse. Inventory';
                    BlankZero = true;
                }
                field("""Warehouse Inventory""-""Net Change"""; Rec."Warehouse Inventory" - Rec."Net Change")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Difference';
                    DecimalPlaces = 0 : 5;
                    BlankZero = true;
                }
                field("recItemBlock.""Warehouse Inventory"""; recItemBlock."Warehouse Inventory")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Whse. Inv. - Blocked';
                    Visible = false;
                    BlankZero = true;
                }
                field("""Warehouse Inventory""-""Net Change""-recItemBlock.""Warehouse Inventory"""; Rec."Warehouse Inventory" - Rec."Net Change" - recItemBlock."Warehouse Inventory")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Difference - After Blocked';
                    DecimalPlaces = 0 : 5;
                    Visible = false;
                    BlankZero = true;
                }
            }
        }
        area(factboxes)
        {
            part(Control17; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("No."),
                              "Date Filter" = field("Date Filter"),
                              "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                              "Location Filter" = field("Location Filter"),
                              "Drop Shipment Filter" = field("Drop Shipment Filter"),
                              "Bin Filter" = field("Bin Filter"),
                              "Variant Filter" = field("Variant Filter"),
                              "Lot No. Filter" = field("Lot No. Filter"),
                              "Serial No. Filter" = field("Serial No. Filter");
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Adjust Inventory")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Adjust Inventory';
                Image = AdjustEntries;

                trigger OnAction()
                begin
                    Clear(CalcInv);
                    CalcInv.SetTableview(Rec);
                    recItemJnlLine."Journal Template Name" := 'PHYS. INVE';
                    recItemJnlLine."Journal Batch Name" := 'DEFAULT';
                    CalcInv.SetItemJnlLine(recItemJnlLine);
                    CalcInv.InitializeRequest(Rec.GetRangemax(Rec."Date Filter"), '', true, true);
                    CalcInv.InitializeRequestZyxel(true);
                    CalcInv.RunModal;

                    Commit;
                    Page.RunModal(Page::"Phys. Inventory Journal");
                end;
            }
        }
        area(navigation)
        {
            group("E&ntries")
            {
                Caption = 'E&ntries';
                Image = Entries;
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Item Ledger Entries", recItemLedgEntry);
                    end;
                }
                action("Physical Whse. Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Physical Whse. Ledger Entries';
                    Image = Warehouse;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Whse. Item Ledger Entry", recWhseItemLedgEntry);
                    end;
                }
            }
            action("Inventory pr. Date")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Inventory pr. Date';
                Image = DateRange;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+F7';

                trigger OnAction()
                begin
                    Clear(WhseInvDate);
                    WhseInvDate.InitPage(Rec."No.", Rec.GetFilter(Rec."Location Filter"));
                    WhseInvDate.Run;
                end;
            }
            action(Card)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Card';
                Image = Item;
                RunObject = Page "Item Card";
                RunPageLink = "No." = field("No.");
                ShortCutKey = 'Shift+Ctrl+e';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        recItemLedgEntry.SetRange("Item No.", Rec."No.");
        recItemLedgEntry.SetRange("Location Code", MainLocation);
        if not recItemLedgEntry.FindLast then
            Clear(recItemLedgEntry);
        recWhseItemLedgEntry.SetRange("Item No.", Rec."No.");
        recWhseItemLedgEntry.SetRange("Quanty Type", recWhseItemLedgEntry."quanty type"::"On Hand");
        if not recWhseItemLedgEntry.FindLast then
            Clear(recWhseItemLedgEntry);

        if recItemLedgEntry."Posting Date" > recWhseItemLedgEntry.Date then
            LastEntryDate := recItemLedgEntry."Posting Date"
        else
            LastEntryDate := recWhseItemLedgEntry.Date;

        recItemBlock.CopyFilters(Rec);
        recItemBlock.SetRange("Quanty Type Filter", recItemBlock."quanty type filter"::Blocked);
        recItemBlock.SetAutocalcFields("Warehouse Inventory");
        recItemBlock.Get(Rec."No.");
    end;

    trigger OnOpenPage()
    var
        ItemLogEvent: Codeunit "Item / Logistic Events";
    begin
        if not Rec.FindFirst then;
        if MainLocation = '' then
            MainLocation := ItemLogEvent.GetMainWarehouseLocation;

        Rec.SETFILTER("Date Filter", '..%1', TODAY - 1);
        Rec.SetRange("Location Filter", MainLocation);
        Rec.SetRange(Inactive, false);
    end;

    var
        recItemLedgEntry: Record "Item Ledger Entry";
        recWhseItemLedgEntry: Record "Warehouse Item Ledger Entry";
        recItemJnlLine: Record "Item Journal Line";
        recItemBlock: Record Item;
        CalcInv: Report "Calculate Inventory ZX";
        WhseInvDate: Page "Warehouse Inventory Date";
        MainLocation: Code[20];
        LastEntryDate: Date;
}
