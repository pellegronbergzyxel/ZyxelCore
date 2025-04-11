Page 50043 "MDM Safety Buffer List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Item;
    SourceTableView = where(Inactive = const(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = MDMBufferEditable;
                }
                field(MDM; Rec.MDM)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(SCM; Rec.SCM)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Edit)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Card";
                RunPageLink = "No." = field("No.");
                ShortCutKey = 'Shift+Ctrl+E';
            }
            action("Import MDM Safety Buffer")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import MDM Safety Buffer';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Import MDM Safety Buffer";
            }
        }
        area(navigation)
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field("No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(27));
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Rec.Status, Rec.Status::Live);
        SetActions;
    end;

    var
        MDMBufferEditable: Boolean;

    local procedure SetActions()
    var
        recUserSetup: Record "User Setup";
    begin
        if not recUserSetup.Get(UserId()) then;
        MDMBufferEditable := (UserId() = Rec.MDM) or (UserId() = Rec.SCM) or recUserSetup.SCM;
    end;
}
