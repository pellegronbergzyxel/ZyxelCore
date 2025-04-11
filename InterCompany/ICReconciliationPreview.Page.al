Page 50365 "IC Reconciliation Preview"
{
    Caption = 'IC Reconciliation Preview';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "IC Reconciliation Name";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(UseAmtsInAddCurr; UseAmtsInAddCurr)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Amounts in Add. Reporting Currency';
                    MultiLine = true;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UseAmtsInAddCurrOnPush;
                    end;
                }
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    begin
                        FilterTokens.MakeDateFilter(DateFilter);
                        Rec.SetFilter(Rec."Date Filter", DateFilter);
                        CurrPage.Update;
                    end;
                }
            }
            part(VATStatementLineSubForm; "IC Reconciliation Preview Line")
            {
                SubPageLink = "Reconciliation Template Name" = field("Reconciliation Template Name"),
                              "Reconciliation Name" = field(Name);
                SubPageView = sorting("Reconciliation Template Name", "Reconciliation Name", "Line No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdateSubForm;
    end;

    trigger OnOpenPage()
    begin
        DateFilter := StrSubstNo('01-01-1900..%1', Today);
        FilterTokens.MakeDateFilter(DateFilter);
        UpdateSubForm;
    end;

    var
        Selection: Option Open,Closed,"Open and Closed";
        PeriodSelection: Option "Before and Within Period","Within Period";
        UseAmtsInAddCurr: Boolean;
        DateFilter: Text[30];
        FilterTokens: Codeunit "Filter Tokens";

    local procedure UpdateSubForm()
    begin
        CurrPage.VATStatementLineSubForm.Page.UpdateForm(Rec, Selection, PeriodSelection, UseAmtsInAddCurr);
    end;

    local procedure OpenandClosedSelectionOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure ClosedSelectionOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure OpenSelectionOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure BeforeandWithinPeriodSelOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure WithinPeriodPeriodSelectOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure UseAmtsInAddCurrOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure OpenSelectionOnValidate()
    begin
        OpenSelectionOnPush;
    end;

    local procedure ClosedSelectionOnValidate()
    begin
        ClosedSelectionOnPush;
    end;

    local procedure OpenandClosedSelectionOnValida()
    begin
        OpenandClosedSelectionOnPush;
    end;

    local procedure WithinPeriodPeriodSelectionOnV()
    begin
        WithinPeriodPeriodSelectOnPush;
    end;

    local procedure BeforeandWithinPeriodSelection()
    begin
        BeforeandWithinPeriodSelOnPush;
    end;
}
