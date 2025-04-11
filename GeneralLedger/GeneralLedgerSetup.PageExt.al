pageextension 50143 GeneralLedgerSetupZX extends "General Ledger Setup"
{
    // 001. 08-02-24 ZY-LD 000 - Fields added to the page.
    layout
    {
        addafter("Allow Deferral Posting To")
        {
            field("Allow VAT Posting From"; Rec."Allow VAT Posting From")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the earliest date on which VAT posting to the company books is allowed.';
            }
            field("Allow VAT Posting To"; Rec."Allow VAT Posting To")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the last date on which VAT posting to the company books is allowed.';
            }
        }
        modify("Shortcut Dimension 3 Code")
        {
            Editable = false;
            Importance = Standard;
        }
        modify("Shortcut Dimension 4 Code")
        {
            Editable = false;
            Importance = Standard;
        }
        addafter("Payroll Transaction Import")
        {
            group(Zyxel)
            {
                Caption = 'Zyxel';
                field("HQ Company Name"; Rec."HQ Company Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(PP)
                {
                    ShowCaption = false;
                    Visible = PowerPivotDateVisible;

                    field("Power Pivot Start Date"; Rec."Power Pivot Start Date")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the start date for the power pivot used for extracting ex. "General Ledger Entires" and "Posted Sales Lines".';
                    }
                    field("Power Pivot End Date"; Rec."Power Pivot End Date")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the end date for the power pivot used for extracting ex. "General Ledger Entires" and "Posted Sales Lines".';
                    }
                }
            }
        }
        //>> 08-02-24 ZY-LD 001
        addafter("VAT Rounding Type")
        {
            field("VAT Reporting Date"; Rec."VAT Reporting Date")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        //<< 08-02-24 ZY-LD 001
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
                RunObject = Page "Change Log Entries";
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(98));
            }
        }
    }
    var
        PowerPivotDateVisible: Boolean;

    trigger OnOpenPage()
    begin
        SetActions();
    end;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        PowerPivotDateVisible := ZGT.IsRhq();
    end;
}
