page 50223 "Enter Selected Fields"
{
    PageType = StandardDialog;
    Permissions = TableData "User Setup" = rm;
    SourceTable = "Sales Header";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            field("Document Type"; Rec."Document Type")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ToolTip = 'The document type will determine the type of sales document (Inv, Cr. Memo) that will be created from the sales order. The document type is determined by the sales order type. If the sales order type is different from EICard, the document type will be determined by the "Document Type" field on the "Sell-to Customer". If the sales order type is EICard, the document type will be determined by the eicard type on the sales order. If the eicard type is normal, the document type will be Invoice. If the eicard type is sample, the document type will be Credit Memo.';
            }
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ToolTip = 'The document number.';
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'The location code on the sales order will determine the inventory location from which the products will be sent. If there is no location code on the sales order, the inventory will be picked from any location that has available inventory. If there is a location code on the sales order, the inventory will only be picked from that location.';
            }
            field("Eicard Type"; Rec."Eicard Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = EicardTypeVisible;
                ToolTip = 'Select the eicard type if the sales order type is EICard and the customer has "Set Eicard Type on Sales Order" selected. The eicard type on the sales order will determine which workflow will be used for approval. If the eicard type is normal, the standard workflow for sales order approval will be used. If the eicard type is sample, a different workflow will be used for approval. The field is only visible if the sales order type is EICard.';
            }
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShipToCodeVisible;
                ToolTip = 'The ship-to code on the sales order will determine where the products will be sent. If there is no ship-to code on the sales order, the products will be sent to the address on the "Sell-to Customer". If there is a ship-to code on the sales order, the products will be sent to the address on the ship-to code. The field is only visible if the sales order type is different from EICard.';
            }
            field("Ship-to Code Del. Doc"; Rec."Ship-to Code Del. Doc")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShipToCodeDelDocVisible;
                ToolTip = 'Fill this field only if the products must be sent to rework on a different location (ex. DK-Office). In all other situations the field must be left blank.';
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'The external document number from the customer. It will be printed on the sales document (Inv, Cr. Memo) and can be used for searching the sales document in the system.';
            }
            field("Backlog Comment"; Rec."Backlog Comment")
            {
                ApplicationArea = Basic, Suite;
                OptionCaption = ' ,Awaiting Prepayment,Credit Blocked,On Hold by Customer,Other,Project item on hold';
                Visible = ShipToCodeVisible;
                ToolTip = 'Select the reason why the sales order is on backlog. The field is only visible if there is a ship-to code on the sales order.';
            }
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShowCurrencyCode;
                ToolTip = 'Currency code on the sales document (Inv, Cr. Memo) will be the same as the currency code on the "Sell-to Customer". If you want to have a different currency code on the sales document, you can fill in the field "Currency Code Sales Doc SUB".';
            }
            field("Send Mail"; Rec."Send Mail")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'The document will be sent automatic by e-mail.';
                Visible = SendMailVisible;
            }
            field("Currency Code Sales Doc SUB"; Rec."Currency Code Sales Doc SUB")
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = CurrencyCodeSalesDocSUBCaption;
                ToolTip = 'In this field, you can enter the currency code you want on the sales document (Inv, Cr. Memo) in the subsidary. You only have to fill the field, if it is differet from the currency code on the "Sell-to Customer".';
                Visible = CurrencyCodeSalesDocSUBVisible;
            }
        }
    }

    trigger OnOpenPage()
    var
        recCust: Record Customer;
        ZGT: Codeunit "ZyXEL General Tools";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if rec."From CDC" then //05-03-2026 BK #549826
            exit;

        ShipToCodeVisible := Rec."Sales Order Type" <> Rec."sales order type"::EICard;
        SendMailVisible := Rec."Send Mail" = true;
        EicardTypeVisible := Rec."Eicard Type" <> Rec."eicard type"::" ";  // 18-02-20 ZY-LD 002
        if recCust.Get(Rec."Sell-to Customer No.") then;
        //>> 05-08-21 ZY-LD 003
        CurrencyCodeSalesDocSUBVisible := recCust."Select Currency Code";
        case Rec."Document Type" of
            Rec."document type"::"Credit Memo":
                CurrencyCodeSalesDocSUBCaption := Text002;
            else
                CurrencyCodeSalesDocSUBCaption := Text001;
        end;

        if (recCust."Currency Code" <> '') or (recCust."Currency Code" <> GeneralLedgerSetup."LCY Code") then
            ShowCurrencyCode := true; //01-05-2026 BK #560277

        ShipToCodeDelDocVisible := (Rec."Document Type" = Rec."Document Type"::Order) and ZGT.IsRhq and ZGT.IsZComCompany and (Rec."Sales Order Type" <> Rec."sales order type"::EICard) and recCust."Sample Account";  // 19-05-24 ZY-LD 005
    end;

    var
        UserSetup: Record "User Setup";
        ShipToCodeVisible: Boolean;
        ShipToCodeDelDocVisible: Boolean;
        ShowCurrencyCode: Boolean;
        SendMailVisible: Boolean;
        EicardTypeVisible: Boolean;
        CurrencyCodeSalesDocSUBVisible: Boolean;
        CurrencyCodeSalesDocSUBCaption: Text;
        Text001: Label 'Currency Code on Sales Invoice SUB';
        Text002: Label 'Currency Code on Sales Cr. Memo SUB';

    procedure SetSalesHeader(pSalesHeader: Record "Sales Header")
    var
        recCust: Record Customer;
    begin
        Rec := pSalesHeader;
        if recCust.Get(Rec."Sell-to Customer No.") then
            if (Rec."Sales Order Type" = Rec."sales order type"::EICard) and recCust."Set Eicard Type on Sales Order" then
                Rec."Eicard Type" := Rec."eicard type"::Normal;
        Rec.Insert();
    end;

    procedure GetSalesHeader(var pSalesHeader: Record "Sales Header")
    begin
        pSalesHeader := Rec;
    end;
}
