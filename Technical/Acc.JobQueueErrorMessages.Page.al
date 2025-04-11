Page 50153 "Acc. Job Queue Error Messages"
{
    Caption = 'Accepted Job Queue Error Messages';
    PageType = List;
    SourceTable = "Acc. Job Queue Error Message";
    SourceTableView = sorting(Message);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Message; Rec.Message)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
