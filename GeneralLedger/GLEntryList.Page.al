Page 50132 "G/L Entry List"
{
    ApplicationArea = Basic, Suite;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "G/L Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the entry number of the G/L entry.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the G/L account number of the G/L entry.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the posting date of the G/L entry.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the document type of the G/L entry.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the document number of the G/L entry.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the description of the G/L entry.';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the amount of the G/L entry.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the global dimension 1 code of the G/L entry.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the global dimension 2 code of the G/L entry.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the user ID of the G/L entry.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the source code of the G/L entry.';
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies whether the G/L entry was created by the system.';
                }
                field("Prior-Year Entry"; Rec."Prior-Year Entry")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies whether the G/L entry is a prior-year entry.';
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the job number of the G/L entry.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the quantity of the G/L entry.';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the VAT amount of the G/L entry.';
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = Basic, Suite;

                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the journal batch name of the G/L entry.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the reason code of the G/L entry.';
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the general posting type of the G/L entry.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the general business posting group of the G/L entry.';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the general product posting group of the G/L entry.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the balance account type of the G/L entry.';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the transaction number of the G/L entry.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the debit amount of the G/L entry.';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the document date of the G/L entry.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the external document number of the G/L entry.';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the source type of the G/L entry.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the source number of the G/L entry.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the number series of the G/L entry.';
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the tax area code of the G/L entry.';
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies whether the G/L entry is tax liable.';
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the tax group code of the G/L entry.';
                }
                field("Use Tax"; Rec."Use Tax")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies whether the G/L entry is subject to use tax.';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the VAT business posting group of the G/L entry.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the VAT product posting group of the G/L entry.';
                }
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the additional currency amount of the G/L entry.';
                }
                field("Add.-Currency Debit Amount"; Rec."Add.-Currency Debit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the additional currency debit amount of the G/L entry.';
                }
                field("Add.-Currency Credit Amount"; Rec."Add.-Currency Credit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the additional currency credit amount of the G/L entry.';
                }
                field("Close Income Statement Dim. ID"; Rec."Close Income Statement Dim. ID")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the close income statement dimension ID of the G/L entry.';
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the IC partner code of the G/L entry.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies whether the G/L entry has been reversed.';
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the entry number of the G/L entry that reversed this entry.';
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the entry number of the G/L entry that was reversed by this entry.';
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the name of the G/L account that is associated with the entry.';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the dimension set ID of the G/L entry.';
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the production order';
                }
                field("FA Entry Type"; Rec."FA Entry Type")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the fixed asset entry type of the G/L entry.';
                }
                field("FA Entry No."; Rec."FA Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the fixed asset entry number of the G/L entry.';
                }
                field("Applied Amount"; Rec."Applied Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the amount that has been applied to the G/L entry.';
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the ID of the entry to which this entry applies.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies whether the G/L entry is closed.';
                }
                field("Applying Entry"; Rec."Applying Entry")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies whether the G/L entry is an applying entry.';
                }
                field("Amount to Apply"; Rec."Amount to Apply")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the amount to apply to the G/L entry.';
                }
                //06-08-2026 BK performance issue.
                /*field(Country; Rec.Country)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cost Type"; Rec."Cost Type")
                {
                    ApplicationArea = Basic, Suite;
                } */
                Field(ShurtcutDimension3; rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the country dimension value of the G/L entry.';
                }
                Field(ShurtcutDimension4; rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the cost type dimension value of the G/L entry.';
                }
                field("Ignore Country Dimension"; Rec."Ignore Country Dimension")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies whether the country dimension value of the G/L entry is ignored.';
                }
                field("Ignore Cost Type Dimension"; Rec."Ignore Cost Type Dimension")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies whether the cost type dimension value of the G/L entry is ignored.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies whether the G/L entry is blocked.';
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    tooltip = 'Specifies the return reason code of the item that is associated with the entry.';
                }
            }
        }
    }

    actions
    {
    }
}
