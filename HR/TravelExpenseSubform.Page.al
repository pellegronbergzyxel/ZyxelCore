Page 50357 "Travel Expense Subform"
{
    // 001. 16-10-20 ZY-LD 2020101510000192 - The filter is changed.
    // 002. 29-11-21 ZY-LD 2021112910000055 - Edit Account No.

    AutoSplitKey = true;
    Caption = 'Travel Expense Subform';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Travel Expense Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Debit / Credit Type"; Rec."Debit / Credit Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Expense Type"; Rec."Expense Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = AccountNoEditable;
                }
                field("Business Purpose"; Rec."Business Purpose")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Vendor Description"; Rec."Vendor Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Division Code - Concur"; Rec."Division Code - Concur")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Division Code - Zyxel"; Rec."Division Code - Zyxel")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Department Code - Concur"; Rec."Department Code - Concur")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Department Code - Zyxel"; Rec."Department Code - Zyxel")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Cost Type"; Rec."Cost Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = VATProdPostingGroupEditable;
                }
                field("Purchasing Currency Code"; Rec."Purchasing Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Purchasing Amount"; Rec."Purchasing Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Original Amount"; Rec."Original Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = BalAccountNoEditable;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = BalAccountNoEditable;
                }
                field("Concur Sequence No."; Rec."Concur Sequence No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Payer Payment Type"; Rec."Payer Payment Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
            group(Control27)
            {
                group(Control31)
                {
                    field("recTravelExpHead.""Debit Amount"""; recTravelExpHead."Debit Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Debit Amount';
                    }
                    field("recTravelExpHead.""Credit Amount"""; recTravelExpHead."Credit Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Credit Amount';
                    }
                    field("recTravelExpHead.Amount"; recTravelExpHead.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Total';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("""Set ""Show Expense""""")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set "Show Expense"';

                trigger OnAction()
                begin
                    Rec."Show Expense" := not Rec."Show Expense";
                    Rec.Modify;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not recTravelExpHead.Get(Rec."Document No.") then;  // 29-11-21 ZY-LD 002
        SetActions;
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("Debit / Credit Type","Debit / Credit Type"::DR);  // 16-10-20 ZY-LD 001
        Rec.SetRange(Rec."Show Expense", true);  // 16-10-20 ZY-LD 001
        SetActions;
        recTravelExpHead.SetAutocalcFields(Amount, "Debit Amount", "Credit Amount");
    end;

    var
        recTravelExpHead: Record "Travel Expense Header";
        AccountNoEditable: Boolean;
        BalAccountNoEditable: Boolean;
        VATProdPostingGroupEditable: Boolean;

    local procedure SetActions()
    var
        recVatProdPostGrp: Record "VAT Product Posting Group";
        recGLAcc: Record "G/L Account";
    begin
        AccountNoEditable :=
          (StrPos(recTravelExpHead."Concur Company Name", 'TR') <> 0) and
          ((recGLAcc.Get(Rec."Account No.") or (Rec."Account No." = '') or (Rec."Bal. Account No." = '')));  // 29-11-21 ZY-LD 002
        BalAccountNoEditable := (Rec."Bal. Account Type" = Rec."bal. account type"::Vendor) and (Rec."Bal. Account No." in ['DUMMY', '']) or AccountNoEditable;
        VATProdPostingGroupEditable := not recVatProdPostGrp.Get(Rec."VAT Prod. Posting Group");
    end;
}
