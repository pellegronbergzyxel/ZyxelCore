pageextension 50185 SalesReceivablesSetupZX extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Archive Return Orders")
        {
            field("Use Sell-to text code filter"; Rec."Use Sell-to text code filter")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Zero Unit cost on Sales line"; Rec."Zero Unit cost on Sales line")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Customer No. on Sister Company"; Rec."Customer No. on Sister Company")
            {
                ApplicationArea = Basic, Suite;
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
                field("Margin Approval"; Rec."Margin Approval")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the new prices entered in the price book or changed prices on sales order or sales invoice must be sent for approval in headquarter.';
                }
                field("Full Pallet / Carton Ordering"; Rec."Full Pallet / Carton Ordering")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Order Type Mandatory"; Rec."Sales Order Type Mandatory")
                {
                    ApplicationArea = Basic, Suite;
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
                }
                field("Calculate Shipment Date"; Rec."Calculate Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
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
                    }
                    group("Delivery Documents")
                    {
                        field("Delivery Days to Add"; Rec."Delivery Days to Add")
                        {
                            ApplicationArea = Basic, Suite;
                        }
                    }
                }
                group("Let Me Repair")
                {
                    field("LMR Item Journal Batch Name"; Rec."LMR Item Journal Batch Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LMR Item Journal Template Name"; Rec."LMR Item Journal Template Name")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LMR Gen. Prod. Posting Group"; Rec."LMR Gen. Prod. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LMR Division"; Rec."LMR Division")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LMR Department"; Rec."LMR Department")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LMR Value Bin"; Rec."LMR Value Bin")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("LMR Country Code"; Rec."LMR Country Code")
                    {
                        ApplicationArea = Basic, Suite;
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
