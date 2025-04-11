page 62026 "Auto General Posting Setup"
{
    Caption = 'General Posting Setup';
    DataCaptionFields = "Gen. Bus. Posting Group", "Gen. Prod. Posting Group";
    PageType = Worksheet;
    SourceTable = "General Posting Setup";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Account"; Rec."Sales Account")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Credit Memo Account"; Rec."Sales Credit Memo Account")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Prepayments Account"; Rec."Sales Prepayments Account")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Purch. Account"; Rec."Purch. Account")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purch. Credit Memo Account"; Rec."Purch. Credit Memo Account")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Purch. Prepayments Account"; Rec."Purch. Prepayments Account")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("COGS Account"; Rec."COGS Account")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("COGS Account (Interim)"; Rec."COGS Account (Interim)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Inventory Adjmt. Account"; Rec."Inventory Adjmt. Account")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invt. Accrual Acc. (Interim)"; Rec."Invt. Accrual Acc. (Interim)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Direct Cost Applied Account"; Rec."Direct Cost Applied Account")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Overhead Applied Account"; Rec."Overhead Applied Account")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
            group(Control52)
            {
                field("<Gen. Bus. Posting Group2>"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Gen. Bus. Posting Group';
                    Editable = false;
                }
                field("<Gen. Prod. Posting Group2>"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Gen. Prod. Posting Group';
                    Editable = false;
                }
                field(GLAccountName; GLAcc.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Name';
                    Editable = false;
                    Visible = GLAccountNameVisible;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Setup")
            {
                Caption = '&Setup';
                action("&Card")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "General Posting Setup Card";
                    RunPageOnRec = true;
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
        area(processing)
        {
            action("&Copy")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Copy';
                Ellipsis = true;
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SaveRecord;
                    CopyGenPostingSetup.SetGenPostingSetup(Rec);
                    CopyGenPostingSetup.RunModal;
                    Clear(CopyGenPostingSetup);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        GLAccountNameVisible := true;
    end;

    trigger OnOpenPage()
    begin
        GLAccountNameVisible := false;
    end;

    var
        GLAcc: Record "G/L Account";
        CopyGenPostingSetup: Report "Copy - General Posting Setup";
        [InDataSet]
        GLAccountNameVisible: Boolean;

    local procedure UpdateGLAccName(AccNo: Code[20])
    begin
        if not GLAcc.Get(AccNo) then
            Clear(GLAcc);
    end;
}
