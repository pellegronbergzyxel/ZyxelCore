Page 50249 "Sales Ord. Line with Overship."
{
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Order Line with Overshipment';
    Editable = false;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = where("Completely Shipped" = const(false));
    UsageCategory = ReportsandAnalysis;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("""Outstanding Quantity"" * ""Unit Cost (LCY)"""; Rec."Outstanding Quantity" * Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Outst. Unit Cost (LCY)';
                    DecimalPlaces = 5 : 2;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Show Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Sales Order";
                RunPageLink = "Document Type" = field("Document Type"),
                              "No." = field("Document No.");
            }
        }
    }
}
