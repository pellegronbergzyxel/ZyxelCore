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
                    Tooltip = 'Specifies the starting date of the posting date range.';
                    Caption = 'From';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues();
                        FromDateOnAfterValidate();
                    end;
                }
                field(ToDate; ToDate)
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the ending date of the posting date range.';
                    Caption = 'To';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues();
                        ToDateOnAfterValidate();
                    end;
                }
            }
            group("G/L Account Range")
            {
                Caption = 'G/L Account Range';
                field(FromGL; FromGL)
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the starting G/L account number of the G/L account range.';
                    Caption = 'From';
                    TableRelation = "G/L Account"."No.";

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues();
                        FromGLOnAfterValidate();
                    end;
                }
                field(ToGL; ToGL)
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the ending G/L account number of the G/L account range.';
                    Caption = 'To';
                    TableRelation = "G/L Account"."No.";

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues();
                        ToGLOnAfterValidate();
                    end;
                }
            }
            group("Dimensions to filter")
            {
                Caption = 'Dimensions to filter';
                field(DivisionFilter1; DivisionFilter1)
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Check this box to filter for entries that have no value for the Division dimension.';
                    Caption = 'Division';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues();
                        DivisionFilter1OnAfterValidate();
                    end;
                }
                field(DepartmentFilter1; DepartmentFilter1)
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Check this box to filter for entries that have no value for the Department dimension.';
                    Caption = 'Department';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues();
                        DepartmentFilter1OnAfterValida();
                    end;
                }
                field(CountryFilter1; CountryFilter1)
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Check this box to filter for entries that have no value for the Country dimension.';
                    Caption = 'Country';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues();
                        CountryFilter1OnAfterValidate();
                    end;
                }
                field(CostTypeFilter1; CostTypeFilter1)
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Check this box to filter for entries that have no value for the Cost Type dimension.';
                    Caption = 'Cost Type';

                    trigger OnValidate()
                    begin
                        GetDimensionsWithoutValues();
                        CostTypeFilter1OnAfterValidate();
                    end;
                }
            }
            repeater(Control1000000000)
            {
                Editable = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the unique number of the entry.';
                    Editable = false;
                    Enabled = true;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the number of the G/L account that is associated with the entry.';
                    Editable = false;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the name of the G/L account that is associated with the entry.';
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the code of the first global dimension that is associated with the entry.';
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the code of the second global dimension that is associated with the entry.';
                    Editable = false;
                }
                //06-08-2026 BK performance issue.
                field(Country; rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the third global dimension that is associated with the entry.';
                    Editable = false;
                }
                field("Cost Type"; rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the fourth global dimension that is associated with the entry.';
                    Editable = false;
                }
                field("Ignore Country Dimension"; Rec."Ignore Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies whether the country dimension is ignored for the entry.';
                }
                field("Ignore Cost Type Dimension"; Rec."Ignore Cost Type Dimension")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies whether the cost type dimension is ignored for the entry.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the type of document that is associated with the entry.';
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the date on which the entry is posted.';
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the number of the document that is associated with the entry.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the description of the entry.';
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the amount of the entry.';
                    Editable = false;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the code of the source that is associated with the entry.';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the quantity of the entry.';
                    Editable = false;
                    Enabled = true;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the VAT amount of the entry.';
                    Editable = false;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the debit amount of the entry.';
                    Editable = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the credit amount of the entry.';
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the date of the document that is associated with the entry.';
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the external document number of the entry.';
                    Editable = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Source Type';
                    Editable = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Source No.';
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
                action("Fix Entry")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'To change dimension values for an entry, click on the Fix Entry button.  For Country and Cost Type dimensions to be refreshed, please click on the Update Dimensions button.';
                    Caption = 'Fix Entry';
                    Image = ChangeDimensions;

                    trigger OnAction()
                    begin
                        Error(Text001);
                        //Page.RunModal(Page::"Fix Dimension", Rec);
                    end;
                }
                separator(Action1000000066)
                {
                }
                action("Toggle Ignore Country")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Toggle Ignore Country';
                    tooltip = 'To change the Ignore Country Dimension value for an entry, click on the Toggle Ignore Country button.';
                    Image = ToggleBreakpoint;

                    trigger OnAction()
                    begin
                        Error(Text001);
                    end;
                }
                action("Toggle Ignore Cost Type")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'To change the Ignore Cost Type Dimension value for an entry, click on the Toggle Ignore Cost Type button.';
                    Caption = 'Toggle Ignore Cost Type';
                    Image = ToggleBreakpoint;

                    trigger OnAction()
                    begin
                        Error(Text001);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FromDate := CalcDate('<-CY>', Today());
        ToDate := Today();
        FromGL := '50000';
        ToGL := '99999';

        GetDimensionsWithoutValues();
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


    procedure GetDimensionsWithoutValues()
    begin
        Rec.SetRange("Posting Date");
        Rec.SetRange("G/L Account No.");
        Rec.SetRange("Global Dimension 1 Code");
        Rec.SetRange("Global Dimension 2 Code");
        Rec.SetRange("Posting Date", FromDate, ToDate);
        Rec.SetRange("G/L Account No.", FromGL, ToGL);

        if DivisionFilter1 then
            Rec.SetRange("Global Dimension 1 Code", '', '');

        if DepartmentFilter1 then
            Rec.SetRange("Global Dimension 2 Code", '', '');

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
