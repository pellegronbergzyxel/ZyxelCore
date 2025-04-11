Page 50266 "Whse. Item Ledger Entry"
{
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Item Ledger Entry";
    SourceTableView = sorting("Item No.", Date)
                      order(descending);

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
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Quanty Type"; Rec."Quanty Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control10; Links)
            {
                Visible = false;
            }
            systempart(Control9; Notes)
            {
                Visible = false;
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
