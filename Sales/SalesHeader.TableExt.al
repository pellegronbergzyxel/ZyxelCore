tableextension 50116 SalesHeaderZX extends "Sales Header"
{
    // 001. 13-03-24 ZY-LD 000 - The field has moved from 50025 to 50029 because of a different field in IC Outbox Sales Header on the field 50025.
    fields
    {
        modify("Shipment Date")
        {
            Caption = 'Available for Picking Date';
        }
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        modify("Location Code")
        {
            TableRelation = Location where("Use As In-Transit" = const(false),
                                           "In Use" = const(true));
        }
        modify("VAT Registration No.")
        {
            Caption = 'VAT Registration No. (Bill-to)';
        }
        field(50000; Elisa; Boolean)
        {
            Caption = 'Elisa';
            Description = 'Unused';
        }
        field(50001; "Confirmed Shipments"; Integer)
        {
            CalcFormula = Count("Sales Line" where("Document Type" = field("Document Type"),
                                                    "Document No." = field("No."),
                                                    Type = const(Item),
                                                    "Shipment Date Confirmed" = const(true)));
            Caption = 'All Shipment Confirmed';
            Description = '23-10-17 ZY-LD 006';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Unconfirmed Shipments"; Integer)
        {
            CalcFormula = Count("Sales Line" where("Document Type" = field("Document Type"),
                                                    "Document No." = field("No."),
                                                    Type = const(Item),
                                                    "Shipment Date Confirmed" = const(false)));
            Caption = 'All Shipment Unconfirmed';
            Description = '23-10-17 ZY-LD 006';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "eComm. Sales Invoice Created"; Boolean)
        {
            CalcFormula = exist("Sales Invoice Header" where("External Document No." = field("External Document No.")));
            Caption = 'eCommerce Sales Invoice Created';
            Description = 'Unused';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "eCommerce Cr. Memo Created"; Boolean)
        {
            CalcFormula = exist("Sales Cr.Memo Header" where("External Document No." = field("External Document No.")));
            Caption = 'eCommerce Cr. Memo Created';
            Description = 'Unused';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "VAT Registration No. Zyxel"; Code[20])
        {
            Caption = 'VAT Registration No. Zyxel';
            Description = '30-05-19 ZY-LD 018';
        }
        field(50007; "Bill-to VAT Registration Code"; Code[10])
        {
            Caption = 'Bill-to VAT Registration Code';
            Description = 'Unused';
            TableRelation = "IC Vendors";
        }
        field(50009; "From E-Mail Address"; Text[50])
        {
            Caption = 'From E-Mail Address';
            Description = 'Unused';
        }
        field(50010; "From E-Mail Signature"; Text[50])
        {
            Caption = 'From E-Mail Signature';
            Description = 'Unused';
        }
        field(50012; "EiCard To Email"; Text[50])
        {
            Caption = 'EiCard To Email';
            Description = 'Unused';
        }
        field(50013; "EiCard To Email 1"; Text[50])
        {
            Caption = 'EiCard To Email 1';
            Description = 'PAB 1.0';
        }
        field(50014; "EiCard To Email 2"; Text[50])
        {
            Caption = 'EiCard To Email 2';
            Description = 'Unused';
        }
        field(50015; "EiCard To Email 3"; Text[50])
        {
            Caption = 'EiCard To Email 3';
            Description = 'Unused';
        }
        field(50016; "EiCard Sales Order"; Code[20])
        {
            Caption = 'EiCard Sales Order';
            Description = 'Unused';
            TableRelation = "Sales Header"."No.";
        }
        field(50017; "Create Invoice pr. Order No."; Code[20])
        {
            Caption = 'Create Invoice pr. Order No.';
            Description = '15-09-21 ZY-LD 047';
        }
        field(50019; "EiCard Distributor Reference"; Text[20])
        {
            Caption = 'EiCard Distributor Reference';
            Description = 'Unused';
        }
        field(50020; "EiCard Status"; Option)
        {
            Caption = 'EiCard Status';
            Description = 'Unused';
            OptionCaption = 'Created,Purchase Order Created,EiCard Order Sent to HQ,Posted,EiCard Sent to Customer,Posting Error';
            OptionMembers = Created,"Purchase Order Created","EiCard Order Sent to HQ",Posted,"EiCard Sent to Customer","Posting Error";
        }
        field(50021; "EiCard Send HTML Email"; Boolean)
        {
            Caption = 'EiCard Send HTML Email';
            Description = 'Unused';
        }
        field(50022; "EiCard To Email 4"; Text[50])
        {
            Caption = 'EiCard To Email 4';
            Description = 'Unused';
        }
        field(50023; "EiCard To Email 5"; Text[50])
        {
            Caption = 'EiCard To Email 5';
            Description = 'Unused';
        }
        field(50024; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Sales Line"."Line Discount Amount" where("Document Type" = field("Document Type"),
                                                                         "Document No." = field("No.")));
            Caption = 'Line Discount Amount';
            Description = '21-09-20 ZY-LD 024';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50028; "Shipping Request Notes"; Text[96])
        {
            Caption = 'Shipping Request Notes';
            Description = '16-08-19 ZY-LD 023';
        }
        field(50030; "Currency Code Sales Doc SUB"; Code[10])
        {
            Caption = 'Currency Code on Sales Document SUB';
            Description = '09-12-19 ZY-LD 028';
            TableRelation = Currency;
        }
        field(50031; "External Document No. End Cust"; Code[20])
        {
            Caption = 'External Document No. for End Cust.';
            Description = '29-01-20 ZY-LD 029';
        }
        field(50032; "Eicard Type"; Option)
        {
            Caption = 'Eicard Type';
            Description = '18-02-20 ZY-LD 030';
            OptionCaption = ' ,Normal,Consignment,eCommerce';
            OptionMembers = " ",Normal,Consignment,eCommerce;
        }
        field(50033; "Customer Document No."; Code[4])
        {
            Caption = 'Customer Document No.';
            Description = '14-01-21 ZY-LD 039';
        }
        field(50034; "SAP No."; Code[10])
        {
            Caption = 'SAP No.';
            Description = '14-01-21 ZY-LD 039';
        }
        field(50035; "Blanket Order No."; Code[20])
        {
            CalcFormula = lookup("Sales Line"."Blanket Order No." where("Document Type" = field("Document Type"),
                                                                        "Document No." = field("No."),
                                                                        Type = const(Item)));
            Caption = 'Blanket Order No.';
            Description = '03-05-21 ZY-LD';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50036; "Skip Posting Group Validation"; Boolean)
        {
            Caption = 'Skip Posting Group Validation';
            Description = '22-06-21 ZY-LD 043';
        }
        field(50037; "Curr. Code Sales Doc SUB Acc."; Boolean)
        {
            Caption = 'Currency Code Sales Doc SUB Accepted';
        }
        field(50038; "External Invoice No."; Code[35])
        {
            Caption = 'External Invoice No.';
            Description = '07-10-21 ZY-LD 048';
        }
        field(50040; "Intercompany Purchase"; Code[10])
        {
            Caption = 'Intercompany Purchase';
        }
        field(50041; "EiCard Ready to Post"; Boolean)
        {
            CalcFormula = exist("EiCard Queue" where("Sales Order No." = field("No."),
                                                     Active = const(true),
                                                     "Purchase Order Status" = field("EiCard iPurch Order St. Filter"),
                                                     "Sales Order Status" = const("EiCard Sent to Customer"),
                                                     "Comparision of Qty and Link Ok" = const(true)));
            Caption = 'EiCard Ready to Post';
            Description = '04-10-19 ZY-LD 024';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50042; "EiCard iPurch Order St. Filter"; Option)
        {
            Caption = 'EiCard Purchase Order Status Filter';
            Description = '28-10-19 ZY-LD 025';
            FieldClass = FlowFilter;
            OptionCaption = 'Created,EiCard Order Sent to HQ,EiCard Order Accepted,EiCard Order Rejected,Fully Matched,Partially Matched,Posted,Posting Error';
            OptionMembers = Created,"EiCard Order Sent to HQ","EiCard Order Accepted","EiCard Order Rejected","Fully Matched","Partially Matched",Posted,"Posting Error";
        }
        field(50044; "Warehouse Status"; Option)
        {
            Caption = 'Warehouse Status';
            Description = 'Unused';
            OptionCaption = 'None,Order Sent,Order Partially Sent,Order Accepted,Order Partially Accepted,Order Rejected,Order Partially Rejected,Order Picking,Order Partially Picking,Order Dispatched,Order Partially Dispatched,Order Delivered,Order Partially Delivered';
            OptionMembers = "None","Order Sent","Order Partially Sent","Order Accepted","Order Partially Accepted","Order Rejected","Order Partially Rejected","Order Picking","Order Partially Picking","Order Dispatched","Order Partially Dispatched","Order Delivered","Order Partially Delivered";
        }
        field(50045; "EiCard Sent"; Boolean)
        {
            Caption = 'EiCard Sent';
            Description = 'Unused';
        }
        field(50046; "Ship-to VAT"; Text[50])
        {
            Caption = 'VAT Registration No. (Ship-to)';
        }
        field(50047; "Post EiCard Invoice Automatic"; Option)
        {
            CalcFormula = lookup(Customer."Post EiCard Invoice Automatic" where("No." = field("Sell-to Customer No.")));  // 30-05-24 ZY-LD 000 - Changed from Bill-to to Sell-to.
            Caption = 'Post EiCard Invoice Automatic';
            Description = '28-10-19 ZY-LD 025';
            FieldClass = FlowField;
            OptionCaption = ' ,Yes (when purchase invoice is posted),Yes (when EiCard links is sent to the customer)';
            OptionMembers = " ","Yes (when purchase invoice is posted)","Yes (when EiCard links is sent to the customer)";
        }
        field(50048; "Picking List No. Filter"; Code[20])
        {
            Caption = 'Picking List No. Filter';
            Description = '01-11-19 ZY-LD 026';
            FieldClass = FlowFilter;
            TableRelation = "VCK Delivery Document Header";
        }
        field(50049; "Total Quantity"; Decimal)
        {
            CalcFormula = sum("Sales Line".Quantity where("Document Type" = field("Document Type"),
                                                          "Document No." = field("No."),
                                                          Type = const(Item)));
            Caption = 'Total Quantity';
            Description = '01-11-19 ZY-LD 026';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "CZ Sales Order No."; Code[20])
        {
            Caption = 'CZ Sales Order No.';
            Description = 'Unused';
        }
        field(50051; "No of Lines"; Integer)
        {
            CalcFormula = Count("Sales Line" where("Document Type" = field("Document Type"),
                                                   "Document No." = field("No."),
                                                   Type = const(Item)));
            Caption = 'No of Lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50052; "Create Delivery Doc. pr. Order"; Boolean)
        {
            CalcFormula = lookup(Customer."Create Delivery Doc. pr. Order" where("No." = field("Sell-to Customer No.")));
            Caption = 'Create Delivery Doc. pr. Order';
            Description = '03-11-21 ZY-LD 050';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50054; "Disable Additional Items"; Boolean)  // 13-03-24 ZY-LD 001
        {
            Caption = 'Disable Additional Items';
            Description = '09-04-18 ZY-LD 013';
        }
        field(50055; "NL to DK Rev. Charge Doc No."; Boolean)  // 13-03-24 ZY-LD 000  // Wrong type - can be deleted.
        {
            Caption = 'Not Used.';
            TableRelation = IF ("Document Type" = const(Invoice)) "Sales Invoice Header" else
            if ("Document Type" = const("Credit Memo")) "Sales Cr.Memo Header";

            trigger OnValidate()
            var
                SalesInvHead: Record "Sales Invoice Header";
                SalesInvLine: Record "Sales Invoice Line";
                SalesCrHead: Record "Sales Cr.Memo Header";
                SalesCrLine: Record "Sales Cr.Memo Line";
                LiNo: Integer;
            begin
                if Rec."Document Type" = Rec."Document Type"::Invoice then begin
                    LiNo := 10000;

                    SalesInvHead.get("NL to DK Rev. Charge Doc No.");
                    SalesInvLine.SetRange("Document No.", SalesInvHead."No.");
                    if SalesInvLine.FindSet() then
                        repeat
                        // Fill in data here. G/L Account No. 40251 - Positive on PI and Negative on SI and 40252 - Reverse sign here.
                        until SalesInvLine.Next() = 0;
                end;
            end;
        }
        field(50056; "NL to DK Reverse Chg. Doc No."; Code[20])  // 13-03-24 ZY-LD 000
        {
            Caption = 'NL to DK Rev. Charge Document No.';
        }
        field(50060; "Created by Company"; Text[30])
        {
            Caption = 'Created by Company';
            Description = 'Unused';
        }
        field(50061; "eCommerce Order"; Boolean)
        {
            Caption = 'eCommerce Order';
            Description = 'eCommerce';
        }
        field(50062; "Reference 2"; Text[50])
        {
            Caption = 'Reference 2';
            Description = 'eCommerce';
        }
        field(50063; EDI; Boolean)
        {
            Caption = 'EDI';
            Description = 'Unused';
        }
        field(50064; "EDI Responce Sent"; Boolean)
        {
            Caption = 'EDI Responce Sent';
            Description = 'Unused';
        }
        field(50065; "EDI Document No."; Code[20])
        {
            Caption = 'EDI Document No.';
            Description = 'Unused';
        }
        field(50068; "Order Desk Resposible Code"; Code[20])
        {
            Caption = 'Order Desk Resposible Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50069; "Skip Verify on Inventory"; Boolean)
        {
            Caption = 'Skip Verify on Inventory';
            Description = '02-03-23 ZY-LD 051';
        }
        field(50071; "Ship-to Code Del. Doc"; Code[20])  // 06-05-24 ZY-LD 000
        {
            Caption = 'Ship-to Code - Rework';
            Description = 'For samples we sometime ship products to Denmark to rework, but due to intrastat the item ledger entry must still be the receiving country.';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
        }
        field(50102; "Backlog Comment"; Option)
        {
            Caption = 'Backlog Comment';
            Description = '12-09-18 ZY-LD 015';
            OptionCaption = ' ,Awaiting Prepayment,Credit Blocked,On Hold by Customer,Other';
            OptionMembers = " ","Awaiting Prepayment","Credit Blocked","On Hold by Customer",Other;
        }
        field(50103; "Send to ZNet"; Boolean)
        {
            Caption = 'Send to ZNet';
            Description = 'Unused';
        }
        field(50104; "From RHQ"; Boolean)
        {
            Caption = 'From RHQ';
            Description = 'Unused';
        }

        field(55015; AmazonePoNo; Code[35])
        {
            // Caption = 'Amazon PO No.';
            DataClassification = ToBeClassified;
        }

        field(55016; AmazonpurchaseOrderState; text[20])
        {
            Caption = 'Amazon purchaseOrderState';
            DataClassification = ToBeClassified;
        }
        field(55017; AmazonSellpartyid; text[20])
        {
            Caption = 'Amazon AmazonSellpartyid';
            DataClassification = ToBeClassified;
        }

        field(55019; AmazconfirmationStatus; text[20])
        {
            Caption = 'Amazon confirmationStatus';
            DataClassification = ToBeClassified;
        }
        field(55021; Amazonfirstwindowdate; date)
        {
            Caption = 'Amazon first date in delivery window';
            DataClassification = ToBeClassified;
        }

        field(61300; "E-Invoice Comment"; Text[25])
        {
            Caption = 'E-Invoice Comment';
        }
        field(62000; "Picking List No."; Code[20])
        {
            CalcFormula = lookup("Sales Line"."Picking List No." where("Document Type" = field("Document Type"),
                                                                       "Document No." = field("No."),
                                                                       "Picking List No." = filter(<> '')));
            Caption = 'Picking List No';
            Description = '01-11-19 ZY-LD 011';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62004; "Send Mail"; Boolean)
        {
            Caption = 'Send Automatic E-mail';
            Description = 'Tectura Taiwan';
        }
        field(62009; "Special Remark"; Text[40])
        {
            Caption = 'Special Remark';
            Description = 'Unused';
        }
        field(62010; "Shipping Instruction"; Text[40])
        {
            Caption = 'Shipping Instruction';
            Description = 'Unused';
        }
        field(62017; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            Description = 'Tectura Taiwan';
            OptionCaption = ' ,Normal,EICard,Drop Shipment,Other,Spec. Order,G/L Account,HaaS,eCommerce';  // 15-07-24 ZY-LD 000 - eCommerce is added.
            OptionMembers = " ",Normal,EICard,"Drop Shipment",Other,"Spec. Order","G/L Account",HaaS,eCommerce;

            trigger OnValidate()
            var
                LEMSG000: Label 'Sales Order Type can not be change!';
                LocationRec: Record Location;
                LEMSG001: Label 'Sales Order Type %1 can not match with Location %2!';
                LEMSG002: Label 'Location %1 not exist!';
                LEMSG003: Label 'Can not find default location for Sales Order Type %1!';
                SOLine: Record "Sales Line";
                Item: Record Item;
                LEMSG004: Label 'Item %1 is not match %2!';
                LEMSG005: Label 'Document Type should be Order or Invoice!';
            begin

            end;
        }
        field(62022; "Completely Invoiced"; Boolean)
        {
            CalcFormula = min("Sales Line"."Completely Invoiced" where("Document Type" = field("Document Type"),
                                                                       "Document No." = field("No."),
                                                                       Type = filter(<> " ")));
            Caption = 'Completely Invoiced';
            Description = 'Tectura Taiwan';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62023; "Shipment Date Missing"; Boolean)
        {
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"),
                                                   "Document No." = field("No."),
                                                   Type = const(Item),
                                                   "Qty. to Ship" = filter(> 0),
                                                   "Shipment Date Confirmed" = const(false)));
            Caption = 'Shipment Date Missing';
            Description = 'Unused';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62025; "RHQ Invoice No"; Code[30])
        {
            Caption = 'RHQ Invoice No';
        }
        field(62026; "RHQ Credit Memo No"; Code[20])
        {
            Caption = 'RHQ Credit Memo No';
        }
        field(62033; "Dist. Purch. Order No."; Text[20])
        {
            Caption = 'Dist. PO#';
            Description = 'Unused';
        }
        field(62034; "Dist. E-mail"; Text[30])
        {
            Caption = 'Dist. E-mail';
            Description = 'Unused';
        }
        field(62080; "Create User ID"; Code[30])
        {
            Caption = 'Create User ID';
            Description = 'ZL111213A';
            Editable = false;
        }
        field(62081; "Create Date"; Date)
        {
            Caption = 'Create Date';
            Description = 'ZL111213A';
            Editable = false;
        }
        field(62082; "Create Time"; Time)
        {
            Caption = 'Create Time';
            Description = 'Unused';
            Editable = false;
        }
        field(62100; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'Unused';
        }
        field(62105; "Variable Symbol"; Code[10])
        {
            Caption = 'Variable Symbol';
            Description = 'Unused';

            trigger OnValidate()
            begin
                //ES4.10: Automatic Banking;
                Rec.TestField(Rec.Status, Rec.Status::Open);
                //ES4.10
            end;
        }
        field(62106; "Constant Symbol"; Code[10])
        {
            Caption = 'Constant Symbol';
            Description = 'Unused';

            trigger OnValidate()
            begin
                //ES4.10: Automatic Banking;
                Rec.TestField(Rec.Status, Rec.Status::Open);
                //ES4.10
            end;
        }
        field(67002; "Batch Posting"; Option)
        {
            Caption = 'Batch Posting';
            Description = 'Unused';
            OptionCaption = 'Daily,Monthly,Price Dependent';
            OptionMembers = Daily,Monthly,"Price Dependent";
        }
        field(67003; "Ship-to E-Mail"; Text[40])
        {
            Caption = 'Ship-to E-Mail';
            Description = 'PAB 1.0';
        }
        field(67004; "Action Code"; Code[6])
        {
            Caption = 'Action Code';
            Description = 'PAB 1.0';
            TableRelation = "Action Codes";
        }
        field(67005; "Delivery Document Created"; Boolean)
        {
            Caption = 'Delivery Document Created';
            Description = 'Unused';
        }
        field(67006; "Delivery Zone"; Option)
        {
            Caption = 'Delivery Zone';
            Description = 'Unused';
            OptionCaption = 'Zone 1,Zone 2,Zone 3,Zone 4,Zone 5,Zone 6,Zone 7,Zone 8,Zone 9,Zone 10';
            OptionMembers = "Zone 1","Zone 2","Zone 3","Zone 4","Zone 5","Zone 6","Zone 7","Zone 8","Zone 9","Zone 10";
        }
    }

    keys
    {
        key(Key50000; "Document Type", "Order Date")
        {
        }
    }


    procedure TotalOutstandingamount(): Decimal
    var
        Salesline: record "Sales Line";
    begin
        Salesline.setrange("Document Type", rec."Document Type");
        Salesline.Setrange("Document No.", rec."No.");
        SalesLine.SetFilter("Shipment No.", '<>%1', '');
        Salesline.CalcSums("Outstanding Amount (LCY)");
        exit(Salesline."Outstanding Amount (LCY)")

    end;
}
