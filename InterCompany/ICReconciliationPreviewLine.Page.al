Page 50366 "IC Reconciliation Preview Line"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "IC Reconciliation Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Row No."; Rec."Row No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleType;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleType;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleType;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleType;
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleType;
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleType;
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleType;
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleType;
                    Visible = false;
                }
                field("Tax Jurisdiction Code"; Rec."Tax Jurisdiction Code")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleType;
                    Visible = false;
                }
                field("Use Tax"; Rec."Use Tax")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleType;
                    Visible = false;
                }
                field(ColumnValueEUR; ColumnValueEUR)
                {
                    ApplicationArea = Basic, Suite;
                    AutoFormatType = 1;
                    BlankZero = true;
                    Caption = 'Amount (EUR)';
                    DrillDown = true;
                    StyleExpr = StyleType;

                    trigger OnDrillDown()
                    begin
                        case Rec.Type of
                            Rec.Type::"Account Totaling":
                                begin
                                    GLEntry.SetFilter("G/L Account No.", Rec.Totaling);
                                    Rec.Copyfilter(Rec."Date Filter", GLEntry."Posting Date");
                                    Page.Run(Page::"General Ledger Entries", GLEntry);
                                end;
                            Rec.Type::"Row Totaling",
                          Rec.Type::Description:
                                Error(Text000, Rec.FieldCaption(Rec.Type), Rec.Type);
                        end;
                    end;
                }
                field(ColumnValueCUR; ColumnValueCUR)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Amount (CUR)';
                    StyleExpr = StyleType;
                }
                field(CurrencyCode; CurrencyCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Currency Code';
                    StyleExpr = StyleType;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IcReconciliation.InitializeRequest(gVATStmtName, Rec, 'EUR');
        IcReconciliation.CalcLineTotal(Rec, ColumnValueEUR, 0);
        if Rec."Print with" = Rec."print with"::"Opposite Sign" then
            ColumnValueEUR := -ColumnValueEUR;

        CurrencyCode := '';
        ColumnValueCUR := 0;
        if Rec.Type in [Rec.Type::"Account Totaling", Rec.Type::"Customer Totaling", Rec.Type::"Vendor Totaling"] then begin
            IcReconciliation.InitializeRequest(gVATStmtName, Rec, '');
            IcReconciliation.CalcLineTotal(Rec, ColumnValueCUR, 0);
            CurrencyCode := '';
            if ColumnValueCUR <> 0 then
                CurrencyCode := IcReconciliation.FinalizeRequest;
            if Rec."Print with" = Rec."print with"::"Opposite Sign" then
                ColumnValueCUR := -ColumnValueCUR;
        end;

        SetActions;
    end;

    trigger OnClosePage()
    begin
        SI.SetHideSalesDialog(false);
    end;

    trigger OnOpenPage()
    begin
        SI.SetHideSalesDialog(true);
    end;

    var
        Text000: label 'Drilldown is not possible when %1 is %2.';
        GLEntry: Record "G/L Entry";
        IcReconciliation: Report "IC Reconciliation";
        gVATStmtName: Record "IC Reconciliation Name";
        ColumnValueEUR: Decimal;
        ColumnValueCUR: Decimal;
        CurrencyCode: Code[10];
        Selection: Option Open,Closed,"Open and Closed";
        PeriodSelection: Option "Before and Within Period","Within Period";
        UseAmtsInAddCurr: Boolean;
        SI: Codeunit "Single Instance";
        StyleType: Text;


    procedure UpdateForm(var VATStmtName: Record "IC Reconciliation Name"; NewSelection: Option Open,Closed,"Open and Closed"; NewPeriodSelection: Option "Before and Within Period","Within Period"; NewUseAmtsInAddCurr: Boolean)
    begin
        Rec.SetRange(Rec."Reconciliation Template Name", VATStmtName."Reconciliation Template Name");
        Rec.SetRange(Rec."Reconciliation Name", VATStmtName.Name);
        VATStmtName.Copyfilter("Date Filter", Rec."Date Filter");
        Selection := NewSelection;
        PeriodSelection := NewPeriodSelection;
        UseAmtsInAddCurr := NewUseAmtsInAddCurr;
        //VATStatement.InitializeRequest(VATStmtName,Rec,Selection,PeriodSelection,FALSE,UseAmtsInAddCurr);
        //IcReconciliation.InitializeRequest(VATStmtName,Rec);
        gVATStmtName := VATStmtName;
        CurrPage.Update;
    end;

    local procedure SetActions()
    begin
        if Rec.Strong then
            StyleType := 'Strong'
        else
            StyleType := 'Standard';
    end;
}
