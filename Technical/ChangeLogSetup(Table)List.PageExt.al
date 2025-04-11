pageextension 50216 ChangeLogSetupTableListZX extends "Change Log Setup (Table) List"
{
    layout
    {
        addafter(LogModification)
        {
            field("ChangeLogSetupTable.""Omit Modify on Creation Day"""; ChangeLogSetupTable."Omit Modify on Creation Day")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Omit Modification on Creation Day';

                trigger OnValidate()
                var
                    NewValue: Boolean;
                begin
                    //>> 08-09-17 CD-LD 001
                    if ChangeLogSetupTable."Table No." > 0 then
                        ChangeLogSetupTable.Modify();
                    //<< 08-09-17 CD-LD 001
                end;
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            Action("Copy to other companies")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy to other companies';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CopyToOtherCompanies();  // 08-09-17 ZY-LD 001
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if not ChangeLogSetupTable.Get(Rec."Object ID") then
            Clear(ChangeLogSetupTable);
    end;

    var
        ChangeLogSetupTable: Record "Change Log Setup (Table)";

    local procedure CopyToOtherCompanies()
    var
        lCompany: Record Company;
        lChangeLogSetupTable: Record "Change Log Setup (Table)";
        lChangeLogSetupTableSub: Record "Change Log Setup (Table)";
        lChangeLogSetupField: Record "Change Log Setup (Field)";
        lChangeLogSetupFieldSub: Record "Change Log Setup (Field)";
        lText001: Label 'Do you wish to copy %1 to all companies?';
    begin
        if Confirm(lText001, false, Rec."Object Name") then begin
            lCompany.SetFilter(Name, '<>%1', CompanyName());
            if lCompany.FindSet() then
                repeat
                    // Table
                    lChangeLogSetupTable.SetRange("Table No.", Rec."Object ID");
                    if lChangeLogSetupTable.FindFirst() then begin
                        lChangeLogSetupTableSub.ChangeCompany(lCompany.Name);
                        lChangeLogSetupTableSub := lChangeLogSetupTable;
                        if not lChangeLogSetupTableSub.Modify() then
                            lChangeLogSetupTableSub.Insert();

                        //Field
                        lChangeLogSetupFieldSub.ChangeCompany(lCompany.Name);
                        lChangeLogSetupFieldSub.SetRange("Table No.", Rec."Object ID");
                        lChangeLogSetupFieldSub.DeleteAll();
                        lChangeLogSetupFieldSub.SetRange("Table No.");

                        lChangeLogSetupField.SetRange("Table No.", Rec."Object ID");
                        if lChangeLogSetupField.FindSet() then
                            repeat
                                lChangeLogSetupFieldSub := lChangeLogSetupField;
                                lChangeLogSetupFieldSub.Insert();
                            until lChangeLogSetupField.Next() = 0;
                    end;
                until lCompany.Next() = 0;
        end;
    end;
}
