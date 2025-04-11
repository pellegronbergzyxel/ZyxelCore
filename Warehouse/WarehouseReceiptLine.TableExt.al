tableextension 50234 WarehouseReceiptLineZX extends "Warehouse Receipt Line"
{
    fields
    {
        field(50001; "Direct Unit Cost"; Decimal)
        {
#pragma warning disable AL0603
            CalcFormula = lookup("Purchase Line"."Direct Unit Cost" where("Document Type" = field("Source Subtype"),
#pragma warning restore AL0603
                                                                          "Document No." = field("Source No."),
                                                                          "Line No." = field("Source Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Line Amount"; Decimal)
        {
#pragma warning disable AL0603
            CalcFormula = lookup("Purchase Line"."Line Amount" where("Document Type" = field("Source Subtype"),
#pragma warning restore AL0603
                                                                     "Document No." = field("Source No."),
                                                                     "Line No." = field("Source Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "New Unit Cost"; Decimal)
        {

            trigger OnValidate()
            var
                lrPurchLine: Record "Purchase Line";
            begin
                case Rec."Source Type" of
                    39:
                        begin
                            lrPurchLine.Get(Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.");
                            lrPurchLine.Validate(lrPurchLine."Direct Unit Cost", Rec."New Unit Cost");
                            lrPurchLine.Modify(true);
                        end;
                end;
            end;
        }
        field(50005; "Vendor Invoice No."; Text[20])
        {
            Caption = 'Vendor Invoice No.';
            Description = '12-02-19 ZY-LD 001';
            TableRelation = "VCK Shipping Detail"."Invoice No." where("Purchase Order No." = field("Source No."),
                                                                      "Purchase Order Line No." = field("Source Line No."));
            ValidateTableRelation = false;
        }
        field(50011; "Vendor Shipment No."; Code[35])
        {
            CalcFormula = lookup("Warehouse Receipt Header"."Vendor Shipment No." where("No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50021; "Warehouse Inbound No."; Code[20])
        {
            Caption = 'Warehouse Inbound No.';
            Description = '23-03-20 ZY-LD 003';
            TableRelation = "Warehouse Inbound Header";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(66001; "DSV Status"; Option)
        {
            OptionCaption = ' ,New,Sent,Recieved,Mismatch';
            OptionMembers = " ",New,Sent,Recieved,Mismatch;
        }
        field(66002; "Expected Receipt Date"; Date)
        {
            CalcFormula = lookup("Warehouse Receipt Header"."Expected Receipt Date" where("No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key50000; "Item No.", "Variant Code", "Location Code", "Due Date")
        {
            SumIndexFields = "Qty. (Base)", "Qty. Outstanding (Base)";
        }
    }
}
