Table 50042 "VCK Delivery Document Line"
{
    // 001. 09-10-18 ZY-LD 2018091010000047 - Field captions and Table relations is added.
    // 002. 18-10-18 ZY-LD 0022018091410000272 - New fields.
    // 003. 01-11-18 ZY-LD 000 - New key. "Item No., Warehouse Status".
    // 004. 01-11-18 ZY-LD 000 - When a "Warehouse Status" on DD Line is changed, the field must also change on the sales order line.
    // 005. 13-03-19 ZY-LD 000 - Warehouse Response Posting Date.
    // 006. 17-04-19 ZY-LD P0202 - Update Warehouse Status on the Sales Line.
    // 007. 01-05-19 ZY-LD P0226 - New field.
    // 008. 29-05-19 ZY-LD 000 - Don't delete if sent to warehouse.
    // 009. 14-08-19 ZY-LD 2019081410000058 - Sales Person Code is extented from 20 to 50
    // 010. 28-11-19 ZY-LD 2019112810000034 - Update sales line if quantity is zero.
    // 011. 01-07-20 ZY-LD 2020070110000036 - "Warehouse Status" must also be cleared when the DD linie is deleted.
    // 012. 12-11-20 ZY-LD 2020111210000071 - Extra check at delete.
    // 013. 17-11-20 ZY-LD P0499 - New key "Sales Order No.".
    // 014. 10-08-21 ZY-LD 2021081010000042 - You can not delete the line if the sales order line is posted.
    // 015. 06-12-21 ZY-LD 000 - New field used on "Customs Invoice".
    // 016. 18-05-22 ZY-LD 2022011110000088 - New field.
    // 017. 08-04-24 ZY-LD 000 - It happens that we delete a line from the delivery document, but the warehouse send it anyway. The order handler must be able to recreate the line.
    // 018. 10-04-24 ZY-LD 000 - The delivery document no. must be the same.
    // DD1.00 2021-09-15 Delta Design A/S
    //  - Added field: HideLine


    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Description = 'PAB 1.0';
            TableRelation = "VCK Delivery Document Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Description = 'PAB 1.0';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'PAB 1.0';
            TableRelation = Item;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            Description = 'PAB 1.0';
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Validate("Line Discount Amount");
                Validate(Amount);

                //>> 28-11-19 ZY-LD 010
                if recSalesLine.Get(recSalesLine."document type"::Order, "Sales Order No.", "Sales Order Line No.") then begin
                    if Quantity = 0 then begin
                        recSalesLine."Delivery Document No." := '';
                        recSalesLine."Warehouse Status" := recSalesLine."warehouse status"::New;
                    end else begin
                        recSalesLine."Delivery Document No." := "Document No.";
                        recSalesLine."Warehouse Status" := "Warehouse Status";
                    end;
                    //recSalesLine.MODIFY;  // 02-12-20 ZY-LD 013
                    if not recSalesLine.Modify then;  // 02-12-20 ZY-LD 013  // If the quantity is updated from the sales line we don´t want to write back.
                end;
                //<< 28-11-19 ZY-LD 010
            end;
        }
        field(6; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price Excl. VAT';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(7; Location; Code[20])
        {
            Caption = 'Location';
            Description = 'PAB 1.0';
            TableRelation = Location;
        }
        field(8; "Sales Order No."; Code[20])
        {
            Caption = 'Source No.';
            Description = 'PAB 1.0';
            TableRelation = if ("Document Type" = const(Sales)) "Sales Header"."No." where("Document Type" = const(Order))
            else
            if ("Document Type" = const(Transfer)) "Transfer Header";
        }
        field(9; "Customer Order No."; Code[30])
        {
            Caption = 'Customer Order No.';
            Description = 'PAB 1.0';
        }
        field(10; "Warehouse Status"; Option)
        {
            Caption = 'Warehouse Status';
            Description = 'PAB 1.0';
            OptionCaption = 'New,Backorder,Ready to Pick,Picking,Packed,Waiting for invoice,Invoice Received,Posted,In Transit,Delivered,Error';
            OptionMembers = New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;

            trigger OnValidate()
            begin
                //>> 17-04-19 ZY-LD 006
                // Warehouse Status on the sales line might be used in PP, it can therefore not be changed to a flowfield.
                if recSalesLine.Get(recSalesLine."document type"::Order, "Sales Order No.", "Sales Order Line No.") then begin
                    recSalesLine."Warehouse Status" := "Warehouse Status";
                    recSalesLine.Modify;
                end;
                //<< 17-04-19 ZY-LD 006
            end;
        }
        field(11; "Action Code"; Text[250])
        {
            Caption = 'Action Code';
            Description = 'PAB 1.0';
        }
        field(12; "Sales Order Line No."; Integer)
        {
            Caption = 'Source Line No.';
            Description = 'PAB 1.0';
            TableRelation = if ("Document Type" = const(Sales)) "Sales Line"."Line No." where("Document Type" = const(Order),
                                                                                             "Document No." = field("Sales Order No."))
            else
            if ("Document Type" = const(Transfer)) "Transfer Line"."Line No." where("Document No." = field("Document No."));
        }
        field(13; "Has Serial No"; Boolean)
        {
            Caption = 'Has Serial No';
            Description = 'PAB 1.0';
        }
        field(14; "Transfer Order Line No."; Integer)
        {
            Caption = 'Transfer Order Line No.';
            Description = 'PAB 1.0';
        }
        field(15; "Transfer Order No."; Code[20])
        {
            Caption = 'Transfer Order No.';
            Description = 'PAB 1.0';
            TableRelation = "Transfer Header"."No.";
        }
        field(16; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            Description = 'PAB 1.0';
            TableRelation = Currency;
        }
        field(17; "Picking Date Time"; Text[50])
        {
            Caption = 'Picking Date Time';
            Description = 'PAB 1.0';
        }
        field(18; "Loading Date Time"; Text[50])
        {
            Caption = 'Loading Date Time';
            Description = 'PAB 1.0';
        }
        field(19; "Delivery Date Time"; Text[50])
        {
            Caption = 'Delivery Date Time';
            Description = 'PAB 1.0';
        }
        field(20; "Delivery Remark"; Text[50])
        {
            Caption = 'Delivery Remark';
            Description = 'PAB 1.0';
        }
        field(21; "Delivery Status"; Text[50])
        {
            Caption = 'Delivery Status';
            Description = 'PAB 1.0';
        }
        field(22; "Receiver Reference"; Text[50])
        {
            Caption = 'Receiver Reference';
            Description = 'PAB 1.0';
        }
        field(23; "Shipper Reference"; Text[50])
        {
            Caption = 'Shipper Reference';
            Description = 'PAB 1.0';
        }
        field(24; "Signed By"; Text[50])
        {
            Caption = 'Signed By';
            Description = 'PAB 1.0';
        }
        field(25; Posted; Boolean)
        {
            Caption = 'Warehouse Response Posted';
            Description = 'PAB 1.0';

            trigger OnValidate()
            begin
                "Whse. Response Posting Date" := CurrentDatetime;  // 13-03-19 ZY-LD 005
            end;
        }
        field(26; "Shipment Date"; Date)
        {
            CalcFormula = lookup("Sales Line"."Shipment Date" where("Document No." = field("Sales Order No."),
                                                                     "Line No." = field("Sales Order Line No.")));
            Caption = 'Picking Date';
            Description = 'PAB 1.0';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; Transferorder; Boolean)
        {
            Caption = 'Transferorder';
            Description = 'RD 1.0';
        }
        field(28; "Salesperson Code"; Code[50])
        {
            Caption = 'Salesperson Code';
            Description = 'PAB 1.0';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
            end;
        }
        field(29; PickDate; Date)
        {
            Caption = 'Picking Date';
            Description = 'PAB 1.0';
        }
        field(30; "Requested Delivery Date"; Date)
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Requested Delivery Date" where("No." = field("Document No.")));
            Caption = 'Requested Delivery Date';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(31; "Release Date"; Date)
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Release Date" where("No." = field("Document No.")));
            Caption = 'Release Date';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(32; "Document Status"; Option)
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Document Status" where("No." = field("Document No.")));
            Caption = 'Document Status';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
            OptionCaption = 'New,Released';
            OptionMembers = New,Released;
        }
        field(33; "Requested Ship Date"; Date)
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Requested Ship Date" where("No." = field("Document No.")));
            Caption = 'Requested Ship Date';
            Description = 'PAB 1.0';
            FieldClass = FlowField;
        }
        field(34; "Ignore In Posting"; Boolean)
        {
            Caption = 'Ignore In Posting';
            Description = 'PAB 1.0';
        }
        field(35; "Deliv. Doc. No. on Sales Line"; Boolean)
        {
            CalcFormula = exist("Sales Line" where("Document Type" = const(Order),
                                                    "Document No." = field("Sales Order No."),
                                                    "Line No." = field("Sales Order Line No."),
                                                    "Delivery Document No." = field("Document No.")));
            Caption = 'Deliv. Doc. No. on Sales Line';
            Description = '18-10-18 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; Amount; Decimal)
        {
            Caption = 'Line Amount Excl. VAT';
            Description = '18-10-18 ZY-LD 002';
            Editable = false;

            trigger OnValidate()
            begin
                //Amount := Quantity * "Unit Price";  // 18-10-18 ZY-LD 001
                GetCurrency("Currency Code");
                "Line Amount" := ROUND(Quantity * "Unit Price", recCurrency."Amount Rounding Precision");
                Amount := "Line Amount" - "Line Discount Amount";
                "Amount Including VAT" := Amount * (1 + ("VAT %" / 100));
            end;
        }
        field(37; "Whse. Response Posting Date"; DateTime)
        {
            Caption = 'Warehouse Response Posting Date';
        }
        field(38; "External Document No. End Cust"; Code[20])
        {
            CalcFormula = lookup("Sales Header"."External Document No. End Cust" where("Document Type" = const(Order),
                                                                                        "No." = field("Sales Order No.")));
            Caption = 'External Document No. for End Cust.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "VAT %"; Decimal)
        {
            BlankZero = true;
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(40; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(41; "Line Discount %"; Decimal)
        {
            BlankZero = true;
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                GetCurrency("Currency Code");
                "Line Discount Amount" :=
                  ROUND(
                    ROUND(Quantity * "Unit Price", recCurrency."Amount Rounding Precision") *
                    "Line Discount %" / 100, recCurrency."Amount Rounding Precision");

                Validate(Amount);
            end;
        }
        field(42; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Line Discount Amount';
            Editable = false;

            trigger OnValidate()
            begin
                if Quantity = 0 then
                    "Line Discount Amount" := 0
                else begin
                    GetCurrency("Currency Code");
                    "Line Discount Amount" := ROUND("Line Discount Amount", recCurrency."Amount Rounding Precision");
                    if xRec."Line Discount Amount" <> "Line Discount Amount" then
                        if ROUND(Quantity * "Unit Price", recCurrency."Amount Rounding Precision") <> 0 then
                            "Line Discount %" :=
                              ROUND(
                                "Line Discount Amount" / ROUND(Quantity * "Unit Price", recCurrency."Amount Rounding Precision") * 100,
                                0.00001)
                        else
                            "Line Discount %" := 0;
                end;

                Validate(Amount);
            end;
        }
        field(43; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            Description = '18-10-18 ZY-LD 002';
            Editable = false;

            trigger OnValidate()
            begin
                //Amount := Quantity * "Unit Price";  // 18-10-18 ZY-LD 001
                GetCurrency("Currency Code");
                Amount := ROUND(Quantity * "Unit Price", recCurrency."Amount Rounding Precision") - "Line Discount Amount";
                "Amount Including VAT" := Amount * (1 + ("VAT %" / 100));
            end;
        }
        field(44; "Gross Weight"; Decimal)
        {
            CalcFormula = lookup(Item."Gross Weight" where("No." = field("Item No.")));
            Caption = 'Gross Weight';
            Editable = false;
            FieldClass = FlowField;
        }
        field(45; "Net Weight"; Decimal)
        {
            CalcFormula = lookup(Item."Net Weight" where("No." = field("Item No.")));
            Caption = 'Net Weight';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46; "External Document No."; Code[35])
        {
            CalcFormula = lookup("Sales Line"."External Document No." where("Document Type" = const(Order),
                                                                             "Document No." = field("Sales Order No."),
                                                                             "Line No." = field("Sales Order Line No.")));
            Caption = 'External Document No.';
            Description = '06-12-21 ZY-LD 015';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "Freight Cost Item"; Boolean)
        {
            CalcFormula = lookup(Item."Freight Cost Item" where("No." = field("Item No.")));
            Caption = 'Freight Cost Item';
            Description = '18-05-22 ZY-LD 016';
            Editable = false;
            FieldClass = FlowField;
        }
        field(48; "Creation Date"; Date)
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Create Date" where("No." = field("Document No.")));
            Caption = 'Creation Date';
            FieldClass = FlowField;
        }
        field(49; "Do not Calculate Amount"; Boolean)  // 18-12-23 ZY-LD 017
        {
            Caption = 'Don´t calculate Amount';
        }
        field(50; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            CalcFormula = lookup("VCK Delivery Document Header"."Sell-to Customer No." where("No." = field("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Document Type"; Option)
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Document Type" where("No." = field("Document No.")));
            Caption = 'Source Type';
            Description = '01-05-19 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Sales,Transfer';
            OptionMembers = Sales,Transfer;
        }
        field(92; "Outstanding Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Outstanding Amount (LCY)';
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure";

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }
        field(50101; "Hide Line"; Boolean)
        {
            Description = 'DT1.00';
            Editable = true;
        }
        field(50102; "No of Serial No."; Integer)
        {
            CalcFormula = count("VCK Delivery Document SNos" where("Delivery Document No." = field("Document No."),
                                                                    "Delivery Document Line No." = field("Line No.")));
            Caption = 'No of Serial No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup("VCK Delivery Document Header"."Sell-to Customer Name" where("No." = field("Document No.")));
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.", "Sales Order No.", "Sales Order Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Warehouse Status")
        {
        }
        key(Key3; "Transfer Order No.")
        {
        }
        key(Key4; "Sales Order No.", "Sales Order Line No.")
        {
        }
        key(Key5; Posted, "Warehouse Status")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        recSalesLine: Record "Sales Line";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if not gDeletingFromHeader then begin  // 12-11-20 ZY-LD 012
                                               //>> 29-05-19 ZY-LD 008
            recDelDocHead.Get("Document No.");
            if recDelDocHead.SentToAllIn then
                if Confirm(Text001, false, "Document No.") then
                    if not Confirm(Text002) then
                        Error(Text003);
            //<< 29-05-19 ZY-LD 008
        end;

        if not "Ignore In Posting" and
           ("Document Type" = "document type"::Sales)  // 12-11-20 ZY-LD 012
        then
            if recSalesLine.Get(recSalesLine."document type"::Order, "Sales Order No.", "Sales Order Line No.") then begin
                //>> 10-08-21 ZY-LD 014
                if ("Document No." = recSalesLine."Delivery Document No.") and  // 10-04-24 ZY-LD 018
                   (recSalesLine."Quantity Shipped" <> 0)
                then
                    if zgt.UserIsDeveloper() then begin
                        if not Confirm(Text004 + Text005, false, "Sales Order No.", "Sales Order Line No.") then
                            Error('')
                    end else
                        Error(Text004, "Sales Order No.", "Sales Order Line No.");

                //<< 10-08-21 ZY-LD 014

                recSalesLine."Delivery Document No." := '';
                recSalesLine."Warehouse Status" := recSalesLine."warehouse status"::New;  // 01-07-20 ZY-LD 011
                recSalesLine.Modify;
            end;
    end;

    trigger OnModify()
    begin
        //>> 01-11-18 ZY-LD 004
        if "Warehouse Status" <> xRec."Warehouse Status" then
            if recSalesLine.Get(recSalesLine.Type::Item, "Sales Order No.", "Sales Order Line No.") then begin
                recSalesLine.TestField("Delivery Document No.");
                recSalesLine."Warehouse Status" := "Warehouse Status";
                recSalesLine.Modify;
            end;
        //<< 01-11-18 ZY-LD 004
    end;

    var
        recDelDocHead: Record "VCK Delivery Document Header";
        recSalesLine: Record "Sales Line";
        Text001: label '%1 has been sent to the warehouse, are you sure you want to delete it?';
        Text002: label 'Are you sure.';
        Text003: label 'Process cancled.';
        recCurrency: Record Currency;
        gDeletingFromHeader: Boolean;
        Text004: label 'You can not delete the line, because the sales order line has been posted. You must undo the posting before you can delete the line.\ Sales Order No.: %1\Line No.: %2.';
        Text005: label '\Are you sure you want to delete?';


    procedure DeletingFromHeader(pDeletingFromHeader: Boolean)
    begin
        gDeletingFromHeader := pDeletingFromHeader;
    end;

    procedure RecreateLineFromChangeLog(pDelDocNo: Code[20]; pDelDocLineNo: Integer; var pCustOrderNo: Code[20]; var pCustOrderLineNo: Integer)
    var
        ChangeLog: Record "Change Log Entry";
        DelDocLine: Record "VCK Delivery Document Line";
        DelDocLine2: Record "VCK Delivery Document Line";
        SalesLine: Record "Sales Line";
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        DecimalValue: Decimal;
        IntegerValue: Integer;
        lText001: Label 'The line was deleted by "%1" on %2.\Do you want to recreate the line on the delivery document?';
        lText002: Label 'The line "%1 %2" has been recreated.';
        lText003: Label 'The line has been created on %1 %2. You must delete that line first before you can recreate the line.';
        lText004: Label '"%1" %2 %3 has a "%4" %5 that is different from %6. You must update the "%1" before you can recreate the line.';
    begin
        //>> 08-04-24 ZY-LD 030
        ChangeLog.SetCurrentKey("Table No.", "Type of Change", "Primary Key Field 1 Value", "Field No.");
        ChangeLog.SetRange("Type of Change", ChangeLog."Type of Change"::Deletion);
        ChangeLog.SetRange("Table No.", Database::"VCK Delivery Document Line");
        ChangeLog.SetRange("Primary Key Field 1 Value", pDelDocNo);
        ChangeLog.SetRange("Primary Key Field 2 Value", Format(pDelDocLineNo));
        if ChangeLog.FindSet() then
            if Confirm(lText001, false, ChangeLog."User ID", ChangeLog."Date and Time") then begin
                RecordRef.Open(ChangeLog."Table No.");
                repeat
                    FieldRef := RecordRef.Field(ChangeLog."Field No.");
                    case FieldRef.Type of
                        FieldRef.Type::Code,
                        FieldRef.Type::Text:
                            FieldRef.Value(ChangeLog."Old Value");
                        FieldRef.Type::Decimal:
                            begin
                                Evaluate(DecimalValue, ChangeLog."Old Value");
                                FieldRef.Value(DecimalValue);
                            end;
                        FieldRef.Type::Integer,
                        FieldRef.Type::Option:
                            begin
                                Evaluate(IntegerValue, ChangeLog."Old Value");
                                FieldRef.Value(IntegerValue);
                            end;
                    end;

                    case ChangeLog."Field No." of
                        8:  // Source No.
                            pCustOrderNo := ChangeLog."Old Value";
                        12:  // Source Line No.
                            Evaluate(pCustOrderLineNo, ChangeLog."Old Value");
                    end;
                until ChangeLog.Next() = 0;
                RecordRef.Insert();

                RecordRef.SetTable(DelDocLine);
                DelDocLine2.SetRange("Sales Order No.", DelDocLine."Sales Order No.");
                DelDocLine2.SetRange("Sales Order Line No.", DelDocLine."Sales Order Line No.");
                DelDocLine2.SetFilter("Document No.", '<>%1', DelDocLine."Document No.");
                if DelDocLine2.FindFirst then
                    Error(lText003, DelDocLine2."Document No.", DelDocLine2."Line No.")
                else begin
                    SalesLine.get(SalesLine."Document Type"::Order, DelDocLine."Sales Order No.", DelDocLine."Sales Order Line No.");
                    if (SalesLine."Delivery Document No." = DelDocLine."Document No.") or (SalesLine."Delivery Document No." = '') then begin
                        SalesLine."Delivery Document No." := DelDocLine."Document No.";
                        SalesLine."Warehouse Status" := DelDocLine."Warehouse Status";
                        SalesLine.Modify;
                        Message(lText002, pDelDocNo, pDelDocLineNo);
                    end else
                        Error(lText004, SalesLine.TableCaption, SalesLine."Document No.", SalesLine."Line No.", SalesLine.FieldCaption("Delivery Document No."), SalesLine."Delivery Document No.", DelDocLine."Document No.");
                end;
            end;
        //<< 08-04-24 ZY-LD 030
    end;

    local procedure GetCurrency(pCode: Code[10])
    begin
        if pCode <> recCurrency.Code then
            recCurrency.Get(pCode);
    end;
}
