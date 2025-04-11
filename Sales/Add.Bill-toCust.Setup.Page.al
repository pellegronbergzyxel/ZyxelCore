Page 50075 "Add. Bill-to Cust. Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Additional Bill-to Cust. Setup';
    DataCaptionFields = "Country/Region Code", "Location Code", "Customer No.";
    PageType = List;
    SourceTable = "Add. Cust. Posting Grp. Setup";
    UsageCategory = Lists;

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
                    Caption = 'Sell-to Country/Region Code';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
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
        area(processing)
        {
            action("Copy from Main Company")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy from Main Company';
                Image = Copy;
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

    local procedure SetActions()
    begin
        PageEditable := ZGT.IsRhq;
    end;
}
