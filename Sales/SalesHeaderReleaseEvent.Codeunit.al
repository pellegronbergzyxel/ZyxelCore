codeunit 50052 SalesHeaderReleaseEvent
{
    // Many comments in the code is comming from "CU 50067".
    // x001. 23-08-24 ZY-LD 000 - The country code must be mentioned in the dimensions on the customer.

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
        recSalesLine2: Record "Sales Line";
        recSalesLine3: Record "Sales Line";
        recItem: Record Item;
        recAddItem: Record "Additional Item";
        recSalesSetup: Record "Sales & Receivables Setup";
        recDelDocLine: Record "VCK Delivery Document Line";
        recGenBusPostGrp: Record "Gen. Business Posting Group";
        recCust: Record Customer;
        recLocation: Record Location;
        recCustOvership: Record "Customer/Item Overshipment";
        recGenProdPostGrp: Record "Gen. Product Posting Group";
        recCountry: Record "Country/Region";
        recAddEicardOrderInfo: Record "Add. Eicard Order Info";
        SalOrdTypeRel: Record "Sales Order Type Relation";  // 16-07-24 ZY-LD 000
        AddItemMgt: Codeunit "ZyXEL Additional Items Mgt";
        ZyXELVCK: Codeunit "ZyXEL VCK";
        ReleaseOrder: Codeunit "Customer Credit Limit Check";
        ZGT: Codeunit "ZyXEL General Tools";
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
        SI: Codeunit "Single Instance";
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
        EInvoiceCommentEnable: Boolean;
        CurrencyCode: Code[10];
        Balance: Decimal;
        BalanceDue: Decimal;
        Credit: Decimal;
        OutstandingAmount: Decimal;
        PrevSBUCompany: Option " ",Zyxel,ZNet;
        lText001: Label '"Item No." %1 on Sales Order %2 Line No. %3 must have an "%4" %5.';
        lText002: Label '"%1" is blank, and delivery document will not be created.\ Do you want to continue?';
        lText003: Label 'If "%1" is blank. Delivery Document will not be created.';
        lText005: Label 'Please enter "%1" on item no. %2. (Line %3).';
        lText006: Label '"%1" has been reached.\%4.\\ "%1": %2\"Order Balance": %3';
        //lText007: Label 'Lines with zero "%1" exists.\\You can tick off the field "%2" on the sales line to confirm that zero "%1" is correct, and to avoid this message again.\\Do you want to continue?';  // 30-04-24 ZY-LD 143
        lText007: Label 'Unaccepted lines with zero "%1" exists (%3).\\You need to tick off the field "%2" on the sales line to confirm that zero "%1" is correct.';  // 30-04-24 ZY-LD 143
        lText008: Label 'Release is cancled.';
        lText009: Label 'External document number can not be blank!';
        lText011: Label '"%1" %2 and "%3" %4 must not be different on "%5" %6 %7. Re-enter "%1".';
        lText012: Label 'Both "%1" and "%2" must be filled on line no. %3.';
        lText013: Label 'The "%1" "%2" on %3 %4 must be identical to "%1" "%5" on the sales header.';
        lText014: Label '"%1" must not be 0,00 on %4 sales order %2 line no. %3.';
        lText015: Label '"%1" must be 0,00 on %4 sales order %2 line no. %3.';
        lText016: Label 'The order contains an item %1 which is not an EiCard.';
        lText017: Label 'The order contains an item %1 which is not a ZyXEL License.';
        lText018: Label 'You can not combine EiCard orders with items for both ZCom and ZNet.\The field "SBU Company" on the item card define the company. Create one sales order for ZCom and one for ZNet.';
        lText019: Label 'You must choose an option for "%1".';
        lText020: Label '"Item No." %1 on Sales Order %2 Line No. %3 does not have an "%4" %5.\Do you want to continue?';
        lText021: Label 'For "Customer No." %1 you can only sell "Item No." %2 from "Location Code" %3.\See "%4".';
        lText022: Label '"%1" must be identical to "%5" on %4 sales order %2 line no. %3.';
        lText023: Label 'You are trying to release an "%1" for location "%2" without a "Shipment No.".\Are you sure you want to continue?';
        lText024: Label 'The sales document (Invoice, Cr. Memo)  in the subsidary will be invoiced in "Currency Code" %1.\Do you want to continue?';
        lText025: Label '"%1" %2 does not match "%3" %4.';
        lText026: Label '"%1" %2 on "%3" does not match "%1" %4 on "%5".';
        lText027: Label '"Line No." %1 with commercial products is not related to a line with overshipment products.\Do you want to continue?';
        lText028: Label '"%1" must have a value, or "%2" must be blank on "%3" %4.';
        lText029: Label '"%1" and "%2" must not be identical.';
        lText030: Label 'The field "%1" must be filled on the item card. The field tell which "HQ Company" the item is linked to. The field must be updated by "HQ PLMS Update".\\"HQ PLMS Update" is running for single items every night, and a full update for all items is running during the weekend.\\You can not start the Eicard process until the field "%1" has been filled.';
        lText031: Label '"%1" is a freight cost, and can be related to an item line.\If the relation is filled in, it freight will be posted same invoice together with the related item.\\Do you want to continue without a relation?';
        lText032: Label '"%1" %2 must be identical to the first two characters on "%3" %4.';
        lText033: Label 'Please contact the accounting manager to get the order released.';
        lText034: Label 'Do you want to continue?';
        lText035: Label 'Quantiry for GLC products must be equal to one.';
        lText036: Label 'Quantity %1 and "%2 security" %3 does not match.';
        lText037: Label 'The Item No. %1 is blocked. Please contact your Supply Chain Manager.';
        lText038: Label '"%1" is a freight cost, and can be related to an item line.\If the relation is filled in, it freight will be posted on the same invoice together with the related item.\\Do you want to continue without a relation?';
        lText041: Label '"%1" %2 is not a valid date.';
        lText042: Label '"%1" on %2 "Line No." %3 is a non returnable item.';
    begin
        //>> 23-09-22 ZY-LD 126
        if SalesHeader."Document Type" in [SalesHeader."document type"::Order, SalesHeader."document type"::"Return Order"] then begin
            if (not SI.GetHideSalesDialog) and GuiAllowed() then begin
                recSalesLine.SetRange("Document Type", SalesHeader."Document Type");
                recSalesLine.SetRange("Document No.", SalesHeader."No.");
                recSalesLine.SetFilter(Type, '>%1', recSalesLine.Type::" ");
                recSalesLine.SetRange("Line Amount", 0);
                recSalesLine.SetRange("Zero Unit Price Accepted", false);
                recSalesLine.SetRange("Hide Line", false);
                recSalesLine.SetRange("Bom Line No.", 0);
                if recSalesLine.FindFirst() then
                    Error(lText007, recSalesLine.FieldCaption("Line Amount"), recSalesLine.FieldCaption("Zero Unit Price Accepted"), recSalesLine."Line No.");  // 30-04-24 ZY-LD 143 
                //if not Confirm(lText007, false, recSalesLine.FieldCaption("Line Amount"), recSalesLine.FieldCaption("Zero Unit Price Accepted")) then
                //    Error(lText008);
            end;
            //>> 16-09-24 ZY-LD x002
            recSalesLine.Reset();
            recSalesLine.SetRange("Document Type", SalesHeader."Document Type");
            recSalesLine.SetRange("Document No.", SalesHeader."No.");
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            recSalesLine.SetFilter("No.", '<>%1', '');
            recSalesLine.SetRange("Not Returnable", true);
            if recSalesLine.FindFirst() then
                Error(lText042, recSalesLine."No.", SalesHeader."No.", recSalesLine."Line No.");
            //<< 16-09-24 ZY-LD x002
        end;
        //<< 23-09-22 ZY-LD 126

        //>> 07-12-23 ZY-LD 134
        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"] THEN BEGIN
            recSalesLine.RESET;
            recSalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
            recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
            recSalesLine.setrange("Unit Cost (LCY)", 0);
            IF recSalesLine.FINDSET THEN
                REPEAT
                    recItem.GET(recSalesLine."No.");

                    IF recItem."Unit Cost" <> 0 THEN begin
                        recSalesLine.VALIDATE("Unit Cost (LCY)", recItem."Unit Cost");
                        recSalesLine.MODIFY;
                    end else
                        if recItem."Last Direct Cost" <> 0 then begin
                            recSalesLine.VALIDATE("Unit Cost (LCY)", recItem."Last Direct Cost");
                            recSalesLine.MODIFY;
                        end;
                UNTIL recSalesLine.NEXT = 0;

            ValidateDimensionsOnRelease2(SalesHeader);  // 23-08-24 ZY-LD x001
        END;
        //<< 07-12-23 ZY-LD 134

        //>> 01-03-19 ZY-LD 023
        if SalesHeader."Document Type" = SalesHeader."document type"::Order then begin  // 01-03-19 ZY-LD 023
            SI.SetManualChange(false);  // 19-01-18 ZY-LD 017

            //OrderingPolicy.MinimumCartonOrdering("No.");  // 28-05-21 ZY-LD 085 - The code has been moved search for 085 to find it.
            //ReleaseOrder.ReleaseWithCreditCheck(SalesHeader);
            //>> 16-01-23 ZY-LD 128
            //IF NOT ReleaseOrder.CheckCreditLimit("Bill-to Customer No.",TRUE,Balance,BalanceDue,Credit) THEN
            //  ERROR(lText006);
            OutstandingAmount := SalesHeader.TotalOutstandingamount() + ReleaseOrder.CalculateReleaseAmountOtherSO(SalesHeader);
            if not ReleaseOrder.CheckCreditLimit(SalesHeader."Bill-to Customer No.", true, Balance, BalanceDue, Credit, OutstandingAmount) then begin
                recCust.Get(SalesHeader."Bill-to Customer No.");
                if ZGT.UserIsAccManager('DK') then begin
                    if not Confirm(lText006, false, recCust.FieldCaption("Credit Limit (LCY)"), recCust."Credit Limit (LCY)", Balance, lText034) then
                        Error('')
                end else
                    Error(lText006, recCust.FieldCaption("Credit Limit (LCY)"), recCust."Credit Limit (LCY)", Balance, lText033);
            end;
            //<< 16-01-23 ZY-LD 128

            //>> 23-09-22 ZY-LD 126 - Code has been moved.
            //ZY2.3 >>
            /*IF (NOT SI.GetHideSalesDialog) AND GUIALLOWED THEN BEGIN
              recSalesLine.SETRANGE("Document Type","Document Type");
              recSalesLine.SETRANGE("Document No.","No.");
              recSalesLine.SETFILTER(Type,'>0');
              recSalesLine.SETFILTER("Line Amount",'=0');
              IF recSalesLine.FINDFIRST THEN
               IF NOT CONFIRM(lText007) THEN
                 ERROR(lText008);
            END;*/
            //ZY2.3 <<
            //<< 23-09-22 ZY-LD 126

            //15-51643 -
            if SalesHeader."External Document No." = '' then
                Error(lText009);
            //15-51643 +

            SalesHeader.TestField(SalesHeader."Ship-to Country/Region Code");  // 12-09-18 ZY-LD 018

            //>> 17-09-18 ZY-LD 019
            recSalesSetup.Get();
            if SalesHeader."Sales Order Type" <> SalesHeader."Sales Order Type"::eCommerce then  // 16-07-24 ZY-LD 150
                if SalesHeader."Location Code" = recSalesSetup."All-In Logistics Location" then begin
                    if SalesHeader."Ship-to Code" = '' then
                        if not Confirm(lText002, false, SalesHeader.FieldCaption(SalesHeader."Ship-to Code")) then
                            Message(lText003, SalesHeader.FieldCaption(SalesHeader."Ship-to Code"));

                    //>> 10-07-20 ZY-LD 060
                    if (SalesHeader."Shipment Method Code" = '') and GuiAllowed() then
                        if not Confirm(lText002, false, SalesHeader.FieldCaption(SalesHeader."Shipment Method Code")) then
                            Message(lText003, SalesHeader.FieldCaption(SalesHeader."Shipment Method Code"));
                    //<< 10-07-20 ZY-LD 060

                    //>> 05-08-19 ZY-LD 032
                    if SalesHeader."Sell-to Customer No." = recSalesSetup."Customer No. on Sister Company" then begin
                        recSalesLine3.SetRange("Document Type", SalesHeader."Document Type");
                        recSalesLine3.SetRange("Document No.", SalesHeader."No.");
                        recSalesLine3.SetRange(Type, recSalesLine3.Type::Item);
                        recSalesLine3.SetFilter("No.", '<>%1', '');
                        recSalesLine3.SetRange("Hide Line", false);
                        if recSalesLine3.FindSet() then
                            repeat
                                if (recSalesLine3."Ext Vend Purch. Order No." = '') or (recSalesLine3."Ext Vend Purch. Order Line No." = 0) then
                                    Error(lText012,
                                      recSalesLine3.FieldCaption("Ext Vend Purch. Order No."),
                                      recSalesLine3.FieldCaption("Ext Vend Purch. Order Line No."),
                                      recSalesLine3."Line No.");
                            until recSalesLine3.Next() = 0;
                    end;
                    //<< 05-08-19 ZY-LD 032
                end;
            //<< 17-09-18 ZY-LD 019

            //>> 18-02-20 ZY-LD 051
            case SalesHeader."Sales Order Type" of
                SalesHeader."sales order type"::EICard:
                    begin
                        recCust.Get(SalesHeader."Sell-to Customer No.");
                        if recCust."Set Eicard Type on Sales Order" and (SalesHeader."Eicard Type" = SalesHeader."eicard type"::" ") then
                            Error(lText019, SalesHeader.FieldCaption(SalesHeader."Eicard Type"));
                    end;
            end;
            //<< 18-02-20 ZY-LD 051

            //>> 16-07-24 ZY-LD 150
            // recLocation.Get(SalesHeader."Location Code");
            // if (SalesHeader."Sales Order Type" <> recLocation."Sales Order Type") and
            //    (SalesHeader."Sales Order Type" <> recLocation."Sales Order Type 2")
            // then
            //     Error(lText025, SalesHeader.FieldCaption(SalesHeader."Location Code"), SalesHeader."Location Code", SalesHeader.FieldCaption(SalesHeader."Sales Order Type"), SalesHeader."Sales Order Type");

            if ((SalesHeader."Sales Order Type" = SalesHeader."Sales Order Type"::eCommerce) and
                (not SalOrdTypeRel.get(SalesHeader."Location Code", SalesHeader."Sales Order Type"))) or
               ((SalesHeader."Sales Order Type" <> SalesHeader."Sales Order Type"::eCommerce) and
                (recLocation.Get(SalesHeader."Location Code")) and
                (SalesHeader."Sales Order Type" <> recLocation."Sales Order Type") and
                (SalesHeader."Sales Order Type" <> recLocation."Sales Order Type 2"))
            then
                Error(lText025, SalesHeader.FieldCaption(SalesHeader."Location Code"), SalesHeader."Location Code", SalesHeader.FieldCaption(SalesHeader."Sales Order Type"), SalesHeader."Sales Order Type");
            //<< 16-07-24 ZY-LD 150

            ValidateDimensionsOnRelease(SalesHeader."No.", SalesHeader."Dimension Set ID");  // 04-02-21 ZY-LD 079

            // Sales Lines
            recSalesLine.Reset();
            recSalesLine.SetRange("Document Type", SalesHeader."Document Type");
            recSalesLine.SetRange("Document No.", SalesHeader."No.");
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            if recSalesLine.FindSet() then
                repeat
                    recItem.Get(recSalesLine."No.");

                    if recSalesLine."Sales Order Type" <> SalesHeader."Sales Order Type" then
                        Error(lText026, SalesHeader.FieldCaption(SalesHeader."Sales Order Type"), recSalesLine."Sales Order Type", recSalesLine.TableCaption(), SalesHeader."Sales Order Type", SalesHeader.TableCaption());
                    if recSalesLine."Location Code" <> SalesHeader."Location Code" then
                        Error(lText026, SalesHeader.FieldCaption(SalesHeader."Location Code"), recSalesLine."Location Code", recSalesLine.TableCaption(), SalesHeader."Location Code", SalesHeader.TableCaption());
                    if not SI.GetWarehouseManagement then  // 08-07-24 ZY-LD 147
                        if recItem."Block on Sales Order" and ((recSalesLine."Qty. to Ship" <> 0) or (recSalesLine."Qty. to Invoice" <> 0)) then
                            Error(lText037, recItem."No.");

                    //>> 24-11-20 ZY-LD 070
                    /*IF recSelltoCustfromLoc.GET(recSalesLine."Sell-to Customer No.",recSalesLine."No.") AND
                      (recSelltoCustfromLoc."Location Code" <> recSalesLine."Location Code")
                    THEN
                      ERROR(lText021,recSalesLine."Sell-to Customer No.",recSalesLine."No.",recSelltoCustfromLoc."Location Code",recSelltoCustfromLoc.TABLECAPTION);*/
                    //<< 24-11-20 ZY-LD 070

                    //>> 12-12-17 ZY-LD 016
                    if SalesHeader."Sales Order Type" = SalesHeader."sales order type"::EICard then begin
                        //>> 23-02-23 ZY-LD 129
                        //IF recItem."EMS License" AND (recSalesLine."EMS Machine Code" = '') THEN
                        //  ERROR(lText005,recSalesLine.FieldCaption("EMS Machine Code"),recSalesLine."No.",recSalesLine."Line No.");

                        //>> 23-05-23 ZY-LD 129
                        /*CASE recItem."Enter Security for Eicard on" OF
                          recItem."Enter Security for Eicard on"::"EMS License" :
                            BEGIN
                              IF recSalesLine."EMS Machine Code" = '' THEN
                                ERROR(lText005,recSalesLine.FieldCaption("EMS Machine Code"),recSalesLine."No.",recSalesLine."Line No.");
                            END;
                          recItem."Enter Security for Eicard on"::"GLC License" :
                            BEGIN
                              IF recSalesLine.Quantity > 1 THEN
                                ERROR(lText035);
                              IF (recSalesLine."GLC Serial No." = '') OR (recSalesLine."GLC Mac Address" = '') THEN BEGIN
                                IF recSalesLine."GLC Serial No." = '' THEN
                                  ERROR(lText005,recSalesLine.FieldCaption("GLC Serial No."),recSalesLine."No.",recSalesLine."Line No.");
                                IF recSalesLine."GLC Mac Address" = '' THEN
                                  ERROR(lText005,recSalesLine.FieldCaption("GLC Mac Address"),recSalesLine."No.",recSalesLine."Line No.");
                              END;

                            END;
                        END;  */

                        if recItem."Enter Security for Eicard on" <> recItem."enter security for eicard on"::" " then begin
                            recAddEicardOrderInfo.SetRange("Document Type", recSalesLine."Document Type");
                            recAddEicardOrderInfo.SetRange("Document No.", recSalesLine."Document No.");
                            recAddEicardOrderInfo.SetRange("Sales Line Line No.", recSalesLine."Line No.");
                            recAddEicardOrderInfo.SetRange(Validated, true);
                            if recSalesLine.Quantity <> recAddEicardOrderInfo.Count() then
                                Error(lText036, recSalesLine.Quantity, Format(recItem."Enter Security for Eicard on"), recAddEicardOrderInfo.Count());
                        end;
                        //<< 23-05-23 ZY-LD 129

                        //<< 23-02-23 ZY-LD 129

                        //>> 05-11-19 ZY-LD 044
                        if not recItem.IsEICard then
                            Error(lText016, recItem."No.");
                        if recItem."Non ZyXEL License" then
                            Error(lText017, recItem."No.");
                        //>> 14-01-22 ZY-LD 111
                        if recItem."SBU Company" = recItem."sbu company"::" " then
                            Error(lText030, recItem.FieldCaption("SBU Company"));
                        //<< 14-01-22 ZY-LD 111
                        if (recItem."SBU Company" <> PrevSBUCompany) and (PrevSBUCompany > Prevsbucompany::" ") then
                            Error(lText018);
                        PrevSBUCompany := recItem."SBU Company";
                        //<< 05-11-19 ZY-LD 044
                    end;
                    //<< 12-12-17 ZY-LD 016

                    //>> 15-11-21 ZY-LD 106
                    if GuiAllowed() then
                        if (recSalesLine."No." = '') and (recSalesLine.Type.AsInteger() > recSalesLine.Type::" ".AsInteger()) then
                            Error(lText028, recSalesLine.FieldCaption("No."), recSalesLine.FieldCaption(Type), recSalesLine.FieldCaption("Line No."), recSalesLine."Line No.");
                    //<< 15-11-21 ZY-LD 106

                    //>> 12-03-19 ZY-LD 024
                    if (recSalesLine.Type = recSalesLine.Type::Item) and
                       (recSalesLine."No." <> '') and
                       (not recSalesLine."Hide Line") and
                       (recSalesLine.Quantity <> recSalesLine."Quantity (Base)")
                    then
                        Error(
                          lText011,
                          recSalesLine.FieldCaption(Quantity), recSalesLine.Quantity, recSalesLine.FieldCaption("Quantity (Base)"), recSalesLine."Quantity (Base)",
                          SalesHeader.TableCaption(), recSalesLine."Document No.", recSalesLine."Line No.");
                    //<< 12-03-19 ZY-LD 024

                    //>> 12-09-18 ZY-LD 018
                    if (recSalesLine."No." <> '') and  // 07-12-18 ZY-LD 022
                       (not recSalesLine."Hide Line") and
                       (recSalesLine."Warehouse Status" < recSalesLine."warehouse status"::Delivered) and  // 11-10-18 ZY-LD 020
                       (not SalesHeader."Disable Additional Items") and  // 11-10-18 ZY-LD 020
                       (recSalesLine."Sales Order Type" <> recSalesLine."sales order type"::"Drop Shipment")  // 08-01-20 ZY-LD 049
                    then begin
                        recAddItem.SetRange("Item No.", recSalesLine."No.");
                        //>> 20-11-18 ZY-LD 021
                        recCust.Get(recSalesLine."Sell-to Customer No.");
                        recCust.TestField("Forecast Territory");
                        //recAddItem.SETRANGE("Ship-to Country/Region","Ship-to Country/Region Code");
                        recAddItem.SetFilter("Ship-to Country/Region", '%1|%2', '', SalesHeader."Ship-to Country/Region Code");
                        recAddItem.SetFilter("Forecast Territory", '%1|%2', '', recCust."Forecast Territory");
                        if recCust."Additional Items" then
                            recAddItem.SetRange("Customer No.", recCust."No.")
                        else
                            recAddItem.SetFilter("Customer No.", '%1', '');

                        //<< 20-11-18 ZY-LD 021
                        if recAddItem.FindFirst() then
                            repeat
                                recSalesLine2.SetRange("Document Type", recSalesLine."Document Type");
                                recSalesLine2.SetRange("Document No.", recSalesLine."Document No.");
                                recSalesLine2.SetRange("Additional Item Line No.", recSalesLine."Line No.");
                                recSalesLine2.SetRange("No.", recAddItem."Additional Item No.");
                                if not recSalesLine2.FindFirst() then begin
                                    //>> 16-08-19 ZY-LD 034
                                    recDelDocLine.SetRange("Sales Order No.", recSalesLine."Document No.");
                                    recDelDocLine.SetRange("Sales Order Line No.", recSalesLine."Line No.");
                                    recDelDocLine.SetRange("Item No.", recAddItem."Additional Item No.");
                                    if not recDelDocLine.FindFirst() then  //<< 16-08-19 ZY-LD 034
                                                                           //>> 14-10-20 ZY-LD 067
                                        if recAddItem."Edit Additional Sales Line" then begin
                                            if not Confirm(lText020, true, recSalesLine."No.", recSalesLine."Document No.", recSalesLine."Line No.", recAddItem.TableCaption(), recAddItem."Additional Item No.") then
                                                Error('');  //<< 14-10-20 ZY-LD 067
                                        end else
                                            Error(lText001, recSalesLine."No.", recSalesLine."Document No.", recSalesLine."Line No.", recAddItem.TableCaption(), recAddItem."Additional Item No.")

                                end;
                            until recAddItem.Next() = 0;

                        //>> 20-08-19 ZY-LD 035
                        recGenBusPostGrp.Get(recSalesLine."Gen. Bus. Posting Group");
                        if recGenBusPostGrp."Sample / Test Equipment" > recGenBusPostGrp."sample / test equipment"::" " then
                            if (recSalesLine.Type = recSalesLine.Type::Item) and (recSalesLine."No." <> '') and (recSalesLine.Quantity <> 0) then begin
                                if recSalesLine."Unit Cost" = 0 then begin
                                    recItem.Get(recSalesLine."No.");
                                    if recItem."Unit Cost" <> 0 then
                                        Error(lText014, recSalesLine.FieldCaption("Unit Cost"), SalesHeader."No.", recSalesLine."Line No.", LowerCase(recSalesLine."Gen. Bus. Posting Group"));
                                end;

                                //>> 19-01-21 ZY-LD 078
                                if recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."sample / test equipment"::"Sample (Unit Price = Zero)" then begin
                                    if recSalesLine."Unit Price" <> 0 then
                                        Error(lText015, recSalesLine.FieldCaption("Unit Price"), SalesHeader."No.", recSalesLine."Line No.", LowerCase(recSalesLine."Gen. Bus. Posting Group"));
                                end else
                                    if recSalesLine."Unit Price" <> recSalesLine."Unit Cost" then
                                        Error(lText022, recSalesLine.FieldCaption("Unit Price"), SalesHeader."No.", recSalesLine."Line No.", LowerCase(recSalesLine."Gen. Bus. Posting Group"), recSalesLine.FieldCaption("Unit Cost"));
                                //<< 19-01-21 ZY-LD 078
                            end;
                        //<< 20-08-19 ZY-LD 035

                    end;
                    //<< 12-09-18 ZY-LD 018

                    //>> 13-08-19 ZY-LD 033
                    if (recSalesLine."Ship-to Code" <> SalesHeader."Ship-to Code") and
                       (recSalesLine."Ship-to Code" <> SalesHeader."Ship-to Code Del. Doc")  //20-05-24 ZY-LD 145
                    then
                        Error(lText013, SalesHeader.FieldCaption(SalesHeader."Ship-to Code"), recSalesLine."Ship-to Code", recSalesLine."Document No.", recSalesLine."Line No.", SalesHeader."Ship-to Code");
                    //<< 13-08-19 ZY-LD 033

                    //>> 30-08-19 ZY-LD 036
                    if recSalesLine."Shipment Date" = 99990101D then
                        Error(lText041, recSalesLine.FieldCaption("Shipment Date"), recSalesLine."Shipment Date");
                    if recSalesLine."Planned Delivery Date" = 99990101D then
                        Error(lText041, recSalesLine.FieldCaption("Planned Delivery Date"), recSalesLine."Planned Delivery Date");
                    if recSalesLine."Planned Shipment Date" = 99990101D then
                        Error(lText041, recSalesLine.FieldCaption("Planned Shipment Date"), recSalesLine."Planned Shipment Date");
                    //<< 30-08-19 ZY-LD 036

                    ValidateDimensionsOnRelease(recSalesLine."Document No.", recSalesLine."Dimension Set ID");  // 04-02-21 ZY-LD 079

                    //>> 09-03-21 ZY-LD 080
                    if (ItemLogisticEvents.MainWarehouseLocation(recSalesLine."Location Code")) and
                       (((recSalesLine."Document Type" = recSalesLine."document type"::Invoice) and
                         (recSalesLine."Shipment No." = '')) or
                        ((recSalesLine."Document Type" = recSalesLine."document type"::"Credit Memo") and
                         (recSalesLine."Return Receipt No." = '')))
                    then
                        if not Confirm(lText023, false, recSalesLine."Document Type", recSalesLine."Location Code") then
                            Error('');
                    //<< 09-03-21 ZY-LD 080

                    //>> 18-10-21 ZY-LD 101
                    if GuiAllowed() then
                        if (not recSalesLine."Completely Shipped") and
                           (recSalesLine."Overshipment Line No." = 0)
                        then begin
                            recCustOvership.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                            recCustOvership.SetFilter("Item No.", '%1|%2', '', SalesHeader."No.");
                            if recCustOvership.FindLast() then begin
                                recGenProdPostGrp.Get(recSalesLine."Gen. Prod. Posting Group");
                                if recGenProdPostGrp.Type <> recGenProdPostGrp.Type::Overshipment then
                                    if not Confirm(lText027, true, recSalesLine."Line No.") then
                                        Error('');
                            end;
                        end;
                    //<< 18-10-21 ZY-LD 101

                    //>> 06-07-22 ZY-LD 122
                    if not SI.GetWarehouseManagement then
                        if recItem."Freight Cost Item" and
                           (recSalesLine."Outstanding Quantity" <> 0) and
                           (recSalesLine."Freight Cost Related Line No." = 0)
                        then
                            if not confirm(lText038, false, recItem."No.", recSalesLine.FieldCaption("Freight Cost Related Line No.")) then  // 17-07-24 ZY-LD 151
                                error('');
                    //Error(lText031, recItem."No.", recSalesLine.FieldCaption("Freight Cost Related Line No."));  // 17-07-24 ZY-LD 151
                    //<< 06-07-22 ZY-LD 122

                    recSalesLine.Status := recSalesLine.Status::Released;
                    recSalesLine.Modify();
                until recSalesLine.Next() = 0;
            //<< 01-03-19 ZY-LD 023

            // 001: >>
            CreateBOMLines(SalesHeader);
            // 001: <<
        end;

        if GuiAllowed() then
            if not SalesHeader."Curr. Code Sales Doc SUB Acc." then begin
                recCust.Get(SalesHeader."Sell-to Customer No.");
                if (SalesHeader."Currency Code Sales Doc SUB" <> recCust."Currency Code") and
                   (SalesHeader."Currency Code Sales Doc SUB" <> '')
                then
                    if Confirm(lText024, true, SalesHeader."Currency Code Sales Doc SUB") then begin
                        SalesHeader."Curr. Code Sales Doc SUB Acc." := true;
                        SalesHeader.Modify(true);
                    end else
                        Error('');
            end;

        if not SalesHeader."eCommerce Order" then begin  // 15-06-22 ZY-LD 121
                                                         /*IF "Ship-to Country/Region Code" <> COPYSTR("Ship-to VAT",1,2) THEN
                                                           ERROR(lText032,FieldCaption("Ship-to Country/Region Code"),"Ship-to Country/Region Code",FieldCaption("Ship-to VAT"),COPYSTR("Ship-to VAT",1,2));*/

            if SalesHeader."VAT Registration No. Zyxel" = '' then
                SalesHeadEvent.SetZyxelVATRegistrationNo(SalesHeader, SalesHeader, 0);
            SalesHeader.TestField(SalesHeader."VAT Registration No. Zyxel");
        end;
        //<< 06-07-21 ZY-LD 090
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header")
    var
        recActCode: Record "Action Codes";
        recDefAction: Record "Default Action";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        AutoConfirm: Codeunit "Pick. Date Confirm Management";
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
        SI: Codeunit "Single Instance";
    begin
        //>> 23-03-20 ZY-LD 054
        if SalesHeader."Document Type" = SalesHeader."document type"::Order then begin
            case SalesHeader."Sales Order Type" of
                SalesHeader."sales order type"::Normal:
                    SalesHeadEvent.UpdateUnshippedQuantity(SalesHeader."Sell-to Customer No.");

                SalesHeader."sales order type"::"Spec. Order":
                    begin
                        recActCode.SetRange("Sales Order Type", recActCode."sales order type"::"Spec. Order");
                        if recActCode.FindSet() then
                            repeat
                                recDefAction.SetRange("Source Type", recDefAction."source type"::Customer);
                                recDefAction.SetRange("Source Code", SalesHeader."Sell-to Customer No.");
                                recDefAction.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
                                recDefAction.SetRange("Action Code", recActCode.Code);
                                recDefAction.SetRange("Header / Line", recDefAction."header / line"::Header);
                                recDefAction.SetRange("Sales Order Type", recActCode."Sales Order Type");
                                if recDefAction.IsEmpty() then begin
                                    recDefAction.Validate("Source Type", recDefAction."source type"::Customer);
                                    recDefAction.Validate("Source Code", SalesHeader."Sell-to Customer No.");
                                    recDefAction.Validate("Customer No.", SalesHeader."Sell-to Customer No.");
                                    recDefAction.Validate("Action Code", recActCode.Code);
                                    recDefAction.Validate("Header / Line", recDefAction."header / line"::Header);
                                    recDefAction.Insert();
                                end;
                            until recActCode.Next() = 0;
                    end;
            end;
        end;

        SI.SetManualChange(true);  // 19-01-18 ZY-LD 017
    end;

    #region Local Procedure
    local procedure CreateBOMLines(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        Item: Record Item;
        LineNo: Integer;
        BOMAmount: Decimal;
        BOMComp: Record "BOM Component";
    begin
        //>> 01-03-19 ZY-LD 023
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("BOM Line No.", 0);
        if SalesLine.FindSet() then
            repeat
                Item.SetAutoCalcFields("Assembly BOM");
                if Item.Get(SalesLine."No.") and Item."Assembly BOM" then begin
                    SalesLine2.Reset();
                    SalesLine2.SetRange("Document Type", SalesLine."Document Type");
                    SalesLine2.SetRange("Document No.", SalesLine."Document No.");
                    SalesLine2.SetRange("BOM Line No.", SalesLine."Line No.");
                    if not SalesLine2.FindSet(true) then begin
                        LineNo := SalesLine."Line No.";

                        // For BOM lines the quantities are reversed and the line hidden
                        // The BOM items are then entered and hidden
                        BOMAmount := 0;
                        BOMComp.SetRange("Parent Item No.", Item."No.");
                        if BOMComp.FindSet() then
                            repeat
                                LineNo := LineNo + 100;
                                NewSalesLine(LineNo, SalesLine."Line No.", SalesLine.Quantity * BOMComp."Quantity per", BOMComp."No.", SalesHeader, SalesLine2);
                                BOMAmount := BOMAmount + SalesLine2."Line Amount";
                            until BOMComp.Next() = 0;

                        LineNo := LineNo + 100;
                        NewSalesLine(LineNo, SalesLine."Line No.", -SalesLine.Quantity, SalesLine."No.", SalesHeader, SalesLine2);
                        if (SalesLine2.Quantity <> 0) and (BOMAmount <> 0) then begin
                            SalesLine2.Validate("Unit Price", BOMAmount / SalesLine2.Quantity);
                            SalesLine2.Validate("Line Amount", -BOMAmount);
                        end;
                        SalesLine2.Modify();
                    end;
                end;
            until SalesLine.Next() = 0;
        //<< 01-03-19 ZY-LD 023
    end;

    local procedure NewSalesLine(LineNo: Integer; BOMLineNo: Integer; Qty: Decimal; ItemNo: Code[20]; SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        //>> 01-03-19 ZY-LD 023
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetSalesHeader(SalesHeader);
        SalesLine.Init();
        SalesLine."Line No." := LineNo;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine.Type := SalesLine.Type::Item;
        SalesLine.Validate(Type);
        SalesLine.Validate("No.", ItemNo);
        SalesLine.Validate(Quantity, Qty);
        SalesLine.Validate(SalesLine."Unit Price", 0);
        SalesLine."BOM Line No." := BOMLineNo;
        SalesLine."Hide Line" := true;
        SalesLine.Insert();
    end;

    local procedure ValidateDimensionsOnRelease(pNo: Code[20]; pDimSetID: Integer)
    var
        recDimSetEntry: Record "Dimension Set Entry";
        recGenLedgerSetup: Record "General Ledger Setup";
        DimensionCode: Code[20];
        i: Integer;
        lText001: Label 'Dimension "%1" is missing on Sales Order %2.\Please contact the Finance Department to have the Dimension updated on the sales order and on the customer card.';
    begin
        //>> 04-02-21 ZY-LD 079
        recGenLedgerSetup.Get();
        recDimSetEntry.SetRange("Dimension Set ID", pDimSetID);
        for i := 1 to 3 do begin
            case i of
                1:
                    DimensionCode := recGenLedgerSetup."Global Dimension 1 Code";
                2:
                    DimensionCode := recGenLedgerSetup."Global Dimension 2 Code";
                3:
                    DimensionCode := recGenLedgerSetup."Shortcut Dimension 3 Code";
            end;
            recDimSetEntry.SetRange("Dimension Code", DimensionCode);
            if not recDimSetEntry.FindFirst() or (recDimSetEntry."Dimension Value Code" = '') then
                Error(lText001, DimensionCode, pNo);
        end;
        //<< 04-02-21 ZY-LD 079
    end;

    local procedure ValidateDimensionsOnRelease2(SalesHeader: Record "Sales Header")
    var
        Cust: Record Customer;
        GenLedgSetup: Record "General Ledger Setup";
        DefaultDim: Record "Default Dimension";
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        DimValueLocated: Boolean;
        lText001: Label 'Dimension "%1" is not set for document %2';
        lText002: Label 'Dimension "%1" "%2" on the "Sales %4" %5 is not a valid dimension for customer %3.\\Please contact the accounting manager to setup the dimension on the customer, or change the dimension value on the "Sales %4".';

    begin
        //>> 23-08-24 ZY-LD x001
        Cust.get(SalesHeader."Sell-to Customer No.");
        if Cust."Sample Account" then begin
            GenLedgSetup.get;
            DimSetEntry.SetRange("Dimension Set ID", SalesHeader."Dimension Set ID");
            DimSetEntry.SetRange("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
            If not DimSetEntry.FindFirst then
                Error(lText001, GenLedgSetup."Shortcut Dimension 3 Code", SalesHeader."No.");

            DefaultDim.SetRange("Table ID", Database::"Customer");
            DefaultDim.SetRange("No.", Cust."No.");
            DefaultDim.SetRange("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
            if DefaultDim.FindFirst then begin
                DimValue.SetRange("Dimension Code", GenLedgSetup."Shortcut Dimension 3 Code");
                DimValue.SetRange(Blocked, false);
                if DefaultDim."Allowed Values Filter" <> '' then
                    DimValue.SetFilter(Code, DefaultDim."Allowed Values Filter")
                else
                    DimValue.SetRange(Code, DefaultDim."Dimension Value Code");
                If DimValue.FindSet then
                    Repeat
                        DimValueLocated := DimSetEntry."Dimension Value Code" = DimValue.Code;
                    Until (DimValue.Next() = 0) or DimValueLocated;

                if not DimValueLocated then
                    Error(lText002, GenLedgSetup."Shortcut Dimension 3 Code", DimSetEntry."Dimension Value Code", Cust."No.", Format(SalesHeader."Document Type"), SalesHeader."No.");
            end;
        end;
        //<< 23-08-24 ZY-LD x001
    end;
    #endregion
}
