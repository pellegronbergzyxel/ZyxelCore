tableextension 50219 ItemStatisticsBufferZX extends "Item Statistics Buffer"
{
    fields
    {
        field(50000; "Item Category Code Filter"; Code[250])
        {
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
            TableRelation = Item."Item Category Code";
            ValidateTableRelation = false;
        }
        field(50002; "Business Unit Filter"; Code[250])
        {
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
            TableRelation = Item."Business Unit";
            ValidateTableRelation = false;
        }
        field(50003; "Serial Code Filter"; Code[250])
        {
            Description = 'PAB 1.0';
        }
        field(50004; "Item Sales Amount"; Decimal)
        {
            CalcFormula = average("Item Budget Entry"."Sales Amount Item" where("Analysis Area" = field("Analysis Area Filter"),
                                                                                "Budget Name" = field("Budget Filter"),
                                                                                "Item No." = field("Item Filter"),
                                                                                Date = field("Date Filter"),
                                                                                "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Budget Dimension 1 Code" = field("Dimension 1 Filter"),
                                                                                "Budget Dimension 2 Code" = field("Dimension 2 Filter"),
                                                                                "Budget Dimension 3 Code" = field("Dimension 3 Filter"),
                                                                                "Source Type" = field("Source Type Filter"),
                                                                                "Source No." = field("Source No. Filter"),
                                                                                "Location Code" = field("Location Filter"),
                                                                                "Item Category Code Filter" = field("Item Category Code Filter"),
                                                                                "Business Unit Filter" = field("Business Unit Filter")));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(50005; Actual; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50006; "Exclude Country Filter"; Code[250])
        {
            Description = 'PAB 1.0';
        }
        field(50007; Opportunity; Boolean)
        {
            CalcFormula = lookup("Item Budget Entry".Opportunity where("Analysis Area" = field("Analysis Area Filter"),
                                                                       "Budget Name" = field("Budget Filter"),
                                                                       "Item No." = field("Item Filter"),
                                                                       Date = field("Date Filter"),
                                                                       "Global Dimension 1 Code" = field(filter("Global Dimension 1 Filter")),
                                                                       "Global Dimension 2 Code" = field(filter("Global Dimension 2 Filter")),
                                                                       "Budget Dimension 1 Code" = field(filter("Dimension 1 Filter")),
                                                                       "Budget Dimension 2 Code" = field(filter("Dimension 2 Filter")),
                                                                       "Budget Dimension 3 Code" = field(filter("Dimension 3 Filter")),
                                                                       "Source Type" = field(filter("Source Type Filter")),
                                                                       "Source No." = field(filter("Source No. Filter")),
                                                                       "Location Code" = field(filter("Location Filter")),
                                                                       "Item Category Code Filter" = field(filter("Item Category Code Filter")),
                                                                       "Business Unit Filter" = field(filter("Business Unit Filter"))));
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
    }
}
