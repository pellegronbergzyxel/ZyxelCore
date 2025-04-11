report 50044 SalesClaimRebateReportZX
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales - Claim  Rebate Report.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Sales - Claim / Rebate Report';
    ShowPrintStatus = false;
    UseRequestPage = false;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
        {
            DataItemTableView = sorting("Document Date", "Sell-to Customer No.", "External Document No.", "Location Code", "Return Reason Code") where("Location Code" = const('PP'), "Hide Line" = const(false));
            RequestFilterFields = "Sell-to Customer No.", "Posting Date", "Forecast Territory", "Return Reason Code";

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Sales Cr.Memo Line"."Sell-to Customer No.", 0, true);

                if not recReturnReasonTmp.Get("Sales Cr.Memo Line"."Return Reason Code") then
                    CurrReport.Skip();

                SalesLineTmp := "Sales Cr.Memo Line";
                SalesLineTmp.Insert();
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                ZGT.OpenProgressWindow('', "Sales Cr.Memo Line".Count());
            end;
        }
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = sorting("Document No.", "Line No.") where("Location Code" = const('PP'), "Hide Line" = const(false));

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("Sales Invoice Line"."Sell-to Customer No.", 0, true);

                if not recReturnReasonTmp.Get("Sales Invoice Line"."Return Reason Code") then
                    CurrReport.Skip();

                SalesLineTmp.TransferFields("Sales Invoice Line");
                SalesLineTmp.Amount := -SalesLineTmp.Amount;
                SalesLineTmp.Insert();
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
            end;

            trigger OnPreDataItem()
            begin
                "Sales Cr.Memo Line".Copyfilter("Sell-to Customer No.", "Sales Invoice Line"."Sell-to Customer No.");
                "Sales Cr.Memo Line".Copyfilter("Posting Date", "Sales Invoice Line"."Posting Date");
                "Sales Cr.Memo Line".Copyfilter("Forecast Territory", "Sales Invoice Line"."Forecast Territory");
                "Sales Cr.Memo Line".Copyfilter("Return Reason Code", "Sales Invoice Line"."Return Reason Code");

                ZGT.OpenProgressWindow('', "Sales Invoice Line".Count());
            end;
        }
        dataitem(SalesLineTmp; "Sales Cr.Memo Line")
        {
            UseTemporary = true;
            column(DocumentNo; SalesLineTmp."Document No.")
            {
            }
            column(SellToCustomerNo; "Sales Cr.Memo Line"."Sell-to Customer No.")
            {
            }
            column(CustomerName; recCust.Name)
            {
            }
            column(ForecastTerritory; recCust."Forecast Territory")
            {
            }
            column(PostingDate; SalesLineTmp."Posting Date")
            {
            }
            column(DocumentDate; SalesLineTmp."Document Date")
            {
            }
            column(ExternalDocumentNo; SalesLineTmp."External Document No.")
            {
            }
            column(ItemNo; SalesLineTmp."No.")
            {
            }
            column(Description; SalesLineTmp.Description)
            {
            }
            column(Amount; SalesLineTmp.Amount)
            {
            }
            column(ReturnReasonCode; recReturnReasonTmp.Code)
            {
            }
            column(ReturnReasonDescription; recReturnReasonTmp.Description)
            {
            }
            column(DocumentNo_Caption; SalesLineTmp.FieldCaption(SalesLineTmp."Document No."))
            {
            }
            column(SellToCustomerNo_Caption; recCust.FieldCaption("No."))
            {
            }
            column(CustomerName_Caption; recCust.FieldCaption(Name))
            {
            }
            column(ForecastTerritory_Caption; recCust.FieldCaption("Forecast Territory"))
            {
            }
            column(PostingDate_Caption; SalesLineTmp.FieldCaption(SalesLineTmp."Posting Date"))
            {
            }
            column(DocumentDate_Caption; SalesLineTmp.FieldCaption(SalesLineTmp."Document Date"))
            {
            }
            column(ExternalDocumentNo_Caption; SalesLineTmp.FieldCaption(SalesLineTmp."External Document No."))
            {
            }
            column(ItemNo_Caption; SalesLineTmp.FieldCaption(SalesLineTmp."No."))
            {
            }
            column(Description_Caption; SalesLineTmp.FieldCaption(SalesLineTmp.Description))
            {
            }
            column(Amount_Caption; SalesLineTmp.FieldCaption(SalesLineTmp.Amount))
            {
            }
            column(ReturnReasonCode_Caption; Text001)
            {
            }
            column(ReturnReasonDescription_Caption; Text002)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if SalesLineTmp."Sell-to Customer No." <> '' then
                    recCust.Get(SalesLineTmp."Sell-to Customer No.")
                else
                    Clear(recCust);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        recReturnReason.SetRange("Gen. Prod. Posting Group", 'REBATE');
        if recReturnReason.FindSet() then begin
            repeat
                recReturnReasonTmp := recReturnReason;
                recReturnReasonTmp.Insert();
            until recReturnReason.Next = 0;
        end;
    end;

    var
        recCust: Record Customer;
        recReturnReason: Record "Return Reason";
        recReturnReasonTmp: Record "Return Reason" temporary;
        ZGT: Codeunit "ZyXEL General Tools";
        Text001: Label 'Return Reason Code';
        Text002: Label 'Return Reason Description';
}
