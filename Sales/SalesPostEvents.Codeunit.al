codeunit 50080 "Sales Post Events"
{
    // 001. 30-01-18 ZY-LD 2017121210000066 - Check on machine code.
    // 002. 01-03-18 ZY-LD 2018021910000301 - On credit memos we need to fill out "Ship-to Country" if "Return Reason Code" is 1.
    // 003. 13-03-18 ZY-LD 2018031310000276 - "Bill-to Country/Region Code" is used as a dimension on VAT-Entries, and must not be blank.
    // 004. 29-10-18 ZY-LD 2018102910000036 - A test was missing.
    // 005. 12-11-18 ZY-LD 2018111310000028 - Confirm comment on the document on specific customers.
    // 006. 26-11-18 ZY-LD 2018112610000165 - Error when deleteing empty invoice.
    // 007. 10-01-19 PAB - Set the EDI flag on the Invoice
    // 008. 29-01-19 ZY-LD 000 - Ship-to Name, Ship-to Address, Ship-to Post Code and Ship-to City must be filled on Italian Credit Memo.
    // 009. 01-02-19 ZY-LD 2019012210000082 - Validate for E-Invoice.
    // 010. 14-02-19 ZY-LD 2019021410000087 - When "Hide Line" then "Unit Price" must be zero.
    // 011. 28-02-19 ZY-LD 2019022810000391 - Shipping date must be filled.
    // 012. 28-02-19 ZY-LD 2019022010000075 - Handle consignment stock.
    // 013. 27-03-19 PAB 2019032710000061 - Changed shipment date.
    // 014. 12-04-19 ZY-LD P0217 - Fill "Invoice No. for End Customer".
    // 015. 09-05-19 ZY-LD 2019050910000028 - Handle only if not temporary.
    // 016. 23-05-19 ZY-LD P0236 - Store VAT Registration No. on the posted document.
    // 017. 29-05-19 ZY-LD 2019052910000035 - "Bill-to Customer No." must be equal to "Bill-to Customer No." on the sales order.
    // 018. 27-06-19 ZY-LD 2019062610000101 - Error must only occur on the main warehouse location.
    // 019. 10-07-19 ZY-LD P0213 - Update unshipped quantity.
    // 020. 08-08-19 ZY-LD 2019080810000088 - Not Temporary.
    // 021. 13-08-19 ZY-LD 2019081310000131 - Unit Cost must not be zero on samples.
    // 022. 22-08-19 ZY-LD 2019080710000106 - VAT Registration No. must be specific on customer level.
    // 023. 06-09-19 ZY-LD P0290 - Set EiCard to Posted.
    // 024. 03-10-19 ZY-LD P0312 - Send automatic e-mail.
    // 025. 29-10-19 ZY-LD 000 - Check if EiCard is ready to post.
    // 026. 04-11-19 ZY-LD 2019110410000025 - Send only unshipped it if aint EiCard.
    // 027. 13-11-19 ZY-LD P0332 - Update Delivery Document.
    // 028. 15-11-19 ZY-LD 0282019102510000121 - Update Document Date on the line.
    // 029. 18-11-19 ZY-LD 000 - Sales Price must not be Zero.
    // 030. 21-11-19 ZY-LD 2019022810000391 - Not for invoices to Denmark.  // 21-01-20 ZY-LD Not for local DE invoice.
    // 031. 14-02-20 ZY-LD 000 - Test of location code.
    // 032. 21-02-20 ZY-LD 2020022010000081 - We posted wrong invoice 20-2000948 because of this, so it has been removed again.
    // 033. 03-02-20 ZY-LD 000 - Block customer price group.
    // 034. 26-03-20 ZY-LD 2020032510000071 - Quantity is added.
    // 035. 30-04-20 ZY-LD 2020042210000092 - If it´s a g/l account invoice, location code must be blank. This makes sure that we pick the correct Zyxel VAT Registration No.
    // 036. 04-05-20 ZY-LD P0420 - Set document status to posted.
    // 037. 04-05-20 ZY-LD 000 - Test on mandatory return reason code.
    // 038. 08-09-20 ZY-LD 2020090810000109 - On specific codes must the unit price be zero.
    // 039. 09-09-20 ZY-LD 2020090410000045 - "VAT Registration No. Zyxel" must be based on "Ship-to Country Code".
    // 040. 21-09-20 ZY-LD 2020091610000068 - "Line Discount Amount" is added.
    // 041. 01-12-20 ZY-LD 000 - If a delivery is reversed, we have to clear the sales order line, so it can be attached to another delivery document.
    // 042. 04-02-21 ZY-LD P0557 - Sample Setup.
    // 043. 03-05-21 ZY-LD 000 - In some countries it´s not allowed to give away items.
    // 044. 20-05-21 ZY-LD 000 - Post Item Charge Assignment and code has moved to separate function. Charge (Item) must have a price and be hidden.
    // 045. 21-06-21 ZY-LD 2021061810000139 - From time to time invoices get posted with wrong posting groups, therefore we have now setup a validation.
    // 046. 23-06-21 ZY-LD 000 - Data moved from table 36.
    // 047. 27-07-21 ZY-LD 2021072710000049 - Check only if not invoiced.
    // 048. 31-08-21 ZY-LD 000 - Don´t send if it´s eCommerce.
    // 049. 31-08-21 ZY-LD 000 - Archive eCommerce Orders.
    // 050. 15-09-21 ZY-LD 2021091310000081 - Test on Your Reference.
    // 051. 15-09-21 ZY-LD 2021091510000077 - It happens that users key in a type when it´s a comment line.
    // 052. 20-09-21 ZY-LD 000 - Test only if there are something to post.
    // 053. 05-10-21 ZY-LD 2021100410000068 - Instead of quantity we now test on quantity to ship and invoice.
    // 054. 12-01-21 ZY-LD 2021101110000091 - Skip on credit memo.
    // 055. 26-01-21 ZY-LD 000 - "External Invoice No." must be a part of the filter.
    // 056. 16-12-21 ZY-LD P0719 - "Freight Approval No." can be blocked after sales invoice has been posted.
    // 057. 01-03-22 ZY-LD 2022022810000063 - Get the user to approve the posting date.
    // 058. 29-03-22 ZY-LD 000 - Posting Date is added to eCommerce archive.
    // 059. 13-04-22 ZY-LD 000 - Finance needs the "Sales Shipment No." on the list.
    // 060. 25-04-22 ZY-LD 2022042510000261 - Prevent Negative Inventory based on Location Code. // 10-08-22 ZY-LD 000 - The code has been removed again.
    // 061. 24-05-22 ZY-LD 2022052310000147 - If zero amount once is accepted, we don´t wan´t to accept it again.
    // 062. 17-10-22 ZY-LD 000 - We saw that eCommerce orders was posted, eventhough it has been marked in the "Error Description" on the eCommerce Order.
    // 063. 13-12-22 ZY-LD 2022121310000045 - Don´t block "Freight Approval Number".
    // 064. 05-01-22 ZY-LD 000 - "Transaction Type" = Order can sometimes be a credit memo.
    // 065. 15-02-23 ZY-LD #4831909 - ZNet does not intercompany to Italian company.
    // 066. 23-02-23 ZY-LD 000 - GLC License.
    // 067. 27-02-23 ZY-LD 000 - Code has been moved.
    // 068. 06-09-23 ZY-LD 000 - It happend that an error occured after the archive insert, and then was only the lines inserted into archive an not the header.
    // 069. 23-10-23 ZY-LD 000 - Unit Cost must alway have a value on both invoice and credit memo.
    // 070. 21-02-24 ZY-LD 000 - In the nordic countries is the payment terms code wrong because of the merge.
    // 071. 19-04-24 ZY-LD
    // 072. 19-06-24 ZY-LD 000 - If a new item has been posted with a purchase invoice without price, we will also accept a sales invoice without price.
    // 073. 13-09-24 ZY-LD 000 - The sales order must be deleted when the matching invoice is posted.
    // 074. 24-09-24 ZY-LD 000 - NL to DK Posting.

    Permissions = TableData "Inventory Setup" = m,
                  TableData "Dimension Value" = rm,
                  TableData "IC Dimension Value" = rm,
                  TableData "IC Outbox Sales Header" = m,
                  TableData "Dimension Set Entry" = r,
                  TableData "Warehouse Inbound Header" = m,
                  tabledata "Sales Invoice Header" = m,
                  Tabledata "Sales Cr.Memo Header" = m;

    trigger OnRun()
    begin
    end;

    var
        recServEnviron: Record "Server Environment";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        Text001: Label '"%1" must be filled.\Please contact the Accounting Manager.';
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
        EmailMgt: Codeunit "E-mail Address Management";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        recSaleLine: Record "Sales Line";
        recSaleLine2: Record "Sales Line";
        recItem: Record Item;
        recCust: Record Customer;
        recBillToCust: Record Customer;
        recInvSetup: Record "Inventory Setup";
        recPostGrpCtryLoc: Record "Post Grp. pr. Country / Loc.";
        recVATRegNoMatrix: Record "VAT Reg. No. pr. Location";
        recGenBusPostGrp: Record "Gen. Business Posting Group";
        recDelDocHead: Record "VCK Delivery Document Header";
        recCustPriceGrp: Record "Customer Price Group";
        recGPPGrpRetReason: Record "G.P.P. Group Ret. Reason Relat";
        recAmzOrderHead: Record "eCommerce Order Header";
        recAddEicardOrderInfo: Record "Add. Eicard Order Info";
        recLocation: Record Location;
        ItemLedgEntry: Record "Item Ledger Entry";
        SaleslinecheckDD: Record "Sales Line";
        ItemWithZeroPriceFound: Boolean;
        showwarning: Boolean;
        QtyItems: Integer;
        lText001: Label 'Additional item lines must not have a value in "%1".';
        lText002: Label 'You must enter "%1" on item no. "%2" (line %3).';
        lText003: Label 'Because of "Wee Reporting" you need to fill out the "Ship-from Country/Region Code" when "%1" is 1.';
        lText004: Label '"%1" must be filled on Italian invoices.';
        lText005: Label 'Value is not valid in "%1". Expected value is %2.';
        lText006: Label '"%1" must not be 0,00 on sales order %2 line no. %3.';
        lText007: Label '"%1" must  be 0,00 on sales order %2 line no. %3.';
        lText008: Label 'EiCard order %1 is not ready to post.';
        lText009: Label 'Number of lines on the sales invoice does not match number of lines on the delivery document.\Sales Invoice: %1\Delivery Document: %2\\Do you want to continue?';
        lText010: Label 'Total quantity on the sales invoice does not match total quantity on the delivery document.\Sales Invoice: %1\Delivery Document: %2\\Do you want to continue?';
        lText011: Label 'Amount on the sales invoice is different from amount on the delivery document.\Sales Invoice: %1.\Delivery Document: %2.\\Do you want to continue?';
        lText012: Label '"%1" is missing on one or more lines on the sales %2 %3.';
        lText013: Label '\\Do you want to continue?';
        lText014: Label '"Location Code" on the sales header and the sales line must not be different.';
        lText015: Label '"%1" %2 is blocked.';
        lText016: Label '"Location Code" on the sales line must not be blank, when "Type = Item".';
        lText017: Label '"Location Code" on a "G/L Account" invoice must be blank.';
        lText018: Label '"%1" %2 is mandatory for "%3" %4.';
        lText019: Label '"%1" must not be blank on "%2" %3.';
        lText020: Label '"%1" must be zero on line no. %2.';
        lText021: Label '"%1" must  be identical with "%4" on document no. %2 line no. %3.';
        lText022: Label '"%1" must be 0,00 on %4 sales order %2 line no. %3.';
        lText023: Label 'There is no "%1" within the filter.\\%2\\Please contact the Finance Department for the setup.';
        lText024: Label '"%1" must be less than or equal to %2 on line no. %3.';
        lText025: Label 'If "%1" is set "%2" must be zero on "%3" "%4" "%5" .';
        lText026: Label '"%1" is wrong.\\Value: %2.\Expected Value: %3.';
        lText027: Label '\\For credit memos, you might set "Sell-to Country/Region Code" = "Ship-to Country/Region Code" from the invoice if you have copied the document.';
        lText028: Label '"%1" is different from todays date.\Are you sure that you wan´t to post the document with "%1" %2?';
        lText029: Label 'Amount on Sales Header %1 %2 do not equal amount %3 on eCommerce order %4.';
        lText030: Label 'Quantity %1 and "%2 security" %3 does not match.';
        lText031: Label 'Clear "%1" when "%2" is zero on line no. %3.';
        lText032: Label '"%1" %2 on %3 is different from "%1" %4 on %5.';
        lText033: Label 'When posting damage items in warehouse management the "%1" must be zero.';
        showwarningLabel: Label 'The customer do not allow invoice before delivered status, do want to check Del. document before invoocing';
        showwarningerror: Label 'Invoicing stopped';
    begin
        with SalesHeader do begin
            if GuiAllowed() then
                //>> 01-03-22 ZY-LD 057
                if not "eCommerce Order" then
                    if "Posting Date" <> Today then
                        if not Confirm(lText028, false, FieldCaption("Posting Date"), "Posting Date") then
                            Error('');
            //<< 01-03-22 ZY-LD 057

            ValidateAddPostGrpPrLocation(SalesHeader);  // 21-06-21 ZY-LD 045
            SI.SetAllowToDeleteAddItem(true);
            //>> 02-03-23 ZY-LD 068
            if "Skip Verify on Inventory" then
                SI.SetSkipVerifyOnInventory(true);
            //<< 02-03-23 ZY-LD 068
            //>> 30-04-20 ZY-LD 035
            if "Document Type" in ["document type"::Order, "document type"::Invoice] then
                if ("Location Code" = '') and ("Sales Order Type" <> "sales order type"::"G/L Account") then
                    Error(lText019, FieldCaption("Location Code"), FieldCaption("Sales Order Type"), "Sales Order Type");
            //<< 30-04-20 ZY-LD 035

            //>> 23-06-21 ZY-LD 046
            if not "eCommerce Order" then begin
                TestField("VAT Registration No. Zyxel");  // Consumers in eCommerce doesn´t have a VAT Reg. No.
                recVATRegNoMatrix.SetAutoCalcFields("VAT Registration No.");
                recVATRegNoMatrix.SetRange("Location Code", "Location Code");
                if ("Ship-to Country/Region Code" = '') or ("Document Type" IN ["Document type"::"Return Order", "Document type"::"Credit Memo"]) then
                    recVATRegNoMatrix.SetFilter("Ship-to Customer Country Code", '%1|%2', "Sell-to Country/Region Code", '')
                else
                    recVATRegNoMatrix.SetFilter("Ship-to Customer Country Code", '%1|%2', "Ship-to Country/Region Code", '');

                recVATRegNoMatrix.SetFilter("Sell-to Customer No.", '%1|%2', "Sell-to Customer No.", '');
                if not recVATRegNoMatrix.FindLast() then
                    Error(lText023, recVATRegNoMatrix.TableCaption(), recVATRegNoMatrix.GetFilters())
                else
                    if "VAT Registration No. Zyxel" <> recVATRegNoMatrix."VAT Registration No." then
                        if "Document Type" = "document type"::"Credit Memo" then begin
                            if not "Skip Posting Group Validation" then  // 12-01-21 ZY-LD 054
                                Error(lText026 + lText027, FieldCaption("VAT Registration No. Zyxel"), "VAT Registration No. Zyxel", recVATRegNoMatrix."VAT Registration No.")
                        end else
                            Error(lText026, FieldCaption("VAT Registration No. Zyxel"), "VAT Registration No. Zyxel", recVATRegNoMatrix."VAT Registration No.");
            end else begin
                //>> 17-10-22 ZY-LD 062
                if ZGT.IsRhq and (not Correction) then begin
                    CalcFields("Amount Including VAT");
                    recAmzOrderHead.SetCurrentkey("Sales Document Type", "eCommerce Order Id", "Invoice No.");  // 05-01-23 ZY-LD 064
                    recAmzOrderHead.SetAutoCalcFields("Amount Including VAT");
                    //recAmzOrderHead.SETRANGE("Transaction Type","Document Type"-2);  // 05-01-23 ZY-LD 064
                    recAmzOrderHead.SetRange("Sales Document Type", "Document Type");  // 05-01-23 ZY-LD 064
                    recAmzOrderHead.SetRange("eCommerce Order Id", "External Document No.");
                    recAmzOrderHead.SetRange("Invoice No.", "External Invoice No.");
                    recAmzOrderHead.FindFirst();
                    // It happens that the shipping has been credited on a "Transaction Type" = Order. Document Type and Tranaction Type will then not match.
                    //>> 05-01-23 ZY-LD 064
                    if ("Document Type" = "document type"::"Credit Memo") and (recAmzOrderHead."Transaction Type" = recAmzOrderHead."transaction type"::Order) then
                        recAmzOrderHead."Amount Including VAT" := -recAmzOrderHead."Amount Including VAT";
                    //<< 05-01-23 ZY-LD 064

                    if Abs(recAmzOrderHead."Amount Including VAT" - "Amount Including VAT") >= 1 then
                        Error(lText029, "No.", "Amount Including VAT", recAmzOrderHead."Amount Including VAT", "External Document No.");
                end;
                //<< 17-10-22 ZY-LD 062
            end;
            //>> 23-05-19 ZY-LD 016
            /*IF "VAT Registration No. Zyxel" = '' THEN BEGIN
              recVATRegNoMatrix.SETAUTOCALCFIELDS("VAT Registration No.");
              recVATRegNoMatrix.SETRANGE("Location Code","Location Code");
              //>> 09-09-20 ZY-LD 039
              IF "Ship-to Country/Region Code" <> '' THEN
                recVATRegNoMatrix.SETFILTER("Ship-to Customer Country Code",'%1|%2',"Ship-to Country/Region Code",'')
              ELSE  //<< 09-09-20 ZY-LD 039
                recVATRegNoMatrix.SETFILTER("Ship-to Customer Country Code",'%1|%2',"Sell-to Country/Region Code",'');
              recVATRegNoMatrix.SETFILTER("Sell-to Customer No.",'%1|%2',"Sell-to Customer No.",'');  // 22-08-19 ZY-LD 022
              IF NOT recVATRegNoMatrix.FINDLAST THEN
                ERROR(lText023,recVATRegNoMatrix.TABLECAPTION,recVATRegNoMatrix.GETFILTERS);
              recVATRegNoMatrix.TESTFIELD("VAT Registration No.");  // 22-08-19 ZY-LD 022
              "VAT Registration No. Zyxel" := recVATRegNoMatrix."VAT Registration No.";
            END;*/
            //<< 23-06-21 ZY-LD 046

            if ("Ship-to VAT" = '') and (not "eCommerce Order") then begin
                recCust.Get("Sell-to Customer No.");
                "Ship-to VAT" := recCust."VAT Registration No.";
            end;
            //<< 23-05-19 ZY-LD 016

            //>> 21-02-24 ZY-LD 070
            if SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] then begin
                recBillToCust.get(SalesHeader."Bill-to Customer No.");
                if recBillToCust."Payment Terms Code" <> SalesHeader."Payment Terms Code" then
                    if GuiAllowed then begin
                        if not confirm(lText032 + ltext013, false,
                               SalesHeader.FieldCaption("Payment Terms Code"),
                               recBillToCust."Payment Terms Code",
                               recbilltocust.TableCaption,
                               SalesHeader."Payment Terms Code",
                               salesheader."Document Type")
                        then
                            error('');
                    end else
                        error(lText032,
                            SalesHeader.FieldCaption("Payment Terms Code"),
                            recBillToCust."Payment Terms Code",
                            recbilltocust.TableCaption,
                            SalesHeader."Payment Terms Code",
                            salesheader."Document Type");

                // 453154 >>
                if GuiAllowed and SalesHeader.Invoice and recBillToCust."Warning on Not-delivery" then begin
                    SaleslinecheckDD.setrange("Document Type", salesheader."Document Type");
                    SaleslinecheckDD.setrange("Document No.", SalesHeader."No.");
                    SaleslinecheckDD.setfilter("Qty. to Invoice", '<>%1', 0);
                    if SaleslinecheckDD.findset then
                        repeat
                            if SaleslinecheckDD."Warehouse Status" <> SaleslinecheckDD."Warehouse Status"::Delivered then
                                showwarning := true;
                        until (SaleslinecheckDD.next = 0) or showwarning;
                    IF showwarning then
                        if not confirm(showwarninglabel, true) then
                            error(showwarningerror);

                end;
                // 453154 <<
            end;
            //<< 21-02-24 ZY-LD 070

            //>> 28-02-19 ZY-LD 012
            //>> Sales Line
            if not recPostGrpCtryLoc.Get("Sell-to Country/Region Code", "Location Code") then;
            recSaleLine.Reset();
            recSaleLine.SetRange("Document Type", "Document Type");
            recSaleLine.SetRange("Document No.", "No.");
            //recSaleLine.SETrange(Type,recSaleLine.Type::"G/L Account",recSaleLine.Type::Item);  // 30-04-20 ZY-LD 035 - G/L Account is added.  // 21-05-21 ZY-LD 044
            recSaleLine.SetFilter(Type, '<>%1', recSaleLine.Type::" ");  // 21-05-21 ZY-LD 044
            if recSaleLine.FindSet() then begin
                repeat
                    case recSaleLine.Type of
                        recSaleLine.Type::"G/L Account":
                            begin
                                //>> 21-05-21 ZY-LD 044
                                if recSaleLine."Hide Line" and
                                   (recSaleLine."Unit Price" <> 0) and
                                   //(recSaleLine.Quantity <> 0) AND  // 05-10-21 ZY-LD 053
                                   ((recSaleLine."Qty. to Ship" <> 0) or (recSaleLine."Qty. to Invoice" <> 0)) and  // 05-10-21 ZY-LD 053
                                   (not GlAccIsReverseLineToChargeItem(recSaleLine))
                                then
                                    Error(lText025, recSaleLine.FieldCaption("Hide Line"), recSaleLine.FieldCaption("Unit Price"), TableCaption(), recSaleLine."Document No.", recSaleLine."Line No.");
                                //<< 21-05-21 ZY-LD 044

                                //>> 30-04-20 ZY-LD 035
                                recSaleLine2.SetRange("Document Type", "Document Type");
                                recSaleLine2.SetRange("Document No.", "No.");
                                recSaleLine2.SetRange(Type, recSaleLine.Type::Item);
                                if recSaleLine2.IsEmpty() and ("Sales Order Type" = "sales order type"::"G/L Account") and (recSaleLine."Location Code" <> '') then
                                    Error(lText017);
                                //<< 30-04-20 ZY-LD 035

                                //>> 15-09-21 ZY-LD 051
                                recSaleLine.TestField("Gen. Bus. Posting Group");
                                recSaleLine.TestField("Gen. Prod. Posting Group");
                                recSaleLine.TestField("VAT Bus. Posting Group");
                                recSaleLine.TestField("VAT Prod. Posting Group");
                                //<< 15-09-21 ZY-LD 051
                            end;
                        recSaleLine.Type::Item:
                            begin
                                if recSaleLine."No." <> '' then begin
                                    //>> 21-05-21 ZY-LD 044
                                    if not recSaleLine."Completely Invoiced" then  // 27-07-21 ZY-LD 047
                                        if recSaleLine."Hide Line" and
                                           (recSaleLine."Unit Price" <> 0) and
                                           //(recSaleLine.Quantity <> 0)  // 05-10-21 ZY-LD 053
                                           ((recSaleLine."Qty. to Ship" <> 0) or (recSaleLine."Qty. to Invoice" <> 0))  // 05-10-21 ZY-LD 053
                                        then
                                            Error(lText025, recSaleLine.FieldCaption("Hide Line"), recSaleLine.FieldCaption("Unit Price"), TableCaption(), recSaleLine."Document No.", recSaleLine."Line No.");
                                    //<< 21-05-21 ZY-LD 044
                                    if recPostGrpCtryLoc."VAT Prod. Post. Group - Sales" <> '' then
                                        if recSaleLine."VAT Prod. Posting Group" <> recPostGrpCtryLoc."VAT Prod. Post. Group - Sales" then
                                            Error(lText005, recSaleLine.FieldCaption("VAT Prod. Posting Group"), recPostGrpCtryLoc."VAT Prod. Post. Group - Sales");
                                    if recPostGrpCtryLoc."Line Discount %" <> 0 then
                                        if recSaleLine."Line Discount %" <> recPostGrpCtryLoc."Line Discount %" then
                                            Error(lText005, recSaleLine.FieldCaption("Line Discount %"), recPostGrpCtryLoc."Line Discount %");
                                    //>> 04-05-20 ZY-LD 037
                                    recGPPGrpRetReason.SetRange("Gen. Prod. Posting Group", recSaleLine."Gen. Prod. Posting Group");
                                    recGPPGrpRetReason.SetRange(Mandatory, true);
                                    if recGPPGrpRetReason.FindFirst() and (recSaleLine."Return Reason Code" <> recGPPGrpRetReason."Return Reason Code") then
                                        Error(lText018, recSaleLine.FieldCaption("Return Reason Code"), recSaleLine."Return Reason Code", recSaleLine.FieldCaption("Gen. Prod. Posting Group"), recSaleLine."Gen. Prod. Posting Group");
                                    //<< 04-05-20 ZY-LD 037
                                    //>> 08-09-20 ZY-LD 038
                                    recGPPGrpRetReason.Reset();
                                    if recGPPGrpRetReason.Get(recSaleLine."Gen. Prod. Posting Group", recSaleLine."Return Reason Code") then begin
                                        if recGPPGrpRetReason."Sales Unit Price Must be Zero" then
                                            if recSaleLine."Unit Price" <> 0 then
                                                Error(lText020, recSaleLine.FieldCaption("Unit Price"), recSaleLine."Line No.");
                                        //>> 03-05-21 ZY-LD 043
                                        if recGPPGrpRetReason."Max. Sales Unit Price" <> 0 then
                                            if ((recSaleLine."Qty. to Ship" <> 0) or (recSaleLine."Qty. to Invoice" <> 0)) and  // 20-09-21 ZY-LD 052
                                               (recSaleLine."Unit Price" > recGPPGrpRetReason."Max. Sales Unit Price")
                                            then
                                                Error(lText024, recSaleLine.FieldCaption("Unit Price"), recGPPGrpRetReason."Max. Sales Unit Price", recSaleLine."Line No.");
                                        //<< 03-05-21 ZY-LD 043
                                    end;
                                    //<< 08-09-20 ZY-LD 038

                                    //>> 13-08-19 ZY-LD 021
                                    if not recSaleLine."Hide Line" then begin
                                        recGenBusPostGrp.Get(recSaleLine."Gen. Bus. Posting Group");
                                        if recGenBusPostGrp."Sample / Test Equipment" > recGenBusPostGrp."sample / test equipment"::" " then begin
                                            if (recSaleLine."Qty. to Ship" <> 0) or (recSaleLine."Qty. to Invoice" <> 0) then begin
                                                if recSaleLine."Unit Cost" = 0 then
                                                    Error(lText006, recSaleLine.FieldCaption("Unit Cost"), "No.", recSaleLine."Line No.");
                                                //>> 04-02-21 ZY-LD 042
                                                /*IF recSaleLine."Unit Price" <> 0 THEN
                                                  ERROR(lText007,recSaleLine.FieldCaption("Unit Price"),"No.",recSaleLine."Line No.");*/

                                                if recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."sample / test equipment"::"Sample (Unit Price = Zero)" then begin
                                                    if recSaleLine."Unit Price" <> 0 then
                                                        Error(lText022, recSaleLine.FieldCaption("Unit Price"), "No.", recSaleLine."Line No.", LowerCase(recSaleLine."Gen. Bus. Posting Group"));
                                                end else
                                                    if recSaleLine."Unit Price" <> recSaleLine."Unit Cost" then
                                                        Error(lText021, recSaleLine.FieldCaption("Unit Price"), "No.", recSaleLine."Line No.", recSaleLine.FieldCaption("Unit Cost"));
                                                //<< 04-02-21 ZY-LD 042
                                            end;
                                        end else
                                            //>> 18-11-19 ZY-LD 029
                                            if ZGT.IsZNetCompany and
                                               (recSaleLine."Unit Price" = 0) and
                                               ((recSaleLine."Qty. to Ship" <> 0) or (recSaleLine."Qty. to Invoice" <> 0)) and
                                               (not recSaleLine."Zero Unit Price Accepted")  // 24-05-22 ZY-LD 061
                                            then
                                                ItemWithZeroPriceFound := true;
                                        //<< 18-11-19 ZY-LD 029

                                        //>> 14-02-20 ZY-LD 031
                                        if "Location Code" <> recSaleLine."Location Code" then
                                            Error(lText014);
                                        //<< 14-02-20 ZY-LD 031
                                        //>> 30-04-20 ZY-LD 035
                                        if ("Sales Order Type" <> "sales order type"::"G/L Account") and (recSaleLine."Location Code" = '') then
                                            Error(lText016);
                                        //<< 30-04-20 ZY-LD 035
                                    end;
                                    //<< 13-08-19 ZY-LD 021 

                                    //>> 23-10-23 ZY-LD 069
                                    if (recSaleLine."Document Type" <> recSaleLine."Document Type"::"Credit Memo") and (recSaleLine."Document Type" <> recSaleLine."Document Type"::"Return Order") then
                                        IF (recSaleLine."Qty. to Ship" <> 0) OR (recSaleLine."Qty. to Invoice" <> 0) then begin
                                            recLocation.get(recSaleLine."Location Code");
                                            if not recLocation."Allow Unit Cost is Zero" then begin
                                                recItem.get(recSaleLine."No.");
                                                //>> 19-06-24 ZY-LD 072
                                                ItemLedgEntry.SetCurrentKey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                                                ItemLedgEntry.SetRange("Item No.", recItem."No.");
                                                ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Purchase);
                                                ItemLedgEntry.SetRange("Location Code", recSaleLine."Location Code");
                                                ItemLedgEntry.SetFilter("Cost Posted to G/L", '<>0');
                                                //<< 19-06-24 ZY-LD 072
                                                if (recItem.Type = recItem.type::Inventory) and ((not recItem."Allow Unit Cost is Zero") or (ItemLedgEntry.FindLast)) then
                                                    recSaleLine.TESTFIELD("Unit Cost (LCY)");
                                            end;
                                        end;
                                    //<< 23-10-23 ZY-LD 069

                                    //>> 18-02-24 ZY-LD 000
                                    if SalesHeader.Invoice and (recSaleLine."Unit Price" = 0) and (recSaleLine."Line Discount %" <> 0) then
                                        Error(lText031, recSaleLine.FieldCaption("Line Discount %"), recSaleLine.FieldCaption("Unit Price"), recSaleLine."Line No.");
                                    //<< 18-02-24 ZY-LD 000
                                    //>> 19-04-24 ZY-LD 071
                                    if SI.GetPostDamage() and SI.GetWarehouseManagement() then
                                        if recSaleLine."Unit Price" <> 0 then
                                            error(lText033, recSaleLine.FieldCaption("Unit Price"));
                                    //<< 19-04-24 ZY-LD 071
                                end;

                                //>> 15-09-21 ZY-LD 051
                                recSaleLine.TestField("Gen. Bus. Posting Group");
                                recSaleLine.TestField("Gen. Prod. Posting Group");
                                recSaleLine.TestField("VAT Bus. Posting Group");
                                recSaleLine.TestField("VAT Prod. Posting Group");
                                //<< 15-09-21 ZY-LD 051
                            end;
                        recSaleLine.Type::"Charge (Item)":
                            begin
                                //>> 21-05-21 ZY-LD 044
                                if not recSaleLine."Hide Line" then
                                    Error(lText002, recSaleLine.Type, recSaleLine.FieldCaption("Hide Line"));
                                //<< 21-05-21 ZY-LD 044

                                //>> 15-09-21 ZY-LD 051
                                recSaleLine.TestField("Gen. Bus. Posting Group");
                                recSaleLine.TestField("Gen. Prod. Posting Group");
                                recSaleLine.TestField("VAT Bus. Posting Group");
                                recSaleLine.TestField("VAT Prod. Posting Group");
                                //<< 15-09-21 ZY-LD 051
                            end;
                    end;
                until recSaleLine.Next() = 0;

                //>> 18-11-19 ZY-LD 029
                if ItemWithZeroPriceFound then
                    if Ship then begin
                        if not GuiAllowed() then begin
                            EmailMgt.CreateEmailWithBodytext2('LOGORDERS', '', StrSubstNo(lText012, recSaleLine.FieldCaption("Unit Price"), Lowercase(Format("Document Type")), "No."), '');
                            EmailMgt.Send;
                        end else
                            if not Confirm(lText012 + lText013, false, recSaleLine.FieldCaption("Unit Price"), LowerCase(Format("Document Type")), "No.") then
                                Error('');
                    end else
                        if not GuiAllowed() then
                            Error(lText012, recSaleLine.FieldCaption("Unit Price"), LowerCase(Format("Document Type")), "No.")
                        else
                            if not Confirm(lText012 + lText013, false, recSaleLine.FieldCaption("Unit Price"), LowerCase(Format("Document Type")), "No.") then
                                Error('');
                //<< 18-11-19 ZY-LD 029
            end;
            //<< 28-02-19 ZY-LD 012

            if "Document Type" in ["document type"::Invoice, "document type"::"Credit Memo"] then begin
                // Additional item lines can't have an amount
                recSaleLine.Reset();
                recSaleLine.SetRange("Document Type", "Document Type");
                recSaleLine.SetRange("Document No.", "No.");
                recSaleLine.SetFilter("Additional Item Line No.", '<>%1', 0);
                recSaleLine.SetFilter("Line Amount", '<>%1', 0);
                if recSaleLine.FindFirst() then
                    Error(lText001, recSaleLine.FieldCaption("Line Amount"));
            end;

            //>> 29-01-19 ZY-LD 008
            if ZGT.IsZComCompany then  // 15-02-23 ZY-LD 065
                if "Document Type" in ["document type"::"Credit Memo"] then
                    if ("Location Code" = 'PP') and ("Bill-to Country/Region Code" = 'IT') then begin
                        TestField("Ship-to Code", "Location Code");
                        TestField("Ship-to Address");
                        TestField("Ship-to Post Code");
                        TestField("Ship-to City");
                    end;
            //<< 29-01-19 ZY-LD 008

            //>> 01-02-19 ZY-LD 009
            if (("Document Type" = "document type"::Order) and Invoice) or
               ("Document Type" = "document type"::Invoice)
            then begin
                //recInvSetup.GET;  // The read has been moved up.
                recGenBusPostGrp.Get("Gen. Bus. Posting Group");  // 19-03-21 ZY-LD 042
                if ZGT.IsRhq and not ZGT.IsZNetCompany then  // 24-01-19 ZY-LD 009
                    if recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."sample / test equipment"::" " then  // 19-03-21 ZY-LD 042
                        if ("Bill-to Country/Region Code" = 'IT') and ("Location Code" = recInvSetup."AIT Location Code") and ("E-Invoice Comment" = '') then
                            Error(lText004, FieldCaption("E-Invoice Comment"));

                //>> 28-02-19 ZY-LD 011
                if ZGT.CompanyNameIs(11) then begin  // DE
                    recSaleLine.Reset();
                    recSaleLine.SetRange("Document Type", "Document Type");
                    recSaleLine.SetRange("Document No.", "No.");
                    recSaleLine.SetRange(Type, recSaleLine.Type::Item);

                    if ("Ship-to Country/Region Code" <> 'DK') and  // 21-11-19 ZY-LD 030
                       ("Shipment Date" = 0D) and
                       (recSaleLine.FindFirst())  // 21-01-20 ZY-LD 030
                    then
                        FieldError("Shipment Date");
                end;
                //<< 28-02-19 ZY-LD 011
                //>> 03-02-20 ZY-LD 033
                if recCustPriceGrp.Get("Customer Price Group") and recCustPriceGrp.Blocked then
                    Error(lText015, FieldCaption("Customer Price Group"), "Customer Price Group");
                //<< 03-02-20 ZY-LD 033
            end;
            //<< 01-02-19 ZY-LD 011

            //>> 01-03-18 ZY-LD 002
            if ZGT.IsRhq then begin
                case "Document Type" of
                    "document type"::Invoice:
                        //>> 13-11-19 ZY-LD 027
                        begin
                            recCust.Get("Sell-to Customer No.");

                            if "Sales Order Type" = "sales order type"::Normal then begin
                                CalcFields("No of Lines", "Total Quantity", "Picking List No.", Amount, "Line Discount Amount");  // 21-09-20 ZY-LD 040
                                recDelDocHead.SetAutoCalcFields("No of Lines", "Total Quantity", Amount);
                                //>> 14-09-20 ZY-LD 040
                                if (recCust."Create Invoice pr. Order") and ("Create Invoice pr. Order No." <> '') then
                                    recDelDocHead.SetRange("Sales Order No. Filter", "Create Invoice pr. Order No.");  // 15-09-21 ZY-LD 050
                                                                                                                       //recDelDocHead.SETRANGE("Sales Order No. Filter","Your Reference");  // 15-09-21 ZY-LD 050
                                                                                                                       //<< 14-09-20 ZY-LD 040
                                if recDelDocHead.Get("Picking List No.") then begin
                                    if recDelDocHead."No of Lines" <> "No of Lines" then
                                        if not Confirm(lText009, false, "No of Lines", recDelDocHead."No of Lines") then
                                            Error('');
                                    if recDelDocHead."Total Quantity" <> "Total Quantity" then
                                        if not Confirm(lText010, false, "Total Quantity", recDelDocHead."Total Quantity") then
                                            Error('');
                                    if Amount + "Line Discount Amount" <> Round(recDelDocHead.Amount) then  // 21-09-20 ZY-LD 040
                                        if not Confirm(lText011, false, Amount, recDelDocHead.Amount) then
                                            Error('');
                                end;
                            end;

                            //>> 15-09-21 ZY-LD 050
                            if ZGT.IsZComCompany then begin
                                recSaleLine.Reset();
                                recSaleLine.SetRange("Document Type", "Document Type");
                                recSaleLine.SetRange("Document No.", "No.");
                                recSaleLine.SetRange(Type, recSaleLine.Type::Item);
                                recSaleLine.SetFilter("Shipment No.", '<>%1', '');

                                if recCust."Create Invoice pr. Order" and (recSaleLine.FindFirst()) then
                                    TestField("Your Reference");
                            end;
                            //<< 15-09-21 ZY-LD 050

                        end;
                    //<< 13-11-19 ZY-LD 027
                    "document type"::"Credit Memo":
                        if "Ship-to Country/Region Code" = '' then begin
                            recSaleLine.Reset();
                            recSaleLine.SetRange("Document Type", "Document Type");
                            recSaleLine.SetRange("Document No.", "No.");
                            recSaleLine.SetRange("Return Reason Code", '1');
                            if recSaleLine.FindFirst() then
                                Error(lText003, recSaleLine.FieldCaption("Return Reason Code"));
                        end;
                end;
            end;
            //<< 01-03-18 ZY-LD 002

            // Eicards must have an machine code if it's marked on the item.
            //>> 30-01-18 ZY-LD 001
            if ("Document Type" = "document type"::Order) and ("Sales Order Type" = "sales order type"::EICard) then begin
                //>> 29-10-19 ZY-LD 025
                recBillToCust.Get("Bill-to Customer No.");
                if recBillToCust."Post EiCard Invoice Automatic" > recBillToCust."post eicard invoice automatic"::" " then begin
                    if recBillToCust."Post EiCard Invoice Automatic" = recBillToCust."post eicard invoice automatic"::"Yes (when purchase invoice is posted)" then
                        SetRange("EiCard iPurch Order St. Filter", "eicard ipurch order st. filter"::Posted);
                    CalcFields("EiCard Ready to Post");
                    if not "EiCard Ready to Post" then
                        Error(lText008, "No.");
                end;
                //<< 29-10-19 ZY-LD 025

                recSaleLine.Reset();
                recSaleLine.SetRange("Document Type", "Document Type");
                recSaleLine.SetRange("Document No.", "No.");
                recSaleLine.SetRange(Type, recSaleLine.Type::Item);
                if recSaleLine.FindSet() then
                    repeat
                        //>> 23-02-23 ZY-LD 066
                        /*IF ((StrPos(recItem."No.",'EMS') <> 0) OR (recItem.GET(recSaleLine."No.") AND recItem."EMS License")) AND
                           (recSaleLine."EMS Machine Code" = '')  // 29-10-18 ZY-LD 004
                        THEN
                          ERROR(lText002,recSaleLine.FieldCaption("EMS Machine Code"),recSaleLine."No.",recSaleLine."Line No.");*/

                        recItem.Get(recSaleLine."No.");
                        if recItem."Enter Security for Eicard on" <> recItem."enter security for eicard on"::" " then begin
                            recAddEicardOrderInfo.SetRange("Document Type", recSaleLine."Document Type");
                            recAddEicardOrderInfo.SetRange("Document No.", recSaleLine."Document No.");
                            recAddEicardOrderInfo.SetRange("Sales Line Line No.", recSaleLine."Line No.");
                            recAddEicardOrderInfo.SetRange(Validated, true);
                            if recSaleLine.Quantity <> recAddEicardOrderInfo.Count() then
                                Error(lText030, recSaleLine.Quantity, Format(recItem."Enter Security for Eicard on"), recAddEicardOrderInfo.Count());
                        end;
                    //<< 23-02-23 ZY-LD 066
                    until recSaleLine.Next() = 0;
            end;
            //<< 30-01-18 ZY-LD 001

            SI.SetRejectChangeLog(true);  // 25-04-18 ZY-LD 004
        end;

    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCommitSalesDoc', '', false, false)]
    // local procedure OnBeforePostCommitSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; ModifyHeader: Boolean)
    // var
    //     recAmzonOrderHead: Record "eCommerce Order Header";
    //     recAmzOrderLine: Record "eCommerce Order Line";
    //     recAmzOrderArc: Record "eCommerce Order Archive";
    //     recAmzOrderLineArc: Record "eCommerce Order Line Archive";
    // begin
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        lSellToCust: Record Customer;
        recSaleInvHead: Record "Sales Invoice Header";
        recSalesInvLine: Record "Sales Invoice Line";
        recSaleCrHead: Record "Sales Cr.Memo Header";
        recLocation: Record Location;
        recCompInfo: Record "Company Information";
        recSalesSetup: Record "Sales & Receivables Setup";
        recEiCardQueue: Record "EiCard Queue";
        recDelDocHead: Record "VCK Delivery Document Header";
        recSaleDocEmail: Record "Sales Document E-mail Entry";
        recCust: Record Customer;
        recEmailAdd: Record "E-mail address";
        recWhseInbHead: Record "Warehouse Inbound Header";
        recDefDim: Record "Default Dimension";
        recGlSetup: Record "General Ledger Setup";
        recDimSetEntry: Record "Dimension Set Entry";
        recDimValue: Record "Dimension Value";
        recIcDimValue: Record "IC Dimension Value";
        recValueEntry: Record "Value Entry";
        recItemLedgEntry: Record "Item Ledger Entry";
        recAmzonOrderHead: Record "eCommerce Order Header";
        recAmzOrderLine: Record "eCommerce Order Line";
        recAmzOrderLineArc: Record "eCommerce Order Line Archive";
        recAmzOrderArc: Record "eCommerce Order Archive";
        recInvSetup: Record "Inventory Setup";
        SalesOrder: Record "Sales Header";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        NLtoDKPosting: Report "NL to DK Posting";  // 24-09-24 ZY-LD 074
        lText001: Label 'The invoice will be e-mailed to the warehouse (%1).\%2';
        lText002: Label 'The invoice %1 is succesfully added to the e-mail queue.';
        lText003: Label 'The invoice %1 must be e-mailed manually to the customer.';
        lText004: Label 'It was not possible to e-mail the invoice to the warehouse!!!';
        MessageText: Text;
    begin
        with SalesHeader do begin
            //>> 03-10-19 ZY-LD 024
            if (("Document Type" = "document type"::Order) and Invoice) or
                ("Document Type" = "document type"::Invoice)
            then
                if ZGT.IsRhq then begin
                    recSaleInvHead.SetAutoCalcFields("Picking List No.");
                    recSaleInvHead.Get(SalesInvHdrNo);
                    //>> 13-11-19 ZY-LD 027
                    if recSaleInvHead."Picking List No." <> '' then begin
                        recDelDocHead.Get(recSaleInvHead."Picking List No.");
                        recDelDocHead."Document Status" := recDelDocHead."document status"::Posted;
                        recDelDocHead.Modify();
                    end;
                    //<< 13-11-19 ZY-LD 027

                    if recSaleInvHead."Send Mail" then begin
                        recSaleDocEmail."Document Type" := recSaleDocEmail."document type"::"Posted Sales Invoice";
                        recSaleDocEmail."Document No." := recSaleInvHead."No.";
                        recCust.Get(recSaleInvHead."Bill-to Customer No.");
                        if recCust."Delay Btw. Post and Send Email" <> 0 then
                            recSaleDocEmail."Send E-mail at" := CurrentDatetime + (1000 * 60 * recCust."Delay Btw. Post and Send Email");

                        recDelDocHead.SetAutoCalcFields("Send Invoice to Warehouse");
                        if recDelDocHead.Get(recSaleInvHead."Picking List No.") and (recDelDocHead."Warehouse Status" = recDelDocHead."warehouse status"::"Waiting for invoice") then begin
                            if recDelDocHead."Send Invoice to Warehouse" then begin
                                recEmailAdd.Get('VCKWAITINV');
                                if recEmailAdd."Delay on Automated E-mail" <> 0 then
                                    recSaleDocEmail."Send E-mail at" := CurrentDatetime + (1000 * 60 * recEmailAdd."Delay on Automated E-mail");
                                recSaleDocEmail."E-mail Address Code" := recEmailAdd.Code;
                                MessageText := StrSubstNo(lText001, recEmailAdd.Recipients, StrSubstNo(lText002, recSaleInvHead."No."));
                            end else
                                MessageText := StrSubstNo(lText004);
                        end else
                            MessageText := StrSubstNo(lText002, recSaleInvHead."No.");

                        recSaleDocEmail.Insert(true);
                        if MessageText <> '' then
                            Message(MessageText);
                    end else
                        if not recSaleInvHead."eCommerce Order" then
                            Message(lText003, recSaleInvHead."No.");
                end;
            Commit();
            //<< 03-10-19 ZY-LD 024

            //>> 27-02-23 ZY-LD 067
            //>> 31-08-21 ZY-LD 049
            if "eCommerce Order" and (not Correction) then begin
                //>> 05-01-23 ZY-LD 064
                //recAmzonOrderHead.SETRANGE("Transaction Type","Document Type"-2);
                recAmzonOrderHead.SetCurrentkey("Sales Document Type", "eCommerce Order Id", "Invoice No.");
                recAmzonOrderHead.SetRange("Sales Document Type", "Document Type");
                //<< 05-01-23 ZY-LD 064
                recAmzonOrderHead.SetRange("eCommerce Order Id", "External Document No.");
                recAmzonOrderHead.SetRange("Invoice No.", "External Invoice No.");
                if recAmzonOrderHead.FindFirst() then begin
                    recAmzOrderArc.TransferFields(recAmzonOrderHead);
                    recAmzOrderArc."Date Archived" := Today;
                    recAmzOrderArc."Posting Date" := "Posting Date";  // 29-03-22 ZY-LD 058
                    recAmzOrderArc.Insert(true);

                    recAmzOrderLine.SetRange("eCommerce Order Id", recAmzonOrderHead."eCommerce Order Id");
                    recAmzOrderLine.SetRange("Invoice No.", recAmzonOrderHead."Invoice No.");
                    if recAmzOrderLine.FindSet() then
                        repeat
                            recAmzOrderLineArc.TransferFields(recAmzOrderLine);
                            recAmzOrderLineArc.Insert(true);
                        until recAmzOrderLine.Next() = 0;

                    recAmzonOrderHead.Delete(true);

                    //>> 13-09-24 ZY-LD 073
                    SalesOrder.SetRange("Document Type", SalesOrder."Document Type"::Order);
                    SalesOrder.SetRange("Sales Order Type", SalesOrder."Sales Order Type"::eCommerce);
                    SalesOrder.SetRange("External Document No.", "External Document No.");
                    if SalesOrder.FindFirst() then
                        SalesOrder.Delete(true);
                    //<< 13-09-24 ZY-LD 073
                    COMMIT;  // 06-09-23 ZY-LD 068
                end;
            end;
            //<< 31-08-21 ZY-LD 049
            //<< 27-02-23 ZY-LD 067

            //>> 20-05-21 ZY-LD 044
            /*IF "Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN
              IF "IC Direction" = "IC Direction"::Outgoing THEN BEGIN
                lBillToCust.GET("Bill-to Customer No.");
                IF ICPartner.GET(lBillToCust."IC Partner Code") AND (NOT ICPartner.Blocked) THEN
                  IF ICPartner."Set Posting Date to Today" OR ICPartner."Set Document Date to Today" THEN BEGIN
                    lIcOutbSaleHead.SETRANGE("Document Type","Document Type");
                    lIcOutbSaleHead.SETRANGE("No.","No.");
                    IF lIcOutbSaleHead.FINDFIRST THEN BEGIN
                      IF ICPartner."Set Posting Date to Today" THEN
                        lIcOutbSaleHead."Posting Date" := TODAY;
                      IF ICPartner."Set Document Date to Today" THEN
                        lIcOutbSaleHead."Document Date" := TODAY;
                      lIcOutbSaleHead.MODIFY;
                    END;
                  END;
              END;*/
            //<< 20-05-21 ZY-LD 044

            case "Document Type" of
                "document type"::Order:
                    begin
                        //>> 06-09-19 ZY-LD 023
                        if ("Sales Order Type" = "sales order type"::EICard) and (SalesInvHdrNo <> '') then
                            if recEiCardQueue.Get(SalesHeader."No.") then begin
                                recEiCardQueue.Validate("Sales Order Status", recEiCardQueue."sales order status"::Posted);
                                recEiCardQueue.Modify(true);
                            end;
                        //<< 06-09-19 ZY-LD 023
                    end;
                "document type"::"Return Order":
                    begin
                        //>> 04-05-20 ZY-LD 036
                        if SalesCrMemoHdrNo <> '' then begin
                            recSaleCrHead.SetAutoCalcFields("Warehouse Inbound No.");
                            recSaleCrHead.Get(SalesCrMemoHdrNo);
                            if recWhseInbHead.Get(recSaleCrHead."Warehouse Inbound No.") then begin
                                recWhseInbHead.Validate("Document Status", recWhseInbHead."document status"::Posted);
                                recWhseInbHead.Modify(true);
                            end;
                        end;
                        //<< 04-05-20 ZY-LD 036
                    end;
                "document type"::Invoice:
                    begin
                        UpdateOutboxSalesHeader(SalesHeader, GenJnlPostLine, SalesShptHdrNo, RetRcpHdrNo, SalesInvHdrNo, SalesCrMemoHdrNo);  // 20-05-21 ZY-LD 044

                        recSaleInvHead.SetAutoCalcFields("Picking List No.");  // 13-11-19 ZY-LD 027
                        recSaleInvHead.Get(SalesInvHdrNo);
                        //>> 12-04-19 ZY-LD 014
                        if ZGT.IsRhq and SerialNoAttached(SalesInvHdrNo) then
                            recSaleInvHead."Serial Numbers Status" := recSaleInvHead."serial numbers status"::Attached;
                        //<< 12-04-19 ZY-LD 014

                        recSaleInvHead.Modify();

                        //>> 10-07-19 ZY-LD 019
                        if ZGT.IsRhq and
                           ("Sales Order Type" <> "sales order type"::EICard)  // 04-11-19 ZY-LD 026
                        then begin
                            recSalesSetup.Get();
                            recSalesSetup.TestField("Customer No. on Sister Company");
                            if (ZGT.IsZNetCompany and ("Sell-to Customer No." = recSalesSetup."Customer No. on Sister Company")) or  // ZNet
                               (not ZGT.IsZNetCompany and ("Sell-to Customer No." = recSalesSetup."Customer No. on Sister Company"))  // Zyxel
                            then begin
                                SalesHeadEvent.UpdateUnshippedQuantity("Sell-to Customer No.");
                                SalesHeadEvent.SendContainerDetails(SalesInvHdrNo, "Sell-to Customer No.");
                            end;
                        end;
                        //<< 10-07-19 ZY-LD 019

                        //>> 16-12-21 ZY-LD 056  // 13-12-22 ZY-LD 063
                        /*recSalesInvLine.SETRANGE("Document No.","No.");
                        recSalesInvLine.SETRANGE(Type,recSalesInvLine.Type::"G/L Account");
                        IF recSalesInvLine.FINDSET THEN BEGIN
                          recGlSetup.GET;
                          REPEAT
                            IF recDefDim.GET(DATABASE::"G/L Account",recSalesInvLine."No.",recGlSetup."Shortcut Dimension 7 Code") AND
                               (recDefDim."Value Posting" = recDefDim."Value Posting"::"Code Mandatory")
                            THEN
                              IF recDimSetEntry.GET(recSalesInvLine."Dimension Set ID",recGlSetup."Shortcut Dimension 7 Code") THEN BEGIN
                                IF recDimValue.GET(recGlSetup."Shortcut Dimension 7 Code",recDimSetEntry."Dimension Value Code") THEN BEGIN
                                  recDimValue.VALIDATE(Blocked,TRUE);
                                  recDimValue.MODIFY(TRUE);
                                END;

                                IF recIcDimValue.GET(recGlSetup."Shortcut Dimension 7 Code",recDimSetEntry."Dimension Value Code") THEN BEGIN
                                  recIcDimValue.VALIDATE(Blocked,TRUE);
                                  recIcDimValue.MODIFY(TRUE);
                                END;
                              END;
                          UNTIL recSalesInvLine.Next() = 0;
                        END;*/
                        //<< 16-12-21 ZY-LD 056

                        //>> 13-04-22 ZY-LD 059
                        //>> 05-01-23 ZY-LD 064
                        //IF "eCommerce Order" AND recAmzOrderArc.GET("Document Type"-2,"External Document No.","External Invoice No.") THEN BEGIN
                        if "eCommerce Order" then begin
                            recAmzOrderArc.SetCurrentkey("Sales Document Type", "eCommerce Order Id", "Invoice No.");
                            recAmzOrderArc.SetRange("Sales Document Type", "Document Type");
                            recAmzOrderArc.SetRange("eCommerce Order Id", "External Document No.");
                            recAmzOrderArc.SetRange("Invoice No.", "External Invoice No.");
                            if recAmzOrderArc.FindFirst() then begin  //<< 05-01-23 ZY-LD 064
                                recValueEntry.SetCurrentkey("Document Type", "Document No.");
                                recValueEntry.SetRange("Document Type", recValueEntry."document type"::"Sales Invoice");
                                recValueEntry.SetRange("Document No.", "No.");
                                if recValueEntry.FindFirst() then begin  // 09-12-22 ZY-LD 059 - There can be refund of shipment fee without the product.
                                    recItemLedgEntry.Get(recValueEntry."Item Ledger Entry No.");

                                    recAmzOrderArc."Sales Shipment No." := recItemLedgEntry."Document No.";
                                    recAmzOrderArc.Modify(true);
                                end;
                            end;
                        end;
                        //<< 13-04-22 ZY-LD 059

                        if SalesHeader."NL to DK Reverse Chg. Doc No." <> '' then  // 24-09-24 ZY-LD 074
                            NLtoDKPosting.NLtoDKRevChargePosted(SalesHeader."NL to DK Reverse Chg. Doc No.", SalesHeader."Document Type");  // 24-09-24 ZY-LD 074
                    end;
                "document type"::"Credit Memo":
                    begin
                        UpdateOutboxSalesHeader(SalesHeader, GenJnlPostLine, SalesShptHdrNo, RetRcpHdrNo, SalesInvHdrNo, SalesCrMemoHdrNo);  // 20-05-21 ZY-LD 044

                        //>> 04-05-20 ZY-LD 036
                        if SalesCrMemoHdrNo <> '' then begin
                            recSaleCrHead.SetAutoCalcFields("Warehouse Inbound No.");
                            recSaleCrHead.Get(SalesCrMemoHdrNo);
                            if recWhseInbHead.Get(recSaleCrHead."Warehouse Inbound No.") then begin
                                recWhseInbHead.Validate("Document Status", recWhseInbHead."document status"::Posted);
                                recWhseInbHead.Modify(true);
                            end;
                        end;
                        //<< 04-05-20 ZY-LD 036

                        //>> 13-04-22 ZY-LD 059
                        //>> 05-01-23 ZY-LD 064
                        //IF "eCommerce Order" AND recAmzOrderArc.GET("Document Type"-2,"External Document No.","External Invoice No.") THEN BEGIN
                        if "eCommerce Order" then begin
                            recAmzOrderArc.SetCurrentkey("Sales Document Type", "eCommerce Order Id", "Invoice No.");
                            recAmzOrderArc.SetRange("Sales Document Type", "Document Type");
                            recAmzOrderArc.SetRange("eCommerce Order Id", "External Document No.");
                            recAmzOrderArc.SetRange("Invoice No.", "External Invoice No.");
                            if recAmzOrderArc.FindFirst() then begin  //<< 05-01-23 ZY-LD 064
                                recValueEntry.SetCurrentkey("Document Type", "Document No.");
                                recValueEntry.SetRange("Document Type", recValueEntry."document type"::"Sales Credit Memo");
                                recValueEntry.SetRange("Document No.", "No.");
                                if recValueEntry.FindFirst() then begin
                                    recItemLedgEntry.Get(recValueEntry."Item Ledger Entry No.");

                                    recAmzOrderArc."Sales Shipment No." := recItemLedgEntry."Document No.";
                                    recAmzOrderArc.Modify(true);
                                end;
                            end;
                        end;
                        //<< 13-04-22 ZY-LD 059

                        NLtoDKPosting.NLtoDKRevChargePosted(SalesHeader."NL to DK Reverse Chg. Doc No.", SalesHeader."Document Type");  // 24-09-24 ZY-LD 074
                    end;
            end;

            SI.SetAllowToDeleteAddItem(false);
            SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 004
            SI.SetSkipVerifyOnInventory(false); // 02-03-23 ZY-LD 068
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure SalesPost_OnBeforeSalesInvLineInsert(SalesLine: Record "Sales Line" temporary; var SalesInvLine: Record "Sales Invoice Line")
    var
        ItemChargeAss: Record "Item Charge Assignment (Sales)";
        PostItemChargeInv: Record "Posted Item Charge (Sales-Inv)";
        PostItemChargeCrM: Record "Posted Item Charge (Sales-CrM)";
    begin
        with SalesLine do
            // 20-05-21 ZY-LD 044
            if Type = Type::"Charge (Item)" then begin
                ItemChargeAss.SetRange("Document Type", "Document Type");
                ItemChargeAss.SetRange("Document No.", "Document No.");
                ItemChargeAss.SetRange("Document Line No.", "Line No.");
                if ItemChargeAss.FindSet() then
                    repeat
                        PostItemChargeInv.TransferFields(ItemChargeAss);
                        PostItemChargeInv."Document No." := SalesInvLine."Document No.";
                        PostItemChargeInv.Insert();
                    until ItemChargeAss.Next() = 0;
            end;
        //<< 20-05-21 ZY-LD 044
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesCrMemoLineInsert', '', false, false)]
    local procedure SalesPost_OnBeforeSalesCrMemoLineInsert(SalesLine: Record "Sales Line" temporary; var SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        ItemChargeAss: Record "Item Charge Assignment (Sales)";
        PostItemChargeInv: Record "Posted Item Charge (Sales-Inv)";
        PostItemChargeCrM: Record "Posted Item Charge (Sales-CrM)";
    begin
        with SalesLine do
            // 20-05-21 ZY-LD 044
            if Type = Type::"Charge (Item)" then begin
                ItemChargeAss.SetRange("Document Type", "Document Type");
                ItemChargeAss.SetRange("Document No.", "Document No.");
                ItemChargeAss.SetRange("Document Line No.", "Line No.");
                if ItemChargeAss.FindSet() then
                    repeat
                        PostItemChargeCrM.TransferFields(ItemChargeAss);
                        PostItemChargeCrM."Document No." := SalesCrMemoLine."Document No.";
                        PostItemChargeCrM.Insert();
                    until ItemChargeAss.Next() = 0;
            end;
        //<< 20-05-21 ZY-LD 044
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Check Dimensions", 'OnCheckDimValuePostingOnAfterCreateDimTableIDs', '', false, false)]
    local procedure CheckDimensions_OnCheckDimValuePostingOnAfterCreateDimTableIDs(RecordVariant: Variant; var TableIDArr: array[10] of Integer; var NumberArr: array[10] of Code[20])
    var
        SalesHeader: Record "Sales Header";
        DataTypeMgt: Codeunit "Data Type Management";
        RecRef: RecordRef;
    begin
        if DataTypeMgt.GetRecordRef(RecordVariant, RecRef) then
            if RecRef.Number() = Database::"Sales Header" then begin
                RecRef.SetTable(SalesHeader);
                NumberArr[1] := SalesHeader."Sell-to Customer No.";  // 01-11-18 ZY-LD 003
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesInvoice(var Rec: Record "Sales Invoice Header"; RunTrigger: Boolean)
    var
        recCust: Record Customer;
    begin
        with Rec do begin
            //>> 13-03-18 ZY-LD 003
            if "Bill-to Customer No." <> '' then  // 26-11-18 ZY-LD 006
                if "Bill-to Country/Region Code" = '' then
                    Error(Text001, FieldCaption("Bill-to Country/Region Code"));
            //<< 13-03-18 ZY-LD 003

            //>> 12-11-18 ZY-LD 005
            if ZGT.IsRhq then begin
                //>> 12-04-19 ZY-LD 014
                if "Sell-to Customer No." = "Bill-to Customer No." then
                    "Invoice No. for End Customer" := "No.";
                //<< 12-04-19 ZY-LD 014
            end;
            //<< 12-11-18 ZY-LD 005
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesInvoice(var Rec: Record "Sales Invoice Header"; RunTrigger: Boolean)
    var
        recLocation: Record Location;
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
    begin
        with Rec do begin
            //>> 12-04-19 ZY-LD 004
            if ZGT.IsRhq then begin
                //>> 03-10-19 ZY-LD 024
                //    IF "Send Mail" THEN BEGIN
                //      recSaleDocEmail."Document Type" := recSaleDocEmail."Document Type"::"Posted Sales Invoice";
                //      recSaleDocEmail."Document No." := "No.";
                //      recCust.GET("Bill-to Customer No.");
                //      IF recCust."Delay Btw. Post and Send Email" <> 0 THEN
                //        recSaleDocEmail."Send E-mail at" := CURRENTDATETIME + (1000 * 60 * recCust."Delay Btw. Post and Send Email");
                //
                //      CALCFIELDS("Picking List No.");
                //      recDelDocHead.SETAUTOCALCFIELDS("Send Invoice to Warehouse");
                //      IF recDelDocHead.GET("Picking List No.") AND (recDelDocHead."Warehouse Status" = recDelDocHead."Warehouse Status"::"Waiting for invoice") THEN BEGIN
                //        IF recDelDocHead."Send Invoice to Warehouse" THEN BEGIN
                //          recEmailAdd.GET('VCKWAITINV');
                //          IF recEmailAdd."Delay on Automated E-mail" <> 0 THEN
                //            recSaleDocEmail."Send E-mail at" := CURRENTDATETIME + (1000 * 60 * recEmailAdd."Delay on Automated E-mail");
                //          recSaleDocEmail."E-mail Address Code" := recEmailAdd.Code;
                //          MESSAGE(lText001,recEmailAdd.Recipients,STRSUBSTNO(lText002,"No."));
                //        END ELSE
                //          MESSAGE(lText004);
                //      END ELSE
                //        MESSAGE(lText002,"No.");
                //
                //      recSaleDocEmail.INSERT(TRUE);
                //    END ELSE
                //      MESSAGE(lText003,"No.");
                //<< 03-10-19 ZY-LD 024
            end else begin
                // Updates RHQ with end customer no.
                if not "eCommerce Order" then  // 31-08-21 ZY-LD 048
                    if ZGT.TurkishServer then
                        ZyWebServMgt.SendSalesInvoiceNo(ZGT.GetRHQCompanyName, "Your Reference", "No.")
                    else begin
                        //>> 12-07-19 ZY-LD 020
                        //ZyWebServMgt.SendSalesInvoiceNo("External Document No.","No.")
                        if "Location Code" <> '' then begin
                            recLocation.Get("Location Code");
                            if recLocation."Comp Name for Return SInvNo" <> '' then
                                ZyWebServMgt.SendSalesInvoiceNo(recLocation."Comp Name for Return SInvNo", "External Document No.", "No.")
                            else
                                ZyWebServMgt.SendSalesInvoiceNo(ZGT.GetRHQCompanyName, "External Document No.", "No.")
                        end;
                        //<< 12-07-19 ZY-LD 020
                    end;
            end;
            //<< 12-04-19 ZY-LD 004
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesCrMemo(var Rec: Record "Sales Cr.Memo Header"; RunTrigger: Boolean)
    var
        recCust: Record Customer;
    begin
        with Rec do begin
            //>> 13-03-18 ZY-LD 003
            if "Bill-to Customer No." <> '' then  // 26-11-18 ZY-LD 006
                if "Bill-to Country/Region Code" = '' then
                    Error(Text001, FieldCaption("Bill-to Country/Region Code"));
            //<< 13-03-18 ZY-LD 003
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesInvoiceLine(var Rec: Record "Sales Invoice Line"; RunTrigger: Boolean)
    var
        lText001: Label 'If "%1" is set "%2" must bezero on "%3" "%4" "%5" .';
        recWhseSetup: Record "Warehouse Setup";
        recInvSetup: Record "Inventory Setup";
        lText002: Label 'Lines with type %1 must be marked as "%2".';
        recSalesInvLine: Record "Sales Invoice Line";
        lText003: Label 'If the line with type %1 is a reverse line of %2, the line must be marked as "%3".';
    begin
        with Rec do begin
            //>> 14-02-19 ZY-LD 010
            // 21-05-21 ZY-LD 044 - Moved to OnBeforePostSalesDoc
            /*IF "Hide Line" AND ("Unit Price" <> 0) AND (Quantity <> 0) THEN  // 26-03-20 ZY-LD 034
              ERROR(lText001,FieldCaption("Hide Line"),FieldCaption("Unit Price"),TABLECAPTION,"Document No.","Line No.");*/
            //<< 14-02-19 ZY-LD 010
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesCrMemoLine(var Rec: Record "Sales Cr.Memo Line"; RunTrigger: Boolean)
    var
        lText001: Label 'If "%1" is set "%2" must bezero on "%3" "%4" "%5" .';
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
        recSalesCrMemoLine: Record "Sales Cr.Memo Line";
        lText002: Label 'Lines with type %1 must be marked as "%2".';
        lText003: Label 'If the line with type %1 is a reverse line of %2, the line must be marked as "%3".';
    begin
        with Rec do begin
            //>> 14-02-19 ZY-LD 010
            // 21-05-21 ZY-LD 044 - Moved to OnBeforePostSalesDoc
            /*IF "Hide Line" AND ("Unit Price" <> 0) THEN
              ERROR(lText001,FieldCaption("Hide Line"),FieldCaption("Unit Price"),TABLECAPTION,"Document No.","Line No.");*/
            //<< 14-02-19 ZY-LD 010

            //>> 15-11-19 ZY-LD 028
            if not IsTemporary then begin
                recSalesCrMemoHead.Get("Document No.");
                "Document Date" := recSalesCrMemoHead."Document Date";
            end;
            //<< 15-11-19 ZY-LD 028
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesShipLine(var Rec: Record "Sales Shipment Line"; RunTrigger: Boolean)
    var
        recSalesHead: Record "Sales Header";
        lText001: Label '"%1" "%2" must be equal to the "%1" on the "%3" "%4".';
    begin
        with Rec do begin
            if not IsTemporary then  // 08-08-19 ZY-LD 020
                                     //>> 29-05-19 ZY-LD 017
                if "Order No." <> '' then begin
                    recSalesHead.Get(recSalesHead."document type"::Order, "Order No.");
                    if (Type = Type::Item) and
                       ("No." <> '') and
                       ("Bill-to Customer No." <> recSalesHead."Bill-to Customer No.")
                    then
                        Error(lText001, FieldCaption("Bill-to Customer No."), "Bill-to Customer No.", recSalesHead.TableCaption(), recSalesHead."Bill-to Customer No.");
                end;
            //<< 29-05-19 ZY-LD 017
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesShipLine(var Rec: Record "Sales Shipment Line"; RunTrigger: Boolean)
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        lText001: Label 'Quantity on "%1" and quantity on "%2" (%8) is not equal on SO "%3" SO line "%4" and dev doc (%5). DD-line %6 against %7';
        recSalesLine: Record "Sales Line";
        warehauseship: record "Warehouse Receipt Header";
        salesshipment: Record "Sales Shipment Header";
    begin
        with Rec do begin
            //>> 13-03-19 ZY-LD 012
            if not IsTemporary then begin  // 09-05-19 ZY-LD 015
                if not Correction then begin  // 01-12-20 ZY-LD 041
                    recDelDocLine.SetRange("Document No.", "Picking List No.");
                    recDelDocLine.SetRange("Sales Order No.", "Order No.");
                    recDelDocLine.SetRange("Sales Order Line No.", Rec."Order Line No.");
                    recDelDocLine.SetRange(Posted, false);
                    if recDelDocLine.FindFirst() then begin
                        if recDelDocLine.Quantity <> Quantity then begin
                            //salesshipment.get(rec."Document No.");
                            Error(lText001, recDelDocLine.TableCaption(), TableCaption(), "Order No.", "Order Line No.", "Picking List No.", recDelDocLine.Quantity, Quantity, Rec."No.");

                        end;
                        recDelDocLine.Validate(Posted, true);
                        recDelDocLine.Modify();
                    end;
                end else begin
                    //>> 01-12-20 ZY-LD 041
                    recDelDocLine.SetRange("Document No.", "Picking List No.");
                    recDelDocLine.SetRange("Sales Order No.", "Order No.");
                    recDelDocLine.SetRange("Sales Order Line No.", "Order Line No.");
                    if recDelDocLine.FindFirst() then
                        if recDelDocLine.Quantity = -Quantity then begin
                            recDelDocLine.Quantity := 0;
                            recDelDocLine.Modify(true);

                            if recSalesLine.Get(recSalesLine."document type"::Order, "Order No.", "Order Line No.") then
                                if recSalesLine."Delivery Document No." = "Picking List No." then begin
                                    recSalesLine.SetHideValidationDialog(true);
                                    recSalesLine."Delivery Document No." := '';
                                    recSalesLine."Warehouse Status" := recSalesLine."warehouse status"::New;
                                    recSalesLine."Shipment Date Confirmed" := false;
                                    recSalesLine.Modify(true);
                                    recSalesLine.SetHideValidationDialog(false);
                                end;
                        end;
                    //>> 01-12-20 ZY-LD 041
                end;
            end;
            //<< 13-03-19 ZY-LD 012
        end;
    end;

    local procedure SerialNoAttached(pSalesInvNo: Code[20]): Boolean
    var
        recSalesShipLine: Record "Sales Shipment Line";
        recSalesInvLine: Record "Sales Invoice Line";
        recSerialNo: Record "VCK Delivery Document SNos";
    begin
        //>> 12-04-19 ZY-LD 014
        recSalesInvLine.SetRange("Document No.", pSalesInvNo);
        recSalesInvLine.SetRange(Type, recSalesInvLine.Type::Item);
        if recSalesInvLine.FindSet() then begin
            recSerialNo.SetCurrentkey("Sales Order No.", "Sales Order Line No.");
            repeat
                if recSalesShipLine.Get(recSalesInvLine."Shipment No.", recSalesInvLine."Shipment Line No.") then begin
                    recSerialNo.SetRange("Sales Order No.", recSalesShipLine."Order No.");
                    recSerialNo.SetRange("Sales Order Line No.", recSalesShipLine."Order Line No.");
                    if recSerialNo.FindFirst() then
                        exit(true);
                end;
            until recSalesInvLine.Next() = 0;
        end;
        //<< 12-04-19 ZY-LD 014
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesInvLine(var Rec: Record "Sales Invoice Line"; RunTrigger: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PostSales-Delete", 'OnAfterDeleteHeader', '', false, false)]
    local procedure OnAfterDeleteHeader(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var SalesInvoiceHeaderPrepmt: Record "Sales Invoice Header"; var SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header")
    var
        lText001: Label 'DEL: %1';
        recAmzOrderHead: Record "eCommerce Order Header";
        lText002: Label '"%1" %2 is opened.';
    begin
        with SalesHeader do begin
            //>> 30-08-21 ZY-LD 048
            if "eCommerce Order" then begin
                if SalesInvoiceHeader."No." <> '' then begin
                    SalesInvoiceHeader."External Document No." := CopyStr(StrSubstNo(lText001, SalesInvoiceHeader."External Document No."), 1, MaxStrLen(SalesInvoiceHeader."External Document No."));
                    SalesInvoiceHeader.Modify();

                    recAmzOrderHead.SetRange("Transaction Type", recAmzOrderHead."transaction type"::Order)
                end;

                if SalesCrMemoHeader."No." <> '' then begin
                    SalesCrMemoHeader."External Document No." := CopyStr(StrSubstNo(lText001, SalesInvoiceHeader."External Document No."), 1, MaxStrLen(SalesInvoiceHeader."External Document No."));
                    SalesCrMemoHeader.Modify();

                    recAmzOrderHead.SetRange("Transaction Type", recAmzOrderHead."transaction type"::Refund);
                end;

                if "External Document No." <> '' then begin
                    //>> 05-01-22 ZY-LD 064
                    recAmzOrderHead.SetCurrentkey("Sales Document Type", "eCommerce Order Id", "Invoice No.");
                    recAmzOrderHead.SetRange("Sales Document Type", "Document Type");
                    //<< 05-01-22 ZY-LD 064
                    recAmzOrderHead.SetRange("eCommerce Order Id", "External Document No.");
                    recAmzOrderHead.SetRange("Invoice No.", "External Invoice No.");  // 26-01-21 ZY-LD 055
                    recAmzOrderHead.SetRange(Open, false);
                    if recAmzOrderHead.FindFirst() then begin
                        recAmzOrderHead.Open := true;
                        recAmzOrderHead.Modify();
                        Message(lText002, recAmzOrderHead.TableCaption(), "External Document No.");
                    end;
                end;
            end;
            //<< 30-08-21 ZY-LD 048
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeShowPostedDocsToPrintCreatedMsg', '', false, false)]
    local procedure SalesHeader_OnBeforeShowPostedDocsToPrintCreatedMsg(var ShowPostedDocsToPrint: Boolean)
    var
        SI: Codeunit "Single Instance";
    begin
        ShowPostedDocsToPrint := not SI.GetHideSalesDialog();  // 13-09-24 ZY-LD 073
    end;


    local procedure ">> Functions"()
    begin
    end;

    local procedure UpdateOutboxSalesHeader(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        lBillToCust: Record Customer;
        ICPartner: Record "IC Partner";
        lIcOutbSaleHead: Record "IC Outbox Sales Header";
    begin
        with SalesHeader do
            if "IC Direction" = "ic direction"::Outgoing then begin
                lBillToCust.Get("Bill-to Customer No.");
                if ICPartner.Get(lBillToCust."IC Partner Code") and (not ICPartner.Blocked) then
                    if ICPartner."Set Posting Date to Today" or ICPartner."Set Document Date to Today" then begin
                        lIcOutbSaleHead.SetRange("Document Type", "Document Type");
                        lIcOutbSaleHead.SetRange("No.", "No.");
                        if lIcOutbSaleHead.FindFirst() then begin
                            if ICPartner."Set Posting Date to Today" then
                                lIcOutbSaleHead."Posting Date" := Today;
                            if ICPartner."Set Document Date to Today" then
                                lIcOutbSaleHead."Document Date" := Today;
                            lIcOutbSaleHead.Modify();
                        end;
                    end;
            end;
    end;

    local procedure GlAccIsReverseLineToChargeItem(var SalesLine: Record "Sales Line") rValue: Boolean
    var
        recSalesLine: Record "Sales Line";
    begin
        with SalesLine do
            if Type = Type::"G/L Account" then begin
                recSalesLine := SalesLine;
                if recSalesLine.Next(-1) <> 0 then  // Charge (Item) line.
                    if (recSalesLine.Type = recSalesLine.Type::"Charge (Item)") and (recSalesLine.Quantity = Quantity) and (-recSalesLine."Unit Price" = "Unit Price") then
                        rValue := true;
            end;
    end;

    local procedure ValidateAddPostGrpPrLocation(var Rec: Record "Sales Header")
    var
        recAddBillToSetup: Record "Add. Cust. Posting Grp. Setup";
        recAddPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
        recBilltoCust: Record Customer;
        recSelltoCust: Record Customer;
        recSalesLine: Record "Sales Line";
        ValidateCustomer: Boolean;
        lText001: Label '"%1" is not correct on %2.\\Value on Sales Order: %3\Value on Additional Setup: %4.';
    begin
        with Rec do begin
            //>> 21-06-21 ZY-LD 045
            if ("Ship-to Country/Region Code" <> '') and ("Location Code" <> '') and ("Sell-to Customer No." <> '') then begin
                if Invoice then begin
                    recAddBillToSetup.SetRange("Country/Region Code", "Sell-to Country/Region Code");
                    recAddBillToSetup.SetRange("Location Code", "Location Code");
                    recAddBillToSetup.SetFilter("Customer No.", '%1|%2', '', "Sell-to Customer No.");
                    if ZGT.IsRhq then
                        recAddBillToSetup.SetRange("Company Type", recAddPostGrpSetup."company type"::Main);
                    if recAddBillToSetup.FindLast() then
                        if (recAddBillToSetup."Bill-to Customer No." <> '') and
                           (recAddBillToSetup."Bill-to Customer No." <> "Bill-to Customer No.")
                        then
                            Error(lText001, FieldCaption("Bill-to Customer No."), "No.", "Bill-to Customer No.", recAddBillToSetup."Bill-to Customer No.");
                end;

                if "Document Type" in ["document type"::"Return Order", "document type"::"Credit Memo"] then
                    recAddPostGrpSetup.SetRange("Country/Region Code", "Sell-to Country/Region Code")
                else
                    recAddPostGrpSetup.SetRange("Country/Region Code", "Ship-to Country/Region Code");
                recAddPostGrpSetup.SetRange("Location Code", "Location Code");
                recAddPostGrpSetup.SetFilter("Customer No.", '%1|%2', '', "Sell-to Customer No.");
                if ZGT.IsRhq then
                    recAddPostGrpSetup.SetRange("Company Type", recAddPostGrpSetup."company type"::Main);
                if recAddPostGrpSetup.FindLast() then begin
                    recBilltoCust.Get("Bill-to Customer No.");

                    if not "Skip Posting Group Validation" then begin
                        if GuiAllowed() then
                            ValidateField(1, 0, FieldCaption("Currency Code"), Format("Document Type"), "No.", 0, "Currency Code", recAddPostGrpSetup."Currency Code", recBilltoCust."Currency Code");
                        ValidateField(1, 1, FieldCaption("Gen. Bus. Posting Group"), Format("Document Type"), "No.", 0, "Gen. Bus. Posting Group", recAddPostGrpSetup."Gen. Bus. Posting Group", recBilltoCust."Gen. Bus. Posting Group");
                        ValidateField(1, 1, FieldCaption("VAT Bus. Posting Group"), Format("Document Type"), "No.", 0, "VAT Bus. Posting Group", recAddPostGrpSetup."VAT Bus. Posting Group", recBilltoCust."VAT Bus. Posting Group");
                        ValidateField(1, 1, FieldCaption("Customer Posting Group"), Format("Document Type"), "No.", 0, "Customer Posting Group", recAddPostGrpSetup."Customer Posting Group", recBilltoCust."Customer Posting Group");
                    end;
                    if Invoice and (not "eCommerce Order") then
                        if ZGT.IsRhq and
                           ((ZGT.IsZComCompany and ("Bill-to Customer No." <> "Sell-to Customer No.")) or (ZGT.IsZNetCompany))
                        then
                            ValidateField(1, 1, FieldCaption("Ship-to VAT"), Format("Document Type"), "No.", 0, "Ship-to VAT", recAddPostGrpSetup."VAT Registration No.", '')
                        else
                            ValidateField(1, 1, FieldCaption("VAT Registration No."), Format("Document Type"), "No.", 0, "VAT Registration No.", recAddPostGrpSetup."VAT Registration No.", '');

                    recSalesLine.SetRange("Document Type", "Document Type");
                    recSalesLine.SetRange("Document No.", "No.");
                    recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                    recSalesLine.SetRange("Quantity Invoiced", 0);
                    if recSalesLine.FindSet() then
                        repeat
                            if not recSalesLine."Skip Posting Group Validation" then begin
                                ValidateField(1, 1,
                                  FieldCaption("Gen. Bus. Posting Group"), Format("Document Type"), "No.", recSalesLine."Line No.", recSalesLine."Gen. Bus. Posting Group", recAddPostGrpSetup."Gen. Bus. Posting Group", recBilltoCust."Gen. Bus. Posting Group");
                                ValidateField(1, 1, FieldCaption("VAT Bus. Posting Group"), Format("Document Type"), "No.", recSalesLine."Line No.", recSalesLine."VAT Bus. Posting Group", recAddPostGrpSetup."VAT Bus. Posting Group", recBilltoCust."VAT Bus. Posting Group");
                                ValidateField(1, 1, recSalesLine.FieldCaption("VAT Prod. Posting Group"), Format("Document Type"), "No.", recSalesLine."Line No.", recSalesLine."VAT Prod. Posting Group", recAddPostGrpSetup."VAT Prod. Posting Group", '');
                            end;
                        until recSalesLine.Next() = 0;
                end else
                    ValidateCustomer := true;
            end else
                ValidateCustomer := true;

            if ValidateCustomer then begin
                recBilltoCust.Get("Bill-to Customer No.");
                recSelltoCust.Get("Sell-to Customer No.");

                // Sales Header
                if not "Skip Posting Group Validation" then begin
                    if GuiAllowed() then
                        ValidateField(0, 0, FieldCaption("Currency Code"), Format("Document Type"), "No.", 0, "Currency Code", recBilltoCust."Currency Code", '');
                    ValidateField(0, 1, FieldCaption("Gen. Bus. Posting Group"), Format("Document Type"), "No.", 0, "Gen. Bus. Posting Group", recBilltoCust."Gen. Bus. Posting Group", '');
                    ValidateField(0, 1, FieldCaption("VAT Bus. Posting Group"), Format("Document Type"), "No.", 0, "VAT Bus. Posting Group", recBilltoCust."VAT Bus. Posting Group", '');
                    ValidateField(0, 1, FieldCaption("Customer Posting Group"), Format("Document Type"), "No.", 0, "Customer Posting Group", recBilltoCust."Customer Posting Group", '');
                end;
                if Invoice and (not "eCommerce Order") then
                    if ZGT.IsRhq and ZGT.IsZComCompany and ("Bill-to Customer No." <> "Sell-to Customer No.") then
                        ValidateField(0, 1, FieldCaption("Ship-to VAT"), Format("Document Type"), "No.", 0, "Ship-to VAT", recSelltoCust."VAT Registration No.", '')
                    else
                        ValidateField(0, 1, FieldCaption("VAT Registration No."), Format("Document Type"), "No.", 0, "VAT Registration No.", recBilltoCust."VAT Registration No.", '');

                // Sales Line
                recSalesLine.SetRange("Document Type", "Document Type");
                recSalesLine.SetRange("Document No.", "No.");
                recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                recSalesLine.SetRange("Quantity Invoiced", 0);
                if recSalesLine.FindSet() then
                    repeat
                        if not recSalesLine."Skip Posting Group Validation" then begin
                            ValidateField(0, 1, FieldCaption("Gen. Bus. Posting Group"), Format("Document Type"), "No.", recSalesLine."Line No.", recSalesLine."Gen. Bus. Posting Group", recBilltoCust."Gen. Bus. Posting Group", '');
                            ValidateField(0, 1, FieldCaption("VAT Bus. Posting Group"), Format("Document Type"), "No.", recSalesLine."Line No.", recSalesLine."VAT Bus. Posting Group", recBilltoCust."VAT Bus. Posting Group", '');
                        end;
                    until recSalesLine.Next() = 0;
            end;
            //<< 21-06-21 ZY-LD 045
        end;
    end;

    local procedure ValidateField(Type: Option Customer,"Additional Setup"; "Confirm/Error": Option Confirm,Error; Fieldname: Text; DocumentType: Text; DocumentNo: Code[20]; LineNo: Integer; Value1: Code[20]; Value2: Code[20]; BillToCustValue: Code[20])
    var
        lText001: Label 'The "%1" on the %7 %2 is different from the setup.\\Value on:\%6: "%3".\%5: "%4".';
        Type2Text: Text;
        lText002: Label 'Sales %1';
        lText003: Label '\\Do you want to continue?';
    begin
        //>> 21-06-21 ZY-LD 045
        if (Type = Type::"Additional Setup") and (Value2 = '') then
            Value2 := BillToCustValue;

        if (Value2 <> '') and (Value1 <> Value2) then begin
            if LineNo = 0 then
                Type2Text := DocumentType
            else
                Type2Text := StrSubstNo('%1 (%2)', DocumentType, LineNo);

            DocumentType := StrSubstNo(lText002, DocumentType);
            if ("Confirm/Error" = "confirm/error"::Confirm) and GuiAllowed() then begin
                if not Confirm(lText001 + lText003, false, Fieldname, DocumentNo, Value1, Value2, Format(Type), Type2Text, DocumentType) then
                    Error('');
            end else
                Error(lText001, Fieldname, DocumentNo, Value1, Value2, Format(Type), Type2Text, DocumentType);
        end;
        //<< 21-06-21 ZY-LD 045
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeArchiveUnpostedOrder', '', false, false)]
    local procedure SalesPost_OnBeforeArchiveUnpostedOrder(var IsHandled: Boolean)
    begin
        IsHandled := true;

    end;
}

