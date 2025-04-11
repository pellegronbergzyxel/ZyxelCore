Page 50185 "HR Absence Subform"
{
    // 001. 25-01-18 ZY-LD 2018012510000211 - Sort descending.
    // 002. 08-04-19 ZY-LD 000 - Employee No. is taken from the record.

    Caption = 'Absence Registration';
    DataCaptionFields = "Employee No.";
    DelayedInsert = false;
    Description = 'Absence Registration';
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Employee Absence";
    SourceTableView = sorting("Employee No.", "From Date")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50207, Rec);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.Validate(Quantity);  // 25-01-18 ZY-LD 001
                    end;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50207, Rec);
                    end;

                    trigger OnValidate()
                    begin
                        Rec.Validate(Quantity);  // 25-01-18 ZY-LD 001
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50207, Rec);
                    end;

                    trigger OnValidate()
                    begin
                        //>> 25-01-18 ZY-LD 001
                        if (Rec."From Date" <> 0D) and (Rec."To Date" <> 0D) then
                            Rec.Quantity := Rec."To Date" - Rec."From Date";
                        //<< 25-01-18 ZY-LD 001
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50207, Rec);
                    end;
                }
                field("Cause of Absence Code"; Rec."Cause of Absence Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50207, Rec);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50207, Rec);
                    end;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50207, Rec);
                    end;
                }
                field("Free Text"; Rec."Free Text")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NewAbse)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'New';
                Image = NewDocument;
                ShortCutKey = 'Ctrl+N';
                ToolTip = 'Create a new record';

                trigger OnAction()
                var
                    recEmployeeAbsence: Record "Employee Absence";
                    recEmployeeAbsence1: Record "Employee Absence";
                    LastNo: Integer;
                begin
                    if recEmployeeAbsence.FindLast then
                        LastNo := recEmployeeAbsence."Entry No." + 1;

                    recEmployeeAbsence1.Init;
                    recEmployeeAbsence1."Entry No." := LastNo;
                    //recEmployeeAbsence1."Employee No." := EmpNo;  // 08-04-19 ZY-LD 001
                    recEmployeeAbsence1."Employee No." := Rec."Employee No.";  // 08-04-19 ZY-LD 001
                    recEmployeeAbsence1.Insert;
                    Commit;

                    Page.RunModal(50207, recEmployeeAbsence1);
                    CurrPage.Update;
                end;
            }
            action("Co&mments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Human Resource Comment Sheet";
                RunPageLink = "Table Name" = const("Human Resources Comment Table Name"::"Employee Absence"),
                              "Table Line No." = field("Entry No.");
            }
            group(Absence)
            {
                Caption = 'Absence';
                Image = Absence;
                separator(Action31)
                {
                }
                action("Overview by &Categories")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Overview by &Categories';
                    Image = AbsenceCategory;
                    RunObject = Page "Absence Overview by Categories";
                    RunPageLink = "Employee No. Filter" = field("Employee No.");
                }
                action("Overview by &Periods")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Overview by &Periods';
                    Image = AbsenceCalendar;
                    RunObject = Page "Absence Overview by Periods";
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        exit(Employee.Get(Rec."Employee No."));
    end;

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then;  // 25-01-18 ZY-LD 001
    end;

    var
        Employee: Record Employee;
        EmpNo: Code[20];


    procedure SetEmployee(EmployeeNo: Code[20])
    begin
        EmpNo := EmployeeNo;
    end;
}
