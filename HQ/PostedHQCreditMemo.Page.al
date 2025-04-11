Page 50325 "Posted HQ Credit Memo"
{
    Caption = 'Posted HQ Credit Memo';
    CardPageID = "HQ Sales Header Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HQ Invoice Header";
    SourceTableView = sorting("Document Type", "No.")
                      order(descending)
                      where("Document Type" = const("Credit Memo"),
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
