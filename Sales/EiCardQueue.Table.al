Table 50036 "EiCard Queue"
{
    // 001. 06-05-19 ZY-LD P0213 - "Created By" is extented from 20 to 50.
    // 002. 03-09-19 ZY-LD P0290 - Do not delete line.
    // 003. 16-09-19 ZY-LD P0290 - Validate E-mail.
    // 004. 20-09-19 ZY-LD 2019092010000044 - New fields.
    // 005. 04-10-19 ZY-LD P0313 - New field.
    // 006. 21-01-19 ZY-LD 2020012110000081 - New field.
    // 007. 18-02-20 ZY-LD P0395 - New field.
    // 008. 01-10-20 ZY-LD 2020093010000068 - New field.
    // 009. 15-12-20 ZY-LD 2020121510000054 - New field.
    // 010. 01-06-22 ZY-LD 2022060110000071 - New field.

    Permissions = TableData "Change Log Entry" = d,
                  TableData "EiCard Link Line" = d;

    fields
    {
        field(1; "Created By"; Code[50])
        {
            Caption = 'User ID';
            Description = 'PAB 1.0';
        }
        field(2; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Description = 'PAB 1.0';
            TableRelation = "Sales Header"."No.";
        }
        field(3; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Description = 'PAB 1.0';
            TableRelation = "Purchase Header"."No.";
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = 'PAB 1.0';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                UpdateEiCardFields;
            end;
        }
        field(5; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
            Description = 'PAB 1.0';
        }
        field(6; "Sales Order Status"; Option)
        {
            Caption = 'Sales Order Status';
            Description = 'PAB 1.0';
            OptionCaption = 'Created,Purchase Order Created,EiCard Order Sent to HQ,Posted,EiCard Sent to Customer,Posting Error,Cancled';
            OptionMembers = Created,"Purchase Order Created","EiCard Order Sent to HQ",Posted,"EiCard Sent to Customer","Posting Error",Cancled;

            trigger OnValidate()
            begin
                //>> 03-09-19 ZY-LD 002
                "Status Change Date" := Today;  // 03-09-19 ZY-LD 002
                if "Sales Order Status" = "sales order status"::"EiCard Sent to Customer" then
                    "E-mail is Sent to Customer" := CurrentDatetime;
                //<< 03-09-19 ZY-LD 002
            end;
        }
        field(7; "Purchase Order Status"; Option)
        {
            Caption = 'Purchase Order Status';
            Description = 'PAB 1.0';
            OptionCaption = 'Created,EiCard Order Sent to HQ,EiCard Order Accepted,EiCard Order Rejected,Fully Matched,Partially Matched,Posted,Posting Error,Cancled';
            OptionMembers = Created,"EiCard Order Sent to HQ","EiCard Order Accepted","EiCard Order Rejected","Fully Matched","Partially Matched",Posted,"Posting Error",Cancled;

            trigger OnValidate()
            begin
                "Status Change Date" := Today;  // 03-09-19 ZY-LD 002
            end;
        }
        field(8; "Status Change Date"; Date)
        {
            Caption = 'Status Change Date';
            Description = 'PAB 1.0';
        }
        field(9; "Error Description"; Text[250])
        {
            Caption = 'Error Description';
            Description = 'PAB 1.0';
        }
        field(10; "Distributor Reference"; Text[250])
        {
            Caption = 'Distributor Reference';
            Description = 'PAB 1.0';
        }
        field(11; "External Document No."; Text[250])
        {
            Caption = 'External Document No.';
            Description = 'PAB 1.0';
        }
        field(13; "Distributor E-mail"; Text[50])
        {
            Caption = 'Distributor E-mail';
            Description = '03-09-19 ZY-LD 002';

            trigger OnValidate()
            begin
                //>> 16-09-19 ZY-LD 003
                if "Distributor E-mail" <> '' then begin
                    "Distributor E-mail" := ZGT.ValidateEmailAdd("Distributor E-mail");
                    MailMgt.CheckValidEmailAddresses("Distributor E-mail");
                end;
                //<< 16-09-19 ZY-LD 003
            end;
        }
        field(14; "End User E-mail"; Text[50])
        {
            Caption = 'End User E-mail';
            Description = '03-09-19 ZY-LD 002';

            trigger OnValidate()
            begin
                //>> 16-09-19 ZY-LD 003
                if "End User E-mail" <> '' then begin
                    "End User E-mail" := ZGT.ValidateEmailAdd("End User E-mail");
                    MailMgt.CheckValidEmailAddresses("End User E-mail");
                end;
                //<< 16-09-19 ZY-LD 003
            end;
        }
        field(15; "EiCard To E-mail 2"; Text[250])
        {
            Caption = 'Extra E-mail 1';
            Description = '03-09-19 ZY-LD 002';

            trigger OnValidate()
            begin
                //>> 16-09-19 ZY-LD 003
                if "EiCard To E-mail 2" <> '' then begin
                    "EiCard To E-mail 2" := ZGT.ValidateEmailAdd("EiCard To E-mail 2");
                    MailMgt.CheckValidEmailAddresses("EiCard To E-mail 2");
                end;
                //<< 16-09-19 ZY-LD 003
            end;
        }
        field(16; "EiCard To E-mail 3"; Text[250])
        {
            Caption = 'Extra E-mail 2';
            Description = '03-09-19 ZY-LD 002';

            trigger OnValidate()
            begin
                //>> 16-09-19 ZY-LD 003
                if "EiCard To E-mail 3" <> '' then begin
                    "EiCard To E-mail 3" := ZGT.ValidateEmailAdd("EiCard To E-mail 3");
                    MailMgt.CheckValidEmailAddresses("EiCard To E-mail 3");
                end;
                //<< 16-09-19 ZY-LD 003
            end;
        }
        field(17; "EiCard To E-mail 4"; Text[250])
        {
            Caption = 'Extra E-mail 3';
            Description = '03-09-19 ZY-LD 002';

            trigger OnValidate()
            begin
                //>> 16-09-19 ZY-LD 003
                if "EiCard To E-mail 4" <> '' then begin
                    "EiCard To E-mail 4" := ZGT.ValidateEmailAdd("EiCard To E-mail 4");
                    MailMgt.CheckValidEmailAddresses("EiCard To E-mail 4");
                end;
                //<< 16-09-19 ZY-LD 003
            end;
        }
        field(19; "Sales Order Exists"; Boolean)
        {
            CalcFormula = exist("Sales Header" where("Document Type" = const(Order),
                                                      "No." = field("Sales Order No.")));
            Description = '03-09-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "From E-Mail Address"; Text[50])
        {
            Caption = 'From E-Mail Address';
            Description = '03-09-19 ZY-LD 002';
        }
        field(21; "From E-Mail Signature"; Text[50])
        {
            Caption = 'From E-Mail Signature';
            Description = '03-09-19 ZY-LD 002';
        }
        field(22; Active; Boolean)
        {
            Caption = 'Active';
            Description = '03-09-19 ZY-LD 002';

            trigger OnValidate()
            begin
                if Active then
                    "Creation Date" := CurrentDatetime;  // 20-09-19 ZY-LD 004
            end;
        }
        field(23; "E-mail is Sent to Customer"; DateTime)
        {
            Caption = 'E-mail is Sent to Customer';
            Description = '03-09-19 ZY-LD 002';
        }
        field(24; "Quantity Links"; Decimal)
        {
            CalcFormula = sum("EiCard Link Line".Quantity where("Purchase Order No." = field("Purchase Order No.")));
            Caption = 'Quantity Links';
            DecimalPlaces = 0 : 0;
            Description = '03-09-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Quantity Sales Order"; Decimal)
        {
            CalcFormula = sum("Sales Line".Quantity where("Document Type" = const(Order),
                                                           "Document No." = field("Sales Order No.")));
            Caption = 'Quantity Sales Order';
            DecimalPlaces = 0 : 0;
            Description = '03-09-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Size (Mb)"; Decimal)
        {
            CalcFormula = sum("EiCard Link Line"."Size (MB)" where("Purchase Order No." = field("Purchase Order No.")));
            Caption = 'Size (Mb)';
            Description = '03-09-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "No. of EiCard Link Lines"; Integer)
        {
            CalcFormula = count("EiCard Link Line" where("Purchase Order No." = field("Purchase Order No."),
                                                          "Item No." = field("Item No. Filter")));
            Caption = 'No. of EiCard Link Lines';
            Description = '03-09-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Vendor Invoice No."; Text[35])
        {
            CalcFormula = lookup("Purchase Header"."Vendor Invoice No." where("Document Type" = const(Order),
                                                                               "No." = field("Purchase Order No.")));
            Description = '03-09-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "No. of Sales Order Lines"; Integer)
        {
            CalcFormula = count("Sales Line" where("Document Type" = const(Order),
                                                    "Document No." = field("Sales Order No."),
                                                    Type = const(Item),
                                                    "No." = filter(<> '')));
            Caption = 'No. of Sales Order Lines';
            Description = '03-09-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
            Description = '20-09-19 ZY-LD 004';
            Editable = false;
        }
        field(31; "Reminder Sent"; Boolean)
        {
            Caption = 'Reminder Sent';
            Description = '20-09-19 ZY-LD 004';
        }
        field(32; "HQ Invoice Received"; Boolean)
        {
            CalcFormula = exist("HQ Invoice Header" where("Document Type" = const(Invoice),
                                                           "Purchase Order No." = field("Purchase Order No.")));
            Caption = 'HQ Invoice Received';
            Description = '20-09-19 ZY-LD 004';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Status Change Date Time"; DateTime)
        {
            CalcFormula = max("Change Log Entry"."Date and Time" where("Table No." = const(50036),
                                                                        "Primary Key Field 1 Value" = field("Sales Order No."),
                                                                        "Field No." = filter(6 | 7),
                                                                        "Type of Change" = const(Modification)));
            Caption = 'Status Change Date';
            Description = '04-10-19 ZY-LD 005';
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "Comparision of Qty and Link Ok"; Boolean)
        {
            Caption = 'Comparision of Quantity and Links Ok';
            Description = '04-10-19 ZY-LD 005';
        }
        field(35; "Purchase Order Deleted By"; Code[50])
        {
            Caption = 'Purchase Order Deleted By';
            Description = '04-10-19 ZY-LD 005';
        }
        field(36; "Invoice Reminder Sent"; Boolean)
        {
            Description = '21-01-19 ZY-LD 006';
        }
        field(37; "Eicard Type"; Option)
        {
            Caption = 'Eicard Type';
            Description = '18-02-20 ZY-LD 007';
            OptionCaption = ' ,Normal,Consignment,eCommerce';
            OptionMembers = " ",Normal,Consignment,eCommerce;
        }
        field(51; "Item No. Filter"; Code[20])
        {
            Caption = 'Item No. Filter';
            Description = '01-10-20 ZY-LD 008';
            FieldClass = FlowFilter;
            TableRelation = Item;
        }
        field(52; "Purchase Price Reminder Sent"; Boolean)
        {
            Caption = 'Purchase Price Reminder Sent';
            Description = '15-12-20 ZY-LD 009';
        }
        field(53; "Purchase Order Posted"; Boolean)
        {
            CalcFormula = exist("Purch. Inv. Header" where("Order No." = field("Purchase Order No.")));
            Caption = 'Purchase Order Posted';
            Description = '01-06-22 ZY-LD 010';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Sales Order No.")
        {
            Clustered = true;
        }
        key(Key2; "Purchase Order No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //>> 03-09-19 ZY-LD 002
        if ("Sales Order Status" > "sales order status"::Created) or ("Purchase Order Status" > "purchase order status"::Created) then
            Error(Text001);

        recEiCardLinkLine.SetRange("Purchase Order No.", "Purchase Order No.");
        recEiCardLinkLine.DeleteAll(true);

        // 07-02-24 ZY-LD 000 - Not allowed in BC
        /*recCngLogEntry.SetCurrentkey("Table No.", "Primary Key Field 1 Value");
        recCngLogEntry.SetRange("Table No.", Database::"EiCard Queue");
        recCngLogEntry.SetRange("Primary Key Field 1 Value", "Sales Order No.");
        recCngLogEntry.DeleteAll;*/
        //<< 03-09-19 ZY-LD 002
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;

        recEiCardUsers.SetFilter("User ID", UserId());
        if recEiCardUsers.FindFirst then begin
            "From E-Mail Address" := recEiCardUsers."E-Mail";
            "From E-Mail Signature" := recEiCardUsers."EMail Signature";
        end;
    end;

    trigger OnModify()
    begin
        //>> 03-09-19 ZY-LD 002
        if ("Sales Order Status" in ["sales order status"::Posted, "sales order status"::Cancled]) and
           ("Purchase Order Status" in ["purchase order status"::Posted, "purchase order status"::Cancled]) then
            Active := false;
        //<< 03-09-19 ZY-LD 002

        //>> 04-10-19 ZY-LD 005
        if not "Comparision of Qty and Link Ok" then begin
            CalcFields("Quantity Sales Order", "Quantity Links");
            "Comparision of Qty and Link Ok" := "Quantity Sales Order" = "Quantity Links";
        end;
        //<< 04-10-19 ZY-LD 005
    end;

    var
        Text001: label 'You canÍt delete the EiCard Queue %1, because itÍs in process.';
        recEiCardUsers: Record "User Setup";
        recEiCardLinkLine: Record "EiCard Link Line";
        recCngLogEntry: Record "Change Log Entry";
        MailMgt: Codeunit "Mail Management";
        ZGT: Codeunit "ZyXEL General Tools";


    procedure UpdateEiCardFields()
    var
        recPurchasesPayablesSetup: Record "Purchases & Payables Setup";
        recCust: Record Customer;
        Subject: Text[1024];
        shiptoinserted: Boolean;
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        if "Customer No." <> xRec."Customer No." then begin
            "Distributor E-mail" := '';
            "End User E-mail" := '';
            "EiCard To E-mail 2" := '';
            "EiCard To E-mail 3" := '';
            "EiCard To E-mail 4" := '';
            "EiCard To E-mail 4" := '';
        end;

        if recCust.Get("Customer No.") then begin
            if "Distributor E-mail" = '' then
                if recCust."EiCard Email Address" <> '' then begin
                    ZGT.ValidateEmailAdd(recCust."EiCard Email Address");
                    "Distributor E-mail" := recCust."EiCard Email Address";
                end;
            if "End User E-mail" = '' then
                if recCust."EiCard Email Address1" <> '' then begin
                    ZGT.ValidateEmailAdd(recCust."EiCard Email Address1");
                    "End User E-mail" := recCust."EiCard Email Address1";
                end;
            if "EiCard To E-mail 2" = '' then
                if recCust."EiCard Email Address2" <> '' then begin
                    ZGT.ValidateEmailAdd(recCust."EiCard Email Address2");
                    "EiCard To E-mail 2" := recCust."EiCard Email Address2";
                end;
            if "EiCard To E-mail 3" = '' then
                if recCust."EiCard Email Address3" <> '' then begin
                    ZGT.ValidateEmailAdd(recCust."EiCard Email Address3");
                    "EiCard To E-mail 3" := recCust."EiCard Email Address3";
                end;
            if "EiCard To E-mail 4" = '' then
                if recCust."EiCard Email Address4" <> '' then begin
                    ZGT.ValidateEmailAdd(recCust."EiCard Email Address4");
                    "EiCard To E-mail 4" := recCust."EiCard Email Address4";
                end;
        end;
    end;
}
