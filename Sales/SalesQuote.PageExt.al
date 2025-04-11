pageextension 50125 SalesQuoteZX extends "Sales Quote"
{
    layout
    {
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Opportunity No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Requested Delivery Date")
        {
            field(GeneralLocationCode; Rec."Location Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Backlog Comment"; Rec."Backlog Comment")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        modify(Control49)
        {
            Caption = 'Comments - Header';
        }
        addfirst(FactBoxes)
        {
            part(Control51; "Sales Comment Line FactBox")
            {
                Caption = 'Comments - Line';
                Provider = SalesLines;
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("Document No."),
                              "Document Line No." = field("Line No.");
            }
        }
    }
}