Report 50045 "Backlog Report"
{

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Backlog Report.rdlc';

    ShowPrintStatus = false;
    UsageCategory = ReportsandAnalysis;
    UseRequestPage = true;

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
            column(CustFilter_Customer; Customer.TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(SortingCustomersCustDateFilter; StrSubstNo(Text001, CustDateFilter))
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
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Sell-to Customer No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.", "Document Type") order(ascending) where("Document Type" = filter(Order), Type = filter(Item), "Completely Shipped" = filter(false), "BOM Line No." = filter(= 0), "Outstanding Quantity" = filter(<> 0), "Additional Item Line No." = const(0));
                RequestFilterFields = "Location Code";

                trigger OnAfterGetRecord()
                begin
                    recSalesHeader.Get(1, "Sales Line"."Document No.");

                    if not Customer."Unblock Pick.Date Restriction" then  // 21-08-19 ZY-LD 006
                                                                          //>> 19-03-19 ZY-LD 005
                        if recPickDateCountry.Get("Sales Line"."No.", recSalesHeader."Ship-to Country/Region Code") then
                            if recPickDateCountry."Picking Start Date" > Today then
                                CurrReport.Skip;
                    //<< 19-03-19 ZY-LD 005

                    SalesLineTmp := "Sales Line";
                    SalesLineTmp.Insert;
                end;
            }

            trigger OnAfterGetRecord()
            var
                recDefaultDimensions: Record "Default Dimension";
            begin
                ZGT.UpdateProgressWindow(Customer."No.", 0, true);  // 18-05-18 ZY-LD 002

                Division := '';
                recDefaultDimensions.SetFilter("Dimension Code", 'DIVISION');
                recDefaultDimensions.SetFilter("Table ID", '18');
                recDefaultDimensions.SetFilter("No.", Customer."No.");
                if recDefaultDimensions.FindFirst then
                    Division := recDefaultDimensions."Dimension Value Code";

                //>> 18-05-18 ZY-LD 002
                Country := '';
                recDefaultDimensions.SetFilter("Dimension Code", 'COUNTRY');
                recDefaultDimensions.SetFilter("Table ID", '18');
                recDefaultDimensions.SetFilter("No.", Customer."No.");
                if recDefaultDimensions.FindFirst then
                    Country := recDefaultDimensions."Dimension Value Code";
                //<< 18-05-18 ZY-LD 002
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;  // 18-05-18 ZY-LD 002
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', Customer.Count);  // 18-05-18 ZY-LD 002

                //>> 09-08-22 ZY-LD 008
                if GuiAllowed and (OrderToShow = Ordertoshow::Transfer) or
                   (not GuiAllowed) and (CustomerToShow = '')
                then
                    CurrReport.Break();

                if CustomerToShow <> '' then
                    Customer.SetRange(Customer."No.", CustomerToShow);
                //<< 09-08-22 ZY-LD 008

                if ShowPrevShipDate then begin
                    recCngLogEntry.SetCurrentkey("Table No.", "Date and Time", "Primary Key Field 1 Value", "Primary Key Field 2 Value", "Primary Key Field 3 Value");
                    recCngLogEntry.SetRange("Table No.", 37);  // Sales Line
                    recCngLogEntry.SetRange("Field No.", 10);  // Shipment Date
                end;
            end;
        }
        dataitem("Transfer Line"; "Transfer Line")
        {
            CalcFields = "Delivery Document No.", "Warehouse Status";
            DataItemTableView = sorting("Transfer-to Code", Status, "Derived From Line No.", "Item No.", "Variant Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Receipt Date", "In-Transit Code") where("Outstanding Quantity" = filter(<> 0));
            RequestFilterFields = "Transfer-to Code";

            trigger OnAfterGetRecord()
            begin
                recItem.Get("Transfer Line"."Item No.");
                recTransHead.Get("Transfer Line"."Document No.");

                Clear(SalesLineTmp);
                SalesLineTmp."Document No." := "Transfer Line"."Document No.";
                SalesLineTmp."Line No." := "Transfer Line"."Line No.";
                SalesLineTmp."Sell-to Customer No." := "Transfer Line"."Transfer-to Code";
                SalesLineTmp."Ship-to Code" := "Transfer Line"."Transfer-to Address Code";
                SalesLineTmp."Location Code" := "Transfer Line"."Transfer-from Code";
                SalesLineTmp."Shipment No." := "Transfer Line"."Transfer-to Code";
                SalesLineTmp."No." := "Transfer Line"."Item No.";
                SalesLineTmp.Description := "Transfer Line".Description;
                SalesLineTmp."Dimension Set ID" := "Transfer Line"."Dimension Set ID";
                SalesLineTmp."Shipment Date" := "Transfer Line"."Shipment Date";
                SalesLineTmp."Shipment Date Confirmed" := "Transfer Line"."Shipment Date Confirmed";
                SalesLineTmp."Delivery Document No." := "Transfer Line"."Delivery Document No.";
                SalesLineTmp."Warehouse Status" := "Transfer Line"."Warehouse Status";
                SalesLineTmp."Outstanding Quantity" := "Transfer Line"."Outstanding Quantity";
                SalesLineTmp."Currency Code" := recGenLedgSetup."LCY Code";
                SalesLineTmp."External Document No." := recTransHead."External Document No.";
                //SalesLineTmp."Unit Price" := recItem."Unit Cost";
                SalesLineTmp.Insert;
            end;

            trigger OnPreDataItem()
            begin
                //>> 09-08-22 ZY-LD 008
                if (OrderToShow = Ordertoshow::Sales) or
                   ((Customer.GetFilters <> '') and (GuiAllowed)) then
                    CurrReport.Break();
                //<< 09-08-22 ZY-LD 008

                "Transfer Line".SetRange("Transfer Line"."Transfer-from Code", ItemLogisticEvent.GetMainWarehouseLocation);
            end;
        }
        dataitem(SalesLineTmp; "Sales Line")
        {
            CalcFields = "Order Date";
            DataItemTableView = sorting("Document Type", "Sell-to Customer No.", "Shipment No.");
            UseTemporary = true;
            column(CustNo_SalesLine; recCust."No.")
            {
            }
            column(CustName_SalesLine; recCust.Name)
            {
            }
            column(DocumentNo_SalesLine; SalesLineTmp."Document No.")
            {
                IncludeCaption = true;
            }
            column(No_SalesLine; SalesLineTmp."No.")
            {
                IncludeCaption = true;
            }
            column(Description_SalesLine; SalesLineTmp.Description)
            {
                IncludeCaption = true;
            }
            column(Quantity_SalesLine; SalesLineTmp."Outstanding Quantity")
            {
                IncludeCaption = true;
            }
            column(UnitPrice_SalesLine; SalesLineTmp."Unit Price")
            {
                IncludeCaption = true;
            }
            column(CurrencyCode_SalesLine; SalesLineTmp."Currency Code")
            {
                IncludeCaption = true;
            }
            column(Customer_PO_No; SalesLineTmp."External Document No.") //23-05-2025 BK #508124
            {
                IncludeCaption = true;
            }
            column(Customer_PO_Position_NO; saleslineTmp."External Document Position No.") //23-05-2025 BK #508124
            {
                IncludeCaption = true;
            }
            column(DeliveryDocumentNo_SalesLine; SalesLineTmp."Delivery Document No.")
            {
                IncludeCaption = true;
            }
            column(WarehouseStatus_SalesLine; SalesLineTmp."Warehouse Status")
            {
                IncludeCaption = true;
            }
            column(ShipmentDateConfirmed_SalesLine; SalesLineTmp."Shipment Date Confirmed")
            {
                IncludeCaption = true;
            }
            column(ShipToCode; SalesLineTmp."Ship-to Code")
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
            column(Dimension1; SalesLineTmp."Shortcut Dimension 1 Code")
            {
                IncludeCaption = true;
            }
            column(Dimension2; SalesLineTmp."Shortcut Dimension 2 Code")
            {
                IncludeCaption = true;
            }
            column(Dimension3; recDimSetEntry."Dimension Value Code")
            {
            }
            column(OrderDate; SalesLineTmp."Order Date")
            {
            }
            column(Amount; SalesLineTmp.Amount)
            {
            }
            column(ShipmentDate; SalesLineTmp."Shipment Date")
            {
                IncludeCaption = true;
                //Caption = 'Expected Dispatch Date';
            }
            column(RequestedDeliveryDate; SalesLineTmp."Requested Delivery Date")
            {
            }
            column(LocationCode; SalesLineTmp."Location Code")
            {
            }
            column(Comment_SalesLine; SalesLineTmp."Backlog Comment")
            {
            }
            column(PreviousShipmentDate; PrevShipmentDate)
            {
            }
            column(Item_Reference_No_; SalesLineTmp."Item Reference No.")  // 04-09-24 ZY-LD #455675
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(recCust);
                if not recCust.Get(SalesLineTmp."Sell-to Customer No.") then
                    if recLocation.Get(SalesLineTmp."Sell-to Customer No.") then begin
                        recCust."No." := recLocation.Code;
                        recCust.Name := recLocation.Name;
                    end;

                ShipToName := '';
                if SalesLineTmp."Document Type" = SalesLineTmp."document type"::Order then begin
                    if recShipToAdd.Get(SalesLineTmp."Sell-to Customer No.", SalesLineTmp."Ship-to Code") then begin
                        ShipToName := recShipToAdd.Name;
                        ShipToAdd := recShipToAdd.Address;
                    end;
                end else begin
                    if recTranstoAdd.Get(SalesLineTmp."Shipment No.", SalesLineTmp."Ship-to Code") then begin
                        ShipToName := recTranstoAdd.Name;
                        ShipToAdd := recTranstoAdd.Address;
                    end;
                end;

                Clear(recDimSetEntry);
                if SalesLineTmp."Dimension Set ID" <> 0 then
                    if not recDimSetEntry.Get(SalesLineTmp."Dimension Set ID", recGenLedgSetup."Shortcut Dimension 3 Code") then;

                SalesLineTmp.Amount := SalesLineTmp."Unit Price" * SalesLineTmp.Quantity;

                if ShowPrevShipDate then begin
                    PrevShipmentDate := 0D;
                    recCngLogEntry.SetRange("Primary Key Field 1 Value", '1');
                    recCngLogEntry.SetRange("Primary Key Field 2 Value", SalesLineTmp."Document No.");
                    recCngLogEntry.SetFilter("Primary Key Field 3 Value", '%1', Format(SalesLineTmp."Line No."));
                    if recCngLogEntry.FindLast then
                        Evaluate(PrevShipmentDate, recCngLogEntry."Old Value", 9);
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowPrevShipDate; ShowPrevShipDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Previous Shipment Date';
                    }
                    field(OrderToShow; OrderToShow)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Orders';
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
        RptTitle = 'Backlog Report';
        RptShipmentDate = 'Shipment Date';
        RptAmount = 'Amount';
        RptOrderDate = 'Order Date';
        RptPrevShipmentDate = 'Previous Picking Date';
        RptShipToAdd = 'Ship to Address';
        CustPONo = 'Customer PO. No.';
        CustPOPosNo = 'Customer PO. Pos. No.';
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GetFilters();
        CustDateFilter := Customer.GetFilter("Date Filter");
        recGenLedgSetup.Get();
    end;

    var
        recTransHead: Record "Transfer Header";
        recShipToAdd: Record "Ship-to Address";
        recTranstoAdd: Record "Transfer-to Address";
        recSalesHeader: Record "Sales Header";
        recPickDateCountry: Record "Item Picking Date pr. Country";
        recCngLogEntry: Record "Change Log Entry";
        recCust: Record Customer;
        recDimSetEntry: Record "Dimension Set Entry";
        recGenLedgSetup: Record "General Ledger Setup";
        recLocation: Record Location;
        recItem: Record Item;
        Amount: Decimal;
        CustFilter: Text;
        CustDateFilter: Text[30];
        Text001: label 'Period: %1';
        CurrReportPageNoCaptionLbl: label 'Page';
        ShipToName: Text;
        ShipToAdd: Text;
        ShipmentDateConfirmedFormatted: Date;
        PrevShipmentDate: Date;
        Division: Text[30];
        Country: Code[10];
        ZGT: Codeunit "ZyXEL General Tools";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        ShowPrevShipDate: Boolean;
        OrderToShow: Option Sales,Transfer,,All;
        CustomerToShow: Code[20];


    procedure InitRequest(NewOrderToShow: Option Sales,Transfer,,Both; NewCustomerToShow: Code[20])
    begin
        OrderToShow := NewOrderToShow;
        CustomerToShow := NewCustomerToShow;
    end;
}
