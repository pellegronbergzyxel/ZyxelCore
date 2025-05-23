pageextension 50113 CustomerCardZX extends "Customer Card"
{
    layout
    {
        modify(General)
        {
            Editable = PageEditable;
        }
        modify("Address & Contact")
        {
            Editable = PageEditable;
        }
        modify(Invoicing)
        {
            Editable = PageEditable;
        }
        modify(Payments)
        {
            Editable = PageEditable;
        }
        modify(Shipping)
        {
            Editable = PageEditable;
        }
        modify(Statistics)
        {
            Editable = PageEditable;
        }
        modify("Responsibility Center")
        {
            Importance = Additional;
        }
        modify("Service Zone Code")
        {
            Importance = Additional;
        }
        modify("IC Partner Code")
        {
            Importance = Promoted;
        }
        modify("Gen. Bus. Posting Group")
        {
            Editable = SelectedFieldsEditable;
        }
        modify("VAT Bus. Posting Group")
        {
            Importance = Promoted;
            Editable = SelectedFieldsEditable;
        }
        modify("Customer Posting Group")
        {
            Editable = SelectedFieldsEditable;
        }
        modify("Currency Code")
        {
            Editable = SelectedFieldsEditable;
            ToolTip = 'The invoice between the regional head quarter and the subsidary will be invoiced with the "Currency Code" from "Bill-to Customer No.". The invoice to the customer from the subsidary will be invoiced with the "Currency Code" from the "Sell-to Customer".';

            trigger OnAfterValidate()
            begin
                SetActions();
            end;
        }
        modify("Customer Price Group")
        {
            Importance = Standard;
        }
        modify("Credit Limit (LCY)")
        {
            Editable = SelectedFieldsEditable;
        }
        modify("VAT Registration No.")
        {
            Editable = SelectedFieldsEditable;
        }
        addafter("No.")
        {
            field("Forecast Territory"; Rec."Forecast Territory")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Forcast Territory';
            }
        }
        addafter("E-Mail")
        {
            field(BacklogEmailAddress; Rec.BacklogEmailAddress)
            {
                ApplicationArea = Basic, Suite;
                ExtendedDatatype = EMail;
                Importance = Promoted;
                ToolTip = 'Specifies an email address to which the Backlog report will be sent.';
            }
        }
        addafter("Country/Region Code")
        {
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Territory Code';
            }
        }
        addafter("Salesperson Code")
        {
            field("Order Desk Resposible Code"; Rec."Order Desk Resposible Code")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specifies the Order Desk Resposible Code';
            }
        }
        addafter(Blocked)
        {
            field(Active; Rec.Active)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'If the tick is removed, the customer will dissapear from the customer list.';
            }
        }
        addafter("Last Date Modified")
        {
            group(Control102)
            {
                Caption = 'Dimensions';
                field(DivisionDimension; DivisionDimension)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Division Dimension';
                    Caption = 'Division';
                    Enabled = false;
                }
                field(CountryDimension; CountryDimension)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Country Dimension';
                    Caption = 'Country';
                    Editable = false;
                }
            }
        }
        addafter("Document Sending Profile")
        {
            group(Finance)
            {
                Caption = 'Finance';
                field("E-Mail Statement"; Rec."E-Mail Statement")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the E-Mail Statement';
                }
                field("Statement Type"; Rec."Statement Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Statement Type';
                }
                field(StatementEmailAdd2; StatementEmailAdd)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statement E-mail Address';
                    ToolTip = 'Specifies the Statement EmailAdd2';

                    trigger OnValidate()
                    begin
                        CustReptMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"C.Statement", StatementEmailAdd);
                        ChangeHasBeenMade := true;
                    end;
                }
                field("E-Mail Reminder"; Rec."E-Mail Reminder")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the E-Mail Reminder';
                    AssistEdit = true;
                }
                field(ReminderEmailAdd; ReminderEmailAdd)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reminder E-mail Address';
                    ToolTip = 'Specifies the ReminderEmailAdd';

                    trigger OnValidate()
                    begin
                        CustReptMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::Reminder, ReminderEmailAdd);
                        ChangeHasBeenMade := true;
                    end;
                }
            }
            group("Order")
            {
                Caption = 'Order';
                field("E-mail for Order Scanning"; Rec."E-mail for Order Scanning")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the E-mail for Order Scanning';
                }
                field(OrderEmailAdd; OrderEmailAdd)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Order E-mail Address';
                    ToolTip = 'Specifies the Order Email Add';

                    trigger OnValidate()
                    begin
                        //>> 26-11-18 ZY-LD 014
                        CustReptMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Order", OrderEmailAdd);
                        ChangeHasBeenMade := true;
                        //<< 26-11-18 ZY-LD 014
                    end;
                }
            }
            group(ShippingGrp)
            {
                Caption = 'Shipping';
                field("E-mail Deliv. Note at Release"; Rec."E-mail Deliv. Note at Release")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'When tick off this field, the delivery note will be sent to the "Order E-mail Address" when the delivery document is released.';
                }
                field("E-mail Shipping Inv. to Whse."; Rec."E-mail Shipping Inv. to Whse.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'When tick off this field, the customs invoice will be sent to the warehouse when the delivery document is released.';
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                field("E-mail Sales Documents"; Rec."E-mail Sales Documents")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the E-mail Sales Documents';
                }
                field("Delay Btw. Post and Send Email"; Rec."Delay Btw. Post and Send Email")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Delay Btw. Post and Send Email';
                }
                field(InvoiceEmailAdd; InvoiceEmailAdd)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoice & Cr.Memo E-mail Address';
                    ToolTip = 'Specifies the InvoiceEmailAdd';

                    trigger OnValidate()
                    begin
                        CustReptMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Invoice", InvoiceEmailAdd);
                        CustReptMgt.UpdateEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Cr.Memo", InvoiceEmailAdd);
                        ChangeHasBeenMade := true;
                    end;
                }
            }
            group(EICard)
            {
                Caption = 'EICard';
                field("Set Eicard Type on Sales Order"; Rec."Set Eicard Type on Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Selected customers can choose between "Normal, Consignment and eCommerce" Eicards. If the field is ticked off, the user must select when the order is created, otherwise "Eicard Type" is set to Normal.';
                }
                field("EiCard Email Address"; Rec."EiCard Email Address")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Distributor E-mail';
                    ToolTip = 'Specifies the EiCard Email Address"';
                }
                field("End User Email Expected"; Rec."End User Email Expected")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the End User Email Expected';
                }
                field("EiCard Email Address1"; Rec."EiCard Email Address1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'End User E-mail';
                    ToolTip = 'Specifies the EiCard Email Address1';
                    Visible = false;
                }
                field("EiCard Email Address2"; Rec."EiCard Email Address2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the EiCard Email Address2';
                }
                field("EiCard Email Address3"; Rec."EiCard Email Address3")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the EiCard Email Address3';
                }
                field("EiCard Email Address4"; Rec."EiCard Email Address4")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the EiCard Email Address4';
                }
                field("Supervisor Password eShop"; Rec."Supervisor Password eShop")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Supervisor Password eShop';
                }
                field("Download and Attach Eicards"; Rec."Download and Attach Eicards")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'A similar field exists in "Automation Setup". If one of the fields is true, a download will be executed.';
                }
            }
            group("Chemical Tax")
            {
                Caption = 'Chemical Tax';
                field("E-mail Chemical Report"; Rec."E-mail Chemical Report")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the E-mail Chemical Report';
                }
                field("E-mail for Chemical Report"; Rec."E-mail for Chemical Report")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'E-mail for Chemical Report';
                }
            }
        }
        addafter("Currency Code")
        {
            field("Select Currency Code"; Rec."Select Currency Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'If ticked off, you can select the currency code for the "Sell-to customer" in the "Pop up" page on the sales document.';
                Visible = not IsBillToCustomer;
            }
        }
        addafter("VAT Registration No.")
        {
            field("EORI No."; Rec."EORI No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = '"Eori No." enables the customs authorities of the other EU countries to recognize a company that is registered as an exporter. In Denmark is "VAT Reg. No." used as the "Eori No.".';
            }
            field("VAT ID"; Rec."VAT ID")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of the VAT ID field.';
            }
        }
        addafter(GLN)
        {
            field("Intercompany Purchase"; Rec."Intercompany Purchase")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of Intercompany Purchase.';
            }
        }
        addafter("Copy Sell-to Addr. to Qte From")
        {
            group(Automation)
            {
                Caption = 'Automation';
                field("Automatic Invoice Handling"; Rec."Automatic Invoice Handling")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Automatic Invoice Handling';
                }
                field("Run Auto. Inv. Hand. on WaitFI"; Rec."Run Auto. Inv. Hand. on WaitFI")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Run "Automatic Invoice Handling" on "Warehouse Status" = "Waiting for Invoice".';
                }
                field("Post EiCard Invoice Automatic"; Rec."Post EiCard Invoice Automatic")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Post EiCard Invoice Automatic';
                }
                field("Mark Inv. and Cr.M as Printed"; Rec."Mark Inv. and Cr.M as Printed")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Mark Inv. and Cr.M as Printed';
                }
                field("Create Invoice pr. Order"; Rec."Create Invoice pr. Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Create Invoice pr. Order';
                }
            }
            group(Control197)
            {
                ShowCaption = false;
                field("Sub company"; Rec."Sub company")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sub company';
                }
                field("Avoid Creation of SI in SUB"; Rec."Avoid Creation of SI in SUB")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = AvoidCreationofSIinSUBEnable;
                    ToolTip = 'Specifies the CAvoid Creation of SI in SUB';
                }
                field("Skip Posting Group Validation"; Rec."Skip Posting Group Validation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Skip Posting Group Validation';
                }
            }
            field(Priority; Rec.Priority)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Priority';
            }
        }
        addafter("Prepayment %")
        {
            field("Your Reference Translation"; Rec."Your Reference Translation")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Your Reference Translation';
                Importance = Additional;
            }
            group("Italian Invoice")
            {
                Caption = 'Italian Invoice';
                field("Customer Tipology"; Rec."Customer Tipology")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Customer Tipology';
                    Importance = Additional;
                }
                field("Recipient Code"; Rec."Recipient Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Recipient Code';
                    Importance = Additional;
                }
                field("Recipient PEC E-Mail"; Rec."Recipient PEC E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Recipient PEC E-Mail';
                    Importance = Additional;
                }
                field("Administration Reference"; Rec."Administration Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Administration Reference';
                    Importance = Additional;
                }
            }
            group(Tyrkey)
            {
                Caption = 'Tyrkey';
                field("VAT Registration Code"; Rec."VAT Registration Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT Registration Code';
                    Importance = Additional;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Registration No.';
                    Importance = Additional;
                }
                field("Tax Office Code"; Rec."Tax Office Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Tax Office Code';
                    Importance = Additional;
                }
            }
        }
        addafter("Customized Calendar")
        {
            field("Additional Items"; Rec."Additional Items")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Additional Items';
            }
            field("Unblock Pick.Date Restriction"; Rec."Unblock Pick.Date Restriction")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Unblock Pick.Date Restriction';
            }
            field("Customs Broker"; Rec."Customs Broker")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Customs Broker';
            }
            field("Create Delivery Doc. pr. Order"; Rec."Create Delivery Doc. pr. Order")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'When ticking off the this field, Delivery Documents will be created pr. Sales Order No.';
            }
            field("Attach Pallet No. to Serial No"; Rec."Attach Pallet No. to Serial No")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Attach Pallet No. to Serial No';
                Importance = Additional;
            }
        }
        addafter("Currency Code")
        {
            field(SelectCurrencyCode2; Rec."Select Currency Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'If ticked off, you can select the currency code for the "Sell-to customer" in the "Pop up" page on the sales document.';
                Visible = not IsBillToCustomer;
            }
        }
        addafter(Shipping)
        {
            group(Planning)
            {
                Caption = 'Planning';
                Editable = PageEditable;
            }
            group(Reporting)
            {
                Caption = 'Reporting';
                Editable = PageEditable;
                group(Control214)
                {
                    Caption = ' ';
                    field("Related Company"; Rec."Related Company")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the Related Company';
                    }
                    field("Exclude Wee Report"; Rec."Exclude Wee Report")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the Exclude Wee Report';
                    }
                    field("Exclude from Intrastat"; Rec."Exclude from Intrastat")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the Exclude from Intrastat';
                    }
                }
                field("Exclude from Forecast"; Rec."Exclude from Forecast")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Exclude from Forecast';
                }
                field("Sample Account"; Rec."Sample Account")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sample Account';
                    Visible = SampleAccountVisible;
                }
                field("KYC Last Checked"; Rec."KYC Last Checked")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the KYC Last Checked';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Category';
                }

            }
            group("Extended Info")
            {
                Caption = 'Extended Info';
                Editable = PageEditable;
                field("Turkish Customer No."; Rec."Turkish Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Turkish Customer No.';
                }
                field(AMAZONID; Rec.AMAZONID)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the AMAZONID';

                }
            }
            group(Forecasting)
            {
                Caption = 'Forecasting';
                Editable = PageEditable;
            }
            group("Ordering Policy")
            {
                Caption = 'Ordering Policy';
                Editable = PageEditable;

                field("Minimum Order Value Enabled"; Rec."Minimum Order Value Enabled")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Minimum Order Value Enabled';
                }
                field("Minimum Order Value (LCY)"; Rec."Minimum Order Value (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Minimum Order Value (LCY)';
                }
                field("Full Pallet Ordering Enabled"; Rec."Full Pallet Ordering Enabled")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if full carton ordering is enabled for the customer.';
                }
                field("Full Pallet Ordering Rounding"; Rec."Full Pallet Ordering Rounding")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how the carton rounding should be calculated.';
                }
            }
        }
        addlast(Invoicing)
        {
            field("Warning on Not-delivery"; Rec."Warning on Not-delivery")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Show warning when delivery document is no on Deilvered status';
            }

        }
    }

    actions
    {
        modify(Service)
        {
            Visible = false;
        }
        addafter("ShipToAddresses")
        {
            action("Action Codes")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Action Codes';
                ToolTip = 'Enter Action Codes';
                Image = "Action";

                trigger OnAction()
                begin
                    DelDocMgt.EnterActionCode(Rec."No.", Rec."No.", 1);
                end;
            }
            action(Overshipment)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the customer Overshipments';
                Caption = 'Overshipment';
                Image = CalculateShipment;
                RunObject = Page "Customer/Item Overshipments";
                RunPageLink = "Customer No." = field("No.");
            }
        }
        addafter(CustomerReportSelections)
        {
            action("Block Item")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Block Item';
                ToolTip = 'Specifies the blocked Customer Items relations';
                Image = Stop;
                RunObject = Page "Customer/Item Relation";
                RunPageLink = "Customer No." = field("No.");
                RunPageView = where(Type = const(Block));
            }
            action("Create Del. Doc pr. Item")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Del. Doc pr. Item';
                ToolTip = 'Customer Item relation where Seperate Delivery Document';
                Image = CreateDocuments;
                RunObject = Page "Customer/Item Relation";
                RunPageLink = "Customer No." = field("No.");
                RunPageView = where(Type = const("Seperate Delivery Document"));
            }
        }
        addafter("Ledger E&ntries")
        {
            action(BillToLedgerEntries)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ledger Entries (Bill-to)';
                ToolTip = 'Customer Ledger Entries';
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
                ToolTip = 'Item Budget Entries';
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
                ToolTip = 'Lookup to the Change log';
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
        addlast("&Customer")
        {
            action(CustomerreportSelection)
            {
                ApplicationArea = all;
                Caption = 'Customer report selection';
                ToolTip = 'Select the Custom Report';
                Image = MailSetup;
                RunObject = page "Custom Report Selection";
                RunPageLink = "Source Type" = const(18), "Source No." = field("No.");
            }
        }
        addafter("Recurring Sales Lines")
        {
            action("Setup pr. Location Code")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Setup pr. Location Code';
                ToolTip = 'eCommerce order Archive FactBox';
                Image = VATPostingSetup;
                RunObject = Page "eComm. Order Archive FactBox";
                RunPageLink = "eCommerce Order Id" = field("No.");
            }
            action("Sell-to Customer from Location")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sell-to Customer from Location';
                ToolTip = 'eCommerce Ship Details FactBox';
                Image = Loaner;
                RunObject = Page "eCommerce Ship Details FactBox";
                RunPageLink = "eCommerce Order Id" = field("No.");
            }
            action("Post Grp. Setup pr. Country / Location")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Grp. Setup pr. Country / Location';
                ToolTip = 'Customer Posting Group Setup pr. Country / Location';
                Image = ChangeCustomer;

                trigger OnAction()
                var
                    recCustPostGrpSetup: Record "Add. Cust. Posting Grp. Setup";
                begin
                    //>> 04-01-21 ZY-LD 010
                    recCustPostGrpSetup.SetRange("Country/Region Code", Rec."Country/Region Code");
                    recCustPostGrpSetup.SetFilter("Customer No.", '%1|%2', '', Rec."No.");
                    Page.Run(Page::"Data Export Record Definitions", recCustPostGrpSetup);
                    //<< 04-01-21 ZY-LD 010
                end;
            }
            action("Delivery Documents")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Documents';
                ToolTip = 'VCK Delivery Document List with status open';
                Image = Delivery;
                RunObject = Page "VCK Delivery Document List";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageView = where("Document Status" = const(Open));
            }
        }
        addafter("Return Orders")
        {
            action(Action228)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Documents';
                ToolTip = 'VCK Delivery Document List with status open and released';
                Image = Delivery;
                RunObject = Page "VCK Delivery Document List";
                RunPageLink = "Sell-to Customer No." = field("No.");
                RunPageView = where("Document Status" = filter(Open | Released));
            }
            action("Inbound Orders")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Warehouse Inbound List where completely received is no';
                Caption = 'Inbound Orders';
                Image = Return;
                RunObject = Page "Warehouse Inbound List";
                RunPageLink = "Sender No." = field("No.");
                RunPageView = where("Completely Received" = const(false));
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
                        ToolTip = 'Data for replication list where table no. equals customer';
                        Image = Relationship;
                        RunObject = Page "Data for Replication List";
                        RunPageLink = "Table No." = const(18),
                                      "Source No." = field("No.");
                    }
                    action("Pr. Company")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pr. Company';
                        ToolTip = 'Set Replication Pr. Company';
                        Image = Relationship;

                        trigger OnAction()
                        begin
                            CustEvent.SetReplicationPrCompany(Rec);
                        end;
                    }
                }
                action(CustBillToCustSetup)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Add. Bill-to Setup';
                    Caption = 'Add. Bill-to Setup';
                    Image = SuggestCustomerBill;
                    Visible = AddPostSetupMainVisible;
                }
                group("Add. Posting Setup")
                {
                    Caption = 'Add. Posting Setup';
                    Enabled = AddPostSetupEnable;
                    Image = InteractionTemplateSetup;
                    action(CustPostingGrpSetupMain)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Additional Posting Setup - Main Company';
                        ToolTip = 'Additional Posting Setup - Main Company';
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
                        ToolTip = 'Additional Posting Setup - Subsidary';
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
                    ToolTip = 'VAT Reg. No. Setup';
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
    }

    trigger OnOpenPage()
    begin
        SetActions();
        SI.SetRejectChangeLog(false);
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);

        if CurrPage.Editable(Rec."VAT Registration No." = '') then
            if recCountry.Get(Rec."Country/Region Code") and recCountry."VAT Reg. No. Must be Filled" then
                Error(Text035, Rec.FieldCaption("VAT Registration No."));

        if ChangeHasBeenMade then
            ZyWebSrvMgt.ReplicateCustomers('', Rec."No.", false);

        if ZGT.IsRhq() then begin
            if Rec."Global Dimension 1 Code" = '' then
                Error(ZyText001, Rec.FieldCaption("Global Dimension 1 Code"));
        end;
    end;

    trigger OnAfterGetRecord()
    var
        recDefaultDimension: Record "Default Dimension";
    begin
        DivisionDimension := '';
        CountryDimension := '';
        recDefaultDimension.SetFilter("Table ID", '18');
        recDefaultDimension.SetFilter("No.", Rec."No.");
        recDefaultDimension.SetFilter("Dimension Code", 'DIVISION');
        if recDefaultDimension.FindFirst() then DivisionDimension := recDefaultDimension."Dimension Value Code";
        recDefaultDimension.SetFilter("Table ID", '18');
        recDefaultDimension.SetFilter("No.", Rec."No.");
        recDefaultDimension.SetFilter("Dimension Code", 'COUNTRY');
        if recDefaultDimension.FindFirst() then CountryDimension := recDefaultDimension."Dimension Value Code";

        SetEmailAddress();
        SetActions();
    end;

    var
        recCountry: Record "Country/Region";
        CustomReportSelection: Record "Custom Report Selection";
        SI: Codeunit "Single Instance";
        CustReptMgt: Codeunit "Custom Report Management";
        ZGT: Codeunit "ZyXEL General Tools";
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        DelDocMgt: Codeunit "Delivery Document Management";
        CustEvent: Codeunit "Customer Events";
        AddPostSetupMainVisible: Boolean;
        AddPostSetupSubVisible: Boolean;
        AddPostSetupEnable: Boolean;
        AddSubSetupEnable: Boolean;
        IsBillToCustomer: Boolean;
        AvoidCreationofSIinSUBEnable: Boolean;
        UseCurrencyFromSelltoCustEnable: Boolean;
        ChangeHasBeenMade: Boolean;
        PageEditable: Boolean;
        SelectedFieldsEditable: Boolean;
        IsZNet: Boolean;
        SampleAccountVisible: Boolean;
        DivisionDimension: Code[20];
        CountryDimension: Code[20];
        ReminderEmailAdd: Text;
        StatementEmailAdd: Text;
        InvoiceEmailAdd: Text;
        OrderEmailAdd: Text;
        Text035: Label '"%1" must be filled.';
        ZyText001: Label '"%1" must not be blank.';

    local procedure SetActions()
    var
        lCust: Record Customer;
        lCustRHQ: Record Customer;
        lCustSister: Record Customer;
        UserSetup: Record "User Setup";
        RHQCustFound: Boolean;
        SisterCustFound: Boolean;
    begin
        lCust.SetRange("Bill-to Customer No.", Rec."No.");
        lCust.SetFilter("No.", '<>%1', Rec."No.");
        if not lCust.FindFirst() then begin
            lCust.Reset();
            if lCust.Get(Rec."Bill-to Customer No.") then
                UseCurrencyFromSelltoCustEnable := Rec."Currency Code" <> lCust."Currency Code";
            AvoidCreationofSIinSUBEnable := true;
        end;

        // Customer is only editable in RHQ, unless if it's a local customer.
        if ZGT.IsRhq() or
          (CompanyName() = ZGT.GetCompanyName(7))
        then
            PageEditable := true
        else begin
            if lCustRHQ.ChangeCompany(ZGT.GetCompanyName(1)) then  // RHQ
                RHQCustFound := lCustRHQ.Get(Rec."No.");
            if lCustSister.ChangeCompany(ZGT.GetSistersCompanyName(1)) then  // ZNet RHQ  
                SisterCustFound := lCustSister.Get(Rec."No.");
            PageEditable := (not RHQCustFound) and (not SisterCustFound);
        end;

        if UserSetup.get(UserId) then
            SelectedFieldsEditable := UserSetup."User Type" = UserSetup."User Type"::"Accounting Manager";


        IsZNet := ZGT.IsZNetCompany;
        IsZNet := false;

        AddPostSetupMainVisible := ZGT.IsRhq();
        AddPostSetupSubVisible := ZGT.IsZComCompany() and
                                  (ZGT.IsRhq() and (Rec."No." <> Rec."Bill-to Customer No.") and (Rec."Bill-to Customer No." <> '')) or
                                  (not ZGT.IsRhq());
        AddPostSetupEnable := (ZGT.IsRhq() and ZGT.IsZComCompany() and (((Rec."No." <> Rec."Bill-to Customer No.") and (Rec."Bill-to Customer No." <> '')) or (Rec."IC Partner Code" <> ''))) or
                              (ZGT.IsRhq() and ZGT.IsZNetCompany()) or
                              (not ZGT.IsRhq());
        AddSubSetupEnable := ZGT.IsRhq();

        IsBillToCustomer := Rec."Bill-to Customer No." = Rec."No.";
        SampleAccountVisible := ZGT.IsRhq() and ZGT.IsZComCompany();
    end;

    local procedure SetEmailAddress()
    begin
        ReminderEmailAdd := CustReptMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::Reminder, Rec."E-Mail");
        StatementEmailAdd := CustReptMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"C.Statement", Rec."E-Mail");
        InvoiceEmailAdd := CustReptMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Invoice", Rec."E-Mail");
        OrderEmailAdd := CustReptMgt.GetEmailAddress(Database::Customer, Rec."No.", CustomReportSelection.Usage::"S.Order", Rec."E-Mail");
    end;
}
