Page 62017 "Invoice Line List"
{
    // 001.  DT1.01  01-07-2010  SH
    //  .Documention for tectura customasation
    //  .Object created

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Sales Invoice Line";

    layout
    {
        area(content)
        {
            repeater(Control1101402000)
            {
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(CustomerDim; CustomerDim)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Profile';
                }
                field("Picking List No."; Rec."Picking List No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Packing List No."; Rec."Packing List No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoice Document No.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment No."; Rec."Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Line No."; Rec."Shipment Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Function")
            {
                Caption = 'Function';
                action("Posted Sales Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoice';

                    trigger OnAction()
                    var
                        InvHeader: Record "Sales Invoice Header";
                        InvoiceForm: Page "Posted Sales Invoice";
                    begin
                        //Tectura Taiwan ZL100507B+
                        Clear(InvHeader);
                        Clear(InvoiceForm);
                        InvHeader.SetFilter("No.", '%1', Rec."Document No.");
                        InvoiceForm.SetTableview(InvHeader);
                        InvoiceForm.RunModal;
                        //Tectura Taiwan ZL100507B-
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Add by Andrew 20100801 (+)
        defaultDimensionTb.Reset;
        defaultDimensionTb.SetRange(defaultDimensionTb."Table ID", 18);
        if defaultDimensionTb.FindFirst then begin
            defaultDimensionTb.SetRange(defaultDimensionTb."No.", Rec."Sell-to Customer No.");

            if defaultDimensionTb.FindFirst then begin
                defaultDimensionTb.SetRange(defaultDimensionTb."Dimension Code", 'CUSTOMERPROFILE');
                if defaultDimensionTb.FindFirst then begin
                    CustomerDim := defaultDimensionTb."Dimension Value Code";
                end;
            end;
        end;
        // Add by Andrew 20100801 (-)
        // Add by Andrew 20100820 (+)
        SalesInvoiceHeader.Reset;
        SalesInvoiceHeader.SetRange(SalesInvoiceHeader."No.", Rec."Document No.");
        if SalesInvoiceHeader.FindFirst then begin
            InvoicePostingDate := SalesInvoiceHeader."Posting Date";
        end;

        // Add by Andrew 20100820 (-)
    end;

    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        defaultDimensionTb: Record "Default Dimension";
        CustomerDim: Text[30];
        InvoicePostingDate: Date;
        SalesInvoiceHeader: Record "Sales Invoice Header";
}
