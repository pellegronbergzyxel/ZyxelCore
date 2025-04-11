tableextension 50168 DimensionCodeBufferZX extends "Dimension Code Buffer"
{
    fields
    {
        field(50000; "Cost Amount"; Decimal)
        {
            CalcFormula = sum("Analysis View Entry"."Cost Amount" where("Analysis View Code" = const(''),
                                                                        "Dimension 1 Value Code" = field("Dimension 1 Value Filter"),
                                                                        "Dimension 2 Value Code" = field("Dimension 2 Value Filter"),
                                                                        "Dimension 3 Value Code" = field("Dimension 3 Value Filter"),
                                                                        "Dimension 4 Value Code" = field("Dimension 4 Value Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50001; "Qty YTD"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50002; "Amount YTD"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50003; "Avg Sales Out 3 Months"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50004; "Avg Sales In 3 Months"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50005; "Budget Amount"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50006; "Distributor Stock"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50007; "Sales Out"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50008; "Sales In"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50009; Actual; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50010; "Customer Filter"; Code[20])
        {
            Description = 'PAB 1.0';
        }
        field(50012; EU2Inventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field(Code),
                                                                 "Location Code" = const('EU2')));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50013; EU2SOQty; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                           Type = const(Item),
                                                                           "No." = field(Code),
                                                                           "Location Code" = const('EU2')));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50014; EU2Available; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50015; UPSInventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field(Code),
                                                                 "Location Code" = const('UPS')));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50016; UPSSOQty; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                           Type = const(Item),
                                                                           "No." = field(Code),
                                                                           "Location Code" = const('UPS')));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50017; UPSAvailable; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50018; "Sales In 3 Months"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50019; "Sales Out 3 Months"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50020; "Sales In 6 Months"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50021; "Sales Out 6 Months"; Decimal)
        {
            Description = 'PAB 1.0';
        }
    }
}
