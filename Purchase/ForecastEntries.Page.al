Page 50069 "Forecast Entries"
{
    // // Ticket 2018051510000091
    // // PAB 15/05/18 Fixed Territory filter lookup
    // 001. 21-08-18 ZY-LD 2018082010000182 - Description is updated
    // 002. 26-01-18 ZY-LD 000 - View Sales Order.
    // 003. 03-11-20 ZY-LD P0514 - Filter is set.

    DataCaptionFields = "Item No.";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Item Budget Entry";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Out of Forecast"; Rec."Out of Forecast")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sales Amount"; Rec."Sales Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Budget Dimension 1 Code"; Rec."Budget Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SO Number"; Rec."SO Number")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Order No.';

                    trigger OnDrillDown()
                    begin
                        ShowSalesOrder(Rec."SO Number");  // 26-10-18 ZY-LD 002
                    end;
                }
                field("SO Line Number"; Rec."SO Line Number")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Order Line No.';
                    Visible = false;
                }
                field("Cost Amount Item"; Rec."Cost Amount Item")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sales Amount Item"; Rec."Sales Amount Item")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Budget Name"; Rec."Budget Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1; "Dimension Value FactBox")
            {
                SubPageLink = "Dimension Set ID" = field("Dimension Set ID");
            }
            systempart(Control3; Links)
            {
                Visible = true;
            }
            systempart(Control2; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Show Sales Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Sales Order';
                Image = ViewOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowSalesOrder(Rec."SO Number");  // 26-10-18 ZY-LD 002
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //>> 21-08-18 ZY-LD 001
        case Rec."Source Type" of
            Rec."source type"::Customer:
                if recCust.Get(Rec."Source No.") then
                    Rec.Description := recCust.Name;
            Rec."source type"::Item:
                if recItem.Get(Rec."Source No.") then
                    Rec.Description := recItem.Description;
        end;
        //<< 21-08-18 ZY-LD 001
    end;

    var
        recCust: Record Customer;
        recItem: Record Item;


    procedure SetSOFilter2M(var SalesOrderLine: Record "Sales Line") Available: Integer
    var
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        ItemBudgetManagement: Codeunit "Item Budget Management Ext.";
        Country: Code[20];
        recCustomer: Record Customer;
        TerritoryCode: Code[20];
        recTerritoryCountries: Record "Forecast Territory Country";
        CountryFilter: Text[250];
    begin
        recCustomer.SetFilter("No.", SalesOrderLine."Sell-to Customer No.");

        //PAB
        if recCustomer.FindSet then TerritoryCode := recCustomer."Forecast Territory";
        if TerritoryCode = '' then exit(0);
        recTerritoryCountries.SetFilter("Forecast Territory Code", TerritoryCode);
        if not recTerritoryCountries.FindSet then exit(0);
        if recTerritoryCountries.FindSet then begin
            repeat
                CountryFilter := CountryFilter + recTerritoryCountries."Territory Code";
                CountryFilter := CountryFilter + '|';
            until recTerritoryCountries.Next() = 0;
            CountryFilter := DelChr(CountryFilter, '>', '|');
        end;
        if CountryFilter = '' then
            exit(0);

        Rec.SetFilter("Budget Name", ItemBudgetManagement.GetMasterForecastName);
        Rec.SetFilter("Item No.", SalesOrderLine."No.");
        Rec.SetFilter("Budget Dimension 1 Code", CountryFilter);
        StartDate := CalcDate('<+2M>', Today);
        BeginDate := Dmy2date(1, Date2dmy(StartDate, 2), Date2dmy(StartDate, 3));
        Rec.SetFilter(Date, Format(BeginDate));
    end;


    procedure SetSOFilter1M(var SalesOrderLine: Record "Sales Line") Available: Integer
    var
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        ItemBudgetManagement: Codeunit "Item Budget Management Ext.";
        Country: Code[20];
        recCustomer: Record Customer;
        TerritoryCode: Code[20];
        recTerritoryCountries: Record "Forecast Territory Country";
        CountryFilter: Text[250];
    begin
        recCustomer.SetFilter("No.", SalesOrderLine."Sell-to Customer No.");

        //PAB
        if recCustomer.FindSet then TerritoryCode := recCustomer."Forecast Territory";
        if TerritoryCode = '' then exit(0);
        recTerritoryCountries.SetFilter("Forecast Territory Code", TerritoryCode);
        if not recTerritoryCountries.FindSet then exit(0);
        if recTerritoryCountries.FindSet then begin
            repeat
                CountryFilter := CountryFilter + recTerritoryCountries."Territory Code";
                CountryFilter := CountryFilter + '|';
            until recTerritoryCountries.Next() = 0;
            CountryFilter := DelChr(CountryFilter, '>', '|');
        end;
        if CountryFilter = '' then
            exit(0);

        Rec.SetFilter("Budget Name", ItemBudgetManagement.GetMasterForecastName);
        Rec.SetFilter("Item No.", SalesOrderLine."No.");
        Rec.SetFilter("Budget Dimension 1 Code", CountryFilter);
        StartDate := CalcDate('<+1M>', Today);
        BeginDate := Dmy2date(1, Date2dmy(StartDate, 2), Date2dmy(StartDate, 3));
        Rec.SetFilter(Date, Format(BeginDate));
    end;


    procedure SetSOFilter0M(var SalesOrderLine: Record "Sales Line") Available: Integer
    var
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        ItemBudgetManagement: Codeunit "Item Budget Management Ext.";
        Country: Code[20];
        recCustomer: Record Customer;
        TerritoryCode: Code[20];
        recTerritoryCountries: Record "Forecast Territory Country";
        CountryFilter: Text[250];
    begin
        recCustomer.SetFilter("No.", SalesOrderLine."Sell-to Customer No.");

        //PAB
        if recCustomer.FindSet then TerritoryCode := recCustomer."Forecast Territory";
        if TerritoryCode = '' then exit(0);
        recTerritoryCountries.SetFilter("Forecast Territory Code", TerritoryCode);
        if not recTerritoryCountries.FindSet then exit(0);
        if recTerritoryCountries.FindSet then begin
            repeat
                CountryFilter := CountryFilter + recTerritoryCountries."Territory Code";
                CountryFilter := CountryFilter + '|';
            until recTerritoryCountries.Next() = 0;
            CountryFilter := DelChr(CountryFilter, '>', '|');
        end;
        if CountryFilter = '' then
            exit(0);

        Rec.SetFilter("Budget Name", ItemBudgetManagement.GetMasterForecastName);
        Rec.SetFilter("Item No.", SalesOrderLine."No.");
        Rec.SetFilter("Budget Dimension 1 Code", CountryFilter);
        StartDate := CalcDate('<+0M>', Today);
        BeginDate := Dmy2date(1, Date2dmy(StartDate, 2), Date2dmy(StartDate, 3));
        Rec.SetFilter(Date, Format(BeginDate));
    end;


    procedure SetPOFilter0M(var PurchaseOrderLine: Record "Purchase Line") Available: Integer
    var
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        ItemBudgetManagement: Codeunit "Item Budget Management Ext.";
    begin
        Rec.SetFilter("Budget Name", ItemBudgetManagement.GetMasterForecastName);
        Rec.SetFilter("Item No.", PurchaseOrderLine."No.");
        StartDate := CalcDate('<+0M>', Today);
        BeginDate := Dmy2date(1, Date2dmy(StartDate, 2), Date2dmy(StartDate, 3));
        Rec.SetFilter(Date, Format(BeginDate));
    end;


    procedure SetPOFilter1M(var PurchaseOrderLine: Record "Purchase Line") Available: Integer
    var
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        ItemBudgetManagement: Codeunit "Item Budget Management Ext.";
    begin
        Rec.SetFilter("Budget Name", ItemBudgetManagement.GetMasterForecastName);
        Rec.SetFilter("Item No.", PurchaseOrderLine."No.");
        StartDate := CalcDate('<+1M>', Today);
        BeginDate := Dmy2date(1, Date2dmy(StartDate, 2), Date2dmy(StartDate, 3));
        Rec.SetFilter(Date, Format(BeginDate));
    end;


    procedure SetPOFilter2M(var PurchaseOrderLine: Record "Purchase Line") Available: Integer
    var
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        ItemBudgetManagement: Codeunit "Item Budget Management Ext.";
    begin
        Rec.SetFilter("Budget Name", ItemBudgetManagement.GetMasterForecastName);
        Rec.SetFilter("Item No.", PurchaseOrderLine."No.");
        StartDate := CalcDate('<+2M>', Today);
        BeginDate := Dmy2date(1, Date2dmy(StartDate, 2), Date2dmy(StartDate, 3));
        Rec.SetFilter(Date, Format(BeginDate));
    end;


    procedure SetSOFilter3M(var SalesOrderLine: Record "Sales Line") Available: Integer
    var
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        ItemBudgetManagement: Codeunit "Item Budget Management Ext.";
        Country: Code[20];
        recCustomer: Record Customer;
        TerritoryCode: Code[20];
        recTerritoryCountries: Record "Forecast Territory Country";
        CountryFilter: Text[250];
    begin
        recCustomer.SetFilter("No.", SalesOrderLine."Sell-to Customer No.");

        //PAB
        if recCustomer.FindSet then TerritoryCode := recCustomer."Forecast Territory";
        if TerritoryCode = '' then exit(0);
        recTerritoryCountries.SetFilter("Forecast Territory Code", TerritoryCode);
        if not recTerritoryCountries.FindSet then exit(0);
        if recTerritoryCountries.FindSet then begin
            repeat
                CountryFilter := CountryFilter + recTerritoryCountries."Territory Code";
                CountryFilter := CountryFilter + '|';
            until recTerritoryCountries.Next() = 0;
            CountryFilter := DelChr(CountryFilter, '>', '|');
        end;
        if CountryFilter = '' then
            exit(0);

        Rec.SetFilter("Budget Name", ItemBudgetManagement.GetMasterForecastName);
        Rec.SetFilter("Item No.", SalesOrderLine."No.");
        Rec.SetFilter("Budget Dimension 1 Code", CountryFilter);
        StartDate := CalcDate('<+3M>', Today);
        BeginDate := Dmy2date(1, Date2dmy(StartDate, 2), Date2dmy(StartDate, 3));
        Rec.SetFilter(Date, Format(BeginDate));
    end;


    procedure SetPOFilter3M(var PurchaseOrderLine: Record "Purchase Line") Available: Integer
    var
        DateFilter: Text[30];
        BeginDate: Date;
        StartDate: Date;
        ItemBudgetManagement: Codeunit "Item Budget Management Ext.";
    begin
        Rec.SetFilter("Budget Name", ItemBudgetManagement.GetMasterForecastName);
        Rec.SetFilter("Item No.", PurchaseOrderLine."No.");
        StartDate := CalcDate('<+3M>', Today);
        BeginDate := Dmy2date(1, Date2dmy(StartDate, 2), Date2dmy(StartDate, 3));
        Rec.SetFilter(Date, Format(BeginDate));
    end;

    local procedure ShowSalesOrder(pOrderNo: Code[20])
    var
        recSalesHead: Record "Sales Header";
        pageSalesOrder: Page "Sales Order";
    begin
        //>> 26-10-18 ZY-LD 002
        if recSalesHead.Get(recSalesHead."document type"::Order, pOrderNo) then begin
            recSalesHead.SetRange("No.", recSalesHead."No.");  // 03-11-20 ZY-LD 003
            pageSalesOrder.Editable(false);
            pageSalesOrder.SetTableview(recSalesHead);
            pageSalesOrder.RunModal;
        end;
        //<< 26-10-18 ZY-LD 002
    end;
}
