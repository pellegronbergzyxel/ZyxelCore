tableextension 50230 ItemBudgetEntryZX extends "Item Budget Entry"
{
    fields
    {
        modify("Source Type")
        {
            trigger OnAfterValidate()
            begin
                if "Source Type" <> xRec."Source Type" then
                    Validate("Source No.", xRec."Source No.");
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                recItemBudgetEntry2: Record "Item Budget Entry";
            begin
                //15-51643 -
                if "Sales Amount Item" = 0 then begin
                    recItemBudgetEntry2.SetFilter("Budget Name", "Budget Name");
                    recItemBudgetEntry2.SetRange(Date, Date);
                    recItemBudgetEntry2.SetFilter("Item No.", "Item No.");
                    recItemBudgetEntry2.SetFilter("Global Dimension 1 Code", "Global Dimension 1 Code");
                    recItemBudgetEntry2.SetFilter("Budget Dimension 1 Code", "Budget Dimension 1 Code");
                    if recItemBudgetEntry2.FindFirst() then
                        "Sales Amount Item" := recItemBudgetEntry2."Sales Amount Item";
                end;
                if "Cost Amount Item" > 0 then begin
                    "Cost Amount" := "Cost Amount Item" * Quantity;
                end;
                if "Sales Amount Item" > 0 then begin
                    "Sales Amount" := "Sales Amount Item" * Quantity;
                end;
                //15-51643 +
            end;
        }
        field(50000; "Cost Amount Item"; Decimal)
        {
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                if Rec."Cost Amount Item" > 0 then begin
                    Rec."Cost Amount" := Rec."Cost Amount Item" * Rec.Quantity;
                end;
            end;
        }
        field(50001; "Sales Amount Item"; Decimal)
        {
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                if Rec."Sales Amount Item" > 0 then begin
                    Rec."Sales Amount" := Rec."Sales Amount Item" * Rec.Quantity;
                end;
            end;
        }
        field(50003; "Item Category Code Filter"; Code[20])
        {
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
            TableRelation = Item."Item Category Code";
            ValidateTableRelation = false;
        }
        field(50005; "Business Unit Filter"; Code[20])
        {
            Description = 'PAB 1.0';
            FieldClass = FlowFilter;
            TableRelation = Item."Business Unit";
            ValidateTableRelation = false;
        }
        field(50006; Projected; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50007; "Projection Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50008; Margin; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(50009; Actual; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50010; "Modification Date"; Date)
        {
            Description = 'PAB 1.0';
        }
        field(50011; Opportunity; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50012; "SO Number"; Code[20])
        {
        }
        field(50013; "SO Line Number"; Integer)
        {
        }
        field(50014; BizType_Account; Text[250])
        {
            Description = 'data from OLAP';
        }
        field(50015; "Out of Forecast"; Boolean)
        {
            Description = 'PAB 1.0';
        }
    }

    keys
    {
        key(Key50000; "Budget Name", Date)
        {
        }
    }

    trigger OnModify()
    begin
        "Modification Date" := TODAY();
    end;
}
