XmlPort 50031 "HQ Forecast"
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/forecast';
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Item Budget Entry"; "Item Budget Entry")
            {
                XmlName = 'ItemBudgetEntry';
                UseTemporary = true;
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

                trigger OnBeforeInsertRecord()
                begin
                    EntryNo += 1;
                    "Item Budget Entry"."Entry No." := EntryNo;
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

    var
        EntryNo: Integer;


    procedure GetData(var pItemBudgetEntry: Record "Item Budget Entry" temporary)
    begin
        if "Item Budget Entry".FindSet then
            repeat
                pItemBudgetEntry := "Item Budget Entry";
                pItemBudgetEntry.Insert;
            until "Item Budget Entry".Next() = 0;
    end;
}
