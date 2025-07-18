page 50012 "Unshipped Purchase Order"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Unshipped Purchase Order';
    PageType = List;
    SourceTable = "Unshipped Purchase Order";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sales Order Line ID"; Rec."Sales Order Line ID")
                {
                    ToolTip = 'Specifies the value of the Sales Order Line ID field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ToolTip = 'Specifies the value of the Purchase Order No. field.';
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    ToolTip = 'Specifies the value of the Purchase Line No. field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("ETD Date"; Rec."ETD Date")
                {
                    ToolTip = 'Specifies the value of the ETD Date field.';
                }
                field("ETA Date"; Rec."ETA Date")
                {
                    ToolTip = 'Specifies the value of the ETA Date field.';
                }
                field("Shipping Order ETD Date"; Rec."Shipping Order ETD Date")
                {
                    ToolTip = 'Specifies the value of the Shipping Order ETD Date field.';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ToolTip = 'Specifies the value of the Expected Receipt Date field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field("Vendor Type"; Rec."Vendor Type")
                {
                    ToolTip = 'Specifies the value of the Vendor Type field.';
                }
                field("DN Number"; Rec."DN Number")
                {
                    ToolTip = 'Specifies the value of the DN Number field.';
                } //Mail from John in HQ - first in test BK
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
            }
        }
    }
}
