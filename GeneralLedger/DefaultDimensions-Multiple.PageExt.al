pageextension 50210 DefaultDimensionsMultipleZX extends "Default Dimensions-Multiple"
{
    layout
    {
        modify(Control1)
        {
            Editable = PageEditable;
        }
    }

    actions
    {
        addfirst(navigation)
        {
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ChangeLogEntry: Record "Change Log Entry";
                begin
                    ChangeLogEntry.SetCurrentKey("Table No.", "Date and Time");
                    ChangeLogEntry.SetAscending("Date and Time", false);
                    ChangeLogEntry.SetRange("Table No.", Database::"Default Dimension");
                    ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(Rec."Table ID"));
                    ChangeLogEntry.SetRange("Primary Key Field 2 Value", Rec."No.");
                    Page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();
    end;

    trigger OnClosePage()
    begin
        if ChangeHasBeenMade then begin
            if Rec."Table ID" = Database::Item then
                ZyWebSrvMgt.ReplicateItems('', Rec."No.", false, false);

            if Rec."Table ID" = Database::Customer then
                ZyWebSrvMgt.ReplicateCustomers('', Rec."No.", false);
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ChangeHasBeenMade := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ChangeHasBeenMade := true;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ChangeHasBeenMade := true;
    end;

    var
        PageEditable: Boolean;
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        ChangeHasBeenMade: Boolean;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        PageEditable := ZGT.UserIsAccManager('');
    end;
}
