tableextension 50107 LocationZX extends Location
{
    // 001. 02-11-23 ZY-LD 000 - Post transfer order shipment when we receive from Taiwan.

    fields
    {
        field(50000; "Notification Email"; Text[250])
        {
            Description = 'PAB 1.0';
            ExtendedDatatype = EMail;
        }
        field(50001; "Confirmation Email"; Text[250])
        {
            Description = 'PAB 1.0';
            ExtendedDatatype = EMail;
        }
        field(50002; "In Use"; Boolean)
        {
            Description = 'PAB 1.0';
        }
        field(50003; "User for Intra Stat"; Boolean)
        {
            Caption = 'Use for Intra Stat';
            Description = '07-05-18 ZY-LD 002';
        }
        field(50004; "Warehouse Outbound FTP Code"; Code[20])
        {
            Caption = 'Warehouse Outbound FTP Code';
            Description = '22-02-19 ZY-LD 002';
            TableRelation = "FTP Folder";
        }
        field(50005; "Warehouse Inbound FTP Code"; Code[20])
        {
            Caption = 'Warehouse Inbound FTP Code';
            Description = '22-02-19 ZY-LD 002';
            TableRelation = "FTP Folder";
        }
        field(50006; Warehouse; Option)
        {
            Caption = 'Warehouse';
            Description = '22-02-19 ZY-LD 002';
            OptionCaption = ' ,VCK,VCK Block';
            OptionMembers = " ",VCK,"VCK Block";
        }
        field(50007; "Customer ID"; Text[10])
        {
            Caption = 'Customer ID';
            Description = '22-02-19 ZY-LD 002';
        }
        field(50008; "Project ID"; Code[10])
        {
            Caption = 'Project ID';
            Description = '22-02-19 ZY-LD 002';
        }
        field(50009; "Message Number Series"; Code[20])
        {
            Caption = 'Message Number Series';
            Description = '22-02-19 ZY-LD 002';
            TableRelation = "No. Series".Code;
        }
        field(50010; "Comp Name for Return SInvNo"; Text[10])
        {
            Caption = 'Company Name for Return Sales Invoice No.';
            Description = '12-07-19 ZY-LD 003';
            TableRelation = Company;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50011; "Include in Item Availability"; Option)
        {
            Caption = 'Include in Item Availability';
            Description = '16-11-20 ZY-LD 005';
            OptionCaption = ' ,OLAP,EMEA,OLAP & EMEA';
            OptionMembers = " ",OLAP,EMEA,"OLAP & EMEA";
        }
        field(50012; "Main Warehouse"; Boolean)
        {
            Caption = 'Main Warehouse';
            Description = '18-11-20 ZY-LD 006';
        }
        field(50013; "Ship-from Country/Region Code"; Code[10])
        {
            Caption = 'Purchase - Ship-from Country/Region Code';  // 02-05-24 - ZY-LD 000
            Description = '04-12-20 ZY-LD 007';
            TableRelation = "Country/Region";
        }
        field(50014; "Forecast Territory"; Code[20])
        {
            Description = '07-01-20 ZY-LD 008';
            TableRelation = "Forecast Territory";
        }
        field(50015; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code / Incoterms';
            Description = '07-01-20 ZY-LD 008';
            TableRelation = "Shipment Method";
        }
        field(50016; "Dimension Country Code"; Code[10])
        {
            Caption = 'Dimension Country Code';
            Description = '25-02-21 ZY-LD 009';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(50017; "Prevent Negative Inventory"; Boolean)
        {
            Caption = 'Prevent Negative Inventory';
            Description = '25-04-22 ZY-LD 010';
            InitValue = true;
        }
        field(50018; "Post Transf. Rcpt on Transit"; Boolean)
        {
            Caption = 'Post Transfer Receipt on Transit';
        }
        field(50019; "eCommerce Location"; Boolean)
        {
            Caption = 'eCommerce Location';
        }
        field(50020; "Use Ship-to Ctry on VAT Entry"; Boolean)
        {
            Caption = 'Use Ship-to Contry on VAT Entry';
            DataClassification = CustomerContent;
        }
        field(50021; "Post Transf. Ship. on Transit"; Boolean)  // 02-11-23 ZY-LD 001
        {
            Caption = 'Post Transfer Shipment on Transit';
        }
        field(50022; "Allow Unit Cost is Zero"; Boolean)
        {
            Caption = 'Allow Unit Cost to be Zero';
        }
        field(50023; "Default Return Reason Code"; Code[20])
        {
            Caption = 'Default Return Reason Code';
            TableRelation = "Return Reason";
        }
        field(50024; "Exclude from Intrastat Report"; Boolean)  // 12-04-24 ZY-LD 000
        {
            Caption = 'Exclude from Intrastat Report';
        }
        field(50025; "RMA Location"; Boolean)  // 06-09-24 ZY-LD 000
        {
            Caption = 'RMA Location';
        }
        field(62017; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            Description = 'Tectura Taiwan';
            OptionCaption = ' ,Normal,EICard,Drop Shipment,Other,Spec. Order,G/L Account,HaaS,eCommerce';  // 15-07-24 ZY-LD 000 - eCommerce is added.';
            OptionMembers = " ",Normal,EICard,"Drop Shipment",Other,"Spec. Order","G/L Account",HaaS,eCommerce;

            trigger OnValidate()
            var
                LEMSG000: Label 'Warning! Sales Order Type change may cause order trapped in process!!';
            begin
                //Tectura Taiwan ZL100526A+
                if (xRec."Sales Order Type" <> 0) then Message(LEMSG000);
                //Tectura Taiwan ZL100526A-
            end;
        }
        field(62018; "Default Order Type Location"; Boolean)
        {
            Description = 'Tectura Taiwan';
        }
        field(62019; "Inc. Item Availability"; Boolean)
        {
            Caption = 'Include in Item Availability (OLAP)';
        }
        field(62020; "Sales Order Type 2"; Option)
        {
            Caption = 'Sales Order Type 2';
            Description = '21-02-20 ZY-LD 004';
            OptionCaption = ' ,Normal,EICard,Drop Shipment,Other,Spec. Order,G/L Account,HaaS,eCommerce';  // 15-07-24 ZY-LD 000 - eCommerce is added.';
            OptionMembers = " ",Normal,EICard,"Drop Shipment",Other,"Spec. Order","G/L Account",HaaS,eCommerce;

            trigger OnValidate()
            var
                LEMSG000: Label 'Warning! Sales Order Type change may cause order trapped in process!!';
            begin
                //Tectura Taiwan ZL100526A+
                if (xRec."Sales Order Type 2" <> 0) then Message(LEMSG000);
                //Tectura Taiwan ZL100526A-
            end;
        }
        field(66001; "Send With DSV"; Boolean)
        {
        }
        field(67001; "DSV Location Code"; Code[10])
        {
        }
        field(67002; "VAT Registration No"; Text[30])
        {
        }
        field(67003; "Header Action Code"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(67004; "Line Action Code"; Text[50])
        {
            Description = 'PAB 1.0';
        }
        field(67005; "Delivery Zone"; Option)
        {
            Description = 'PAB 1.0';
            OptionCaption = 'Zone 1,Zone 2,Zone 3,Zone 4,Zone 5,Zone 6,Zone 7,Zone 8,Zone 9,Zone 10';
            OptionMembers = "Zone 1","Zone 2","Zone 3","Zone 4","Zone 5","Zone 6","Zone 7","Zone 8","Zone 9","Zone 10";
        }
        field(67006; zNetZComcode; code[10])
        {
            Caption = 'zNet / zCom location translate';
            Description = 'translate between zNet and zCom location code between znet <> zCom';
        }
    }
}
