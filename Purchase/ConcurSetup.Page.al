Page 50092 "Concur Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Concur Setup';
    SourceTable = "Concur Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Import Folder - Travel Expense"; Rec."Import Folder - Travel Expense")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Import Folder - Invoice Captur"; Rec."Import Folder - Invoice Captur")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(Control12)
                {
                    field("To Concur Folder"; Rec."To Concur Folder")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("From Concur Folder"; Rec."From Concur Folder")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Uploaded Folder"; Rec."Uploaded Folder")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Error Folder"; Rec."Error Folder")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Archive Folder"; Rec."Archive Folder")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Import Success E-mail Code"; Rec."Import Success E-mail Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Rejected E-mail Code"; Rec."Rejected E-mail Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No Lines to Import E-mail Code"; Rec."No Lines to Import E-mail Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Import Error E-mail Code"; Rec."Import Error E-mail Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("G/L Account")
            {
                Caption = 'G/L Account';
                field("Cash Advance Account No."; Rec."Cash Advance Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Freight in Transit Account No."; Rec."Freight in Transit Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Invoice)
            {
                Caption = 'Invoice';
                group(Domestic)
                {
                    Caption = 'Domestic';
                    field("Gen. Bus. Posting Group Dom."; Rec."Gen. Bus. Posting Group Dom.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Bus. Posting Group';
                        Tooltip = 'Default posting group at insert vendor.';
                    }
                    field("Vendor Posting Group Dom."; Rec."Vendor Posting Group Dom.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor Posting Group';
                        ToolTip = 'Default posting group at insert vendor.';
                    }
                }
                group(EU)
                {
                    Caption = 'EU';
                    field("Gen. Bus. Posting Group EU"; Rec."Gen. Bus. Posting Group EU")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Bus. Posting Group';
                        ToolTip = 'Default posting group at insert vendor.';
                    }
                    field("Vendor Posting Group EU"; Rec."Vendor Posting Group EU")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor Posting Group';
                        ToolTip = 'Default posting group at insert vendor.';
                    }
                }
                group("NON-EU")
                {
                    Caption = 'NON-EU';
                    field("Gen. Bus. Posting Group Non-EU"; Rec."Gen. Bus. Posting Group Non-EU")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Bus. Posting Group';
                        ToolTip = 'Default posting group at insert vendor.';
                    }
                    field("Vendor Posting Group Non-EU"; Rec."Vendor Posting Group Non-EU")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor Posting Group';
                        ToolTip = 'Default posting group at insert vendor.';
                    }
                }
            }
            group("General Journal")
            {
                Caption = 'General Journal';
                field("Travel Exp. Gen. Jnl. Template"; Rec."Travel Exp. Gen. Jnl. Template")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Travel Exp. Gen. Jnl. Batch"; Rec."Travel Exp. Gen. Jnl. Batch")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Vendor Nos."; Rec."Vendor Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice Nos."; Rec."Invoice Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Travel Exp. Concur Id Nos"; Rec."Travel Exp. Concur Id Nos")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Travel Expense Nos."; Rec."Travel Expense Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Data Exchange")
            {
                Caption = 'Data Exchange';
                field("Vendor Form Name"; Rec."Vendor Form Name")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Lessor)
            {
                Caption = '365 Payroll';
                //>TODO: LD Lessor?
                // field("Travel Exp. Pay Type Code"; Rec."Travel Exp. Pay Type Code")
                // {
                //     ApplicationArea = Basic, Suite;
                // }
                field("Travel Exp. Pay Type Mail Add."; Rec."Travel Exp. Pay Type Mail Add.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Automation)
            {
                Caption = 'Automation';
                field("recAutoSetup.""Run Automations"""; recAutoSetup."Run Automations")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Run Automations';
                    Editable = false;
                }
                group(Control41)
                {
                    field("recAutoSetup.""Export Concur Vendors"""; recAutoSetup."Export Concur Vendors")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Export Concur Vendors';
                    }
                    field("recAutoSetup.""Export Concur Vendors After"""; recAutoSetup."Export Concur Vendors After")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Export Concur Vendors After';
                        ToolTip = 'Concur can only import one file per day, so the automation will export changed Concur vendors once after this time.';
                    }
                }
                group(Control42)
                {
                    field("recAutoSetup.""Invoice Capture Process"""; recAutoSetup."Invoice Capture Process")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Invoice Capture Process';
                    }
                    field("recAutoSetup.""Travel Expense Process"""; recAutoSetup."Travel Expense Process")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Travel Expense Process';
                    }
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        if not recAutoSetup.IsEmpty then
            recAutoSetup.Modify(true);
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then
            Rec.Insert;

        if not recAutoSetup.IsEmpty then
            recAutoSetup.Get;
    end;

    var
        recAutoSetup: Record "Automation Setup";
}
