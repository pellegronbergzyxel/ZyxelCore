codeunit 50067 "Sales Header/Line Events"
{

    Permissions = TableData "Dimension Value" = i,
                  TableData "Warehouse Comment Line" = id,
                  TableData "Warehouse Receipt Header" = id,
                  TableData "Warehouse Receipt Line" = id,
                  TableData "Warehouse Shipment Header" = id,
                  TableData "Warehouse Shipment Line" = id,
                  TableData "Whse. Pick Request" = id,
                  TableData "Picking Date Confirmed" = rimd,
                  TableData "Warehouse Inbound Header" = d,
                  TableData "EiCard Queue" = d,
                  TableData "VCK Shipping Detail" = d,
                  TableData "EiCard Link Line" = d,
                  tabledata "Sales Shipment Header" = m,
                  tabledata "Sales Shipment Line" = m;

    trigger OnRun()
    begin
    end;

    var
        //ZGT: Codeunit "ZyXEL General Tools";
        //SI: Codeunit "Single Instance";
        EmailAddMgt: Codeunit "E-mail Address Management";
        Text001: Label '"%1" %2 is not a valid date.';
    //Text002: Label '\\Please contact navsupport@zyxel.eu to find a solution.';


    //>> Sales Header
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesHeader(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        Rec."Create User ID" := copystr(UserId(), 1, 30);
        Rec."Create Date" := Today();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesHeader(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var
        recEiCardQueue: Record "EiCard Queue";
        recSalesHead: Record "Sales Header";
    begin

        if Rec."Document Type" = Rec."document type"::Order then
            if (Rec."Sales Order Type" = Rec."sales order type"::EICard) and
               (Rec."No." <> '') and
               (recSalesHead.Get(recSalesHead."document type"::Order, Rec."No."))
            then
                if not recEiCardQueue.Get(Rec."No.") then begin
                    recEiCardQueue."Sales Order No." := Rec."No.";
                    recEiCardQueue."End User E-mail" := Rec."EiCard To Email 1";
                    recEiCardQueue.Insert(true);
                    Commit();
                end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteSalesHeader(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        Rec."Send Mail" := false;
        if not Rec.Invoice then
            Rec."NL to DK Reverse Chg. Doc No." := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInitRecord', '', false, false)]
    local procedure OnBeforeInitRecord(var SalesHeader: Record "Sales Header")
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SaveSalesHeader(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', false, false)]
    local procedure OnAfterInitRecord(var SalesHeader: Record "Sales Header")
    var
        recSalesHead: Record "Sales Header";
        SI: Codeunit "Single Instance";
        CompanyText: Text;
    begin
        begin
            if SalesHeader."Document Type" in [SalesHeader."document type"::Order, SalesHeader."document type"::Invoice, SalesHeader."document type"::Quote] then
                CompanyText := CompanyName();

            if SalesHeader."Document Type" in [SalesHeader."document type"::Order, SalesHeader."document type"::Quote] then
                if SalesHeader."Requested Delivery Date" = 0D then
                    SalesHeader."Requested Delivery Date" := Today();

            SI.GetSalesHeader(recSalesHead);
            if recSalesHead."Location Code" <> '' then
                SalesHeader.Validate(SalesHeader."Location Code", recSalesHead."Location Code");
            SI.ClearSalesHeader();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnBeforeValidateSelltoCustomerNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recCust: Record Customer;
        ServerEnviron: Record "Server Environment";
        ZGT: Codeunit "ZyXEL General Tools";
        lText001: Label '%1 must not be blank.';

    begin
        begin
            if ZGT.IsRhq() then
                if serverenviron.ProductionEnvironment() then   // Find another solution here with Doc Capture.
                    if Rec."Document Type" in [Rec."document type"::Order, Rec."document type"::Invoice] then
                        if Rec."Sales Order Type" = Rec."sales order type"::" " then
                            Error(lText001, Rec.FieldCaption(Rec."Sales Order Type"));

            if Rec."Sell-to Customer No." <> '' then begin
                recCust.Get(Rec."Sell-to Customer No.");
                if (Rec."Sales Order Type" <> Rec."sales order type"::" ") and
                   (Rec."Sales Order Type" <> Rec."sales order type"::"G/L Account")
                then
                    recCust.TestField("Location Code");
                Rec."Salesperson Code" := recCust."Salesperson Code";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    procedure "OnAfterValidateSell-toCustomerNo"(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recCust: Record Customer;
        SI: Codeunit "Single Instance";
        lText001: Label 'Please send the order document to scanning "%1" for %2.\\If you want to continue with a manual order, please click Yes.\Do you want to continue?';
        DeletedDocument: Boolean;

    begin
        recCust.Get(Rec."Sell-to Customer No.");
        Rec.Validate(Rec."Ship-to VAT", recCust."VAT Registration No.");
        if (Rec."Document Type" = Rec."document type"::Order) and
           not SI.GetHideSalesDialog()
        then
            if recCust."E-mail for Order Scanning" <> '' then
                if not Confirm(lText001, false, recCust."E-mail for Order Scanning", recCust.Name) then begin
                    SI.SetDeleteSalesOrder(true);
                    DeletedDocument := true;
                end;

        if not DeletedDocument then begin
            Rec."Salesperson Code" := "GetSale/PurchCode"(Rec."Salesperson Code", 0);
            Rec."Order Desk Resposible Code" := "GetSale/PurchCode"(recCust."Order Desk Resposible Code", 1);
            Rec."Intercompany Purchase" := recCust."Intercompany Purchase";
            Rec."Customer Price Group" := recCust."Customer Price Group";  //Keep Customer price group from Sell-To Customer
            if (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.") and
               (Rec."Currency Code" <> recCust."Currency Code")
            then
                Rec."Currency Code Sales Doc SUB" := recCust."Currency Code";

            CreateDim_SellToCustomerNo(Rec, xRec);

            if not SI.GetHideSalesDialog() then
                EnterSelectedFieldsOnSalesDocument(Rec, xRec);

            Eicard_UpdateCustomerNo(Rec);


            SetAddPostGrpPrLocation(Rec, xRec, CurrFieldNo);
            SetZyxelVATRegistrationNo(Rec, xRec, CurrFieldNo);
            Rec.Validate(Rec."Send Mail");
        end;

        Rec.Validate(Rec."Skip Posting Group Validation", recCust."Skip Posting Group Validation");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeLookupSellToContactNo', '', false, false)]
    local procedure OnBeforeValidateSellToContactNo(var SalesHeader: Record "Sales Header")
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SaveSalesHeader(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Contact No.', false, false)]
    local procedure OnAfterValidateSellToContactNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recShiptoAdd: Record "Ship-to Address";
        SI: Codeunit "Single Instance";
    begin
        if Rec."Document Type" = Rec."document type"::Quote then begin
            Rec.SetHideValidationDialog(true);
            SI.GetSalesHeader(recSalesHead);
            if Rec."Sales Order Type" = Rec."sales order type"::EICard then begin
                if recShiptoAdd.Get(Rec."Sell-to Customer No.", recSalesHead."Location Code") then
                    Rec.Validate(Rec."Ship-to Code", recSalesHead."Location Code")
                else
                    Rec."Ship-to Code" := recSalesHead."Location Code";
                Rec.Validate(Rec."Location Code", recSalesHead."Location Code");
                Rec.Modify(true);

                recSalesLine.SetRange("Document Type", Rec."Document Type");
                recSalesLine.SetRange("Document No.", Rec."No.");
                recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                if recSalesLine.FindSet(true) then begin
                    recSalesLine.SetHideValidationDialog(true);
                    repeat
                        recSalesLine.Validate("Location Code", recSalesHead."Location Code");
                        recSalesLine.Modify(true);
                    until recSalesLine.Next() = 0;
                    recSalesLine.SetHideValidationDialog(false);
                end;
            end;
            Rec.SetHideValidationDialog(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Location Code', false, false)]
    local procedure OnBeforeValidateSHLocationCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recLocation: Record Location;
        SI: Codeunit "Single Instance";
        lText001: Label '"%1" %2 does not match "%3" %4.';

    begin
        if (Rec."Document Type" in [Rec."document type"::Quote, Rec."document type"::Order, Rec."document type"::Invoice]) and
           (Rec."Sales Order Type" <> Rec."sales order type"::" ")
        then
            if recLocation.Get(Rec."Location Code") then
                if (Rec."Sales Order Type" <> recLocation."Sales Order Type") and
                   (Rec."Sales Order Type" <> recLocation."Sales Order Type 2") and
                   (CurrFieldNo = Rec.FieldNo(Rec."Location Code"))
                then
                    Error(lText001, Rec.FieldCaption(Rec."Location Code"), Rec."Location Code", Rec.FieldCaption(Rec."Sales Order Type"), Rec."Sales Order Type");

        if (CurrFieldNo <> Rec.FieldNo(Rec."Location Code")) and
           (CurrFieldNo <> Rec.FieldNo(Rec."Sales Order Type")) and
           (not SI.GetKeepLocationCode())
        then
            if (Rec."Document Type" = Rec."document type"::Order) or
               (Rec."Document Type" = Rec."document type"::Invoice) or
               (Rec."Document Type" = Rec."document type"::Quote)
            then
                if xRec."Location Code" <> '' then
                    Rec."Location Code" := xRec."Location Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure OnAfterValidateSHLocationCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recSalesLine: Record "Sales Line";
        recSalesLine2: Record "Sales Line";
        lText001: Label '"%1" must not be blank on "%2" %3.';
    begin
        if Rec."Document Type" in [Rec."document type"::Order, Rec."document type"::Invoice] then
            if ((Rec."Location Code" = '') and (xRec."Location Code" <> '')) and (Rec."Sales Order Type" <> Rec."sales order type"::"G/L Account") then
                Error(lText001, Rec.FieldCaption(Rec."Location Code"), Rec.FieldCaption(Rec."Sales Order Type"), Rec."Sales Order Type");

        if Rec."Location Code" <> xRec."Location Code" then begin
            recSalesLine.SetRange("Document Type", Rec."Document Type");
            recSalesLine.SetRange("Document No.", Rec."No.");
            recSalesLine.SetRange("Location Code", xRec."Location Code");
            if recSalesLine.FindSet(true) then
                repeat
                    recSalesLine2 := recSalesLine;
                    recSalesLine2.Validate("Location Code", Rec."Location Code");
                    recSalesLine2.Modify(true);
                until recSalesLine.Next() = 0;
        end;

        if (Rec."Document Type" = Rec."document type"::"Credit Memo") and
           (Rec."Location Code" = 'PP') and
           (Rec."Sell-to Country/Region Code" = 'IT')
        then
            Rec.Validate(Rec."Ship-to Code", Rec."Location Code");

        SetAddPostGrpPrLocation(Rec, xRec, CurrFieldNo);
        SetZyxelVATRegistrationNo(Rec, xRec, CurrFieldNo);

        CreateDim_SellToCustomerNo(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sales Order Type', false, false)]
    local procedure OnBeforeValidateSalesOrderType(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recSalesLine: Record "Sales Line";
        recItem: Record Item;
        lText002: Label '"%1" %2 can not be used on a sales order.';
    begin
        Rec.TestField(Rec.Status, Rec.Status::Open);
        if (Rec."Document Type" = Rec."document type"::Order) and (Rec."Sales Order Type" = Rec."sales order type"::"G/L Account") then
            Error(lText002, Rec.FieldCaption(Rec."Sales Order Type"), Rec."Sales Order Type");

        if (Rec."Document Type" = Rec."document type"::Order) or
           (Rec."Document Type" = Rec."document type"::Invoice) or
           (Rec."Document Type" = Rec."document type"::Quote)
        then begin
            recSalesLine.SetRange("Document Type", Rec."Document Type");
            recSalesLine.SetRange("Document No.", Rec."No.");
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            recSalesLine.SetFilter("No.", '<>%1', '');
            if recSalesLine.FindSet() then
                repeat
                    recItem.Get(recSalesLine."No.");
                    ValidateLocationCodeWithSalesOrderType(Rec."Sales Order Type", recItem);
                until recSalesLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sales Order Type', false, false)]
    local procedure OnAfterValidateSalesOrderType(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recLocation: Record Location;
        recSalesLine: Record "Sales Line";
        recSalesLineTmp: Record "Sales Line" Temporary;
        lText001: Label 'Do you want to change "%1"\from "%2" to "%3"?';

    begin
        if (Rec."Document Type" = Rec."document type"::Order) or
           (Rec."Document Type" = Rec."document type"::Invoice) or
           (Rec."Document Type" = Rec."document type"::Quote)
        then begin
            recSalesLine.SetRange("Document Type", Rec."Document Type");
            recSalesLine.SetRange("Document No.", Rec."No.");
            if recSalesLine.findset() then
                repeat
                    recSalesLineTmp := recSalesLine;
                    recSalesLineTmp.insert();
                Until recSalesLine.next() = 0;

            recLocation.SetRange("Default Order Type Location", true);
            recLocation.SetRange("Sales Order Type", Rec."Sales Order Type");
            recLocation.SetRange("In Use", true);

            if xRec."Sales Order Type" <> xRec."sales order type"::" " then begin
                if Confirm(lText001, false, Rec.FieldCaption(Rec."Sales Order Type"), xRec."Sales Order Type", Rec."Sales Order Type") then
                    if recLocation.FindFirst() then
                        Rec.Validate(Rec."Location Code", recLocation.Code);
                EnterSelectedFieldsOnSalesDocument(Rec, xRec);

                recSalesLine.SetRange("Document Type", Rec."Document Type");
                recSalesLine.SetRange("Document No.", Rec."No.");
                recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                if recSalesLine.FindSet(true) then
                    repeat
                        recSalesLine.ValidateLocation();
                        recSalesLine.Validate("Sales Order Type", Rec."Sales Order Type");
                        recSalesLineTmp.get(recSalesLine."Document Type", recSalesLine."Document No.", recSalesLine."Line No.");
                        recSalesLine."Planned Delivery Date" := recSalesLineTmp."Planned Delivery Date";
                        recSalesLine."Planned Shipment Date" := recSalesLineTmp."Planned Shipment Date";
                        recSalesLine."Shipment Date" := recSalesLineTmp."Shipment Date";
                        recSalesLine.Modify(true);
                    until recSalesLine.Next() = 0;
            end else
                if recLocation.FindFirst() then
                    Rec.Validate(Rec."Location Code", recLocation.Code);

            if Rec."Sales Order Type" = Rec."sales order type"::EICard then
                Rec."Eicard Type" := Rec."eicard type"::Normal
            else
                Rec."Eicard Type" := Rec."eicard type"::" ";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeConfirmUpdateCurrencyFactor', '', false, false)]
    local procedure OnBeforeConfirmUpdateCurrencyFactor(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.SetHideValidationDialog(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Bill-to Customer No.', false, false)]
    local procedure "OnAfterValidateBill-toCustomerNo"(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recCust: Record Customer;
    begin
        recCust.Get(Rec."Sell-to Customer No.");

        if Rec."Document Type" = Rec."document type"::Order then
            Rec.Validate(Rec."Currency Code", recCust."Currency Code");  // We have to show the "Order Confirmation" in the customers currency, therefore we overwrite the currency code on the sales order
        Rec."Salesperson Code" := "GetSale/PurchCode"(recCust."Salesperson Code", 0);
        Rec."Order Desk Resposible Code" := "GetSale/PurchCode"(recCust."Order Desk Resposible Code", 1);
        Rec."Intercompany Purchase" := recCust."Intercompany Purchase";
        Rec."Customer Price Group" := recCust."Customer Price Group";  //Keep Customer price group from Sell-To Customer

        CreateDim_SellToCustomerNo(Rec, xRec);

        SetAddPostGrpPrLocation(Rec, xRec, CurrFieldNo);
        Rec.Validate("Send Mail");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Document Date', false, false)]
    local procedure OnAfterValidateSHDocumentDate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        if Rec."Document Type" = Rec."document type"::"Credit Memo" then
            Rec."Due Date" := xRec."Due Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Ship-to Code', false, false)]
    local procedure OnAfterValidateSHShipToCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recSalesLine: Record "Sales Line";
        recShipToAdd: Record "Ship-to Address";
        Cust: Record Customer;
        GenLedgSetup: Record "General Ledger Setup";
        DefaultDim: Record "Default Dimension";
        AllInDates: Codeunit "Delivery Document Management";
    begin
        if Rec."Document Type" = Rec."document type"::"Credit Memo" then
            if recShipToAdd.Get(Rec."Sell-to Customer No.", Rec."Ship-to Code") then begin
                Rec."Ship-to Name" := recShipToAdd.Name;
                Rec."Ship-to Address" := recShipToAdd.Address;
                Rec."Ship-to Post Code" := recShipToAdd."Post Code";
                Rec."Ship-to City" := recShipToAdd.City;
            end;

        if (Rec."Document Type" <> Rec."document type"::"Return Order") and
           (Rec."Document Type" <> Rec."document type"::"Credit Memo")
        then begin
            Rec."Shipment Date" := AllInDates.CalcShipmentDate('', '', Rec."Ship-to Country/Region Code", copystr(Rec."Shortcut Dimension 1 Code", 1, 10), Rec."Shipment Date", false);

            recSalesLine.SetRange("Document Type", Rec."Document Type");
            recSalesLine.SetRange("Document No.", Rec."No.");
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            if recSalesLine.FindSet(true) then
                repeat
                    recSalesLine.Validate("Ship-to Code", GetShipToCodeForSalesLine(Rec));
                    recSalesLine.Modify(true);
                until recSalesLine.Next() = 0;
        end;

        if Cust.get(Rec."Sell-to Customer No.") and Cust."Sample Account" then begin
            GenLedgSetup.get();
            IF DefaultDim.get(Database::Customer, Rec."Sell-to Customer No.", GenLedgSetup."Shortcut Dimension 3 Code") and
               (DefaultDim."Value Posting" IN [DefaultDim."Value Posting"::"Code Mandatory", DefaultDim."Value Posting"::"Same Code"])
            then
                Rec.ValidateShortcutDimCode(3, Rec."Ship-to Country/Region Code");

        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Ship-to Code Del. Doc', false, false)]
    local procedure OnAfterValidateSHShipToCodeDelDoc(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recSalesLine: Record "Sales Line";
    Begin
        if (Rec."Document Type" <> Rec."document type"::"Return Order") and
           (Rec."Document Type" <> Rec."document type"::"Credit Memo")
        then begin
            recSalesLine.SetRange("Document Type", Rec."Document Type");
            recSalesLine.SetRange("Document No.", Rec."No.");
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            if recSalesLine.FindSet() then
                repeat
                    recSalesLine.Validate("Ship-to Code", GetShipToCodeForSalesLine(Rec));
                    recSalesLine.Modify(true);
                until recSalesLine.Next() = 0;
        end;
    end;

    local procedure GetShipToCodeForSalesLine(var Rec: Record "Sales Header") rValue: Code[20]
    var
        Cust: Record Customer;
    Begin
        Cust.Get(Rec."Sell-to Customer No.");
        If Cust."Sample Account" and (Rec."Ship-to Code Del. Doc" <> '') then
            rValue := Rec."Ship-to Code Del. Doc"
        else
            rValue := Rec."Ship-to Code";
    End;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Ship-to Country/Region Code', false, false)]
    local procedure OnAfterValidateShipToCountry(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        AddItemMgt: Codeunit "ZyXEL Additional Items Mgt";
    begin
        SetAddPostGrpPrLocation(Rec, xRec, CurrFieldNo);
        SetZyxelVATRegistrationNo(Rec, xRec, CurrFieldNo);
        AddItemMgt.UpdateAdditionalItems(Rec."Document Type", Rec."No.", Rec."Ship-to Country/Region Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Country/Region Code', false, false)]
    local procedure OnAfterValidateSellToCountry(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        SetZyxelVATRegistrationNo(Rec, xRec, CurrFieldNo);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Backlog Comment', false, false)]
    local procedure OnAfterValidateSHBacklogComment(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recSalesLine: Record "Sales Line";
        lText001: Label 'Do you want to update all "%1(s)" where "%2" is blank?';
    begin
        if (Rec."Backlog Comment" <> xRec."Backlog Comment") and (Rec."Backlog Comment" <> Rec."backlog comment"::" ") then
            if Confirm(lText001, true, recSalesLine.TableCaption(), Rec.FieldCaption(Rec."Backlog Comment")) then begin
                recSalesLine.SetRange("Document Type", Rec."Document Type");
                recSalesLine.SetRange("Document No.", Rec."No.");
                recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                recSalesLine.SetRange("Hide Line", false);
                recSalesLine.SetRange("Backlog Comment", recSalesLine."backlog comment"::" ");
                if recSalesLine.FindSet() then
                    repeat
                        recSalesLine."Backlog Comment" := Rec."Backlog Comment";
                        recSalesLine.Modify();
                    until recSalesLine.Next() = 0;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Send Mail', false, false)]
    local procedure OnAfterValidateSendMail(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recCust: Record Customer;
        recCustRepSlct: Record "Custom Report Selection";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.IsRhq() then
            if Rec."Document Type" in [Rec."document type"::Quote, Rec."document type"::Order, Rec."document type"::Invoice] then begin
                if Rec."Bill-to Customer No." <> '' then
                    recCust.Get(Rec."Bill-to Customer No.")
                else
                    recCust.Get(Rec."Sell-to Customer No.");

                recCustRepSlct.SetRange("Source Type", Database::Customer);
                recCustRepSlct.SetRange("Source No.", recCust."No.");
                recCustRepSlct.SetRange(Usage, recCustRepSlct.Usage::"S.Invoice");
                if not recCustRepSlct.FindFirst() then;

                if Rec."Sales Order Type" = Rec."sales order type"::EICard then
                    Rec."Send Mail" :=
                      (recCust."E-mail Sales Documents" and (recCust."Post EiCard Invoice Automatic" <> recCust."post eicard invoice automatic"::" ")) and
                      ((recCustRepSlct."Send To Email" <> '') or (recCust."E-Mail" <> ''))
                else
                    if Rec."Location Code" = ItemLogisticEvent.GetMainWarehouseLocation() then
                        Rec."Send Mail" :=
                          recCust."E-mail Sales Documents" and
                          (recCust."Automatic Invoice Handling" = recCust."automatic invoice handling"::"Create and Post Invoice") and
                          (recCustRepSlct."Send To Email" <> '')
                    else
                        Rec."Send Mail" := false;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'External Document No.', false, false)]
    local procedure OnAfterValidateExternalDocumentNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recSalesLine: Record "Sales Line";
        SalesHeader2: Record "Sales Header";
        ZGT: Codeunit "ZyXEL General Tools";
        lText001: Label 'Do you want to update "%1" on sales lines?';
        Text002: Label 'External Document No. "%1" is already used on another sales order %2 for this customer.';

    begin
        if ZGT.IsZComCompany() then begin //12-09-2025 BK #526597
            SalesHeader2.SetRange(SalesHeader2."Document Type", SalesHeader2."document type"::Order);
            SalesHeader2.SetFilter(SalesHeader2."No.", '<>%1', Rec."No.");
            SalesHeader2.SetRange(SalesHeader2."Sell-to Customer No.", Rec."Sell-to Customer No.");
            SalesHeader2.setrange("External Document No.", Rec."External Document No.");
            IF SalesHeader2.FindFirst() THEN
                message(Text002, Rec."External Document No.", SalesHeader2."No.");
        end;

        recSalesLine.SetRange("Document Type", Rec."Document Type");
        recSalesLine.SetRange("Document No.", Rec."No.");
        recSalesLine.SetRange("External Document No.", xRec."External Document No.");
        if recSalesLine.FindSet(true) then begin
            if Confirm(lText001, false, Rec.FieldCaption(Rec."External Document No.")) then
                recSalesLine.ModifyAll("External Document No.", Rec."External Document No.");
        end else begin
            recSalesLine.SetRange("External Document No.");
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            if recSalesLine.FindSet(true) then
                if Confirm(lText001, false, Rec.FieldCaption(Rec."External Document No.")) then
                    recSalesLine.ModifyAll("External Document No.", Rec."External Document No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Salesperson Code', false, false)]
    local procedure OnAfterValidateSalespersonCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        CreateDim_SellToCustomerNo(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Campaign No.', false, false)]
    local procedure OnAfterValidateCampainNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        CreateDim_SellToCustomerNo(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Responsibility Center', false, false)]
    local procedure OnAfterValidateResponsibilityCenter(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        CreateDim_SellToCustomerNo(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Bill-to Customer Templ. Code', false, false)]
    local procedure OnAfterValidateBillToCustomerTemplateCode(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recCust: Record Customer;
    begin
        if recCust.Get(Rec."Bill-to Customer No.") then
            Rec."Payment Terms Code" := recCust."Payment Terms Code";

        CreateDim_SellToCustomerNo(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterConfirmCurrencyFactorUpdate, '', false, false)]
    local procedure OnAfterConfirmUpdateCurrencyFactor(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.SetHideValidationDialog(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Currency Code Sales Doc SUB', false, false)]
    local procedure OnBeforeValidateCurrencyCodeSalesDocSUB(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recCust: Record Customer;
    begin
        recCust.Get(Rec."Sell-to Customer No.");
        if (recCust."Currency Code" = '') or (recCust."Currency Code" = Rec."Currency Code Sales Doc SUB") then
            Rec."Currency Code Sales Doc SUB" := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Currency Code Sales Doc SUB', false, false)]
    local procedure OnAfterValidateCurrencyCodeSalesDocSUB(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        Rec."Curr. Code Sales Doc SUB Acc." := false;
        Rec.Modify(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeSalesLineInsert, '', false, false)]
    local procedure OnBeforeInsertCreateSalesLine(var TempSalesLine: Record "Sales Line" temporary; var SalesLine: Record "Sales Line")
    begin
        SalesLine."Hide Line" := TempSalesLine."Hide Line";
        SalesLine."Additional Item Line No." := TempSalesLine."Additional Item Line No.";
        SalesLine."Additional Item Quantity" := TempSalesLine."Additional Item Quantity";
        SalesLine."Ext Vend Purch. Order No." := TempSalesLine."Ext Vend Purch. Order No.";
        SalesLine."Ext Vend Purch. Order Line No." := TempSalesLine."Ext Vend Purch. Order Line No.";
        SalesLine."BOM Line No." := TempSalesLine."BOM Line No.";
        SalesLine."BOM Header" := TempSalesLine."BOM Header";
        SalesLine."External Document No." := TempSalesLine."External Document No.";
        SalesLine."Backlog Comment" := TempSalesLine."Backlog Comment";
        SalesLine."Shipment Date" := TempSalesLine."Shipment Date";
        SalesLine."Shipment Date Confirmed" := TempSalesLine."Shipment Date Confirmed";
        SalesLine."Delivery Document No." := TempSalesLine."Delivery Document No.";
        SalesLine."Warehouse Status" := TempSalesLine."Warehouse Status";
        SalesLine."IC Payment Terms" := TempSalesLine."IC Payment Terms";
        SalesLine."Picking List No." := TempSalesLine."Picking List No.";
        SalesLine."Packing List No." := TempSalesLine."Packing List No.";
        SalesLine.Validate("Sales Order Type", TempSalesLine."Sales Order Type");
        SalesLine."Ship-to Code" := TempSalesLine."Ship-to Code";

        SalesLine."Lock by Ref Document" := TempSalesLine."Lock by Ref Document";
        SalesLine."Location Code" := TempSalesLine."Location Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeMessageIfSalesLinesExist', '', false, false)]
    local procedure SalesHeader_OnBeforeMessageIfSalesLinesExist(SalesHeader: Record "Sales Header"; ChangedFieldCaption: Text; var IsHandled: Boolean)
    begin
        if ChangedFieldCaption = SalesHeader.FieldCaption("Location Code") then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnRecreateSalesLinesOnBeforeSalesLineDeleteAll', '', false, false)]
    local procedure SalesHeader_OnRecreateSalesLinesOnBeforeSalesLineDeleteAll(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
        SalesLine.ModifyAll("Lock by Ref Document", false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeConfirmKeepExistingDimensions', '', false, false)]
    local procedure SalesHeader_OnBeforeConfirmKeepExistingDimensions(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; FieldNo: Integer; OldDimSetID: Integer; var Confirmed: Boolean; var IsHandled: Boolean)
    begin
        Confirmed := true;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCheckCustomerPostingGroupChange', '', false, false)]
    local procedure OnBeforeCheckCustomerPostingGroupChange(SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        SI: Codeunit "Single Instance";
    begin
        IsHandled := SI.GetAllowChangeOfCustomerPostingGroup();
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateLocationCode', '', false, false)]
    local procedure OnBeforeValidateLocationCode(var SalesHeader: Record "Sales Header"; IsHandled: Boolean)
    var
        Location: Record Location;
        SalOrdTypeRel: Record "Sales Order Type Relation";

    begin
        // If the location code has changed we change it back again.
        if ((SalesHeader."Sales Order Type" <> SalesHeader."Sales Order Type"::" ") and (SalesHeader."Sales Order Type" <> SalesHeader."Sales Order Type"::"G/L Account")) and
           (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Quote])
         then
            if Location.get(SalesHeader."Location Code") then
                if SalesHeader."Sales Order Type" = SalesHeader."Sales Order Type"::eCommerce then begin
                    If not SalOrdTypeRel.get(SalesHeader."Location Code", SalesHeader."Sales Order Type") then begin
                        SalOrdTypeRel.SetRange("Sales Order Type", SalesHeader."Sales Order Type");
                        SalOrdTypeRel.SetRange("Default Order Type Location", true);
                        SalOrdTypeRel.SetRange("In Use", true);
                        SalOrdTypeRel.findfirst();
                        SalesHeader."Location Code" := Location.Code;
                    end;
                end else
                    if (SalesHeader."Sales Order Type" <> Location."Sales Order Type") and
                       (SalesHeader."Sales Order Type" <> Location."Sales Order Type 2")
                    then begin
                        Location.SetRange("Default Order Type Location", true);
                        Location.SetRange("Sales Order Type", SalesHeader."Sales Order Type");
                        Location.SetRange("In Use", true);
                        Location.findfirst();

                        SalesHeader."Location Code" := Location.Code;
                    end;
    end;


    procedure CreateDimensionValueCode(var Rec: Record "Dimension Set Entry")
    var
        recGenLedgSetup: Record "General Ledger Setup";
        recDimValue: Record "Dimension Value";
        Window: Dialog;
        DimValueCode: Code[20];
    begin
        recGenLedgSetup.Get();
        if Rec."Dimension Code" = recGenLedgSetup."Shortcut Dimension 7 Code" then
            if not recDimValue.Get(Rec."Dimension Code", Rec."Dimension Value Code") then begin
                Window.Open('#1###################');
                //Window.INPUT(1, DimValueCode); //TODO: Replcae with Page if this function is called at all (Await compile)
                Window.Close();
                if DimValueCode <> '' then begin
                    recDimValue.Init();
                    recDimValue.Validate("Dimension Code", Rec."Dimension Code");
                    recDimValue.Validate(Code, DimValueCode);
                    recDimValue.Validate(Name, DimValueCode);
                    recDimValue.Insert(true);
                end;
            end;
    end;


    local procedure ValidateLocationCodeWithSalesOrderType(pSalesOrderType: Option " ",Normal,EICard,"Drop Shipment",Other,"Spec. Order","G/L Account",HaaS; var pItem: Record Item)
    var
        ServerEnviron: Record "Server Environment";
        lText001: Label 'The"Item No." %1 does not match "Sales Order Type" %2.';
    begin
        If ServerEnviron.ProductionEnvironment() then   // Find another solution here with Doc Capture.
            if ((pSalesOrderType = Psalesordertype::EICard) and
                (not pItem.IsEICard) and (not pItem."Non ZyXEL License")) or
                ((pSalesOrderType <> Psalesordertype::EICard) and
                (pItem.IsEICard) or (pItem."Non ZyXEL License"))
            then
                Error(lText001, pItem."No.", pSalesOrderType);
    end;

    local procedure SetAddPostGrpPrLocation(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recAddBillToSetup: Record "Add. Cust. Posting Grp. Setup";
        recAddPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
        recCust: Record Customer;
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        ModifyHeader: Boolean;
        UpdateFromCustomer: Boolean;
    begin
        if not SI.GetSkipAddPostGrpPrLocation() then begin
            SI.SetAllowChangeOfCustomerPostingGroup(true);

            if (Rec."Ship-to Country/Region Code" <> '') and (Rec."Location Code" <> '') and (Rec."Sell-to Customer No." <> '') then begin
                recAddBillToSetup.SetRange("Country/Region Code", Rec."Sell-to Country/Region Code");
                recAddBillToSetup.SetRange("Location Code", Rec."Location Code");
                recAddBillToSetup.SetFilter("Customer No.", '%1|%2', '', Rec."Sell-to Customer No.");
                if ZGT.IsRhq() then
                    recAddBillToSetup.SetRange("Company Type", recAddPostGrpSetup."company type"::Main);
                if recAddBillToSetup.FindLast() then begin
                    Rec.SetHideValidationDialog(true);
                    if (recAddBillToSetup."Bill-to Customer No." <> '') and
                       (recAddBillToSetup."Bill-to Customer No." <> Rec."Bill-to Customer No.")
                    then begin
                        Rec.Validate(Rec."Bill-to Customer No.", recAddBillToSetup."Bill-to Customer No.");
                        ModifyHeader := true;
                    end;
                end;

                if Rec."Document Type" = Rec."document type"::"Credit Memo" then
                    recAddPostGrpSetup.SetRange("Country/Region Code", Rec."Sell-to Country/Region Code")
                else
                    recAddPostGrpSetup.SetRange("Country/Region Code", Rec."Ship-to Country/Region Code");
                recAddPostGrpSetup.SetRange("Location Code", Rec."Location Code");
                recAddPostGrpSetup.SetFilter("Customer No.", '%1|%2', '', Rec."Sell-to Customer No.");
                if ZGT.IsRhq() then
                    recAddPostGrpSetup.SetRange("Company Type", recAddPostGrpSetup."company type"::Main);
                if recAddPostGrpSetup.FindLast() then begin
                    Rec.SetHideValidationDialog(true);
                    if (recAddPostGrpSetup."Currency Code" <> '') and
                       (recAddPostGrpSetup."Currency Code" <> Rec."Currency Code")
                    then begin
                        Rec.Validate(Rec."Currency Code", recAddPostGrpSetup."Currency Code");
                        ModifyHeader := true;
                    end;
                    if (recAddPostGrpSetup."Gen. Bus. Posting Group" <> '') and
                       (recAddPostGrpSetup."Gen. Bus. Posting Group" <> Rec."Gen. Bus. Posting Group")
                    then begin
                        Rec.Validate(Rec."Gen. Bus. Posting Group", recAddPostGrpSetup."Gen. Bus. Posting Group");
                        ModifyHeader := true;
                    end;
                    if (recAddPostGrpSetup."VAT Bus. Posting Group" <> '') and
                       (recAddPostGrpSetup."VAT Bus. Posting Group" <> Rec."VAT Bus. Posting Group")
                    then begin
                        Rec.Validate(Rec."VAT Bus. Posting Group", recAddPostGrpSetup."VAT Bus. Posting Group");
                        ModifyHeader := true;
                    end;
                    if (recAddPostGrpSetup."Customer Posting Group" <> '') and
                       (recAddPostGrpSetup."Customer Posting Group" <> Rec."Customer Posting Group")
                    then begin
                        Rec.Validate(Rec."Customer Posting Group", recAddPostGrpSetup."Customer Posting Group");
                        ModifyHeader := true;
                    end;

                    if (recAddPostGrpSetup."EU 3-Party Trade" <> Rec."EU 3-Party Trade") then begin
                        Rec.Validate(Rec."EU 3-Party Trade", recAddBillToSetup."EU 3-Party Trade");
                        ModifyHeader := true;
                    end;

                    if ZGT.IsRhq() then begin
                        if (recAddPostGrpSetup."VAT Registration No." <> '') and
                           (recAddPostGrpSetup."VAT Registration No." <> Rec."Ship-to VAT")
                        then begin
                            Rec.Validate(Rec."Ship-to VAT", recAddPostGrpSetup."VAT Registration No.");
                            ModifyHeader := true;
                        end;
                    end else
                        if (recAddPostGrpSetup."VAT Registration No." <> '') and
                           (recAddPostGrpSetup."VAT Registration No." <> Rec."VAT Registration No.")
                        then begin
                            Rec.Validate(Rec."VAT Registration No.", recAddPostGrpSetup."VAT Registration No.");
                            ModifyHeader := true;
                        end;
                end else
                    UpdateFromCustomer := true;

                Rec.SetHideValidationDialog(false);
            end else
                UpdateFromCustomer := true;

            if UpdateFromCustomer then
                if (Rec."Sell-to Customer No." <> '') and
                   ((Rec."Sell-to Customer No." = Rec."Bill-to Customer No.") or (Rec."Bill-to Customer No." = ''))
                then begin
                    recCust.Get(Rec."Sell-to Customer No.");

                    Rec.SetHideValidationDialog(true);
                    if (recCust."Currency Code" <> '') and
                       (recCust."Currency Code" <> Rec."Currency Code")
                    then begin
                        Rec.Validate(Rec."Currency Code", recCust."Currency Code");
                        ModifyHeader := true;
                    end;
                    if (recCust."Gen. Bus. Posting Group" <> '') and
                       (recCust."Gen. Bus. Posting Group" <> Rec."Gen. Bus. Posting Group")
                    then begin
                        Rec.Validate(Rec."Gen. Bus. Posting Group", recCust."Gen. Bus. Posting Group");
                        ModifyHeader := true;
                    end;
                    if (recCust."VAT Bus. Posting Group" <> '') and
                       (recCust."VAT Bus. Posting Group" <> Rec."VAT Bus. Posting Group")
                    then begin
                        Rec.Validate(Rec."VAT Bus. Posting Group", recCust."VAT Bus. Posting Group");
                        ModifyHeader := true;
                    end;
                    if (recCust."Customer Posting Group" <> '') and
                       (recCust."Customer Posting Group" <> Rec."Customer Posting Group")
                    then begin
                        Rec.Validate(Rec."Customer Posting Group", recCust."Customer Posting Group");
                        ModifyHeader := true;
                    end;

                    Rec.Validate(Rec."EU 3-Party Trade", false);
                    ModifyHeader := true;

                    Rec.SetHideValidationDialog(false);
                end;

            if ModifyHeader then
                if not Rec.Modify(true) then;

            SI.SetAllowChangeOfCustomerPostingGroup(false);
        end;
    end;

    procedure SetZyxelVATRegistrationNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recVATRegNoMatrix: Record "VAT Reg. No. pr. Location";
    begin
        if not Rec.IsTemporary then begin

            if Rec."Document Type" in [Rec."document type"::"Credit Memo", Rec."document type"::"Return Order"] then
                Rec."VAT Registration No. Zyxel" :=
                  recVATRegNoMatrix."GetZyxelVATReg/EoriNo"(0, Rec."Location Code", '', Rec."Sell-to Country/Region Code", Rec."Sell-to Customer No.")
            else
                Rec."VAT Registration No. Zyxel" :=
                  recVATRegNoMatrix."GetZyxelVATReg/EoriNo"(0, Rec."Location Code", Rec."Ship-to Country/Region Code", Rec."Sell-to Country/Region Code", Rec."Sell-to Customer No.");
            if not Rec.Modify(true) then;

        end;
    end;

    procedure DisableEnableAdditionalItems(var rec: Record "Sales Header")
    var

        recSalesLine: Record "Sales Line";
        recDelDocHead: Record "VCK Delivery Document Header";
        lText004: Label 'You need to delete the "Delivery Document Line" on item "%1" before you can delete the line.';
        lText001: Label 'Do you want to disable additional items on order "%1"?';
        lText002: Label 'Do you want to enable additional items on order "%1"?';
        lText003: Label '"%1" must be "%2".';

    begin
        if rec.Status <> rec.Status::Open then
            Error(lText003, rec.FieldCaption(rec.Status), rec.Status::Open);
        if not rec."Disable Additional Items" then begin
            if Confirm(lText001, false, rec."No.") then begin
                rec."Disable Additional Items" := not rec."Disable Additional Items";
                rec.Modify();

                recSalesLine.SetRange("Document Type", rec."Document Type");
                recSalesLine.SetRange("Document No.", rec."No.");
                recSalesLine.SetFilter("Additional Item Line No.", '<>0');
                if recSalesLine.FindSet() then
                    repeat
                        if recSalesLine."Delivery Document No." <> '' then
                            if recDelDocHead.Get(recSalesLine."Delivery Document No.") and
                               (recDelDocHead."Warehouse Status" < recDelDocHead."warehouse status"::Delivered)
                            then
                                Error(lText004, recSalesLine."No.");
                        recSalesLine.Delete(true);
                    until recSalesLine.Next() = 0;
            end;
        end else
            if Confirm(lText002, false, rec."No.") then begin
                rec."Disable Additional Items" := not rec."Disable Additional Items";
                rec.Modify();
            end;
    end;

    procedure SkipPostGrpValidation(var SalesHeader: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
    begin
        if SalesHeader.FindSet(true) then
            repeat
                SalesHeader.Validate(SalesHeader."Skip Posting Group Validation", true);
                SalesHeader.Modify(true);

                recSalesLine.SetRange("Document Type", SalesHeader."Document Type");
                recSalesLine.SetRange("Document No.", SalesHeader."No.");
                if recSalesLine.FindSet(true) then
                    repeat
                        recSalesLine.Validate("Skip Posting Group Validation", true);
                        recSalesLine.Modify(true);
                    until recSalesLine.Next() = 0;
            until SalesHeader.Next() = 0;
    end;

    procedure SkipPostGrpValidationWithConfirm(var pSalesHead: Record "Sales Header"; PageCaption: Text)
    var
        lText001: Label 'Do you want to skip posting group validation for %1 %2?';
    begin
        if Confirm(lText001, false, pSalesHead.Count(), PageCaption) then
            SkipPostGrpValidation(pSalesHead);
    end;

    local procedure CreateDim_SellToCustomerNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        GenLedgSetup: Record "General Ledger Setup";
        Cust: Record Customer;
        DefaultDim: Record "Default Dimension";
        SalesHeader: Record "Sales Header";
        DimMgt: Codeunit DimensionManagement;
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        DimMgt.AddDimSource(DefaultDimSource, Database::Customer, Rec."Sell-to Customer No.");
        DimMgt.AddDimSource(DefaultDimSource, Database::"Salesperson/Purchaser", Rec."Salesperson Code");
        DimMgt.AddDimSource(DefaultDimSource, Database::Campaign, Rec."Campaign No.");
        DimMgt.AddDimSource(DefaultDimSource, Database::"Responsibility Center", Rec."Responsibility Center");
        DimMgt.AddDimSource(DefaultDimSource, Database::"Customer Templ.", Rec."Sell-to Customer Templ. Code");
        Rec.CreateDim(DefaultDimSource);

        if SalesHeader.get(Rec."Document Type", Rec."No.") then
            if Cust.get(Rec."Sell-to Customer No.") and Cust."Sample Account" then begin
                GenLedgSetup.get();
                IF DefaultDim.get(Database::Customer, Rec."Sell-to Customer No.", GenLedgSetup."Shortcut Dimension 3 Code") and
                   (DefaultDim."Value Posting" IN [DefaultDim."Value Posting"::"Code Mandatory", DefaultDim."Value Posting"::"Same Code"])
                then
                    Rec.ValidateShortcutDimCode(3, Rec."Ship-to Country/Region Code");
            end;
    end;

    local procedure EnterSelectedFieldsOnSalesDocument(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        lSalesHeader: Record "Sales Header";
        SI: Codeunit "Single Instance";
        ZGT: Codeunit "ZyXEL General Tools";
        EnterSelectedFields: Page "Enter Selected Fields";
    begin
        if (GuiAllowed()) and
            (ZGT.IsRhq() or ZGT.CompanyNameIs(9) or ZGT.CompanyNameIs(14)) and
            (not Rec."eCommerce Order") and
            (not Rec.EDI) and
            (not SI.GetHideSalesDialog()) and
            (rec.AmazonePoNo = '') AND // Amazon order skip
            (Rec."Sales Order Type" <> Rec."sales order type"::"G/L Account")
        then
            if Rec."Document Type" in [Rec."document type"::Order, Rec."document type"::Invoice, Rec."document type"::"Credit Memo"] then begin
                if Rec.GetFilter(Rec."Sell-to Customer No.") = '' then
                    if Rec.Modify(true) then
                        Commit()
                    else
                        if Rec.Insert(true) then
                            Commit();

                SI.SetKeepLocationCode(true);
                EnterSelectedFields.SetSalesHeader(Rec);
                if Rec.GetFilter(Rec."Sell-to Customer No.") <> '' then
                    EnterSelectedFields.Run()
                else
                    EnterSelectedFields.RunModal();
                EnterSelectedFields.GetSalesHeader(lSalesHeader);
                if (Rec."Location Code" <> lSalesHeader."Location Code") and (lSalesHeader."Location Code" <> '') then
                    Rec.Validate(Rec."Location Code", lSalesHeader."Location Code");
                if (Rec."External Document No." <> lSalesHeader."External Document No.") and (lSalesHeader."External Document No." <> '') then
                    Rec.Validate(Rec."External Document No.", lSalesHeader."External Document No.");
                if (Rec."Ship-to Code" <> lSalesHeader."Ship-to Code") and (lSalesHeader."Ship-to Code" <> '') then
                    Rec.Validate(Rec."Ship-to Code", lSalesHeader."Ship-to Code");

                if (Rec."Ship-to Code Del. Doc" <> lSalesHeader."Ship-to Code Del. Doc") and (lSalesHeader."Ship-to Code Del. Doc" <> '') then
                    Rec.Validate("Ship-to Code Del. Doc", lSalesHeader."Ship-to Code Del. Doc");

                if (Rec."Backlog Comment" <> lSalesHeader."Backlog Comment") and (lSalesHeader."Backlog Comment" <> lSalesHeader."backlog comment"::" ") then
                    Rec.Validate(Rec."Backlog Comment", lSalesHeader."Backlog Comment");

                if (Rec."Eicard Type" <> lSalesHeader."Eicard Type") and (lSalesHeader."Eicard Type" <> lSalesHeader."eicard type"::" ") then
                    Rec.Validate(Rec."Eicard Type", lSalesHeader."Eicard Type");

                if (Rec."Currency Code Sales Doc SUB" <> lSalesHeader."Currency Code Sales Doc SUB") and (lSalesHeader."Currency Code Sales Doc SUB" <> '') then
                    Rec.Validate(Rec."Currency Code Sales Doc SUB", lSalesHeader."Currency Code Sales Doc SUB");

                SI.SetKeepLocationCode(false);
            end;
    end;

    procedure "GetSale/PurchCode"("pSale/PurchCode": Code[20]; pType: Option SalesPerson,Responsible): Code[20]
    var
        lUserSetup: Record "User Setup";
        lUser: Record User;
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.IsZNetCompany then begin
            // If the sales person on the customer is still employed, then it's used
            if "pSale/PurchCode" <> '' then begin
                lUserSetup.SetRange("Salespers./Purch. Code", "pSale/PurchCode");
                if lUserSetup.FindFirst() then begin
                    lUser.SetRange("User Name", lUserSetup."User ID");
                    if lUser.FindFirst() then
                        if lUser.State = lUser.State::Enabled then
                            if ((CurrentDatetime() < lUser."Expiry Date") or (lUser."Expiry Date" = 0DT)) then
                                exit("pSale/PurchCode");
                end;
            end;

            // Otherwise it will use current users sales person code, if created in user setup, otherwise it will use the transfered code.
            if lUserSetup.Get(UserId()) and (lUserSetup."Salespers./Purch. Code" <> '') then
                exit(lUserSetup."Salespers./Purch. Code")
            else
                exit("pSale/PurchCode");
        end else
            exit("pSale/PurchCode");
    end;

    //>> Sales Line
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesLine(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        recSalesHead: Record "Sales Header";
        SalesSetup: Record "Sales & Receivables Setup";

    begin
        if not Rec.IsTemporary then begin
            recSalesHead.Get(Rec."Document Type", Rec."Document No.");
            Rec.Validate(Rec."Sales Order Type", recSalesHead."Sales Order Type");

            if GuiAllowed() then
                if (Rec."Document Type" = Rec."document type"::Order) and (Rec.Type = Rec.Type::Item) and (not Rec."Hide Line") then
                    Rec."Backlog Comment" := recSalesHead."Backlog Comment";

            if (Rec."External Document No." = '') and (recSalesHead."External Document No." <> '') then
                Rec."External Document No." := recSalesHead."External Document No.";

            if SalesSetup.Get() then
                if SalesSetup."Default Shipment Date" <> 0D then
                    Rec."Shipment Date" := SalesSetup."Default Shipment Date"; //16-07-2025 BK #512739
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifySalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean)
    var
        recWhseIndbLine: Record "VCK Shipping Detail";
        recWhseIndbHead: Record "Warehouse Inbound Header";
        SI: Codeunit "Single Instance";
        lText001: Label '"Delivery Document Line" is created on DD %1. Do you want to save the change?';
        lText002: Label 'Change is cancled.';
        lText003: Label 'You are not allowed to make changes when %1 is "%2" on the "Delivery Document Line". (%3)';
        lText004: Label 'The line is created as Warehouse Inbound.\Are you sure that you want to change the quantity?';
    begin
        if Rec."Document Type" = Rec."document type"::"Return Order" then
            if Rec.Quantity <> xRec.Quantity then begin
                recWhseIndbLine.SetRange("Order Type", recWhseIndbLine."order type"::"Sales Return Order");
                recWhseIndbLine.SetRange("Purchase Order No.", Rec."Document No.");
                recWhseIndbLine.SetRange("Purchase Order Line No.", Rec."Line No.");
                recWhseIndbLine.SetFilter("Document No.", '<>%1', '');
                if recWhseIndbLine.FindFirst() then
                    if recWhseIndbHead.Get(recWhseIndbLine."Document No.") and
                       (recWhseIndbHead."Warehouse Status" >= recWhseIndbHead."warehouse status"::"Goods Received")
                    then
                        recWhseIndbHead.Delete();

                if Rec.Quantity = 0 then begin
                    if not recWhseIndbLine.IsEmpty() and (Rec."Quantity Invoiced" = 0) then begin
                        recWhseIndbLine.Quantity := 0;
                        recWhseIndbLine.Modify(true);
                    end;
                end else
                    if not recWhseIndbLine.IsEmpty() and (Rec."Quantity Invoiced" = 0) then
                        if Confirm(lText004, true) then begin
                            recWhseIndbLine.Quantity := Rec.Quantity;
                            recWhseIndbLine.Modify(true);
                        end else
                            Error('');
            end;

        UpdatePickingDateConfirmation(Rec, xRec);

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteSalesLine(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        lText001: Label 'The quantity that you are trying to invoice is greater than the quantity in return receipt %1.';
        lText002: Label 'Locked by reference purchas document!';
    begin
        if not Rec.IsTemporary then begin
            if Rec."Document Type" = Rec."document type"::Order then
                if (Rec."Outstanding Quantity" > 0) and (Rec."Delivery Document No." <> '') and (Rec."Additional Item Line No." = 0) then
                    Error(lText001);

            if RunTrigger then
                if Rec."Lock by Ref Document" then
                    Error(lText002);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteSalesLine(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        lText001: Label 'The line has been sent to the warehouse so the line can not be deleted. Set the quantity to zero instead.';
        recWhseIndbHead: Record "Warehouse Inbound Header";
        recWhseIndbLine: Record "VCK Shipping Detail";
        recPickDateConf: Record "Picking Date Confirmed";
        recAddEicardOrderInfo: Record "Add. Eicard Order Info";
        MarginApp: Record "Margin Approval";
    begin
        if not Rec.IsTemporary then begin
            if rec."Warehouse Inbound No." <> '' then
                if Rec."Document Type" = Rec."document type"::"Return Order" then begin
                    recWhseIndbLine.SetRange("Order Type", recWhseIndbLine."order type"::"Sales Return Order");
                    recWhseIndbLine.SetRange("Purchase Order No.", Rec."Document No.");
                    recWhseIndbLine.SetRange("Purchase Order Line No.", Rec."Line No.");
                    if recWhseIndbLine.FindFirst() then begin
                        if recWhseIndbLine."Document No." <> '' then begin
                            if recWhseIndbHead.Get(recWhseIndbLine."Document No.") then
                                if recWhseIndbHead."Warehouse Status" < recWhseIndbHead."warehouse status"::"On Stock" then
                                    Error(lText001)
                        end else
                            if not recWhseIndbLine.Archive then
                                recWhseIndbLine.Delete(true);
                    end;
                end;

            if Rec."Document Type" = Rec."document type"::Order then
                if recPickDateConf.Get(recPickDateConf."source type"::"Sales Order", Rec."Document No.", Rec."Line No.") then
                    recPickDateConf.Delete(true);

            recAddEicardOrderInfo.SetRange("Document Type", Rec."Document Type");
            recAddEicardOrderInfo.SetRange("Document No.", Rec."Document No.");
            recAddEicardOrderInfo.SetRange("Sales Line Line No.", Rec."Line No.");
            recAddEicardOrderInfo.DeleteAll(true);

            MarginApp.SetCurrentKey("Source Type", "Sales Document Type", "Source No.", "Source Line No.");
            MarginApp.SetRange("Source Type", MarginApp."Source Type"::"Sales");
            MarginApp.SetRange("Sales Document Type", Rec."Document Type");
            MarginApp.SetRange("Source No.", Rec."Document No.");
            MarginApp.SetRange("Source Line No.", Rec."Line No.");
            If MarginApp.FindFirst() then
                MarginApp.Delete(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Type', false, false)]
    local procedure OnBeforeValidateType(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin

        if (Rec.Type <> xRec.Type) and (xRec.Type = xRec.Type::Item) and (xRec."Shipment Date Confirmed") then
            Rec."Shipment Date Confirmed" := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure OnBeforeValidateSlNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recItem: Record Item;
        recVend: Record Vendor;
        recCustItemBlock: Record "Customer/Item Relation";
        recSalesHead: Record "Sales Header";
        ItemLogisticEvent: Codeunit "Item / Logistic Events";
        SI: Codeunit "Single Instance";
        PrevValue: Boolean;
        lText001: Label 'You are not allowed to rename "%1". Delete the line, and create a new.';
        lText002: Label 'The "Item No." %1 is blocked for "Customer No." %2.';
        lText005: Label 'Locked by reference purchas document!';
        lText006: Label 'The Item No. %1 is blocked. Please contact your Supply Chain Manager.';
    begin
        if (Rec."Document Type" = Rec."document type"::Order) and (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin

            recSalesHead.Get(Rec."Document Type", Rec."Document No.");
            if (recSalesHead."Sales Order Type" = recSalesHead."Sales Order Type"::Eicard) and
               (recSalesHead."Eicard Type" = recSalesHead."Eicard Type"::eCommerce)
            then begin
                PrevValue := SI.SkipErrorOnBlockOnOrder;
                SI.SetSkipErrorOnBlockOnOrder(true);
            end;

            recItem.Get(Rec."No.");
            recSalesHead.Get(Rec."Document Type", Rec."Document No.");
            if not SI.SkipErrorOnBlockOnOrder then
                if recItem."Block on Sales Order" then
                    Error(lText006, Rec."No.");

            SI.SetSkipErrorOnBlockOnOrder(PrevValue);

            if recCustItemBlock.Get(recCustItemBlock.Type::Block, recSalesHead."Sell-to Customer No.", Rec."No.") then
                Error(lText002, Rec."No.", Rec."Sell-to Customer No.");
        end;

        if (Rec."Document Type" = Rec."document type"::"Return Order") and (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            recItem.get(Rec."No.");
            Rec."Not Returnable" := recItem."Not Returnable";
        end;


        if (xRec."No." <> '') and (Rec."No." <> xRec."No.") then
            Error(lText001, Rec.FieldCaption(Rec."No."));

        if (CurrFieldNo = Rec.FieldNo(Rec."No.")) and
           (Rec."Lock by Ref Document") then
            Error(lText005);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateSLNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recCust: Record Customer;
        recItem: Record Item;
        recSalesHead: Record "Sales Header";
        recVend: Record Vendor;
        recItemUnitOfMes: Record "Item Unit of Measure";
        recGlAcc: Record "G/L Account";
        recPostGrpCtryLoc: Record "Post Grp. pr. Country / Loc.";
        SI: Codeunit "Single Instance";
        lText001: Label 'Please enter "%1" on "%2" "%3", item no. "%4".\\The "%1" is generated on the customers server. Please contact the customer.';
        lText002: Label 'The license must be purchased by vendor %1 - %2.';
        lText003: Label 'The field "%1" must be filled on "%2" "%3". Please contact the Finance Department.';
        lText004: Label '"%1" is %2. Are you sure you want to use item no. %3?';
        lText005: Label 'Item No. %1 is inactive. Are you sure you want to continue?';
        lText006: Label 'Iten No. %1 is neither an EiCard or an "Non Zyxel License".';
        lText007: Label 'The item %1 is "End of Life".\\"%2"=%3,\"%4"=%5.';
        lText008: Label 'For "Customer No." %1 you can only sell "Item No." %2 from "Location Code" %3.\See "%4".';
        lText009: Label 'The item is provided by an external supplier: %1';
        lText010: Label 'The item is marked as "%1", but no vendor number has been supplied';
        lText011: Label 'Item No. %1 does not match Sales Order Type %2.';
    begin
        if Rec."Document Type" = Rec."document type"::Order then begin
            if Rec.Type = Rec.Type::Item then begin
                recItem.Get(Rec."No.");

                ValidateLocationCodeWithSalesOrderType(Rec."Sales Order Type", recItem);

                if Rec."Sales Order Type" = Rec."sales order type"::EICard then begin
                    if recItem."Non ZyXEL License" then begin
                        if not recVend.Get(recItem."Non ZyXEL License Vendor") then;
                        Error(lText002, recItem."Non ZyXEL License Vendor", recVend.Name);
                    end;

                    recSalesHead.Get(Rec."Document Type", Rec."Document No.");
                    if (recSalesHead."Eicard Type" <> recSalesHead."Eicard Type"::eCommerce) and
                       (recItem."Lifecycle Phase" = recItem."lifecycle phase"::"Pre-Disable") or
                       ((recItem."Last Buy Date" < Today) and (recItem."Last Buy Date" <> 0D))
                    then
                        Error(lText007, Rec."No.", recItem.FieldCaption("Last Buy Date"), recItem."Last Buy Date", recItem.FieldCaption("Lifecycle Phase"), recItem."Lifecycle Phase");
                end else begin
                    recSalesHead.Get(Rec."Document Type", Rec."Document No.");
                    Rec."Shipment Date" := recSalesHead."Shipment Date";
                end;
            end;
        end;
        // 12-09-2025 BK #526671 - Remove SET code for TR drop shipment

        if (Rec.Type = Rec.Type::"G/L Account") and (Rec."IC Partner Reference" = '') and (Rec."No." <> '') then begin
            recGlAcc.Get(Rec."No.");
            recSalesHead.Get(Rec."Document Type", Rec."Document No.");
            if (recGlAcc."Default IC Partner G/L Acc. No" = '') and
               (recSalesHead."Sell-to Customer No." <> recSalesHead."Bill-to Customer No.")
            then
                Error(lText003, recGlAcc.FieldCaption("Default IC Partner G/L Acc. No"), recGlAcc.TableCaption(), Rec."No.");
        end;

        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            recSalesHead.Get(Rec."Document Type", Rec."Document No.");
            if recPostGrpCtryLoc.Get(recSalesHead."Sell-to Country/Region Code", recSalesHead."Location Code") then begin
                Rec.Validate(Rec."VAT Prod. Posting Group", recPostGrpCtryLoc."VAT Prod. Post. Group - Sales");
                if recPostGrpCtryLoc."Line Discount %" <> 0 then
                    Rec.Validate(Rec."Line Discount %", recPostGrpCtryLoc."Line Discount %");
            end;

            recItem.Get(Rec."No.");
            if (recItem."End of Life Date" <> 0D) and (recItem."End of Life Date" < Today) then
                if (not SI.GetHideSalesDialog) and (not recSalesHead."eCommerce Order") then
                    Message(lText004, recItem.FieldCaption("End of Life Date"), recItem."End of Life Date", Rec."No.");

            if recItem.Inactive then
                if (not SI.GetHideSalesDialog) and (not recSalesHead."eCommerce Order") then
                    Message(lText005, Rec."No.");

            if Rec."Sales Order Type" = Rec."sales order type"::EICard then begin
                if not recItem.IsEICard and not recItem."Non ZyXEL License" then
                    Error(lText006);

                if recItem."Non ZyXEL License" then
                    if recVend.Get(recItem."Non ZyXEL License Vendor") then
                        Message(lText009, recVend.Name)
                    else
                        Message(lText010, recItem.FieldCaption("Non ZyXEL License"));


                if not recItem.IsEICard then
                    Error(lText011, Rec."No.", Rec."Sales Order Type");
            end;

        end;
        if not recCust.Get(Rec."Sell-to Customer No.") then;
        Rec.Validate(Rec."Skip Posting Group Validation", recCust."Skip Posting Group Validation");

        SetAddVatProdPostGrp(Rec);
        Rec.Validate(Rec."Gen. Prod. Posting Group");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Quantity', false, false)]
    local procedure OnBeforeValidateSLQuantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        recItem: Record Item;
        recCust: Record Customer;
        SI: Codeunit "Single Instance";
        PrevQuantity: Decimal;
        NewQuantity: Decimal;
        lText001: Label '%1 is changed from %2 to %3\because "%4" on the item card has the value %5.';
        lText002: Label 'Minimum Carton Ordering Policy want to make an adjustment.\\Quantity: %1\New Quantity: %2\\Do you want to make this adjustment?';
    begin

        if not SI.GetHideSalesDialog then
            if (Rec."Document Type" in [Rec."document type"::Order, Rec."document type"::Invoice]) and
               (Rec.Type = Rec.Type::Item) and
               (Rec."No." <> '')
            then begin
                recItem.Get(Rec."No.");
                if recItem."Order Multiple" <> 0 then begin
                    PrevQuantity := Rec.Quantity;
                    Rec.Quantity := Round(Rec.Quantity, recItem."Order Multiple", '>');
                    Message(lText001, Rec.FieldCaption(Rec.Quantity), PrevQuantity, Rec.Quantity, recItem.FieldCaption("Order Multiple"), recItem."Order Multiple");
                end;

                recSalesSetup.Get;
                if recSalesSetup."Full Pallet / Carton Ordering" then
                    if recItem."Min. Carton Qty. Enabled" and
                       (recItem."Number per carton" > 0) and
                       (Rec.Quantity > 0) and
                       (Rec."Sales Order Type" = Rec."sales order type"::Normal)
                    then begin
                        recCust.Get(Rec."Sell-to Customer No.");
                        if recCust."Full Pallet Ordering Enabled" then begin
                            case recCust."Full Pallet Ordering Rounding" of
                                recCust."full pallet ordering rounding"::"Round Down":
                                    NewQuantity := recItem."Number per carton" * ROUND((Rec.Quantity / recItem."Number per carton"), 1, '<');
                                recCust."full pallet ordering rounding"::"Round Up":
                                    NewQuantity := recItem."Number per carton" * ROUND((Rec.Quantity / recItem."Number per carton"), 1, '>');
                            end;
                            if NewQuantity = 0 then
                                NewQuantity := recItem."Number per carton";

                            if Rec.Quantity <> NewQuantity then
                                if Confirm(lText002, true, Rec.Quantity, NewQuantity) then
                                    Rec.Quantity := NewQuantity;
                        end;
                    end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure OnAfterValidateSLLocationCode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        SetAddVatProdPostGrp(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Hide Line', false, false)]
    local procedure OnBeforeValidateSLHideLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        lText001: Label 'You are not allowed to remove "%1" from an additional item line.';
    begin
        begin
            // You are not allowed to remove hide line.
            if xRec."Hide Line" and (Rec."Additional Item Line No." <> 0) then
                Error(lText001, Rec.FieldCaption(Rec."Hide Line"));
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'item reference no.', false, false)]
    local procedure OnBeforeValidateSLItemReferenceNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        sl: record "Sales Line";
    begin
        begin
            if CurrFieldNo = rec.FieldNo("Item Reference No.") then begin
                sl.setrange("Document No.", rec."Document No.");
                sl.setrange("Document Type", rec."Document Type");
                sl.setrange("Overshipment Line No.", rec."Line No.");
                if sl.FindSet() then
                    rec.RemUnitPrice := rec."Unit Price";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'item reference no.', false, false)]
    local procedure onAfterValidateSLItemReferenceNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        sl: record "Sales Line";
    begin

        if CurrFieldNo = rec.FieldNo("Item Reference No.") then begin
            if (rec.RemUnitPrice <> rec."Unit Price") then begin
                sl.setrange("Document No.", rec."Document No.");
                sl.setrange("Document Type", rec."Document Type");
                sl.setrange("Overshipment Line No.", rec."Line No.");
                if sl.FindSet() then
                    rec.validate("Unit Price", rec.RemUnitPrice);

            end;

            clear(rec.RemUnitPrice);
        end;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Shipment Date', false, false)]
    local procedure OnBeforeValidateSLShipmentDate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        lText001: Label '"Shipment Date" is trying to be changed from %1 to %2 on Sales Order %3 %4';
    begin
        if Rec."Shipment Date" = 99990101D then
            Error(Text001, Rec.FieldCaption(Rec."Shipment Date"), Rec."Shipment Date");

        if not GuiAllowed then
            if Rec."Sales Order Type" = Rec."Sales Order Type"::Eicard then
                if (Rec."Shipment Date" <> xRec."Shipment Date") and (xRec."Shipment Date" <> 0D) then
                    Error(ltext001, xRec."Shipment Date", Rec."Shipment Date", Rec."Document No.", Rec."Line No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Shipment Date', false, false)]
    local procedure OnAfterValidateSLShipmentDate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        lText001: Label '"Shipment Date" %1 is less that xRec."Shipment Date" %2. Please contact navsupport@zyxel.eu';
    begin
        // To locate an error.
        if not GuiAllowed() then
            if Rec."Shipment Date" < xRec."Shipment Date" then
                Error(lText001, Rec."Shipment Date", xRec."Shipment Date");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Shipment Date Confirmed', false, false)]
    local procedure OnBeforeValidateSLShipmentDateConfirmed(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        MarginApp: Record "Margin Approval";
        Cust: Record Customer;
        ZyXELVCKCreateDD: Codeunit "Delivery Document Management";
        PickDateConfMgt: Codeunit "Pick. Date Confirm Management";
        SI: Codeunit "Single Instance";
        lText001: Label '"Warehouse Status" is %1 on "Delivery Document" %2.\Are you sure you want to unconfirm the line?';
        lText002: Label 'The margin has not been approved, so you are not allowed to confirm the line.';
    begin
        if SI.GetValidateFromPage then begin
            Rec.TestStatusOpen;
            if Rec."Shipment Date Confirmed" and (Rec.Type = Rec.Type::Item) and (Rec."Document No." <> '') then
                if not PickDateConfMgt.PerformManuelConfirm2(1, '') then;
        end;

        if not Rec."Shipment Date Confirmed" then
            if Rec."Warehouse Status" = Rec."warehouse status"::New then begin
                recDelDocLine.SetRange("Sales Order No.", Rec."Document No.");
                recDelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
                if recDelDocLine.FindFirst() then begin
                    Rec."Delivery Document No." := '';
                    recDelDocLine.Delete();
                end;
            end;

        if MarginApp.MarginApprovalActive then begin
            Cust.get(Rec."Sell-to Customer No.");
            if not Cust."Sample Account" then begin
                Rec.Calcfields("Margin Approved");
                if not Rec."Margin Approved" then
                    error(lText002);
            end;
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Shipment Date Confirmed', false, false)]
    local procedure OnAfterValidateSLShipmentDateConfirmed(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recSalesHead: Record "Sales Header";
        recAddSalesLine: Record "Sales Line";
        recFrgtSalesLine: Record "Sales Line";
        SI: Codeunit "Single Instance";
        DelDocMgt: Codeunit "Delivery Document Management";
    begin
        if Rec."Shipment Date Confirmed" and
           (Rec.Type = Rec.Type::Item) and
           (Rec."Document No." <> '')
        then begin
            if SI.GetUpdateShipmentDate then begin
                recSalesHead.Get(Rec."Document Type", Rec."Document No.");
                Rec."Shipment Date" :=
                  DelDocMgt.CalcShipmentDate(
                    Rec."Sell-to Customer No.",
                    Rec."No.",
                    recSalesHead."Ship-to Country/Region Code",
                    Rec."Shortcut Dimension 1 Code",
                    Rec."Shipment Date",
                    true);
            end;
        end else
            Rec."Shipment Date" := 0D;
        Rec.Modify(true);

        recAddSalesLine.SetRange("Document Type", Rec."Document Type");
        recAddSalesLine.SetRange("Document No.", Rec."Document No.");
        recAddSalesLine.SetRange("Additional Item Line No.", Rec."Line No.");
        if recAddSalesLine.FindSet() then
            repeat
                recAddSalesLine."Shipment Date Confirmed" := Rec."Shipment Date Confirmed";
                recAddSalesLine."Shipment Date" := Rec."Shipment Date";
                recAddSalesLine.Modify();
            until recAddSalesLine.Next() = 0;

        recFrgtSalesLine.SetRange("Document Type", Rec."Document Type");
        recFrgtSalesLine.SetRange("Document No.", Rec."Document No.");
        recFrgtSalesLine.SetRange("Freight Cost Related Line No.", Rec."Line No.");
        if recFrgtSalesLine.FindSet() then
            repeat
                recFrgtSalesLine."Shipment Date Confirmed" := Rec."Shipment Date Confirmed";
                recFrgtSalesLine."Shipment Date" := Rec."Shipment Date";
                recFrgtSalesLine.Modify();
            until recFrgtSalesLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Return Reason Code', false, false)]
    local procedure OnBeforeValidateSLReturnReasonCode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        ReturnReason: Record "Return Reason";
        lText001: Label '"%1" %2 can not be used on %3.';
        lText002: Label '"%1" %2 can only be used on %3.\\Do you want to continue?';
        lText003: Label 'Editing is cancled.';
    begin
        if Rec."Return Reason Code" <> '' then begin
            case Rec."Document Type" of
                Rec."document type"::"Return Order":
                    begin
                        if Rec."Return Reason Code" <> '' then begin
                            ReturnReason.get(Rec."Return Reason Code");
                            if not returnreason."Use on Sales Return Order" then
                                Error(lText001, Rec.FieldCaption(Rec."Return Reason Code"), Rec."Return Reason Code", Rec."document type"::"Return Order");
                        end;
                    end;
                Rec."document type"::"Credit Memo":
                    if Rec."Return Reason Code" = '1' then
                        if not Confirm(lText002, false, Rec.FieldCaption(Rec."Return Reason Code"), Rec."Return Reason Code", Rec."document type"::"Return Order") then
                            Error(lText003);
            end;
            // 478493 >>
            if CurrFieldNo = rec.FieldNo("Return Reason Code") then
                rec.RemUnitPrice := rec."Unit Price";
            // 478493 <<                    
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Return Reason Code', false, false)]
    local procedure OnAfterValidateSL_ReturnReasonCode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        ReturnReason: Record "Return Reason";
        Item: Record Item;
        GlAcc: Record "G/L Account";
        ItemCharge: Record "Item Charge";
        SalesHeader: Record "Sales Header";
    begin
        if Rec."Document Type" IN [Rec."Document Type"::"Credit Memo", Rec."Document Type"::"Return Order"] then begin
            if ReturnReason.get(Rec."Return Reason Code") and (ReturnReason."Gen. Bus. Posting Group" <> '') then
                Rec.Validate("Gen. Bus. Posting Group", ReturnReason."Gen. Bus. Posting Group")
            else begin
                SalesHeader.get(Rec."Document Type", Rec."Document No.");
                Rec.Validate("Gen. Bus. Posting Group", SalesHeader."Gen. Bus. Posting Group")
            end;

            if ReturnReason.get(Rec."Return Reason Code") and (ReturnReason."Gen. Prod. Posting Group" <> '') then
                Rec.Validate("Gen. Prod. Posting Group", ReturnReason."Gen. Prod. Posting Group")
            else
                case Rec.Type of
                    Rec.Type::Item:
                        begin
                            Item.get(Rec."No.");
                            Rec.Validate("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group")
                        end;
                    Rec.Type::"G/L Account":
                        Begin
                            GlAcc.get(Rec."No.");
                            Rec.Validate("Gen. Prod. Posting Group", GlAcc."Gen. Prod. Posting Group");
                        End;
                    Rec.Type::"Charge (Item)":
                        Begin
                            ItemCharge.get(Rec."No.");
                            Rec.Validate("Gen. Prod. Posting Group", ItemCharge."Gen. Prod. Posting Group");
                        End;
                    Rec.Type::"Fixed Asset":
                        Begin
                        End;
                end;
            // 478493 >>
            if CurrFieldNo = rec.FieldNo("Return Reason Code") then
                if (rec.RemUnitPrice <> rec."Unit Price") then
                    rec.validate("Unit Price", rec.RemUnitPrice);
            clear(rec.RemUnitPrice);
            // 478493 <<  

        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Unit Price', false, false)]
    local procedure OnBeforeValidateSLUnitPriceExclVAT(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recGenBusPostGrp: Record "Gen. Business Posting Group";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        UpdateUnitPrice(Rec, Xrec, CurrFieldNo, false);

        // This code can be removed, when sales to eCommerce is done direct from ZNet DK.
        if ZGT.IsZNetCompany then
            if (Rec."Sell-to Customer No." in ['200125', '200153']) and
               (Rec."Document Type" in [Rec."document type"::Order, Rec."document type"::Invoice]) and
               (not Rec."Hide Line")
            then
                Rec."Unit Price" := GetZyxelUnitCost(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit Price', false, false)]
    local procedure OnAfterValidateSLUnitPriceExclVAT(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        DelDocLine: Record "VCK Delivery Document Line";
        SalesLine: Record "Sales Line";
        MarginApp: Record "Margin Approval";
        MarginAppType: Enum "Margin Approval Type";
    begin
        if Rec."Document Type" = Rec."Document Type"::Order then begin
            If Rec."Delivery Document No." <> '' then begin
                DelDocLine.SetCurrentkey("Sales Order No.", "Sales Order Line No.");
                DelDocLine.SetRange("Document Type", DelDocLine."document type"::Sales);
                DelDocLine.SetRange("Sales Order No.", Rec."Document No.");
                DelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
                if DelDocLine.FindFirst() then begin
                    if Rec."Unit Price" <> 0 then
                        DelDocLine.Validate("Unit Price", Rec."Unit Price")
                    else
                        DelDocLine.Validate("Unit Price", Rec."Unit Cost");
                    DelDocLine.Modify();
                end;

                if Rec."Overshipment Line No." <> 0 then begin
                    if SalesLine.get(Rec."Document Type", Rec."Document No.", Rec."Overshipment Line No.") then
                        If SalesLine."Delivery Document No." <> '' then begin
                            DelDocLine.SetCurrentkey("Sales Order No.", "Sales Order Line No.");
                            DelDocLine.SetRange("Document Type", DelDocLine."document type"::Sales);
                            DelDocLine.SetRange("Sales Order No.", SalesLine."Document No.");
                            DelDocLine.SetRange("Sales Order Line No.", SalesLine."Line No.");
                            if DelDocLine.FindFirst() then begin
                                if Rec."Unit Price" <> 0 then
                                    DelDocLine.Validate("Unit Price", Rec."Unit Price")
                                else
                                    DelDocLine.Validate("Unit Price", Rec."Unit Cost");
                                DelDocLine.Modify();
                            end;
                        end;
                end;
            end;
        end;

        if (Rec.Type = Rec.Type::Item) and ((Rec."Unit Price" <> 0) or (Rec."Unit Price" <> 0)) then
            case Rec."Document Type" of
                Rec."Document Type"::Order:
                    MarginApp.ApproveSalesLine(Rec);
                Rec."Document Type"::Invoice:
                    MarginApp.ApproveSalesLine(Rec);
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Zero Unit Price Accepted', false, false)]
    local procedure OnBeforeValidateZeroUnitPriceAccepted(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        Rec.TestStatusOpen;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Gen. Prod. Posting Group', false, false)]
    local procedure OnAfterValidateSLGenProdPostGrp(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recGPPGroupRetReasonRelat: Record "G.P.P. Group Ret. Reason Relat";
    begin
        if not recGPPGroupRetReasonRelat.Get(Rec."Gen. Prod. Posting Group", Rec."Return Reason Code") then
            Rec."Return Reason Code" := '';
        recGPPGroupRetReasonRelat.SetRange("Gen. Prod. Posting Group", Rec."Gen. Prod. Posting Group");
        recGPPGroupRetReasonRelat.SetRange(Mandatory, true);
        if recGPPGroupRetReasonRelat.FindFirst() and recGPPGroupRetReasonRelat.FindFirst() then
            Rec.Validate(Rec."Return Reason Code", recGPPGroupRetReasonRelat."Return Reason Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateSLSellToCustomerNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        SetAddVatProdPostGrp(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateSLQuantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recDelDocLine: Record "VCK Delivery Document Line";
        recItem: Record Item;
        lText001: Label 'Delivery Document %1 is released and sent to the warehouse.\If you change the quantity you have to advice the warehouse manually.\\Are you sure that you want change the quantity?';
        lText002: Label 'The quantity on the delivery document %1 i updated.';
        lText003: Label '\Please advice the warehouse about the change.';
    begin
        if Rec.Type = Rec.Type::Item then begin
            if Rec.Quantity <> xRec.Quantity then begin
                recDelDocLine.SetCurrentkey("Sales Order No.", "Sales Order Line No.");
                recDelDocLine.SetRange("Document Type", recDelDocLine."document type"::Sales);
                recDelDocLine.SetRange("Sales Order No.", Rec."Document No.");
                recDelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
                recDelDocLine.SetAutoCalcFields("Document Status");
                if recDelDocLine.FindFirst() then
                    if recDelDocLine."Document Status" = recDelDocLine."document status"::New then begin
                        recDelDocLine.Validate(Quantity, Rec.Quantity);
                        recDelDocLine.Modify(true);
                        Message(lText002, recDelDocLine."Document No.");
                    end else
                        if Confirm(lText001, false, recDelDocLine."Document No.") then begin
                            recDelDocLine.Validate(Quantity, Rec.Quantity);
                            recDelDocLine.Modify(true);
                            Message(lText002 + lText003, recDelDocLine."Document No.");
                        end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit Cost', false, false)]
    local procedure OnAfterValidateSLUnitCost(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recGenBusPostGrp: Record "Gen. Business Posting Group";
    begin
        UpdateUnitPrice(Rec, xRec, CurrFieldNo, true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit Cost (LCY)', false, false)]
    local procedure OnAfterValidateSLUnitCostLCY(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recGenBusPostGrp: Record "Gen. Business Posting Group";
    begin
        UpdateUnitPrice(Rec, xRec, CurrFieldNo, true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Warehouse Status', false, false)]
    local procedure OnAfterValidateSLWarehouseStatus(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if Rec."Warehouse Status" = Rec."warehouse status"::New then
            Rec."Delivery Document No." := '';
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'VAT %', false, false)]
    local procedure "OnAfterValidateSLVAT%"(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recDelDocLine: Record "VCK Delivery Document Line";
    begin
        recDelDocLine.SetRange("Sales Order No.", Rec."No.");
        recDelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
        recDelDocLine.SetFilter("Warehouse Status", '<%1', recDelDocLine."warehouse status"::Posted);
        if recDelDocLine.FindSet() then
            repeat
                recDelDocLine.Validate("VAT %", Rec."VAT %");
                recDelDocLine.Modify(true);
            until recDelDocLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure "OnAfterValidateSLLineDiscount%"(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recDelDocLine: Record "VCK Delivery Document Line";
    begin
        recDelDocLine.SetRange("Sales Order No.", Rec."No.");
        recDelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
        recDelDocLine.SetFilter("Warehouse Status", '<%1', recDelDocLine."warehouse status"::Posted);
        if recDelDocLine.FindSet() then
            repeat
                recDelDocLine.Validate("Line Discount %", Rec."Line Discount %");
                recDelDocLine.Modify(true);
            until recDelDocLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Sales Order Type', false, false)]
    local procedure OnAfterValidateSLSalesOrderType(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recPurchasing: Record Purchasing;
    begin
        if Rec.Type = Rec.Type::Item then
            if (Rec."Document Type" = Rec."document type"::Order) and
               (Rec."Sales Order Type" = Rec."sales order type"::"Spec. Order")
            then begin
                recPurchasing.SetRange("Special Order", true);
                recPurchasing.FindFirst();
                Rec.Validate(Rec."Purchasing Code", recPurchasing.Code);
            end else
                if Rec."Purchasing Code" <> '' then
                    Rec.Validate(Rec."Purchasing Code", '');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Freight Cost Related Line No.', false, false)]
    local procedure OnAfterValidateSLFreightCostRelatedLineNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recSalesLine: Record "Sales Line";
        recDelDocHead: Record "VCK Delivery Document Header";
        recDelDocLine: Record "VCK Delivery Document Line";
        DelDocMgt: Codeunit "Delivery Document Management";
        lText001: Label 'The delivery document has been sent to the warehouse.';
        lText002: Label '\The %1 must be invoiced manually.';
    begin
        Rec.CalcFields(Rec."Freight Cost Item");
        if Rec."Freight Cost Item" then
            if Rec."Freight Cost Related Line No." <> 0 then begin
                recSalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Freight Cost Related Line No.");
                if recSalesLine."Shipment Date Confirmed" then begin
                    if recSalesLine."Delivery Document No." = '' then begin
                        Rec."Shipment Date Confirmed" := true;
                        Rec."Shipment Date" := recSalesLine."Shipment Date";
                        Rec.Modify(true);
                    end else begin
                        recDelDocHead.Get(recSalesLine."Delivery Document No.");
                        if recDelDocHead."Warehouse Status" = recDelDocHead."warehouse status"::New then begin
                            Rec."Shipment Date Confirmed" := true;
                            Rec."Shipment Date" := recSalesLine."Shipment Date";
                            Rec.Status := Rec.Status::Released;
                            Rec.Modify(true);
                            DelDocMgt.PerformCreationForSingleOrderWithoutConfirmation(Rec."Document No.");
                            Rec.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
                        end else
                            Error(lText001 + lText002, Rec."No.");
                    end;
                end;
            end else begin
                Rec."Shipment Date Confirmed" := false;
                Rec."Shipment Date" := 0D;
                Rec.Modify(true);

                if Rec."Delivery Document No." <> '' then begin
                    recDelDocHead.Get(Rec."Delivery Document No.");
                    if recDelDocHead."Warehouse Status" = recDelDocHead."warehouse status"::New then begin
                        recDelDocLine.SetRange("Document No.", Rec."Delivery Document No.");
                        recDelDocLine.SetRange("Sales Order No.", Rec."Document No.");
                        recDelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
                        if recDelDocLine.FindFirst() then begin
                            recDelDocLine.Delete(true);
                            Rec.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
                        end;
                    end else
                        Error(lText001);
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Outstanding Amount (LCY)', false, false)]
    local procedure OnAfterValidateSLOutstandingAmountLCY(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        recDelDocLine: Record "VCK Delivery Document Line";
    begin
        recDelDocLine.SetCurrentkey("Sales Order No.", "Sales Order Line No.");
        recDelDocLine.SetRange("Document Type", recDelDocLine."document type"::Sales);
        recDelDocLine.SetRange("Sales Order No.", Rec."Document No.");
        recDelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
        if recDelDocLine.FindFirst() then begin
            recDelDocLine.Validate("Outstanding Amount (LCY)", Rec."Outstanding Amount (LCY)");
            recDelDocLine.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateQuantityOnBeforeCheckAssocPurchOrder', '', false, false)]
    local procedure SalesLine_OnValidateQuantityOnBeforeCheckAssocPurchOrder(var SalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    var
        LMSG000: Label 'Locked by reference purchase document!';
    begin
        if (CurrentFieldNo = SalesLine.FieldNo(Quantity)) and SalesLine."Lock by Ref Document" then
            Error(LMSG000);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Requested Delivery Date', false, false)]
    local procedure SalesLine_OnAfterValidateRequestedDeliveryDate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if (Rec."Requested Delivery Date" <> 0D) and (Rec."Requested Delivery Date" <> xRec."Requested Delivery Date") then begin
            if xRec."Planned Delivery Date" <> 0D then
                Rec.Validate("Planned Delivery Date", xRec."Planned Delivery Date");
            if xRec."Shipment Date" <> 0D then
                Rec.Validate("Shipment Date", xRec."Shipment Date");
        end;
        if not Rec.Modify() then;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidatePlannedDeliveryDate', '', false, false)]
    local procedure SalesLine_OnBeforeValidatePlannedDeliveryDate(var IsHandled: Boolean; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        AllInDates: Codeunit "Delivery Document Management";
    begin
        if SalesLine."Planned Delivery Date" <> 0D then
            SalesHeader.SetFilter("No.", SalesLine."Document No.");
        if SalesHeader.FindFirst() then
            SalesLine."Planned Delivery Date" := AllInDates.CalcDeliveryDate(SalesLine."Planned Delivery Date", SalesHeader."Ship-to Country/Region Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidatePlannedShipmentDate', '', false, false)]
    local procedure SalesLine_OnBeforeValidatePlannedShipmentDate(var IsHandled: Boolean; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        AllInDates: Codeunit "Delivery Document Management";
    begin
        if SalesLine."Sales Order Type" <> SalesLine."Sales Order Type"::"Drop Shipment" then begin
            if SalesLine."Planned Shipment Date" <> 0D then
                SalesHeader.SetFilter("No.", SalesLine."Document No.");
            if SalesHeader.FindFirst() then
                SalesLine."Planned Delivery Date" :=
                    AllInDates.CalcShipmentDate(
                        SalesLine."Sell-to Customer No.",
                        SalesLine."No.",
                        SalesHeader."Ship-to Country/Region Code",
                        SalesLine."Shortcut Dimension 1 Code",
                        SalesLine."Planned Shipment Date",
                        false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeInitOutstandingAmount', '', false, false)]
    local procedure SalesLine_OnBeforeInitOutstandingAmount(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
        if (not SalesLine."Completely Shipped") and (SalesLine.Quantity = 0) then
            SalesLine."Completely Shipped" := (SalesLine."BOM Line No." <> 0) and SalesLine."Hide Line" and (SalesLine.Quantity = 0) and (SalesLine."Outstanding Quantity" = 0);
        if not SalesLine."Completely Shipped" then
            SalesLine."Completely Shipped" := SalesLine.Type = SalesLine.Type::"G/L Account";
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure SalesLine_OnAfterInitHeaderDefaults(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; xSalesLine: Record "Sales Line")
    begin
        SalesLine."External Document No." := SalesHeader."External Document No.";
        SalesLine."Ship-to Code" := GetShipToCodeForSalesLine(SalesHeader);
        SalesLine."Sales Order Type" := SalesHeader."Sales Order Type"; //RD
    end;

    local procedure SetAddVatProdPostGrp(var Rec: Record "Sales Line")
    var
        recAddPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
        recSalesHead: Record "Sales Header";
        recItem: Record Item;
        ZGT: Codeunit "ZyXEL General Tools";

    begin
        recSalesHead.Get(Rec."Document Type", Rec."Document No.");
        if ((Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and (Rec."Location Code" <> '') and (Rec."VAT Bus. Posting Group" <> '')) or
           ((Rec.Type = Rec.Type::"G/L Account") and (Rec."No." <> '') and (recSalesHead."Location Code" <> '') and (Rec."VAT Bus. Posting Group" <> ''))
        then begin
            recAddPostGrpSetup.SetRange("Country/Region Code", recSalesHead."Ship-to Country/Region Code");

            if Rec.Type = Rec.Type::"G/L Account" then
                recAddPostGrpSetup.SetRange("Location Code", recSalesHead."Location Code")
            else
                recAddPostGrpSetup.SetRange("Location Code", Rec."Location Code");
            recAddPostGrpSetup.SetFilter("Customer No.", '%1|%2', '', Rec."Sell-to Customer No.");
            if ZGT.IsRhq() then
                recAddPostGrpSetup.SetRange("Company Type", recAddPostGrpSetup."company type"::Main);
            if recAddPostGrpSetup.FindLast() and (recAddPostGrpSetup."VAT Prod. Posting Group" <> '') then
                Rec.Validate(Rec."VAT Prod. Posting Group", recAddPostGrpSetup."VAT Prod. Posting Group")
            ELSE
                IF (Rec.Type = Rec.Type::Item) THEN BEGIN
                    recItem.GET(Rec."No.");
                    Rec.VALIDATE("VAT Prod. Posting Group", recItem."VAT Prod. Posting Group");
                END;
        end;
    end;

    local procedure UpdateUnitPrice(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer; ValidateUnitPrice: Boolean)
    var
        recGenBusPostGrp: Record "Gen. Business Posting Group";
    begin
        if recGenBusPostGrp.Get(Rec."Gen. Bus. Posting Group") and (recGenBusPostGrp."Sample / Test Equipment" > recGenBusPostGrp."sample / test equipment"::" ") then
            if recGenBusPostGrp."Sample / Test Equipment" = recGenBusPostGrp."sample / test equipment"::"Sample (Unit Price = Zero)" then begin
                if ValidateUnitPrice then
                    Rec.Validate(Rec."Unit Price", 0)
                else
                    Rec."Unit Price" := 0;
            end else
                if ValidateUnitPrice then
                    Rec.Validate(Rec."Unit Price", Rec."Unit Cost")
                else
                    Rec."Unit Price" := Rec."Unit Cost";
    end;

    procedure OnAfterDeleteSalesLinePage(var Rec: Record "Sales Line")
    var
        lText001: Label 'It is not allowed to delete an additional line.';
        lText002: Label 'The sales line is created on delivery document %1. You must delete the delivery document line before you delete the sales line.';
        lSalesLine: Record "Sales Line";
        recDelDocLine: Record "VCK Delivery Document Line";
        lText003: Label 'You are about to delete an additional line.\Do you want to continue?';
    begin
        // Additional item line must not be deleted seperatly
        lSalesLine.SetRange("Document Type", Rec."Document Type");
        lSalesLine.SetRange("Document No.", Rec."Document No.");
        lSalesLine.SetRange("Line No.", Rec."Additional Item Line No.");
        if lSalesLine.FindFirst() then
            if Rec."Edit Additional Sales Line" then begin
                if not Confirm(lText003, true) then
                    Error(lText001);
            end else
                Error(lText001);

        // Delete additional item lines who belongs to the line
        lSalesLine.Reset();
        lSalesLine.SetRange("Document Type", Rec."Document Type");
        lSalesLine.SetRange("Document No.", Rec."Document No.");
        lSalesLine.SetRange("Additional Item Line No.", Rec."Line No.");
        if lSalesLine.FindSet(true) then
            repeat
                lSalesLine.Delete();
            until lSalesLine.Next() = 0;

        // A delivery document line must be deleted before the sales line.
        if (Rec."Document Type" = Rec."document type"::Order) and (Rec."Sales Order Type" <> Rec."sales order type"::EICard) then begin
            recDelDocLine.SetRange("Sales Order No.", Rec."Document No.");
            recDelDocLine.SetRange("Sales Order Line No.", Rec."Line No.");
            if recDelDocLine.FindFirst() and
               (recDelDocLine.Quantity <> 0)
            then
                if Rec."Warehouse Status" = Rec."warehouse status"::New then
                    recDelDocLine.Delete(true)
                else
                    Error(lText002, recDelDocLine."Document No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitOutstanding', '', false, false)]
    local procedure OnAfterInitOutstanding(var SalesLine: Record "Sales Line")
    var
        recSalesHead: Record "Sales Header";
        recSalesSetup: Record "Sales & Receivables Setup";
        ArchiveMgt: Codeunit ArchiveManagement;
    begin
        if SalesLine."Document Type" in [SalesLine."document type"::"Return Order", SalesLine."document type"::"Credit Memo"] then begin
            case SalesLine."Document Type" of
                SalesLine."document type"::"Return Order":
                    if SalesLine.Type = SalesLine.Type::Item then
                        SalesLine."Completely Invoiced" :=
                          ((SalesLine."Outstanding Quantity" < SalesLine.Quantity) and (SalesLine."Return Qty. Rcd. Not Invd." = 0) and (SalesLine.Quantity <> 0)) or
                          ((SalesLine."Outstanding Quantity" = SalesLine.Quantity) and (SalesLine."Return Qty. Rcd. Not Invd." = 0) and (SalesLine.Quantity = 0))
                    else
                        SalesLine."Completely Invoiced" := (SalesLine."Outstanding Quantity" = 0) and (SalesLine."Return Qty. Rcd. Not Invd." = 0);
                SalesLine."document type"::"Credit Memo":
                    if SalesLine.Type = SalesLine.Type::Item then
                        SalesLine."Completely Invoiced" :=
                          ((SalesLine."Outstanding Quantity" = 0) and (SalesLine."Return Qty. Rcd. Not Invd." = 0) and (SalesLine.Quantity <> 0)) or
                          ((SalesLine."Outstanding Quantity" = 0) and (SalesLine."Return Qty. Rcd. Not Invd." = 0) and (SalesLine.Quantity = 0) and SalesLine."Hide Line")
                    else
                        SalesLine."Completely Invoiced" := (SalesLine."Outstanding Quantity" = 0) and (SalesLine."Return Qty. Rcd. Not Invd." = 0);
            end;
        end else begin
            if (not SalesLine."Completely Shipped") and (SalesLine.Quantity = 0) then
                SalesLine."Completely Shipped" := (SalesLine."BOM Line No." <> 0) and (SalesLine."Hide Line") and (SalesLine.Quantity = 0) and (SalesLine."Outstanding Quantity" = 0);
            if not SalesLine."Completely Shipped" then
                SalesLine."Completely Shipped" := SalesLine.Type = SalesLine.Type::"G/L Account";

            if SalesLine.Type = SalesLine.Type::Item then
                SalesLine."Completely Invoiced" :=
                  ((SalesLine."Outstanding Quantity" = 0) and (SalesLine."Qty. Shipped Not Invoiced" = 0) and (SalesLine.Quantity <> 0)) or
                  ((SalesLine."Outstanding Quantity" = 0) and (SalesLine."Qty. Shipped Not Invoiced" = 0) and (SalesLine.Quantity = 0) and SalesLine."Hide Line")
            else
                SalesLine."Completely Invoiced" := (SalesLine."Outstanding Quantity" = 0) and (SalesLine."Qty. Shipped Not Invoiced" = 0);
        end;
    end;


    procedure GetExternalDocNoFromSalesInvLine(pSalesInvHeadNo: Code[20]) rValue: Text
    var
        lSaleInvLine: Record "Sales Invoice Line";
    begin
        lSaleInvLine.SetCurrentkey("External Document No.");
        lSaleInvLine.SetRange("Document No.", pSalesInvHeadNo);
        lSaleInvLine.SetFilter("External Document No.", '<>%1', '');
        if lSaleInvLine.FindSet() then
            repeat
                if StrPos(rValue, lSaleInvLine."External Document No.") = 0 then begin
                    if rValue <> '' then
                        rValue := rValue + ', ';
                    rValue := rValue + lSaleInvLine."External Document No.";
                end;
                lSaleInvLine.SetRange("External Document No.", lSaleInvLine."External Document No.");
                if lSaleInvLine.FindLast() then
                    lSaleInvLine.SetFilter("External Document No.", '>%1', lSaleInvLine."External Document No.");
            until lSaleInvLine.Next() = 0;
    end;

    procedure GetExternalDocNoFromSalesCrMemoLine(pSalesCrMemoHeadNo: Code[20]) rValue: Text
    var
        lSaleCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        lSaleCrMemoLine.SetCurrentkey("External Document No.");
        lSaleCrMemoLine.SetRange("Document No.", pSalesCrMemoHeadNo);
        lSaleCrMemoLine.SetFilter("External Document No.", '<>%1', '');
        if lSaleCrMemoLine.FindSet() then
            repeat
                if rValue <> '' then
                    rValue := rValue + ', ';
                rValue := rValue + lSaleCrMemoLine."External Document No.";
                lSaleCrMemoLine.SetRange("External Document No.", lSaleCrMemoLine."External Document No.");
                if lSaleCrMemoLine.FindLast() then
                    lSaleCrMemoLine.SetFilter("External Document No.", '>%1', '');
            until lSaleCrMemoLine.Next() = 0;
    end;

    procedure SetZyxelReportSelectionFilter(HeaderDoc: Variant; var ReportSelections: Record "Report Selections")
    var
        HeaderRecRef: RecordRef;
        HeaderFieldRef: FieldRef;
        CountryRegCode: Code[10];
    begin
        HeaderRecRef.GetTable(HeaderDoc);
        HeaderFieldRef := HeaderRecRef.field(90);  // Sell-to Country/Region
        CountryRegCode := HeaderFieldRef.Value;

        ReportSelections.SetFilter("Country/Region Code", '%1|%2', '', CountryRegCode);
        if ReportSelections.FindLast() then
            ReportSelections.SetRange("Country/Region Code", ReportSelections."Country/Region Code");
    end;


    procedure UpdateUnshippedQuantity(SellToCustomerNo: Code[20])
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.IsRhq() then begin
            recSalesSetup.Get();
            recSalesSetup.TestField("Customer No. on Sister Company");
            if ZGT.IsZNetCompany then begin  // ZNet
                if SellToCustomerNo = recSalesSetup."Customer No. on Sister Company" then
                    ZyWebServMgt.SendUnshippedQuantity(ZGT.GetSistersCompanyName(1), SellToCustomerNo)
            end else  // Zyxel
                if SellToCustomerNo = recSalesSetup."Customer No. on Sister Company" then
                    ZyWebServMgt.SendUnshippedQuantity(ZGT.GetSistersCompanyName(1), SellToCustomerNo);
        end;
    end;

    procedure SendContainerDetails(SalesInvNo: Code[20]; SellToCustomerNo: Code[20])
    var
        recSalesSetup: Record "Sales & Receivables Setup";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if ZGT.IsRhq() then begin
            recSalesSetup.Get();
            recSalesSetup.TestField("Customer No. on Sister Company");
            if ZGT.IsZNetCompany then begin  // ZNet
                if SellToCustomerNo = recSalesSetup."Customer No. on Sister Company" then
                    ZyWebServMgt.SendContainerDetails(ZGT.GetSistersCompanyName(1), 0, SalesInvNo)
            end else  // Zyxel
                if SellToCustomerNo = recSalesSetup."Customer No. on Sister Company" then
                    ZyWebServMgt.SendContainerDetails(ZGT.GetSistersCompanyName(1), 0, SalesInvNo);
        end;
    end;


    procedure HidePostButtons(pLocationCode: Code[20]; pOrderNo: Code[20]) rValue: Boolean
    var
        recWarehouse: Record Location;
        recSalesLine: Record "Sales Line";
        recDelDocLine: Record "VCK Delivery Document Line";
        recItem: Record Item;
        PrevDelDocNo: Code[20];
    begin
        if not recWarehouse.Get(pLocationCode) then;
        rValue := recWarehouse.Warehouse = recWarehouse.Warehouse::" ";

        if not rValue and (pOrderNo <> '') then begin
            recSalesLine.SetRange("Document Type", recSalesLine."document type"::Order);
            recSalesLine.SetRange("Document No.", pOrderNo);
            recSalesLine.SetRange(Type, recSalesLine.Type::Item);
            recSalesLine.SetRange("Hide Line", false);
            recSalesLine.SetRange("Additional Item Line No.", 0);
            if recSalesLine.FindSet() then begin
                if (PrevDelDocNo = '') and
                   (recSalesLine."Delivery Document No." <> '') and
                   (recSalesLine.Quantity = recSalesLine."Quantity Shipped")
                then begin
                    rValue := true;
                    PrevDelDocNo := recSalesLine."Delivery Document No.";
                end;

                repeat
                    if (recSalesLine."Delivery Document No." <> PrevDelDocNo) or
                       (recSalesLine."Quantity Shipped" = 0)
                    then
                        rValue := false;

                    recDelDocLine.SetRange("Document No.", recSalesLine."Delivery Document No.");
                    recDelDocLine.SetFilter("Sales Order No.", '<>%1', recSalesLine."Document No.");
                    if recDelDocLine.FindFirst() then
                        rValue := false;
                until (recSalesLine.Next() = 0) or (not rValue);

                recSalesLine.SetFilter("Item Type", '<>%1', "Item Type"::Inventory);
                if recSalesLine.findfirst and (recSalesLine.Quantity <> recSalesLine."Quantity Shipped") then
                    rValue := true;

            end;
        end;
    end;

    local procedure GetZyxelUnitCost(var Rec: Record "Sales Line") rValue: Decimal
    var
        recVend: Record Vendor;
        recPurchPrice: Record "Price List Line";
        recItem: Record Item;
        ZGT: Codeunit "ZyXEL General Tools";
        i: Integer;
    begin
        if ZGT.IsRhq() then
            if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
                recPurchPrice.SetRange("Asset Type", recPurchPrice."Asset Type"::Item);
                recPurchPrice.SetRange("Asset No.", Rec."No.");
                recPurchPrice.SetFilter("Starting Date", '..%1', Today);
                recPurchPrice.SetFilter("Ending Date", '%1..|%2', Today, 0D);

                for i := 1 to 3 do begin
                    if ZGT.IsZComCompany then begin
                        case i of
                            1:
                                recVend.SetRange("SBU Company", recVend."sbu company"::"ZCom HQ");
                            2:
                                recVend.SetRange("SBU Company", recVend."sbu company"::"ZNet HQ");
                            3:
                                recVend.SetRange("SBU Company", recVend."sbu company"::"ZNet EMEA");
                        end;
                    end else
                        case i of
                            1:
                                recVend.SetRange("SBU Company", recVend."sbu company"::"ZNet HQ");
                            2:
                                recVend.SetRange("SBU Company", recVend."sbu company"::"ZCom HQ");
                            3:
                                recVend.SetRange("SBU Company", recVend."sbu company"::"ZCom EMEA");
                        end;

                    recVend.FindFirst();
                    recPurchPrice.SetRange("Source Type", recPurchPrice."Source Type"::Vendor);
                    recPurchPrice.SetRange("Source No.", recVend."No.");
                    if recPurchPrice.FindLast() and (recPurchPrice."Direct Unit Cost" <> 0) then begin
                        rValue := recPurchPrice."Direct Unit Cost";
                        i := 999;
                    end;
                end;

                // If we don´t find a Zyxel price, we use "Last Direce Cost".
                if i < 999 then begin
                    recItem.Get(Rec."No.");
                    rValue := recItem."Last Direct Cost";
                end;
            end;
    end;

    local procedure UpdatePickingDateConfirmation(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        recPickDateConf: Record "Picking Date Confirmed";
        Modified: Boolean;
        ItemLogisticEvents: Codeunit "Item / Logistic Events";
        ShortcutDimCode: array[8] of Code[20];
    begin
        if (Rec."Document Type" = Rec."document type"::Order) and (Rec."Sales Order Type" in [Rec."sales order type"::Normal, Rec."sales order type"::"Spec. Order"]) then
            if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and (Rec."BOM Line No." = 0) and (Rec."Additional Item Line No." = 0) then begin
                if not recPickDateConf.Get(recPickDateConf."source type"::"Sales Order", Rec."Document No.", Rec."Line No.") then begin
                    if Rec."Outstanding Quantity" > 0 then begin
                        recPickDateConf.Init();
                        recPickDateConf."Source Type" := recPickDateConf."source type"::"Sales Order";
                        recPickDateConf."Source No." := Rec."Document No.";
                        recPickDateConf."Source Line No." := Rec."Line No.";
                        recPickDateConf."Item No." := Rec."No.";
                        recPickDateConf."Location Code" := Rec."Location Code";
                        recPickDateConf."Picking Date" := Rec."Shipment Date";
                        recPickDateConf."Picking Date Confirmed" := Rec."Shipment Date Confirmed";
                        recPickDateConf."Outstanding Quantity" := Rec."Outstanding Quantity";
                        recPickDateConf."Outstanding Quantity (Base)" := Rec."Outstanding Qty. (Base)";
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        recPickDateConf."Country Code" := ShortcutDimCode[3];
                        recPickDateConf.Insert(true);
                    end;
                end else begin
                    if recPickDateConf."Item No." <> Rec."No." then begin
                        recPickDateConf."Item No." := Rec."No.";
                        Modified := true;
                    end;
                    if recPickDateConf."Location Code" <> Rec."Location Code" then begin
                        recPickDateConf."Location Code" := Rec."Location Code";
                        Modified := true;
                    end;
                    if recPickDateConf."Picking Date" <> Rec."Shipment Date" then begin
                        recPickDateConf."Picking Date" := Rec."Shipment Date";
                        recPickDateConf."Marked Entry" := false;
                        Modified := true;
                    end;
                    if recPickDateConf."Picking Date Confirmed" <> Rec."Shipment Date Confirmed" then begin
                        recPickDateConf."Picking Date Confirmed" := Rec."Shipment Date Confirmed";
                        recPickDateConf."Marked Entry" := false;
                        Modified := true;
                    end;
                    if recPickDateConf."Outstanding Quantity" <> Rec."Outstanding Quantity" then begin
                        recPickDateConf."Outstanding Quantity" := Rec."Outstanding Quantity";
                        Modified := true;
                    end;
                    if recPickDateConf."Outstanding Quantity (Base)" <> Rec."Outstanding Qty. (Base)" then begin
                        recPickDateConf."Outstanding Quantity (Base)" := Rec."Outstanding Qty. (Base)";
                        Modified := true;
                    end;

                    if Modified then
                        if (recPickDateConf."Outstanding Quantity" = 0) and (recPickDateConf."Outstanding Quantity (Base)" = 0) then
                            recPickDateConf.Delete(true)
                        else
                            recPickDateConf.Modify(true);
                end;
            end else
                if recPickDateConf.Get(recPickDateConf."source type"::"Sales Order", Rec."Document No.", Rec."Line No.") then
                    recPickDateConf.Delete(true);
    end;

    local procedure Eicard_UpdateCustomerNo(var Rec: Record "Sales Header")
    var
        recEiCardQueue: Record "EiCard Queue";
    begin
        if Rec."Document Type" = Rec."document type"::Order then
            if recEiCardQueue.Get(Rec."No.") then begin
                recEiCardQueue.Validate("Customer No.", Rec."Sell-to Customer No.");
                recEiCardQueue.Modify(true);
            end;
    end;

    // Page - Sales Order"()
    [EventSubscriber(Objecttype::Page, 42, 'OnAfterActionEvent', 'Reopen', false, false)]
    local procedure OnAfterActionEventReOpen_Page42(var Rec: Record "Sales Header")
    var
        recWhseShipHead: Record "Warehouse Shipment Header";
        recSalesLine: Record "Sales Line";
    begin
        OnAfterActionEventReOpen(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 9305, 'OnAfterActionEvent', 'Reopen', false, false)]
    local procedure OnAfterActionEventReOpen_Page9305(var Rec: Record "Sales Header")
    var
        recWhseShipHead: Record "Warehouse Shipment Header";
        recSalesLine: Record "Sales Line";
    begin
        OnAfterActionEventReOpen(Rec);
    end;

    procedure OnAfterActionEventReOpen(var Rec: Record "Sales Header")
    var
        recWhseShipHead: Record "Warehouse Shipment Header";
        recSalesLine: Record "Sales Line";
    begin
        if Rec."Document Type" = Rec."document type"::Order then begin
            recWhseShipHead.SetRange("Sales Order No.", Rec."No.");
            if recWhseShipHead.FindFirst() then
                recWhseShipHead.Delete(true);
        end;

        recSalesLine.SetRange("Document Type", Rec."Document Type");
        recSalesLine.SetFilter("Document No.", Rec."No.");
        if recSalesLine.FindSet(true) then
            repeat
                recSalesLine.Status := recSalesLine.Status::Open;
                recSalesLine.Modify(true);
            until recSalesLine.Next() = 0;
    end;

    [EventSubscriber(Objecttype::Page, 42, 'OnAfterActionEvent', 'Release', false, false)]
    local procedure OnAfterActionEventRelease_Page42(var Rec: Record "Sales Header")
    var
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
    begin
        OnAfterActionEventRelease(Rec);  // 06-08-21 ZY-LD 092
    end;

    [EventSubscriber(Objecttype::Page, 9305, 'OnAfterActionEvent', 'Release', false, false)]
    local procedure OnAfterActionEventRelease_Page9305(var Rec: Record "Sales Header")
    var
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
    begin
        OnAfterActionEventRelease(Rec);  // 06-08-21 ZY-LD 092
    end;

    procedure OnAfterActionEventRelease(var Rec: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
        recItem: Record Item;
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
    begin
        GetSourceDocOutbound.CreateFromSalesOrderHideDialog(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 42, 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateEventSellToCustomerNo_Page42(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        SI: Codeunit "Single Instance";
    begin
        if SI.GetDeleteSalesOrder then begin
            Rec.Delete(true);
            SI.SetDeleteSalesOrder(false);
        end;
    end;

    [EventSubscriber(Objecttype::Page, 42, 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeleteRecordEvent_Page42(var Rec: Record "Sales Header"; var AllowDelete: Boolean)
    var
        recEiCardQueue: Record "EiCard Queue";
        lText001: Label 'The EiCard Links has been sent to the customer, and you are therefore not able to cancle the sales order.';
        lText002: Label 'The EiCard order is linked to purchae order %1.\Are you sure you want to delete order no. %2?';
        recSaleLine: Record "Sales Line";
        recPurchHead: Record "Purchase Header";
        lText003: Label 'The purchase order %1 was not sent to eShop, and has therefore been deleted.';
        lText004: Label 'The purchase order %1 has been sent to eShop and can not be deleted.\The purchase order has been prepared for invoicing.\ The only chance for getting the money back is to request HQ for a credit memo.';
    begin
        if Rec."Document Type" = Rec."document type"::Order then
            if Rec."Sales Order Type" = Rec."sales order type"::EICard then begin
                if recEiCardQueue.Get(Rec."No.") then
                    if recEiCardQueue.Active then begin
                        if recEiCardQueue."Sales Order Status" = recEiCardQueue."sales order status"::"EiCard Sent to Customer" then
                            Error(lText001);


                        if Confirm(lText002, false, recEiCardQueue."Purchase Order No.", Rec."No.") then begin
                            recSaleLine.SetRange("Document Type", Rec."Document Type");
                            recSaleLine.SetRange("Document No.", Rec."No.");
                            if recSaleLine.FindSet(true) then
                                repeat
                                    recSaleLine."Lock by Ref Document" := false;
                                    recSaleLine.Modify();
                                until recSaleLine.Next() = 0;

                            recEiCardQueue.Validate("Sales Order Status", recEiCardQueue."sales order status"::Cancled);
                            recEiCardQueue.Modify(true);

                            case recEiCardQueue."Purchase Order Status" of
                                recEiCardQueue."purchase order status"::Created:
                                    begin
                                        recPurchHead.Get(recPurchHead."document type"::Order, recEiCardQueue."Purchase Order No.");
                                        recPurchHead.Delete(true);

                                        recEiCardQueue.Validate("Purchase Order Status", recEiCardQueue."purchase order status"::Cancled);
                                        recEiCardQueue."Purchase Order Deleted By" := UserId();
                                        recEiCardQueue.Modify(true);

                                        Message(lText003, recEiCardQueue."Purchase Order No.");
                                    end;

                                recEiCardQueue."purchase order status"::"EiCard Order Sent to HQ":
                                    begin
                                        recEiCardQueue.Validate("Purchase Order Status", recEiCardQueue."purchase order status"::"EiCard Order Accepted");
                                        recEiCardQueue.Modify(true);
                                        Message(lText004, recEiCardQueue."Purchase Order No.");
                                    end;
                            end;
                        end
                    end else
                        if not recEiCardQueue.Delete(true) then;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Totals", 'OnAfterCalculateSalesSubPageTotals', '', false, false)]
    local procedure OnAfterCalculateSalesSubPageTotals(var TotalSalesHeader: Record "Sales Header")
    begin
        TotalSalesHeader.CALCFIELDS("Line Discount Amount", "Total Quantity", "No of Lines");
    end;

    // Page Sales Order Line
    [EventSubscriber(Objecttype::Page, 46, 'OnModifyRecordEvent', '', false, false)]
    local procedure OnModifyRecordEvent_Page46(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; var AllowModify: Boolean)
    begin
        UpdatePickingDateConfirmation(Rec, xRec);
    end;

    [EventSubscriber(Objecttype::Page, 46, 'OnBeforeValidateEvent', 'Shipment Date Confirmed', false, false)]
    local procedure OnBeforeValidateShipmentDateConfirmed_Page46(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        lText001: Label '"Warehouse Status" is %1 on "Delivery Document" %2.\Are you sure you want to unconfirm the line?';
        PickDateConfMgt: Codeunit "Pick. Date Confirm Management";
    begin
        Rec.TestStatusOpen();
        if not Rec."Shipment Date Confirmed" then
            if Rec."Warehouse Status" <> Rec."warehouse status"::New then
                if not Confirm(lText001, false, Rec."Warehouse Status", Rec."Delivery Document No.") then
                    Error('');
    end;

    [EventSubscriber(Objecttype::Page, 46, 'OnAfterValidateEvent', 'Shipment Date Confirmed', false, false)]
    local procedure OnAfterValidateShipmentDateConfirmed_Page46(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetUpdateShipmentDate(false);
    end;

    [EventSubscriber(Objecttype::Page, 46, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNo_Page46(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        recItem: Record Item;
        lText001: Label 'Please enter "%1" on "%2" "%3", item no. "%4".\\The "%1" is generated on the customers server. Please contact the customer.';
        lText002: Label 'Please enter "%1 and %2" on "%3" "%4", item no. "%5".';
        lText003: Label '\\You can key in the EMS and GLC information in "Line / Related Info / EMS or GLC".';
        recAddEicardOrderInfo: Record "Add. Eicard Order Info";
    begin
        if (Rec."Document Type" = Rec."document type"::Order) and (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            recItem.Get(Rec."No.");
            case recItem."Enter Security for Eicard on" of
                recItem."enter security for eicard on"::"EMS License":
                    Message(lText001 + lText003, recAddEicardOrderInfo.FieldCaption("EMS Machine Code"), Rec.TableCaption(), Rec."Line No.", Rec."No.");
                recItem."enter security for eicard on"::"GLC License":
                    Message(lText002 + lText003, recAddEicardOrderInfo.FieldCaption("GLC Serial No."), recAddEicardOrderInfo.FieldCaption("GLC Mac Address"), Rec.TableCaption(), Rec."Line No.", Rec."No.");
            end;
        end;
    end;

    [EventSubscriber(Objecttype::Page, 6630, 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeleteRecordEvent6630(var Rec: Record "Sales Header"; var AllowDelete: Boolean)
    var
        recWhseInbHead: Record "Warehouse Inbound Header";
        recWhseIndbLine: Record "VCK Shipping Detail";
        recSalesLine: Record "Sales Line";
        SI: Codeunit "Single Instance";
        lText001: Label '"%1" %2 is created as Warehouse Inbound, and can not be deleted.';
        Text002: Label '\\Please contact navsupport@zyxel.eu to find a solution.';
    begin

        Rec.CalcFields(Rec."Completely Invoiced");
        recSalesLine.SetRange("Document Type", Rec."Document Type");
        recSalesLine.SetRange("Document No.", Rec."No.");
        if not Rec."Completely Invoiced" and recSalesLine.FindFirst() then begin
            recWhseInbHead.SetRange("Order Type", recWhseInbHead."order type"::"Sales Return Order");
            recWhseInbHead.SetRange("Shipment No.", Rec."No.");
            if recWhseInbHead.FindFirst() then begin
                if (recWhseInbHead."Warehouse Status" <= recWhseInbHead."warehouse status"::"Order Sent (2)") then begin
                    recWhseIndbLine.LockTable();
                    recWhseIndbLine.SetCurrentkey("Document No.");
                    recWhseIndbLine.SetRange("Document No.", recWhseInbHead."No.");
                    recWhseIndbLine.DeleteAll();

                    recWhseInbHead.Delete(true);

                    if recWhseInbHead."Sent To Warehouse" then begin
                        SI.SetMergefield(100, recWhseInbHead."No.");
                        EmailAddMgt.CreateSimpleEmail('LOGDELWIO', '', '');
                        EmailAddMgt.Send();
                    end;
                end else
                    Error(lText001 + Text002, Rec."Document Type", Rec."No.");
            end else begin
                recWhseIndbLine.SetRange("Purchase Order No.", Rec."No.");
                recWhseIndbLine.SetRange(Archive, false);
                if not recWhseIndbLine.IsEmpty() then
                    Error(lText001 + Text002, Rec."Document Type", Rec."No.");
            end;
        end;
    end;

    [EventSubscriber(Objecttype::Page, 6630, 'OnAfterActionEvent', 'Reopen', false, false)]
    local procedure OnAfterActionEventReOpen6630(var Rec: Record "Sales Header")
    begin
        DeleteWarehouseReceipt(Rec, true);
    end;

    [EventSubscriber(Objecttype::Page, 6630, 'OnAfterActionEvent', 'Release', false, false)]
    local procedure OnAfterActionEventRelease6630(var Rec: Record "Sales Header")
    begin
        CreateWarehouseReceipt(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 9304, 'OnAfterActionEvent', 'Reopen', false, false)]
    local procedure OnAfterActionEventReOpen9304(var Rec: Record "Sales Header")
    begin
        DeleteWarehouseReceipt(Rec, true);
    end;

    [EventSubscriber(Objecttype::Page, 9304, 'OnAfterActionEvent', 'Release', false, false)]
    local procedure OnAfterActionEventRelease9304(var Rec: Record "Sales Header")
    begin
        CreateWarehouseReceipt(Rec);
    end;

    procedure CreateWarehouseReceipt(var Rec: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
        recContDetail: Record "VCK Shipping Detail";
        recWhseInbHead: Record "Warehouse Inbound Header";
        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
    begin
        begin
            GetSourceDocInbound.CreateFromSalesReturnOrderHideDialog(Rec);
            recWhseInbHead.SetRange("Container No.", Rec."No.");
            recWhseInbHead.SetRange("Warehouse Status", recWhseInbHead."warehouse status"::"On Stock");
            if recWhseInbHead.IsEmpty() then
                ZyWebServMgt.SendContainerDetails(CompanyName(), 1, Rec."No.");
        end;
    end;

    procedure DeleteWarehouseReceipt(var Rec: Record "Sales Header"; DeleteWarehouseInbound: Boolean)
    var
        recWhseRcptHead: Record "Warehouse Receipt Header";
        recWhseIndbLine: Record "VCK Shipping Detail";
        recWhseIndbHead: Record "Warehouse Inbound Header";
    begin
        if Rec."Document Type" = Rec."document type"::"Return Order" then begin
            recWhseRcptHead.SetRange("Sales Return Order No.", Rec."No.");
            if recWhseRcptHead.FindFirst() then
                recWhseRcptHead.Delete(true);

            if DeleteWarehouseInbound then begin
                recWhseIndbLine.SetRange("Order Type", recWhseIndbLine."order type"::"Sales Return Order");
                recWhseIndbLine.SetRange("Purchase Order No.", Rec."No.");
                if recWhseIndbLine.FindFirst() then
                    if recWhseIndbLine."Document No." = '' then
                        recWhseIndbLine.DeleteAll(true)
                    else begin
                        if recWhseIndbHead.Get(recWhseIndbLine."Document No.") and
                           (recWhseIndbHead."Warehouse Status" < recWhseIndbHead."warehouse status"::"Goods Received")
                        then begin
                            recWhseIndbLine.DeleteAll(true);
                            recWhseIndbHead.Delete(true);
                        end;
                    end
            end;
        end;

    end;

    [EventSubscriber(Objecttype::Page, 41, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPage_Page41(var Rec: Record "Sales Header")
    var
        recLink: Record "Record Link";
        FileMgt: Codeunit "File Management";
    begin
        recLink.SetRange("Record ID", Rec.RecordId);
        if recLink.FindFirst() then
            Hyperlink(recLink.URL1);
    end;

    [EventSubscriber(Objecttype::Page, 41, 'OnBeforeActionEvent', 'MakeOrder', false, false)]
    local procedure OnBeforeMakeOrder_Page41(var Rec: Record "Sales Header")
    begin
        OnBeforeMakeOrderQuote(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 41, 'OnAfterActionEvent', 'MakeOrder', false, false)]
    local procedure OnAfterMakeOrder_Page41(var Rec: Record "Sales Header")
    begin
        OnAfterMakeOrderQuote(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 9300, 'OnBeforeActionEvent', 'MakeOrder', false, false)]
    local procedure OnBeforeMakeOrder_Page9300(var Rec: Record "Sales Header")
    begin
        OnBeforeMakeOrderQuote(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 9300, 'OnAfterActionEvent', 'MakeOrder', false, false)]
    local procedure OnAfterMakeOrder_Page9300(var Rec: Record "Sales Header")
    begin
        OnAfterMakeOrderQuote(Rec);
    end;

    local procedure OnBeforeMakeOrderQuote(var Rec: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
        lText001: Label '"%1" %2 on "%3" does not match "%1" %4 on "%5".';
    begin
        recSalesLine.SetRange("Document Type", Rec."Document Type");
        recSalesLine.SetRange("Document No.", Rec."No.");
        recSalesLine.SetRange(Type, recSalesLine.Type::Item);
        recSalesLine.SetFilter("Location Code", '%1', '');
        if recSalesLine.FindSet() then begin
            repeat
                recSalesLine.Validate("Location Code", Rec."Location Code");
                recSalesLine.Modify(true);
            until recSalesLine.Next() = 0;
            Commit();
        end;
    end;

    local procedure OnAfterMakeOrderQuote(var Rec: Record "Sales Header")
    var
        recSalesOrderHeader: Record "Sales Header";
        recSalesOrderLine: Record "Sales Line";
        recItem: Record Item;
        QuantityDeleted: Integer;
        lText001: Label '%1 line(s) has not been transferred to the order because the item has reached the "End of Life Date".';
        lText002: Label 'The item no. "%1" has "End of Life Date" %2, and the quantity is less than ordered.\Please review the item on the sales order.';
    begin
        recSalesOrderHeader.SetRange("Quote No.", Rec."No.");
        if recSalesOrderHeader.FindFirst() then begin
            if recSalesOrderHeader."Sales Order Type" = recSalesOrderHeader."sales order type"::EICard then
                Eicard_UpdateCustomerNo(recSalesOrderHeader);

            recSalesOrderLine.SetRange("Document Type", recSalesOrderHeader."Document Type");
            recSalesOrderLine.SetRange("Document No.", recSalesOrderHeader."No.");
            recSalesOrderLine.SetRange(Type, recSalesOrderLine.Type::Item);
            recSalesOrderLine.SetFilter("End of Life Date", '>%1&<%2', 0D, WorkDate);
            if recSalesOrderLine.FindSet(true) then
                repeat
                    recItem.SetRange("Location Filter", recSalesOrderHeader."Location Code");
                    recItem.SetAutoCalcFields(Inventory);
                    recItem.Get(recSalesOrderLine."No.");
                    if recItem.Inventory = 0 then begin
                        recSalesOrderLine.Delete(true);
                        QuantityDeleted += 1;
                    end else
                        if recItem.Inventory < recSalesOrderLine.Quantity then
                            Message(lText002, recSalesOrderLine."No.", recItem."End of Life Date");
                until recSalesOrderLine.Next() = 0;

            if QuantityDeleted > 0 then begin
                Commit();
                Message(lText001, QuantityDeleted);
            end;

            Page.Run(Page::"Sales Order", recSalesOrderHeader);
        end;
    end;

    [EventSubscriber(Objecttype::Page, 507, 'OnAfterActionEvent', 'MakeOrder', false, false)]
    local procedure OnAfterMateOrder_Page507(var Rec: Record "Sales Header")
    begin
        OnAfterMakeOrderBlanket(Rec);  // 03-05-21 ZY-LD 084
    end;

    [EventSubscriber(Objecttype::Page, 9303, 'OnAfterActionEvent', 'Make &Order', false, false)]
    local procedure OnAfterMakeOrder_Page9303(var Rec: Record "Sales Header")
    begin
        OnAfterMakeOrderBlanket(Rec);  // 03-05-21 ZY-LD 084
    end;

    local procedure OnAfterMakeOrderBlanket(var Rec: Record "Sales Header")
    var
        recSalesHead: Record "Sales Header";
        recSalesHead2: Record "Sales Header";
        recLocation: Record Location;
        EnterSelectedFields: Page "Enter Selected Fields";
    begin
        //>> 03-05-21 ZY-LD 084
        recSalesHead.SetRange("Blanket Order No.", Rec."No.");
        recSalesHead.SetRange("Order Date", Today);
        if recSalesHead.FindLast() then begin
            Page.Run(Page::"Sales Order", recSalesHead);

            EnterSelectedFields.SetSalesHeader(Rec);
            EnterSelectedFields.RunModal;
            EnterSelectedFields.GetSalesHeader(recSalesHead2);
            if recSalesHead."Sales Order Type" = recSalesHead2."sales order type"::" " then begin
                recLocation.Get(recSalesHead2."Location Code");
                recSalesHead."Sales Order Type" := recLocation."Sales Order Type";
            end;
            if (recSalesHead."Location Code" <> recSalesHead2."Location Code") and (recSalesHead2."Location Code" <> '') then
                recSalesHead.Validate("Location Code", recSalesHead2."Location Code");
            if (recSalesHead."External Document No." <> recSalesHead."External Document No.") and (recSalesHead2."External Document No." <> '') then
                recSalesHead.Validate("External Document No.", recSalesHead2."External Document No.");
            if (recSalesHead."Ship-to Code" <> recSalesHead2."Ship-to Code") and (recSalesHead2."Ship-to Code" <> '') then
                recSalesHead.Validate("Ship-to Code", recSalesHead2."Ship-to Code");
            if (recSalesHead."Backlog Comment" <> recSalesHead2."Backlog Comment") and (recSalesHead2."Backlog Comment" <> recSalesHead2."backlog comment"::" ") then
                recSalesHead.Validate("Backlog Comment", recSalesHead2."Backlog Comment");
            recSalesHead.Modify(true);
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnBeforeInsertWarehouseShipmentHeader(var Rec: Record "Warehouse Shipment Header"; RunTrigger: Boolean)
    begin
        begin
            Rec."Shipment Date" := 0D;
            Rec.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertWarehouseShipmentLine(var Rec: Record "Warehouse Shipment Line"; RunTrigger: Boolean)
    begin
        if not Rec.IsTemporary then
            Rec.Validate(Rec."Qty. to Ship", 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", OnAfterInsertSalesOrderHeader, '', false, false)]
    local procedure OnAfterInsertHeaderAndBeforeInsertLines(var SalesOrderHeader: Record "Sales Header")
    begin

        if not SalesOrderHeader."Send Mail" then begin
            SalesOrderHeader.Validate(SalesOrderHeader."Send Mail");
            SalesOrderHeader.Modify(true);
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeTransferQuoteLineToOrderLineLoop', '', false, false)]
    local procedure OnAfterTransferQuoteToSalesOrderLine(var SalesQuoteLine: Record "Sales Line"; var IsHandled: Boolean)
    var
        recItem: Record Item;
        lText001: Label '"%1" is "%2".\The item is not transferred to the sales order.';
    begin

        recItem.Get(SalesQuoteLine."No.");
        if recItem."Block on Sales Order" then begin
            Message(lText001, SalesQuoteLine."No.", recItem.FieldCaption("Block on Sales Order"));
            IsHandled := true;
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Comment Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertSalesCommentLine(var Rec: Record "Sales Comment Line"; RunTrigger: Boolean)
    begin
        Rec."User Id" := UserId();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Purch. Order to Order", 'OnRunOnAfterPurchBlanketOrderLineSetFilters', '', false, false)]
    local procedure BlanketPurchOrdertoOrder_OnRunOnAfterPurchBlanketOrderLineSetFilters(var PurchBlanketOrderLine: Record "Purchase Line")
    begin

        PurchBlanketOrderLine.SetFilter("Qty. to Receive", '<>%1', 0);

    end;

    [EventSubscriber(ObjectType::Report, Report::"Combine Return Receipts", 'OnBeforeValidateCustomerNoFromOrder', '', false, false)]
    local procedure CombineReturnReceipts_OnBeforeValidateCustomerNoFromOrder(var SalesHeader: Record "Sales Header"; SalesOrderHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        SalesHeader.Validate("Sell-to Customer No.", SalesOrderHeader."Sell-to Customer No.");
        if SalesHeader."Bill-to Customer No." <> SalesHeader."Sell-to Customer No." then
            SalesHeader.Validate("Bill-to Customer No.", SalesOrderHeader."Bill-to Customer No.");
        IsHandled := true;
    end;

    //>> Copy Document
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeCopySalesDocument', '', false, false)]
    local procedure OnBeforeCopySalesDocument()
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetSkipAddPostGrpPrLocation := true;
        SI.SetHideSalesDialog := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesDocument', '', false, false)]
    local procedure OnAfterCopySalesDocument()
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetSkipAddPostGrpPrLocation := false;
        SI.SetHideSalesDialog := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeCopySalesHeaderFromPostedInvoice', '', false, false)]
    local procedure CopyDocumentMgt_OnBeforeCopySalesHeaderFromPostedInvoice(var ToSalesHeader: Record "Sales Header"; SalesInvoiceHeader: Record "Sales Invoice Header"; var IsHandled: Boolean);
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetHideSalesDialog(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopySalesDocOnAfterTransferPostedInvoiceFields', '', false, false)]
    local procedure CopyDocumentMgt_OnCopySalesDocOnAfterTransferPostedInvoiceFields(var ToSalesHeader: Record "Sales Header"; SalesInvoiceHeader: Record "Sales Invoice Header"; OldSalesHeader: Record "Sales Header")
    var
        SI: Codeunit "Single Instance";
    begin
        SI.SetHideSalesDialog(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeCheckCreditLimit', '', false, false)]
    local procedure CopyDocumentMgt_OnBeforeCheckCreditLimit(var FromSalesHeader: Record "Sales Header"; var ToSalesHeader: Record "Sales Header"; FromDocType: Enum "Sales Document Type From"; var IsHandled: Boolean)
    begin
        if FromDocType in ["Sales Document Type From"::Quote,
                        "Sales Document Type From"::"Blanket Order",
                        "Sales Document Type From"::Order,
                        "Sales Document Type From"::Invoice,
                        "Sales Document Type From"::"Return Order",
                        "Sales Document Type From"::"Credit Memo"] then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeUpdateCustLedgEntry', '', false, false)]
    local procedure CopyDocumentMgt_OnBeforeUpdateCustLedgEntry(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesLineFromSalesDocSalesLine', '', false, false)]
    local procedure CopyDocumentMgt_OnAfterCopySalesLineFromSalesDocSalesLine(var ToSalesLine: Record "Sales Line")
    begin
        ResetSaleLineFieldsAfterCopy(ToSalesLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesLineFromSalesLineBuffer', '', false, false)]
    local procedure CopyDocumentMgt_OnAfterCopySalesLineFromSalesLineBuffer(var ToSalesLine: Record "Sales Line")
    begin
        ResetSaleLineFieldsAfterCopy(ToSalesLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesLineFromSalesCrMemoLineBuffer', '', false, false)]
    local procedure CopyDocumentMgt_OnAfterCopySalesLineFromSalesCrMemoLineBuffer(var ToSalesLine: Record "Sales Line")
    begin
        ResetSaleLineFieldsAfterCopy(ToSalesLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesLineFromSalesShptLineBuffer', '', false, false)]
    local procedure CopyDocumentMgt_OnAfterCopySalesLineFromSalesShptLineBuffer(var ToSalesLine: Record "Sales Line")
    begin
        ResetSaleLineFieldsAfterCopy(ToSalesLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesLineFromReturnRcptLineBuffer', '', false, false)]
    local procedure CopyDocumentMgt_OnAfterCopySalesLineFromReturnRcptLineBuffer(var ToSalesLine: Record "Sales Line")
    begin
        ResetSaleLineFieldsAfterCopy(ToSalesLine);
    end;

    local procedure ResetSaleLineFieldsAfterCopy(var ToSalesLine: Record "Sales Line")
    begin
        ToSalesLine."Delivery Document No." := '';
        ToSalesLine.Status := ToSalesLine.Status::Open;
        ToSalesLine."Shipment Date Confirmed" := false;
        ToSalesLine."Warehouse Status" := ToSalesLine."Warehouse Status"::New;
        ToSalesLine."Lock by Ref Document" := false;
        ToSalesLine."Picking List No." := '';
        ToSalesLine.Modify();
    end;
    //<< Copy Document

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Shipment", 'OnRunAfterFilterSalesShpLine', '', false, false)]
    local procedure SalesGetShipment_OnRunAfterFilterSalesShpLine(var SalesShptLine: Record "Sales Shipment Line"; SalesHeader: Record "Sales Header")
    var
        SalesShptHeader2: Record "Sales Shipment Header";
        ModifyLine: Boolean;
        ModifyHead: Boolean;
    begin
        //Tectura Taiwan ZL100526A+
        if (SalesHeader."Sales Order Type" <> 0) then begin
            SalesShptLine.SetFilter("Sales Order Type", '%1', SalesHeader."Sales Order Type");
        end;
        if (SalesHeader."Location Code" <> '') then begin
            SalesShptLine.SetFilter("Location Code", '%1', SalesHeader."Location Code");
        end;
        if (SalesHeader."Sell-to Customer No." <> '') then begin
            SalesShptLine.SetFilter("Sell-to Customer No.", '%1', SalesHeader."Sell-to Customer No.");
        end;
        if (SalesHeader."Ship-to Code" <> '') then begin
            SalesShptLine.SetFilter("Ship-to Code", '%1', SalesHeader."Ship-to Code");
        end;
        //Tectura Taiwan ZL100526A-

        SalesShptLine.SetFilter("Currency Code", '%1|%2', SalesHeader."Currency Code", '');

        if SalesShptLine.FindSet(true) then begin
            SalesShptHeader2.Get(SalesShptLine."Document No.");
            if SalesShptHeader2."Bill-to Customer No." <> SalesHeader."Bill-to Customer No." then begin
                SalesShptHeader2."Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
                ModifyHead := true;
            end;
            if (SalesShptHeader2."Currency Code" = '') and
               (SalesShptHeader2."Currency Code" <> SalesHeader."Currency Code")
            then begin
                SalesShptHeader2."Currency Code" := SalesHeader."Currency Code";
                ModifyHead := true;
            end;
            if ModifyHead then
                SalesShptHeader2.Modify(False);

            SalesShptLine.SetRange("Currency Code", SalesHeader."Currency Code");
            SalesShptLine.FindSet(true);

            repeat
                if SalesShptLine."Bill-to Customer No." <> SalesHeader."Bill-to Customer No." then begin
                    SalesShptLine."Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
                    ModifyLine := true;
                end;
                if SalesShptLine."Gen. Bus. Posting Group" <> SalesHeader."Gen. Bus. Posting Group" then begin
                    SalesShptLine."Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
                    ModifyLine := true;
                end;
                if SalesShptLine."VAT Bus. Posting Group" <> SalesHeader."VAT Bus. Posting Group" then begin
                    SalesShptLine."VAT Bus. Posting Group" := SalesHeader."VAT Bus. Posting Group";
                    ModifyLine := true;
                end;
                if ModifyLine then
                    SalesShptLine.Modify(false);
                ModifyLine := false;
            until SalesShptLine.Next() = 0;
        end;

        SalesShptLine.SetRange("Currency Code", SalesHeader."Currency Code");
        SalesShptLine.SetRange("Bill-to Customer No.", SalesHeader."Bill-to Customer No.");
        Commit();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Line - Price", 'OnAfterAddSources', '', false, false)]
    local procedure OnAfterAddSources(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; PriceType: Enum "Price Type"; var PriceSourceList: Codeunit "Price Source List")
    var
        SI: codeunit "Single Instance";
    begin
        if not SI.GetUseBillToCustomer() then
            if PriceType = PriceType::Sale then begin
                PriceSourceList.Init();
                PriceSourceList.Add("Price Source Type"::Customer, SalesHeader."Sell-to Customer No.");
                PriceSourceList.Add("Price Source Type"::Contact, SalesHeader."Sell-to Contact No.");
                PriceSourceList.Add("Price Source Type"::"Customer Price Group", SalesLine."Customer Price Group");
                PriceSourceList.Add("Price Source Type"::"Customer Disc. Group", SalesLine."Customer Disc. Group");
                PriceSourceList.Add("Price Source Type"::"All Customers");
                PriceSourceList.Add("Price Source Type"::Campaign, SalesHeader."Campaign No.");
                AddActivatedCampaignsAsSource(PriceSourceList);
                PriceSourceList.AddJobAsSources(SalesLine."Job No.", SalesLine."Job Task No.");
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Line - Price", 'OnAfterGetDocumentDate', '', false, false)]
    local procedure SalesLinePrice_OnAfterGetDocumentDate(var DocumentDate: Date; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line")
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        case SalesSetup."Calc. Sales Price Based on" of
            SalesSetup."Calc. Sales Price Based on"::"Requested Delivery Date":
                begin
                    if SalesLine."Requested Delivery Date" <> 0D then
                        DocumentDate := SalesLine."Requested Delivery Date"
                    else
                        if SalesHeader."Requested Delivery Date" <> 0D then
                            DocumentDate := SalesHeader."Requested Delivery Date";
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnUpdateUnitPriceByFieldOnAfterFindPrice', '', false, false)]
    local procedure SalesLine_OnUpdateUnitPriceByFieldOnAfterFindPrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CallingFieldNo: Integer)
    var
        SI: codeunit "Single Instance";
        PriceCalculation: interface "Price Calculation";
        LineWithPrice: interface "Line With Price";
        PriceType: enum "Price Type";
    begin
        SI.SetUseBillToCustomer(true);
        SalesLine.GetPriceCalculationHandler(PriceType::Sale, SalesHeader, PriceCalculation);
        PriceCalculation.ApplyDiscount();
        SI.SetUseBillToCustomer(false);
    end;


    procedure AddActivatedCampaignsAsSource(var PriceSourceList: Codeunit "Price Source List")
    var
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
        SourceType: Enum "Price Source Type";
    begin
        if FindActivatedCampaign(TempTargetCampaignGr, PriceSourceList) then
            repeat
                PriceSourceList.Add(SourceType::Campaign, TempTargetCampaignGr."Campaign No.");
            until TempTargetCampaignGr.Next() = 0;
    end;

    local procedure FindActivatedCampaign(var TempCampaignTargetGr: Record "Campaign Target Group" temporary; var PriceSourceList: Codeunit "Price Source List"): Boolean
    var
        PriceSourceType: Enum "Price Source Type";
    begin
        TempCampaignTargetGr.Reset();
        TempCampaignTargetGr.DeleteAll();

        if PriceSourceList.GetValue(PriceSourceType::Campaign) = '' then
            if not FindCustomerCampaigns(PriceSourceList.GetValue(PriceSourceType::Customer), TempCampaignTargetGr) then
                FindContactCompanyCampaigns(PriceSourceList.GetValue(PriceSourceType::Contact), TempCampaignTargetGr);

        exit(TempCampaignTargetGr.FindFirst());
    end;

    local procedure FindCustomerCampaigns(CustomerNo: Code[20]; var TempCampaignTargetGr: Record "Campaign Target Group" temporary) Found: Boolean;
    var
        CampaignTargetGr: Record "Campaign Target Group";
    begin
        CampaignTargetGr.SetRange(Type, CampaignTargetGr.Type::Customer);
        CampaignTargetGr.SetRange("No.", CustomerNo);
        Found := CampaignTargetGr.CopyTo(TempCampaignTargetGr);
    end;

    local procedure FindContactCompanyCampaigns(ContactNo: Code[20]; var TempCampaignTargetGr: Record "Campaign Target Group" temporary) Found: Boolean
    var
        CampaignTargetGr: Record "Campaign Target Group";
        Contact: Record Contact;
    begin
        if Contact.Get(ContactNo) then begin
            CampaignTargetGr.SetRange(Type, CampaignTargetGr.Type::Contact);
            CampaignTargetGr.SetRange("No.", Contact."Company No.");
            Found := CampaignTargetGr.CopyTo(TempCampaignTargetGr);
        end;
    end;

    // V26>>
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Validate Source Line", 'OnBeforeSalesLineVerifyChange', '', false, false)]
    // local procedure OnBeforeSalesLineVerifyChange(var NewSalesLine: Record "Sales Line"; var OldSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    // var
    //     SI: Codeunit "Single Instance";
    // begin

    //     if SI.GetValidateFromPage then
    //         IsHandled := true;

    // end;
    // V26<<

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnSetShipToCustomerAddressFieldsFromShipToAddrOnAfterCalcShouldCopyLocationCode, '', false, false)]
    local procedure "Sales Header_OnSetShipToCustomerAddressFieldsFromShipToAddrOnAfterCalcShouldCopyLocationCode"(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; ShipToAddress: Record "Ship-to Address"; var ShouldCopyLocationCode: Boolean)
    var
        ShipLocation: Record Location;
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        // 15-05-2025 BK #493054
        IF ZGT.IsZComCompany() then Begin
            IF ShouldCopyLocationCode then begin
                IF ShipToAddress."Location Code" <> '' then
                    ShipLocation.get(ShipToAddress."Location Code");
                IF (ShipLocation."Sales Order Type" <> SalesHeader."Sales Order Type") then
                    ShouldCopyLocationCode := false;
            end;
        End;
        // 15-05-2025 BK #493054
    end;

}
