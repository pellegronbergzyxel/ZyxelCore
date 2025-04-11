pageextension 50312 UsersZX extends Users
{
    layout
    {
        addafter("Authentication Email")
        {
            field("Expiry Date"; Rec."Expiry Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("recEmp.""Leaving Date"""; recEmp."Leaving Date")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employee Leaving Date';
            }
            field("Contact Email"; Rec."Contact Email")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        addafter("FA Journal Setup")
        {
            action("Print User Permissions")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print User Permissions';
                Image = "Report";
                RunObject = Report "Print Permissions";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //>> 03-07-19 ZY-LD 001
        if StrLen(Rec."Contact Email") <= 20 then
            if not recEmp.Get(Rec."Contact Email") then
                Clear(recEmp);
        //<< 03-07-19 ZY-LD 001
    end;

    trigger OnOpenPage()
    begin
        //>> 28-03-22 ZY-LD 002
        //Rec.SetFilter("Expiry Date", '%1|%2..', 0DT, CREATEDATETIME(WORKDATE, 0T));  // Set the filter manually on the page.
        //Rec.SetRange(State, Rec.State::Enabled);
        //<< 28-03-22 ZY-LD 002
    end;

    var
        recEmp: Record "ZyXEL Employee";
}
