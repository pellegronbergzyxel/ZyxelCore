pageextension 50287 SalesManagerRoleCenterZX extends "Sales Manager Role Center"
{
    layout
    {
        addfirst(rolecenter)
        {
            group(Finance)
            {
                ShowCaption = false;
                part("Finance Performance"; "Finance Performance")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                part("Account Manager Activities"; "Account Manager Activities")
                {
                    ApplicationArea = Basic, Suite;
                }
                part("My Customers"; "My Customers")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Other)
            {
                ShowCaption = false;
                part("Trailing Sales Orders Chart"; "Trailing Sales Orders Chart")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                part("My Job Queue"; "My Job Queue")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                part("Cash Flow Chart"; "Cash Flow Forecast Chart")
                {
                    ApplicationArea = Basic, Suite;
                }
                part("My Vendors"; "My Vendors")
                {
                    ApplicationArea = Basic, Suite;
                }
                part("Report Inbox Part"; "Report Inbox Part")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        modify(Control1900724808)
        {
            Visible = false;
        }
        modify(Control1900724708)
        {
            Visible = false;
        }
    }

    actions
    {
        addfirst(reporting)
        {
            action("G/L Trial Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&G/L Trial Balance';
                Image = Report;
                RunObject = Report "Trial Balance";
            }
            action("Bank Detail Trial Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Bank Detail Trial Balance';
                Image = Report;
                RunObject = Report "Bank Acc. - Detail Trial Bal.";
            }
            action("Account Schedule")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Account Schedule';
                Image = Report;
                RunObject = Report "Account Schedule";
            }
            action("Budget")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Budget';
                Image = Report;
                RunObject = Report "Budget";
            }
            action("Trial Balance/Budget")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Bala&nce/Budget';
                Image = Report;
                RunObject = Report "Trial Balance/Budget";
            }
            action("Trial Balance by Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Balance by &Period';
                Image = Report;
                RunObject = Report "Trial Balance by Period";
            }
            action("Fiscal Year Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Fiscal Year Balance';
                Image = Report;
                RunObject = Report "Fiscal Year Balance";
            }
            action("Balance Comp. - Prev. Y&ear")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Balance Comp. - Prev. Y&ear';
                Image = Report;
                RunObject = Report "Balance Comp. - Prev. Year";
            }
            action("Closing Trial Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Closing Trial Balance';
                Image = Report;
                RunObject = Report "Closing Trial Balance";
            }
            action("Cash Flow Date List")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Flow Date List';
                Image = Report;
                RunObject = Report "Cash Flow Date List";
            }
            action("Aged Accounts Receivable")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Aged Accounts &Receivable';
                Image = Report;
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Aged Accounts Payable")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Aged Accounts Pa&yable';
                Image = Report;
                RunObject = Report "Aged Accounts Payable";
            }
            action("Reconcile Cust. and Vend. Accs")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reconcile Cus&t. and Vend. Accs';
                Image = Report;
                RunObject = Report "Reconcile Cust. and Vend. Accs";
            }
            separator(sep1)
            {
            }
            action("VAT Registration No. Check")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT Registration No. Check';
                Image = Report;
                RunObject = Report "VAT Registration No. Check";
            }
            action("VAT Exceptions")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT E&xceptions';
                Image = Report;
                RunObject = Report "VAT Exceptions";
            }
            action("VAT Statement")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT &Statement';
                Image = Report;
                RunObject = Report "VAT Statement";
            }
            action("VAT - VIES Declaration Tax Auth")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT - VIES Declaration Tax Aut&h';
                Image = Report;
                RunObject = Report "VAT- VIES Declaration Tax Auth";
            }
            action("VAT - VIES Declaration Disk")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT - VIES Declaration Dis&k';
                Image = Report;
                RunObject = Report "VAT- VIES Declaration Disk";
            }
            action("EC Sales List")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EC Sales &List';
                Image = Report;
                RunObject = Report "EC Sales List";
            }
            //Reports does not exists in new Intrastat module
            // action("Intrastat - Checklist")
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = '&Intrastat - Checklist';
            //     Image = Report;
            //     RunObject = Report "Intrastat - Checklist";
            // }
            // action("Intrastat - Form")
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Intrastat - For&m';
            //     Image = Report;
            //     RunObject = Report "Intrastat - Form";
            // }
            action("Cost Accounting P/L Statement")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cost Accounting P/L Statement';
                Image = Report;
                RunObject = Report "Cost Acctg. Statement";
            }
            action("CA P/L Statement per Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'CA P/L Statement per Period';
                Image = Report;
                RunObject = Report "Cost Acctg. Stmt. per Period";
            }
            action("CA P/L Statement with Budget")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'CA P/L Statement with Budget';
                Image = Report;
                RunObject = Report "Cost Acctg. Statement/Budget";
            }
            action("Cost Accounting Analysis")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cost Accounting Analysis';
                Image = Report;
                RunObject = Report "Cost Acctg. Analysis";
            }
        }
        addfirst(sections)
        {
            group(HomeItems)
            {
                action("Chart of Accounts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Chart of Accounts';
                    RunObject = Page "Chart of Accounts";
                }
                action("Vendors")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendors';
                    RunObject = Page "Vendor List";
                    Image = Vendor;
                }
                action("VendorBalance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Balance';
                    RunObject = Page "Vendor List";
                    RunPageView = where("Balance (LCY)" = filter(<> 0));
                    Image = Balance;
                }
                action("Purchase Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                }
                action("Budgets")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Budgets';
                    RunObject = Page "G/L Budget Names";
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Accounts';
                    RunObject = Page "Bank Account List";
                    Image = BankAccount;
                }
                action("VAT Statements")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'VAT Statements';
                    RunObject = Page "VAT Statement Names";
                }
                action("Items2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Items';
                    RunObject = Page "Item List";
                    Image = Item;
                }
                action("Customers2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customers';
                    RunObject = Page "Customer List";
                    Image = Customer;
                }
                action("CustomerBalance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Balance';
                    RunObject = Page "Customer List";
                    RunPageView = where("Balance (LCY)" = filter(<> 0));
                    Image = Balance;
                }
                action("Sales Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Orders';
                    RunObject = Page "Sales Order List";
                    Image = Order;
                }
                action("Reminders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reminders';
                    RunObject = Page "Reminder List";
                    Image = Reminder;
                }
                action("Finance Charge Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Finance Charge Memos';
                    RunObject = Page "Finance Charge Memo List";
                    Image = FinChargeMemo;
                }
            }
            Group(ActivityButtons)
            {
                group("Journals")
                {
                    Caption = 'Journals';
                    action("Purchase Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase Journals';
                        RunObject = Page "General Journal Batches";
                        RunPageView = where("Template Type" = const(Purchases), Recurring = const(false));
                    }
                    action("Sales Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Journals';
                        RunObject = Page "General Journal Batches";
                        RunPageView = where("Template Type" = const(Sales), Recurring = const(false));
                    }
                    action("Cash Receipt Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cash Receipt Journals';
                        RunObject = Page "General Journal Batches";
                        RunPageView = where("Template Type" = const("Cash Receipts"), Recurring = const(false));
                        Image = Journals;
                    }
                    action("Payment Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Payment Journals';
                        RunObject = Page "General Journal Batches";
                        RunPageView = where("Template Type" = const(Payments), Recurring = const(false));
                        Image = Journals;
                    }
                    action("IC General Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'IC General Journals';
                        RunObject = Page "General Journal Batches";
                        RunPageView = where("Template Type" = const(Intercompany), Recurring = const(false));
                    }
                    action("General Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'General Journals';
                        RunObject = Page "General Journal Batches";
                        RunPageView = where("Template Type" = const(General), Recurring = const(false));
                        Image = Journal;
                    }
                }
                Group("Fixed Assets")
                {
                    Caption = 'Fixed Assets';
                    action("Fixed Assets List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Fixed Assets';
                        RunObject = Page "Fixed Asset List";
                    }
                    action("Insurance")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Insurance';
                        RunObject = Page "Insurance List";
                    }
                    action("Fixed Assets G/L Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Fixed Assets G/L Journals';
                        RunObject = Page "General Journal Batches";
                        RunPageView = where("Template Type" = const(Assets), Recurring = const(false));
                    }
                    action("Fixed Assets Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Fixed Assets Journals';
                        RunObject = Page "FA Journal Batches";
                        RunPageView = where(Recurring = const(false));
                    }
                    action("Fixed Assets Reclass. Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Fixed Assets Reclass. Journals';
                        RunObject = Page "FA Reclass. Journal Batches";
                    }
                    action("Insurance Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Insurance Journals';
                        RunObject = Page "Insurance Journal Batches";
                    }
                    action("Recurring General Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Recurring General Journals';
                        RunObject = Page "General Journal Batches";
                        RunPageView = where("Template Type" = const(General), Recurring = const(true));
                    }
                    action("Recurring Fixed Asset Journals")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Recurring Fixed Asset Journals';
                        RunObject = Page "FA Journal Batches";
                        RunPageView = where(Recurring = const(true));
                    }
                }
                Group("Cash Flow")
                {
                    Caption = 'Cash Flow';
                    action("Cash Flow Forecasts")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cash Flow Forecasts';
                        RunObject = Page "Cash Flow Forecast List";
                    }
                    action("Chart of Cash Flow Accounts")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Chart of Cash Flow Accounts';
                        RunObject = Page "Chart of Cash Flow Accounts";
                    }
                    action("Cash Flow Manual Revenues")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cash Flow Manual Revenues';
                        RunObject = Page "Cash Flow Manual Revenues";
                    }
                    action("Cash Flow Manual Expenses")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cash Flow Manual Expenses';
                        RunObject = Page "Cash Flow Manual Expenses";
                    }
                }
                Group("Cost Accounting")
                {
                    Caption = 'Cost Accounting';
                    action("Cost Types")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cost Types';
                        RunObject = Page "Chart of Cost Types";
                    }
                    action("Cost Centers")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cost Centers';
                        RunObject = Page "Chart of Cost Centers";
                    }
                    action("Cost Objects")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cost Objects';
                        RunObject = Page "Chart of Cost Objects";
                    }
                    action("Cost Allocations")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cost Allocations';
                        RunObject = Page "Cost Allocation Sources";
                    }
                    action("Cost Budgets")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cost Budgets';
                        RunObject = Page "Cost Budget Names";
                    }
                }
                Group("Posted Documents")
                {
                    Caption = 'Posted Documents';
                    action("Posted Sales Invoices")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Sales Invoices';
                        RunObject = Page "Posted Sales Invoices";
                        Image = PostedOrder;
                    }
                    action("Posted Sales Credit Memos")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Sales Credit Memos';
                        RunObject = Page "Posted Sales Credit Memos";
                        Image = PostedOrder;
                    }
                    action("Posted Purchase Invoices")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Purchase Invoices';
                        RunObject = Page "Posted Purchase Invoices";
                    }
                    action("Posted Purchase Credit Memos")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Purchase Credit Memos';
                        RunObject = Page "Posted Purchase Credit Memos";
                    }
                    action("Issued Reminders")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Issued Reminders';
                        RunObject = Page "Issued Reminder List";
                        Image = OrderReminder;
                    }
                    action("Issued Fin. Charge Memos")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Issued Fin. Charge Memos';
                        RunObject = Page "Issued Fin. Charge Memo List";
                        Image = PostedMemo;
                    }
                    action("G/L Registers")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'G/L Registers';
                        RunObject = Page "G/L Registers";
                        Image = GLRegisters;
                    }
                    action("Cost Accounting Registers")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cost Accounting Registers';
                        RunObject = Page "Cost Registers";
                    }
                    action("Cost Accounting Budget Registers")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cost Accounting Budget Registers';
                        RunObject = Page "Cost Budget Registers";
                    }
                }
                group("Administration")
                {
                    Caption = 'Administration';
                    action("Currencies")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currencies';
                        RunObject = Page "Currencies";
                        Image = Currency;
                    }
                    action("Accounting Periods")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Accounting Periods';
                        RunObject = Page "Accounting Periods";
                        Image = AccountingPeriods;
                    }
                    action("No. Series")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number Series';
                        RunObject = Page "No. Series";
                    }
                    action("Analysis Views")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Analysis Views';
                        RunObject = Page "Analysis View List";
                    }
                    action("Account Schedules")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Account Schedules';
                        RunObject = Page "Account Schedule Names";
                    }
                    action("Dimensions")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Dimensions';
                        RunObject = Page "Dimensions";
                        Image = Dimensions;
                    }
                    action("Bank Account Posting Groups")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Account Posting Groups';
                        RunObject = Page "Bank Account Posting Groups";
                    }
                }
                group(NewDocumentItems)
                {
                    action("Sales & Credit Memo")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales &Credit Memo';
                        RunObject = Page "Sales Credit Memo";
                        Image = CreditMemo;
                        RunPageMode = Create;
                    }
                    action("P&urchase Credit Memo")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'P&urchase Credit Memo';
                        RunObject = Page "Purchase Credit Memo";
                        Image = CreditMemo;
                        RunPageMode = Create;
                    }
                }
                group(ActionItems)
                {
                    Caption = 'Tasks';
                    action("Cas&h Receipt Journal")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cas&h Receipt Journal';
                        RunObject = Page "Cash Receipt Journal";
                        Image = CashReceiptJournal;
                    }
                    action("Pa&yment Journal")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pa&yment Journal';
                        RunObject = Page "Payment Journal";
                        Image = PaymentJournal;
                    }
                    separator("Separator")
                    {
                    }
                    action("Analysis &Views2")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Analysis &Views';
                        RunObject = Page "Analysis View List";
                        Image = AnalysisView;
                    }
                    action("Analysis by &Dimensions")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Analysis by &Dimensions';
                        RunObject = Page "Analysis by Dimensions";
                        Image = AnalysisViewDimension;
                    }
                    action("Calculate Depreciation")
                    {
                        Ellipsis = true;
                        Caption = 'Calculate Deprec&iation';
                        RunObject = Report "Calculate Depreciation";
                        Image = CalculateDepreciation;
                    }
                    action("Import Consolidation from Database")
                    {
                        Ellipsis = true;
                        Caption = 'Import Co&nsolidation from Database';
                        RunObject = Report "Import Consolidation from DB";
                        Image = ImportDatabase;
                    }
                    action("Bank Account Reconciliation")
                    {
                        Caption = 'Bank Account R&econciliation';
                        RunObject = Page "Bank Acc. Reconciliation";
                        Image = BankAccountRec;
                    }
                    action("Adjust Exchange Rates")
                    {
                        Ellipsis = true;
                        Caption = 'Adjust E&xchange Rates';
                        RunObject = Report "Exch. Rate Adjustment";
                        Image = AdjustExchangeRates;
                    }
                    action("Post Inventory Cost to G/L")
                    {
                        Caption = 'P&ost Inventory Cost to G/L';
                        RunObject = Report "Post Inventory Cost to G/L";
                        Image = PostInventoryToGL;
                    }
                    separator("Separator2")
                    {
                    }
                    action("Create Reminders")
                    {
                        Ellipsis = true;
                        Caption = 'C&reate Reminders';
                        RunObject = Report "Create Reminders";
                        Image = CreateReminders;
                    }
                    action("Create Finance Charge Memos")
                    {
                        Ellipsis = true;
                        Caption = 'Create Finance Charge &Memos';
                        RunObject = Report "Create Finance Charge Memos";
                        Image = CreateFinanceChargememo;
                    }
                    separator("Separator3")
                    {
                    }
                    action("Intrastat Journal")
                    {
                        Caption = 'Intrastat &Journal';
                        RunObject = Page "Intrastat Report";
                        Image = Journal;
                    }
                    action("Calc. and Post VAT Settlement")
                    {
                        Caption = 'Calc. and Pos&t VAT Settlement';
                        RunObject = Report "Calc. and Post VAT Settlement";
                        Image = SettleOpenTransactions;
                    }
                }
                Group("Setup")
                {
                    Caption = 'Setup';
                    action("General Ledger Setup")
                    {
                        Caption = 'General &Ledger Setup';
                        RunObject = Page "General Ledger Setup";
                        Image = Setup;
                    }
                    action("Sales & Receivables Setup")
                    {
                        Caption = '&Sales && Receivables Setup';
                        RunObject = Page "Sales & Receivables Setup";
                        Image = Setup;
                    }
                    action("Purchases & Payables Setup")
                    {
                        Caption = '&Purchases && Payables Setup';
                        RunObject = Page "Purchases & Payables Setup";
                        Image = Setup;
                    }
                    action("Fixed Asset Setup")
                    {
                        Caption = '&Fixed Asset Setup';
                        RunObject = Page "Fixed Asset Setup";
                        Image = Setup;
                    }
                    action("Cash Flow Setup")
                    {
                        Caption = 'Cash Flow Setup';
                        RunObject = Page "Cash Flow Setup";
                        Image = CashFlowSetup;
                    }
                    action("Cost Accounting Setup")
                    {
                        Caption = 'Cost Accounting Setup';
                        RunObject = Page "Cost Accounting Setup";
                        Image = CostAccountingSetup;
                    }
                    separator("Separator4")
                    {
                    }
                }
                group("History2")
                {
                    Caption = 'History';
                    action("Navigate")
                    {
                        Caption = 'Navi&gate';
                        RunObject = Page Navigate;
                        Image = Navigate;
                    }
                }
            }
        }
    }
}
