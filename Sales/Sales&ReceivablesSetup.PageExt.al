pageextension 50185 SalesReceivablesSetupZX extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Archive Return Orders")
        {
            field("Use Sell-to text code filter"; Rec."Use Sell-to text code filter")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies whether to use the Sell-to Customer Text Code filter when creating sales documents from templates. When this field is selected, only templates with a matching Sell-to Customer Text Code will be available for selection.';
            }
            field("Zero Unit cost on Sales line"; Rec."Zero Unit cost on Sales line")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies whether to allow zero unit cost on sales lines. When this field is selected, users can enter sales lines with a unit cost of zero.';
            }
            field("Customer No. on Sister Company"; Rec."Customer No. on Sister Company")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the customer number to be used for transactions involving sister companies. This customer number will be used when processing sales and receivables transactions between sister companies within the organization.';
            }
        }
        addafter("Background Posting")
        {
            group(Zyxel)
            {
                Caption = 'Zyxel';
                field("Calc. Sales Price Based on"; Rec."Calc. Sales Price Based on")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies which date field the sales price calculation is based on.';
                }
                field("Margin Approval"; Rec."Margin Approval") //30-10-2025 BK #MarginApproval
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the new prices entered in the price book or changed prices on sales order or sales invoice must be sent for approval in headquarter.';
                }
                field("Full Pallet / Carton Ordering"; Rec."Full Pallet / Carton Ordering")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to enforce full pallet or carton ordering on sales orders. When this field is selected, users must order items in full pallet or carton quantities as defined in the item setup.';
                }
                field("Sales Order Type Mandatory"; Rec."Sales Order Type Mandatory")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the Sales Order Type field is mandatory when creating sales orders. When this field is selected, users must specify a Sales Order Type for each sales order.';
                }

                field("Del. Doc. Creation Calculation"; Rec."Del. Doc. Creation Calculation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'When creating delivery documents a filter is set on "Picking Date (Shipment Date)" on the sales order line. The filter is  <.."TODAY" + "Delivery Doc. Creation Calculation">.';
                }
                field("All-In Logistics Location"; Rec."All-In Logistics Location")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'VCK Location';
                    ToolTip = 'Specifies the location code used for All-In Logistics (VCK) operations. This location code will be used for inventory management and order fulfillment processes related to All-In Logistics services.';
                }
                field("Calculate Shipment Date"; Rec."Calculate Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to automatically calculate the "Shipment Date" on the sales order header based on the "Requested Delivery Date" and other factors such as lead times and availability.';
                }
                field("Default Shipment Date"; Rec."Default Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Calculate "Shipment Date" on sales order header. If the field is left blank, "Shipment Date" will be set to Workdate.';
                }
                field("Print Req. Del. Date on O.Conf"; Rec."Print Req. Del. Date on O.Conf")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Print "Requested Delivery Date" from the sales order line on the order confirmation, if the date is different from "Requested Delivery Date" on the sales order header.';
                }
                field("Calc. Local VAT for Currency"; Rec."Calc. Local VAT for Currency")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to calculate local VAT based on the currency of the transaction. When this field is selected, local VAT will be calculated according to the currency used in the sales document.';
                }
                group(BacklogCmtUnderMinAmount)
                {
                    Caption = 'Backlog Comment under Min. Amount';
                    field(BacklogComment; BacklogComment)
                    {
                        ApplicationArea = Basic, Suite;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the comment that will be added to the Backlog report, that is sent automatically, when the amount is under the "Min. Amount to Pick" found in the "Country Picking Days".';

                        trigger OnValidate()
                        begin
                            Rec.SetBacklogComment(BacklogComment);
                        end;
                    }
                }
                group(EiCards)
                {
                    field("EiCard Automation Enabled"; Rec."EiCard Automation Enabled")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies whether EiCard automation is enabled for sales and receivables processes. When this field is selected, EiCard functionalities will be available for use in relevant transactions.';
                    }
                    group("Delivery Documents")
                    {
                        field("Delivery Days to Add"; Rec."Delivery Days to Add")
                        {
                            ApplicationArea = Basic, Suite;
                            ToolTip = 'Specifies the number of delivery days to add when calculating the expected delivery date for sales orders and invoices processed through EiCard.';
                        }
                    }
                }
                group("Let Me Repair")
                {
                    field("LMR Item Journal Batch Name"; Rec."LMR Item Journal Batch Name")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the name of the item journal batch used for Let Me Repair (LMR) processes. This batch is used to track and manage item journals related to LMR activities.';
                    }
                    field("LMR Item Journal Template Name"; Rec."LMR Item Journal Template Name")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the name of the item journal template used for Let Me Repair (LMR) processes. This template provides a predefined structure for item journals related to LMR activities.';
                    }
                    field("LMR Gen. Prod. Posting Group"; Rec."LMR Gen. Prod. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the general product posting group used for Let Me Repair (LMR) processes. This posting group determines how LMR-related transactions are recorded in the general ledger.';
                    }
                    field("LMR Division"; Rec."LMR Division")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the division associated with Let Me Repair (LMR) processes. This division is used to categorize and manage LMR-related activities within the organization.';
                    }
                    field("LMR Department"; Rec."LMR Department")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the department associated with Let Me Repair (LMR) processes. This department is used to categorize and manage LMR-related activities within the organization.';
                    }
                    field("LMR Value Bin"; Rec."LMR Value Bin")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value bin used for Let Me Repair (LMR) processes. This bin is used to store and manage items related to LMR activities.';
                    }
                    field("LMR Country Code"; Rec."LMR Country Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the country code associated with Let Me Repair (LMR) processes. This country code is used to manage LMR-related activities in compliance with local regulations and requirements.';
                    }
                }
                group(NLtoDK)
                {
                    Caption = 'NL to DK VAT Posting';
                    field("Run NL to DK Posting"; Rec."Run NL to DK Posting")
                    {
                        ToolTip = 'Specifies to run NL to DK Posing. Products sold to DK from NL don´t have a natural inbound VAT entry. By running "NL to DK Posting" correct VAT entries will be created.';
                    }
                    field("NL to DK Customer No."; Rec."NL to DK Customer No.")
                    {
                        ToolTip = 'Specifies which customer account the invoice should be posted on.';
                    }
                    field("NL to DK Debit Account No."; Rec."NL to DK Debit Account No.")
                    {
                        ToolTip = 'Specifies the debit account no.';
                    }
                    field("NL to DK Credit Account No."; Rec."NL to DK Credit Account No.")
                    {
                        ToolTip = 'Specifies the credit account no.';
                    }
                    field("NL to DK VAT Prod. Post. Grp."; Rec."NL to DK VAT Prod. Post. Grp.")
                    {
                        ToolTip = 'Specifies the "VAT Prod. Posting Group" the reverse line will be posted with.';
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BacklogComment := Rec.GetBacklogComment();
    end;

    var
        BacklogComment: Text;
}
