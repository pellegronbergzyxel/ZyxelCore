Table 50003 "Customer Invoice Texts"
{
    // 
    // 001.  DT1.06  14-07-2010  SH .Object created
    // 002. 21-02-20 ZY-LD P0398 - Spec. Order is added to "Sales Order type".
    // 003. 16-04-21 ZY-LD P0597 - HaaS is added to Sales Order Type.


    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(2; Location; Code[10])
        {
            Caption = 'Location';
            NotBlank = true;
            TableRelation = Location;
        }
        field(3; "Sales Order Type"; Option)
        {
            Caption = 'Sales Order Type';
            Description = 'Tectura Taiwan';
            OptionCaption = ' ,Normal,EICard,Drop Shipment,Other,Spec. Order,G/L Account,HaaS,eCommerce';  // 15-07-24 ZY-LD 000 - eCommerce is added.';
            OptionMembers = " ",Normal,EICard,"Drop Shipment",Other,"Spec. Order","G/L Account",HaaS,eCommerce;

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
        field(4; "Text ID"; Code[10])
        {
            Caption = 'Text ID';
            TableRelation = "Invoice Description";
        }
        field(5; "Order Confimation"; Boolean)
        {
            Caption = 'Order Confirmation';
            Description = 'RD 1.0';
        }
    }

    keys
    {
        key(Key1; "Customer No.", Location, "Sales Order Type")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.", "Sales Order Type", Location)
        {
        }
        key(Key3; "Sales Order Type", Location, "Customer No.")
        {
        }
        key(Key4; Location, "Sales Order Type")
        {
        }
    }

    fieldgroups
    {
    }
}
