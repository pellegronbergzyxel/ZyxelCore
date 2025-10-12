pageextension 50258 WarehouseSetupZX extends "Warehouse Setup"
{
    layout
    {
        addafter("Shipment Posting Policy")
        {
            field("Stop Whse. Communication"; Rec."Stop Whse. Communication")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies a date and time to stop communication with the warehouse.';
            }
        }
        addafter("Registered Whse. Movement Nos.")
        {
            field("Whse. Inbound Order Nos."; Rec."Whse. Inbound Order Nos.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the No. Series to be used for Warehouse Inbound Orders.';
            }
            field("Whse. Delivery Document Nos."; Rec."Whse. Delivery Document Nos.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the No. Series to be used for Warehouse Delivery Documents.';
            }
            field("Whse. Rcpt Response Nos."; Rec."Whse. Rcpt Response Nos.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the No. Series to be used for Posted Inventory Pick Responses.';
            }
            field("Whse. Ship Response Nos."; Rec."Whse. Ship Response Nos.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the No. Series to be used for Warehouse Shipment Responses.';
            }
            field("Action Code Nos."; Rec."Action Code Nos.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the No. Series to be used for Action Codes.';
            }
            group(VCK)
            {
                Caption = 'VCK';
                field("When Can We Post Resp. VCK"; Rec."When Can We Post Resp. VCK")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies on which status we can post warehouse outbound responses (VCK).';
                }
                field("When Can We Post I-Resp. VCK"; Rec."When Can We Post I-Resp. VCK")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies on which status we can post warehouse inbound responses (VCK).';
                }
                field("Expected Shipment Period"; Rec."Expected Shipment Period")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'If the field is filled, we will add the period to "Estimated Time of Departure (ETD)" and into the field "Expected Receipt Date"/"ETA". If "ETD-Date" is empty we will use "Estimated Time of Arrival (ETA)" for the calculation instead.';
                }
                field("Calculated ETA Calculation"; Rec."Calculated ETA Calculation") //08-09-2025 BK #525482
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'If the field is filled, we will add the period to "Calculated ETA" and into the field "Expected Receipt Date".';
                }
                field("Expected Receipt Calculation"; Rec."Expected Receipt Calculation") //08-09-2025 BK #525482
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'If the field is filled, we will add the period to "ETA" and get Expected Receipt Date.';
                }

            }
        }
    }
}
