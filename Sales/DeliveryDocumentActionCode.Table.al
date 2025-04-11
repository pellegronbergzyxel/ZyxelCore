Table 66007 "Delivery Document Action Code"
{
    // 001. 12-01-18 ZY-LD 2018011210000094 - New field.
    // 002. 13-03-19 ZY-LD 2019022010000075 - New field.
    // 003. 23-06-22 ZY-LD 2022062210000067 - Correction.

    Caption = 'Delivery Document Action Code';

    fields
    {
        field(1; "Delivery Document No."; Code[20])
        {
        }
        field(3; "Action Code"; Code[10])
        {
            Caption = 'Action Code';
            TableRelation = "Action Codes";

            trigger OnValidate()
            begin
                CalcFields("Action Description");
                //>> 23-06-22 ZY-LD 003
                if recActCode.Get("Action Code") then
                    Validate("Comment Type", recActCode."Default Comment Type")
                //ELSE
                //  "Comment Type" := "Comment Type"::General;
                //<< 23-06-22 ZY-LD 003
            end;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Action Description"; Text[150])
        {
            CalcFormula = lookup("Action Codes".Description where(Code = field("Action Code")));
            Caption = 'Action Description';
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
            OptionCaption = 'General,Picking,Packing,Transport,Export,Customer,SAP,E-mail Confirmation,E-mail Notification,E-mail Exceptation,E-mail Pre-Alert,E-mail Slot-Request,Ready for Pickup';
            OptionMembers = General,Picking,Packing,Transport,Export,Customer,SAP,"E-mail Confirmation","E-mail Notification","E-mail Exceptation","E-mail Pre-Alert","E-mail Slot-Request","Ready for Pickup";

            trigger OnValidate()
            begin
                if not Modify(true) then;
            end;
        }
        field(11; "Insert Blank After This Line"; Boolean)
        {
            Caption = 'Insert Blank After This Line';
        }
        field(12; "Warehouse Status"; Option)
        {
            CalcFormula = lookup("VCK Delivery Document Header"."Warehouse Status" where("No." = field("Delivery Document No.")));
            Caption = 'Warehouse Status';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'New,Backorder,Ready to Pick,Picking,Packed,Waiting for invoice,Invoice Received,Posted,In Transit,Delivered,Error';
            OptionMembers = New,Backorder,"Ready to Pick",Picking,Packed,"Waiting for invoice","Invoice Received",Posted,"In Transit",Delivered,Error;

            trigger OnValidate()
            var
                recDelDocLine: Record "VCK Delivery Document Line";
            begin
            end;
        }
    }

    keys
    {
        key(Key1; "Delivery Document No.", "Action Code")
        {
            Clustered = true;
        }
        key(Key2; "Delivery Document No.", "Comment Type", Sequence)
        {
        }
    }

    fieldgroups
    {
    }

    var
        recDefaultAction: Record "Default Action";
        Text001: label 'Action Code "%1" is located on one or more "Ship-to Adresses".\Do you want to delete %2 action code(s) "%1" for customer no. %3 on "Ship-to Address"?';
        Text002: label 'Action Code "%1" is already created on the customer.';
        recActCode: Record "Action Codes";


    procedure InitLine(pDefAction: Record "Default Action")
    begin
        Clear(Rec);
        Init;
        "Action Code" := pDefAction."Action Code";
        "Header / Line" := pDefAction."Header / Line";
        Sequence := pDefAction.Sequence;
        "Comment Type" := pDefAction."Comment Type";
        "Insert Blank After This Line" := pDefAction."Insert Blank After This Line";
    end;
}
