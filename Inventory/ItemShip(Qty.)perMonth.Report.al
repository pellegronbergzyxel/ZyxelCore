Report 50052 "Item Ship (Qty.) per Month"
{
    // 001. 05-07-21 ZY-LD 2021070210000247 - "Sales (Qty.)" is changed to "Shipment (Qty.)" on request from Ralf.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Ship (Qty.) per Month.rdlc';

    Caption = 'Item Ship (Qty.) per Month';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            CalcFields = "Shipment (Qty.)";
            RequestFilterFields = "No.", Inactive, "Location Filter", "Date Filter";
            column(ItemNo; Item."No.")
            {
            }
            column(ItemDescription; Item.Description)
            {
            }
            column(Caption1; CaptionArray[1])
            {
            }
            column(Caption2; CaptionArray[2])
            {
            }
            column(Caption3; CaptionArray[3])
            {
            }
            column(Caption4; CaptionArray[4])
            {
            }
            column(Caption5; CaptionArray[5])
            {
            }
            column(Caption6; CaptionArray[6])
            {
            }
            column(Caption7; CaptionArray[7])
            {
            }
            column(Caption8; CaptionArray[8])
            {
            }
            column(Caption9; CaptionArray[9])
            {
            }
            column(Caption10; CaptionArray[10])
            {
            }
            column(Caption11; CaptionArray[11])
            {
            }
            column(Caption12; CaptionArray[12])
            {
            }
            column(Value1; QtyArray[1])
            {
            }
            column(Value2; QtyArray[2])
            {
            }
            column(Value3; QtyArray[3])
            {
            }
            column(Value4; QtyArray[4])
            {
            }
            column(Value5; QtyArray[5])
            {
            }
            column(Value6; QtyArray[6])
            {
            }
            column(Value7; QtyArray[7])
            {
            }
            column(Value8; QtyArray[8])
            {
            }
            column(Value9; QtyArray[9])
            {
            }
            column(Value10; QtyArray[10])
            {
            }
            column(Value11; QtyArray[11])
            {
            }
            column(Value12; QtyArray[12])
            {
            }

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow(Item."No.", 0, true);

                ShowOnlyIfQty := false;
                i := 0;
                if recDate.FindSet then
                    repeat
                        i += 1;
                        Item.SetRange(Item."Date Filter", recDate."Period Start", recDate."Period End");
                        Item.CalcFields(Item."Shipment (Qty.)");
                        QtyArray[i] := Item."Shipment (Qty.)";
                        if Item."Shipment (Qty.)" <> 0 then
                            ShowOnlyIfQty := true;
                    until recDate.Next() = 0;

                if not ShowOnlyIfQty then
                    CurrReport.Skip;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                recDate.SetRange("Period Type", recDate."period type"::Month);
                Item.Copyfilter(Item."Date Filter", recDate."Period Start");
                if recDate.FindSet then
                    repeat
                        i += 1;
                        CaptionArray[i] :=
                          StrSubstNo('%1. %2',
                            ZGT.GetMonthText(Date2dmy(recDate."Period Start", 2), false, false, true),
                            Date2dmy(recDate."Period Start", 3));
                    until recDate.Next() = 0;

                ZGT.OpenProgressWindow('', Item.Count);
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
                    field(ShowOnlyIfQty; ShowOnlyIfQty)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Only Items with Quantity';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            Item.SetRange(Inactive, false);
        end;
    }

    labels
    {
    }

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        recDate: Record Date;
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        Col: Integer;
        CaptionArray: array[12] of Text;
        QtyArray: array[12] of Integer;
        i: Integer;
        ShowOnlyIfQty: Boolean;
}
