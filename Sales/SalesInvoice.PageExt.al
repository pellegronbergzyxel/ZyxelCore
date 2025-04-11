pageextension 50127 SalesInvoiceZX extends "Sales Invoice"
{
    layout
    {
        modify("Currency Code")
        {
            ToolTip = 'The invoice between the regional head quarter and the subsidary will be invoiced with the "Currency Code" from "Bill-to Customer No.". The invoice to the customer from the subsidary will be invoiced with the "Currency Code" from the "Sell-to Customer".';
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                SetActions();  // 01-02-19 ZY-LD 008
            end;
        }
        movebefore("Sell-to"; "Location Code")
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                SetActions();  // 01-02-19 ZY-LD 008
            end;
        }
        modify("Ship-to Contact")
        {
            Importance = Standard;
        }

        addafter("No.")
        {
            field("Sales Order Type"; Rec."Sales Order Type")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Location Code")
        {
            group(ExternalRefs)
            {
                ShowCaption = false;
                field("External Invoice No."; Rec."External Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    Visible = ExternalInvoiceNoVisible;
                }
                field("E-Invoice Comment"; Rec."E-Invoice Comment")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = EInvoiceCommentEnable;
                    ShowMandatory = EInvoiceCommentEnable;
                }
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
            field("Create User ID"; Rec."Create User ID")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
        }
        movebefore("External Invoice No."; "External Document No.")
        modify("Bill-to Country/Region Code")
        {
            Importance = Additional;

            trigger OnAfterValidate()
            begin
                SetActions;  // 01-02-19 ZY-LD 008
            end;
        }
        addbefore("VAT Bus. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
        }
        modify("Customer Posting Group")
        {
            Editable = true;
            Importance = Additional;
        }
        modify("VAT Registration No.")
        {
            ApplicationArea = Basic, Suite;
            Visible = true;
        }
        addafter("VAT Registration No.")
        {
            field("Ship-to VAT"; Rec."Ship-to VAT")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                // Visible = VATRegistrationNoSellToVisible;  12-02-24 ZY-LD 000
            }
            field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("Send Mail"; Rec."Send Mail")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Ship-to Name")
        {
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Ship-to Post Code")
        {
            field("Ship-to E-Mail"; Rec."Ship-to E-Mail")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Shipment Date")
        {
            field("Picking List No."; Rec."Picking List No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Currency Code")
        {
            field("Currency Code Sales Doc SUB"; Rec."Currency Code Sales Doc SUB")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Currency Code on Sales Invoice SUB';
                Importance = Promoted;
                ToolTip = 'If you fill this field, the value will be used on the sales invoice in the subsidary instead of the "Currency Code" from the "Sell-to Customer.';
            }
        }
        addafter("Foreign Trade")
        {
            group(Application)
            {
                Caption = 'Application';
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        addafter(Control1906127307)
        {
            part(Control53; "Sales Inv Del Doc Fact Box")
            {
                Caption = 'Delivery Document Details';
                SubPageLink = "No." = field("Picking List No.");
                Visible = false;
            }
        }
        moveafter("Incoming Document Entry No."; "Ship-to Contact")
        moveafter("Ship-to Address 2"; "Ship-to City")
    }

    actions
    {
        addafter("Move Negative Lines")
        {
            action("Import Sales Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Sales Lines';
                Image = ImportExcel;

                trigger OnAction()
                var
                    ImportSalesLine: Report "Import Sales Line";
                begin
                    Clear(ImportSalesLine);
                    ImportSalesLine.Init(Rec."Document Type", Rec."No.");
                    ImportSalesLine.RunModal;
                end;
            }
        }
        addafter(Preview)
        {
            action("Skip Posting Group Validation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Skip Posting Group Validation';
                Image = ChangeTo;

                trigger OnAction()
                begin
                    SkipPostGrpValidation;  // 28-06-21 ZY-LD 004
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 007
        SetActions;  // 01-02-19 ZY-LD 008
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 007
    end;

    var
        SI: Codeunit "Single Instance";
        EInvoiceCommentEnable: Boolean;
        VATRegistrationNoSellToVisible: Boolean;
        ExternalInvoiceNoVisible: Boolean;

    local procedure SetActions()
    var
        recInvSetup: Record "Inventory Setup";
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        recInvSetup.Get();  // 01-02-19 ZY-LD 016
        EInvoiceCommentEnable := (Rec."Bill-to Country/Region Code" = 'IT') and (Rec."Location Code" = recInvSetup."AIT Location Code");  // 01-02-19 ZY-LD 016
        VATRegistrationNoSellToVisible :=
          ZGT.IsRhq and
          ((ZGT.IsZComCompany and (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.")) or  //<< 18-08-21 ZY-LD 032
           (ZGT.IsZNetCompany and (Rec."VAT Registration No." <> Rec."Ship-to VAT")));  // 28-10-21 ZY-LD 032

        ExternalInvoiceNoVisible := Rec."eCommerce Order";  // 26-10-21 ZY-LD 011 ExternalInvoiceNoVisible
    end;

    local procedure SkipPostGrpValidation()
    var
        recSalesHead: Record "Sales Header";
        SalesHeaderEvent: Codeunit "Sales Header/Line Events";
    begin
        //>> 28-06-21 ZY-LD 003
        CurrPage.SetSelectionFilter(recSalesHead);
        SalesHeaderEvent.SkipPostGrpValidationWithConfirm(recSalesHead, CurrPage.Caption);
        //<< 28-06-21 ZY-LD 003
    end;
}
