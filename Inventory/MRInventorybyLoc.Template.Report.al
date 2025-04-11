Report 50086 "MR Inventory by Loc. Template"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/MR Inventory by Loc. Template.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("Item Category Code", Description) order(descending);
            RequestFilterFields = "No.";
            column(Rptdate; Format(Today, 0, 4))
            {
            }
            column(Company; CompanyName())
            {
            }
            column(No_Item; Item."No.")
            {
            }
            column(ItemCategoryCode; Item."Item Category Code")
            {
            }
            column(ItemDescription; Item.Description)
            {
            }
            dataitem(Location; Location)
            {
                RequestFilterFields = "Code";
                column(LocationCode; Location.Code)
                {
                }
                column(intTalQty_; intTalQty)
                {
                }
                column(intTalValue_; intTalValue)
                {
                }
                column(Segment_1; Segment1)
                {
                }
                column(Seg_Cost_1; Seg_Cost1)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    Segment1 := 0;
                    Seg_Cost1 := 0;

                    tabItemledger2.SetRange("Item No.", Item."No.");
                    tabItemledger2.SetFilter("Location Code", Location.Code);
                    tabItemledger2.SetFilter("Posting Date", '..%1', BaseDate);

                    if tabItemledger2.FindFirst then begin
                        repeat
                            Segment1 += tabItemledger2.Quantity;
                        until tabItemledger2.Next() = 0;
                    end;

                    //value Entry Cal Value
                    tabValue.SetRange("Item No.", Item."No.");
                    tabValue.SetRange("Location Code", Location.Code);
                    tabValue.SetRange("Posting Date", 0D, BaseDate);
                    if tabValue.FindFirst then begin
                        repeat
                            Seg_Cost1 += tabValue."Cost Amount (Actual)";
                        until tabValue.Next() = 0;
                    end;

                    if (Segment1 = 0) and (Seg_Cost1 = 0)
                       then
                        CurrReport.Skip;

                    intTalQty += Segment1;
                    intTalValue += Seg_Cost1;
                end;
            }

            trigger OnPreDataItem()
            begin

                intTalQty := 0;
                intTalValue := 0;

                tabItemLedger.SetCurrentkey("Item No.", "Variant Code", Open, Positive, "Location Code",
                  "Posting Date", "Expiration Date", "Lot No.", "Serial No.");

                tabValue.SetCurrentkey("Item No.", "Item Ledger Entry Type", "Entry Type", "Item Charge No.", "Location Code",
                                            "Variant Code", "Posting Date");

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
                    field(BaseDate; BaseDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Date:';
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
        text001 = 'ZYRHQ';
        text002 = 'Company Code';
        text003 = 'Item No.';
        text004 = 'CAT I';
        text005 = 'CAT II';
        text006 = 'Descripion';
        text007 = 'Total Quantity';
        text008 = 'Total Amount';
        Text009 = 'Location';
        text025 = 'Page';
        RptTitle = 'Inventory Report by Location';
    }

    var
        Text1: label 'Reading item #1######## of';
        Text001: label 'ZYRHQ';
        Text19072657: label 'End Date:';
        Segment1: Decimal;
        Seg_Cost1: Decimal;
        BaseDate: Date;
        isExcel: Boolean;
        tabValue: Record "Value Entry";
        tabItemLedger: Record "Item Ledger Entry";
        tabItemledger2: Record "Item Ledger Entry";
        TempILE: Record "Item Ledger Entry" temporary;
        intTalQty: Decimal;
        intTalValue: Decimal;
        isAmount: Boolean;
        D: Dialog;
        C: Integer;


    procedure CalcUnitCost(ILE: Record "Item Ledger Entry"): Decimal
    var
        Unitcost: Decimal;
    begin
        begin
            ILE.CalcFields(ILE."Cost Amount (Expected)", ILE."Cost Amount (Actual)");
            Unitcost := (ILE."Cost Amount (Actual)" + ILE."Cost Amount (Expected)") / ILE.Quantity;
            exit(Unitcost);
        end;
    end;


    procedure InsertTransferEntry(ILE: Record "Item Ledger Entry")
    var
        ILERec: Record "Item Ledger Entry";
        ILERec2: Record "Item Ledger Entry";
        ItemApplnEntry: Record "Item Application Entry";
    begin
        TempILE.Init;
        TempILE.TransferFields(ILE);
        if TempILE.Insert then
            FindMainEntry(ILE);
    end;


    procedure FindMainEntry(ILE: Record "Item Ledger Entry")
    var
        ILERec: Record "Item Ledger Entry";
        ILERec2: Record "Item Ledger Entry";
        ItemApplnEntry: Record "Item Application Entry";
    begin

        //FIND THE First purchase/positive entry for the transfer
        ILERec.Reset;
        ILERec.SetRange("Item No.", ILE."Item No.");
        ILERec.SetRange("Entry Type", ILERec."entry type"::Transfer);
        ILERec.SetFilter("Location Code", '<>%1', ILE."Location Code");
        ILERec.SetRange("Posting Date", ILE."Posting Date");
        ILERec.SetRange(Open, false);
        ILERec.SetRange("Document No.", ILE."Document No.");
        //ILERec.SETFILTER(Quantity,'=%1',-(ILE.Quantity));
        if ILERec.FindFirst then begin
            ItemApplnEntry.Reset;
            ItemApplnEntry.SetCurrentkey("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
            ItemApplnEntry.SetRange("Outbound Item Entry No.", ILERec."Entry No.");
            ItemApplnEntry.SetRange("Item Ledger Entry No.", ILERec."Entry No.");
            ItemApplnEntry.SetRange("Cost Application", true);
            if ItemApplnEntry.FindFirst then
                if ILERec2.Get(ItemApplnEntry."Inbound Item Entry No.") and ILERec2.Positive then
                    if ILERec2."Entry Type" <> ILERec2."entry type"::Transfer then begin
                        TempILE."Posting Date" := ILERec2."Posting Date";
                        TempILE.Modify;
                    end else
                        FindMainEntry(ILERec2);

        end;
    end;
}
