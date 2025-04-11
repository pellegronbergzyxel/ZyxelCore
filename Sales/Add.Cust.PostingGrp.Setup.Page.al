Page 50195 "Add. Cust. Posting Grp. Setup"
{
    // 001. 23-08-21 ZY-LD 000 - Only visible in Main company.
    // 002. 10-06-22 ZY-LD 000 - 3 Party Trade.

    Caption = 'Additional Posting Grp. Setup';
    DataCaptionFields = "Country/Region Code", "Location Code", "Customer No.";
    PageType = List;
    SourceTable = "Add. Cust. Posting Grp. Setup";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                Editable = PageEditable;
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ship-to Country/Region Code';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = ThreePartyTradeInSubsidary;
                }
                field("Location Code in SUB"; Rec."Location Code in SUB")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = LocationCodeinSubsidary;
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                RunObject = Page "Change Log Entries";
                RunPageView = SORTING("Table No.", "Date and Time")
                              ORDER(Descending)
                              WHERE("Table No." = CONST(50039));
                RunPageLink = "Primary Key Field 1 Value" = FIELD("Country/Region Code"),
                                  "Primary Key Field 2 Value" = FIELD("Location Code");
                Promoted = true;
                Image = ChangeLog;
                PromotedCategory = Process;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions;
    end;

    trigger OnClosePage()
    begin
        if ChangeHasBeenMade then
            if Rec."Company Type" = Rec."company type"::Subsidary then
                ZyWebSrvMgt.ReplicateCustomers('', DelChr(Rec.GetFilter(Rec."Customer No."), '=', '''|'), false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ChangeHasBeenMade := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ChangeHasBeenMade := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ChangeHasBeenMade := true;
    end;

    trigger OnOpenPage()
    begin
        SetActions;
    end;

    var
        ChangeHasBeenMade: Boolean;
        ZyWebSrvMgt: Codeunit "Zyxel Web Service Management";
        ZGT: Codeunit "ZyXEL General Tools";
        PageEditable: Boolean;
        LocationCodeinSubsidary: Boolean;
        ThreePartyTradeInSubsidary: Boolean;

    local procedure SetActions()
    begin
        PageEditable := ZGT.IsRhq;
        LocationCodeinSubsidary := Rec."Company Type" = Rec."company type"::Main;  // 23-08-21 ZY-LD 001
        ThreePartyTradeInSubsidary := Rec."Company Type" = Rec."company type"::Subsidary;  // 10-06-22 ZY-LD 002
    end;
}
