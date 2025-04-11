pageextension 50311 CustomerReportSelectionsZX extends "Customer Report Selections"
{
    layout
    {
        modify(ReportID)
        {
            Visible = false;
        }
        modify(ReportCaption)
        {
            Visible = false;
        }
        modify("Custom Report Description")
        {
            Visible = false;
        }
    }

    actions
    {
        addfirst(processing)
        {
            action("Update E-mail Address from Customer")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update E-mail Address from Customer';
                RunObject = Codeunit "Custom Report Management";
            }
        }
    }

    trigger OnClosePage()
    begin
        //>> 17-10-18 ZY-LD 002
        if ChangeHasBeenMade then
            if Rec."Source Type" = Database::Customer then
                ZyWebSrvMgt.ReplicateCustomers('', Rec."Source No.", false);
        //<< 17-10-18 ZY-LD 002
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ChangeHasBeenMade := true;  // 17-10-18 ZY-LD 002
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ChangeHasBeenMade := true;  // 17-10-18 ZY-LD 002
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ChangeHasBeenMade := true;  // 17-10-18 ZY-LD 002
    end;

    var
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        ChangeHasBeenMade: Boolean;
}
