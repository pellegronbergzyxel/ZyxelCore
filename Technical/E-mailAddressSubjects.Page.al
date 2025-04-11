Page 50293 "E-mail Address Subjects"
{
    // 001. 14-05-18 ZY-LD 2018051410000154 - Created.
    // 002. 22-11-19 ZY-LD 2019112110000029 - New field.

    Caption = 'E-mail Address Subjects';
    PageType = List;
    SourceTable = "E-mail Address Subject";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;
    end;

    var
        PageEnable: Boolean;

    local procedure SetActions()
    var
        recEmailAdd: Record "E-mail address";
    begin
        recEmailAdd.Get(Rec."E-mail Address Code");
        PageEnable := not recEmailAdd.Replicated;
    end;
}
