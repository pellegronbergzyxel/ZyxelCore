pageextension 50209 DefaultDimensionsZX extends "Default Dimensions"
{
    layout
    {
        modify("Dimension Code")
        {
            Enabled = FieldEnable;
        }
        modify("Dimension Value Code")
        {
            Enabled = FieldEnable;
        }
        modify("Value Posting")
        {
            Enabled = FieldEnable;
        }
        addfirst(Control1)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic, Suite;
                Enabled = FieldEnable;
            }
        }
        addafter("Value Posting")
        {
            field("Force Update in Subsidary"; Rec."Force Update in Subsidary")
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = ForceUpdateCaption;
                Caption = ' ';
                Enabled = ForceUpdateInSubsidaryEnable;
                ToolTip = 'If "Force Update In Subsidary" is ticked off, the dimension will be updated in the subsidaries every time G/L Account is replicated. If not ticked off, the dimension will only be replicated when the G/L Account is created in the subsidary. The field is only visible on G/L Account, and only editable in RHQ.';
                Visible = ForceUpdateInSubsidaryVisible;
            }
            field("Mandatory Concur Dimension"; Rec."Mandatory Concur Dimension")
            {
                ApplicationArea = Basic, Suite;
                Editable = MandatoryConcurDimensionEditable;
                ToolTip = 'The value in this field will overwrite the dimension in the import from Concur.';
                Visible = MandatoryConcurDimensionVisible;
            }
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

    trigger OnAfterGetRecord()
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

    trigger OnDeleteRecord(): Boolean
    begin
        ChangeHasBeenMade := true;  // 28-04-18 ZY-LD 003
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ChangeHasBeenMade := true;  // 28-04-18 ZY-LD 003
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ChangeHasBeenMade := true;  // 28-04-18 ZY-LD 003
    end;

    trigger OnOpenPage()
    begin
        SetActions();  // 05-04-18 ZY-LD 002
    end;

    var
        //PageEditable: Boolean;
        ChangeHasBeenMade: Boolean;
        ForceUpdateInSubsidaryVisible: Boolean;
        ForceUpdateInSubsidaryEnable: Boolean;
        FieldEnable: Boolean;
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        ForceUpdateCaption: Text;
        MandatoryConcurDimensionVisible: Boolean;
        MandatoryConcurDimensionEditable: Boolean;

    local procedure SetActions()
    var
        recGenSetup: Record "General Ledger Setup";
        ZGT: Codeunit "ZyXEL General Tools";
        lText001: Label 'Locked by RHQ';
    begin
        //PageEditable := ZGT.UserIsAccManager('');  // 05-04-18 ZY-LD 002
        ForceUpdateInSubsidaryVisible := Rec."Table ID" = Database::"G/L Account";
        ForceUpdateInSubsidaryEnable := ZGT.IsRhq and ZGT.IsZComCompany;
        FieldEnable := ZGT.IsRhq or not Rec."Force Update in Subsidary";
        if ZGT.IsRhq then
            ForceUpdateCaption := Rec.FieldCaption(Rec."Force Update in Subsidary")
        else
            ForceUpdateCaption := lText001;

        //>> 27-10-20 ZY-LD 005
        recGenSetup.Get();
        MandatoryConcurDimensionVisible := (Rec."Table ID" = Database::"G/L Account") and ZGT.IsRhq and ZGT.IsZComCompany;
        MandatoryConcurDimensionEditable := Rec."Dimension Code" = recGenSetup."Global Dimension 2 Code";
        //<< 27-10-20 ZY-LD 005
    end;
}
