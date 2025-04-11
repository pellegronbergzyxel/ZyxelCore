Codeunit 50010 "Delete Inv. Quotes and Orders"
{
    // 001. 19-04-22 ZY-LD 2022032910000051 - We will only archive documents where there are no outstanding quantity.


    trigger OnRun()
    begin
        ArchivedSalesQuotes;

        SalesOrders;
        ArchivedSalesOrders;

        SalesReturnOrders;
    end;

    var
        ZGT: Codeunit "ZyXEL General Tools";

    local procedure ArchivedSalesQuotes()
    var
        recSalesHeadArch: Record "Sales Header Archive";
        recAutoSetup: Record "Automation Setup";
        SalesHeader: Record "Sales Header";
        ArchivedVersionsDeletedMsg: Label 'Archived versions deleted.';
    begin
        recAutoSetup.Get;
        if Format(recAutoSetup."Delete Arch. Quotes Older than") <> '' then begin
            recSalesHeadArch.SetFilter("Date Archived", '<%1', CalcDate(recAutoSetup."Delete Arch. Quotes Older than", Today));
            if recSalesHeadArch.FindSet() then
                repeat
                    SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Quote);
                    SalesHeader.SETRANGE("No.", recSalesHeadArch."No.");
                    SalesHeader.SETRANGE("Doc. No. Occurrence", recSalesHeadArch."Doc. No. Occurrence");
                    IF NOT SalesHeader.FINDFIRST THEN
                        recSalesHeadArch.Mark(true);
                until recSalesHeadArch.Next() = 0;
            recSalesHeadArch.MarkedOnly(true);
            recSalesHeadArch.DeleteAll(true);
            Message(ArchivedVersionsDeletedMsg);
        end;
    end;

    local procedure SalesOrders()
    var
        recSalesHead: Record "Sales Header";
        recSalesHeadArch: Record "Sales Header Archive";
        recAutoSetup: Record "Automation Setup";
        ArchiveMgt: Codeunit ArchiveManagement;
        lText001: label 'Archive old orders';
    begin
        recAutoSetup.Get;

        if Format(recAutoSetup."Delete Inv. Orders Older than") <> '' then begin
            recSalesHead.SetRange("Document Type", recSalesHead."document type"::Order);
            recSalesHead.SetRange("Completely Invoiced", true);
            recSalesHead.SetFilter("Order Date", '<%1', CalcDate(recAutoSetup."Delete Inv. Orders Older than", Today));
            if recSalesHead.FindSet then begin
                ZGT.OpenProgressWindow('', recSalesHead.Count);
                repeat
                    ZGT.UpdateProgressWindow(lText001, 0, true);

                    recSalesHeadArch.SetRange("Document Type", recSalesHead."Document Type");
                    recSalesHeadArch.SetRange("No.", recSalesHead."No.");
                    recSalesHeadArch.SetRange("Completely Invoiced", true);
                    if not recSalesHeadArch.FindFirst then
                        ArchiveMgt.ArchSalesDocumentNoConfirm(recSalesHead);
                until recSalesHead.Next() = 0;
                ZGT.CloseProgressWindow;

                Report.RunModal(Report::"Delete Invoiced Sales Orders", false, false, recSalesHead);
            end;
        end
    end;

    local procedure ArchivedSalesOrders()
    var
        recSalesHeadArch: Record "Sales Header Archive";
        recSalesHeadArch2: Record "Sales Header Archive";
        recAutoSetup: Record "Automation Setup";
        SalesHeader: Record "Sales Header";
        ArchivedVersionsDeletedMsg: Label 'Archived versions deleted.';
    begin
        recAutoSetup.Get;

        if Format(recAutoSetup."Delete Arch. Orders Older than") <> '' then begin
            recSalesHeadArch.SetRange("Document Type", recSalesHeadArch."document type"::Order);
            recSalesHeadArch.SetRange("Completely Invoiced", true);
            recSalesHeadArch.SetFilter("Date Archived", '<%1', CalcDate(recAutoSetup."Delete Arch. Orders Older than", Today));
            if recSalesHeadArch.FindSet() then
                repeat
                    SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SETRANGE("No.", recSalesHeadArch."No.");
                    SalesHeader.SETRANGE("Doc. No. Occurrence", recSalesHeadArch."Doc. No. Occurrence");
                    IF NOT SalesHeader.FINDFIRST THEN
                        recSalesHeadArch.Mark(true);
                until recSalesHeadArch.Next() = 0;
            recSalesHeadArch.MarkedOnly(true);
            recSalesHeadArch.DeleteAll(true);
            Message(ArchivedVersionsDeletedMsg);
        end;
    end;

    local procedure SalesReturnOrders()
    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesHeadArch: Record "Sales Header Archive";
        recAutoSetup: Record "Automation Setup";
        ArchiveMgt: Codeunit ArchiveManagement;
        lText001: label 'Archive old return orders';
    begin
        recAutoSetup.Get;

        if Format(recAutoSetup."Del. Inv. Return Ord. Older th") <> '' then begin
            recSalesHead.SetRange("Document Type", recSalesHead."document type"::"Return Order");
            recSalesHead.SetRange("Completely Invoiced", true);
            recSalesHead.SetFilter("Order Date", '<%1', CalcDate(recAutoSetup."Del. Inv. Return Ord. Older th", Today));
            if recSalesHead.FindSet then begin
                ZGT.OpenProgressWindow('', recSalesHead.Count);
                repeat
                    ZGT.UpdateProgressWindow(lText001, 0, true);

                    //>> 19-04-22 ZY-LD 001
                    recSalesLine.SetRange("Document Type", recSalesHead."Document Type");
                    recSalesLine.SetRange("Document No.", recSalesHead."No.");
                    recSalesLine.SetFilter("Outstanding Quantity", '>0');
                    if not recSalesLine.FindFirst then begin  //<< 19-04-22 ZY-LD 001
                        recSalesHeadArch.SetRange("Document Type", recSalesHead."Document Type");
                        recSalesHeadArch.SetRange("No.", recSalesHead."No.");
                        recSalesHeadArch.SetRange("Completely Invoiced", true);
                        if not recSalesHeadArch.FindFirst then
                            ArchiveMgt.ArchSalesDocumentNoConfirm(recSalesHead);
                    end;
                until recSalesHead.Next() = 0;
                ZGT.CloseProgressWindow;

                Report.RunModal(Report::"Delete Invd Sales Ret. Orders", false, false, recSalesHead);
            end;
        end;
    end;

    local procedure ArchivedSalesReturnOrders()
    var
        recSalesHeadArch: Record "Sales Header Archive";
        recSalesHeadArch2: Record "Sales Header Archive";
        recAutoSetup: Record "Automation Setup";
    begin
        recAutoSetup.Get;

        if Format(recAutoSetup."Del. Arch. Return Ord. Older t") <> '' then begin
            recSalesHeadArch.SetRange("Document Type", recSalesHeadArch."document type"::"Return Order");
            recSalesHeadArch.SetRange("Completely Invoiced", true);
            recSalesHeadArch.SetFilter("Date Archived", '<%1', CalcDate(recAutoSetup."Del. Arch. Return Ord. Older t", Today));
            if recSalesHeadArch.FindSet then
                repeat
                    recSalesHeadArch2.SetRange("Document Type", recSalesHeadArch."Document Type");
                    recSalesHeadArch2.SetRange("No.", recSalesHeadArch."No.");
                    Report.RunModal(Report::"Delete Sales Return Order Ver.", false, false, recSalesHeadArch2);
                until recSalesHeadArch.Next() = 0;
        end;
    end;

    local procedure PurchaseOrders()
    var
        recAutoSetup: Record "Automation Setup";
        lText001: label 'Delete Invoiced Purchase Orders';
    begin
        recAutoSetup.Get;

        if recAutoSetup."Delete Invoiced Purch. Orders" then
            Report.RunModal(Report::"Delete Invoiced Purch. Orders", false, false);
    end;
}
