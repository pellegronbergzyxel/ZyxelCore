Page 50011 "Customer/Item Relation"
{
    Caption = 'Customer/Item Relation';
    DataCaptionFields = Type, "Customer Name";
    PageType = List;
    SourceTable = "Customer/Item Relation";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = ShipToCodeEnabled;
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

    trigger OnOpenPage()
    begin
        ShipToCodeEnabled := Rec.Type = Rec.Type::"Seperate Delivery Document";
    end;

    var
        ShipToCodeEnabled: Boolean;
}
