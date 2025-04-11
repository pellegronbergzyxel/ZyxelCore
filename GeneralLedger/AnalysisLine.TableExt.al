tableextension 50228 AnalysisLineZX extends "Analysis Line"
{
    fields
    {
        modify("Item Budget Filter")
        {
            Caption = 'Forecast Filter';
        }
        field(50001; "Item Category Filter"; Code[10])
        {
            Caption = 'Category 1 Filter';
            Description = '15-51643';
            FieldClass = FlowFilter;
            TableRelation = "Item Category";
        }
        field(50002; "Serial Code Filter"; Code[50])
        {
            Caption = 'Category 3 Filter';
            Description = '15-51643';
            FieldClass = FlowFilter;
        }
    }
}
