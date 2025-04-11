Page 50367 "Sales Return Order - Backlog"
{
    // 001. 10-04-19 ZY-LD 000 - "PFE EXPRESS" is added to the filter.
    Permissions = tabledata "Sales Invoice Header" = m;

    ApplicationArea = Basic, Suite;
    Caption = 'Sales Return Order - Backlog';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = sorting("Document Type", "Sell-to Customer No.")
                      order(ascending)
                      where("Document Type" = const("Return Order"),
                            "Completely Invoiced" = const(false),
                            Type = const(Item));
    UsageCategory = ReportsandAnalysis;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sell-to Customer Name';
                }
                field(ForecastTerritory; ForecastTerritory)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Forecast Territory';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Return Qty. to Receive"; Rec."Return Qty. to Receive")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Visible = false;
                }
                field("Return Qty. Received"; Rec."Return Qty. Received")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = false;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = false;
                }
                field("Return Qty. Rcd. Not Invd."; Rec."Return Qty. Rcd. Not Invd.")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Invoice';

                trigger OnAction()
                begin
                    CreateInvoice;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        CustomerName := SalesHeader."Sell-to Customer Name";
        recCust.Get(Rec."Sell-to Customer No.");
        ForecastTerritory := recCust."Forecast Territory";
    end;

    var
        SalesHeader: Record "Sales Header";
        recCust: Record Customer;
        CustomerName: Text[50];
        ForecastTerritory: Text;

    local procedure CreateInvoice()
    var
        lSalesLine: Record "Sales Line";
        lText001: label 'Do you want to create an sales invoice on %1 %2?';
        lSalesInvHead: Record "Sales Header";
        lSalesInvLine: Record "Sales Line";
    begin
        CurrPage.SetSelectionFilter(lSalesLine);
        if Confirm(lText001, false, lSalesLine."Sell-to Customer No.", lSalesLine."Ship-to Code") then begin
            lSalesInvHead."Document Type" := lSalesInvHead."document type"::Invoice;
            lSalesInvHead.Insert(true);
            lSalesInvHead.Validate("Sell-to Customer No.", lSalesLine."Sell-to Customer No.");
            lSalesInvHead.Validate("Ship-to Code", lSalesLine."Ship-to Code");
            lSalesInvHead.Modify(true);

            lSalesLine.FindSet;
            repeat
                lSalesInvLine.Validate("Document Type", lSalesInvHead."Document Type");
                lSalesInvLine.Validate("Document No.", lSalesInvHead."No.");
                lSalesInvLine.Validate("Line No.", lSalesLine."Line No.");
                lSalesInvLine.Validate(Type, lSalesLine.Type);
                lSalesInvLine.Validate("No.", lSalesLine."No.");
                lSalesInvLine.Validate("Location Code", lSalesLine."Location Code");
                lSalesInvLine.Validate(Description, lSalesLine.Description);
                lSalesInvLine.Validate("Description 2", lSalesLine."Description 2");
                lSalesInvLine.Validate("Unit of Measure", lSalesLine."Unit of Measure");
                lSalesInvLine.Validate(Quantity, lSalesLine.Quantity);
                lSalesInvLine.Validate("Unit Price", lSalesLine."Unit Price");
                lSalesInvLine.Insert(true);
            until lSalesLine.Next() = 0;
        end;
    end;
}
