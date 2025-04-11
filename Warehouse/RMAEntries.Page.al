Page 50343 "RMA Entries"
{
    ApplicationArea = Basic, Suite;
    Caption = 'RMA Entries';
    Editable = false;
    PageType = List;
    SourceTable = "LMR Stock";
    SourceTableView = order(descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Time Stamp"; Rec."Time Stamp")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("ZyXEL Item"; Rec."ZyXEL Item")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Bin; Rec.Bin)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then;
    end;
}
