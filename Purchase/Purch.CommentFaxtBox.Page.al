Page 50352 "Purch. Comment FaxtBox"
{
    Caption = 'Purch. Comment FaxtBox';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Purch. Comment Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Co&mments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Purch. Comment Sheet";
                RunPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No."),
                              "Document Line No." = const(0);
            }
        }
    }
}
