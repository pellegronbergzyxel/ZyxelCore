page 50223 "Enter Selected Fields"
{
    // 001. 07-01-19 PAB Ticket#2019010410000062 - Added option
    // 002. 18-02-20 ZY-LD P0395 - Eicard Type.
    // 003. 05-08-21 ZY-LD 000 - Select Currency Code.
    // 004. 03-12-21 ZY-LD 000 - Final Destination.
    // 005. 19-05-24 ZY-LD 000 - Samples might have temporery ship-to code in order to rework the products before sending it to the customer.

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
            }
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Eicard Type"; Rec."Eicard Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = EicardTypeVisible;
            }
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = Basic, Suite;
                Visible = ShipToCodeVisible;
            }
            field("Ship-to Code Del. Doc"; Rec."Ship-to Code Del. Doc")  // 06-05-24 ZY-LD 000
            {
                ApplicationArea = Basic, Suite;
                Visible = ShipToCodeDelDocVisible;
                ToolTip = 'Fill this field only if the products must be sent to rework on a different location (ex. DK-Office). In all other situations the field must be left blank.';
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Backlog Comment"; Rec."Backlog Comment")
            {
                ApplicationArea = Basic, Suite;
                OptionCaption = ' ,Awaiting Prepayment,Credit Blocked,On Hold by Customer,Other,Project item on hold';
                Visible = ShipToCodeVisible;
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
    begin
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
        //<< 05-08-21 ZY-LD 003
        ShipToCodeDelDocVisible := (Rec."Document Type" = Rec."Document Type"::Order) and ZGT.IsRhq and ZGT.IsZComCompany and (Rec."Sales Order Type" <> Rec."sales order type"::EICard) and recCust."Sample Account";  // 19-05-24 ZY-LD 005
    end;

    var
        UserSetup: Record "User Setup";
        ShipToCodeVisible: Boolean;
        ShipToCodeDelDocVisible: Boolean;
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
        //>> 18-02-20 ZY-LD 002
        if recCust.Get(Rec."Sell-to Customer No.") then
            if (Rec."Sales Order Type" = Rec."sales order type"::EICard) and recCust."Set Eicard Type on Sales Order" then
                Rec."Eicard Type" := Rec."eicard type"::Normal;
        //<< 18-02-20 ZY-LD 002
        Rec.Insert();
    end;

    procedure GetSalesHeader(var pSalesHeader: Record "Sales Header")
    begin
        pSalesHeader := Rec;
    end;
}
