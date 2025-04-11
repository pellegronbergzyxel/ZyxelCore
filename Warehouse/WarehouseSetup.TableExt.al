tableextension 50216 WarehouseSetupZX extends "Warehouse Setup"
{
    fields
    {
        field(50000; "Default Transaction Type"; Code[10])
        {
            Caption = 'Default Transaction Type';
            Description = '07-05-18 ZY-LD 001';
            TableRelation = "Transaction Type";
        }
        field(50001; "Default Transport Method"; Code[10])
        {
            Caption = 'Default Transport Method';
            Description = '07-05-18 ZY-LD 001';
            TableRelation = "Transport Method";
        }
        field(50002; "VCK Outbound FTP Code"; Code[20])
        {
            Caption = 'VCK Outbound FTP Code';
            Description = '22-02-19 ZY-LD 002';
            TableRelation = "FTP Folder";
        }
        field(50003; "VCK Inbound FTP Code"; Code[20])
        {
            Caption = 'VCK Inbound FTP Code';
            Description = '22-02-19 ZY-LD 002';
            TableRelation = "FTP Folder";
        }
        field(50004; "When Can We Post Resp. VCK"; Option)
        {
            Caption = 'On Which Status Can We Post Whse. Outb. Resp.';
            Description = '13-03-19 ZY-LD 003';
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
            Description = '25-06-19 ZY-LD 004';
        }
        field(50010; "Action Code Nos."; Code[10])
        {
            Caption = 'Action Code Nos.';
            TableRelation = "No. Series";
        }
        field(50011; "Whse. Inbound Order Nos."; Code[10])
        {
            Caption = 'Whse. Inbound Order Nos.';
            Description = '06-02-20 ZY-LD 005';
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
            Description = '04-05-22 ZY-LD 006';
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
