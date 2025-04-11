Codeunit 62017 ICReconManagement
{
    Permissions = TableData "IC Reconciliation Template" = imd,
                  TableData "IC Reconciliation Name" = imd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'VAT';
        Text001: label 'VAT Statement';
        Text002: label 'DEFAULT';
        Text003: label 'Default Statement';
        OpenFromBatch: Boolean;


    procedure TemplateSelection(PageID: Integer; var VATStmtLine: Record "IC Reconciliation Line"; var StmtSelected: Boolean)
    var
        VATStmtTmpl: Record "IC Reconciliation Template";
    begin
        StmtSelected := true;

        VATStmtTmpl.Reset;
        VATStmtTmpl.SetRange("Page ID", PageID);

        case VATStmtTmpl.Count of
            0:
                begin
                    VATStmtTmpl.Init;
                    VATStmtTmpl.Name := Text000;
                    VATStmtTmpl.Description := Text001;
                    VATStmtTmpl.Validate("Page ID");
                    VATStmtTmpl.Insert;
                    Commit;
                end;
            1:
                VATStmtTmpl.FindFirst;
            else
                StmtSelected := Page.RunModal(0, VATStmtTmpl) = Action::LookupOK;
        end;
        if StmtSelected then begin
            VATStmtLine.FilterGroup(2);
            VATStmtLine.SetRange("Reconciliation Template Name", VATStmtTmpl.Name);
            VATStmtLine.FilterGroup(0);
            if OpenFromBatch then begin
                VATStmtLine."Reconciliation Template Name" := '';
                Page.Run(VATStmtTmpl."Page ID", VATStmtLine);
            end;
        end;
    end;


    procedure TemplateSelectionFromBatch(var VATStmtName: Record "IC Reconciliation Name")
    var
        VATStmtLine: Record "IC Reconciliation Line";
        VATStmtTmpl: Record "IC Reconciliation Template";
    begin
        OpenFromBatch := true;
        VATStmtTmpl.Get(VATStmtName."Reconciliation Template Name");
        VATStmtTmpl.TestField("Page ID");
        VATStmtName.TestField(Name);

        VATStmtLine.FilterGroup := 2;
        VATStmtLine.SetRange("Reconciliation Template Name", VATStmtTmpl.Name);
        VATStmtLine.FilterGroup := 0;

        VATStmtLine."Reconciliation Template Name" := '';
        VATStmtLine."Reconciliation Name" := VATStmtName.Name;
        Page.Run(VATStmtTmpl."Page ID", VATStmtLine);
    end;


    procedure OpenStmt(var CurrentStmtName: Code[10]; var VATStmtLine: Record "IC Reconciliation Line")
    begin
        CheckTemplateName(VATStmtLine.GetRangemax("Reconciliation Template Name"), CurrentStmtName);
        VATStmtLine.FilterGroup(2);
        VATStmtLine.SetRange("Reconciliation Name", CurrentStmtName);
        VATStmtLine.FilterGroup(0);
    end;


    procedure OpenStmtBatch(var VATStmtName: Record "IC Reconciliation Name")
    var
        VATStmtTmpl: Record "IC Reconciliation Template";
        VATStmtLine: Record "IC Reconciliation Line";
        JnlSelected: Boolean;
    begin
        if VATStmtName.GetFilter("Reconciliation Template Name") <> '' then
            exit;
        VATStmtName.FilterGroup(2);
        if VATStmtName.GetFilter("Reconciliation Template Name") <> '' then begin
            VATStmtName.FilterGroup(0);
            exit;
        end;
        VATStmtName.FilterGroup(0);

        if not VATStmtName.Find('-') then begin
            if not VATStmtTmpl.FindFirst then
                TemplateSelection(0, VATStmtLine, JnlSelected);
            if VATStmtTmpl.FindFirst then
                CheckTemplateName(VATStmtTmpl.Name, VATStmtName.Name);
        end;
        VATStmtName.Find('-');
        JnlSelected := true;
        if VATStmtName.GetFilter("Reconciliation Template Name") <> '' then
            VATStmtTmpl.SetRange(Name, VATStmtName.GetFilter("Reconciliation Template Name"));
        case VATStmtTmpl.Count of
            1:
                VATStmtTmpl.FindFirst;
            else
                JnlSelected := Page.RunModal(0, VATStmtTmpl) = Action::LookupOK;
        end;
        if not JnlSelected then
            Error('');

        VATStmtName.FilterGroup(0);
        VATStmtName.SetRange("Reconciliation Template Name", VATStmtTmpl.Name);
        VATStmtName.FilterGroup(2);
    end;

    local procedure CheckTemplateName(CurrentStmtTemplateName: Code[10]; var CurrentStmtName: Code[10])
    var
        VATStmtTmpl: Record "IC Reconciliation Template";
        VATStmtName: Record "IC Reconciliation Name";
    begin
        VATStmtName.SetRange("Reconciliation Template Name", CurrentStmtTemplateName);
        if not VATStmtName.Get(CurrentStmtTemplateName, CurrentStmtName) then begin
            if not VATStmtName.FindFirst then begin
                VATStmtTmpl.Get(CurrentStmtTemplateName);
                VATStmtName.Init;
                VATStmtName."Reconciliation Template Name" := VATStmtTmpl.Name;
                VATStmtName.Name := Text002;
                VATStmtName.Description := Text003;
                VATStmtName.Insert;
                Commit;
            end;
            CurrentStmtName := VATStmtName.Name;
        end;
    end;


    procedure CheckName(CurrentStmtName: Code[10]; var VATStmtLine: Record "IC Reconciliation Line")
    var
        VATStmtName: Record "IC Reconciliation Name";
    begin
        VATStmtName.Get(VATStmtLine.GetRangemax("Reconciliation Template Name"), CurrentStmtName);
    end;


    procedure SetName(CurrentStmtName: Code[10]; var VATStmtLine: Record "IC Reconciliation Line")
    begin
        VATStmtLine.FilterGroup(2);
        VATStmtLine.SetRange("Reconciliation Name", CurrentStmtName);
        VATStmtLine.FilterGroup(0);
        if VATStmtLine.Find('-') then;
    end;


    procedure LookupName(CurrentStmtTemplateName: Code[10]; CurrentStmtName: Code[10]; var EntrdStmtName: Text[10]): Boolean
    var
        VATStmtName: Record "IC Reconciliation Name";
    begin
        VATStmtName."Reconciliation Template Name" := CurrentStmtTemplateName;
        VATStmtName.Name := CurrentStmtName;
        VATStmtName.FilterGroup(2);
        VATStmtName.SetRange("Reconciliation Template Name", CurrentStmtTemplateName);
        VATStmtName.FilterGroup(0);
        if Page.RunModal(0, VATStmtName) <> Action::LookupOK then
            exit(false);

        EntrdStmtName := VATStmtName.Name;
        exit(true);
    end;
}
