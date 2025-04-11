Page 50202 "HR Employee Fact Box"
{
    // 001. 06-09-19 ZY-LD 2019051010000132 - Calculate "Job Title".

    Caption = ' Employee';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "ZyXEL Employee";

    layout
    {
        area(content)
        {
            group(Details)
            {
                Caption = 'Details';
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Full Name';
                    Editable = false;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Company';
                    Editable = false;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Title';
                    Editable = false;
                }
                field("Manager Fullname"; Rec."Manager Fullname")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Manager';
                    Editable = false;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Gender';
                    Editable = false;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Birth Date';
                    Editable = false;
                }
                field("HRMod.CalculateSinceToday(""Birth Date"")"; HRMod.CalculateSinceToday(Rec."Birth Date"))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Age';
                    Editable = false;
                }
                field("HRMod.CalculateSinceToday(""Employment Date"")"; HRMod.CalculateSinceToday(Rec."Employment Date"))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Service Length';
                    Editable = false;
                }
                field("ZyXEL Email Address"; Rec."ZyXEL Email Address")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'E-mail Address';
                    ExtendedDatatype = EMail;
                }
                field("ZyXEL Telephone No."; Rec."ZyXEL Telephone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Phone No.';
                    ExtendedDatatype = PhoneNo;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.GetJobTitle;  // 06-09-09 ZY-LD 001
        Rec.GetManager;  // 06-09-09 ZY-LD 001
    end;

    trigger OnAfterGetRecord()
    begin
        //>> 06-09-09 ZY-LD 001
        // recRoleHist.SetCurrentKey("Employee No.","Start Date");
        // recRoleHist.SETRANGE("Employee No.","No.");
        // recRoleHist.SETFILTER("Start Date",'..%1',"Date Filter History");
        // IF NOT recRoleHist.FINDLAST THEN
        //  CLEAR(recRoleHist);
        //<< 06-09-09 ZY-LD 001
    end;

    var
        recRoleHist: Record "HR Role History";
        HRMod: Codeunit "ZyXEL HR Module";


    procedure SetDateFilterHistory(DateFilterHistory: Date)
    begin
        Rec.SetFilter(Rec."Date Filter History", '..%1', DateFilterHistory);
        CurrPage.Update(false);
    end;
}
