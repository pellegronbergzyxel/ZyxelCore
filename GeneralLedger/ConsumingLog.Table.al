table 62007 "Consuming Log"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(11; "Consuming Reference No."; Code[20])
        {
        }
        field(12; "Consuming Line"; Integer)
        {
        }
        field(13; "Consuming Qty"; Decimal)
        {
            Caption = 'Forecast Consuming Qty';
        }
        field(14; "Other Consuming Qty"; Decimal)
        {
            Caption = 'MDM Consuming Qty';
        }
        field(15; "Normal Consuming Qty"; Decimal)
        {
        }
        field(21; "Source Type"; Option)
        {
            OptionCaption = 'Order,Return';
            OptionMembers = "Order",Return;
        }
        field(22; "Order Number"; Code[20])
        {
        }
        field(23; "Order Line"; Integer)
        {
        }
        field(24; "Shipment Date"; Date)
        {
            Caption = 'Request Delivery date';
        }
        field(25; "Reference Date"; Date)
        {
        }
        field(26; "Release Date"; Date)
        {
        }
        field(27; "Release Time"; Time)
        {
        }
        field(31; "Item No."; Code[20])
        {
        }
        field(32; Qty; Decimal)
        {
            Caption = 'Sales Order Quantity';
        }
        field(41; "Over Forecast Flag"; Boolean)
        {
        }
        field(60; "Customer No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Consuming Reference No.", "Consuming Line")
        {
            SumIndexFields = "Consuming Qty", "Other Consuming Qty";
        }
        key(Key3; "Release Date", "Release Time")
        {
        }
    }

    trigger OnInsert()
    var
        ConsumLog: Record "Consuming Log";
    begin
        if ("Entry No." = 0) then begin
            Clear(ConsumLog);
            ConsumLog.Reset();
            if ConsumLog.FindLast() then begin
                "Entry No." := ConsumLog."Entry No." + 1;
            end else begin
                "Entry No." := 1;
            end;
        end;
        //Tectura Taiwan ZL100512B+
        if (("Consuming Qty" + "Other Consuming Qty" + Qty) > 0) then begin
            "Over Forecast Flag" := true;
        end else begin
            "Over Forecast Flag" := false;
        end;
        //Tectura Taiwan ZL100512B-
    end;

    trigger OnModify()
    begin
        //Tectura Taiwan ZL100512B+
        if (("Consuming Qty" + "Other Consuming Qty" + Qty) > 0) then begin
            "Over Forecast Flag" := true;
        end else begin
            "Over Forecast Flag" := false;
        end;
        //Tectura Taiwan ZL100512B-
    end;
}
