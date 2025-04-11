Page 50147 "Sales Invoice Line"
{
    ApplicationArea = Basic, Suite;
    Editable = false;
    PageType = List;
    SourceTable = "Sales Invoice Line";
    SourceTableView = order(descending)
                      where("Sales Order Type" = filter(Normal | EICard),
                            Type = const(Item),
                            "Location Code" = filter('EU2' | 'VCK ZNET' | 'EICARD'));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sales Order Type"; Rec."Sales Order Type")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Order Type';
                }
                field("Picking List No."; Rec."Picking List No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(PackingListNo; PackingListNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Packing List No';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'External Document No.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sell-to Customer No.';
                }
                field(SellToCUstomerName; recCustTmp.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sell-to Customer Name';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoice Document No.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Line No.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type';
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
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; Rec."Currency Code")
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
                field(CountryCode; CountryCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Country Code';
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
                field(QtyPerCarton; QtyPerCarton)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty. per Carton';
                }
                field(SoldPerCarton; SoldPerCarton)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sold per Carton';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(ShowPostedDocument)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Posted Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin

                    SalesInvHeader.Get(Rec."Document No.");
                    Page.Run(Page::"Posted Sales Invoice", SalesInvHeader);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        recDefaultDimension: Record "Default Dimension";
        recSalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        DivisionCode := '';
        DepartmentCode := '';
        CountryCode := '';
        CustomerProfile := '';
        InvoicePostingDate := 0D;
        recDefaultDimension.SetRange("Table ID", 18);
        recDefaultDimension.SetFilter("Dimension Code", 'DIVISION');
        recDefaultDimension.SetFilter("No.", Rec."Sell-to Customer No.");
        if recDefaultDimension.FindFirst then DivisionCode := recDefaultDimension."Dimension Value Code";
        recDefaultDimension.Reset;
        recDefaultDimension.SetRange("Table ID", 18);
        recDefaultDimension.SetFilter("Dimension Code", 'DEPARTMENT');
        recDefaultDimension.SetFilter("No.", Rec."Sell-to Customer No.");
        if recDefaultDimension.FindFirst then DepartmentCode := recDefaultDimension."Dimension Value Code";
        recDefaultDimension.Reset;
        recDefaultDimension.SetRange("Table ID", 18);
        recDefaultDimension.SetFilter("Dimension Code", 'COUNTRY');
        recDefaultDimension.SetFilter("No.", Rec."Sell-to Customer No.");
        if recDefaultDimension.FindFirst then CountryCode := recDefaultDimension."Dimension Value Code";
        recDefaultDimension.Reset;
        recDefaultDimension.SetRange("Table ID", 18);
        recDefaultDimension.SetFilter("Dimension Code", 'CUSTOMERPROFILE');
        recDefaultDimension.SetFilter("No.", Rec."Sell-to Customer No.");
        if recDefaultDimension.FindFirst then CustomerProfile := recDefaultDimension."Dimension Value Code";
        recSalesInvoiceHeader.Reset;
        recSalesInvoiceHeader.SetRange(recSalesInvoiceHeader."No.", Rec."Document No.");
        if recSalesInvoiceHeader.FindFirst then InvoicePostingDate := recSalesInvoiceHeader."Posting Date";

        if not recItemTmp.Get(Rec."No.") then begin
            recItem.Get(Rec."No.");
            recItemTmp := recItem;
            recItemTmp.Insert;
        end else
            QtyPerCarton := recItemTmp."Number per carton";
        if QtyPerCarton <> 0 then
            SoldPerCarton := (Rec.Quantity MOD QtyPerCarton) = 0
        else
            SoldPerCarton := false;

        if not recCustTmp.get(Rec."Sell-to Customer No.") then begin
            recCust.get(Rec."Sell-to Customer No.");
            recCustTmp := recCust;
            recCustTmp.Insert;
        end;
    end;

    trigger OnOpenPage()
    begin
        SI.UseOfReport(8, 50147, 0);
        if not Rec.FindFirst then;
    end;

    var
        CustomerProfile: Code[20];
        DivisionCode: Code[20];
        CountryCode: Code[20];
        PackingListNo: Code[20];
        DepartmentCode: Code[20];
        InvoicePostingDate: Date;
        CustomerProfileFilter: Code[20];
        DivisionCodeFilter: Code[20];
        CountryCodeFilter: Code[20];
        DepartmentCodeFilter: Code[20];
        SI: Codeunit "Single Instance";
        recItem: Record Item;
        recItemTmp: Record Item temporary;
        recCust: Record Customer;
        recCustTmp: Record Customer temporary;
        QtyPerCarton: Integer;
        SoldPerCarton: Boolean;
}
