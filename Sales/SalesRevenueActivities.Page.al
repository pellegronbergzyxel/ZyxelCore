Page 50186 "Sales Revenue Activities"
{
    PageType = CardPart;
    SourceTable = "Finance Cue";

    layout
    {
        area(content)
        {
            field(Revenue; Rec.Revenue)
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = STRSUBSTNO(Text001, WORKDATE);
            }
            field("Revenue 2"; Rec."Revenue 2")
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = STRSUBSTNO(Text001, WORKDATE - 1);
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Rec."Date Filter Revenue", WorkDate);
        Rec.SetRange(Rec."Date Filter Revenue 2", WorkDate - 1);
    end;

    var
        Text001: label 'Gross Sales: %1';
}
