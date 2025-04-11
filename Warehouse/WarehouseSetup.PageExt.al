pageextension 50258 WarehouseSetupZX extends "Warehouse Setup"
{
    layout
    {
        addafter("Shipment Posting Policy")
        {
            field("Stop Whse. Communication"; Rec."Stop Whse. Communication")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Registered Whse. Movement Nos.")
        {
            field("Whse. Inbound Order Nos."; Rec."Whse. Inbound Order Nos.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Whse. Delivery Document Nos."; Rec."Whse. Delivery Document Nos.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Whse. Rcpt Response Nos."; Rec."Whse. Rcpt Response Nos.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Whse. Ship Response Nos."; Rec."Whse. Ship Response Nos.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Action Code Nos."; Rec."Action Code Nos.")
            {
                ApplicationArea = Basic, Suite;
            }
            group(VCK)
            {
                Caption = 'VCK';
                field("When Can We Post Resp. VCK"; Rec."When Can We Post Resp. VCK")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("When Can We Post I-Resp. VCK"; Rec."When Can We Post I-Resp. VCK")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Expected Shipment Period"; Rec."Expected Shipment Period")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'If the field is filled, we will add the period to "Estimated Time of Departure (ETD)" and into the field "Expected Receipt Date". If "ETD-Date" is empty we will use "Estimated Time of Arrival (ETA)" for the calculation instead.';
                }
            }
        }
    }
}
