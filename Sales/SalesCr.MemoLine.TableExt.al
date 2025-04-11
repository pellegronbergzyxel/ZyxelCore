tableextension 50132 SalesCrMemoLineZX extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50000; "Order Date"; Date)
        {
            CalcFormula = lookup("Sales Cr.Memo Header"."Posting Date" where("No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50001; "Forecast Territory"; Code[20])
        {
            CalcFormula = lookup(Customer."Forecast Territory" where("No." = field("Sell-to Customer No.")));
            Caption = 'Forecast Territory';
            Description = '13-11-19 ZY-LD 007';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Forecast Territory";
        }
        field(50002; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Description = '13-11-19 ZY-LD 007';
        }
        field(50021; "Warehouse Inbound No."; Code[20])
        {
            Caption = 'Warehouse Inbound No.';
            Description = '04-05-20 ZY-LD 008';
        }
        field(50022; "External Document Position No."; Code[10])
        {
            Caption = 'External Document Position No.';
            Description = '04-08-21 ZY-LD 009';
        }
        field(50100; "BOM Line No."; Integer)
        {
            Caption = 'BOM Line No.';
            Description = 'DT1.00';
            Editable = false;
        }
        field(50101; "Hide Line"; Boolean)
        {
            Description = 'DT1.00';
            Editable = false;
        }
        field(50103; "IC Payment Terms"; Code[10])
        {
            Caption = 'IC Payment Terms';
            Description = '20-09-18 ZY-LD 004';
            TableRelation = "Payment Terms";
        }
        field(62000; "Picking List No."; Code[20])
        {
            Caption = 'Picking List No';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(62001; "Packing List No."; Text[50])
        {
            Caption = 'Packing List No.';
            Description = 'Tectura Taiwan';
            Editable = false;
        }
        field(62005; Status; Option)
        {
            Caption = 'Status';
            Description = 'Tectura Taiwan';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(62006; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Description = 'Tectura Taiwan';
        }
        field(62042; "Special Order No. on SO Line"; Code[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key50000; "External Document No.")
        {
        }
        key(Key50001; "Document Date", "External Document No.")
        {
        }
        key(Key50002; "Sell-to Customer No.", "Location Code", "Return Reason Code")
        {
        }
    }
}
