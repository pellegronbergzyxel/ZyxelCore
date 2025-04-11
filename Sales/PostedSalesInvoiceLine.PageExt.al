pageextension 50315 "PostedSalesInvoiceLine" extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
            {
                ApplicationArea = All;
                Tooltip = 'Specifies the name of the Sell-to Customer of the Posted Sales Invoice';
            }
            field("Bill-to Country/Region"; Rec."Bill-to Country/Region")
            {
                ApplicationArea = All;
                Tooltip = 'Specifies the Country/Region Code of the Bill-to Customer of the Posted Sales Invoice';
            }
        }

        addlast(Control1)
        {
            field(Category1; Category1)
            {
                Caption = 'Category 1';
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(Category2; Category2)
            {
                Caption = 'Category 2';
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(Category3; Category3)
            {
                Caption = 'Category 3';
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Category1 := '';
        Category2 := '';
        Category3 := '';

        if Rec.Type = Rec.Type::Item then begin
            item.get(Rec."No.");
            Category1 := Item."Category 1 Code";
            Category2 := Item."Category 2 Code";
            Category3 := Item."Category 3 Code";
        end;
    end;

    trigger OnAfterGetCurrRecord()
    Begin
    End;

    var
        Item: Record Item;
        Category1: Code[50];
        Category2: Code[50];
        Category3: Code[50];
}
