page 50259 "eCommerce Payment Card"
{
    Caption = 'eCommerce Payment';
    DataCaptionFields = "Order ID";
    DeleteAllowed = false;
    Description = 'eCommerce Payment';
    InsertAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "eCommerce Payment";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'eCommerce Order';
                field("eCommerce Market Place"; Rec."eCommerce Market Place")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Error x"; Rec."Error x")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Exception; Rec.Exception)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order ID"; Rec."Order ID")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'eCommerce Order No.';
                }
                field("eCommerce Invoice No."; Rec."eCommerce Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'eCommerce Invoice No.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Detail"; Rec."Payment Detail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Product Title"; Rec."Product Title")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Description';
                    Editable = false;
                }
                field("Ship To Country"; Rec."Ship To Country")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transaction Summary"; Rec."Transaction Summary")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                field("Source Invoice No."; Rec."Source Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purchase Invoice No."; Rec."Purchase Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sales Credit No."; Rec."Sales Credit No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Fee Purchase Invoice No."; Rec."Fee Purchase Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Fee Purchase Invoice No.';
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Posting Currency Code"; Rec."Posting Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Type"; Rec."Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cash Receipt Journals Line"; Rec."Cash Receipt Journals Line")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Upload)
            {
                Caption = 'Upload';
                field(Filename; Rec.Filename)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
        }
    }

    var
        ChargeAccount: Code[20];
        FeeAccount: Code[20];
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        CurrencyCode: Code[20];
        Vendor: Code[20];
        PostingCompanyName: Code[20];
        GenJnlManagement: Codeunit GenJnlManagement;
        Text0001: Label 'Setting selection to Open.\';
        Text0002: Label 'Are you sure that you want to change the selection to Open?';
        Text0003: Label 'Setting selection to Closed.\';
        Text0004: Label 'Are you sure that you want to change the selection to Closed?';
        Err0001: Label 'The Company does not exist in the eCommerce Setup.';
        Err0002: Label 'The Company is not Active in the eCommerce Setup.';
        Err0003: Label 'The eCommerce Setup is not complete.';
        Err0004: Label 'General Journal Batch %1 Cannot be found.';
        Text0005: Label 'Are you sure that you want to delete all the eCommerce Journal Lines?';
        Text0006: Label 'Deleting eCommerce Journal Lines.\';
}
