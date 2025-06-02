pageextension 50227 ICInboxPurchaseDocZX extends "IC Inbox Purchase Doc."
{
    layout
    {
        addafter("Pay-to Vendor No.")
        {
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = Basic, Suite;
            }
            group(Control19)
            {
            }
        }
        addafter("Currency Code")
        {
            field("Currency Code Sales Doc SUB"; Rec."Currency Code Sales Doc SUB")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addfirst(Shipping)
        {
            field("Ship-to Contact"; Rec."Ship-to Contact")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Ship-to Name")
        {
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Ship-to Address")
        {
            field("Ship-to Address 2"; Rec."Ship-to Address 2")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Ship-to City")
        {
            field("Ship-to County"; Rec."Ship-to County")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to Post Code"; Rec."Ship-to Post Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to E-Mail"; Rec."Ship-to E-Mail")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to VAT"; Rec."Ship-to VAT")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = Basic, Suite;
                Editable = true;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Currency Code Sales Doc SUB" = '' then
            if Cust.Get(Rec."Sell-to Customer No.") then
                Rec."Currency Code Sales Doc SUB" := Cust."Currency Code";
    end;

    var
        Cust: Record Customer;
        Text001: Label 'Customer No. %1 was now found.';
}
