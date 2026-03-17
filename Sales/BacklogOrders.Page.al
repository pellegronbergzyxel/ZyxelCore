page 50090 "Backlog Orders"
{
    //05-06-2025 BK #Cleanup
    ApplicationArea = Basic, Suite;
    Caption = 'Backlog Orders';
    PageType = List;
    SourceTable = "Sales Line"; //0303-2026 BK #522282
    SourceTableTemporary = true;
    /*SourceTableView = sorting("Document No.", "Line No.", "Document Type")
                      where("Document Type" = const(Order),
                            Type = const(Item),
                            Quantity =filter(<>0),
                            "Warehouse Status" = filter(0 | 1 | 2 | 3 | 4 | 5 | 6 | 8),
                            "BOM Line No." = const(0),
                            "Additional Item Line No." = const(0)); */
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Sell-to Customer No.';
                }
                field("Sell-to Name"; Rec."Sell-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Sell-to Name';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Ship-to Code';
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Ship-to Name';
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Ship-to Address';
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Ship-to Country/Region Code';
                }
                field("Division Code"; Rec."Division Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Division Code';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Country Code';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Document No.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Order Date';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies External Document No.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Shipment Date';
                }
                field("Shipment Date Confirmed"; Rec."Shipment Date Confirmed")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Shipment Date Confirmed';
                }
                field("Delivery Document No."; Rec."Delivery Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Delivery Document No. ';
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Warehouse Status';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Description';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies  Quantity';
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Outstanding Quantity';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Unit Price';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Amount';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    Visible = false;
                    ToolTip = 'Specifies Line Discount Amount';
                }
                field("Amount Excl. Discount"; Rec.Amount + Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount Excl. Discount';
                    ToolTip = 'Specifies Amount Excl. Discount';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Currency Code';
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Requested Delivery Date';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Location Code';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Slaesperson Code';
                }
                field("Order Desk Responsible Code"; Rec."Order Desk Responsible Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Order Desk Responsibel Code';
                }
                field("Backlog Comment"; Rec."Backlog Comment")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Backlog Comment';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin

        Rec.Reset();
        Rec.DeleteAll();
        FillInTempSLine(Rec);


    end;

    procedure FillInTempSLine(var Rec: Record "Sales Line" temporary)
    var
        SalesLine: Record "Sales Line";
        DeliverDocument: Record "VCK Delivery Document Header";
        SkipLine: Boolean;

    begin
        SkipLine := false;
        SalesLine.SetCurrentKey("Document No.", "Line No.", "Document Type");
        salesLine.setrange("Document Type", SalesLine."Document Type"::Order);
        salesLine.setrange(Type, SalesLine.Type::Item);
        SalesLine.setfilter(Quantity, '<>%1', 0);
        SalesLine.Setfilter("Warehouse Status", '%1|%2|%3|%4|%5|%6|%7', SalesLine."Warehouse Status"::New, SalesLine."Warehouse Status"::"Ready to Pick", SalesLine."Warehouse Status"::Picking,
                            SalesLine."Warehouse Status"::Packed, SalesLine."Warehouse Status"::"In Transit", SalesLine."Warehouse Status"::"Invoice Received", SalesLine."Warehouse Status"::"Waiting for invoice");
        SalesLine.SetRange("BOM Line No.", 0);
        SalesLine.setrange("Additional Item Line No.", 0);


        if SalesLine.FindSet() then
            repeat
                if deliverDocument.Get(SalesLine."Delivery Document No.") then
                    if DeliverDocument."Document Status" = DeliverDocument."Document Status"::Posted then
                        SkipLine := true;

                if not SkipLine then begin
                    Rec := SalesLine;
                    Rec.Insert();
                end;

                SkipLine := false; //16-03-2026 BK #560383
            until SalesLine.Next() = 0;

    end;
}

