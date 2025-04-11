Report 50036 "Overshipment Accrual"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Overshipment Accrual.rdlc';
    Caption = 'Overshipment Accrual';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Gen. Product Posting Group"; "Gen. Product Posting Group")
        {
            RequestFilterFields = "Code";
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Gen. Prod. Posting Group" = field(Code);
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") where("Document Type" = const(Order), "Completely Shipped" = const(false), Quantity = filter(> 0), "Gen. Prod. Post. Grp. Type" = const(Overshipment));
                column(DocumentNo; "Sales Line"."Document No.")
                {
                }
                column(LineNo; "Sales Line"."Line No.")
                {
                }
                column(SellToCustomerNo; "Sales Line"."Sell-to Customer No.")
                {
                }
                column(Type; "Sales Line".Type)
                {
                }
                column(LocationCode; "Sales Line"."Location Code")
                {
                }
                column(ItemNo; "Sales Line"."No.")
                {
                }
                column(Description; "Sales Line".Description)
                {
                }
                column(Quantity; "Sales Line".Quantity)
                {
                }
                column(OutstandingQuantity; "Sales Line"."Outstanding Quantity")
                {
                }
                column(QuantityAccrual; QtyAccrual)
                {
                }
                column(UnitCostLCY; "Sales Line"."Unit Cost (LCY)")
                {
                }
                column(ShippedPercentiage; PctMainShip * 100)
                {
                }
                column(AccrualAmount; QtyAccrual * "Sales Line"."Unit Cost (LCY)")
                {
                }
                column(ErrorDescription; ErrorDescription)
                {
                }
                column(CalculationText; CalculationText)
                {
                }
                column(CreatedBy; recSalesHead."Create User ID")
                {
                }
                column(DocumentNo_Caption; "Sales Line".FieldCaption("Sales Line"."Document No."))
                {
                }
                column(LineNo_Caption; "Sales Line".FieldCaption("Sales Line"."Line No."))
                {
                }
                column(SellToCustomerNo_Caption; "Sales Line".FieldCaption("Sales Line"."Sell-to Customer No."))
                {
                }
                column(Type_Caption; "Sales Line".FieldCaption("Sales Line".Type))
                {
                }
                column(LocationCode_Caption; "Sales Line".FieldCaption("Sales Line"."Location Code"))
                {
                }
                column(ItemNo_Caption; "Sales Line".FieldCaption("Sales Line"."No."))
                {
                }
                column(Description_Caption; "Sales Line".FieldCaption("Sales Line".Description))
                {
                }
                column(Quantity_Caption; "Sales Line".FieldCaption("Sales Line".Quantity))
                {
                }
                column(OutstandingQuantity_Caption; "Sales Line".FieldCaption("Sales Line"."Outstanding Quantity"))
                {
                }
                column(QuantityAccrual_Caption; Text002)
                {
                }
                column(UnitCostLCY_Caption; "Sales Line".FieldCaption("Sales Line"."Unit Cost (LCY)"))
                {
                }
                column(ShippedPercentiage_Caption; Text003)
                {
                }
                column(ErrorDescription_Caption; Text004)
                {
                }
                column(AccrualAmount_Caption; Text005)
                {
                }
                column(CreatedBy_Caption; Text006)
                {
                }
                column(CalculationText_Caption; Text007)
                {
                }

                trigger OnAfterGetRecord()
                var
                    lText001: label 'Pure overshipment order';
                begin
                    CalculationText := '';
                    ErrorDescription := '';
                    QtyAccrual := 0;
                    PctMainShip := 0;
                    PctOverShip := 0;
                    QtyMain := 0;
                    QtyShipMain := 0;

                    recSalesLine.SetRange("Document Type", "Sales Line"."Document Type");
                    recSalesLine.SetRange("Document No.", "Sales Line"."Document No.");
                    recSalesLine.SetFilter("Line No.", '<>%1', "Sales Line"."Line No.");
                    recSalesLine.SetRange("Overshipment Line No.", "Sales Line"."Line No.");
                    if recSalesLine.FindSet then begin
                        repeat
                            QtyMain += recSalesLine.Quantity;
                            QtyShipMain += recSalesLine."Quantity Shipped";
                        until recSalesLine.Next() = 0;

                        if QtyShipMain <> 0 then begin
                            PctMainShip := QtyShipMain / QtyMain;
                            PctOverShip := "Sales Line"."Quantity Shipped" / "Sales Line".Quantity;
                            if PctMainShip > PctOverShip then begin
                                QtyAccrual := "Sales Line"."Outstanding Quantity" * (PctMainShip - PctOverShip);
                                CalculationText := StrSubstNo('%1 := %2 * ((%3 / %4) - (%5 / %6))', ROUND(QtyAccrual), "Sales Line"."Outstanding Quantity", QtyShipMain, QtyMain, "Sales Line"."Quantity Shipped", "Sales Line".Quantity);
                                QtyAccrual := ROUND(QtyAccrual, 1, '>');
                            end else
                                CurrReport.Skip;
                        end else
                            CurrReport.Skip;
                    end else begin
                        recSalesLine2.SetRange("Document Type", "Sales Line"."Document Type");
                        recSalesLine2.SetRange("Document No.", "Sales Line"."Document No.");
                        recSalesLine2.SetFilter("Line No.", '<>%1', "Sales Line"."Line No.");
                        recSalesLine2.SetRange(Type, recSalesLine2.Type::Item);
                        recSalesLine2.SetRange("No.", "Sales Line"."No.");
                        if not recSalesLine2.FindFirst then begin
                            QtyAccrual := "Sales Line"."Outstanding Quantity";
                            CalculationText := lText001;
                        end else
                            ErrorDescription := StrSubstNo(Text001, "Sales Line"."Document No.", "Sales Line"."Line No.");
                    end;

                    if (ErrorDescription = '') and ("Sales Line"."Unit Cost (LCY)" = 0) then
                        ErrorDescription := StrSubstNo(Text008, "Sales Line".FieldCaption("Sales Line"."Unit Cost (LCY)"));

                    recSalesHead.Get("Sales Line"."Document Type", "Sales Line"."Document No.");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        Text001: label 'Relation is missing for overshipment line on sales order "%1" line no. "%2".';
        recSalesLine2: Record "Sales Line";
        QtyMain: Decimal;
        QtyShipMain: Decimal;
        PctMainShip: Decimal;
        PctOverShip: Decimal;
        QtyAccrual: Decimal;
        ErrorDescription: Text;
        Text002: label 'Quantity Accrual';
        Text003: label 'Percentage Shipped on Main Shipment';
        Text004: label 'Error Description';
        CalculationText: Text;
        AccrualAmount: Decimal;
        Text005: label 'Accrual Amount';
        Text006: label 'Created By';
        Text007: label 'Calculation';
        Text008: label '"%1" must not be blank.';
}
