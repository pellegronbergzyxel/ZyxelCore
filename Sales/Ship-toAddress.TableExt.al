tableextension 50139 ShipToAddressZX extends "Ship-to Address"
{
    fields
    {
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code / Incoterms';
        }
        field(50000; "Delivery Zone"; Option)
        {
            Description = 'Unused';
            OptionCaption = 'Zone 1,Zone 2,Zone 3,Zone 4,Zone 5,Zone 6,Zone 7,Zone 8,Zone 9,Zone 10';
            OptionMembers = "Zone 1","Zone 2","Zone 3","Zone 4","Zone 5","Zone 6","Zone 7","Zone 8","Zone 9","Zone 10";
        }
        field(50001; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';
            Description = 'Unused';
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
        field(50005; "Last Used Date"; Date)
        {
            CalcFormula = max("Sales Invoice Header"."Posting Date" where("Sell-to Customer No." = field("Customer No."),
                                                                           "Ship-to Code" = field(Code)));
            Caption = 'Last Used Date';
            Description = '18-03-21 ZY-LD 006';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "NCTS No."; Code[10])
        {
            Caption = 'NCTS No.';
        }
        field(50007; "Action Code"; Boolean)
        {
            BlankZero = true;
            CalcFormula = exist("Default Action" where("Source Type" = const("Ship-to Address"),
                                                       "Source Code" = field(Code),
                                                       "Customer No." = field("Customer No.")));
            Caption = 'Action Code';
            Description = '30-03-22 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; Replicated; Boolean)
        {
            Caption = 'Replicated';
        }
    }

    fieldgroups
    {
        addlast(DropDown; "Country/Region Code")
        {
        }
    }

    trigger OnInsert()
    var
        Text001: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
    begin
        //>> 21-09-17 ZY-LD 001
        if StrPos(Code, '&') <> 0 then
            Error(Text001, FieldCaption(Code));
        //<< 21-09-17 ZY-LD 001
    end;
}
