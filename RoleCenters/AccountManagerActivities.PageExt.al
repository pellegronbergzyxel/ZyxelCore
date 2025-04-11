pageextension 50290 AccountManagerActivitiesZX extends "Account Manager Activities"
{
    layout
    {
        addafter("Incoming Documents")
        {
            cuegroup(Concur)
            {
                Caption = 'Concur';
                field("Open Travel Expenses"; Rec."Open Travel Expenses")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            cuegroup(eCommerce)
            {
                Caption = 'eCommerce';
                Visible = eCommerceVisible;
                field("eCommerce Orders"; Rec."eCommerce Orders")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("eCommerce Invoices"; Rec."eCommerce Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Invoice List";
                }
                field("eCommerce Cr. Memo"; Rec."eCommerce Cr. Memo")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Sales Credit Memos";
                }
            }
            cuegroup(Warehouse)
            {
                Caption = 'Warehouse';
                Visible = WarehouseVisible;
                field("Items not Invoiced"; Rec."Items not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Item Ledger Entries";
                }
                field("Whse. Purcase Resp. not Posted"; Rec."Whse. Purcase Resp. not Posted")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Whse. Ship Resp. not Posted"; Rec."Whse. Ship Resp. not Posted")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();  // 07-09-21 ZY-LD 001
    end;

    var
        eCommerceVisible: Boolean;
        WarehouseVisible: Boolean;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        //>> 07-09-21 ZY-LD 001
        eCommerceVisible :=
          (ZGT.IsRhq and ZGT.IsZNetCompany) or
          (ZGT.CompanyNameIs(11) and ZGT.IsZComCompany);
        //<< 07-09-21 ZY-LD 001

        WarehouseVisible := ZGT.IsRhq;  // 17-01-21 ZY-LD 002
    end;
}
