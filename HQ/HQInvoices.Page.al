Page 50071 "HQ Invoices"
{
    Caption = 'HQ Invoices';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HQ EICard Invoices";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Matched; Rec.Matched)
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
            group(Line)
            {
                Caption = 'Line';
                action("View Source Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'View Source Document';
                    Image = ViewOrder;

                    trigger OnAction()
                    var
                        recPurchasesPayablesSetup: Record "Purchases & Payables Setup";
                        InvFolder: Text[250];
                    begin
                        if recPurchasesPayablesSetup.FindFirst then begin
                            InvFolder := recPurchasesPayablesSetup."EiCard HQ Invoice Folder";
                            Hyperlink(InvFolder + '\' + Rec."Document Name");
                        end;
                    end;
                }
            }
        }
    }


    procedure SetFilter(OrderNo: Code[20])
    begin
        Rec.SetFilter("Order No.", OrderNo);
    end;
}
