Page 50305 "Replication Setup"
{
    // 001. 06-12-18 ZY-LD 000 - New field.
    // 002. 07-02-19 ZY-LD 2019020610000093 - New field.

    ApplicationArea = Basic, Suite;
    Caption = 'Replication Setup';
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Replication Company";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Save XML File"; Rec."Save XML File")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible;
                }
                field("Replicate Customer"; Rec."Replicate Customer")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible;
                }
                field("Replicate Item"; Rec."Replicate Item")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible;
                }
                field("Replicate Chart of Account"; Rec."Replicate Chart of Account")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible;
                }
                field("Replicate Exchange Rate"; Rec."Replicate Exchange Rate")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible or ExchangeRateVisible;
                }
                field("Customer Credit Limit"; Rec."Customer Credit Limit")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible;
                }
                field("HQ Account Payable Details"; Rec."HQ Account Payable Details")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = HQAccountPayableDetailsEditable;
                }
                field("HQ Account Receivable Details"; Rec."HQ Account Receivable Details")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = HQAccountPayableDetailsEditable;
                }
                field("HQ Account Receivable WebSrv."; Rec."HQ Account Receivable WebSrv.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = HQAccountPayableDetailsEditable;
                }
                field("Replicate E-mail Address"; Rec."Replicate E-mail Address")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible;
                }
                field("Replicate User Setup"; Rec."Replicate User Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible;
                }
                field("Replicate Cost Type Name"; Rec."Replicate Cost Type Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible;
                }
                field("Company Information"; Rec."Company Information")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible;
                }
                field("Get End Cust. Sales Inv. No."; Rec."Get End Cust. Sales Inv. No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible;
                }
                field("Travel Expense E-mail Address"; Rec."Travel Expense E-mail Address")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = FieldVisible or TravelExpenseVisible;
                }
                field("Download HQ Sales Document"; Rec."Download HQ Sales Document")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SII Spain"; Rec."SII Spain")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(navigation)
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
                    RunPageLink = "Primary Key Field 1 Value" = field("Company Name");
                    RunPageView = sorting("Table No.", "Date and Time")
                                  order(descending)
                                  where("Table No." = const(60009));
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;
    end;

    trigger OnOpenPage()
    begin
        SetActions;
    end;

    var
        ReplicationType: Option " ",ExchangeRate,ConcurVendor,TravelExpenseEmail;
        ExchangeRateVisible: Boolean;
        ConcurVendorVisible: Boolean;
        TravelExpenseVisible: Boolean;
        FieldVisible: Boolean;
        HQAccountPayableDetailsEditable: Boolean;


    procedure InitPage(pReplicationType: Option " ",ExchangeRate,ConcurVendor,TravelExpenseEmail)
    begin
        ReplicationType := pReplicationType;
    end;

    local procedure SetActions()
    var
        ZGT: Codeunit "ZyXEL General Tools";
    begin
        case ReplicationType of
            Replicationtype::" ":
                begin
                    ExchangeRateVisible := true;
                    FieldVisible := true;
                end;
            Replicationtype::ExchangeRate:
                begin
                    ExchangeRateVisible := true;
                    FieldVisible := false;
                end;
            Replicationtype::ConcurVendor:
                begin
                    ConcurVendorVisible := true;
                    FieldVisible := false;
                end;
            Replicationtype::TravelExpenseEmail:
                begin
                    TravelExpenseVisible := true;
                    FieldVisible := false;
                end;
        end;

        if ZGT.IsRhq then begin
            HQAccountPayableDetailsEditable := false;
            if ZGT.IsZNetCompany then
                if UpperCase(CopyStr(Rec."Company Name", 1, 4)) = 'ZNET' then
                    HQAccountPayableDetailsEditable := true;
            if ZGT.IsZComCompany then
                if (UpperCase(CopyStr(Rec."Company Name", 1, 4)) = 'ZYND') or (UpperCase(CopyStr(Rec."Company Name", 1, 5)) = 'ZYXEL') then
                    HQAccountPayableDetailsEditable := true;
        end;
    end;
}
