Table 50047 "Transfer-to Address"
{
    // 001. 21-09-17 ZY-LD 000 - Error if & is used in the code field.
    // 002. 16-10-19 ZY-LD 000 - New fields for implementing communication with France. The fileds might be deleted after 01-01-2020.
    // 003. 09-07-20 ZY-LD P0455 - Filter set on "Shipment Method Code".
    // 004. 09-07-20 ZY-LD P0455 - Caption on "Shipment Method Code" has changed to "Shipment Method Code / Incoterms".
    // 005. 05-10-20 ZY-LD P0452 - New field.

    Caption = 'Transfer-to Address';
    DataCaptionFields = "Location Code", Name, "Code";
    LookupPageID = "Transfer-to Address List";

    fields
    {
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(8; Contact; Text[50])
        {
            Caption = 'Contact';
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Telex No."; Text[30])
        {
            Caption = 'Telex No.';
        }
        field(30; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code / Incoterms';
            TableRelation = "Shipment Method";
        }
        field(31; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                if "Shipping Agent Code" <> xRec."Shipping Agent Code" then
                    Validate("Shipping Agent Service Code", '');
            end;
        }
        field(32; "Place of Export"; Code[20])
        {
            Caption = 'Place of Export';
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(54; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(83; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(84; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(85; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(92; County; Text[30])
        {
            Caption = 'County';
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(103; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(108; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(109; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(5792; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
        }
        field(5900; "Service Zone Code"; Code[10])
        {
            Caption = 'Service Zone Code';
            TableRelation = "Service Zone";
        }
        field(50002; "External Customer No."; Code[20])
        {
            Caption = 'External Customer No.';
            Description = '16-10-19 ZY-LD 002';
        }
        field(50003; "External Ship-to Code"; Code[10])
        {
            Caption = 'External Ship-to Code';
            Description = '16-10-19 ZY-LD 002';
        }
        field(50004; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
            Description = '05-10-20 ZY-LD 003';
        }
    }

    keys
    {
        key(Key1; "Location Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Name, Address, City, "Post Code")
        {
        }
    }

    trigger OnInsert()
    begin
        recLocation.Get("Location Code");
        Name := recLocation.Name;

        //>> 21-09-17 ZY-LD 001
        if StrPos(Code, '&') <> 0 then
            Error(Text001, FieldCaption(Code));
        //<< 21-09-17 ZY-LD 001
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Text000: label 'untitled';
        recLocation: Record Location;
        PostCode: Record "Post Code";
        Text001: label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';


    procedure Caption(): Text[130]
    begin
        if "Location Code" = '' then
            exit(Text000);
        recLocation.Get("Location Code");
        exit(StrSubstNo('%1 %2 %3 %4', recLocation.Code, recLocation.Name, Code, Name));
    end;


    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.FindFirst then
            MapMgt.MakeSelection(Database::"Ship-to Address", GetPosition)
        else
            Message(Text001);
    end;
}
