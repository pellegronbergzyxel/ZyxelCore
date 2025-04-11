page 50353 "eCommerce Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Setup';
    SourceTable = "eCommerce Setup";
    UsageCategory = Administration;
    AdditionalSearchTerms = 'ecommerce setup';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Payment Batch Nos."; Rec."Payment Batch Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posted Document Path"; Rec."Posted Document Path")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("N/A Retention Period"; Rec."N/A Retention Period")
                {
                    ApplicationArea = Basic, Suite;
                    Tooltip = 'Specifies the period orders with invoice "N/A" is held until we post them. If an order with a real invoice no., and the same amount is found, the N/A order will be deleted.';
                }
            }
            group(Import)
            {
                Caption = 'Import';
                group(Orders)
                {
                    Caption = 'Orders';
                    group("Tax Library Document")
                    {
                        Caption = 'Tax Library Document';
                        field("API Import Path"; Rec."API Import Path")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Path';
                        }
                        field("API Import Archive Path"; Rec."API Import Archive Path")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Archive Path';
                        }
                        field("API Import Error Path"; Rec."API Import Error Path")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Error Path';
                        }
                    }
                    group("Fulfilled Shipments")
                    {
                        Caption = 'Fulfilled Shipments';
                        field("API Import Fulfil. Order  Path"; Rec."API Import Fulfil. Order  Path")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Path';
                        }
                        field("API Import Fulfi. Archive Path"; Rec."API Import Fulfi. Archive Path")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Archive Path';
                        }
                        field("API Import Fulfi. Error Path"; Rec."API Import Fulfi. Error Path")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Error Path';
                        }
                    }
                }
                group(Returns)
                {
                    Caption = 'Returns';
                    group("FBA Customer Return")
                    {
                        Caption = 'FBA Customer Return';
                        field("API Import Return Order  Path"; Rec."API Import Return Order  Path")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Path';
                        }
                        field("API Import Return Archive Path"; Rec."API Import Return Archive Path")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Archive Path';
                        }
                        field("API Import Return Error Path"; Rec."API Import Return Error Path")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Error Path';
                        }
                    }
                }
                group(Payment)
                {
                    Caption = 'Payment';
                    field("API Import Payment Path"; Rec."API Import Payment Path")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Path';
                    }
                    field("API Import Payment Arch. Path"; Rec."API Import Payment Arch. Path")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Path';
                    }
                    field("API Import Payment Error Path"; Rec."API Import Payment Error Path")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Error Path';
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then
            Rec.Insert();
    end;
}
