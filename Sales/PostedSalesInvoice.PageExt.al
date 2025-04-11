pageextension 50148 PostedSalesInvoiceZX extends "Posted Sales Invoice"
{
    layout
    {
        modify("Pre-Assigned No.")
        {
            Caption = 'eCommerce No.';
        }
        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Eicard Type"; Rec."Eicard Type")
            {
                ApplicationArea = Basic, Suite;
                Visible = EicardTypeVisible;
            }
        }
        addafter("External Document No.")
        {
            field(ExternalDocumentSL; ExternalDocumentSL)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'External Document No. 2';
                Editable = false;
                Importance = Additional;
            }
            field("E-Invoice Comment"; Rec."E-Invoice Comment")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Importance = Additional;
            }
            field("Customer Document No."; Rec."Customer Document No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("SAP No."; Rec."SAP No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("Picking List No."; Rec."Picking List No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Bill-to Contact")
        {
            field("RHQ Invoice No"; Rec."RHQ Invoice No")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Payment Method Code")
        {
            group(Control77)
            {
                ShowCaption = false;
                field("Ship-to VAT"; Rec."Ship-to VAT")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                }
                field("Company VAT Registration Code"; Rec."Company VAT Registration Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = CompanyVATRegistrationCodeEditable;
                    Importance = Additional;
                }
            }
            field("Intercompany Purchase"; Rec."Intercompany Purchase")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Currency Code")
        {
            field("Currency Code Sales Doc SUB"; Rec."Currency Code Sales Doc SUB")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addlast(General)
        {
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        addafter(ActionGroupCRM)
        {
            action("Show Delivery Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Show Delivery Document';
                Image = Document;
                RunObject = Page "VCK Delivery Document";
                RunPageLink = "No." = field("Picking List No.");
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Change Log")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Change Log Entries";
                    RunPageLink = "Primary Key Field 1 Value" = field("No.");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(112));
                }
            }
        }
        addfirst(Processing)
        {
            action(eCommerceInvoice)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open &eCommerce Invoice';
                Description = 'Open the invoice sent to the eCommerce customer.';
                Image = SendAsPDF;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Open the invoice sent to the eCommerce customer.';
            }
        }
    }

    var
        EicardTypeVisible: Boolean;

    trigger OnOpenPage()
    begin
        SetActions();  // 14-12-21 ZY-LD 003
    end;

    trigger OnAfterGetRecord()
    begin
        ExternalDocumentSL := SalesHeaderLineEvent.GetExternalDocNoFromSalesInvLine(Rec."No.");  // 21-09-18 ZY-LD 001
        SetActions();  // 14-12-21 ZY-LD 003
    end;

    var
        ExternalDocumentSL: Text;
        SalesHeaderLineEvent: Codeunit "Sales Header/Line Events";
        CompanyVATRegistrationCodeEditable: Boolean;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        CompanyVATRegistrationCodeEditable := ZGT.UserIsAccManager('DK');  // 14-12-21 ZY-LD 003
        EicardTypeVisible := (Rec."Sales Order Type" = Rec."Sales Order Type"::EICard) and (Rec."Eicard Type" <> Rec."Eicard Type"::" ");
    end;
}
