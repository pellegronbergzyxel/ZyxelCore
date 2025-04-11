pageextension 50101 CompanyInformationZX extends "Company Information"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("VAT Registration No.")
        {
            field("VAT Registration No. Domestic"; Rec."VAT Registration No. Domestic")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = '"VAT Registration No. Domestic" is used in Concur for identify the correct company.';
            }
            field("EORI No."; Rec."EORI No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = '"Eori No." enables the customs authorities of the other EU countries to recognize a company that is registered as an exporter. In Denmark is "VAT Reg. No." used as the "Eori No.".';
            }
        }
        addafter(Picture)
        {
            field("Logo Screen"; Rec."Logo Screen")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Logo Screen';
            }
            field("Business Mandatory"; Rec."Business Mandatory")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Home Page")
        {
            field("Finance Phone No."; Rec."Finance Phone No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Finance E-Mail"; Rec."Finance E-Mail")
            {
                ApplicationArea = Basic, Suite;
            }
            field("General Manager Title"; Rec."General Manager Title")
            {
                ApplicationArea = Basic, Suite;
            }
            field("General Manager Name"; Rec."General Manager Name")
            {
                ApplicationArea = Basic, Suite;
            }
            field("General Manager Address"; Rec."General Manager Address")
            {
                ApplicationArea = Basic, Suite;
            }
            field("General Manager City"; Rec."General Manager City")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Steuername; Rec.Steuername)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Steuernumber; Rec.Steuernumber)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Iban)
        {
            field("Bank Address"; Rec."Bank Address")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Bank Address 2"; Rec."Bank Address 2")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Bank City"; Rec."Bank City")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Bank Post Code"; Rec."Bank Post Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Bank Country/Region Code"; Rec."Bank Country/Region Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Ship-to Name")
        {
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Shipping)
        {
            group("Payment Information")
            {
                Caption = 'Payment Information';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("<Bank Account No. 2>"; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("<IBAN a>"; Rec.Iban)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code 2"; Rec."Currency Code 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bank Account No. 2"; Rec."Bank Account No. 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("IBAN 2"; Rec."IBAN 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code 3"; Rec."Currency Code 3")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("<Bank Account No. 3>"; Rec."Bank Account No. 3")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("IBAN 3"; Rec."IBAN 3")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code 4"; Rec."Currency Code 4")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bank Account No. 4"; Rec."Bank Account No. 4")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("IBAN 4"; Rec."IBAN 4")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(UK)
                {
                    Caption = 'UK';
                    field("Wee Registration No."; Rec."Wee Registration No.")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
        addafter("System Indicator")
        {
            group(Mapping)
            {
                Caption = 'Mapping';
                field("HQ Company Name"; Rec."HQ Company Name")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        addafter(Codes)
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite, Advanced;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(79));
                }
            }
        }
    }
}
