page 50196 "Customs Brokers"
{
    Caption = 'Customs Brokers';
    PageType = List;
    SourceTable = "Customs Broker";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Code";Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Name;Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}
