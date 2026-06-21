Report 50126 "Sales Order Received TEST"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Order Received';
    UsageCategory = Tasks;
    UseRequestPage = false;
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        tempblob: codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        Base64Result: Text;
        emailmessage: codeunit "Email Message";

    begin
        recInvSetup.Get;  // 07-08-19 ZY-LD 004
        SalesHeader.SetRange("Document Type", SalesHeader."document type"::Order);
        SalesHeader.SetFilter("Sales Order Type", '<>%1', SalesHeader."sales order type"::EICard);
        SalesHeader.SetFilter("Create Date", '%1..', CalcDate('<-CW>', WorkDate));
        SalesHeader.SetFilter("Shortcut Dimension 1 Code", 'CH*');
        SalesHeader.SetFilter("Location Code", StrSubstNo('%1|EICARD|PFE EXPRES', recInvSetup."AIT Location Code"));
        RepSalesOrderRecived.SetTableview(SalesHeader);
        RepSalesOrderRecived.UseRequestPage(False);
        RepSalesOrderRecived.RunModal;
        RepSalesOrderRecived.GetFilename(tempblob);
        SI.SetMergefield(100, StrSubstNo(Text001, Date2dwy(WorkDate, 2)));
        SI.SetMergefield(101, Format(CalcDate('<-CW>', WorkDate)));
        EmailAddMgt.CreateSimpleEmail('REP50102', '', '');
        //EmailAddMgt.AddAttachment(tempblob, FileMgt.GetFileName(FilenameTarget));
        EmailAddMgt.AddAttachment(tempblob, 'SalesOrderReceived.xlsx');
        EmailAddMgt.Send;
    end;

    var
        SalesHeader: Record "Sales Header";
        EmailAddress: Record "E-mail address";
        recInvSetup: Record "Inventory Setup";
        FileMgt: Codeunit "File Management";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        FilenameServer: Text;
        FilenameTarget: Text;
        RepSalesOrderRecived: Report "Sales Order Recived - Excel";
        Text001: label 'Week %1';
        Text002: label '.xlsx';
        Text003: label 'Sales Order Recived:  ';
        Text004: label 'Turkish invoices %1';
}
