Page 50324 "Posted HQ Invoice"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Posted HQ Invoice';
    CardPageID = "HQ Sales Header Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = History;
    SourceTable = "HQ Invoice Header";
    SourceTableView = sorting("Document Type", "No.")
                      order(descending)
                      where("Document Type" = const(Invoice),
                            Status = const("Document is Posted"));

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
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
            action("Show Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Hyperlink(Rec.GetFilename);
                end;
            }
            action("Show Posted Purchase Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Posted Purchase Invoice';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Posted Purchase Invoice";
                RunPageLink = "Vendor Invoice No." = field("No.");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields(Rec."Purchase Order No.");
    end;

    trigger OnOpenPage()
    begin
        if not Rec.FindFirst then;
    end;

    var
        HqSalesDocMgt: Codeunit "HQ Sales Document Management";
}
