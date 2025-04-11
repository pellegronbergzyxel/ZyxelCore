Table 50080 "Availability pr Location"
{
    // 001.  DT1.00  01-07-2010  SH
    //   .Object Created
    // 002: BS 18.12.2012 added ActualAvailable, PO Qty., Qty. in Receipt Line, ExpectedAvailable
    // 003. 15-11-18 ZY-LD 000 - New field.
    // 004. 22-04-20 ZY-LD 2020042210000038 - "Order Type" is added as filter on "Qty. on Shipping Detail".


    fields
    {
        field(1; Item; Code[20])
        {
            TableRelation = Item;
        }
        field(2; Location; Code[10])
        {
            TableRelation = Location;
        }
        field(3; Inventory; Decimal)
        {
        }
        field(4; "Qty. in Sales Order"; Decimal)
        {
        }
        field(5; "Qty. in Purchase Order"; Decimal)
        {
        }
        field(6; Available; Decimal)
        {
        }
        field(7; Description; Text[50])
        {
        }
        field(8; Parent; Boolean)
        {
        }
        field(9; ActualAvailable; Decimal)
        {
        }
        field(10; "PO Qty."; Decimal)
        {
        }
        field(11; "Qty. in Receipt Line"; Decimal)
        {
        }
        field(12; ExpectedAvailable; Decimal)
        {
        }
        field(55100; "Qty. on Shipping Detail"; Decimal)
        {
            Description = 'PAB 1.0';
        }
        field(55101; "HQ Unshipped Purchase Order"; Decimal)
        {
            Description = 'RD 1.0';
        }
        field(55102; "Qty. on Ship. Detail Received"; Decimal)
        {
            Caption = 'Quantity on Shipping Detail Received';
            Description = '15-11-18 ZY-LD 003';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; Item, Location)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
