Page 50083 "HQ Sales Header List"
{
    // 001. 07-11-19 ZY-LD 000 - Download document.

    ApplicationArea = Basic, Suite;
    Caption = 'HQ Sales Header List';
    CardPageID = "HQ Sales Header Card";
    Editable = false;
    PageType = List;
    SourceTable = "HQ Invoice Header";
    SourceTableView = where(Status = filter(<> "Document is Posted"));
    UsageCategory = Lists;

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
                field(Status; Rec.Status)
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
                var
                    FileMgt: Codeunit "File Management";
                begin
                    Rec.DownloadToClient();
                end;
            }
            action("Purchase Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Order';
                Image = "Order";
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageLink = "Document Type" = const(Order),
                              "No." = field("Purchase Order No.");
            }
            action("EiCard Queue")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EiCard Queue';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "EiCard Queue";
                RunPageLink = "Purchase Order No." = field("Purchase Order No.");
            }
        }
        area(processing)
        {
            action("Download Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Download Document';
                Image = LinkWeb;

                trigger OnAction()
                begin
                    //>> 07-11-19 ZY-LD 001
                    if Rec."File Path" = '' then
                        if Confirm(Text001, true) then begin
                            Rec.DownloadDocument(true);
                            Hyperlink(Rec.GetFilename);
                        end;
                    //<< 07-11-19 ZY-LD 001
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields(Rec."Purchase Order No.");
    end;

    var
        HqSalesDocMgt: Codeunit "HQ Sales Document Management";
        Text001: label 'Do you want to download the document?';
}
