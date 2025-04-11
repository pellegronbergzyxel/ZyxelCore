Page 50022 "Dimension Management Tool"
{
    // 001. 22-10-18 ZY-LD 000 - Fix Entry does not work. Use "Dimension Combination" instead.

    ApplicationArea = Basic, Suite;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "G/L Entry";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group("Posting Date Range")
            {
                Caption = 'Posting Date Range';
                field(FromDate; FromDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'From';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues;
                        FromDateOnAfterValidate;
                    end;
                }
                field(ToDate; ToDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues;
                        ToDateOnAfterValidate;
                    end;
                }
            }
            group("G/L Account Range")
            {
                Caption = 'G/L Account Range';
                field(FromGL; FromGL)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'From';
                    TableRelation = "G/L Account"."No.";

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues;
                        FromGLOnAfterValidate;
                    end;
                }
                field(ToGL; ToGL)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'To';
                    TableRelation = "G/L Account"."No.";

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues;
                        ToGLOnAfterValidate;
                    end;
                }
            }
            group("Dimensions to filter")
            {
                Caption = 'Dimensions to filter';
                field(DivisionFilter1; DivisionFilter1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Division';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues;
                        DivisionFilter1OnAfterValidate;
                    end;
                }
                field(DepartmentFilter1; DepartmentFilter1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Department';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues;
                        DepartmentFilter1OnAfterValida;
                    end;
                }
                field(CountryFilter1; CountryFilter1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Country';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues;
                        CountryFilter1OnAfterValidate;
                    end;
                }
                field(CostTypeFilter1; CostTypeFilter1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cost Type';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues;
                        CostTypeFilter1OnAfterValidate;
                    end;
                }
            }
            repeater(Control1000000000)
            {
                Editable = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = true;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Cost Type"; Rec."Cost Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Ignore Country Dimension"; Rec."Ignore Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ignore Cost Type Dimension"; Rec."Ignore Cost Type Dimension")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = true;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Fix Entry...")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Fix Entry...';
                    Image = ChangeDimensions;

                    trigger OnAction()
                    begin
                        Error(Text001);  // 22-10-18 ZY-LD 001
                        Page.RunModal(Page::"Fix Dimension", Rec);
                    end;
                }
                separator(Action1000000066)
                {
                }
                action("Toggle Ignore Country")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Toggle Ignore Country';
                    Image = ToggleBreakpoint;

                    trigger OnAction()
                    var
                        NewVal: Boolean;
                    begin
                        Error(Text001);  // 22-10-18 ZY-LD 001
                        NewVal := not xRec."Ignore Country Dimension";
                        //rec.IgnoreCountryDimension(xRec."Entry No.",NewVal);
                    end;
                }
                action("Toggle Ignore Cost Type")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Toggle Ignore Cost Type';
                    Image = ToggleBreakpoint;

                    trigger OnAction()
                    var
                        NewVal: Boolean;
                    begin
                        Error(Text001);  // 22-10-18 ZY-LD 001
                        NewVal := not xRec."Ignore Cost Type Dimension";
                        //rec.IgnoreCostTypeDimension(xRec."Entry No.",NewVal);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FromDate := CalcDate('<-CY>', Today);
        ToDate := Today;
        FromGL := '50000';
        ToGL := '99999';

        GetDimensionsWithoutValues;
    end;

    var
        FromDate: Date;
        DivisionFilter1: Boolean;
        CountryFilter1: Boolean;
        DepartmentFilter1: Boolean;
        CostTypeFilter1: Boolean;
        ToDate: Date;
        FromGL: Code[20];
        ToGL: Code[20];
        Text001: label 'The "Dimension Management Tool" is replaced by "Dimension Combinations". Ask Finance.';
        Text19066805: label 'Dimension Management Tool';
        Text19018606: label 'Check a dimension type box to search for blank dimensions. The dimensions are added together when searching.';
        Text19020316: label 'To change dimension values for an entry, click on the Fix Entry button.  For Country and Cost Type dimensions to be refreshed, please click on the Update Dimensions button.';


    procedure GetDimensionsWithoutValues()
    begin
        Rec.SetRange("Posting Date");
        Rec.SetRange("G/L Account No.");
        Rec.SetRange("Global Dimension 1 Code");
        Rec.SetRange("Global Dimension 2 Code");
        Rec.SetRange("Posting Date", FromDate, ToDate);
        Rec.SetRange("G/L Account No.", FromGL, ToGL);

        if DivisionFilter1 then begin
            Rec.SetRange("Global Dimension 1 Code", '', '');
        end;
        if DepartmentFilter1 then begin
            Rec.SetRange("Global Dimension 2 Code", '', '');
        end;
    end;

    local procedure FromDateOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure DivisionFilter1OnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure DepartmentFilter1OnAfterValida()
    begin
        CurrPage.Update(false);
    end;

    local procedure CostTypeFilter1OnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure CountryFilter1OnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure ToDateOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure FromGLOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure ToGLOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;
}
