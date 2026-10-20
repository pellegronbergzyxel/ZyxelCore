page 50151 "Sales Price Line Archive List"
{   //22-09-2026 BK #558088
    PageType = List;
    SourceTable = "Price List Line Archive";
    ApplicationArea = All;
    UsageCategory = administration;
    Caption = 'Price List Line Archive';
    editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Price List Code"; Rec."Price List Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Price Type"; Rec."Price Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Asset Type"; Rec."Asset Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("New Price"; Rec."New Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
                field("Automatically Added"; Rec."Automatically Added")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fields';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActivateLine)
            { //22-09-2026 BK #558088
                ApplicationArea = All;
                Caption = 'Activate Line';
                ToolTip = 'Moves the selected archived price line back to the active price list.';
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PriceListArchiveMgt: Codeunit AmazonHelper;
                begin
                    if not Confirm(
                        'Do you want to activate line %1 for Price List %2?',
                        false,
                        Rec."Line No.",
                        Rec."Price List Code")
                    then
                        exit;

                    PriceListArchiveMgt.RestorePriceListLines(Rec."Price List Code");

                    CurrPage.Update(false);
                end;
            }
        }
    }
}