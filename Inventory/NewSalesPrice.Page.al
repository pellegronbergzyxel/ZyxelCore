page 50112 "New Sales Price"
{
    ApplicationArea = Basic, Suite;
    Caption = 'New Sales Price';
    PageType = Card;
    SourceTable = "Price List Line";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ShowFilter = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Price List Code"; Rec."Price List Code")
                {
                    Editable = false;
                }
                group(Customer)
                {
                    ShowCaption = false;
                    field("Source Type"; Rec."Source Type")
                    {
                        Editable = false;
                    }
                    field("Assign-to No."; Rec."Assign-to No.")
                    {
                        Editable = CustNoEditable;
                        trigger OnValidate()
                        var
                            PriceHeader: Record "Price List Header";
                            SalesSetup: Record "Sales & Receivables Setup";
                        begin
                            SalesSetup.get;
                            if SalesSetup."Default Price List Code" <> '' then
                                Rec."Price List Code" := SalesSetup."Default Price List Code"
                            else begin
                                PriceHeader.SetRange("Source Type", PriceHeader."Source Type"::Customer);
                                PriceHeader.SetRange("Assign-to No.", Rec."Assign-to No.");
                                if PriceHeader.FindFirst() then
                                    Rec."Price List Code" := PriceHeader.Code;
                            end;
                        end;
                    }
                    field("Currency Code"; Rec."Currency Code") { }
                }
                group(Item)
                {
                    ShowCaption = false;
                    field("Asset Type"; Rec."Asset Type")
                    {
                        Editable = false;
                    }
                    field("Product No."; Rec."Product No.")
                    {
                        Editable = ItemNoEditable;

                        trigger OnValidate()
                        begin
                            Rec.CalcFields("Item Description");
                        end;
                    }
                    field("Item Description"; Rec."Item Description") { }
                    field("Unit of Measure Code"; Rec."Unit of Measure Code")
                    {
                        Editable = false;
                    }
                }
            }
            group(DateAndPrice)
            {
                Caption = 'Date & Price';
                group(Date)
                {
                    ShowCaption = false;
                    field("Starting Date"; Rec."Starting Date") { }
                    field("Ending Date"; Rec."Ending Date") { }
                }
                field("Minimum Quantity"; Rec."Minimum Quantity") { }
                field("Unit Price"; Rec."Unit Price") { }
            }
        }
    }
    var
        ItemNoEditable: Boolean;
        CustNoEditable: Boolean;

    trigger OnInit()
    begin
        ItemNoEditable := Rec."Asset No." = '';
        CustNoEditable := Rec."Assign-to No." = '';
        Rec."Minimum Quantity" := 1;
    end;
}
