Page 50033 "Item/Customer Relation"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Item/Customer Relation';
    DataCaptionFields = "Customer No.", "Item Name";
    PageType = List;
    SourceTable = "Customer/Item Relation";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }
}
