Page 50364 "IC Reconciliation Names"
{
    Caption = 'IC Reconciliation Names';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "IC Reconciliation Name";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
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
        area(processing)
        {
            action("Edit IC Reconciliation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit IC Reconciliation';
                Image = SetupList;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IcReconMgt.TemplateSelectionFromBatch(Rec);
                end;
            }
            action("&Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ICReconName: Record "IC Reconciliation Name";
                    ICReconTmpl: Record "IC Reconciliation Template";
                begin
                    //>> 06-05-20 ZY-LD 001
                    ICReconName := Rec;
                    ICReconName.SETRECFILTER;
                    ICReconTmpl.GET(ICReconName."Reconciliation Template Name");
                    ICReconTmpl.TESTFIELD("IC Reconciliation Report ID");
                    REPORT.RUN(ICReconTmpl."IC Reconciliation Report ID", TRUE, FALSE, ICReconName);
                    //<< 06-05-20 ZY-LD 001
                end;
            }
        }
    }

    trigger OnInit()
    begin
        Rec.SetRange(Rec."Reconciliation Template Name");
    end;

    trigger OnOpenPage()
    begin
        IcReconMgt.OpenStmtBatch(Rec);
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        IcReconMgt: Codeunit ICReconManagement;

    local procedure DataCaption(): Text[250]
    var
        VATStmtTmpl: Record "VAT Statement Template";
    begin
        if not CurrPage.LookupMode then
            if Rec.GetFilter(Rec."Reconciliation Template Name") <> '' then
                if Rec.GetRangeMin(Rec."Reconciliation Template Name") = Rec.GetRangemax(Rec."Reconciliation Template Name") then
                    if VATStmtTmpl.Get(Rec.GetRangeMin(Rec."Reconciliation Template Name")) then
                        exit(VATStmtTmpl.Name + ' ' + VATStmtTmpl.Description);
    end;
}
