Page 50130 "Delivery Document Cue"
{
    PageType = CardPart;
    SourceTable = "ZY Logistics Cue";

    layout
    {
        area(content)
        {
            cuegroup(NewGroup)
            {
                Caption = 'New';
                field(Control7; Rec.New)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            cuegroup(Released)
            {
                Caption = 'Not Invoiced';
                field("Not Invoiced"; Rec."Not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ready to Invoice';
                    Image = Receipt;
                }
                field("Ready to Release"; Rec."Ready to Release")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ready To Release';
                    Image = Receipt;
                }
                field("Not Processed"; Rec."Not Processed")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Released / Not Received at Warehouse';
                    Image = Receipt;
                }
                field("Released Waiting"; Rec."Released Waiting")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Waiting For Invoice';
                    Image = Receipt;
                }
                field("Send Invoice to Customer"; Rec."Send Invoice to Customer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Invoice to Customer';
                    Image = Receipt;
                }
                field("Ship-to Code is missing"; Rec."Ship-to Code is missing")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ship-to Code is Missing';
                    Image = Receipt;
                }
                field("Transferred Not Posted"; Rec."Transferred Not Posted")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transferred not Posted';
                    Image = Receipt;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        recDelDocHead: Record "VCK Delivery Document Header";
        recAutoSetup: Record "Automation Setup";
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        //>> 07-11-19 ZY-LD 009
        IF recDelDocHead.READPERMISSION THEN
            IF recAutoSetup.GET THEN
                Rec.SETFILTER("Warehouse Status Filter", '%1..%2|%3..',
                  Rec."Warehouse Status Filter"::"Waiting for invoice",
                  Rec."Warehouse Status Filter"::"Invoice Received",  // 06-12-21 ZY-LD 012
                  recDelDocHead.GetWhseStatusToInvoiceOn(false));
        //<< 07-11-19 ZY-LD 009
    end;
}
