Page 50093 "VCK Country Shipment Days"
{
    // 001. 06-09-18 ZY-LD 2018090610000046 - New fields.
    // 002. 01-04-19 ZY-LD 000 - Block DD Release.

    ApplicationArea = Basic, Suite;
    Caption = 'Country Picking Days';
    PageType = List;
    SourceTable = "VCK Country Shipment Days";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Block DD Release from"; Rec."Block DD Release from")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Min. Amount to Ship"; Rec."Min. Amount to Ship")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Time"; Rec."Shipment Time")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Monday; Rec.Monday)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Tuesday; Rec.Tuesday)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Wednesday; Rec.Wednesday)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Thursday; Rec.Thursday)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Thursday';
                }
                field(Friday; Rec.Friday)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Delivery Days"; Rec."Delivery Days")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Eoq Start Date"; Rec."Eoq Start Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Eoq End Date"; Rec."Eoq End Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Eoq Date Formula"; Rec."Eoq Date Formula")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-To Code"; Rec."Ship-To Code")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Get All Countries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Get All Countries';
                    Image = CountryRegion;

                    trigger OnAction()
                    begin
                        AllInLogistics.GetCountryDeliveryDaysCountrie;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        AllInLogistics: Codeunit "ZyXEL VCK";
}
