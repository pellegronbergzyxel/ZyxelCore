page 50260 "eComm. Payment Journal Batches"
{
    ApplicationArea = Basic, Suite;
    Caption = 'eCommerce Payment Journal Batches';
    PageType = List;
    SourceTable = "eCommerce Payment Header";
    SourceTableView = sorting(Date)
                      order(descending);
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specified No.';
                    StyleExpr = StyleText;
                }
                field("Market Place ID"; Rec."Market Place ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    StyleExpr = StyleText;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    StyleExpr = StyleText;
                }
                field("Transaction Summary"; Rec."Transaction Summary")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field("Deposit Date"; Rec."Deposit Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    StyleExpr = StyleText;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    StyleExpr = StyleText;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    StyleExpr = StyleText;
                }
                field("Transfered Amount"; Rec."Transfered Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    StyleExpr = StyleText;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    StyleExpr = StyleText;
                    Visible = false;
                }
                field("Settlement ID"; Rec."Settlement ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control29; "Payment Header FactBox2")
            {
                Caption = 'Posting Reconciliation';
                ToolTip = 'Specifies field';
                SubPageLink = "No." = field("No.");
            }
            part(Control30; "Payment Header FactBox")
            {
                Caption = 'Payment Dashboard';
                ToolTip = 'Specifies field';
                SubPageLink = "No." = field("No.");
            }
            systempart(Control18; Links)
            {
                Visible = false;
            }
            systempart(Control17; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            Action(EditJournal)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies field';
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "eCommerce Payment Journal";
                RunPageLink = "Journal Batch No." = field("No.");
                ShortCutKey = 'Return';
            }
            Action(Action14)
            {
                Caption = 'Update Magento Payment';
                ToolTip = 'Specifies field';
                ApplicationArea = Basic, Suite;
                RunObject = Report "Update Magento Payment";
            }
            group(Import)
            {
                Caption = 'Import';
                Action("Import Batch")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    Caption = 'Import Batch';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        APIMgt: Codeunit "API Management";
                    begin
                        // APIMgt.ImportPayments;
                        message('use [Import eCommerce Payments]')
                    end;
                }
                Action("Import eCommerce Payments")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    Caption = 'Import eCommerce Payments';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        XmlPort.Run(XmlPort::"Import eCommerce Payment", true);
                        CurrPage.Update();
                    end;
                }
                Action(Action25)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    Caption = 'Import eCommerce Payments';
                    Image = Import;

                    trigger OnAction()
                    begin
                        XmlPort.Run(XmlPort::"eCommerce Payment Import", true);
                        CurrPage.Update();
                    end;
                }
                Action("Import eCommerce Payments - OLD LAYOUT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    Caption = 'Import eCommerce Payments - OLD LAYOUT';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        XmlPort.Run(XmlPort::"Import eComm. Payment - TEMP", true);
                        CurrPage.Update();
                    end;
                }
            }
        }
        area(navigation)
        {
            group(Setup)
            {
                Caption = 'Setup';
                Action("Payment Matrix")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies field';
                    Caption = 'Payment Matrix';
                    Image = ShowMatrix;
                    RunObject = Page "eCommerce Pay. Matrix List";
                }
                Action(eCommerceTransactionSummary)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'eCommerce Transaction Summary';
                    Description = 'eCommerce Transaction Summary';
                    Image = Transactions;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "eCommerce Transaction Summary";
                    ToolTip = 'eCommerce Transaction Summary';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions();
    end;

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst() then;
        SetActions();
    end;

    var
        StyleText: Text;

    local procedure SetActions()
    var
        PaymentLine: Record "eCommerce Payment";

    begin
        if Rec.Open then
            StyleText := 'Standard'
        else begin //20-10-2026 BK #589630
            styleText := 'Subordinate';
            PaymentLine.SetRange("Journal Batch No.", Rec."No.");
            PaymentLine.SetRange(Open, true);
            if not PaymentLine.IsEmpty() then
                StyleText := 'Unfavorable';
        end;
    end;
}
