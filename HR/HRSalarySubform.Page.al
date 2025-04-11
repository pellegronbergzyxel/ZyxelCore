Page 50182 "HR Salary Subform"
{
    // 001. 13-04-18 ZY-LD 000  Company Car is added.
    // 002. 01-08-18 ZY-LD 2018062910000259 - New field.
    // 003. 05-11-18 ZY-LD 2018102210000156 - New field.

    Caption = 'Salary';
    CardPageID = "HR Salary Card";
    PageType = ListPart;
    SourceTable = "HR Salary Line";
    SourceTableView = sorting("Employee No.", "Valid From")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Valid From"; Rec."Valid From")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Valid To"; Rec."Valid To")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Base Salary P.A."; Rec."Base Salary P.A.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Base Salary P.M."; Rec."Base Salary P.M.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Commission Pay P.A."; Rec."Commission Pay P.A.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Total OTE P.A."; Rec."Total OTE P.A.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Pre-paid Bonus (per Month)"; Rec."Pre-paid Bonus (per Month)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Base % Split"; Rec."Base % Split")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Commission % Split"; Rec."Commission % Split")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("No of Salaries - Decimal"; Rec."No of Salaries - Decimal")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("KPI Plan Payment"; Rec."KPI Plan Payment")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("KPI Plan Attached"; Rec."KPI Plan Attached")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("KPI Holdback %"; Rec."KPI Holdback %")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Company Car"; Rec."Company Car")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Company Car P.A."; Rec."Company Car P.A.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Car Allowance P.A."; Rec."Car Allowance P.A.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Car Allowance P.M."; Rec."Car Allowance P.M.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Car Level"; Rec."Car Level")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Car Registration No"; Rec."Car Registration No")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Car Leasing Company"; Rec."Car Leasing Company")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Car Lease Valid From"; Rec."Car Lease Valid From")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Car Lease Valid To"; Rec."Car Lease Valid To")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(50183, Rec);
                    end;
                }
                field("Tracking Document Id"; Rec."Tracking Document Id")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Tracking Document Attached"; Rec."Tracking Document Attached")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Co&mments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Human Resource Comment Sheet";
                RunPageLink = "Table Name" = const("Human Resources Comment Table Name"::"HR Salary Line"),
                              "Table Line No." = field(UID);
            }
        }
    }
}
