page 50034 "Customer Credit Limit"
{
    // // 11-10-17 ZY-LD 001 Export to Excel.
    // 002. 05-11-18 ZY-LD 2018110510000043 - Output is changed from "Outstanding Orders SUB (LCY) to "Outstanding Orders RHQ (LCY).

    ApplicationArea = Basic, Suite;
    Caption = 'Customer Credit Limit';
    // TODO: Dosn't work (rewrite).
    //CardPageID = "Customer Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Approve';
    SourceTable = "Customer Credit Limited";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Company; Rec.Company)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Status';
                    StyleExpr = StyleText;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Credit Limit Sub (LCY)"; Rec."Credit Limit Sub (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Balance Due Sub (LCY)"; Rec."Balance Due Sub (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                }
                field("Credit Limit Sub (EUR)"; Rec."Credit Limit Sub (EUR)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Balance Due Sub (EUR)"; Rec."Balance Due Sub (EUR)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Outstanding Orders RHQ (LCY)"; Rec."Outstanding Orders RHQ (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    DecimalPlaces = 2 : 2;
                }
                field("Balance Due + Outstanding EUR"; Rec."Balance Due + Outstanding EUR")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Balance Due + Outstanding LCY"; Rec."Balance Due + Outstanding LCY")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Balance Due + Outstanding Order (LCY)';
                    Visible = false;
                }
                field(Division; Rec.Division)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Division';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Country';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Cust. Only Created in Sub"; Rec."Cust. Only Created in Sub")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Current Exchange Rate"; Rec."Current Exchange Rate")
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
            action("Export to Excel")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export to Excel';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;  // 05-07-24 ZY-LD 000 - Use the default BC export instead.

                trigger OnAction()
                begin
                    ExportToExcel();  // 11-10-17 ZY-LD 001
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
    end;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::OK:
                StyleText := 'Standard';
            Rec.Status::Investigate:
                StyleText := 'Ambiguous';
            Rec.Status::Warning:
                StyleText := 'Unfavorable';
        end;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        //CustomerCreditLimitCU.AnalyseCreditLimited;
        if Confirm(Text001, true) then
            ZyWebServMgt.GetCustomerCreditLimits();
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        StyleText: Text[20];
        CustomerCreditLimitCU: Codeunit "ZyXEL Customer Credit Limit";
        Col: Integer;
        ChangeColor: Boolean;
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        Text001: Label 'Do you want to update data?';

    local procedure ExportToExcel()
    var
        lCompany: Record Company;
        FirstLoop: Boolean;
    begin
        //>> 11-10-17 ZY-LD 001
        FirstLoop := true;
        if lCompany.FindSet() then
            repeat
                Rec.SetRange(Rec.Company, lCompany.Name);
                if Rec.FindSet() then begin
                    ExcelBuf.DeleteAll();
                    MakeExcelHead();
                    repeat
                        MakeExcelLine();
                    until Rec.Next() = 0;
                    if FirstLoop then begin
                        CreateExcelbook(lCompany.Name);
                        FirstLoop := false;
                    end else
                        AddNewSheet(lCompany.Name);
                end;
            until lCompany.Next() = 0;
        OpenExcelbook;
        //<< 11-10-17 ZY-LD 001
    end;


    procedure MakeExcelHead()
    var
        lText001: Label 'Payment Terms';
    begin
        //>> 11-10-17 ZY-LD 001
        Col := 37;
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec.Status), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Customer No."), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Customer Name"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Credit Limit Sub (LCY)"), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Balance Due Sub (LCY)"), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Credit Limit Sub (EUR)"), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Balance Due Sub (EUR)"), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Outstanding Orders RHQ (LCY)"), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Balance Due + Outstanding EUR"), false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec.Division), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec.Country), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec.Blocked), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec.Category), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec.Tier), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Payment Terms"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Cust. Only Created in Sub"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Currency Code"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);

        ExcelBuf.AddColumn(Rec.FieldCaption(Rec."Current Exchange Rate"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow();
        //<< 11-10-17 ZY-LD 001
    end;

    procedure MakeExcelLine()
    var
        lCust: Record Customer;
        lPayTerms: Record "Payment Terms";
    begin
        //>> 11-10-17 ZY-LD 001
        if ChangeColor then begin
            Col := 15;
            ChangeColor := false;
        end else begin
            Col := 35;
            ChangeColor := true;
        end;

        ExcelBuf.AddColumn(Format(Rec.Status), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec."Customer No.", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec."Customer Name", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec."Credit Limit Sub (LCY)", false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec."Balance Due Sub (LCY)", false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec."Credit Limit Sub (EUR)", false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec."Balance Due Sub (EUR)", false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec."Outstanding Orders RHQ (LCY)", false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec."Balance Due + Outstanding EUR", false, '', false, false, false, '##,###,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Rec.Division, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.Country, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Rec.Blocked), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.Category, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec.Tier, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec."Payment Terms", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        if Rec."Cust. Only Created in Sub" then
            ExcelBuf.AddColumn(Rec."Cust. Only Created in Sub", false, '', false, false, false, '', ExcelBuf."cell type"::Text)
        else
            ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec."Currency Code", false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Rec."Current Exchange Rate", false, '', false, false, false, '##0.00###', ExcelBuf."cell type"::Number);
        ExcelBuf.NewRow();
        //<< 11-10-17 ZY-LD 001
    end;

    procedure CreateExcelbook(SheetName: Text[30])
    var
        FileManagement: Codeunit "File Management";
    begin
        //>> 11-10-17 ZY-LD 001
        ExcelBuf.CreateBook('', SheetName);
        ExcelBuf.WriteSheet(SheetName, CompanyName(), UserId());
        ExcelBuf.ClearNewRow();

        // ExcelBuf.CreateBook('',Text002);
        // ExcelBuf.WriteSheet(Text003,CompanyName(),UserId());
        // ExcelBuf.CloseBook;
        // ExcelBuf.OpenExcel;
        // ExcelBuf.GiveUserControl;
        // ERROR('');
        //<< 11-10-17 ZY-LD 001
    end;

    local procedure AddNewSheet(SheetName: Text[30])
    begin
        //>> 11-10-17 ZY-LD 001
        ExcelBuf.AddNewSheet(SheetName);
        ExcelBuf.WriteSheet(SheetName, CompanyName(), UserId());
        //<< 11-10-17 ZY-LD 001
    end;

    procedure OpenExcelbook()
    var
        FileManagement: Codeunit "File Management";
    begin
        //>> 11-10-17 ZY-LD 001
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
        Error('');
        //<< 11-10-17 ZY-LD 001
    end;
}
