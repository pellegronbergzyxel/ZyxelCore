pageextension 50213 DimensionSelectionZX extends "Dimension Selection"
{
    procedure SetForecastFilter()
    begin
        Rec.SetFilter(Code, 'Item|Customer');
    end;
}
