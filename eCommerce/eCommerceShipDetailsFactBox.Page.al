page 50236 "eCommerce Ship Details FactBox"
{
    Caption = 'Ship - Details';
    PageType = CardPart;
    SourceTable = "eCommerce Order Header";

    layout
    {
        area(content)
        {
            group("Ship-to")
            {
                Caption = 'Ship-to';
                field("Ship To Postal Code"; Rec."Ship To Postal Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Postal Code';
                }
                field("Ship To City"; Rec."Ship To City")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'City';
                }
                field("Ship To State"; Rec."Ship To State")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'State';
                }
                field("Ship To Country"; Rec."Ship To Country")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Country';
                }
            }
            group("Ship-from")
            {
                Caption = 'Ship-from';
                field("Ship From Postal Code"; Rec."Ship From Postal Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Postal Code';
                }
                field("Ship From City"; Rec."Ship From City")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'City';
                }
                field("Ship From State"; Rec."Ship From State")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'State';
                }
                field("Ship From Country"; Rec."Ship From Country")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Country';
                }
                field("Ship From Tax Location Code"; Rec."Ship From Tax Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Tax Location Code';
                }
            }
        }
    }
}
