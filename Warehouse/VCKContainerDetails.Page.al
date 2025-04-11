Page 50101 "VCK Container Details"
{
    // 001. 24-10-18 ZY-LD 000 - New field.
    // 002. 14-12-18 ZY-LD 000 - Confirm.
    // 003. 28-01-19 ZY-LD 000 - Prevent modify after 25-01-19. Data is received by web service.
    // 004. 05-01-21 ZY-LD 000 - "New" has been set to No.
    // 005. 15-10-21 ZY-LD 2021101510000047 - Amount it added to the page.

    ApplicationArea = Basic, Suite;
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "VCK Shipping Detail";
    SourceTableView = sorting(Archive, "Batch No.")
                      order(descending)
                      where(Archive = const(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Container No."; Rec."Container No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field("Bill of Lading No."; Rec."Bill of Lading No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pallet No."; Rec."Pallet No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity to Receive';
                    Visible = false;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Quantity-""Quantity Received"""; Rec.Quantity - Rec."Quantity Received")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity';
                    DecimalPlaces = 0 : 5;
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(ETD; Rec.ETD)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipping Method"; Rec."Shipping Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Previous Batch No."; Rec."Previous Batch No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Data Received Created"; Rec."Data Received Created")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Data Received Updated"; Rec."Data Received Updated")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Original ETA Date"; Rec."Original ETA Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Previous ETA Date"; Rec."Previous ETA Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Expected Shipping Days"; Rec."Expected Shipping Days")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Original Shipping Days"; Rec."Original Shipping Days")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("""Expected Shipping Days""-""Original Shipping Days"""; Rec."Expected Shipping Days" - Rec."Original Shipping Days")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Delayed Shipping Days';
                    Visible = false;
                }
                field("Item Category 1 Code"; Rec."Item Category 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Item Category 2 Code"; Rec."Item Category 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Item Category 3 Code"; Rec."Item Category 3 Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                // #490711
                field(tobeETA; Rec.tobeETA)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                // #490711

            }
        }
        area(factboxes)
        {
            part(Control8; "VCK Ship. Detail Received")
            {
                Caption = 'Received Details';
                SubPageLink = "Container No." = field("Container No."),
                              "Invoice No." = field("Invoice No."),
                              "Purchase Order No." = field("Purchase Order No."),
                              "Purchase Order Line No." = field("Purchase Order Line No."),
                              "Pallet No." = field("Pallet No."),
                              "Item No." = field("Item No."),
                              Quantity = field(Quantity),
                              "Shipping Method" = field("Shipping Method"),
                              "Order No." = field("Order No.");
            }
            part(Control26; "Warehouse Indbound FactBox")
            {
                Caption = 'Warehouse Indbound Details';
                SubPageLink = "No." = field("Document No.");
            }
            part(Control25; "Purchase Order FactBox")
            {
                Caption = 'Purchase Order Details';
                SubPageLink = "Document Type" = const(Order),
                              "No." = field("Purchase Order No.");
            }
            part(Control3; "Purchase Order Line FactBox")
            {
                SubPageLink = "Document Type" = const(Order),
                              "Document No." = field("Purchase Order No."),
                              "Line No." = field("Purchase Order Line No.");
            }
            part(Control13; "Item Warehouse FactBox")
            {
                SubPageLink = "No." = field("Item No."),
                              "Location Filter" = field(Location);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Archive Multiple Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Archive Lines';
                Image = Archive;
                ToolTip = 'Archive the selected lines';

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if Confirm(Text001, true, Rec.Count) then  // 14-12-18 ZY-LD 002
                        if Rec.FindSet(false) then
                            repeat
                                Rec.Archive := true;
                                Rec.Modify;
                            until Rec.Next() = 0;
                end;
            }
            action("Change ETA Date")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change ETA Date';
                Description = 'Change ETA';
                Image = ChangeDate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Change ETA';

                trigger OnAction()
                begin
                    Report.RunModal(50169);
                    //CurrPage.Update(true);
                end;
            }
            action("Update VCK Inbound Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update VCK Inbound Lines';
                Image = UpdateShipment;
                Visible = CreateVCKInboundVisible;

                trigger OnAction()
                begin
                    CreateVCKInbound;  // 14-12-18 ZY-LD 002
                end;
            }
            action(tobeETA)
            {
                ApplicationArea = all;
                caption = 'Move to be ETA > ETA';
                trigger OnAction()
                begin
                    rec.movetobeETA();
                end;
            }
        }
        area(navigation)
        {
            action("Warehouse Inbound")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Inbound';
                Image = Document;
                RunObject = Page "Warehouse Inbound Card";
                RunPageLink = "No." = field("Document No.");
            }
            action("Purchase Order")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageLink = "No." = field("Purchase Order No.");
                RunPageView = where("Document Type" = const(Order));
            }
            action("Unshipped Quantity")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unshipped Quantity';
                Image = Shipment;
                RunObject = Page "Purchase Lines";
                RunPageLink = "Document Type" = const(Order), Type = const(Item), OriginalLineNo = filter(<> 0);

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

                    trigger OnAction()
                    var
                        ChangeLogEntry: Record "Change Log Entry";
                    begin
                        ChangeLogEntry.SetCurrentKey("Table No.", "Date and Time");
                        ChangeLogEntry.SetAscending("Date and Time", false);
                        ChangeLogEntry.SetRange("Table No.", Database::"VCK Shipping Detail");
                        ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(Rec."Entry No."));
                        page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                    end;
                }
            }
        }
        area(reporting)
        {
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    PrintContainerDetails;
                end;
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
