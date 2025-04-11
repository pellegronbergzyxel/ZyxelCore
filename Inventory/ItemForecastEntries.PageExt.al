pageextension 50275 ItemBudgetEntriesZX extends "Item Budget Entries"
{
    Caption = 'Item Forecast Entries';
    Editable = false;
    layout
    {
        modify("Budget Name")
        {
            Visible = false;
        }
        modify(Description)
        {
            Visible = false;
        }
        modify("Source Type")
        {
            Visible = false;
        }
        modify("Source No.")
        {
            Caption = 'Customer';
        }
        modify("Cost Amount")
        {
            Visible = false;
        }
        modify("Entry No.")
        {
            Visible = false;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                //15-51643 -
                if Rec."Global Dimension 1 Code" = '' then
                    Error(Text001);
                if Rec."Budget Dimension 1 Code" = '' then
                    Error(Text002);
                //15-51643 +
            end;
        }
        addafter("Budget Name")
        {
            field("Modification Date"; Rec."Modification Date")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Date)
        {
            field(Opportunity; Rec.Opportunity)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Cost Amount")
        {
            field("Out of Forecast"; Rec."Out of Forecast")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sales Amount Item"; Rec."Sales Amount Item")
            {
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                begin
                    //15-51643 -
                    if Rec."Global Dimension 1 Code" = '' then
                        Error(Text003);
                    if Rec."Budget Dimension 1 Code" = '' then
                        Error(Text004);
                    //15-51643 +
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
        if not Rec.FindFirst() then;  // 19-11-20 ZY-LD 002
    end;

    var
        Text001: Label 'Warning: You cannot modify the Quantity as there is no Division set for this line.\ Please press the esc key to cancel this action.';
        Text002: Label 'Warning: You cannot modify the Quantity as there is no Country set for this line.\ Please press the esc key to cancel this action.';
        Text003: Label 'Warning: You cannot modify the Sales Amount Item as there is no Division set for this line.\ Please press the esc key to cancel this action.';
        Text004: Label 'Warning: You cannot modify the Sales Amount Item as there is no Country set for this line.\ Please press the esc key to cancel this action.';
}
