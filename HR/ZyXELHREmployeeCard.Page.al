Page 50242 "ZyXEL HR Employee Card"
{
    // 001. 30-04-18 ZY-LD 2018042610000161 - New fields.
    // 002. 27-07-18 ZY-LD 2018062910000259 - New field.
    // 003. 17-10-18 ZY-LD 2018101710000068 - Setup No. Series.
    // 004. 26-06-19 ZY-LD 2019062410000088 - New field.
    // 005. 06-09-09 ZY-LD 000 - Calculate Job Title and Manager Name.
    // 006. 27-09-19 ZY-LD 2019092710000059 - Documents is filtered on Employee No.
    // 007. 17-10-19 ZY-LD 2019101610000157 - New tab "Reporting" is added.

    Caption = 'Employee Card';
    PageType = Card;
    SourceTable = "ZyXEL Employee";

    layout
    {
        area(content)
        {
            group("Employee Details")
            {
                Caption = 'Employee Details';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        //>> 17-10-18 ZY-LD 003
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                        //<< 17-10-18 ZY-LD 003
                    end;
                }
                field("Cost Type"; Rec."Cost Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Company Option"; Rec."Company Option")
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
                field("Previous Employment Date"; Rec."Previous Employment Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(LengthOfService; LengthOfService)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Length Of Service';
                    DecimalPlaces = 0 : 0;
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

                    trigger OnValidate()
                    begin
                        Age := HRMod.CalculateSinceToday(Rec."Birth Date");
                    end;
                }
                field(Age; Age)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Age';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
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
                group(Banking)
                {
                    Caption = 'Banking';
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
                }
            }
            group("Contact Details")
            {
                Caption = 'Contact Details';
                group(Home)
                {
                    Caption = 'Home';
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
                    field("E-Mail"; Rec."E-Mail")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                    }
                }
                group(Work)
                {
                    Caption = 'Work';
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
                    field("Skype Address"; Rec."Skype Address")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Skype';
                    }
                    field("Work Mobile No"; Rec."Work Mobile No")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Emergency Contact")
                {
                    Caption = 'Emergency Contact';
                    field("Emergency Contact Name"; Rec."Emergency Contact Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact Name';
                    }
                    field("Emergency Contact Relationship"; Rec."Emergency Contact Relationship")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact Relationship';
                    }
                    field("Emergency Contact Tel No 1"; Rec."Emergency Contact Tel No 1")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact Tel No 1';
                    }
                    field("Emergency Contact Tel No 2"; Rec."Emergency Contact Tel No 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact Tel No 2';
                    }
                }
            }
            part(Control126; "HR Role History Subform")
            {
                Caption = 'Role / Job Details';
                Description = 'Role / Job Details';
                ShowFilter = true;
                SubPageLink = "Employee No." = field("No.");
                SubPageView = sorting(UID, "Employee No.", "Start Date")
                              order(descending);
                UpdatePropagation = Both;
            }
            group(Benefits)
            {
                Caption = 'Benefits';
                group("Pension Scheme")
                {
                    Caption = 'Pension Scheme';
                    field("Pension Scheme Member"; Rec."Pension Scheme")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pension Scheme Member';
                    }
                    field("Pension Scheme Provider"; Rec."Pension Scheme Provider")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("PEN Employee Contr. (%)"; Rec."PEN Employee Contr. (%)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("PEN Employee Contr. (Amount)"; Rec."PEN Employee Contr. (Amount)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("PEN Employer Contr. (%)"; Rec."PEN Employer Contr. (%)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("PEN Employer Contr. (Amount)"; Rec."PEN Employer Contr. (Amount)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("PEN Currency Code"; Rec."PEN Currency Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Code';
                    }
                }
                group("Life Insurance")
                {
                    Caption = 'Life Insurance';
                    field("Life Assurance"; Rec."Life Assurance")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Life Insurance Provider"; Rec."Life Insurance Provider")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LI Employee Contr. (%)"; Rec."LI Employee Contr. (%)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LI Employee Contr. (Amount)"; Rec."LI Employee Contr. (Amount)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LI Employer Contr. (%)"; Rec."LI Employer Contr. (%)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LI Employer Contr. (Amount)"; Rec."LI Employer Contr. (Amount)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LI Currency Code"; Rec."LI Currency Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Code';
                    }
                }
                group(Healthcare)
                {
                    Caption = 'Healthcare';
                    field("Healthcare Scheme"; Rec."Healthcare Scheme")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Healthcare Provider"; Rec."Healthcare Provider")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("HC Employee Contr. (%)"; Rec."HC Employee Contr. (%)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("HC Employee Contr. (Amount)"; Rec."HC Employee Contr. (Amount)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("HC Employer Contr. (%)"; Rec."HC Employer Contr. (%)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("HC Employer Contr. (Amount)"; Rec."HC Employer Contr. (Amount)")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("HC Currency Code"; Rec."HC Currency Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Code';
                    }
                }
                group("Home Internet")
                {
                    Caption = 'Home Internet';
                    field(Control108; Rec."Home Internet")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Home Internet Amount"; Rec."Home Internet Amount")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Home Internet Amount Currency"; Rec."Home Internet Amount Currency")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Code';
                    }
                }
                group("Mobile Phone")
                {
                    Caption = 'Mobile Phone';
                    field(Control107; Rec."Mobile Phone")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Date when fund allocated"; Rec."Date when fund allocated")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Amount allocated"; Rec."Amount allocated")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Amount Allocated Currency Code"; Rec."Amount Allocated Currency Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Code';
                    }
                }
                group("Credit Card")
                {
                    Caption = 'Credit Card';
                    field(Control163; Rec."Credit Card")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Card Number"; Rec."Card Number")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Date given"; Rec."Date given")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Expiry Date"; Rec."Expiry Date")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Credit Limit"; Rec."Credit Limit")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Credit Card Currency Code"; Rec."Credit Card Currency Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Code';
                    }
                }
                group("Other Benefits")
                {
                    Caption = 'Other Benefits';
                    field("Housing Allowance"; Rec."Housing Allowance")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Social Cost"; Rec."Social Cost")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Medical Insurance"; Rec."Medical Insurance")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Holiday Entitlement"; Rec."Holiday Entitlement")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Sickness Pay"; Rec."Sickness Pay")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Laptop; Rec.Laptop)
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Other Benefits Amount"; Rec."Other Benefits Amount")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Control103; Rec."Other Benefits")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                part(Control181; "HR Other Benefits Subform")
                {
                    Caption = 'Other Benefits';
                    SubPageLink = "Employee No." = field("No.");
                }
            }
            part(Absence; "HR Absence Subform")
            {
                Caption = 'Holiday/Absence';
                Description = 'Holiday/Absence';
                ShowFilter = true;
                SubPageLink = "Employee No." = field("No.");
                UpdatePropagation = Both;
            }
            part("Salary List"; "HR Salary Subform")
            {
                Caption = 'Salary';
                SubPageLink = "Employee No." = field("No.");
            }
            part(KPI; "HR Zyxel KPI Entry Subform")
            {
                Caption = 'KPI';
                SubPageLink = Type = const(KPI),
                              "Employee No." = field("No.");
            }
            part(Control192; "HR Zyxel Add. Pay. Subform")
            {
                Caption = 'Additional Payment';
                SubPageLink = Type = const("Additional Payment"),
                              "Employee No." = field("No.");
            }
            part("Disciplinary List"; "HR Disciplinary Subform")
            {
                Caption = 'Disciplinary';
                SubPageLink = "Employee No." = field("No.");
            }
            group("Disciplinary Meeting")
            {
                Caption = 'Disciplinary Meeting';
                field("Disciplinary Meeting Date"; Rec."Disciplinary Meeting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Disciplinary Meeting Locations"; Rec."Disciplinary Meeting Locations")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Probation)
            {
                Caption = 'Probation';
                field("Probation Period (Months)"; Rec."Probation Period (Months)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Probation Period (Months)';
                    Enabled = ProbationEnabled;
                }
                field("Probation Review Meeting"; Rec."Probation Review Meeting")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = ProbationEnabled;
                }
                field("Probation Passed"; Rec."Probation Passed")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        Actions;
                    end;
                }
            }
            group(Termination)
            {
                Caption = 'Termination';
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Exit Interview"; Rec."Exit Interview")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Exit Interview';
                }
                field("Severence Pay"; Rec."Severence Pay")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Notice)
                {
                    Caption = 'Notice';
                    field("Date Notice Given"; Rec."Date Notice Given")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Notice Given To"; Rec."Notice Given To")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = true;
                    }
                    field("Notice Given To Name"; Rec."Notice Given To Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                    }
                    field("Notice Period by EE"; Rec."Notice Period by EE")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Notice Period by EE (Months)';
                    }
                    field("Notice to be given by ER"; Rec."Notice to be given by ER")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Notice to be given by ER (Months)';
                    }
                    field("Notice Period Comments"; Rec."Notice Period Comments")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Dates)
                {
                    Caption = 'Dates';
                    field("Leaving Date"; Rec."Leaving Date")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Last Physical Day Worked"; Rec."Last Physical Day Worked")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Garden Leave"; Rec."Garden Leave")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(Comments)
                {
                    Caption = 'Comments';
                    field("Leaving Comments"; Rec."Leaving Comments")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Other Comments"; Rec."Other Comments")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group("Supporting Documents")
            {
                Caption = 'Supporting Documents';
                field("Right to Work in Country"; Rec."Right to Work in Country")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Right To Process EE Data"; Rec."Right To Process EE Data")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Code of Conduct Signed"; Rec."Code of Conduct Signed")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Insight Profile Completed"; Rec."Insight Profile Completed")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Travel Insurance"; Rec."Travel Insurance")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pres. Skills Training Compl."; Rec."Pres. Skills Training Compl.")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(ID)
                {
                    Caption = 'ID';
                    field("ID Provided"; Rec."ID Provided")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("ID number"; Rec."ID number")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("ID Type"; Rec."ID Type")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Expiration Date of ID"; Rec."Expiration Date of ID")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group("Driving License")
                {
                    Caption = 'Driving License';
                    field("Driving License Checked"; Rec."Driving License Checked")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Driving License No"; Rec."Driving License No")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Driving License Expiry"; Rec."Driving License Expiry")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Driving License Copy Attached"; Rec."Driving License Copy Attached")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
                group(GDPR)
                {
                    Caption = 'GDPR';
                    field("GDPR Training Completed"; Rec."GDPR Training Completed")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Training Completed';
                    }
                    field("GDPR Training Completed Date"; Rec."GDPR Training Completed Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Training Completed Date';
                    }
                    field("GDPR Consent Form Returned"; Rec."GDPR Consent Form Returned")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Consent Form Returned';
                    }
                    field("GDPR Consent Form Ret. Date"; Rec."GDPR Consent Form Ret. Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Consent Form Retudrned Date';
                    }
                    field("GDPR Consent Form Signed"; Rec."GDPR Consent Form Signed")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Consent Form Signed';
                    }
                    field("GDPR Consent Form Signed Date"; Rec."GDPR Consent Form Signed Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Consent Form Signed Date';
                    }
                    field("GDPR Consent Withdrawn"; Rec."GDPR Consent Withdrawn")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Consent Withdrawn';
                    }
                    field("GDPR Consent Withdrawn Date"; Rec."GDPR Consent Withdrawn Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Consent Withdrawn Date';
                    }
                }
            }
            group(Reporting)
            {
                Caption = 'Reporting';
                field("Exclude from Reports"; Rec."Exclude from Reports")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
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
                SubPageLink = "No." = field("No.");
            }
            part(AbsencePart; "HR Employee Abscense Fact Box")
            {
                Caption = 'Holiday/Sick';
                Editable = false;
                SubPageLink = "No." = field("No.");
            }
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
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
                action(Dimensions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(5200),
                                  "No." = field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
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
                action("&Confidential Information")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Confidential Information';
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
                separator(Action23)
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
                action("Co&nfidential Info. Overview")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Co&nfidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                }
                separator(Action61)
                {
                }
                action("Online Map")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Online Map';
                    Image = Map;
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
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.GetJobTitle;  // 06-09-09 ZY-LD 005
        Rec.GetManager;  // 06-09-09 ZY-LD 005
        if Rec.GetFilter(Rec."Date Filter History") <> '' then
            CurrPage.EmployeePart.Page.SetDateFilterHistory(Rec.GetRangemax(Rec."Date Filter History"));  // 06-09-09 ZY-LD 005
    end;

    trigger OnAfterGetRecord()
    begin

        Age := HRMod.CalculateSinceToday(Rec."Birth Date");
        LengthOfService := HRMod.CalculateSinceToday(Rec."Employment Date");
        CurrPage.Absence.Page.SetEmployee(Rec."No.");
    end;

    trigger OnInit()
    begin
        MapPointVisible := true;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
    begin
        if not MapMgt.TestSetup then
            MapPointVisible := false;

        Actions;
    end;

    var
        [InDataSet]
        MapPointVisible: Boolean;
        Age: Decimal;
        LengthOfService: Decimal;
        HRMod: Codeunit "ZyXEL HR Module";
        ProbationEnabled: Boolean;

    local procedure "Actions"()
    begin
        ProbationEnabled := not Rec."Probation Passed";
    end;
}
