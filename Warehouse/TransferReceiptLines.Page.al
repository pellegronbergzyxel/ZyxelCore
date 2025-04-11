page 50138 "Transfer Receipt Lines"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Posted Transfer Receipt Lines';
    PageType = List;
    SourceTable = "Transfer Receipt Line";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.") { }
                field("Transfer Order No."; Rec."Transfer Order No.") { }
                field("Receipt Date"; Rec."Receipt Date") { }
                field("Posting Date"; TransRcptHead."Posting Date") { }
                field("Transfer-from Code"; Rec."Transfer-from Code") { }
                field("Transfer-to Code"; Rec."Transfer-to Code") { }
                field("In-Transit Code"; Rec."In-Transit Code") { }
                field("Item No."; Rec."Item No.") { }
                field(Description; Rec.Description) { }
                field(Quantity; Rec.Quantity) { }
                field("Unit of Measure"; Rec."Unit of Measure") { }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    Visible = false;
                }
            }
        }
    }
    var
        TransRcptHead: Record "Transfer Receipt Header";

    trigger OnAfterGetRecord()
    begin
        TransRcptHead.get(Rec."Document No.");
    end;
}
