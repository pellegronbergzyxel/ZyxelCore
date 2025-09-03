Report 50096 "VAT Report For BCIT"
{
    Caption = 'VAT Report For BCIT';
    DefaultLayout = RDLC;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;
    RDLCLayout = './Layouts/VAT Report For BCIT.rdlc';
    WordLayout = './Layouts/VAT Report For BCIT.docx';

    trigger OnPreReport()
    begin
        //MakeExcelHead();
    end;

    trigger OnPostReport()
    begin
        //CreateExcelbook();
    end;
}