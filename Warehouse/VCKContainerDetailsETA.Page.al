Page 50164 "VCK Container Details ETA"
{
    // 001. 24-10-18 ZY-LD 000 - New field.
    // 002. 14-12-18 ZY-LD 000 - Confirm.
    // 003. 28-01-19 ZY-LD 000 - Prevent modify after 25-01-19. Data is received by web service.
    // 004. 05-01-21 ZY-LD 000 - "New" has been set to No.
    // 005. 15-10-21 ZY-LD 2021101510000047 - Amount it added to the page.

    ApplicationArea = Basic, Suite;
    Caption = 'VCK Container Details ETA';
    Editable = false;
    PageType = List;
    SourceTable = "VCK Shipping Detail";
    SourceTableView = sorting(ETA);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ETD; Rec.ETD)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipping Method"; Rec."Shipping Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity to Receive';
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
            action("Container Details")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Container Details';
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "VCK Container Details";
                RunPageLink = "Invoice No." = field("Invoice No."),
                              "Purchase Order No." = field("Purchase Order No."),
                              Location = field(Location),
                              ETA = field(ETA);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //>> 15-10-21 ZY-LD 005
        Rec.CalcFields(Rec."Quantity Received", Rec."Direct Unit Cost");
        Rec."Calculated Quantity" := Rec.Quantity - Rec."Quantity Received";
        Rec.Amount := Rec."Calculated Quantity" * Rec."Direct Unit Cost";
        //<< 15-10-21 ZY-LD 005
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //>> 28-01-19 ZY-LD 003
        if Rec."Data Received Created" <> 0DT then
            if not Confirm(Text003, false) then
                Error(Text002);
        //<< 28-01-19 ZY-LD 003
    end;

    trigger OnOpenPage()
    begin
        if UserId() = 'jkral' then
            CurrPage.Editable := true;

        SetActions;
    end;

    var
        Text001: label 'Do you want to archive %1 line(s)?';
        ZGT: Codeunit "ZyXEL General Tools";
        CreateVCKInboundVisible: Boolean;
        Text002: label 'You are not allowed to modify lines received after 25-01-19.';
        Text003: label 'The data has been received from electronically.\Are you sure you want to change the line?';

    local procedure CreateVCKInbound()
    var
        recContDetail: Record "VCK Shipping Detail";
        ZyVCKPostMgt: Codeunit "Zyxel VCK Post Management";
        lText001: label 'Do you want to create VCK Post Line?';
    begin
        //>> 14-12-18 ZY-LD 002
        // IF CONFIRM(lText001) THEN BEGIN
        //  CurrPage.SETSELECTIONFILTER(recContDetail);
        //  IF recContDetail.FINDSET THEN BEGIN
        //    ZGT.OpenProgressWindow('',COUNT);
        //    REPEAT
        //      ZGT.UpdateProgressWindow("Purchase Order No.",0,TRUE);
        //
        //      recVCKPostLine.SETRANGE(Date,TODAY);
        //      recVCKPostLine.SETRANGE("Order No.",recContDetail."Purchase Order No.");
        //      recVCKPostLine.SETRANGE("Line No.",recContDetail."Purchase Order Line No.");
        //      recVCKPostLine.SETRANGE("Invoice No.",recContDetail."Invoice No.");
        //      recVCKPostLine.SETRANGE(Posted,FALSE);
        //      IF recVCKPostLine.FINDFIRST THEN BEGIN
        //        recVCKPostLine.Quantity += recContDetail.Quantity;
        //        recVCKPostLine.MODIFY;
        //      END ELSE BEGIN
        //        recVCKPostLine.Date := TODAY;
        //        recVCKPostLine."Order No." := recContDetail."Purchase Order No.";
        //        recVCKPostLine."Line No." := recContDetail."Purchase Order Line No.";
        //        recVCKPostLine."Invoice No." := recContDetail."Invoice No.";
        //        recVCKPostLine.Quantity := recContDetail.Quantity;
        //        recVCKPostLine.INSERT;
        //      END;
        //    UNTIL recContDetail.Next() = 0;
        //    ZGT.CloseProgressWindow;
        //  END;
        // END;
        //<< 14-12-18 ZY-LD 002
    end;

    local procedure SetActions()
    var
        recServEnviron: Record "Server Environment";
    begin
        CreateVCKInboundVisible := not recServEnviron.ProductionEnvironment;  // 14-12-18 ZY-LD 002
    end;

    local procedure PrintContainerDetails()
    var
        recContDetail: Record "VCK Shipping Detail";
    begin
        recContDetail.SetRange("Batch No.", Rec."Batch No.");
        Report.RunModal(Report::"Container Details", true, true, recContDetail);
    end;
}
