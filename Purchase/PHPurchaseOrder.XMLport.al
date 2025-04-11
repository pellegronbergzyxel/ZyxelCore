xmlport 50009 "PH Purchase Order"
{
    // 001. 26-11-20 ZY-LD 2020111910000165 - Validate on Contact No. instead of customer no.
    // 002. 15-12-20 ZY-LD 000 - Email is added.
    // 003. 24-03-21 ZY-LD 2021032410000071 - Item No. is changed from field reference to text, because the length sometimes exseeds 20.
    // 004. 21-04-21 ZY-LD 2021042010000147 - It seems that the filename we receive is not unique, and that makes errors when we download.
    // 005. 26-07-21 ZY-LD 000 - Some customers does not send all 20 characters.
    // 006. 14-09-21 ZY-LD 2021091410000051 - Bad characters in front of the itemno.
    // 007. 08-11-21 ZY-LD 2021110810000111 - We have seen a customer combining ZNet and ZCom licenses on one order.

    DefaultNamespace = 'urn:microsoft-dynamics-nav/purchaseorder';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Sales Header"; "Sales Header")
            {
                MinOccurs = Zero;
                XmlName = 'PurchaseOrder';
                UseTemporary = true;
                textelement(Id)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        InsertComment("Sales Header"."No.", 0, 'Id', Id);
                    end;
                }
                textelement(DocumentId)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DocumentId := "Sales Header"."No.";
                    end;

                    trigger OnAfterAssignVariable()
                    begin
                        InsertComment("Sales Header"."No.", 0, 'DocumentId', DocumentId);
                    end;
                }
                textelement(RemoteId)
                {
                }
                textelement(FileName)
                {

                    trigger OnBeforePassVariable()
                    begin
                        FileName := 'PhasesOrderContent.xml';
                    end;

                    trigger OnAfterAssignVariable()
                    begin
                        InsertComment("Sales Header"."No.", 0, 'FileName', FileName);
                    end;
                }
                textelement(FileURL)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        InsertComment("Sales Header"."No.", 0, 'FileURL', FileURL);
                    end;
                }
                textelement(MediaLink)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        InsertComment("Sales Header"."No.", 0, 'MediaLink', MediaLink);
                    end;
                }
                textelement(MediaLinkOriginal)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        InsertComment("Sales Header"."No.", 0, 'MediaLinkOriginal', MediaLinkOriginal);
                    end;
                }
                textelement(MediaLinkData)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        InsertComment("Sales Header"."No.", 0, 'MediaLinkData', MediaLinkData);
                    end;
                }
                textelement(UploadedAt)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        InsertComment("Sales Header"."No.", 0, 'UploadedAt', UploadedAt);
                    end;
                }
                textelement(ProcessedAt)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        InsertComment("Sales Header"."No.", 0, 'ProcessedAt', ProcessedAt);
                    end;
                }
                textelement(PoNumber)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PoNumber := "Sales Header"."External Document No.";
                    end;

                    trigger OnAfterAssignVariable()
                    begin
                        "Sales Header"."External Document No." := PoNumber;
                        InsertComment("Sales Header"."No.", 0, 'PoNumber', PoNumber);
                    end;
                }
                textelement(PoDate)
                {
                    textelement(Match)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            InsertComment("Sales Header"."No.", 0, 'Match', Match);
                        end;
                    }
                    textelement(ISO8601)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            InsertComment("Sales Header"."No.", 0, 'ISO8601', ISO8601);
                        end;
                    }
                    textelement(Text)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            InsertComment("Sales Header"."No.", 0, 'Text', Text);
                        end;
                    }
                }
                textelement(BuyerName)
                {

                    trigger OnBeforePassVariable()
                    begin
                        BuyerName := "Sales Header"."Sell-to Customer Name";
                    end;

                    trigger OnAfterAssignVariable()
                    begin
                        "Sales Header"."Sell-to Customer Name" := CopyStr(BuyerName, 1, MaxStrLen("Sales Header"."Sell-to Customer Name"));
                        InsertComment("Sales Header"."No.", 0, 'BuyerName', BuyerName);
                    end;
                }
                textelement(TermDays)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        InsertComment("Sales Header"."No.", 0, 'TermDays', TermDays);
                    end;
                }
                textelement(ShippingAddress)
                {
                    textelement(StreetNumber)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            InsertComment("Sales Header"."No.", 0, 'StreetNumber', StreetNumber);
                        end;
                    }
                    textelement(Street)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            InsertComment("Sales Header"."No.", 0, 'Street', Street);
                        end;
                    }
                    textelement(City)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            "Sales Header"."Ship-to City" := CopyStr(City, 1, MaxStrLen("Sales Header"."Ship-to City"));
                            InsertComment("Sales Header"."No.", 0, 'City', City);
                        end;
                    }
                    textelement(AdministrativeArea)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            "Sales Header"."Ship-to County" := CopyStr(AdministrativeArea, 1, MaxStrLen("Sales Header"."Ship-to County"));
                            InsertComment("Sales Header"."No.", 0, 'AdministrativeArea', AdministrativeArea);
                        end;
                    }
                    textelement(ZipCode)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            "Sales Header"."Ship-to Post Code" := CopyStr(ZipCode, 1, MaxStrLen("Sales Header"."Ship-to Post Code"));
                            InsertComment("Sales Header"."No.", 0, 'ZipCode', ZipCode);
                        end;
                    }
                    textelement(Country)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            recCountry.SetRange(Name, Country);
                            if not recCountry.FindFirst() then
                                Clear(recCountry);
                            "Sales Header"."Ship-to Country/Region Code" := recCountry.Code;
                            InsertComment("Sales Header"."No.", 0, 'Country', Country);
                        end;
                    }
                    textelement(DeliveryLine1)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            "Sales Header"."Ship-to Name" := CopyStr(DeliveryLine1, 1, MaxStrLen("Sales Header"."Ship-to Name"));
                            InsertComment("Sales Header"."No.", 0, 'DeliveryLine1', DeliveryLine1);
                        end;
                    }
                    textelement(DeliveryLine2)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            "Sales Header"."Ship-to Address" := CopyStr(DeliveryLine2, 1, MaxStrLen("Sales Header"."Ship-to Address"));
                            InsertComment("Sales Header"."No.", 0, 'DeliveryLine2', DeliveryLine2);
                        end;
                    }
                    textelement(DeliveryLine3)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            "Sales Header"."Ship-to Address 2" := CopyStr(DeliveryLine3, 1, MaxStrLen("Sales Header"."Ship-to Address 2"));
                            ;
                            InsertComment("Sales Header"."No.", 0, 'DeliveryLine3', DeliveryLine3);
                        end;
                    }
                    textelement(VerificationStatus)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            InsertComment("Sales Header"."No.", 0, 'VerificationStatus', VerificationStatus);
                        end;
                    }
                    textelement(Email)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            //>> 15-12-20 ZY-LD 002
                            "Sales Header"."EiCard To Email 1" := CopyStr(Email, 1, MaxStrLen("Sales Header"."EiCard To Email 1"));
                            InsertComment("Sales Header"."No.", 0, 'Email', Email);
                            //<< 15-12-20 ZY-LD 002
                        end;
                    }
                }
                tableelement("Sales Line"; "Sales Line")
                {
                    MinOccurs = Zero;
                    XmlName = 'Line';
                    UseTemporary = true;
                    textelement(ItemId)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            InsertComment("Sales Header"."No.", "Sales Line"."Line No.", 'ItemId', ItemId);
                        end;
                    }
                    textelement(ItemNo)
                    {

                        trigger OnAfterAssignVariable()
                        var
                            recItem: Record Item;
                            recItemIdentifier: Record "Item Identifier";
                            InvestigateIdentifier: Boolean;
                        begin
                            //>> 14-09-21 ZY-LD 006
                            if CopyStr(ItemNo, 1, 4) = 'NMS ' then
                                ItemNo := CopyStr(ItemNo, 5, StrLen(ItemNo));
                            //<< 14-09-21 ZY-LD 006

                            ItemNo := DelChr(ItemNo, '=', ' ');
                            if StrLen(ItemNo) > MaxStrLen(recItem."No.") then
                                InvestigateIdentifier := true
                            else
                                if not recItem.Get(ItemNo) then
                                    InvestigateIdentifier := true;

                            if InvestigateIdentifier then begin
                                recItemIdentifier.SetRange(ExtendedCodeZX, ItemNo);
                                if recItemIdentifier.FindFirst() then
                                    ItemNo := recItemIdentifier."Item No.";
                            end;
                            "Sales Line"."No." := CopyStr(ItemNo, 1, MaxStrLen("Sales Line"."No."));
                            InsertComment("Sales Header"."No.", "Sales Line"."Line No.", 'ItemNo', "Sales Line"."No.");
                        end;
                    }
                    textelement(Description)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            InsertComment("Sales Header"."No.", "Sales Line"."Line No.", 'Description', Description);
                        end;
                    }
                    fieldelement(Quantity; "Sales Line".Quantity)
                    {
                        FieldValidate = no;

                        trigger OnAfterAssignField()
                        begin
                            InsertComment("Sales Header"."No.", "Sales Line"."Line No.", 'Quantity', Format("Sales Line".Quantity));
                        end;
                    }
                    textelement(Unit)
                    {

                        trigger OnAfterAssignVariable()
                        begin
                            InsertComment("Sales Header"."No.", "Sales Line"."Line No.", 'Unit', Unit);
                        end;
                    }
                    fieldelement(UnitPrice; "Sales Line"."Unit Price")
                    {
                        FieldValidate = no;

                        trigger OnAfterAssignField()
                        begin
                            InsertComment("Sales Header"."No.", "Sales Line"."Line No.", 'UnitPrice', Format("Sales Line"."Unit Price"));
                        end;
                    }
                    fieldelement(Net; "Sales Line".Amount)
                    {
                        FieldValidate = no;

                        trigger OnAfterAssignField()
                        begin
                            InsertComment("Sales Header"."No.", "Sales Line"."Line No.", 'Net', Format("Sales Line".Amount));
                        end;
                    }

                    trigger OnAfterInitRecord()
                    begin
                        CommentLineNo := 0;
                        SalesLineNo += 10000;
                        "Sales Line"."Document No." := "Sales Header"."No.";
                        "Sales Line"."Line No." := SalesLineNo;
                    end;
                }

                trigger OnAfterInitRecord()
                begin
                    if DocId = '' then
                        DocId := '1'
                    else
                        DocId := IncStr(DocId);
                    "Sales Header"."No." := DocId;

                    CommentLineNo := 0;
                    SalesLineNo := 0;
                    recSalesComTmp.Reset();
                    recSalesComTmp.DeleteAll();
                end;

                trigger OnBeforeInsertRecord()
                begin
                    if "Sales Header"."No." = '' then
                        Error(Text001, 'PurchaseOrder/No');
                end;
            }
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

    var
        Text001: Label '%1 must not be blank.';
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesComTmp: Record "Sales Comment Line" temporary;
        recSalesCom: Record "Sales Comment Line";
        recCountry: Record "Country/Region";
        CommentLineNo: Integer;
        SalesLineNo: Integer;
        DocId: Code[20];


    procedure InsertData()
    var
        recItem: Record Item;
        FtpMgt: Codeunit "VisionFTP Management";
        LinkText: Text;
        ItemNoFilter: Text;
        CreateEicardOrderZNet: Boolean;
        CreateEicardOrderZCom: Boolean;
        CreateEicardOrderBlank: Boolean;
        CreateNormalOrder: Boolean;
        SBUCompany: Option " ","ZCom HQ","ZNet HQ";
    begin
        if "Sales Header".FindSet() then
            repeat
                if FileName <> '' then
                    LinkText := FtpMgt.DownloadAndRenameFile('PHASES', FileName, '', true);  // 21-04-21 ZY-LD 004

                CreateEicardOrderZNet := false;
                CreateEicardOrderZCom := false;  // 08-11-21 ZY-LD 007
                CreateEicardOrderBlank := false;  // 08-11-21 ZY-LD 007
                CreateNormalOrder := false;
                "Sales Line".SetRange("Document No.", "Sales Header"."No.");
                if "Sales Line".FindFirst() then
                    repeat
                        //>> 21-12-20 ZY-LD 003
                        //IF recItem.GET("Sales Line"."No.") AND (recItem.IsEICard OR recItem."Non ZyXEL License") THEN
                        ItemNoFilter := StrSubstNo('%1*', "Sales Line"."No.");
                        recItem.SetFilter("No.", ItemNoFilter);
                        if recItem.FindFirst() and  //<< 21-12-20 ZY-LD 003
                          (recItem.IsEICard or recItem."Non ZyXEL License")
                        then begin
                            //>> 08-11-21 ZY-LD 007
                            //CreateEicardOrder := TRUE
                            case recItem."SBU Company" of
                                recItem."sbu company"::" ":
                                    CreateEicardOrderBlank := true;
                                recItem."sbu company"::"ZNet HQ":
                                    CreateEicardOrderZNet := true;
                                recItem."sbu company"::"ZCom HQ":
                                    CreateEicardOrderZCom := true;
                            end;
                            //<< 08-11-21 ZY-LD 007
                        end else
                            CreateNormalOrder := true;
                    until ("Sales Line".Next() = 0) or (CreateEicardOrderZNet and CreateEicardOrderZCom and CreateNormalOrder);

                if CreateNormalOrder then
                    InsertSalesQuote("Sales Header"."sales order type"::Normal, LinkText, Sbucompany::" ");
                if CreateEicardOrderZNet then
                    InsertSalesQuote("Sales Header"."sales order type"::EICard, LinkText, Sbucompany::"ZNet HQ");
                //>> 08-11-21 ZY-LD 007
                if CreateEicardOrderZCom then
                    InsertSalesQuote("Sales Header"."sales order type"::EICard, LinkText, Sbucompany::"ZCom HQ");
                if CreateEicardOrderBlank then
                    InsertSalesQuote("Sales Header"."sales order type"::EICard, LinkText, Sbucompany::" ");
            //<< 08-11-21 ZY-LD 007
            until "Sales Header".Next() = 0;
    end;

    local procedure InsertSalesQuote(pSalesOrderType: Option " ",Normal,EICard,"Drop Shipment",Other,"Spec. Order","G/L Account"; pLinkText: Text; pSBUCompany: Option " ","ZCom HQ","ZNet HQ")
    var
        recCont: Record Contact;
        recCust: Record Customer;
        recMktSetup: Record "Marketing Setup";
        recItem: Record Item;
        recItem2: Record Item;
        recLink: Record "Record Link";
        recContBusRel: Record "Contact Business Relation";
        recShiptoAdd: Record "Ship-to Address";
        LineNo: Integer;
        ItemFound: Boolean;
        ItemIsEicard: Boolean;
        SaveLocation: Code[10];
        SearchName: Code[50];
        ItemNoFilter: Text;
    begin
        Clear(recSalesHead);
        recSalesHead.Init();
        recSalesHead.Validate("Document Type", recSalesHead."document type"::Quote);
        recSalesHead.Insert(true);

        recSalesHead.Validate("Sales Order Type", pSalesOrderType);
        if pSalesOrderType = Psalesordertype::EICard then
            recSalesHead.Validate("Eicard Type", recSalesHead."eicard type"::Normal);
        SaveLocation := recSalesHead."Location Code";

        recCont.SetRange(Type, recCont.Type::Person);
        recCont.SetRange(Name, "Sales Header"."Sell-to Customer Name");
        if ("Sales Header"."Sell-to Customer Name" <> '') and recCont.FindFirst() then begin
            recMktSetup.Get();
            if (recCont."Company No." <> '') and
                ((recContBusRel.Get(recCont."Company No.", recMktSetup."Bus. Rel. Code for Customers")) and (recContBusRel."No." <> ''))
            then begin
                //recSalesHead.VALIDATE("Sell-to Customer No.",recContBusRel."No.")  // 26-11-20 ZY-LD 001
                recSalesHead.Validate("Sell-to Contact No.", recCont."No.");  // 26-11-20 ZY-LD 001
            end else begin
                recSalesHead."Sell-to Contact No." := recCont."No.";
                recSalesHead.Validate("Sell-to Customer Templ. Code", GetTemplateCode("Sales Header"."Sell-to Country/Region Code"));
            end;
        end else begin
            Clear(recCont);
            recCont.Init();
            recCont.Type := recCont.Type::Person;
            recCont.Insert(true);

            recCont.Name := "Sales Header"."Sell-to Customer Name";
            recCont."Name 2" := "Sales Header"."Sell-to Customer Name 2";
            recCont.Address := "Sales Header"."Sell-to Address";
            recCont."Address 2" := "Sales Header"."Sell-to Address 2";
            recCont."Post Code" := "Sales Header"."Sell-to Post Code";
            recCont.City := "Sales Header"."Sell-to City";
            recCont."Country/Region Code" := "Sales Header"."Sell-to Country/Region Code";
            recCont.Modify(true);

            recSalesHead."Sell-to Contact No." := recCont."No.";
            recSalesHead.Validate("Sell-to Customer Templ. Code", GetTemplateCode("Sales Header"."Sell-to Country/Region Code"));
        end;
        recSalesHead.Validate("Location Code", SaveLocation);

        recShiptoAdd.Reset();
        case recSalesHead."Sales Order Type" of
            recSalesHead."sales order type"::EICard:
                begin
                    if recSalesHead."Sell-to Customer No." <> '' then begin
                        if not recShiptoAdd.Get(recSalesHead."Sell-to Customer No.", recSalesHead."Location Code") then begin
                            recShiptoAdd.Init();
                            recShiptoAdd.Validate("Customer No.", recSalesHead."Sell-to Customer No.");
                            recShiptoAdd.Validate(Code, recSalesHead."Location Code");
                            recShiptoAdd.Validate("Location Code", recSalesHead."Location Code");
                            recShiptoAdd.Validate("Shipment Method Code", 'MAIL');

                            recCust.Get(recSalesHead."Sell-to Customer No.");
                            recShiptoAdd.Name := recCust.Name;
                            recShiptoAdd."Name 2" := recCust."Name 2";
                            recShiptoAdd.Address := recCust.Address;
                            recShiptoAdd."Address 2" := recCust."Address 2";
                            recShiptoAdd."Post Code" := recCust."Post Code";
                            recShiptoAdd.City := recCust.City;
                            recShiptoAdd."Country/Region Code" := recCust."Country/Region Code";
                            recShiptoAdd.Insert(true);
                        end;
                        recSalesHead.Validate("Ship-to Code", recShiptoAdd.Code);
                    end;
                end;
            recSalesHead."sales order type"::Normal:
                begin
                    if "Sales Header"."Ship-to Name" <> '' then
                        SearchName := "Sales Header"."Ship-to Name"
                    else
                        SearchName := "Sales Header"."Sell-to Customer Name";
                    recShiptoAdd.SetRange("Search Name", SearchName);
                    if recShiptoAdd.FindFirst() and (SearchName <> '') then
                        recSalesHead.Validate("Ship-to Code", recShiptoAdd.Code)
                    else begin
                        recSalesHead."Ship-to Name" := "Sales Header"."Ship-to Name";
                        recSalesHead."Ship-to Name 2" := "Sales Header"."Ship-to Name 2";
                        recSalesHead."Ship-to Address" := "Sales Header"."Ship-to Address";
                        recSalesHead."Ship-to Address 2" := "Sales Header"."Ship-to Address 2";
                        recSalesHead."Ship-to Post Code" := "Sales Header"."Ship-to Post Code";
                        recSalesHead."Ship-to City" := "Sales Header"."Ship-to City";
                        recSalesHead."Ship-to County" := "Sales Header"."Ship-to County";
                        recSalesHead."Ship-to Contact" := "Sales Header"."Ship-to Contact";
                        recSalesHead."Ship-to Country/Region Code" := "Sales Header"."Ship-to Country/Region Code";
                    end;
                end;
        end;

        recSalesHead.Validate("External Document No.", "Sales Header"."External Document No.");
        recSalesHead.Validate("Location Code", SaveLocation);
        recSalesHead.Modify(true);

        recSalesComTmp.SetRange("Document Line No.", 0);
        if recSalesComTmp.FindSet() then
            repeat
                recSalesCom := recSalesComTmp;
                recSalesCom."No." := recSalesHead."No.";
                recSalesCom.Insert();
            until recSalesComTmp.Next() = 0;

        "Sales Line".SetRange("Document No.", "Sales Header"."No.");
        if "Sales Line".FindSet() then begin
            LineNo := 0;
            repeat
                Clear(recItem);
                ItemFound := recItem.Get("Sales Line"."No.") and not recItem.Inactive;

                //>> 21-12-20 ZY-LD 003
                ItemIsEicard := false;
                ItemNoFilter := StrSubstNo('%1*', "Sales Line"."No.");
                recItem2.SetFilter("No.", ItemNoFilter);
                recItem2.SetRange(Inactive, false);  // 26-07-21 ZY-LD 005
                if recItem2.FindFirst() then begin
                    ItemIsEicard := recItem2.IsEICard or recItem2."Non ZyXEL License";
                    //>> 26-07-21 ZY-LD 005
                    if not ItemFound then
                        if recItem2.Count = 1 then begin
                            ItemFound := true;
                            recItem := recItem2;
                        end;
                    //<< 26-07-21 ZY-LD 005
                end;
                //<< 21-12-20 ZY-LD 003

                if ((pSalesOrderType = Psalesordertype::Normal) and (not recItem.IsEICard and not recItem."Non ZyXEL License" and not ItemIsEicard)) or
                   ((pSalesOrderType = Psalesordertype::EICard) and
                    (recItem.IsEICard or recItem."Non ZyXEL License" or ItemIsEicard) and
                    (recItem."SBU Company" = pSBUCompany))  // 08-11-21 ZY-LD 007
                then begin
                    LineNo += 10000;

                    recSalesLine.Validate("Document Type", "Sales Header"."Document Type");
                    recSalesLine.Validate("Document No.", recSalesHead."No.");
                    recSalesLine.Validate("Line No.", LineNo);
                    recSalesLine.Insert(true);

                    recSalesLine.Validate(Type, recSalesLine.Type::Item);
                    if ItemFound then begin
                        //recSalesLine.VALIDATE("No.","Sales Line"."No.");  // 26-07-21 ZY-LD 005
                        recSalesLine.Validate("No.", recItem."No.");  // 26-07-21 ZY-LD 005
                        recSalesLine.Validate(Quantity, "Sales Line".Quantity);
                    end else begin
                        recSalesLine."No." := "Sales Line"."No.";
                        recSalesLine.Quantity := "Sales Line".Quantity;
                    end;
                    recSalesLine.Modify(true);

                    recSalesComTmp.SetRange("Document Line No.", "Sales Line"."Line No.");
                    if recSalesComTmp.FindSet() then
                        repeat
                            recSalesCom := recSalesComTmp;
                            recSalesCom."No." := recSalesHead."No.";
                            recSalesCom."Document Line No." := recSalesLine."Line No.";
                            recSalesCom.Insert();
                        until recSalesComTmp.Next() = 0;
                end;
            until "Sales Line".Next() = 0;
        end;

        if pLinkText <> '' then begin
            Clear(recLink);
            recLink.Init();
            recLink."Record ID" := recSalesHead.RecordId;
            recLink.URL1 := pLinkText;
            recLink.Created := CurrentDatetime;
            recLink."User ID" := UserId();
            recLink.Company := CompanyName();
            recLink.Insert(true);
        end;
    end;

    local procedure InsertComment(pDocNo: Code[50]; pDocLineNo: Integer; pNode: Text; pValue: Text)
    begin
        CommentLineNo += 10000;
        Clear(recSalesComTmp);
        recSalesComTmp.Init();
        recSalesComTmp."Document Type" := recSalesComTmp."document type"::Quote;
        recSalesComTmp."Document Line No." := pDocLineNo;
        recSalesComTmp."No." := pDocNo;
        recSalesComTmp."Line No." := CommentLineNo;
        recSalesComTmp.Date := Today;
        recSalesComTmp.Code := 'QUOTE';
        if StrLen(pNode) + StrLen(pValue) + 2 <= 80 then begin
            recSalesComTmp.Comment := StrSubstNo('%1: %2', pNode, pValue);
            recSalesComTmp.Insert();
        end else begin
            recSalesComTmp.Comment := StrSubstNo('%1:', pNode);
            recSalesComTmp.Insert();

            CommentLineNo += 10000;
            recSalesComTmp."Line No." := CommentLineNo;
            recSalesComTmp.Comment := CopyStr(pValue, 1, MaxStrLen(recSalesComTmp.Comment));
            recSalesComTmp.Insert();
        end;
    end;

    local procedure GetTemplateCode(pCountryCode: Code[10]) rValue: Code[10]
    var
        recCountry: Record "Country/Region";
        recMktSetup: Record "Marketing Setup";
    begin
        if recCountry.Get(pCountryCode) and (recCountry."Sales Quote Template Code" <> '') then
            rValue := recCountry."Sales Quote Template Code"
        else begin
            recMktSetup.Get();
            recMktSetup.TestField("Sales Quote Template Code");
            rValue := recMktSetup."Sales Quote Template Code";
        end;
    end;


    procedure SetData(pPurchOrderNo: Code[20]): Boolean
    var
        recPurchHead: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        LineNo: Integer;
    begin
        recPurchHead.SetRange("Document Type", recPurchHead."document type"::Order);
        recPurchHead.SetRange("No.", pPurchOrderNo);
        if recPurchHead.FindFirst() then begin
            "Sales Header"."No." := recPurchHead."No.";
            "Sales Header"."External Document No." := recPurchHead."No.";
            "Sales Header"."Requested Delivery Date" := recPurchHead."Requested Receipt Date";
            "Sales Header"."Sell-to Customer Name" := recPurchHead."Buy-from Vendor Name";
            "Sales Header"."Sell-to Customer Name 2" := recPurchHead."Buy-from Vendor Name 2";
            "Sales Header"."Sell-to Address" := recPurchHead."Buy-from Address";
            "Sales Header"."Sell-to Address 2" := recPurchHead."Buy-from Address 2";
            "Sales Header"."Sell-to Post Code" := recPurchHead."Buy-from Post Code";
            "Sales Header"."Sell-to City" := recPurchHead."Buy-from City";
            "Sales Header"."Sell-to Country/Region Code" := recPurchHead."Buy-from Country/Region Code";

            "Sales Header"."Ship-to Name" := recPurchHead."Ship-to Name";
            "Sales Header"."Ship-to Name 2" := recPurchHead."Ship-to Name 2";
            "Sales Header"."Ship-to Address" := recPurchHead."Ship-to Address";
            "Sales Header"."Ship-to Address 2" := recPurchHead."Ship-to Address 2";
            "Sales Header"."Ship-to Post Code" := recPurchHead."Ship-to Post Code";
            "Sales Header"."Ship-to City" := recPurchHead."Ship-to City";
            "Sales Header"."Ship-to Country/Region Code" := recPurchHead."Ship-to Country/Region Code";
            "Sales Header".Insert();

            recPurchLine.SetRange("Document Type", recPurchHead."Document Type");
            recPurchLine.SetRange("Document No.", recPurchHead."No.");
            if recPurchLine.FindSet() then
                repeat
                    LineNo += 10000;
                    "Sales Line"."Document No." := "Sales Header"."No.";
                    "Sales Line"."Line No." := LineNo;
                    "Sales Line"."No." := recPurchLine."No.";
                    "Sales Line".Quantity := recPurchLine.Quantity;
                    "Sales Line"."Requested Delivery Date" := recPurchLine."Requested Receipt Date";
                    "Sales Line".Insert();
                until recPurchLine.Next() = 0;

            exit(true);
        end;
    end;
}
