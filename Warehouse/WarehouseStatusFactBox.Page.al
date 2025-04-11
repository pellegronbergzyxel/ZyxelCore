Page 50342 "Warehouse Status FactBox"
{
    Caption = 'Warehouse Status FactBox';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Warehouse Status"; Rec."Warehouse Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Delivery Document No."; Rec."Delivery Document No.")
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
            action("Show Delivery Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Delivery Document';
                Image = Document;
                RunObject = Page "VCK Delivery Document";
                RunPageLink = "No." = field("Delivery Document No.");
            }
        }
    }
}
