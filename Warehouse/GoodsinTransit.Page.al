Page 50109 "Goods in Transit"
{
    // 001. 05-04-18 ZY-LD 2018040510000101 - New category codes.
    // 002. 14-01-19 ZY-LD 000 - Fields peplaced with calculated fields.
    // 003. 14-01-20 ZY-LD 000 - Filtered on SBU Company.

    ApplicationArea = Basic, Suite;
    Caption = 'HQ - Goods in Transit';
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "VCK Shipping Detail";
    SourceTableView = where(Archive = const(false),
                            "SBU Company" = filter("ZCom HQ" | "ZNet HQ"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field("Bill of Lading No."; Rec."Bill of Lading No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Category 1 Code"; Rec."Item Category 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 1 Code';
                }
                field("Item Category 2 Code"; Rec."Item Category 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 2 Code';
                }
                field("Item Category 3 Code"; Rec."Item Category 3 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Category 3 Code';
                }
                field("Division Code"; Rec."Division Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Quantity-""Quantity Received"""; Rec.Quantity - Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 2;
                    Visible = false;
                }
                field("Calculated Quantity"; Rec."Calculated Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unit Price';
                    DecimalPlaces = 2 : 5;
                }
                field("(Quantity-""Quantity Received"") * ""Direct Unit Cost"""; (Rec.Quantity - Rec."Quantity Received") * Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount';
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("SBU Company"; Rec."SBU Company")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Show Purchase Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Purchase Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageLink = "Document Type" = const(Order),
                              "No." = field("Purchase Order No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Rec."Quantity Received", Rec."Direct Unit Cost");
        Rec."Calculated Quantity" := Rec.Quantity - Rec."Quantity Received";
        Rec.Amount := Rec."Calculated Quantity" * Rec."Direct Unit Cost";
        //>> 14-01-19 ZY-LD 002
        /*
        PurchaseLine.SETFILTER("Document No.","Purchase Order No.");
        PurchaseLine.SETFILTER("Line No.",FORMAT("Purchase Order Line No."));
        IF PurchaseLine.FINDFIRST THEN BEGIN
          UPrice := PurchaseLine."Direct Unit Cost";
          TAmount := Quantity * UPrice;
          ItemDescription := PurchaseLine.Description;
          RecItem.SETFILTER(RecItem."No.", PurchaseLine."No.");
          IF RecItem.FINDFIRST THEN BEGIN
            //>> 05-04-18 ZY-LD 001
            //CAT1 :=  PurchaseLine."Item Category Code";
            //CAT2 :=  RecItem."Product Group Code";
            CAT1OLD :=  PurchaseLine."Item Category Code";
            CAT1 :=  RecItem."Category 1 Code";
            CAT2 :=  RecItem."Category 2 Code";
            //<< 05-04-18 ZY-LD 001
          END;
        END;
        */
        //<< 14-01-19 ZY-LD 002

    end;

    var
        PurchaseLine: Record "Purchase Line";
        UPrice: Decimal;
        TAmount: Decimal;
        ItemDescription: Text[50];
        RecItem: Record Item;
        CAT2: Code[100];
        CAT1: Code[100];
        CAT1OLD: Code[10];
}
