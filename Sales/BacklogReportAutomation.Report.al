report 50035 BacklogReportAutomation
{
    Caption = 'Backlog Report (Automation)';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/BacklogReportAutomation.rdlc';
    ShowPrintStatus = false;
    UsageCategory = None;
    UseRequestPage = false;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Global Dimension 1 Filter", "Bill-to Customer No.";
            column(No_Customer; Customer."No.")
            {
                IncludeCaption = true;
            }
            column(Name_Customer; Customer.Name)
            {
                IncludeCaption = true;
            }
            column(RptDate; Format(Today, 0, 4))
            {
            }
            column(CompanyName; CompanyName())
            {
            }
            column(CustFilter_Customer; Customer.TableCaption() + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(SortingCustomersCustDateFilter; StrSubstNo(PeriodLbl, CustDateFilter))
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(Division; Division)
            {
            }
            column(Country; Country)
            {
            }
            column(ShowPrevShipDate; ShowPrevShipDate)
            {
            }
            column(BacklogComment; BacklogComment)
            {
            }
            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Sell-to Customer No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.", "Document Type") order(ascending) where("Document Type" = filter(Order), Type = filter(Item), "Completely Shipped" = filter(false), "BOM Line No." = filter(= 0), "Outstanding Quantity" = filter(<> 0), "Additional Item Line No." = const(0));
                RequestFilterFields = "Location Code";

                trigger OnAfterGetRecord()
                begin
                    SalesHeader.Get(1, SalesLine."Document No.");

                    if not Customer."Unblock Pick.Date Restriction" then
                        if ItemPickDateCountry.Get(SalesLine."No.", SalesHeader."Ship-to Country/Region Code") then
                            if ItemPickDateCountry."Picking Start Date" > Today then
                                CurrReport.Skip();

                    TempSalesLine := SalesLine;
                    TempSalesLine.Insert();
                end;
            }

            trigger OnAfterGetRecord()
            var
                DefaultDim: Record "Default Dimension";
            begin
                Division := '';
                DefaultDim.SetFilter("Dimension Code", 'DIVISION');
                DefaultDim.SetFilter("Table ID", '18');
                DefaultDim.SetFilter("No.", Customer."No.");
                if DefaultDim.FindFirst() then
                    Division := DefaultDim."Dimension Value Code";

                Country := '';
                DefaultDim.SetFilter("Dimension Code", 'COUNTRY');
                DefaultDim.SetFilter("Table ID", '18');
                DefaultDim.SetFilter("No.", Customer."No.");
                if DefaultDim.FindFirst() then
                    Country := DefaultDim."Dimension Value Code";
            end;

            trigger OnPreDataItem()
            begin
                if (GuiAllowed() and (OrderToShow = Ordertoshow::Transfer)) or
                   ((not GuiAllowed()) and (CustomerToShow = ''))
                then
                    CurrReport.Break();

                if CustomerToShow <> '' then
                    Customer.SetRange(Customer."No.", CustomerToShow);

                if ShowPrevShipDate then begin
                    ChangeLogEntry.SetCurrentkey("Table No.", "Date and Time", "Primary Key Field 1 Value", "Primary Key Field 2 Value", "Primary Key Field 3 Value");
                    ChangeLogEntry.SetRange("Table No.", 37);  // Sales Line
                    ChangeLogEntry.SetRange("Field No.", 10);  // Shipment Date
                end;
            end;
        }
        dataitem(TransferLine; "Transfer Line")
        {
            CalcFields = "Delivery Document No.", "Warehouse Status";
            DataItemTableView = sorting("Transfer-to Code", Status, "Derived From Line No.", "Item No.", "Variant Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Receipt Date", "In-Transit Code") where("Outstanding Quantity" = filter(<> 0));
            RequestFilterFields = "Transfer-to Code";

            trigger OnAfterGetRecord()
            begin
                Item.Get(TransferLine."Item No.");
                TransferHeader.Get(TransferLine."Document No.");

                Clear(TempSalesLine);
                TempSalesLine."Document No." := TransferLine."Document No.";
                TempSalesLine."Line No." := TransferLine."Line No.";
                TempSalesLine."Sell-to Customer No." := TransferLine."Transfer-to Code";
                TempSalesLine."Ship-to Code" := TransferLine."Transfer-to Address Code";
                TempSalesLine."Location Code" := TransferLine."Transfer-from Code";
                TempSalesLine."Shipment No." := TransferLine."Transfer-to Code";
                TempSalesLine."No." := TransferLine."Item No.";
                TempSalesLine.Description := TransferLine.Description;
                TempSalesLine."Dimension Set ID" := TransferLine."Dimension Set ID";
                TempSalesLine."Shipment Date" := TransferLine."Shipment Date";
                TempSalesLine."Shipment Date Confirmed" := TransferLine."Shipment Date Confirmed";
                TempSalesLine."Delivery Document No." := TransferLine."Delivery Document No.";
                TempSalesLine."Warehouse Status" := TransferLine."Warehouse Status";
                TempSalesLine."Outstanding Quantity" := TransferLine."Outstanding Quantity";
                TempSalesLine."Currency Code" := GLSetup."LCY Code";
                TempSalesLine."External Document No." := TransferHeader."External Document No.";
                TempSalesLine.Insert();
            end;

            trigger OnPreDataItem()
            begin
                if (OrderToShow = Ordertoshow::Sales) or
                   ((Customer.GetFilters() <> '') and (GuiAllowed()))
                then
                    CurrReport.Break();

                TransferLine.SetRange(TransferLine."Transfer-from Code", ItemLogisticEvent.GetMainWarehouseLocation);
            end;
        }
        dataitem(TempSalesLine; "Sales Line")
        {
            CalcFields = "Order Date";
            DataItemTableView = sorting("Document Type", "Sell-to Customer No.", "Shipment No.");
            UseTemporary = true;
            column(CustNo_SalesLine; Cust."No.")
            {
            }
            column(CustName_SalesLine; Cust.Name)
            {
            }
            column(DocumentNo_SalesLine; TempSalesLine."Document No.")
            {
                IncludeCaption = true;
            }
            column(No_SalesLine; TempSalesLine."No.")
            {
                IncludeCaption = true;
            }
            column(Description_SalesLine; TempSalesLine.Description)
            {
                IncludeCaption = true;
            }
            column(Quantity_SalesLine; TempSalesLine."Outstanding Quantity")
            {
                IncludeCaption = true;
            }
            column(UnitPrice_SalesLine; TempSalesLine."Unit Price")
            {
                IncludeCaption = true;
            }
            column(CurrencyCode_SalesLine; TempSalesLine."Currency Code")
            {
                IncludeCaption = true;
            }
            column(ExternalDocumentNo_SalesLine; TempSalesLine."External Document No.")
            {
                IncludeCaption = true;
            }
            column(DeliveryDocumentNo_SalesLine; TempSalesLine."Delivery Document No.")
            {
                IncludeCaption = true;
            }
            column(WarehouseStatus_SalesLine; TempSalesLine."Warehouse Status")
            {
                IncludeCaption = true;
            }
            column(ShipmentDateConfirmed_SalesLine; TempSalesLine."Shipment Date Confirmed")
            {
                IncludeCaption = true;
            }
            column(ShipToCode; TempSalesLine."Ship-to Code")
            {
                IncludeCaption = true;
            }
            column(ShipToName; ShipToName)
            {
                IncludeCaption = false;
            }
            column(ShipToAdd; ShipToAdd)
            {
            }
            column(Dimension1; TempSalesLine."Shortcut Dimension 1 Code")
            {
                IncludeCaption = true;
            }
            column(Dimension2; TempSalesLine."Shortcut Dimension 2 Code")
            {
                IncludeCaption = true;
            }
            column(Dimension3; DimSetEntry."Dimension Value Code")
            {
            }
            column(OrderDate; TempSalesLine."Order Date")
            {
            }
            column(Amount; TempSalesLine.Amount)
            {
            }
            column(ShipmentDate; TempSalesLine."Shipment Date")
            {
                IncludeCaption = true;
            }
            column(RequestedDeliveryDate; TempSalesLine."Requested Delivery Date")
            {
            }
            column(LocationCode; TempSalesLine."Location Code")
            {
            }
            column(Comment_SalesLine; TempSalesLine."Backlog Comment")
            {
            }
            column(PreviousShipmentDate; PrevShipmentDate)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Cust);
                if not Cust.Get(TempSalesLine."Sell-to Customer No.") then
                    if Location.Get(TempSalesLine."Sell-to Customer No.") then begin
                        Cust."No." := Location.Code;
                        Cust.Name := Location.Name;
                    end;

                ShipToName := '';
                if TempSalesLine."Document Type" = TempSalesLine."document type"::Order then begin
                    if ShipToAddress.Get(TempSalesLine."Sell-to Customer No.", TempSalesLine."Ship-to Code") then begin
                        ShipToName := ShipToAddress.Name;
                        ShipToAdd := ShipToAddress.Address;
                    end;
                end else begin
                    if TransToAddress.Get(TempSalesLine."Shipment No.", TempSalesLine."Ship-to Code") then begin
                        ShipToName := TransToAddress.Name;
                        ShipToAdd := TransToAddress.Address;
                    end;
                end;

                Clear(DimSetEntry);
                if TempSalesLine."Dimension Set ID" <> 0 then
                    if not DimSetEntry.Get(TempSalesLine."Dimension Set ID", GLSetup."Shortcut Dimension 3 Code") then;

                TempSalesLine.Amount := TempSalesLine."Unit Price" * TempSalesLine.Quantity;

                if ShowPrevShipDate then begin
                    PrevShipmentDate := 0D;
                    ChangeLogEntry.SetRange("Primary Key Field 1 Value", '1');
                    ChangeLogEntry.SetRange("Primary Key Field 2 Value", TempSalesLine."Document No.");
                    ChangeLogEntry.SetFilter("Primary Key Field 3 Value", '%1', Format(TempSalesLine."Line No."));
                    if ChangeLogEntry.FindLast() then
                        Evaluate(PrevShipmentDate, ChangeLogEntry."Old Value", 9);
                end;
            end;
        }
    }

    labels
    {
        RptTitle = 'Backlog Report';
        RptShipmentDate = 'Shipment Date';
        RptAmount = 'Amount';
        RptOrderDate = 'Order Date';
        RptPrevShipmentDate = 'Previous Picking Date';
        RptShipToAdd = 'Ship to Address';
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GetFilters();
        CustDateFilter := Customer.GetFilter("Date Filter");
        GLSetup.Get();
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TransferHeader: Record "Transfer Header";
        ShipToAddress: Record "Ship-to Address";
        TransToAddress: Record "Transfer-to Address";
        SalesHeader: Record "Sales Header";
        ItemPickDateCountry: Record "Item Picking Date pr. Country";
        ChangeLogEntry: Record "Change Log Entry";
        Cust: Record Customer;
        DimSetEntry: Record "Dimension Set Entry";
        Location: Record Location;
        Item: Record Item;
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        Country: Code[10];
        CustDateFilter: Text[30];
        ShipToName: Text[50];
        Division: Text[30];
        CustomerToShow: Code[20];
        CustFilter: Text;
        ShipToAdd: Text;
        BacklogComment: Text;
        Amount: Decimal;
        ShipmentDateConfirmedFormatted: Date;
        PrevShipmentDate: Date;
        ShowPrevShipDate: Boolean;
        OrderToShow: Option Sales,Transfer,,All;
        PeriodLbl: Label 'Period: %1';
        CurrReportPageNoCaptionLbl: Label 'Page';

    procedure InitRequest(NewOrderToShow: Option Sales,Transfer,,Both; NewCustomerToShow: Code[20]; NewBacklogComment: Text)
    begin
        OrderToShow := NewOrderToShow;
        CustomerToShow := NewCustomerToShow;
        BacklogComment := NewBacklogComment;
    end;
}
