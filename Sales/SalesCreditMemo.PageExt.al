pageextension 50128 SalesCreditMemoZX extends "Sales Credit Memo"
{
    layout
    {
        movebefore("Sell-to"; "Location Code")
        moveafter("Location Code"; "External Document No.")
        modify("Currency Code")
        {
            ToolTip = 'The invoice between the regional head quarter and the subsidary will be invoiced with the "Currency Code" from "Bill-to Customer No.". The invoice to the customer from the subsidary will be invoiced with the "Currency Code" from the "Sell-to Customer".';
        }
        addafter("External Document No.")
        {
            field("Create User ID"; Rec."Create User ID")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }

            field("Sales Order Type"; Rec."Sales Order Type") //21-05-2025 BK #Maria
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
        }
        addafter("Prices Including VAT")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
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
                //Visible = VATRegistrationNoSellToVisible;  // 12-02-24 ZY-LD 000
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
        addafter(Billing)
        {
            Group(Shipping)
            {
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the address that products on the sales document will be shipped to.';
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an additional part of the shipping address.';
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code of the shipping address.';
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the city of the shipping address.';
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ship-from Country/Region Code';
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the contact person at the shipping address.';
                }
            }
        }
        moveafter("Ship-to Contact"; "Shipment Date")
        addafter("Currency Code")
        {
            field("Currency Code Sales Doc SUB"; Rec."Currency Code Sales Doc SUB")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Currency Code on Sales Cr. Memo SUB';
                Importance = Promoted;
                ToolTip = 'If you fill this field, the value will be used on the sales credit memo in the subsidary instead of the "Currency Code" from the "Sell-to Customer.';
            }
        }
        addlast(Shipping)
        {
            field("Rcvd.-from Count./Region Code"; Rec."Rcvd.-from Count./Region Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies where the products is shipped from.';
            }
        }
    }

    actions
    {
        modify(GetPostedDocumentLinesToReverse)
        {
            Promoted = false;
        }
        addafter("Preview Posting")
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
            group(Import)
            {
                Caption = 'Import';
                action("Import Price Protection and Rebate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Price Protection and Rebate';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // 25-10-18 ZY-LD 008
                        Clear(ImportCreditMemoLine);
                        ImportCreditMemoLine.ReportInit(4, Rec."No.", Rec."Location Code", Rec."External Document No.");  // 22-04-22 ZY-LD 010
                        ImportCreditMemoLine.RunModal;
                        //<< 25-10-18 ZY-LD 008
                    end;
                }
            }
            group(Lines)
            {
                Caption = 'Lines';
                action(SetNegativeToHidden)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Hide Negative';
                    Image = ItemTrackingLines;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    var
                        recSalesLine: Record "Sales Line";
                    begin
                        if Confirm('Are you sure you want to hide all lines with a negative quantity', false) then begin
                            recSalesLine.SetFilter("Document No.", Rec."No.");
                            recSalesLine.SetFilter(Quantity, '<0');
                            if recSalesLine.FindFirst() then begin
                                repeat
                                    recSalesLine."Hide Line" := true;
                                    recSalesLine.Modify();
                                until recSalesLine.Next() = 0;
                            end;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 18-08-21 ZY-LD 032
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 007
    end;

    trigger OnOpenPage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 007
        SetActions();  // 18-08-21 ZY-LD 032
    end;

    var
        Text001: Label 'The Credit Memo Cannot be Posted becasue line %1 has no Return Reason Code';
        SI: Codeunit "Single Instance";
        ImportCreditMemoLine: Report "Import Price Protection";
        VATRegistrationNoSellToVisible: Boolean;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        VATRegistrationNoSellToVisible :=
          ZGT.IsRhq and
          ((ZGT.IsZComCompany and (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.")) or  //<< 18-08-21 ZY-LD 032
           (ZGT.IsZNetCompany and (Rec."VAT Registration No." <> Rec."Ship-to VAT")));  // 28-10-21 ZY-LD 032
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
