page 50240 "eCommerce Order Subform"
{
    Caption = 'eCommerce Order Subform';
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "eCommerce Order Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ASIN; Rec.ASIN)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies ASIN';
                    Editable = false;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Item no.';
                    Editable = false;
                }
                field("Unexpected Item"; Rec."Unexpected Item")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Unexpected Item';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Description';
                    Editable = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies VAT Prod. Posting Group';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Quantity';
                    Editable = false;
                }
                field("Item Price (Exc. Tax)"; Rec."Item Price (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Item Price (Exc. Tax)';
                    Editable = false;
                }
                field("Total (Exc. Tax)"; Rec."Total (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total (Exc. Tax)';
                    Editable = false;
                }
                field("Item Price (Inc. Tax)"; Rec."Item Price (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Item Price (Inc. Tax)';
                    Editable = false;
                }
                field("Line Discount Pct."; Rec."Line Discount Pct.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Line Discount Pct.';
                }
                field("Line Discount Excl. Tax"; Rec."Line Discount Excl. Tax")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Line Discount Excl. Tax';
                }
                field("Line Discount Incl. Tax"; Rec."Line Discount Incl. Tax")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Line Discount Incl. Tax';
                }
                field("Total Tax Amount"; Rec."Total Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total Tax Amount';
                    Editable = false;
                }
                field("Total (Inc. Tax)"; Rec."Total (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total (Inc. Tax)';
                    Editable = false;
                }
                field("Total Promo (Inc. Tax)"; Rec."Total Promo (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total Promo (Inc. Tax)';
                    Editable = false;
                    Visible = false;
                }
                field("Total Promo Tax Amount"; Rec."Total Promo Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total Promo Tax Amount';
                    Editable = false;
                    Visible = false;
                }
                field("Total Promo (Exc. Tax)"; Rec."Total Promo (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total Promo (Exc. Tax)';
                    Editable = false;
                    Visible = false;
                }
                field("Total Shipping (Inc. Tax)"; Rec."Total Shipping (Inc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total Shipping (inc. Tax)';
                    Editable = false;
                    Visible = false;
                }
                field("Total Shipping Tax Amount"; Rec."Total Shipping Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total Shipping Tax Amount';
                    Editable = false;
                    Visible = false;
                }
                field("Total Shipping (Exc. Tax)"; Rec."Total Shipping (Exc. Tax)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Total Shipping (Exc. Tax)';
                    Editable = false;
                    Visible = false;
                }
                field("Line Discount Tax Amount"; Rec."Line Discount Tax Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies Line Discount Tax Amount';
                    Editable = false;
                    Visible = false;
                }
            }
            group(Control26)
            {
                ShowCaption = false; //02-06-2025 BK #IT Cleanup
                group(Control27)
                {
                    ShowCaption = false; //02-06-2025 BK #IT Cleanup
                    field("recAmzOrderHead.Amount"; recAmzOrderHead.Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(recAmzOrderHead."Currency Code");
                        Caption = 'Total Amount Excl. VAT';
                        ToolTip = 'Specifies Total Amount Excl. VAT';
                        Editable = false;
                    }
                    field("recAmzOrderHead.""Tax Amount"""; recAmzOrderHead."Tax Amount")
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(recAmzOrderHead."Currency Code");
                        Caption = 'Total VAT';
                        ToolTip = 'Specifies Total VAT';
                        Editable = false;
                    }
                    field("recAmzOrderHead.""Amount Including VAT"""; recAmzOrderHead."Amount Including VAT")
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(recAmzOrderHead."Currency Code");
                        Caption = 'Total Amount Incl. VAT';
                        ToolTip = 'Specifies Total Amount Incl. VAT';
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Line")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit Line';
                ToolTip = 'Edit Line';
                Image = EditLines;

                trigger OnAction()
                begin
                    Rec.EditLine();
                    CurrPage.Update();
                end;
            }
            action("Change Item No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Item No.';
                ToolTip = 'Change Item No.';
                Enabled = ChangeItemNoEnable;
                Image = Item;

                trigger OnAction()
                begin
                    ChangeItemNo();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ChangeItemNoEnable := Rec."Unexpected Item";

        if (Rec."Transaction Type" <> recAmzOrderHead."Transaction Type") or
           (Rec."eCommerce Order Id" <> recAmzOrderHead."eCommerce Order Id") or
           (Rec."Invoice No." <> recAmzOrderHead."Invoice No.")
        then begin
            recAmzOrderHead.SetAutoCalcFields(Amount, "Tax Amount", "Amount Including VAT");
            recAmzOrderHead.Get(Rec."Transaction Type", Rec."eCommerce Order Id", Rec."Invoice No.");
        end;
    end;

    var
        recAmzOrderHead: Record "eCommerce Order Header";
        DocumentTotals: Codeunit "Document Totals";
        ChangeItemNoEnable: Boolean;

    local procedure ChangeItemNo()
    var
        lItem: Record Item;
        GenericInputPage: Page "Generic Input Page";
        lText001: Label 'Enter Item No.';
        lText002: Label 'New Item No.';
        lText003: Label '%1 %2 was not found.';
    begin

        GenericInputPage.SetPageCaption(lText001);
        GenericInputPage.SetFieldCaption(lText002);
        GenericInputPage.SetVisibleField(3);  // Code 20
        if GenericInputPage.RunModal() = Action::OK then
            if lItem.Get(GenericInputPage.GetCode20()) then begin
                Rec.Validate(Rec."Item No.", GenericInputPage.GetCode20());
                Rec.Validate(Rec.Description, lItem.Description);
                Rec."Unexpected Item" := false;
                Rec.Modify(true);
            end else
                Error(lText003, Rec.FieldCaption(Rec."Item No."), GenericInputPage.GetCode20());
    end;
}
