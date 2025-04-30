tableextension 50110 CustomerZX extends Customer
{
    fields
    {
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        field(50000; "Related Company"; Boolean)
        {
        }
        field(50001; "Do Not Change Bill-to Cust No."; Boolean)
        {
            Caption = 'Do Not Change Bill-to Customer No.';
            Description = 'Unused';
        }
        field(50002; "Select Currency Code"; Boolean)
        {
            Caption = 'Select Currency Code';
        }
        field(50003; "Customer Contract"; Boolean)
        {
            CalcFormula = exist("Customer Contract" where("Customer No." = field("No.")));
            Caption = 'Customer Contract';
            Description = 'Unused';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Exclude Wee Report"; Boolean)
        {
            Caption = 'Exclude Wee Report';
            Description = '02-03-18 ZY-LD 012';
        }
        field(50005; "Statement Type"; Option)
        {
            Caption = 'Statement Type';
            Description = '21-03-18 ZY-LD 013';
            InitValue = Standard;
            OptionMembers = " ",Standard,"Ri.Ba.";
        }
        field(50006; "Exclude from Intrastat"; Boolean)
        {
            Caption = 'Exclude from Intrastat';
            Description = '02-03-18 ZY-LD 012';
        }
        field(50007; "VAT Registration Code"; Code[10])
        {
            TableRelation = "IC Vendors";
        }
        field(50008; "Enable Forecasting"; Boolean)
        {
            Description = 'Unused';
        }
        field(50009; "Automatic SP Items"; Boolean)
        {
            Description = 'Unused';
        }
        field(50010; Incoterms; Text[50])
        {
            Description = 'Unused';
        }
        field(50011; "Has Forecast Items"; Boolean)
        {
            Description = 'Unused';
        }
        field(50012; "EiCard Email Address"; Text[50])
        {
            Caption = 'Distributor E-mail';
            Description = 'PAB 1.0';
            ExtendedDatatype = EMail;
        }
        field(50013; "EiCard Send HTML Email"; Boolean)
        {
            Description = 'Unused';
            InitValue = true;
        }
        field(50014; "EiCard Add Dist Ref to Subject"; Boolean)
        {
            Description = 'Unused';
        }
        field(50015; "EiCard Add Customer to Subject"; Boolean)
        {
            Description = 'Unused';
        }
        field(50016; "EiCard Add Order No to Subject"; Boolean)
        {
            Description = 'Unused';
        }
        field(50017; "EiCard Email Address1"; Text[50])
        {
            Description = 'PAB 1.0';
            ExtendedDatatype = EMail;
        }
        field(50018; "EiCard Email Address2"; Text[50])
        {
            Caption = 'EiCard Email Address 2';
            Description = 'PAB 1.0';
            ExtendedDatatype = EMail;
        }
        field(50019; "EiCard Email Address3"; Text[50])
        {
            Caption = 'EiCard Email Address 3';
            Description = 'PAB 1.0';
            ExtendedDatatype = EMail;
        }
        field(50020; "EiCard Email Address4"; Text[50])
        {
            Caption = 'EiCard Email Address 4';
            Description = 'PAB 1.0';
            ExtendedDatatype = EMail;
        }
        field(50021; "Supervisor Password eShop"; Text[20])
        {
            Caption = 'Supervisor Password eShop';
            Description = '10-08-20 ZY-LD 034';
        }
        field(50022; "Confirmation E-Mail"; Text[250])
        {
            Description = 'Unused';
            ExtendedDatatype = EMail;
        }
        field(50023; "Action Code Source"; Option)
        {
            Description = 'Unused';
            InitValue = "Sell-to Customer";
            OptionCaption = 'Sell-to Customer,Ship-to Customer';
            OptionMembers = "Sell-to Customer","Ship-to Customer";
        }
        field(50024; "Delivery Zone"; Option)
        {
            Description = 'Unused';
            OptionCaption = 'Zone 1,Zone 2,Zone 3,Zone 4,Zone 5,Zone 6,Zone 7,Zone 8,Zone 9,Zone 10';
            OptionMembers = "Zone 1","Zone 2","Zone 3","Zone 4","Zone 5","Zone 6","Zone 7","Zone 8","Zone 9","Zone 10";
        }
        field(50025; "Delivery Days"; Integer)
        {
            Description = 'Unused';
        }
        field(50026; "Your Reference Translation"; Option)
        {
            Caption = 'Your Reference Translation';
            Description = '15-09-21 ZY-LD 039';
            OptionMembers = " ","Purchase Order No.";
        }
        field(50027; "E-mail for Order Scanning"; Text[30])
        {
            Caption = 'E-mail for Order Scanning';
            Description = '04-11-20 ZY-LD 035';
            ExtendedDatatype = EMail;
        }
        field(50028; "Download and Attach Eicards"; Boolean)
        {
            Caption = 'Download and Attach Eicards to E-mail';
        }
        field(50029; "Minimum Order Value Enabled"; Boolean)
        {
            Caption = 'Min. Order Value Enabled';
            Description = 'PAB 1.0';
        }
        field(50030; "Minimum Order Value (LCY)"; Decimal)
        {
            Caption = 'Min. Order Value (LCY)';
            Description = 'PAB 1.0';
            InitValue = 8.000;
        }
        field(50031; "Full Pallet Ordering Enabled"; Boolean)
        {
            Caption = 'Min. Carton Qty. Enabled';
            Description = 'PAB 1.0';
        }
        field(50032; "Full Pallet Ordering Rounding"; Option)
        {
            Caption = 'Carton Rounding';
            Description = 'PAB 1.0';
            InitValue = "Round Down";
            OptionCaption = 'Round Up,Round Down';
            OptionMembers = "Round Up","Round Down";
        }
        field(50033; "Turkish Customer No."; Code[20])
        {
            Caption = 'Turkish Customer No.';
            Description = '25-01-17 ZY-LD 011';
        }
        field(50034; "Set Eicard Type on Sales Order"; Boolean)
        {
            Caption = 'Set Eicard Type on Sales Order';
            Description = '18-02-20 ZY-LD 030';
        }
        field(50035; "Skip Posting Group Validation"; Boolean)
        {
            Caption = 'Skip Posting Group Validation';
            Description = '22-06-21 ZY-LD 038';
        }
        field(50036; "Forecast Territory"; Code[20])
        {
            Caption = 'Forecast Territory';
            Description = 'PAB 1.0';
            Editable = false;
            TableRelation = "Forecast Territory";
        }
        field(50037; "Outst. Orders Sell-to (LCY)"; Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            AutoFormatType = 1;
            CalcFormula = sum("Sales Line"."Outstanding Amount (LCY)" where("Document Type" = const(Order),
                                                                            "Sell-to Customer No." = field("No."),
                                                                            "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                            "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                            "Currency Code" = field("Currency Filter")));
            Caption = 'Outstanding Orders Sell-to (LCY)';
            Description = '08-11-18 ZY-LD 020';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50038; "Unblock Pick.Date Restriction"; Boolean)
        {
            Caption = 'Unblock Pickking Date Restriction';
            Description = '21-08-19 ZY-LD 025';
        }
        field(50039; "E-mail Sales Documents"; Boolean)
        {
            Caption = 'E-mail Sales Documents';
            Description = '25-09-19 ZY-LD 026';
            InitValue = true;
        }
        field(50040; "Intercompany Purchase"; Code[10])
        {
            TableRelation = "Intercompany Purchase Code";
        }
        field(50041; "Post EiCard Invoice Automatic"; Option)
        {
            Caption = 'Post EiCard Invoice Automatic';
            Description = '28-10-19 ZY-LD 027';
            InitValue = "Yes (when purchase invoice is posted)";
            OptionCaption = ' ,Yes (when purchase invoice is posted),Yes (when EiCard links is sent to the customer)';
            OptionMembers = " ","Yes (when purchase invoice is posted)","Yes (when EiCard links is sent to the customer)";
        }
        field(50042; "Mark Inv. and Cr.M as Printed"; Boolean)
        {
            Caption = 'Mark Invice and Cr. Memo as Printed';
            Description = '25-09-19 ZY-LD 026';
        }
        field(50043; "Delay Btw. Post and Send Email"; Integer)
        {
            Caption = 'Delay Between Post to Send E-mail (Min.)';
            Description = '14-11-19 ZY-LD 028';
            MaxValue = 1440;
            MinValue = 0;
        }
        field(50044; "Automatic Invoice Handling"; Option)
        {
            Caption = 'Automatic Invoice Handling';
            Description = '14-11-19 ZY-LD 028';
            OptionMembers = " ","Create Invoice","Create and Post Invoice";
        }
        field(50045; "Create Invoice pr. Order"; Boolean)
        {
            Caption = 'Create Invoice pr. Order';
            Description = '16-06-20 ZY-LD 032';
        }
        field(50046; "EORI No."; Code[15])
        {
            Caption = 'EORI No.';
            Description = '25-01-21 ZY-LD 037';
        }
        field(50047; "Customs Broker"; Code[10])
        {
            Caption = 'Customs Broker';
            Description = '25-01-21 ZY-LD 037';
            TableRelation = "Customs Broker";
        }
        field(50050; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            Description = 'CO4.20';
        }
        field(50051; "Additional Items"; Boolean)
        {
            Caption = 'Additional Items';
            Description = '20-11-18 ZY-LD 023';
        }
        field(50052; "SDI No."; Code[20])
        {
            Caption = 'SDI No.';
            Description = '27-11-18 ZY-LD 024';
        }
        field(50053; "SDI Recipient Code"; Code[10])
        {
            Caption = 'SDI Recipient Code';
            Description = '27-11-18 ZY-LD 024';
        }
        field(50054; "PEC E-mail Address IT"; Text[50])
        {
            Caption = 'PEC E-mail Address';
            Description = '27-11-18 ZY-LD 024';
        }
        field(50055; "Approval No. must be Filled"; Boolean)
        {
            Caption = 'Approval No. on Sales Line must be Filled';
            Description = '30-01-20 ZY-LD 006';
        }
        field(50056; "Create Delivery Doc. pr. Order"; Boolean)
        {
            Caption = 'Create Delivery Doc. pr. Order';
            Description = '03-11-21 ZY-LD 040';
        }
        field(50057; "Run Auto. Inv. Hand. on WaitFI"; Boolean)
        {
            Caption = 'Run Auto. Inv. Hand. on Waiting for Invoice';
            Description = '03-12-21 ZY-LD 041';
        }
        field(50058; "E-mail Shipping Inv. to Whse."; Boolean)
        {
            Caption = 'E-mail Shipping Inv. to Warehouse';
            Description = '26-10-21 ZY-LD 011';
        }
        field(50059; "Attach Pallet No. to Serial No"; Boolean)
        {
            Caption = 'Attach Pallet No. to Serial No.';
            Description = '26-01-22 ZY-LD 042';
        }
        field(50060; "Exclude from Forecast"; Boolean)
        {
            Description = '16-02-22 ZY-LD 043';
        }
        field(50061; "E-mail Deliv. Note at Release"; Boolean)
        {
            Caption = 'E-mail Delivery Note at Release';
            Description = '03-03-22 ZY-LD 044';
        }
        field(50062; "E-mail Chemical Report"; Boolean)
        {
            Caption = 'E-mail Chemical Report';
            Description = '02-06-22 ZY-LD 045';
        }
        field(50063; "E-mail for Chemical Report"; Text[30])
        {
            Caption = 'E-mail for Chemical Report';
            Description = '02-06-22 ZY-LD 045';
            ExtendedDatatype = EMail;
        }
        field(50064; "Last Chemical Report Sent"; Date)
        {
            Caption = 'Last Chemical Report Sent';
            Description = '02-06-22 ZY-LD 045';
        }
        field(50065; "Order Desk Resposible Code"; Code[20])
        {
            Caption = 'Order Desk Resposible Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50066; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
        field(50067; "Fiscal Code IT"; Text[20])
        {
            Caption = 'Fiscal Code';
            Description = '25-05-23 ZY-LD 046';
        }
        field(50068; "NL to DK Rev. Charge"; Boolean)  // 13-03-24 ZY-LD 000
        {
            Caption = 'NL to DK Reverse Charge';
        }
        field(50069; "Sample Account"; Boolean)
        {
            Caption = 'Sample Account';
        }
        field(50070; "End User Email Expected"; Boolean)
        {
            Caption = 'End User Email Expected';
        }
        field(50071; "KYC Last Checked"; Date)
        {
            Caption = 'Know your Customer Last Checked';
        }

        // 463541 >>
        field(50072; "Warning on Not-delivery"; Boolean)
        {
            Caption = 'Warning on invocing for not-delivery on DD';
        }
        // 463541 <<
        field(50073; "AMAZONID"; Code[10])
        {
            caption = 'Amazon party id';
            Description = 'Amazon party id';
        }



        field(55025; "Creation Date"; Date)
        {
            Description = 'Unused';
        }
        field(55026; "Modified Date"; Date)
        {
            Description = 'Unused';
        }
        field(55027; "Created By"; Code[50])
        {
            Description = 'Unused';
        }
        field(55028; "Modified By"; Code[50])
        {
            Description = 'Unused';
        }
        field(55029; "E-Mail Statement Address"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(55030; "E-Mail Reminder Address"; Text[250])
        {
            Description = 'PAB 1.0';
        }
        field(55031; "E-Mail Statement"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(55032; "E-Mail Reminder"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(55033; Category; Option)
        {
            Caption = 'Risk Assesment';
            OptionCaption = ' ,A,B,C,D';
            OptionMembers = " ",A,B,C,D;
        }
        field(55034; Tier; Code[10])
        {
            Description = 'PAB 1.0';
        }
        field(55035; "Parrent Name"; Text[30])
        {
            Caption = 'Parrent Account';
            Description = 'Unused';
        }
        field(61300; "Administration Reference"; Code[20])
        {
            Caption = 'Administration Reference';
            Description = 'FRA';
        }
        field(61301; "Recipient Code"; Code[10])
        {
            Caption = 'Recipient Code';
            Description = 'FRA';
        }
        field(61302; "Customer Tipology"; Option)
        {
            Caption = 'Customer Tipology';
            Description = 'FRA';
            OptionCaption = 'Private Customer,Public Customer';
            OptionMembers = "Private Customer","Public Customer";
        }
        field(61303; "Recipient PEC E-Mail"; Text[80])
        {
            Caption = 'Recipient PEC E-Mail';
            Description = 'FPA.030918';
        }
        field(62007; "Notification E-Mail"; Text[250])
        {
            Caption = 'Notification E-Mail';
            Description = 'Unused';
            ExtendedDatatype = EMail;
        }
        field(62016; "Mailing Group Code"; Code[50])
        {
            Description = 'Unused';
        }
        field(62050; Monday; Boolean)
        {
            Description = 'Unused';
        }
        field(62051; Tuesday; Boolean)
        {
            Description = 'Unused';
        }
        field(62052; Wednesday; Boolean)
        {
            Description = 'Unused';
        }
        field(62053; Thursday; Boolean)
        {
            Description = 'Unused';
        }
        field(62054; Friday; Boolean)
        {
            Description = 'Unused';
        }
        field(67000; "Avoid Creation of SI in SUB"; Boolean)
        {
            Caption = 'Avoid Creation of IC Sales Invoice in SUB';
        }
        field(67001; "Sub company"; Boolean)
        {
        }
        field(67002; "Batch Posting"; Option)
        {
            Description = 'Unused';
            OptionCaption = 'Daily,Monthly,Price Dependent';
            OptionMembers = Daily,Monthly,"Price Dependent";
        }
        field(67003; Abbreviation; Text[50])
        {
            Description = 'Unused';
        }
        field(67004; "FCST Region ID"; Option)
        {
            OptionMembers = " ",ZyND,ZyCZ,ZyDE,ZyBNL,ZyUK,Partner,"EM RBU",OTHERS;
        }
        field(67005; "Customer Business Type"; Option)
        {
            Description = 'Unused';
            OptionMembers = " ",CH,SP,KA;
        }
        field(67006; "Is in FCST Separately"; Boolean)
        {
            Description = 'Unused';
        }
        field(67007; "Currency Code in Sales Order"; Boolean)
        {
            Description = 'Unused';
        }
        field(67008; "Forecast visibility"; Boolean)
        {
            Description = 'Unused';
        }
        field(67009; "Sales FCST Consumption"; Code[20])
        {
            Description = 'Unused';
        }
        field(67010; "Express Picking"; Boolean)
        {
            Description = 'Unused';
        }
        field(67011; "Tax Office Code"; Code[20])
        {
            Caption = 'Tax Office Code';
            Description = 'PAB 1.0';
            TableRelation = "Tax Office ZY";
        }
        field(67012; "VAT ID"; Text[20])
        {
            Caption = 'VAT ID';
            Description = 'PAB 1.0';
        }
        field(67013; "Use E-Invoice"; Boolean)
        {
            Caption = 'Use E-Invoice';
            Description = '11-10-18 ZY-LD 019';
            Editable = false;
        }
        field(67014; "E-Invoice Profile ID"; Option)
        {
            Caption = 'E-Invoice Profile ID';
            Description = '11-10-18 ZY-LD 019';
            OptionCaption = ' ,Basic Invoice,Commercial Invoice';
            OptionMembers = " ","Basic Invoice","Commercial Invoice";
        }
        field(67015; "RHQ Customer No"; Code[20])
        {
            Description = 'Unused';
        }
        field(70000; BacklogEmailAddress; Text[80])
        {
            Caption = 'Backlog Email Address';
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }
    }

    fieldgroups
    {
        addlast(DropDown; "Global Dimension 1 Code")
        {
        }
    }
}
