pageextension 50117 VendorListZX extends "Vendor List"
{
    layout
    {
        moveafter(name; Contact)
        addafter(Contact)
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the vendor''s address.';
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies additional address information.';
            }
            field(City; Rec.City)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the vendor''s city.';
            }
        }
        moveafter(City; "Phone No.")
        addafter("VAT Bus. Posting Group")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the vendor''s VAT registration number.';
            }
        }
        addafter("Base Calendar Code")
        {
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Net Change field.';
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Net Change (LCY) field.';
            }
            field("Invoice Amounts"; Rec."Invoice Amounts")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Invoice Amounts field.';
            }
            field("Cr. Memo Amounts"; Rec."Cr. Memo Amounts")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Cr. Memo Amounts field.';
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the vendor''s email address.';
            }
            field(Active; Rec.Active)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the Active field.';
            }
        }
    }

    actions
    {
        addafter("Item Refe&rences")
        {
            action("Bill-From Vendor pr. Location")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bill-From Vendor pr. Location';
                Image = CoupledOpportunity;
                RunObject = Page "Add. Vend. Posting Grp. Setup";
                RunPageLink = "Vendor No." = field("No.");
            }
        }
        addafter("Ledger E&ntries")
        {
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
                              where("Table No." = const(23));
            }
        }
        addafter(History)
        {
            group("Additional Setup")
            {
                Caption = 'Additional Setup';
                action(VendPostingGrpSetupSub)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Add. Posting Setup';
                    Image = Intercompany;
                    RunObject = Page "Add. Vend. Posting Grp. Setup";

                    trigger OnAction()
                    begin
                        // Using OnAfterAction.
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 005
        SetActions;  // 24-02-21 ZY-LD 006
        Rec.SetRange(Active, true);
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 005
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions;  // 24-02-21 ZY-LD 006
    end;

    var
        SI: Codeunit "Single Instance";
        AddPostSetupSubVisible: Boolean;

    local procedure SetActions()
    begin
        AddPostSetupSubVisible := Rec."Related Company";  // 24-02-21 ZY-LD 006
    end;
}
