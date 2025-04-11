Table 66006 "Default Action"
{
    // 001. 12-01-18 ZY-LD 2018011210000094 - New field.
    // 002. 13-03-19 ZY-LD 2019022010000075 - New field.
    // 003. 25-02-20 ZY-LD P0398 - New field.
    // 004. 23-03-20 ZY-LD 000 - Set Sales Order Type.
    // 005. 04-02-22 ZY-LD 2022020310000074 - Key is changed from "Source Type,Comment Type,Sequence" to "Source Type,Source Code,Comment Type,Sequence".

    LookupPageID = "Default Action Code";

    fields
    {
        field(1; "Source Type"; Option)
        {
            Caption = 'Source Type';
            Description = 'PAB 1.0';
            OptionCaption = ' ,Customer,Ship-to Address,Item,Location,Transfer-to Address';
            OptionMembers = " ",Customer,"Ship-to Address",Item,Location,"Transfer-to Address";
        }
        field(2; "Source Code"; Code[20])
        {
            Caption = 'Source Code';
            Description = 'PAB 1.0';
            TableRelation = if ("Source Type" = const(Item)) Item
            else
            if ("Source Type" = const(Customer)) Customer
            else
            if ("Source Type" = const("Ship-to Address")) "Ship-to Address".Code
            else
            if ("Source Type" = const(Location)) Location;
        }
        field(3; "Action Code"; Code[10])
        {
            Caption = 'Action Code';
            Description = 'PAB 1.0';
            TableRelation = "Action Codes";

            trigger OnValidate()
            begin
                CalcFields("Action Description");

                case "Source Type" of
                    "source type"::Customer:
                        begin
                            recDefaultAction.SetRange("Source Type", "source type"::"Ship-to Address");
                            recDefaultAction.SetRange("Customer No.", "Customer No.");
                            recDefaultAction.SetRange("Action Code", "Action Code");
                            recDefaultAction.SetRange("Header / Line", "Header / Line");
                            if recDefaultAction.FindFirst then
                                if Confirm(Text001, false, "Action Code", recDefaultAction.Count, "Customer No.") then
                                    recDefaultAction.DeleteAll(true);
                        end;
                    "source type"::"Ship-to Address":
                        begin
                            recDefaultAction.SetRange("Source Type", "source type"::Customer);
                            recDefaultAction.SetRange("Source Code", "Customer No.");
                            recDefaultAction.SetRange("Action Code", "Action Code");
                            recDefaultAction.SetRange("Header / Line", "Header / Line");
                            if recDefaultAction.FindFirst then
                                Error(Text002, "Action Code");
                        end;
                end;

                //>> 23-03-20 ZY-LD 004
                recActCode.Get("Action Code");
                if recActCode."Sales Order Type" > recActCode."sales order type"::" " then
                    Validate("Sales Order Type", recActCode."Sales Order Type");
                //<< 23-03-20 ZY-LD 004
                Validate("Comment Type", recActCode."Default Comment Type");
            end;
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = 'PAB 1.0';
        }
        field(5; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            Description = '12-01-18 ZY-LD 001';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Action Description"; Text[150])
        {
            CalcFormula = lookup("Action Codes".Description where(Code = field("Action Code")));
            Caption = 'Action Description';
            Description = '13-03-19 ZY-LD 002';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Header / Line"; Option)
        {
            Caption = 'Header / Line';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(8; Sequence; Integer)
        {
            BlankZero = true;
            Caption = 'Sequence';
            MaxValue = 100;
            MinValue = 0;
        }
        field(9; "Comment Type"; Option)
        {
            Caption = 'Comment Type';
            OptionCaption = 'General,Picking,Packing,Transport,Export,Customer,,,E-mail Notification (Pre-Adv),,,,E-mail Slot-Request';
            OptionMembers = General,Picking,Packing,Transport,Export,Customer,SAP,"E-mail Confirmation","E-mail Notification","E-mail Exceptation","E-mail Pre-Alert","E-mail Ready for Pickup","E-mail Slot-Request";

            trigger OnValidate()
            begin
                if not Modify(true) then;
            end;
        }
        field(10; "E-mail at Status WaitForInv"; Boolean)
        {
            Caption = 'E-mail at "Waiting for Invoice".';
        }
        field(11; "Insert Blank After This Line"; Boolean)
        {
            Caption = 'Insert Blank After This Line';
        }
        field(12; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            Description = '25-02-20 ZY-LD 003';
            OptionCaption = ' ,,,,,Spec. Order';
            OptionMembers = " ",,,,,"Spec. Order";

            trigger OnValidate()
            var
                LEMSG000: label 'Sales Order Type can not be change!';
                LocationRec: Record Location;
                LEMSG001: label 'Sales Order Type %1 can not match with Location %2!';
                LEMSG002: label 'Location %1 not exist!';
                LEMSG003: label 'Can not find default location for Sales Order Type %1!';
                SOLine: Record "Sales Line";
                Item: Record Item;
                LEMSG004: label 'Item %1 is not match %2!';
                LEMSG005: label 'Document Type should be Order or Invoice!';
            begin
            end;
        }
        field(13; "Customer Exist"; Boolean)
        {
            BlankZero = true;
            CalcFormula = exist(Customer where("No." = field("Source Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Ship-to Address Exist"; Boolean)
        {
            BlankZero = true;
            CalcFormula = exist("Ship-to Address" where("Customer No." = field("Customer No."),
                                                         Code = field("Source Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "End Date"; Date)
        {
            CalcFormula = lookup("Action Codes"."End Date" where(Code = field("Action Code")));
            Caption = 'End Date';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Source Type", "Source Code", "Customer No.", "Action Code")
        {
            Clustered = true;
        }
        key(Key2; "Source Type", "Source Code", "Comment Type", Sequence)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Confirmed: Boolean;
    begin
        recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Open);
        recDelDocHead.SetRange("Sell-to Customer No.", "Customer No.");
        if "Source Type" = "source type"::"Ship-to Address" then
            recDelDocHead.SetRange("Ship-to Code", StrSubstNo('%1.%2', "Customer No.", "Source Code"));
        if recDelDocHead.FindSet then
            repeat
                recDelDocAction.SetRange("Delivery Document No.", recDelDocHead."No.");
                recDelDocAction.SetRange("Action Code", "Action Code");
                if recDelDocAction.FindFirst then
                    if Confirmed then
                        recDelDocAction.Delete(true)
                    else
                        if Confirm(Text004, true, "Action Code") then begin
                            recDelDocAction.Delete(true);
                            Confirmed := true;
                        end;
            until recDelDocHead.Next() = 0;
    end;

    trigger OnInsert()
    begin
        recDelDocHead.SetRange("Document Status", recDelDocHead."document status"::Open);
        recDelDocHead.SetRange("Sell-to Customer No.", "Customer No.");
        if "Source Type" = "source type"::"Ship-to Address" then
            recDelDocHead.SetRange("Ship-to Code", StrSubstNo('%1.%2', "Customer No.", "Source Code"));
        if recDelDocHead.FindSet then
            if Confirm(Text003, true, "Action Code") then
                repeat
                    recDelDocAction.InitLine(Rec);
                    recDelDocAction."Delivery Document No." := recDelDocHead."No.";
                    if not recDelDocAction.Insert then;
                until recDelDocHead.Next() = 0;
    end;

    var
        recActCode: Record "Action Codes";
        recDefaultAction: Record "Default Action";
        Text001: label 'Action Code "%1" is located on one or more "Ship-to Adresses".\Do you want to delete %2 action code(s) "%1" for customer no. %3 on "Ship-to Address"?';
        Text002: label 'Action Code "%1" is already created on the customer.';
        recDelDocHead: Record "VCK Delivery Document Header";
        recDelDocAction: Record "Delivery Document Action Code";
        Text003: label 'Do you want to update open delivery documents with the code %1?';
        Text004: label 'Do you want to remove action code "%1" from open delivery documents?';
}
