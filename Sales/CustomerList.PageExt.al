pageextension 50114 CustomerListZX extends "Customer List"
{
    layout
    {
        modify("No.")
        {
            Style = Strong;
            StyleExpr = true;
        }
        modify("Credit Limit (LCY)")
        {
            Visible = false;
        }
        modify(Control1907829707)
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("Forecast Territory"; Rec."Forecast Territory")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Name)
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = Basic, Suite;
            }
            field(City; Rec.City)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Priority; Rec.Priority)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Responsibility Center")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Registration No."; Rec."Registration No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Balance Due"; Rec."Balance Due")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Phone No.")
        {
            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Shipping Agent Code")
        {
            field("Allow Line Disc."; Rec."Allow Line Disc.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Base Calendar Code")
        {
            field(Division; Division)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Division';
            }
            field(Department; Department)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Department';
            }
            field("Minimum Order Value Enabled"; Rec."Minimum Order Value Enabled")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Minimum Order Value (LCY)"; Rec."Minimum Order Value (LCY)")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Full Pallet Ordering Enabled"; Rec."Full Pallet Ordering Enabled")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Full Pallet Ordering Rounding"; Rec."Full Pallet Ordering Rounding")
            {
                ApplicationArea = Basic, Suite;
            }
            field("E-Mail Statement"; Rec."E-Mail Statement")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(StatementEmailAdd; StatementEmailAdd)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'E-mail Address Statement';
                Visible = false;
            }
            field("E-Mail Reminder"; Rec."E-Mail Reminder")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(ReminderEmailAdd; ReminderEmailAdd)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'E-mail Address Reminder';
                Visible = false;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(CountryDimension; CountryDimension)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Country Dimension';
                Visible = false;
            }
            field("Statement Type"; Rec."Statement Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Print Statements"; Rec."Print Statements")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Related Company"; Rec."Related Company")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(Active; Rec.Active)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
        addafter("Salesperson Code")
        {
            field("Order Desk Resposible Code"; Rec."Order Desk Resposible Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        moveafter("No."; "IC Partner Code")
        moveafter("Phone No."; Contact)
        addlast(Control1)
        {
            field(Category; Rec.Category)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("KYC Last Checked"; Rec."KYC Last Checked")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        modify(Service)
        {
            Visible = false;
        }
        modify(NewServiceQuote)
        {
            Visible = false;
        }
        modify(NewServiceInvoice)
        {
            Visible = false;
        }
        modify(NewServiceOrder)
        {
            Visible = false;
        }
        modify(NewServiceCrMemo)
        {
            Visible = false;
        }
        addafter(ShipToAddresses)
        {
            action("Action Codes")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Action Codes';
                Image = "Action";

                trigger OnAction()
                begin
                    DelDocMgt.EnterActionCode(Rec."No.", Rec."No.", 1);
                end;
            }
            action(Overshipment)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Overshipment';
                Image = CalculateShipment;
                RunObject = Page "Customer/Item Overshipments";
                RunPageLink = "Customer No." = field("No.");
            }
        }
        addafter(ApprovalEntries)
        {
            action("Block Item")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Block Item';
                Image = Stop;
                RunObject = Page "Customer/Item Relation";
                RunPageLink = "Customer No." = field("No.");
                RunPageView = where(Type = const(Block));
            }
            action("Create Del. Doc pr. Item")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Del. Doc pr. Item';
                Image = CreateDocuments;
                RunObject = Page "Customer/Item Relation";
                RunPageLink = "Customer No." = field("No.");
                RunPageView = where(Type = const("Seperate Delivery Document"));
            }
        }
        addafter(CustomerLedgerEntries)
        {
            action(BillToLedgerEntries)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ledger Entries (Bill-to)';
                Image = LedgerEntries;
                RunObject = Page "Customer Ledger Entries";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageView = sorting("Customer No.");
                ShortCutKey = 'Shift+F7';
            }
            action("Item Forecast Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Forecast Entries';
                Image = Forecast;
                RunObject = Page "Item Budget Entries";
                RunPageLink = "Source Type" = const(Customer),
                              "Source No." = field("No.");
                RunPageView = sorting("Analysis Area", "Budget Name", "Item No.", Date)
                              where("Budget Name" = const('MASTER'),
                                    Quantity = filter(<> 0));
            }
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
                              where("Table No." = const(18));
            }
        }
        addafter("Recurring Sales Lines")
        {
            action("Setup pr. Location Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Setup pr. Location Code';
                Image = VATPostingSetup;
                RunObject = Page "eComm. Order Archive FactBox";
                RunPageLink = "eCommerce Order Id" = field("No.");
            }
            action("Sell-to Customer from Location")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sell-to Customer from Location';
                Image = Loaner;
                RunObject = Page "eCommerce Order FactBox";
                RunPageLink = "eCommerce Order Id" = field("No.");
            }
        }
        addafter("Return Orders")
        {
            action("Delivery Documents")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Documents';
                Image = Delivery;
                RunObject = Page "VCK Delivery Document List";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageView = where("Document Status" = filter(Open | Released));
            }
            action("Inbound Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Inbound Orders';
                Image = Return;
                RunObject = Page "Warehouse Inbound List";
                RunPageLink = "Sender No." = field("No.");
                RunPageView = where("Completely Received" = const(false));
            }
        }
        addafter("Blanket Orders")
        {
            action("Invoice Text")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Invoice Text';
                Image = EndingText;
                RunObject = Page "Customer Invoice Texts";
                RunPageLink = "Customer No." = field("No.");
            }
        }
        addafter(Service)
        {
            group("Additional Setup")
            {
                Caption = 'Additional Setup';
                group(" Cust. Sub. Setup")
                {
                    Caption = ' Cust. Sub. Setup';
                    Enabled = AddSubSetupEnable;
                    Image = UserSetup;
                    action("Pr. Customer")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pr. Customer';
                        Image = Relationship;
                        RunObject = Page "Data for Replication List";
                        RunPageLink = "Table No." = const(18),
                                      "Source No." = field("No.");
                    }
                    action("Pr. Company")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pr. Company';
                        Image = Relationship;

                        trigger OnAction()
                        begin
                            CustEvent.SetReplicationPrCompany(Rec);  // 02-11-18 ZY-LD 007
                        end;
                    }
                }
                action(CustBillToCustSetup)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Add. Bill-to Setup';
                    Image = SuggestCustomerBill;
                    Visible = AddPostSetupMainVisible;
                }
                group("Add. Posting Setup")
                {
                    Caption = 'Add. Posting Setup';
                    Image = InteractionTemplateSetup;
                    action(CustPostingGrpSetupMain)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Additional Posting Setup - Main Company';
                        Image = Company;
                        Visible = AddPostSetupMainVisible;

                        trigger OnAction()
                        begin
                            // Using OnAfterAction.
                        end;
                    }
                    action(CustPostingGrpSetupSub)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Additional Posting Setup - Subsidary';
                        Image = Intercompany;
                        Visible = AddPostSetupSubVisible;

                        trigger OnAction()
                        begin
                            // Using OnAfterAction.
                        end;
                    }
                }
                action(CustVatRegNoSetup)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'VAT Reg. No. Setup';
                    Image = VATPostingSetup;

                    trigger OnAction()
                    begin
                        // Using OnAfterAction.
                    end;
                }
                action(EUArticle)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'EU Article';
                    Image = VoucherDescription;

                    trigger OnAction()
                    begin
                        // Using OnAfterAction.
                    end;
                }
            }
        }
        addafter("Sales Journal")
        {
            action("""Update() ""Blocked""""")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update "Blocked"';
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    UpdateBlocked;  // 11-10-17 ZY-LD 001
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetActions();  // 03-02-21 ZY-LD 010
    end;

    trigger OnAfterGetRecord()
    var
        recDefaultDimension: Record "Default Dimension";
    begin
        Division := '';
        Department := '';
        recDefaultDimension.SetRange("Table ID", 18);
        recDefaultDimension.SetFilter("Dimension Code", 'DIVISION');
        recDefaultDimension.SetFilter("No.", Rec."No.");
        if recDefaultDimension.FindFirst() then Division := recDefaultDimension."Dimension Value Code";
        recDefaultDimension.Reset();
        recDefaultDimension.SetRange("Table ID", 18);
        recDefaultDimension.SetFilter("Dimension Code", 'DEPARTMENT');
        recDefaultDimension.SetFilter("No.", Rec."No.");
        if recDefaultDimension.FindFirst() then Department := recDefaultDimension."Dimension Value Code";
        //>> 05-01-18 ZY-LD 002
        CountryDimension := '';
        recDefaultDimension.SetFilter("Table ID", '18');
        recDefaultDimension.SetFilter("No.", Rec."No.");
        recDefaultDimension.SetFilter("Dimension Code", 'COUNTRY');
        if recDefaultDimension.FindFirst() then
            CountryDimension := recDefaultDimension."Dimension Value Code";
        //<< 05-01-18 ZY-LD 002
        SetEmailAddress();  // 22-10-18 ZY-LD 006
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 003
    end;

    trigger OnOpenPage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 003
        Rec.SetRange(Active, true);
    end;

    var
        Division: Code[20];
        Department: Code[20];
        CountryDimension: Code[20];
        SI: Codeunit "Single Instance";
        CustReptMgt: Codeunit "Custom Report Management";
        CustomReportSelection: Record "Custom Report Selection";
        ReminderEmailAdd: Text;
        StatementEmailAdd: Text;
        CustEvent: Codeunit "Customer Events";
        ZGT: Codeunit "ZyXEL General Tools";
        DelDocMgt: Codeunit "Delivery Document Management";
        AddPostSetupMainVisible: Boolean;
        AddPostSetupSubVisible: Boolean;
        AddPostSetupEnable: Boolean;
        AddSubSetupEnable: Boolean;

    local procedure UpdateBlocked()
    var
        lCust: Record Customer;
        lText001: Label 'Do you want to change value of the field\"%1" to "%2" on %3 customer(s)?';
        lText002: Label 'Are you sure?';
        GenericInputPage: Page "Generic Input Page";
        lText003: Label 'New value';
        lText004: Label 'Change value on "Block".';
        NewValue: Option " ",Ship,Invoice,All;
        lText005: Label '%1 customer(s) has been updated.';
    begin
        //>> 11-10-17 ZY-LD 001
        GenericInputPage.SetPageCaption(lText004);
        GenericInputPage.SetFieldCaption(lText003);
        GenericInputPage.SetVisibleField(8);  // Blocked
        if GenericInputPage.RunModal = Action::OK then begin
            NewValue := GenericInputPage.GetOption;

            CurrPage.SetSelectionFilter(lCust);
            if Confirm(lText001, false, Rec.FieldCaption(Rec.Blocked), Format(NewValue), lCust.Count()) then begin
                if Confirm(lText002) then begin
                    if lCust.FindSet() then
                        repeat
                            lCust.Validate(Blocked, NewValue);
                            lCust.Modify(true);
                        until lCust.Next() = 0;
                    Message(lText005, lCust.Count());
                end;
            end;
        end;
        //<< 11-10-17 ZY-LD 001
    end;

    local procedure SetEmailAddress()
    begin
        //>> 22-10-18 ZY-LD 006
        ReminderEmailAdd := CustReptMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::Reminder, Rec."E-Mail");
        StatementEmailAdd := CustReptMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"C.Statement", Rec."E-Mail");
        //<< 22-10-18 ZY-LD 006
    end;

    local procedure SetActions()
    begin
        //>> 22-02-21 ZY-LD 011
        AddPostSetupMainVisible := ZGT.IsRhq;
        AddPostSetupSubVisible := ZGT.IsZComCompany and
                                  (ZGT.IsRhq and (Rec."No." <> Rec."Bill-to Customer No.") and (Rec."Bill-to Customer No." <> '')) or
                                  (not ZGT.IsRhq);
        AddPostSetupEnable := (ZGT.IsRhq and ZGT.IsZComCompany and (((Rec."No." <> Rec."Bill-to Customer No.") and (Rec."Bill-to Customer No." <> '')) or (Rec."IC Partner Code" <> ''))) or
                              (ZGT.IsRhq and ZGT.IsZNetCompany) or
                              (not ZGT.IsRhq);
        AddSubSetupEnable := ZGT.IsRhq;
        //<< 22-02-21 ZY-LD 011
    end;
}
