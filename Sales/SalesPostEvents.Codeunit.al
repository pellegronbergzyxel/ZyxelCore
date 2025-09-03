codeunit 50080 "Sales Post Events"
{

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
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        SalesHeadEvent: Codeunit "Sales Header/Line Events";
        EmailMgt: Codeunit "E-mail Address Management";
        Text001: Label '"%1" must be filled.\Please contact the Accounting Manager.';


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
        lText001: Label 'Additional item lines must not have a value in "%1".';
        lText002: Label 'You must enter "%1" on item no. "%2" (line %3).';
        lText003: Label 'Because of "Wee Reporting" you need to fill out the "Ship-from Country/Region Code" when "%1" is 1.';
        lText004: Label '"%1" must be filled on Italian invoices.';
        lText005: Label 'Value is not valid in "%1". Expected value is %2.';
        lText006: Label '"%1" must not be 0,00 on sales order %2 line no. %3.';
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
                if not "eCommerce Order" then
                    if "Posting Date" <> Today then
                        if not Confirm(lText028, false, FieldCaption("Posting Date"), "Posting Date") then
                            Error('');

            ValidateAddPostGrpPrLocation(SalesHeader);
            SI.SetAllowToDeleteAddItem(true);

            if "Skip Verify on Inventory" then
                SI.SetSkipVerifyOnInventory(true);


            if "Document Type" in ["document type"::Order, "document type"::Invoice] then
                if ("Location Code" = '') and ("Sales Order Type" <> "sales order type"::"G/L Account") then
                    Error(lText019, FieldCaption("Location Code"), FieldCaption("Sales Order Type"), "Sales Order Type");



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
                            if not "Skip Posting Group Validation" then
                                Error(lText026 + lText027, FieldCaption("VAT Registration No. Zyxel"), "VAT Registration No. Zyxel", recVATRegNoMatrix."VAT Registration No.")
                        end else
                            Error(lText026, FieldCaption("VAT Registration No. Zyxel"), "VAT Registration No. Zyxel", recVATRegNoMatrix."VAT Registration No.");
            end else
                if ZGT.IsRhq() and (not Correction) then begin
                    CalcFields("Amount Including VAT");
                    recAmzOrderHead.SetCurrentkey("Sales Document Type", "eCommerce Order Id", "Invoice No.");
                    recAmzOrderHead.SetAutoCalcFields("Amount Including VAT");
                    recAmzOrderHead.SetRange("Sales Document Type", "Document Type");
                    recAmzOrderHead.SetRange("eCommerce Order Id", "External Document No.");
                    recAmzOrderHead.SetRange("Invoice No.", "External Invoice No.");
                    recAmzOrderHead.FindFirst();
                    // It happens that the shipping has been credited on a "Transaction Type" = Order. Document Type and Tranaction Type will then not match.
                    if ("Document Type" = "document type"::"Credit Memo") and (recAmzOrderHead."Transaction Type" = recAmzOrderHead."transaction type"::Order) then
                        recAmzOrderHead."Amount Including VAT" := -recAmzOrderHead."Amount Including VAT";

                    if Abs(recAmzOrderHead."Amount Including VAT" - "Amount Including VAT") >= 1 then
                        Error(lText029, "No.", "Amount Including VAT", recAmzOrderHead."Amount Including VAT", "External Document No.");
                end;

            if ("Ship-to VAT" = '') and (not "eCommerce Order") then begin
                recCust.Get("Sell-to Customer No.");
                "Ship-to VAT" := recCust."VAT Registration No.";
            end;

            if SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] then begin
                recBillToCust.get(SalesHeader."Bill-to Customer No.");
                if recBillToCust."Payment Terms Code" <> SalesHeader."Payment Terms Code" then
                    if GuiAllowed() then begin
                        if not confirm(lText032 + ltext013, false,
                               SalesHeader.FieldCaption("Payment Terms Code"),
                               recBillToCust."Payment Terms Code",
                               recbilltocust.TableCaption(),
                               SalesHeader."Payment Terms Code",
                               salesheader."Document Type")
                        then
                            error('');
                    end else
                        error(lText032,
                            SalesHeader.FieldCaption("Payment Terms Code"),
                            recBillToCust."Payment Terms Code",
                            recbilltocust.TableCaption(),
                            SalesHeader."Payment Terms Code",
                            salesheader."Document Type");

                // 453154 >>
                if GuiAllowed and SalesHeader.Invoice and recBillToCust."Warning on Not-delivery" then begin
                    SaleslinecheckDD.setrange("Document Type", salesheader."Document Type");
                    SaleslinecheckDD.setrange("Document No.", SalesHeader."No.");
                    SaleslinecheckDD.setfilter("Qty. to Invoice", '<>%1', 0);
                    if SaleslinecheckDD.findset() then
                        repeat
                            if SaleslinecheckDD."Warehouse Status" <> SaleslinecheckDD."Warehouse Status"::Delivered then
                                showwarning := true;
                        until (SaleslinecheckDD.next() = 0) or showwarning;
                    IF showwarning then
                        if not confirm(showwarninglabel, true) then
                            error(showwarningerror);

                end;
                // 453154 <<
            end;

            //>> Sales Line
            if not recPostGrpCtryLoc.Get("Sell-to Country/Region Code", "Location Code") then;
            recSaleLine.Reset();
            recSaleLine.SetRange("Document Type", "Document Type");
            recSaleLine.SetRange("Document No.", "No.");
            recSaleLine.SetFilter(Type, '<>%1', recSaleLine.Type::" ");
            if recSaleLine.FindSet() then begin
                repeat
                    case recSaleLine.Type of
                        recSaleLine.Type::"G/L Account":
                            begin
                                if recSaleLine."Hide Line" and
                                   (recSaleLine."Unit Price" <> 0) and
                                   ((recSaleLine."Qty. to Ship" <> 0) or (recSaleLine."Qty. to Invoice" <> 0)) and
                                   (not GlAccIsReverseLineToChargeItem(recSaleLine))
                                then
                                    Error(lText025, recSaleLine.FieldCaption("Hide Line"), recSaleLine.FieldCaption("Unit Price"), TableCaption(), recSaleLine."Document No.", recSaleLine."Line No.");


                                recSaleLine2.SetRange("Document Type", "Document Type");
                                recSaleLine2.SetRange("Document No.", "No.");
                                recSaleLine2.SetRange(Type, recSaleLine.Type::Item);
                                if recSaleLine2.IsEmpty() and ("Sales Order Type" = "sales order type"::"G/L Account") and (recSaleLine."Location Code" <> '') then
                                    Error(lText017);

                                recSaleLine.TestField("Gen. Bus. Posting Group");
                                recSaleLine.TestField("Gen. Prod. Posting Group");
                                recSaleLine.TestField("VAT Bus. Posting Group");
                                recSaleLine.TestField("VAT Prod. Posting Group");

                            end;
                        recSaleLine.Type::Item:
                            begin
                                if recSaleLine."No." <> '' then begin
                                    if not recSaleLine."Completely Invoiced" then
                                        if recSaleLine."Hide Line" and
                                           (recSaleLine."Unit Price" <> 0) and
                                            ((recSaleLine."Qty. to Ship" <> 0) or (recSaleLine."Qty. to Invoice" <> 0))
                                        then
                                            Error(lText025, recSaleLine.FieldCaption("Hide Line"), recSaleLine.FieldCaption("Unit Price"), TableCaption(), recSaleLine."Document No.", recSaleLine."Line No.");

                                    if recPostGrpCtryLoc."VAT Prod. Post. Group - Sales" <> '' then
                                        if recSaleLine."VAT Prod. Posting Group" <> recPostGrpCtryLoc."VAT Prod. Post. Group - Sales" then
                                            Error(lText005, recSaleLine.FieldCaption("VAT Prod. Posting Group"), recPostGrpCtryLoc."VAT Prod. Post. Group - Sales");
                                    if recPostGrpCtryLoc."Line Discount %" <> 0 then
                                        if recSaleLine."Line Discount %" <> recPostGrpCtryLoc."Line Discount %" then
                                            Error(lText005, recSaleLine.FieldCaption("Line Discount %"), recPostGrpCtryLoc."Line Discount %");

                                    recGPPGrpRetReason.SetRange("Gen. Prod. Posting Group", recSaleLine."Gen. Prod. Posting Group");
                                    recGPPGrpRetReason.SetRange(Mandatory, true);
                                    if recGPPGrpRetReason.FindFirst() and (recSaleLine."Return Reason Code" <> recGPPGrpRetReason."Return Reason Code") then
                                        Error(lText018, recSaleLine.FieldCaption("Return Reason Code"), recSaleLine."Return Reason Code", recSaleLine.FieldCaption("Gen. Prod. Posting Group"), recSaleLine."Gen. Prod. Posting Group");

                                    recGPPGrpRetReason.Reset();
                                    if recGPPGrpRetReason.Get(recSaleLine."Gen. Prod. Posting Group", recSaleLine."Return Reason Code") then begin
                                        if recGPPGrpRetReason."Sales Unit Price Must be Zero" then
                                            if recSaleLine."Unit Price" <> 0 then
                                                Error(lText020, recSaleLine.FieldCaption("Unit Price"), recSaleLine."Line No.");

                                        if recGPPGrpRetReason."Max. Sales Unit Price" <> 0 then
                                            if ((recSaleLine."Qty. to Ship" <> 0) or (recSaleLine."Qty. to Invoice" <> 0)) and
                                               (recSaleLine."Unit Price" > recGPPGrpRetReason."Max. Sales Unit Price")
                                            then
                                                Error(lText024, recSaleLine.FieldCaption("Unit Price"), recGPPGrpRetReason."Max. Sales Unit Price", recSaleLine."Line No.");

                                    end;

                                    if not recSaleLine."Hide Line" then begin
                                        recGenBusPostGrp.Get(recSaleLine."Gen. Bus. Posting Group");
                                        if recGenBusPostGrp."Sample / Test Equipment" > recGenBusPostGrp."sample / test equipment"::" " then begin
                                            if (recSaleLine."Qty. to Ship" <> 0) or (recSaleLine."Qty. to Invoice" <> 0) then begin
                                                if recSaleLine."Unit Cost" = 0 then
                                                    Error(lText006, recSaleLine.FieldCaption("Unit Cost"), "No.", recSaleLine."Line No.");

                                                if recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."sample / test equipment"::"Sample (Unit Price = Zero)" then begin
                                                    if recSaleLine."Unit Price" <> 0 then
                                                        Error(lText022, recSaleLine.FieldCaption("Unit Price"), "No.", recSaleLine."Line No.", LowerCase(recSaleLine."Gen. Bus. Posting Group"));
                                                end else
                                                    if recSaleLine."Unit Price" <> recSaleLine."Unit Cost" then
                                                        Error(lText021, recSaleLine.FieldCaption("Unit Price"), "No.", recSaleLine."Line No.", recSaleLine.FieldCaption("Unit Cost"));

                                            end;
                                        end else

                                            if ZGT.IsZNetCompany() and
                                               (recSaleLine."Unit Price" = 0) and
                                               ((recSaleLine."Qty. to Ship" <> 0) or (recSaleLine."Qty. to Invoice" <> 0)) and
                                               (not recSaleLine."Zero Unit Price Accepted")
                                            then
                                                ItemWithZeroPriceFound := true;

                                        if "Location Code" <> recSaleLine."Location Code" then
                                            Error(lText014);

                                        if ("Sales Order Type" <> "sales order type"::"G/L Account") and (recSaleLine."Location Code" = '') then
                                            Error(lText016);

                                    end;

                                    if (recSaleLine."Document Type" <> recSaleLine."Document Type"::"Credit Memo") and (recSaleLine."Document Type" <> recSaleLine."Document Type"::"Return Order") then
                                        IF (recSaleLine."Qty. to Ship" <> 0) OR (recSaleLine."Qty. to Invoice" <> 0) then begin
                                            recLocation.get(recSaleLine."Location Code");
                                            if not recLocation."Allow Unit Cost is Zero" then begin
                                                recItem.get(recSaleLine."No.");
                                                ItemLedgEntry.SetCurrentKey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                                                ItemLedgEntry.SetRange("Item No.", recItem."No.");
                                                ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Purchase);
                                                ItemLedgEntry.SetRange("Location Code", recSaleLine."Location Code");
                                                ItemLedgEntry.SetFilter("Cost Posted to G/L", '<>0');
                                                if (recItem.Type = recItem.type::Inventory) and ((not recItem."Allow Unit Cost is Zero") or (ItemLedgEntry.FindLast())) then
                                                    recSaleLine.TESTFIELD("Unit Cost (LCY)");
                                            end;
                                        end;

                                    if SalesHeader.Invoice and (recSaleLine."Unit Price" = 0) and (recSaleLine."Line Discount %" <> 0) then
                                        Error(lText031, recSaleLine.FieldCaption("Line Discount %"), recSaleLine.FieldCaption("Unit Price"), recSaleLine."Line No.");

                                    if SI.GetPostDamage() and SI.GetWarehouseManagement() then
                                        if recSaleLine."Unit Price" <> 0 then
                                            error(lText033, recSaleLine.FieldCaption("Unit Price"));
                                end;


                                recSaleLine.TestField("Gen. Bus. Posting Group");
                                recSaleLine.TestField("Gen. Prod. Posting Group");
                                recSaleLine.TestField("VAT Bus. Posting Group");
                                recSaleLine.TestField("VAT Prod. Posting Group");
                            end;
                        recSaleLine.Type::"Charge (Item)":
                            begin
                                if not recSaleLine."Hide Line" then
                                    Error(lText002, recSaleLine.Type, recSaleLine.FieldCaption("Hide Line"), recSaleLine."Line No.");

                                recSaleLine.TestField("Gen. Bus. Posting Group");
                                recSaleLine.TestField("Gen. Prod. Posting Group");
                                recSaleLine.TestField("VAT Bus. Posting Group");
                                recSaleLine.TestField("VAT Prod. Posting Group");
                            end;
                    end;
                until recSaleLine.Next() = 0;

                if ItemWithZeroPriceFound then
                    if Ship then begin
                        if not GuiAllowed() then begin
                            EmailMgt.CreateEmailWithBodytext2('LOGORDERS', '', StrSubstNo(lText012, recSaleLine.FieldCaption("Unit Price"), Lowercase(Format("Document Type")), "No."), '');
                            EmailMgt.Send();
                        end else
                            if not Confirm(lText012 + lText013, false, recSaleLine.FieldCaption("Unit Price"), LowerCase(Format("Document Type")), "No.") then
                                Error('');
                    end else
                        if not GuiAllowed() then
                            Error(lText012, recSaleLine.FieldCaption("Unit Price"), LowerCase(Format("Document Type")), "No.")
                        else
                            if not Confirm(lText012 + lText013, false, recSaleLine.FieldCaption("Unit Price"), LowerCase(Format("Document Type")), "No.") then
                                Error('');
            end;

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

            if ZGT.IsZComCompany() then
                if "Document Type" in ["document type"::"Credit Memo"] then
                    if ("Location Code" = 'PP') and ("Bill-to Country/Region Code" = 'IT') then begin
                        TestField("Ship-to Code", "Location Code");
                        TestField("Ship-to Address");
                        TestField("Ship-to Post Code");
                        TestField("Ship-to City");
                    end;

            if (("Document Type" = "document type"::Order) and Invoice) or
               ("Document Type" = "document type"::Invoice)
            then begin
                //recInvSetup.GET;  // The read has been moved up.
                recGenBusPostGrp.Get("Gen. Bus. Posting Group");
                if ZGT.IsRhq() and not ZGT.IsZNetCompany() then
                    if recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."sample / test equipment"::" " then
                        if ("Bill-to Country/Region Code" = 'IT') and ("Location Code" = recInvSetup."AIT Location Code") and ("E-Invoice Comment" = '') then
                            Error(lText004, FieldCaption("E-Invoice Comment"));

                if ZGT.CompanyNameIs(11) then begin  // DE
                    recSaleLine.Reset();
                    recSaleLine.SetRange("Document Type", "Document Type");
                    recSaleLine.SetRange("Document No.", "No.");
                    recSaleLine.SetRange(Type, recSaleLine.Type::Item);

                    if ("Ship-to Country/Region Code" <> 'DK') and
                       ("Shipment Date" = 0D) and
                       (recSaleLine.FindFirst())
                    then
                        FieldError("Shipment Date");
                end;

                if recCustPriceGrp.Get("Customer Price Group") and recCustPriceGrp.Blocked then
                    Error(lText015, FieldCaption("Customer Price Group"), "Customer Price Group");

            end;

            if ZGT.IsRhq() then
                case "Document Type" of
                    "document type"::Invoice:
                        begin
                            recCust.Get("Sell-to Customer No.");

                            if "Sales Order Type" = "sales order type"::Normal then begin
                                CalcFields("No of Lines", "Total Quantity", "Picking List No.", Amount, "Line Discount Amount");
                                recDelDocHead.SetAutoCalcFields("No of Lines", "Total Quantity", Amount);
                                if (recCust."Create Invoice pr. Order") and ("Create Invoice pr. Order No." <> '') then
                                    recDelDocHead.SetRange("Sales Order No. Filter", "Create Invoice pr. Order No.");


                                if recDelDocHead.Get("Picking List No.") then begin
                                    if recDelDocHead."No of Lines" <> "No of Lines" then
                                        if not Confirm(lText009, false, "No of Lines", recDelDocHead."No of Lines") then
                                            Error('');
                                    if recDelDocHead."Total Quantity" <> "Total Quantity" then
                                        if not Confirm(lText010, false, "Total Quantity", recDelDocHead."Total Quantity") then
                                            Error('');
                                    if Amount + "Line Discount Amount" <> Round(recDelDocHead.Amount) then
                                        if not Confirm(lText011, false, Amount, recDelDocHead.Amount) then
                                            Error('');
                                end;
                            end;

                            if ZGT.IsZComCompany() then begin
                                recSaleLine.Reset();
                                recSaleLine.SetRange("Document Type", "Document Type");
                                recSaleLine.SetRange("Document No.", "No.");
                                recSaleLine.SetRange(Type, recSaleLine.Type::Item);
                                recSaleLine.SetFilter("Shipment No.", '<>%1', '');

                                if recCust."Create Invoice pr. Order" and (recSaleLine.FindFirst()) then
                                    TestField("Your Reference");
                            end;


                        end;

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

            // Eicards must have an machine code if it's marked on the item.
            if ("Document Type" = "document type"::Order) and ("Sales Order Type" = "sales order type"::EICard) then begin
                recBillToCust.Get("Bill-to Customer No.");
                if recBillToCust."Post EiCard Invoice Automatic" > recBillToCust."post eicard invoice automatic"::" " then begin
                    if recBillToCust."Post EiCard Invoice Automatic" = recBillToCust."post eicard invoice automatic"::"Yes (when purchase invoice is posted)" then
                        SetRange("EiCard iPurch Order St. Filter", "eicard ipurch order st. filter"::Posted);
                    CalcFields("EiCard Ready to Post");
                    if not "EiCard Ready to Post" then
                        Error(lText008, "No.");
                end;

                recSaleLine.Reset();
                recSaleLine.SetRange("Document Type", "Document Type");
                recSaleLine.SetRange("Document No.", "No.");
                recSaleLine.SetRange(Type, recSaleLine.Type::Item);
                if recSaleLine.FindSet() then
                    repeat
                        recItem.Get(recSaleLine."No.");
                        if recItem."Enter Security for Eicard on" = recItem."enter security for eicard on"::"GLC License" then begin //25-08-25 BK #505159
                            recAddEicardOrderInfo.SetRange("Document Type", recSaleLine."Document Type");
                            recAddEicardOrderInfo.SetRange("Document No.", recSaleLine."Document No.");
                            recAddEicardOrderInfo.SetRange("Sales Line Line No.", recSaleLine."Line No.");
                            recAddEicardOrderInfo.SetRange(Validated, true);
                            if recSaleLine.Quantity <> recAddEicardOrderInfo.Count() then
                                Error(lText030, recSaleLine.Quantity, Format(recItem."Enter Security for Eicard on"), recAddEicardOrderInfo.Count());
                        end;
                    until recSaleLine.Next() = 0;
            end;

            SI.SetRejectChangeLog(true);
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        recSaleInvHead: Record "Sales Invoice Header";
        recSaleCrHead: Record "Sales Cr.Memo Header";
        recSalesSetup: Record "Sales & Receivables Setup";
        recEiCardQueue: Record "EiCard Queue";
        recDelDocHead: Record "VCK Delivery Document Header";
        recSaleDocEmail: Record "Sales Document E-mail Entry";
        recCust: Record Customer;
        recEmailAdd: Record "E-mail address";
        recWhseInbHead: Record "Warehouse Inbound Header";
        recValueEntry: Record "Value Entry";
        recItemLedgEntry: Record "Item Ledger Entry";
        recAmzonOrderHead: Record "eCommerce Order Header";
        recAmzOrderLine: Record "eCommerce Order Line";
        recAmzOrderLineArc: Record "eCommerce Order Line Archive";
        recAmzOrderArc: Record "eCommerce Order Archive";
        SalesOrder: Record "Sales Header";
        NLtoDKPosting: Report "NL to DK Posting";
        lText001: Label 'The invoice will be e-mailed to the warehouse (%1).\%2';
        lText002: Label 'The invoice %1 is succesfully added to the e-mail queue.';
        lText003: Label 'The invoice %1 must be e-mailed manually to the customer.';
        lText004: Label 'It was not possible to e-mail the invoice to the warehouse!!!';
        MessageText: Text;
    begin
        with SalesHeader do begin
            if (("Document Type" = "document type"::Order) and Invoice) or
                ("Document Type" = "document type"::Invoice)
            then
                if ZGT.IsRhq() then begin
                    recSaleInvHead.SetAutoCalcFields("Picking List No.");
                    recSaleInvHead.Get(SalesInvHdrNo);
                    if recSaleInvHead."Picking List No." <> '' then begin
                        recDelDocHead.Get(recSaleInvHead."Picking List No.");
                        recDelDocHead."Document Status" := recDelDocHead."document status"::Posted;
                        recDelDocHead.Modify();
                    end;

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

            if "eCommerce Order" and (not Correction) then begin
                recAmzonOrderHead.SetCurrentkey("Sales Document Type", "eCommerce Order Id", "Invoice No.");
                recAmzonOrderHead.SetRange("Sales Document Type", "Document Type");
                recAmzonOrderHead.SetRange("eCommerce Order Id", "External Document No.");
                recAmzonOrderHead.SetRange("Invoice No.", "External Invoice No.");
                if recAmzonOrderHead.FindFirst() then begin
                    recAmzOrderArc.TransferFields(recAmzonOrderHead);
                    recAmzOrderArc."Date Archived" := Today();
                    recAmzOrderArc."Posting Date" := "Posting Date";
                    recAmzOrderArc.Insert(true);

                    recAmzOrderLine.SetRange("eCommerce Order Id", recAmzonOrderHead."eCommerce Order Id");
                    recAmzOrderLine.SetRange("Invoice No.", recAmzonOrderHead."Invoice No.");
                    if recAmzOrderLine.FindSet() then
                        repeat
                            recAmzOrderLineArc.TransferFields(recAmzOrderLine);
                            recAmzOrderLineArc.Insert(true);
                        until recAmzOrderLine.Next() = 0;

                    recAmzonOrderHead.Delete(true);

                    SalesOrder.SetRange("Document Type", SalesOrder."Document Type"::Order);
                    SalesOrder.SetRange("Sales Order Type", SalesOrder."Sales Order Type"::eCommerce);
                    SalesOrder.SetRange("External Document No.", "External Document No.");
                    if SalesOrder.FindFirst() then
                        SalesOrder.Delete(true);
                    COMMIT();
                end;
            end;

            case "Document Type" of
                "document type"::Order:
                    if ("Sales Order Type" = "sales order type"::EICard) and (SalesInvHdrNo <> '') then
                        if recEiCardQueue.Get(SalesHeader."No.") then begin
                            recEiCardQueue.Validate("Sales Order Status", recEiCardQueue."sales order status"::Posted);
                            recEiCardQueue.Modify(true);
                        end;

                "document type"::"Return Order":
                    if SalesCrMemoHdrNo <> '' then begin
                        recSaleCrHead.SetAutoCalcFields("Warehouse Inbound No.");
                        recSaleCrHead.Get(SalesCrMemoHdrNo);
                        if recWhseInbHead.Get(recSaleCrHead."Warehouse Inbound No.") then begin
                            recWhseInbHead.Validate("Document Status", recWhseInbHead."document status"::Posted);
                            recWhseInbHead.Modify(true);
                        end;
                    end;

                "document type"::Invoice:
                    begin
                        UpdateOutboxSalesHeader(SalesHeader);

                        recSaleInvHead.SetAutoCalcFields("Picking List No.");
                        recSaleInvHead.Get(SalesInvHdrNo);
                        if ZGT.IsRhq() and SerialNoAttached(SalesInvHdrNo) then
                            recSaleInvHead."Serial Numbers Status" := recSaleInvHead."serial numbers status"::Attached;

                        recSaleInvHead.Modify();

                        if ZGT.IsRhq() and
                           ("Sales Order Type" <> "sales order type"::EICard)
                        then begin
                            recSalesSetup.Get();
                            recSalesSetup.TestField("Customer No. on Sister Company");
                            if (ZGT.IsZNetCompany() and ("Sell-to Customer No." = recSalesSetup."Customer No. on Sister Company")) or  // ZNet
                               (not ZGT.IsZNetCompany() and ("Sell-to Customer No." = recSalesSetup."Customer No. on Sister Company"))  // Zyxel
                            then begin
                                SalesHeadEvent.UpdateUnshippedQuantity("Sell-to Customer No.");
                                SalesHeadEvent.SendContainerDetails(SalesInvHdrNo, "Sell-to Customer No.");
                            end;
                        end;

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

                        if SalesHeader."NL to DK Reverse Chg. Doc No." <> '' then
                            NLtoDKPosting.NLtoDKRevChargePosted(SalesHeader."NL to DK Reverse Chg. Doc No.", SalesHeader."Document Type");
                    end;
                "document type"::"Credit Memo":
                    begin
                        UpdateOutboxSalesHeader(SalesHeader);

                        if SalesCrMemoHdrNo <> '' then begin
                            recSaleCrHead.SetAutoCalcFields("Warehouse Inbound No.");
                            recSaleCrHead.Get(SalesCrMemoHdrNo);
                            if recWhseInbHead.Get(recSaleCrHead."Warehouse Inbound No.") then begin
                                recWhseInbHead.Validate("Document Status", recWhseInbHead."document status"::Posted);
                                recWhseInbHead.Modify(true);
                            end;
                        end;

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

                        NLtoDKPosting.NLtoDKRevChargePosted(SalesHeader."NL to DK Reverse Chg. Doc No.", SalesHeader."Document Type");
                    end;
            end;

            SI.SetAllowToDeleteAddItem(false);
            SI.SetRejectChangeLog(false);
            SI.SetSkipVerifyOnInventory(false);
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure SalesPost_OnBeforeSalesInvLineInsert(SalesLine: Record "Sales Line" temporary; var SalesInvLine: Record "Sales Invoice Line")
    var
        ItemChargeAss: Record "Item Charge Assignment (Sales)";
        PostItemChargeInv: Record "Posted Item Charge (Sales-Inv)";
    begin
        with SalesLine do

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
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesCrMemoLineInsert', '', false, false)]
    local procedure SalesPost_OnBeforeSalesCrMemoLineInsert(SalesLine: Record "Sales Line" temporary; var SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        ItemChargeAss: Record "Item Charge Assignment (Sales)";
        PostItemChargeCrM: Record "Posted Item Charge (Sales-CrM)";
    begin
        with SalesLine do
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
                NumberArr[1] := SalesHeader."Sell-to Customer No.";
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesInvoice(var Rec: Record "Sales Invoice Header"; RunTrigger: Boolean)
    var
    begin
        with Rec do begin
            if "Bill-to Customer No." <> '' then
                if "Bill-to Country/Region Code" = '' then
                    Error(Text001, FieldCaption("Bill-to Country/Region Code"));

            if ZGT.IsRhq() then
                if "Sell-to Customer No." = "Bill-to Customer No." then
                    "Invoice No. for End Customer" := "No.";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesInvoice(var Rec: Record "Sales Invoice Header"; RunTrigger: Boolean)
    var
        recLocation: Record Location;
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
    begin
        with Rec do
            if not ZGT.IsRhq() then
                // Updates RHQ with end customer no.
                if not "eCommerce Order" then
                    if ZGT.TurkishServer() then
                        ZyWebServMgt.SendSalesInvoiceNo(CopyStr(ZGT.GetRHQCompanyName(), 1, 30), "Your Reference", "No.")
                    else
                        if "Location Code" <> '' then begin
                            recLocation.Get("Location Code");
                            if recLocation."Comp Name for Return SInvNo" <> '' then
                                ZyWebServMgt.SendSalesInvoiceNo(recLocation."Comp Name for Return SInvNo", "External Document No.", "No.")
                            else
                                ZyWebServMgt.SendSalesInvoiceNo(CopyStr(ZGT.GetRHQCompanyName(), 1, 30), "External Document No.", "No.")
                        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesCrMemo(var Rec: Record "Sales Cr.Memo Header"; RunTrigger: Boolean)
    var
    begin
        with Rec do
            if "Bill-to Customer No." <> '' then
                if "Bill-to Country/Region Code" = '' then
                    Error(Text001, FieldCaption("Bill-to Country/Region Code"));
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesCrMemoLine(var Rec: Record "Sales Cr.Memo Line"; RunTrigger: Boolean)
    var
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
    begin
        with Rec do
            if not IsTemporary() then begin
                recSalesCrMemoHead.Get("Document No.");
                "Document Date" := recSalesCrMemoHead."Document Date";
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesShipLine(var Rec: Record "Sales Shipment Line"; RunTrigger: Boolean)
    var
        recSalesHead: Record "Sales Header";
        lText001: Label '"%1" "%2" must be equal to the "%1" on the "%3" "%4".';
    begin
        with Rec do
            if not IsTemporary then
                if "Order No." <> '' then begin
                    recSalesHead.Get(recSalesHead."document type"::Order, "Order No.");
                    if (Type = Type::Item) and
                       ("No." <> '') and
                       ("Bill-to Customer No." <> recSalesHead."Bill-to Customer No.")
                    then
                        Error(lText001, FieldCaption("Bill-to Customer No."), "Bill-to Customer No.", recSalesHead.TableCaption(), recSalesHead."Bill-to Customer No.");
                end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesShipLine(var Rec: Record "Sales Shipment Line"; RunTrigger: Boolean)
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        recSalesLine: Record "Sales Line";
        lText001: Label 'Quantity on "%1" and quantity on "%2" (%8) is not equal on SO "%3" SO line "%4" and dev doc (%5). DD-line %6 against %7';

    begin
        with Rec do
            if not IsTemporary then
                if not Correction then begin
                    recDelDocLine.SetRange("Document No.", "Picking List No.");
                    recDelDocLine.SetRange("Sales Order No.", "Order No.");
                    recDelDocLine.SetRange("Sales Order Line No.", Rec."Order Line No.");
                    recDelDocLine.SetRange(Posted, false);
                    if recDelDocLine.FindFirst() then begin
                        if recDelDocLine.Quantity <> Quantity then
                            Error(lText001, recDelDocLine.TableCaption(), TableCaption(), "Order No.", "Order Line No.", "Picking List No.", recDelDocLine.Quantity, Quantity, Rec."No.");
                        recDelDocLine.Validate(Posted, true);
                        recDelDocLine.Modify();
                    end;
                end else begin
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
                end;
    end;

    local procedure SerialNoAttached(pSalesInvNo: Code[20]): Boolean
    var
        recSalesShipLine: Record "Sales Shipment Line";
        recSalesInvLine: Record "Sales Invoice Line";
        recSerialNo: Record "VCK Delivery Document SNos";
    begin

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
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesInvLine(var Rec: Record "Sales Invoice Line"; RunTrigger: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PostSales-Delete", 'OnAfterDeleteHeader', '', false, false)]
    local procedure OnAfterDeleteHeader(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var SalesInvoiceHeaderPrepmt: Record "Sales Invoice Header"; var SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header")
    var
        recAmzOrderHead: Record "eCommerce Order Header";
        lText001: Label 'DEL: %1';
        lText002: Label '"%1" %2 is opened.';
    begin
        with SalesHeader do
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

                    recAmzOrderHead.SetCurrentkey("Sales Document Type", "eCommerce Order Id", "Invoice No.");
                    recAmzOrderHead.SetRange("Sales Document Type", "Document Type");

                    recAmzOrderHead.SetRange("eCommerce Order Id", "External Document No.");
                    recAmzOrderHead.SetRange("Invoice No.", "External Invoice No.");
                    recAmzOrderHead.SetRange(Open, false);
                    if recAmzOrderHead.FindFirst() then begin
                        recAmzOrderHead.Open := true;
                        recAmzOrderHead.Modify();
                        Message(lText002, recAmzOrderHead.TableCaption(), "External Document No.");
                    end;
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeShowPostedDocsToPrintCreatedMsg', '', false, false)]
    local procedure SalesHeader_OnBeforeShowPostedDocsToPrintCreatedMsg(var ShowPostedDocsToPrint: Boolean)
    var
        SI: Codeunit "Single Instance";
    begin
        ShowPostedDocsToPrint := not SI.GetHideSalesDialog();
    end;

    local procedure UpdateOutboxSalesHeader(var SalesHeader: Record "Sales Header")
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
                                lIcOutbSaleHead."Posting Date" := Today();
                            if ICPartner."Set Document Date to Today" then
                                lIcOutbSaleHead."Document Date" := Today();
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
            if ("Ship-to Country/Region Code" <> '') and ("Location Code" <> '') and ("Sell-to Customer No." <> '') then begin
                if Invoice then begin
                    recAddBillToSetup.SetRange("Country/Region Code", "Sell-to Country/Region Code");
                    recAddBillToSetup.SetRange("Location Code", "Location Code");
                    recAddBillToSetup.SetFilter("Customer No.", '%1|%2', '', "Sell-to Customer No.");
                    if ZGT.IsRhq() then
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
                if ZGT.IsRhq() then
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
                        if ZGT.IsRhq() and
                           ((ZGT.IsZComCompany() and ("Bill-to Customer No." <> "Sell-to Customer No.")) or (ZGT.IsZNetCompany()))
                        then
                            ValidateField(1, 1, FieldCaption("Ship-to VAT"), Format("Document Type"), "No.", 0, copystr("Ship-to VAT", 1, 20), recAddPostGrpSetup."VAT Registration No.", '')
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
                    if ZGT.IsRhq() and ZGT.IsZComCompany() and ("Bill-to Customer No." <> "Sell-to Customer No.") then
                        ValidateField(0, 1, FieldCaption("Ship-to VAT"), Format("Document Type"), "No.", 0, copystr("Ship-to VAT", 1, 20), recSelltoCust."VAT Registration No.", '')
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
        end;
    end;

    local procedure ValidateField(Type: Option Customer,"Additional Setup"; "Confirm/Error": Option Confirm,Error; Fieldname: Text; DocumentType: Text; DocumentNo: Code[20]; LineNo: Integer; Value1: Code[20]; Value2: Code[20]; BillToCustValue: Code[20])
    var
        lText001: Label 'The "%1" on the %7 %2 is different from the setup.\\Value on:\%6: "%3".\%5: "%4".';
        Type2Text: Text;
        lText002: Label 'Sales %1';
        lText003: Label '\\Do you want to continue?';
    begin

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
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeArchiveUnpostedOrder', '', false, false)]
    local procedure SalesPost_OnBeforeArchiveUnpostedOrder(var IsHandled: Boolean)
    begin
        IsHandled := true;

    end;
}

