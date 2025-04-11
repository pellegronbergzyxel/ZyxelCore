Page 50058 "VAT Reg. No. pr. Locations"
{
    ApplicationArea = Basic, Suite;
    Caption = 'VAT Registration No. Setup';
    PageType = List;
    SourceTable = "VAT Reg. No. pr. Location";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Send-from Country/Region"; Rec."Send-from Country/Region")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Customer Country Code"; Rec."Ship-to Customer Country Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Country Code"; Rec."VAT Country Code")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        Rec.CalcFields(Rec."VAT Registration No.");
                    end;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EORI No."; Rec."EORI No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(navigation)
        {
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Change Log Entries";
                RunPageLink = "Primary Key Field 1 Value" = field("Location Code"),
                              "Primary Key Field 2 Value" = field("Ship-to Customer Country Code"),
                              "Primary Key Field 3 Value" = field("Sell-to Customer No.");
                RunPageView = sorting("Table No.", "Date and Time")
                              order(descending)
                              where("Table No." = const(50005));
            }
        }
    }
}
