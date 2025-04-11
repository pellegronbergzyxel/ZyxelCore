Page 50281 "HR Salary FactBox"
{
    // 001. 21-02-18 ZY-LD 2018021610000058 - Created.

    Caption = 'Salary Details';
    Editable = false;
    PageType = ListPart;
    SourceTable = "HR Salary Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Valid From"; Rec."Valid From")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Valid To"; Rec."Valid To")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Base Salary P.A."; Rec."Base Salary P.A.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Commission Pay P.A."; Rec."Commission Pay P.A.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Car Allowance P.A."; Rec."Car Allowance P.A.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}
