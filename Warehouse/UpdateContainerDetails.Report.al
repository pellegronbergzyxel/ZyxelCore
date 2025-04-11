Report 50169 "Update Container Details"
{
    // 001. 14-08-19 ZY-LD 2019081410000021 - ZyXEL General Tools is changed from CU50016 to CU50000.
    // 002. 27-07-21 ZY-LD 2021071310000057 - Code is updated.

    Caption = 'Update Container Details';
    ProcessingOnly = true;
    ShowPrintStatus = false;

    dataset
    {
        dataitem("VCK Shipping Detail"; "VCK Shipping Detail")
        {
            DataItemTableView = sorting("Container No.", "Invoice No.", "Purchase Order No.", "Purchase Order Line No.", "Pallet No.", "Item No.", "Shipping Method", "Order No.");
            RequestFilterFields = "Bill of Lading No.";

            trigger OnAfterGetRecord()
            begin
                ZGT.UpdateProgressWindow("VCK Shipping Detail"."Bill of Lading No.", 0, true);

                recShipDetail := "VCK Shipping Detail";
                recShipDetail.Validate(ETA, NewETA);
                recShipDetail.Modify(true);
                Updated := true;
            end;

            trigger OnPostDataItem()
            begin
                ZGT.CloseProgressWindow;
                if Updated then
                    Message(Text002, "VCK Shipping Detail".FieldCaption("VCK Shipping Detail".ETA), "VCK Shipping Detail".FieldCaption("VCK Shipping Detail"."Expected Receipt Date"), "VCK Shipping Detail".GetFilter("VCK Shipping Detail"."Bill of Lading No."));
            end;

            trigger OnPreDataItem()
            begin
                if not Confirm(Text003, true, NewETA, "VCK Shipping Detail".Count, "VCK Shipping Detail".GetFilter("VCK Shipping Detail"."Bill of Lading No.")) then
                    CurrReport.Break();

                ZGT.OpenProgressWindow('', "VCK Shipping Detail".Count);
            end;
        }
    }

    requestpage
    {
        Caption = 'Change Container ETA Date';
        DeleteAllowed = false;
        Description = 'Change Container ETA Date';
        ShowFilter = false;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewETA; NewETA)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New ETA Date';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        NewETA := Today;
    end;

    trigger OnPreReport()
    var
        ConfirmStr: Text[1000];
    begin
        if not ZGT.IsRhq then
            CurrReport.Break();

        if "VCK Shipping Detail".GetFilter("Bill of Lading No.") = '' then
            Error(Text001, "VCK Shipping Detail".FieldCaption("Bill of Lading No."));

        SI.UseOfReport(3, 50169, 2);  // 14-10-20 ZY-LD 000
        Updated := false;
    end;

    var
        recShipDetail: Record "VCK Shipping Detail";
        NewETA: Date;
        Text001: label 'You must specify a "%1"';
        Text002: label '"%1" and "%2" has been updated for "Bill of Lading no." %3.';
        Updated: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";
        SI: Codeunit "Single Instance";
        Text003: label 'Do you want to change the "ETA Date" to %1 for %2 line(s) with "Bill of Lading No." %3?';

    local procedure CheckBOLExists(BOLNum: Code[20]) Exists: Boolean
    var
        recVCKShippingDetail: Record "VCK Shipping Detail";
    begin
        /*recVCKShippingDetail.SETFILTER("Bill of Lading No.",BOLNum);
        Exists := recVCKShippingDetail.FINDFIRST;*/

    end;

    local procedure ChangeDate(BOLNum: Code[20]; NewDate: Date)
    var
        recVCKShippingDetail: Record "VCK Shipping Detail";
        OldETA: Date;
        OldExpected: Date;
        ExpectedDays: Integer;
        recNo: Integer;
        OldETD: Integer;
    begin
        /*recVCKShippingDetail.SETFILTER("Bill of Lading No.",BOLNum);
        IF recVCKShippingDetail.FINDSET THEN BEGIN
          ZGT.OpenProgressWindow('',recVCKShippingDetail.COUNT);
          REPEAT
             recNo += 1;
             ZGT.UpdateProgressWindow(recVCKShippingDetail."Purchase Order No.",recNo,TRUE);
             OldETA := recVCKShippingDetail.ETA;
             OldExpected := recVCKShippingDetail."Expected Receipt Date";
             ExpectedDays := OldExpected - OldETA;
             recVCKShippingDetail.ETA := NewDate;
             recVCKShippingDetail."Expected Receipt Date" := CALCDATE('+'+FORMAT(ExpectedDays) + 'D',NewDate);
             recVCKShippingDetail.MODIFY;
          UNTIL recVCKShippingDetail.Next() = 0;
          ZGT.CloseProgressWindow;
        END;
        MESSAGE(Text003,BOLNum);*/

    end;
}
