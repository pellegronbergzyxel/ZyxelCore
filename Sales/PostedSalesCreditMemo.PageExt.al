pageextension 50150 PostedSalesCreditMemoZX extends "Posted Sales Credit Memo"
{
    layout
    {
        modify("Pre-Assigned No.")
        {
            Caption = 'eCommerce No.';
        }
        modify("VAT Registration No.")
        {
            Editable = false;
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
        }
        addafter("Bill-to Contact")
        {
            field("RHQ Credit Memo No"; Rec."RHQ Credit Memo No")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Payment Method Code")
        {
            group(Control58)
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

    }

    actions
    {
        addafter("&Cr. Memo")
        {
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
                                  where("Table No." = const(114));
                }
            }
        }
        addafter(ActivityLog)
        {
            action("Update Document Date")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Document Date';
                Image = ChangeDate;

                trigger OnAction()
                begin
                    NewDocumentDate();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetActions();  // 14-12-21 ZY-LD 006
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Amount Including VAT", Amount);
        VATAmount := Rec."Amount Including VAT" - Rec.Amount;
        ExternalDocumentSL := SalesHeaderLineEvent.GetExternalDocNoFromSalesCrMemoLine(Rec."No.");  // 21-09-18 ZY-LD 003
        SetActions();  // 14-12-21 ZY-LD 006
    end;

    trigger OnDeleteRecord(): Boolean
    var
        DeleteNotAllowedErr: Label 'Deletion not allowed!';
    begin
        Error(DeleteNotAllowedErr);
    end;

    var
        VATAmount: Decimal;
        ExternalDocumentSL: Text;
        SalesHeaderLineEvent: Codeunit "Sales Header/Line Events";
        CompanyVATRegistrationCodeEditable: Boolean;

    local procedure NewDocumentDate()
    var
        recSalesCrMemoHead: Record "Sales Cr.Memo Header";
        recSalesCrMemoLine: Record "Sales Cr.Memo Line";
        GenericInputPage: Page "Generic Input Page";
        NewDate: Date;
        lText001: Label 'Update Document Date';
        lText002: Label 'New Date';
    begin
        //>> 12-12-19 ZY-LD 005
        GenericInputPage.SetDate(Rec."Document Date");
        GenericInputPage.SetPageCaption(lText001);
        GenericInputPage.SetFieldCaption(lText002);
        GenericInputPage.SetVisibleField(4);
        if GenericInputPage.RunModal = Action::OK then begin
            NewDate := GenericInputPage.GetDate;
            if Rec."Document Date" <> NewDate then begin
                Rec."Document Date" := NewDate;
                Rec.Modify();

                recSalesCrMemoLine.SetRange("Document No.", Rec."No.");
                recSalesCrMemoLine.SetRange(Type, recSalesCrMemoLine.Type::Item);
                if recSalesCrMemoLine.FindSet(true) then
                    repeat
                        recSalesCrMemoLine."Document Date" := Rec."Document Date";
                        recSalesCrMemoLine.Modify();
                    until recSalesCrMemoLine.Next() = 0;
                CurrPage.Update(false);
            end;
        end;
        //<< 12-12-19 ZY-LD 005
    end;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        CompanyVATRegistrationCodeEditable := ZGT.UserIsAccManager('DK');  // 14-12-21 ZY-LD 006
    end;
}
