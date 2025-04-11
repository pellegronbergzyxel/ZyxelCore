Page 50361 "IC Reconciliation"
{
    AutoSplitKey = true;
    Caption = 'IC Reconciliation';
    MultipleNewLines = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "IC Reconciliation Line";

    layout
    {
        area(content)
        {
            field(CurrentStmtName; CurrentStmtName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    exit(IcReconMgt.LookupName(Rec.GetRangemax(Rec."Reconciliation Template Name"), CurrentStmtName, Text));
                end;

                trigger OnValidate()
                begin
                    IcReconMgt.CheckName(CurrentStmtName, Rec);
                    CurrentStmtNameOnAfterValidate;
                end;
            }
            repeater(Control1)
            {
                field("Row No."; Rec."Row No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        recCust: Record Customer;
                        GLAccountList: Page "G/L Account List";
                        CustomerList: Page "Customer List";
                        VendorList: Page "Vendor List";
                    begin
                        case Rec.Type of
                            Rec.Type::"Account Totaling":
                                begin
                                    GLAccountList.LookupMode(true);
                                    if not (GLAccountList.RunModal = Action::LookupOK) then
                                        exit(false);
                                    Text := GLAccountList.GetSelectionFilter;
                                    exit(true);
                                end;
                            Rec.Type::"Customer Totaling":
                                begin
                                    if Rec."Company Name" <> '' then
                                        recCust.ChangeCompany(Rec."Company Name");
                                    if Rec.Totaling <> '' then
                                        recCust.SetFilter("No.", Rec.Totaling);
                                    if not recCust.FindFirst then;
                                    recCust.SetRange("No.");

                                    CustomerList.LookupMode(true);
                                    CustomerList.SetTableview(recCust);
                                    if not (CustomerList.RunModal = Action::LookupOK) then
                                        exit(false);
                                    Text := DelChr(CustomerList.GetSelectionFilter, '=', '''');
                                    ;
                                    exit(true);
                                end;
                            Rec.Type::"Vendor Totaling":
                                begin
                                    VendorList.LookupMode(true);
                                    if not (VendorList.RunModal = Action::LookupOK) then
                                        exit(false);
                                    Text := VendorList.GetSelectionFilter;
                                    exit(true);
                                end;
                        end;

                        Text := DelChr(Text, '=', '''');
                    end;
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Row Totaling"; Rec."Row Totaling")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Calculate with"; Rec."Calculate with")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Blank Zero"; Rec."Blank Zero")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Control22; Rec.Print)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Print with"; Rec."Print with")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("New Page"; Rec."New Page")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Strong; Rec.Strong)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
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
        area(navigation)
        {
            group("IC Reconciliation")
            {
                Caption = 'IC Reconciliation';
                Image = Suggest;
                action("P&review")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&review';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "IC Reconciliation Preview";
                    RunPageLink = "Reconciliation Template Name" = field("Reconciliation Template Name"),
                                  Name = field("Reconciliation Name");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Print)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ICReconLine: Record "IC Reconciliation Line";
                        ICReconTmpl: Record "IC Reconciliation Template";
                    begin
                        //>> 06-05-20 ZY-LD 001
                        ICReconLine.COPY(Rec);
                        ICReconLine.SETRANGE("Reconciliation Template Name", ICReconLine."Reconciliation Template Name");
                        ICReconLine.SETRANGE("Reconciliation Name", ICReconLine."Reconciliation Name");
                        ICReconTmpl.GET(ICReconLine."Reconciliation Template Name");
                        ICReconTmpl.TESTFIELD("IC Reconciliation Report ID");
                        REPORT.RUN(ICReconTmpl."IC Reconciliation Report ID", TRUE, FALSE, ICReconLine);
                        //<< 06-05-20 ZY-LD 001
                    end;
                }
                action("Renumber Statement Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Renumber Statement Lines';
                    Image = Replan;

                    trigger OnAction()
                    begin
                        RenumberStatementLine;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        StmtSelected: Boolean;
    begin
        OpenedFromBatch := (Rec."Reconciliation Name" <> '') and (Rec."Reconciliation Template Name" = '');
        if OpenedFromBatch then begin
            CurrentStmtName := Rec."Reconciliation Name";
            IcReconMgt.OpenStmt(CurrentStmtName, Rec);
            exit;
        end;
        IcReconMgt.TemplateSelection(Page::"VAT Statement", Rec, StmtSelected);
        if not StmtSelected then
            Error('');
        IcReconMgt.OpenStmt(CurrentStmtName, Rec);
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        IcReconMgt: Codeunit ICReconManagement;
        CurrentStmtName: Code[10];
        OpenedFromBatch: Boolean;

    local procedure CurrentStmtNameOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        IcReconMgt.SetName(CurrentStmtName, Rec);
        CurrPage.Update(false);
    end;

    local procedure RenumberStatementLine()
    var
        recIcReconLine: Record "IC Reconciliation Line";
        recIcReconLineTmp: Record "IC Reconciliation Line" temporary;
        LiNo: Integer;
        lText001: label '"%1" are renumbered.';
        lText002: label 'Do you want to renumber statement lines (%1, %2)?';
        lText003: label 'Are you sure?';
    begin
        if Confirm(lText002, false, Rec."Reconciliation Template Name", Rec."Reconciliation Name") then
            if Confirm(lText003) then begin
                recIcReconLine.SetRange("Reconciliation Template Name", Rec."Reconciliation Template Name");
                recIcReconLine.SetRange("Reconciliation Name", Rec."Reconciliation Name");
                if recIcReconLine.FindSet(true) then begin
                    repeat
                        LiNo += 10000;
                        recIcReconLineTmp := recIcReconLine;
                        recIcReconLineTmp."Line No." := LiNo;
                        recIcReconLineTmp.Insert;
                    until recIcReconLine.Next() = 0;

                    recIcReconLine.DeleteAll(true);

                    if recIcReconLineTmp.FindSet then
                        repeat
                            recIcReconLine := recIcReconLineTmp;
                            recIcReconLine.Insert;
                        until recIcReconLineTmp.Next() = 0;

                    Message(lText001, LiNo / 10000);
                end;
            end;
    end;
}
