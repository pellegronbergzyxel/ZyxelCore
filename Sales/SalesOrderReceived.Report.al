report 50048 "Sales Order Received"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Order Received';
    UsageCategory = Tasks;
    UseRequestPage = false;
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        tempblob: codeunit "Temp Blob";
    begin
        recInvSetup.Get();
        SalesHeader.SetRange("Document Type", SalesHeader."document type"::Order);
        SalesHeader.SetFilter("Sales Order Type", '<>%1', SalesHeader."sales order type"::EICard);
        SalesHeader.SetFilter("Create Date", '%1..', CalcDate('<-CW>', WorkDate()));
        SalesHeader.SetFilter("Shortcut Dimension 1 Code", 'CH*');
        SalesHeader.SetFilter("Location Code", StrSubstNo('%1|EICARD|PFE EXPRES', recInvSetup."AIT Location Code"));
        RepSalesOrderRecived.SetTableview(SalesHeader);
        RepSalesOrderRecived.UseRequestPage(GuiAllowed());
        RepSalesOrderRecived.RunModal();
        if not GuiAllowed() then begin
            RepSalesOrderRecived.GetFilename(tempblob);
            SI.SetMergefield(100, StrSubstNo(Text001, Date2dwy(WorkDate(), 2)));
            SI.SetMergefield(101, Format(CalcDate('<-CW>', WorkDate())));
            EmailAddMgt.CreateSimpleEmail('REP50102', '', '');
            EmailAddMgt.AddAttachment(tempblob, 'SalesOrderReceived.xlsx');
            EmailAddMgt.Send();
        end;
    end;

    var
        SalesHeader: Record "Sales Header";
        recInvSetup: Record "Inventory Setup";
        EmailAddMgt: Codeunit "E-mail Address Management";
        SI: Codeunit "Single Instance";
        RepSalesOrderRecived: Report "Sales Order Recived - Excel";
        Text001: label 'Week %1';
}
