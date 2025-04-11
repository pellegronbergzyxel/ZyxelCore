Page 50198 "Currency Exchange Rate Buffer"
{
    Caption = 'Currency Exchange Rate Buffer';
    DataCaptionFields = "Currency Code";
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Currency Exchange Rate Buffer";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Company; Rec.Company)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("LCY Code"; Rec."LCY Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Relational Currency Code"; Rec."Relational Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Exchange Rate Amount"; Rec."Exchange Rate Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Relational Exch. Rate Amount"; Rec."Relational Exch. Rate Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Adjustment Exch. Rate Amount"; Rec."Adjustment Exch. Rate Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Relational Adjmt Exch Rate Amt"; Rec."Relational Adjmt Exch Rate Amt")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Fix Exchange Rate Amount"; Rec."Fix Exchange Rate Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Help Message")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Help Message';
                Image = Help;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Message(Text001);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
    end;

    var
        recExchRateTmp: Record "Currency Exchange Rate Buffer" temporary;
        recCngLogEntry: Record "Change Log Entry";
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        ChangeHasBeenMade: Boolean;
        Text001: label 'You can modify or delete lines from this temporary table.\The data you see in this page will be updated in the current companies.\\Click OK, to replicate.';
}
