Page 50241 "Zyxel HR Employee List"
{
    // 001. 21-02-18 ZY-LD 2018021610000058 - New field.
    // 002. 23-02-18 ZY-LD 2018022310000133 - Calculating birthdate age.
    // 003. 06-09-19 ZY-LD 2019051010000132 - Calculate "Job Title".

    Caption = 'Employee List';
    CardPageID = "ZyXEL HR Employee Card";
    Editable = false;
    PageType = List;
    SourceTable = "ZyXEL Employee";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Active employee"; Rec."Active employee")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("Cost Type"; Rec."Cost Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Office Location';
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        LengthOfService := HRMod.CalculateSinceToday(Rec."Employment Date");
                    end;
                }
                field(LengthOfService; LengthOfService)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Length Of Service';
                    Editable = false;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Middle Name/Initials';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Initials; Rec.Initials)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Known As"; Rec."Known As")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(CurrentAge; CurrentAge)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Current Age';
                    Editable = false;
                }
                field(BirthdateAge; BirthdateAge)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Birthdate Age';
                }
                field("Place of Birth"; Rec."Place of Birth")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Social Security No."; Rec."Social Security No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = Basic, Suite;
                    OptionCaption = 'Single,Married,Partner,Divorced,Widowed,Common Law Marriage,Cohabiting';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Name of Account"; Rec."Name of Account")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sort Code"; Rec."Sort Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pay Date"; Rec."Pay Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Address 3"; Rec."Address 3")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Address 3';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("Work Mobile No"; Rec."Work Mobile No")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                }
                field("ZyXEL Email Address"; Rec."ZyXEL Email Address")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'E-mail Address';
                    ExtendedDatatype = EMail;
                    Importance = Promoted;
                }
                field("ZyXEL Telephone No."; Rec."ZyXEL Telephone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Phone No.';
                    ExtendedDatatype = PhoneNo;
                    Importance = Standard;
                }
                field("ZyXEL Fax No."; Rec."ZyXEL Fax No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Fax No.';
                    ExtendedDatatype = PhoneNo;
                    Importance = Promoted;
                }
                field("Division Code Filter"; Rec."Division Code Filter")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("No of Salary Lines in Period"; Rec."No of Salary Lines in Period")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("No of Salary Lines"; Rec."No of Salary Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("No of Role_Job Details"; Rec."No of Role_Job Details")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Holiday Entitlement"; Rec."Holiday Entitlement")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Leaving Date"; Rec."Leaving Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Manager Fullname"; Rec."Manager Fullname")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Full Time Hours Per Week"; Rec."Full Time Hours Per Week")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Pres. Skills Training Compl."; Rec."Pres. Skills Training Compl.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Emergency Contact Name"; Rec."Emergency Contact Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Emergency Contact Relationship"; Rec."Emergency Contact Relationship")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Emergency Contact Tel No 1"; Rec."Emergency Contact Tel No 1")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Emergency Contact Tel No 2"; Rec."Emergency Contact Tel No 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Picture; "HR Employee Picture")
            {
                Caption = 'Picture';
                SubPageLink = "No." = field("No.");
            }
            part(EmployeePart; "HR Employee Fact Box")
            {
                Caption = 'Employee';
                Editable = false;
                ShowFilter = false;
                SubPageLink = "No." = field("No."),
                              "Date Filter History" = field("Date Filter History");
            }
            part(AbsencePart; "HR Employee Abscense Fact Box")
            {
                Caption = 'Holiday/Sick';
                Editable = false;
                SubPageLink = "No." = field("No.");
            }
            part(Salary; "HR Salary FactBox")
            {
                Caption = 'Salary';
                SubPageLink = "Employee No." = field("No.");
            }
            systempart(Control5; Links)
            {
                Visible = true;
            }
            systempart(Control3; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                Image = Employee;
                action("Co&mments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = const("Human Resources Comment Table Name"::"ZyXEL Employee"),
                                  "No." = field("No.");
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = const(5200),
                                      "No." = field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;

                        trigger OnAction()
                        var
                            Employee: Record Employee;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Employee);
                            DefaultDimMultiple.SetMultiEmployee(Employee);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                action("&Picture")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = field("No.");
                }
                action("&Alternative Addresses")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Alternative Addresses';
                    Image = Addresses;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No." = field("No.");
                }
                action("&Relatives")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Relatives';
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = field("No.");
                }
                action("Mi&sc. Article Information")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Mi&sc. Article Information';
                    Image = Filed;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = field("No.");
                }
                action("Co&nfidential Information")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Co&nfidential Information';
                    Image = Lock;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = field("No.");
                }
                action("Q&ualifications")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Q&ualifications';
                    Image = Certificate;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = field("No.");
                }
                action("A&bsences")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'A&bsences';
                    Image = Absence;
                    RunObject = Page "Employee Absences";
                    RunPageLink = "Employee No." = field("No.");
                }
                separator(Action51)
                {
                }
                action("Absences by Ca&tegories")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Absences by Ca&tegories';
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = field("No."),
                                  "Employee No. Filter" = field("No.");
                }
                action("Misc. Articles &Overview")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Misc. Articles &Overview';
                    Image = FiledOverview;
                    RunObject = Page "Misc. Articles Overview";
                }
                action("Con&fidential Info. Overview")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Con&fidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field("No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(50109));
                }
            }
        }
        area(processing)
        {
            action("Import KPI / Bonus")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import KPI / Bonus';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
        }
        area(reporting)
        {
            action("Export to Excel")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export to Excel';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"Export Zyxel Employee", true, false, Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.GetJobTitle;  // 06-09-09 ZY-LD 003
        Rec.GetManager;  // 06-09-09 ZY-LD 003
        CurrPage.EmployeePart.Page.SetDateFilterHistory(Rec.GetRangemax(Rec."Date Filter History"));  // 06-09-09 ZY-LD 003
    end;

    trigger OnAfterGetRecord()
    var
        BirthDate: Date;
    begin
        //Manager := HRMod.Manager(Rec."No.");  // 06-09-09 ZY-LD 003
        //JobTitle := HRMod.JobTitle(Rec."No.");  // 06-09-09 ZY-LD 003
        CurrentAge := HRMod.CalculateSinceToday(Rec."Birth Date");
        BirthdateAge := HRMod.CalculateBirthdate(CurrentAge, Rec."Birth Date");  // 23-02-18 ZY-LD 002
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Rec."Date Filter History", '..%1', WorkDate);
    end;

    var
        LengthOfService: Integer;
        HRMod: Codeunit "ZyXEL HR Module";
        CurrentAge: Integer;
        BirthdateAge: Integer;
        recDate: Record Date;
}
