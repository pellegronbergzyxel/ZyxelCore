XmlPort 50066 ItemBudgetEntries
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/Replicate';
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Item Budget Entry"; "Item Budget Entry")
            {
                MinOccurs = Zero;
                XmlName = 'ItemBudgetEntries';
                UseTemporary = true;
                fieldelement(EntryNo; "Item Budget Entry"."Entry No.")
                {
                }
                fieldelement(BudgetName; "Item Budget Entry"."Budget Name")
                {
                }
                fieldelement(Date; "Item Budget Entry".Date)
                {
                }
                fieldelement(ItemNo; "Item Budget Entry"."Item No.")
                {
                }
                fieldelement(SourceType; "Item Budget Entry"."Source Type")
                {
                }
                fieldelement(SourceNo; "Item Budget Entry"."Source No.")
                {
                }
                fieldelement(Quantity; "Item Budget Entry".Quantity)
                {
                }
                fieldelement(SalesAmount; "Item Budget Entry"."Sales Amount")
                {
                }
                fieldelement(DivisionCode; "Item Budget Entry"."Global Dimension 1 Code")
                {
                }
                fieldelement(DepartmentCode; "Item Budget Entry"."Global Dimension 2 Code")
                {
                }
                fieldelement(CountryCode; "Item Budget Entry"."Budget Dimension 1 Code")
                {
                }
                fieldelement(OutOfForecast; "Item Budget Entry"."Out of Forecast")
                {
                }
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


    procedure SetData(pItemBudgetEntry: Record "Item Budget Entry"): Boolean
    begin
        "Item Budget Entry" := pItemBudgetEntry;
        "Item Budget Entry".Insert;
        exit(true);
    end;


    procedure ReplicateData()
    var
        recItemBudgEntry: Record "Item Budget Entry";
    begin
        if "Item Budget Entry".FindSet then
            repeat
                recItemBudgEntry := "Item Budget Entry";
                recItemBudgEntry.Insert;
            until "Item Budget Entry".Next() = 0;
    end;
}
