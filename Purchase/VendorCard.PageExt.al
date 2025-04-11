pageextension 50116 VendorCardZX extends "Vendor Card"
{
    layout
    {
        modify("IC Partner Code")
        {
            Importance = Promoted;
        }
        modify("VAT Bus. Posting Group")
        {
            Importance = Promoted;
        }
        modify("Vendor Posting Group")
        {
            Importance = Standard;
        }
        addafter(Blocked)
        {
            field(Active; Rec.Active)
            {
                ApplicationArea = Basic, Suite;
            }
            field("SBU Company"; Rec."SBU Company")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                Importance = Additional;
            }
        }
        addafter("IC Partner Code")
        {
            field("IC Partner Code Zyxel"; Rec."IC Partner Code Zyxel")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sample Vendor"; Rec."Sample Vendor")  // 02-05-24 - ZY-LD 000
            {
                ApplicationArea = Basic, Suite;
            }
            field("FTP Code Normal"; Rec."FTP Code Normal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("FTP Code EiCard"; Rec."FTP Code EiCard")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("VAT Registration No.")
        {
            field("VAT ID"; Rec."VAT ID")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Prices Including VAT")
        {
            field("Add. EMEA Purchace Price %"; Rec."Add. EMEA Purchace Price %")
            {
                ApplicationArea = Basic, Suite;
                Editable = AddEMEAPurchPriceEditable;
            }
        }
        addafter("Foreign Trade")
        {
            group(Reporting)
            {
                field("Related Company"; Rec."Related Company")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        addafter(VendorReportSelections)
        {
            action("Bill-From Vendor pr. Location")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bill-From Vendor pr. Location';
                Image = CoupledOpportunity;
                RunObject = Page "Add. Vend. Posting Grp. Setup";
                RunPageLink = "Vendor No." = field("No.");
            }
        }
        addafter("Ledger E&ntries")
        {
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
                              where("Table No." = const(23));
            }
        }
        addafter(History)
        {
            group("Additional Setup")
            {
                Caption = 'Additional Setup';
                action(VendPostingGrpSetupSub)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Add. Posting Setup';
                    Image = Intercompany;
                    RunObject = Page "Add. Vend. Posting Grp. Setup";

                    trigger OnAction()
                    begin
                        // Using OnAfterAction.
                    end;
                }
            }
        }
        addafter("Purchase Journal")
        {
            action("Change IC Partner")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change IC Partner';
                Image = ICPartner;

                trigger OnAction()
                begin
                    ChangeICPartner;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 005
        SetActions();  // 10-02-20 ZY-LD 008
    end;

    trigger OnClosePage()
    begin
        SI.SetRejectChangeLog(false);  // 25-04-18 ZY-LD 005
    end;

    trigger OnAfterGetRecord()
    begin
        SetActions();  // 24-02-21 ZY-LD 009
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SetActions();  // 24-02-21 ZY-LD 009
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetActions();  // 10-02-20 ZY-LD 008
    end;

    var
        SI: Codeunit "Single Instance";
        AddEMEAPurchPriceEditable: Boolean;
        AddPostSetupSubVisible: Boolean;
        PreviousVendorNo: Code[20];

    local procedure ChangeICPartner()
    var
        lICPartner: Record "IC Partner";
        lText001: Label 'Do you want to change %1 from "%2" to "%3"?';
    begin
        if Page.RunModal(Page::"IC Partner List", lICPartner) = Action::LookupOK then begin
            if Confirm(lText001, false, Rec.FieldCaption(Rec."IC Partner Code"), Rec."IC Partner Code", lICPartner.Code) then begin
                Rec."IC Partner Code" := lICPartner.Code;
                Rec.Modify();
            end;
        end;
    end;

    local procedure SetActions()
    var
        ZyWebServMgt: Codeunit "Zyxel Web Service Management";
    begin
        AddEMEAPurchPriceEditable := Rec."SBU Company" in [Rec."sbu company"::"ZCom EMEA", Rec."sbu company"::"ZNet EMEA"];  // 10-02-20 ZY-LD 008
        //>> 24-02-21 ZY-LD 009
        AddPostSetupSubVisible := Rec."Related Company";
        //if Rec."No." <> PreviousVendorNo then
        //    ConcurVendorFieldsEditable := not ZyWebServMgt.VendorCreatedInConcur(Rec."No.");
        PreviousVendorNo := Rec."No.";
        //<< 24-02-21 ZY-LD 009
    end;
}
