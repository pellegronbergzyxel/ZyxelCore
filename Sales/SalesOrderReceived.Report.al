report 50048 "Sales Order Received"
{
    // 001. 12-04-18 ZY-LD 000 - Turkish invoice list added for David. - 02-01-19 - David doesn't need this e-mail anymore.
    // 002. 04-04-19 ZY-LD 000 - PFE EXPRESS is added.
    // 003. 11-04-19 ZY-LD 2019041110000034 - Location Code "PFE EXPRES" is added.
    // 004. 07-08-19 ZY-LD 2019080510000173 - Location Code was not variable.
    // 005. 08-04-20 ZY-LD 000 - Changed the filter on Sales Order Type.


    ApplicationArea = Basic, Suite;
    Caption = 'Sales Order Received';
    UsageCategory = Tasks;
    UseRequestPage = false;
    ProcessingOnly = true;

    trigger OnPreReport()
    begin
        recInvSetup.Get;  // 07-08-19 ZY-LD 004
        SalesHeader.SetRange("Document Type", SalesHeader."document type"::Order);
        //SalesHeader.SETRANGE("Sales Order Type",SalesHeader."Sales Order Type"::Normal);  // 11-04-19 ZY-LD 003
        //SalesHeader.SETFILTER("Sales Order Type",'%1|%2',SalesHeader."Sales Order Type"::Normal,SalesHeader."Sales Order Type"::Other);  // 11-04-19 ZY-LD 003  // 08-04-20 ZY-LD 005
        SalesHeader.SetFilter("Sales Order Type", '<>%1', SalesHeader."sales order type"::EICard);  // 08-04-20 ZY-LD 005
        SalesHeader.SetFilter("Create Date", '%1..', CalcDate('<-CW>', WorkDate));
        SalesHeader.SetFilter("Shortcut Dimension 1 Code", 'CH*');
        //SalesHeader.SETFILTER("Location Code",'EU2|EICARD|PFE EXPRES');  // 11-04-19 ZY-LD 003  // 07-08-19 ZY-LD 004
        SalesHeader.SetFilter("Location Code", StrSubstNo('%1|EICARD|PFE EXPRES', recInvSetup."AIT Location Code"));  // 07-08-19 ZY-LD 004
        RepSalesOrderRecived.SetTableview(SalesHeader);
        RepSalesOrderRecived.UseRequestPage(GuiAllowed);
        RepSalesOrderRecived.RunModal;
        if not GuiAllowed then begin
            FilenameServer := RepSalesOrderRecived.GetFilename;
            FilenameTarget := FileMgt.GetDirectoryName(FilenameServer) + '\' + StrSubstNo(Text001, Date2dwy(WorkDate, 2)) + Text002;
            FileMgt.CopyServerFile(FilenameServer, FilenameTarget, true);
            FileMgt.DeleteServerFile(FilenameServer);

            SI.SetMergefield(100, StrSubstNo(Text001, Date2dwy(WorkDate, 2)));
            SI.SetMergefield(101, Format(CalcDate('<-CW>', WorkDate)));
            EmailAddMgt.CreateSimpleEmail('REP50102', '', '');
            EmailAddMgt.AddAttachment(FilenameTarget, FileMgt.GetFileName(FilenameTarget), false);
            EmailAddMgt.Send;
            FileMgt.DeleteServerFile(FilenameTarget);
        end;
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
