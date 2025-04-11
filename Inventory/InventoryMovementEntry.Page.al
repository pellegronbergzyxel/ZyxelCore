Page 50082 "Inventory Movement Entry"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Inventory Movement Entry';
    Editable = false;
    PageType = List;
    SourceTable = "Inventory Movement Entry";
    SourceTableView = order(descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Max. Aging Code"; Rec."Max. Aging Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Inventory Movements")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Inventory Movements';
                Image = Process;

                trigger OnAction()
                begin
                    UpdateInventoryMovement.Run;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then;
    end;

    var
        UpdateInventoryMovement: Codeunit "Update Inventory Movement";
}
