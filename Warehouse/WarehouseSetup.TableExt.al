tableextension 50216 WarehouseSetupZX extends "Warehouse Setup"
{
    fields
    {
        field(50000; "Default Transaction Type"; Code[10])
        {
            Caption = 'Default Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(50001; "Default Transport Method"; Code[10])
        {
            Caption = 'Default Transport Method';
            TableRelation = "Transport Method";
        }
        field(50002; "VCK Outbound FTP Code"; Code[20])
        {
            Caption = 'VCK Outbound FTP Code';
            TableRelation = "FTP Folder";
        }
        field(50003; "VCK Inbound FTP Code"; Code[20])
        {
            Caption = 'VCK Inbound FTP Code';
            TableRelation = "FTP Folder";
        }
        field(50004; "When Can We Post Resp. VCK"; Option)
        {
            Caption = 'On Which Status Can We Post Whse. Outb. Resp.';
            OptionCaption = 'New or Larger,Backorder or Larger,Ready to Pick or Larger,Picking or Larger,Packed or Larger,Waiting for invoice or Larger,Invoice Received or Larger,Posted or Larger,In Transit or Larger,Delivered or Larger,Error';
            OptionMembers = "New or Larger","Backorder or Larger","Ready to Pick or Larger","Picking or Larger","Packed or Larger","Waiting for invoice or Larger","Invoice Received or Larger","Posted or Larger","In Transit or Larger","Delivered or Larger",Error;
        }
        field(50005; "Whse. Rcpt Response Nos."; Code[10])
        {
            AccessByPermission = TableData "Posted Invt. Pick Header" = R;
            Caption = 'Whse. Rcpt Response Nos.';
            TableRelation = "No. Series";
        }
        field(50006; "Whse. Ship Response Nos."; Code[10])
        {
            AccessByPermission = TableData "Warehouse Shipment Header" = R;
            Caption = 'Whse. Ship Response Nos.';
            TableRelation = "No. Series";
        }
        field(50007; "Stop Whse. Communication"; DateTime)
        {
            Caption = 'Stop Whse. Communication';
        }
        field(50008; "Whse. Delivery Document Nos."; Code[10])
        {
            Caption = 'Whse. Delivery Document Nos.';
            TableRelation = "No. Series";
        }
        field(50009; "Latest Inventory Request"; Date)
        {
            Caption = 'Latest Inventory Request';
        }
        field(50010; "Action Code Nos."; Code[10])
        {
            Caption = 'Action Code Nos.';
            TableRelation = "No. Series";
        }
        field(50011; "Whse. Inbound Order Nos."; Code[10])
        {
            Caption = 'Whse. Inbound Order Nos.';
            TableRelation = "No. Series";
        }
        field(50012; "When Can We Post I-Resp. VCK"; Option)
        {
            Caption = 'On Which Status Can We Post Whse. Inb. Resp.';
            OptionCaption = ' ,Order Sent, Order Sent (2),Goods Received,Putting Away,On Stock';
            OptionMembers = " ","Order Sent"," Order Sent (2)","Goods Received","Putting Away","On Stock";
        }
        field(50013; "Expected Shipment Period"; DateFormula)
        {
            Caption = 'Expected Shipment Period';
        }
        field(50014; "Calculated ETA Calculation"; DateFormula) //08-09-2025 BK #525482
        {
            Caption = 'Calculated ETA Calculation';
        }
        field(50015; "Expected Receipt Calculation"; DateFormula) //08-09-2025 BK #525482
        {
            Caption = 'Expected Receipt Calculation';
        }
    }

    procedure WhsePostingAllowed() rValue: Boolean
    var
        recWhseSetup: Record "Warehouse Setup";
    begin
        //>> 30-04-19 ZY-LD 004
        recWhseSetup.Get();

        if recWhseSetup."Stop Whse. Communication" <> 0DT then
            rValue := not (CurrentDatetime > recWhseSetup."Stop Whse. Communication")
        else
            rValue := true;
        //<< 30-04-19 ZY-LD 004
    end;
}
