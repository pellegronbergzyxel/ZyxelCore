tableextension 50214 TransferReceiptLineZX extends "Transfer Receipt Line"
{
    fields
    {
        field(50000; "SCM Approved"; Boolean)
        {
            Description = 'ZY1.0';
        }
        field(50001; "Picking Status"; Option)
        {
            Description = 'ZY1.0';
            OptionCaption = ' ,New,Sent';
            OptionMembers = " ",New,Sent;
        }
        field(50002; "DSV Sent Date Time"; DateTime)
        {
            Description = 'ZY1.0';
        }
        field(50010; Customer_PO; Code[20])
        {
            Description = 'ZY1.1';
        }
        field(50021; "Warehouse Inbound No."; Code[20])
        {
            Caption = 'Warehouse Inbound No.';
            Description = '23-03-20 ZY-LD 002';
        }
        field(70000; ExpectedReceiptDate; Date)
        {
            Caption = 'Expected Receipt Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(70001; PurchaseOrderNo; Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(70002; PurchaseOrderLineNo; Integer)
        {
            Caption = 'Purchase Order Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}
