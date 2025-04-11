table 50087 "Sales Order Type Relation"
{
    Caption = 'Sales Order Type Relation';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(2; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            OptionMembers = " ",Normal,EICard,"Drop Shipment",Other,"Spec. Order","G/L Account",HaaS,eCommerce;
            OptionCaption = ' ,Normal,EICard,Drop Shipment,Other,Spec. Order,G/L Account,HaaS,eCommerce';
        }
        field(3; "Default Order Type Location"; Boolean)
        {
            Caption = 'Default Sales Order Type Location';

            trigger OnValidate()
            var
                SalOrdTypeRel: Record "Sales Order Type Relation";
                lText001: Label '"%1" is "%2" for %3. ';
            begin
                SalOrdTypeRel.SetRange("Sales Order Type", Rec."Sales Order Type");
                SalOrdTypeRel.SetRange("Default Order Type Location", true);
                if SalOrdTypeRel.FindFirst() then
                    Error(lText001, SalOrdTypeRel."Location Code", FieldCaption("Default Order Type Location"), Rec."Sales Order Type");
            end;
        }
        field(4; "In Use"; Boolean)
        {
            Caption = 'In Use';
            FieldClass = FlowField;
            CalcFormula = lookup(Location."In Use" where(Code = field("Location Code")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Location Code", "Sales Order Type")
        {
            Clustered = true;
        }
    }
}
