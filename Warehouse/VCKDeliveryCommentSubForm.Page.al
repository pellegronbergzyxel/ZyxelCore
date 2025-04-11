Page 50079 "VCK Delivery Comment Sub Form"
{
    PageType = ListPart;
    SourceTable = "VCK Delivery Note Comments";

    layout
    {
        area(content)
        {
            field("Delivery Comment 1"; Rec."Delivery Comment 1")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Delivery Comment 2"; Rec."Delivery Comment 2")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Delivery Comment 3"; Rec."Delivery Comment 3")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Delivery Comment 4"; Rec."Delivery Comment 4")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Delivery Comment 5"; Rec."Delivery Comment 5")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Delivery Comment 6"; Rec."Delivery Comment 6")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Delivery Comment 7"; Rec."Delivery Comment 7")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Delivery Comment 8"; Rec."Delivery Comment 8")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Delivery Comment 9"; Rec."Delivery Comment 9")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Delivery Comment 10"; Rec."Delivery Comment 10")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
    }

    var
        Text001: label 'You cannot change the Delivery Note text once the Document has been released.';
        Enabled: Boolean;


    procedure SetEnabled(IsEnabled: Boolean)
    begin
        Enabled := IsEnabled;
    end;
}
