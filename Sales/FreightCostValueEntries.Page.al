Page 50124 "Freight Cost Value Entries"
{
    Caption = 'Freight Cost Value Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Freight Cost Value Entry";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Value Entry No."; Rec."Value Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Cost Value Entry No."; Rec."Cost Value Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Charge (Item)"; Rec."Charge (Item)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Freight Posted to G/L"; Rec."Freight Posted to G/L")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
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
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    recValueEntry.Get(Rec."Value Entry No.");
                    Navigate.SetDoc(recValueEntry."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    Rec.CalcFields(Rec."Document No.");
                    FreightCostMgt.PerformManualPost(Rec."Document No.");
                end;
            }
        }
    }

    var
        recValueEntry: Record "Value Entry";
        FreightCostMgt: Codeunit "Freight Cost Management";
        Navigate: Page Navigate;
}
