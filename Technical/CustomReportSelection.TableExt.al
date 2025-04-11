// TODO: Not sure what to do...?
TableExtension 50246 CustomReportSelectionZX extends "Custom Report Selection"
{
    //procedure PrintCustomReports();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DocumentRecordRef.GETTABLE(HeaderDoc);
    CASE DocumentRecordRef.NUMBER OF
      DATABASE::"Sales Invoice Header":
        BEGIN
          SalesInvoiceHeader := HeaderDoc;
          SalesInvoiceHeader.SETRANGE("No.",SalesInvoiceHeader."No.");
          SalesInvoiceHeader.GET(SalesInvoiceHeader."No.");
          SetCustomReportSelectionRange(
            CustomReportSelection2,DATABASE::Customer,SalesInvoiceHeader."Bill-to Customer No.",
            CustomReportSelection2.Usage::"S.Invoice");
          SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        END;
      DATABASE::"Sales Cr.Memo Header":
        BEGIN
          SalesCrMemoHeader := HeaderDoc;
          SalesCrMemoHeader.SETRANGE("No.",SalesCrMemoHeader."No.");
          SalesCrMemoHeader.GET(SalesCrMemoHeader."No.");
          SetCustomReportSelectionRange(
            CustomReportSelection2,DATABASE::Customer,SalesCrMemoHeader."Bill-to Customer No.",
            CustomReportSelection2.Usage::"S.Cr.Memo");
          SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
        END;
      DATABASE::"Sales Header":
        BEGIN
          SalesHeader := HeaderDoc;
          SalesHeader.SETRANGE("No.",SalesHeader."No.");
          CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Quote:
              SetCustomReportSelectionRange(
                CustomReportSelection2,DATABASE::Customer,SalesHeader."Bill-to Customer No.",
                CustomReportSelection2.Usage::"S.Quote");
            SalesHeader."Document Type"::Order:
              SetCustomReportSelectionRange(
                CustomReportSelection2,DATABASE::Customer,SalesHeader."Bill-to Customer No.",
                CustomReportSelection2.Usage::"S.Order");
            SalesHeader."Document Type"::Invoice:
              BEGIN
                IF SalesHeader."Last Posting No." = '' THEN
                  SalesInvoiceHeader."No." := SalesHeader."No."
                ELSE
                  SalesInvoiceHeader."No." := SalesHeader."Last Posting No.";
                SalesInvoiceHeader.SETRECFILTER;
                SetCustomReportSelectionRange(
                  CustomReportSelection2,DATABASE::Customer,SalesHeader."Bill-to Customer No.",
                  CustomReportSelection2.Usage::"S.Invoice");
              END;
            SalesHeader."Document Type"::"Credit Memo":
              BEGIN
                IF SalesHeader."Last Posting No." = '' THEN
                  SalesCrMemoHeader."No." := SalesHeader."No."
                ELSE
                  SalesCrMemoHeader."No." := SalesHeader."Last Posting No.";
                SalesCrMemoHeader.SETRECFILTER;
                SetCustomReportSelectionRange(
                  CustomReportSelection2,DATABASE::Customer,SalesHeader."Bill-to Customer No.",
                  CustomReportSelection2.Usage::"S.Cr.Memo");
              END;
          END
        END;
      DATABASE::"Service Invoice Header":
        EXIT(0);
      DATABASE::"Service Cr.Memo Header":
        EXIT(0);
      DATABASE::"Service Header":
        EXIT(0);
      ELSE
        ERROR(UnsupportedReportErr);
    END;

    IF CustomReportSelection2.FIND('-') THEN BEGIN
      REPEAT
        CustomLayoutPresent := CustomReportLayout.GET(CustomReportSelection2."Custom Report Layout ID");
        IF CustomLayoutPresent THEN
          ReportLayoutSelection.SetTempLayoutSelected(CustomReportLayout.ID);

        IF SendAsEmail THEN BEGIN
          AttachmentFilePath := COPYSTR(FileManagement.ServerTempFileName('pdf'),1,250);

          GeneratePDF(SalesHeader,SalesInvoiceHeader,SalesCrMemoHeader,COPYSTR(AttachmentFilePath,1,250));

          IF CustomLayoutPresent THEN
            ReportLayoutSelection.SetTempLayoutSelected(0);

          IF NOT EXISTS(AttachmentFilePath) THEN
            ERROR(AttachmentFilePath);

          EmailPDF(SalesHeader,SalesInvoiceHeader,SalesCrMemoHeader,CustomReportSelection2,COPYSTR(AttachmentFilePath,1,250));
        END ELSE BEGIN
          CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice:
              REPORT.RUN(CustomReportSelection2."Report ID",ShowRequestPage,FALSE,SalesInvoiceHeader);
            SalesHeader."Document Type"::"Credit Memo":
              REPORT.RUN(CustomReportSelection2."Report ID",ShowRequestPage,FALSE,SalesCrMemoHeader);
            ELSE
              REPORT.RUNMODAL(CustomReportSelection2."Report ID",TRUE,FALSE,SalesHeader);
          END;

          IF CustomLayoutPresent THEN
            ReportLayoutSelection.SetTempLayoutSelected(0);
        END;
      UNTIL CustomReportSelection2.Next() = 0;

      EXIT(CustomReportSelection2."Report ID");
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..35
            //>> 30-03-20 ZY-LD 002
            SalesHeader."Document Type"::"Return Order":
              SetCustomReportSelectionRange(
                CustomReportSelection2,DATABASE::Customer,SalesHeader."Bill-to Customer No.",
                CustomReportSelection2.Usage::"S.Return");
            //<< 30-03-20 ZY-LD 002
    #36..69
    //>> 17-06-20 ZY-LD 003
    IF CustomReportSelection2.FIND('-') THEN
      REPEAT
        CustomReportSelectionTmp := CustomReportSelection2;

        IF CustomReportSelection2."Report ID" = 0 THEN BEGIN
          CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::"Return Order" :
              recRepSelection.SETRANGE(Usage,recRepSelection.Usage::"S.Return");
            SalesHeader."Document Type"::Invoice :
              recRepSelection.SETRANGE(Usage,recRepSelection.Usage::"S.Invoice");
            SalesHeader."Document Type"::"Credit Memo":
              recRepSelection.SETRANGE(Usage,recRepSelection.Usage::"S.Cr.Memo");
            ELSE
              recRepSelection.SETRANGE(Usage,recRepSelection.Usage::"S.Order");
          END;

          SalesHeadEvent.SetZyxelReportSelectionFilter(DocumentRecordRef,recRepSelection);
          IF recRepSelection.FINDSET THEN
            REPEAT
              CustomReportSelectionTmp."Report ID" := recRepSelection."Report ID";
              EVALUATE(CustomReportSelectionTmp.Sequence,recRepSelection.Sequence);
              IF NOT CustomReportSelectionTmp.INSERT THEN;
            UNTIL recRepSelection.Next() = 0;
        END ELSE
          IF NOT CustomReportSelectionTmp.INSERT THEN;
      UNTIL CustomReportSelection2.Next() = 0;

    IF CustomReportSelectionTmp.FIND('-') THEN BEGIN
      REPEAT
        CustomReportSelection2 := CustomReportSelectionTmp;
    #72..83
          //>> 01-07-22 ZY-LD 004
          {IF NOT EXISTS(AttachmentFilePath) THEN
            ERROR(AttachmentFilePath);}

          IF EXISTS(AttachmentFilePath) THEN  //<< 01-07-22 ZY-LD 004
            EmailPDF(SalesHeader,SalesInvoiceHeader,SalesCrMemoHeader,CustomReportSelection2,COPYSTR(AttachmentFilePath,1,250));
    #88..100
      UNTIL CustomReportSelectionTmp.Next() = 0;
    #102..104

    {IF CustomReportSelection2.FIND('-') THEN BEGIN
    #71..103
    END;}
    //<< 17-06-20 ZY-LD 003
    */
    //end;
}
