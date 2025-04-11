page 50119 "Move delivery document line"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Move delivery document line';
    PageType = Card;
    Editable = true;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    SourceTable = "VCK Delivery Document Line";



    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;

                }

                field("New Document No."; newDDLine."Document No.")
                {
                    ApplicationArea = all;
                    Editable = true;
                    Caption = 'New Document No.';
                }
                field("New Line No."; newDDLine."Line No.")
                {
                    ApplicationArea = all;
                    Editable = true;
                    Caption = 'New Line No.';
                }
                field("New Sales Order No."; newDDLine."Sales Order No.")
                {
                    ApplicationArea = all;
                    Editable = true;
                    Caption = 'New Sales Order No.';
                }
                field("New Sales Order Line No."; newDDLine."Sales Order Line No.")
                {
                    ApplicationArea = all;
                    Editable = true;
                    Caption = 'New Sales Order Line No.';

                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            Action(move)
            {
                Caption = 'Move to DD';
                ApplicationArea = all;
                Image = MoveToNextPeriod;
                trigger OnAction()
                begin
                    if (newDDLine."Document No." <> '') and
                    (newDDLine."Line No." <> 0) and
                    (newDDLine."Sales Order No." <> '') and
                    (newDDLine."Sales Order Line No." <> 0) then begin
                        if rec.Rename(newDDLine."Document No.", newDDLine."Line No.", newDDLine."Sales Order No.", newDDLine."Sales Order Line No.") then
                            CurrPage.Close();
                    end;


                end;
            }
        }
    }
    var
        newDDLine: Record "VCK Delivery Document Line" temporary;

}
