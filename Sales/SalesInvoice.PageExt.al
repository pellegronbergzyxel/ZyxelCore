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
                SetActions();
            end;
        }
        movebefore("Sell-to"; "Location Code")
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                SetActions();
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
                ToolTip = 'Specifies the type of sales order. The type determines how the sales order is processed.';
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
                    ToolTip = 'Specifies the external invoice number.';
                    Importance = Additional;
                    Visible = ExternalInvoiceNoVisible;
                }
                field("E-Invoice Comment"; Rec."E-Invoice Comment")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the comment for the e-invoice.';
                    Enabled = EInvoiceCommentEnable;
                    ShowMandatory = EInvoiceCommentEnable;
                }
            }
            field("Customer Document No."; Rec."Customer Document No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the customer document number.';
                Importance = Additional;
            }
            field("SAP No."; Rec."SAP No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the SAP number.';
                Importance = Additional;
            }
            field("Create User ID"; Rec."Create User ID")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the user ID of the user who created the sales invoice.';
                Importance = Additional;
            }
        }
        movebefore("External Invoice No."; "External Document No.")
        modify("Bill-to Country/Region Code")
        {
            Importance = Additional;

            trigger OnAfterValidate()
            begin
                SetActions();
            end;
        }
        addbefore("VAT Bus. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the general business posting group for the sales invoice.';
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
                ToolTip = 'Specifies the VAT for the ship-to address.';
                Importance = Additional;
            }
            field("VAT Registration No. Zyxel"; Rec."VAT Registration No. Zyxel")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the VAT registration number for Zyxel.';
                Importance = Additional;
            }
            field("Send Mail"; Rec."Send Mail")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies whether to send an email with the sales invoice.';
            }
        }
        addafter("Ship-to Name")
        {
            field("Ship-to Name 2"; Rec."Ship-to Name 2")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the second line of the ship-to name.';
            }
        }
        addafter("Ship-to Post Code")
        {
            field("Ship-to E-Mail"; Rec."Ship-to E-Mail")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the email address for the ship-to contact.';
            }
        }
        addafter("Shipment Date")
        {
            field("Picking List No."; Rec."Picking List No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the picking list number associated with the sales invoice.';
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
                    ToolTip = 'Specifies the type of document to which this sales invoice applies.';
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number to which this sales invoice applies.';
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the document to which this sales invoice applies.';
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
                ToolTip = 'Imports sales lines from an external source into the sales invoice.';
                Image = ImportExcel;

                trigger OnAction()
                var
                    ImportSalesLine: Report "Import Sales Line";
                begin
                    Clear(ImportSalesLine);
                    ImportSalesLine.Init(Rec."Document Type", Rec."No.");
                    ImportSalesLine.RunModal();
                end;
            }

            action("Set the Correction Flag")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set the Correction Flag';
                ToolTip = 'Sets the correction flag for the sales invoice.';
                Image = ChangeTo;

                trigger OnAction()
                var
                    ConfirmLB: Label 'Do you want to change the correction flag?';
                    ResultLB: Label 'The correction flag has been set to %1.';
                begin
                    // 25-06-25 BK #513757
                    if Confirm(ConfirmLB, false) then begin
                        Rec."Correction" := not Rec."Correction";
                        Rec.Modify(true);
                        Commit();
                        CurrPage.Update(false);
                        Message(ResultLB, Rec."Correction");
                    End;
                end;
            }
        }
        addafter(Preview)
        {
            action("Skip Posting Group Validation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Skip Posting Group Validation';
                ToolTip = 'Skips the posting group validation for the sales invoice.';
                Image = ChangeTo;

                trigger OnAction()
                begin
                    SkipPostGrpValidation();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SI.SetRejectChangeLog(false);
        SetActions();
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);
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
        recInvSetup.Get();
        EInvoiceCommentEnable := (Rec."Bill-to Country/Region Code" = 'IT') and (Rec."Location Code" = recInvSetup."AIT Location Code");
        VATRegistrationNoSellToVisible :=
          ZGT.IsRhq() and
          ((ZGT.IsZComCompany() and (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.")) or
           (ZGT.IsZNetCompany() and (Rec."VAT Registration No." <> Rec."Ship-to VAT")));

        ExternalInvoiceNoVisible := Rec."eCommerce Order";  // ExternalInvoiceNoVisible
    end;

    local procedure SkipPostGrpValidation()
    var
        recSalesHead: Record "Sales Header";
        SalesHeaderEvent: Codeunit "Sales Header/Line Events";
    begin

        CurrPage.SetSelectionFilter(recSalesHead);
        SalesHeaderEvent.SkipPostGrpValidationWithConfirm(recSalesHead, CurrPage.Caption);

    end;
}
