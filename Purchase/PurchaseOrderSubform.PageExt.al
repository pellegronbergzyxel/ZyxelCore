pageextension 50136 PurchaseOrderSubformZX extends "Purchase Order Subform"
{
    layout
    {
        addfirst(Control1)
        {
            field(Matched; Rec.Matched)
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Editable = false;
            }
        }
        modify(Type)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;

            trigger OnAfterValidate()
            begin
                IsCurrPageIsEditable := CurrPage.Editable;
                CurrPage.Update();
            end;
        }
        modify(FilteredTypeField)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsCurrPageIsEditable and IsLineEditable;
            Enabled = IsLineEditable;

            trigger OnAfterValidate()
            begin
                IsCurrPageIsEditable := CurrPage.Editable;
                CurrPage.Update();
            end;
        }
        modify("No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
            ShowMandatory = Rec.Type <> Rec.Type::" ";

            trigger OnAfterValidate()
            begin
                IsCurrPageIsEditable := CurrPage.Editable;
                CurrPage.Update();
            end;

            trigger OnLookup(var Text: Text): Boolean
            begin
                PurchLineEvent.OnLookupPurchaseLineNo(Rec);
            end;
        }
        addafter("No.")
        {
            field("Vendor Status"; Rec."Vendor Status")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
            field("Vendor Invoice No"; Rec."Vendor Invoice No")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
                Visible = false;
            }
        }
        modify("Item Reference No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("IC Partner Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("IC Partner Ref. Type")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("IC Partner Reference")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Variant Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        addafter("Variant Code")
        {
            field("ETD Date"; Rec."ETD Date")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
            field(ETA; Rec.ETA)
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
        }
        modify(Nonstock)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        addafter(Nonstock)
        {
            field("Cost Split Type"; Rec."Cost Split Type")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
        }
        modify("Gen. Bus. Posting Group")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Gen. Prod. Posting Group")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("VAT Bus. Posting Group")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("VAT Prod. Posting Group")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify(Description)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Description 2")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Drop Shipment")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Return Reason Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Location Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = false;
        }
        modify("Bin Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = false;
        }
        modify(Quantity)
        {
            Visible = not IsGroupedLines;
        }
        addafter(Quantity)
        {
            field("Grouped Quantity"; GroupedQuantity)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Quantity';
                BlankZero = true;
                Editable = (not IsBlankNumber) and IsLineEditable;
                Enabled = (not IsBlankNumber) and IsLineEditable;
                DecimalPlaces = 0 : 5;
                Visible = IsGroupedLines;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
                ToolTip = 'Specifies the quantity of what you''re buying. The number is based on the unit chosen in the Unit of Measure Code field.';

                trigger OnValidate()
                begin
                    Rec.Validate(Quantity, GroupedQuantity);
                    CurrPage.Update(false);
                end;
            }
        }
        modify("Reserved Quantity")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Remaining Qty.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Unit of Measure Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Unit of Measure")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Direct Unit Cost")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = (not IsBlankNumber) and IsLineEditable;
            Enabled = (not IsBlankNumber) and IsLineEditable;
            ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
        }
        modify("Indirect Cost %")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Unit Cost (LCY)")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Unit Price (LCY)")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Tax Liable")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
        }
        modify("Tax Area Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Tax Group Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Use Tax")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Line Discount %")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = (not IsBlankNumber) and IsLineEditable;
            Enabled = (not IsBlankNumber) and IsLineEditable;
        }
        modify("Line Amount")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = (not IsBlankNumber) and IsLineEditable;
            Enabled = (not IsBlankNumber) and IsLineEditable;
        }
        modify("Line Discount Amount")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify(NonDeductibleVATBase)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify(NonDeductibleVATAmount)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Prepayment %")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Prepmt. Line Amount")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Prepmt. Amt. Inv.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }

        modify("Allow Invoice Disc.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Inv. Discount Amount")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Inv. Disc. Amount to Invoice")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Qty. to Receive")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Quantity Received")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
        }
        modify("Qty. to Invoice")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Quantity Invoiced")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
        }
        modify("Prepmt Amt to Deduct")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Prepmt Amt Deducted")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
        }
        modify("Allow Item Charge Assignment")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Qty. to Assign")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Item Charge Qty. to Handle")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Qty. Assigned")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
        }
        modify("Job No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Task No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Planning Line No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Line Type")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Unit Price")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Line Amount")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Line Discount Amount")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Line Discount %")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Total Price")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Unit Price (LCY)")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Total Price (LCY)")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Line Amount (LCY)")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Job Line Disc. Amount (LCY)")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        addafter("Job Line Disc. Amount (LCY)")
        {
            field("Requested Date From Factory"; Rec."Requested Date From Factory")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
        }
        modify("Requested Receipt Date")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        addafter("Requested Receipt Date")
        {
            field("Warehouse Status"; Rec."Warehouse Status")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
        }
        modify("Promised Receipt Date")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Visible = false;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Planned Receipt Date")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Visible = false;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Expected Receipt Date")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Visible = false;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Order Date")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Lead Time Calculation")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Planning Flexibility")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Prod. Order No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Prod. Order Line No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Operation No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Work Center No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify(Finished)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Whse. Outstanding Qty. (Base)")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
        }
        modify("Inbound Whse. Handling Time")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Blanket Order No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Blanket Order Line No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Appl.-to Item Entry")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Deferral Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify(ShortcutDimCode3)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify(ShortcutDimCode4)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify(ShortcutDimCode5)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify(ShortcutDimCode6)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify(ShortcutDimCode7)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify(ShortcutDimCode8)
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Document No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
        }
        modify("Line No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
        }
        addafter("Line No.")
        {
            field(OriginalLineNo; Rec.OriginalLineNo)
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Editable = false;
                Enabled = false;
            }
            field("EMS Machine Code"; Rec."EMS Machine Code")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Visible = false;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
            field("GLC Serial No."; Rec."GLC Serial No.")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Visible = false;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
            field("GLC Mac Address"; Rec."GLC Mac Address")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Visible = false;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
            field("Original Quantity"; Rec."Original Quantity")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Visible = false;
                Editable = false;
                Enabled = IsLineEditable;
            }
            field("Outstanding Quantity Grouped"; Rec."Outstanding Quantity Grouped")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Visible = false;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
            field("Quantity Received Grouped"; Rec."Quantity Received Grouped")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Visible = false;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
            field("Quantity Invoiced Grouped"; Rec."Quantity Invoiced Grouped")
            {
                ApplicationArea = Basic, Suite;
                Style = Attention;
                StyleExpr = IsGroupedStyle;
                Visible = false;
                Editable = IsLineEditable;
                Enabled = IsLineEditable;
            }
        }
        modify("Over-Receipt Quantity")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Over-Receipt Code")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Gross Weight")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Net Weight")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Unit Volume")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Units per Parcel")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("FA Posting Date")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Attached to Line No.")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        modify("Attached Lines Count")
        {
            Style = Attention;
            StyleExpr = IsGroupedStyle;
            Editable = IsLineEditable;
            Enabled = IsLineEditable;
        }
        moveafter("No."; "Requested Receipt Date")
        addlast(Control1)
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = true;
            }
            field("Qty. Invoiced (Base)"; Rec."Qty. Invoiced (Base)")
            {
                ApplicationArea = all;
                Visible = false;
                Editable = true;
            }

        }
    }

    actions
    {
        addafter("O&rder")
        {
            action("Change Log")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Change Log';
                Image = ChangeLog;

                trigger OnAction()
                var
                    ChangeLogEntry: Record "Change Log Entry";
                begin
                    ChangeLogEntry.SetCurrentKey("Table No.", "Date and Time");
                    ChangeLogEntry.SetAscending("Date and Time", false);
                    ChangeLogEntry.SetRange("Table No.", Database::"Purchase Line");
                    ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(Rec."Document Type", 0, 9));
                    ChangeLogEntry.SetRange("Primary Key Field 2 Value", Rec."Document No.");
                    ChangeLogEntry.SetRange("Primary Key Field 3 Value", Format(Rec."Line No."));
                    Page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        AjustOutstandingQuantityBaseVisible := ZGT.UserIsDeveloper();
    end;

    trigger OnAfterGetRecord()
    begin
        if IsGroupedLines then
            if (Rec.OriginalLineNo > 0) and (Rec."Line No." = Rec.OriginalLineNo) then begin
                GroupedPurchLine.SetRange(OriginalLineNo, Rec."Line No.");
                if GroupedPurchLine.Count() > 1 then begin
                    IsGroupedStyle := true;
                    GroupedPurchLine.CalcSums(Quantity);
                end else
                    IsGroupedStyle := false;
                GroupedQuantity := GroupedPurchLine.Quantity;
            end else begin
                GroupedQuantity := Rec.Quantity;
                IsGroupedStyle := false;
                Rec.Mark(true);
            end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if not IsGroupedLines then
            IsLineEditable := true
        else
            if Rec.OriginalLineNo = 0 then
                IsLineEditable := true
            else
                IsLineEditable := false;

        IsCurrPageIsEditable := CurrPage.Editable;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if (Rec.OriginalLineNo = 0) or (Rec."Line No." = Rec.OriginalLineNo) then
            Rec.Mark(true);

        CurrPage.Update(false);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if IsGroupedLines and (CurrPage.Caption = GroupedPageCaptionLbl) and (Rec.OriginalLineNo > 0) then begin
            Error(GroupedLineErr);
            exit(false);
        end;

        CurrPage.Update(false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if IsGroupedLines and (CurrPage.Caption = GroupedPageCaptionLbl) and (Rec.OriginalLineNo > 0) then begin
            Error(GroupedLineErr);
            exit(false);
        end;

        CurrPage.Update(false);
    end;

    var
        GroupedPurchLine: Record "Purchase Line";
        ItemBudgetManagement: Codeunit "Item Budget Management";
        ZGT: Codeunit "ZyXEL General Tools";
        PurchLineEvent: Codeunit "Purchase Header/Line Events";
        GroupedQuantity: Decimal;
        IsGroupedStyle: Boolean;
        AjustOutstandingQuantityBaseVisible: Boolean;
        IsGroupedLines: Boolean;
        IsLineEditable: Boolean;
        IsCurrPageIsEditable: Boolean;
        Text002: Label 'No Source Document Specified.';
        Text003: Label 'Do you want to change value in "%1"?';
        GroupedPageCaptionLbl: Label 'Lines (Grouped)';
        GroupedLineErr: Label 'This record can not be change in this window.';

    procedure SetIsGroupedLines()
    begin
        IsGroupedLines := true;
    end;

    procedure SetupGroupedLines(DocumentNo: Code[20])
    var
        CurrentLineNo: Integer;
    begin
        GroupedPurchLine.SetRange("Document Type", GroupedPurchLine."Document Type"::Order);
        GroupedPurchLine.SetRange("Document No.", DocumentNo);

        Rec.ClearMarks();
        Rec.MarkedOnly(false);
        if Rec.FindSet() then begin
            repeat
                if (Rec.OriginalLineNo = 0) or (Rec."Line No." = Rec.OriginalLineNo) then
                    Rec.Mark(true);
            until Rec.Next() = 0;

            Rec.MarkedOnly(true);
            Rec.FindSet();

            CurrPage.Update(false);
        end;
    end;


    procedure SetSelectionFilter(var SelectedRec: Record "Purchase Line")
    begin
        Clear(SelectedRec);
        SelectedRec.Reset();
        CurrPage.SetSelectionFilter(SelectedRec);
    end;

    procedure ViewSourceDocument()
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        InvFolder: Text[250];
        PurchaseHeader: Record "Purchase Header";
        MultFiles: Text[1024];
        Pos: Integer;
        Counter: Integer;
    begin
        PurchaseHeader.SetFilter("No.", Rec."Document No.");
        if PurchaseHeader.FindFirst() then begin
            if PurchaseHeader.IsEICard then begin
                if Rec."Source Document" = '' then Error(Text002);
                if PurchasesPayablesSetup.FindFirst() then begin
                    InvFolder := PurchasesPayablesSetup."EShop Invoice Folder";
                    Hyperlink(InvFolder + '\' + Rec."Source Document");
                end;
            end;
            if not PurchaseHeader.IsEICard then begin
                if Rec."Vendor Invoice No" <> '' then begin
                    if PurchasesPayablesSetup.FindFirst() then begin
                        InvFolder := PurchasesPayablesSetup."EShop Invoice Folder";
                        // Multiple Documents
                        if StrPos(Rec."Vendor Invoice No", ',') > 0 then begin
                            MultFiles := Rec."Vendor Invoice No";
                            Pos := 1;
                            while (Pos <= StrLen(MultFiles)) do begin
                                if CopyStr(MultFiles, Pos, 1) = ',' then
                                    Counter := Counter + 1;
                                Pos := Pos + 1;
                            end;
                            Counter := Counter + 1;
                            Pos := 1;
                            while (Pos <= Counter) do begin
                                Hyperlink(InvFolder + '\' + SelectStr(Pos, MultFiles) + '.RTF');
                                Pos := Pos + 1;
                            end;
                        end;
                        // Only One Document
                        if StrPos(Rec."Vendor Invoice No", ',') = 0 then begin
                            Hyperlink(InvFolder + '\' + Rec."Vendor Invoice No" + '.RTF');
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure AjustOutstandingQuantityBase()
    var
        lText001: Label '"%1" = %2\"%3" = %4\Do you want to update "%3"?';
        lText002: Label '"%1" = %2\"%3" = %4\Do you want to continue?';
        lText003: Label '"%1" and "%2" are equal.';
    begin
        // We don't know why "Outstanding Quantity" is different from "Outstanding Qty. (Base)", but here we can change it.
        if Rec."Outstanding Quantity" <> Rec."Outstanding Qty. (Base)" then begin
            if Confirm(lText001, false, Rec.FieldCaption(Rec."Outstanding Quantity"), Rec."Outstanding Quantity", Rec.FieldCaption(Rec."Outstanding Qty. (Base)"), Rec."Outstanding Qty. (Base)") then begin
                Rec."Outstanding Qty. (Base)" := Rec."Outstanding Quantity";
                if Confirm(lText002, false, Rec.FieldCaption(Rec."Outstanding Quantity"), Rec."Outstanding Quantity", Rec.FieldCaption(Rec."Outstanding Qty. (Base)"), Rec."Outstanding Qty. (Base)") then
                    Rec.Modify();
            end;
        end else
            Message(lText003, Rec.FieldCaption(Rec."Outstanding Quantity"), Rec.FieldCaption(Rec."Outstanding Qty. (Base)"));
    end;

    local procedure EnterNewOutstandingQuantity()
    var
        PurchComLine: Record "Purch. Comment Line";
        GenInpPage: Page "Generic Input Page";
        NewOutQty: Decimal;
        LineNo: Integer;
        lText001: Label 'Adjust Outstanding Qty.';
        lText002: Label 'New Outstanding Qty.';
        lText003: Label 'Do you want to change "%1" from %2 to %3?';
        lText004: Label '"%1" has been changed from "%2" to "%3".';
    begin
        GenInpPage.SetInt(Rec."Outstanding Quantity");
        GenInpPage.SetPageCaption(lText001);
        GenInpPage.SetFieldCaption(lText002);
        GenInpPage.SetVisibleField(1);

        if GenInpPage.RunModal = Action::OK then begin
            NewOutQty := GenInpPage.GetInt;
            if Rec."Outstanding Quantity" <> NewOutQty then
                if Confirm(lText003, false, Rec.FieldCaption(Rec."Outstanding Quantity"), Rec."Outstanding Quantity", NewOutQty) then begin
                    LineNo := 10000;
                    PurchComLine.SetRange("Document Type", Rec."Document Type");
                    PurchComLine.SetRange("No.", Rec."Document No.");
                    PurchComLine.SetRange("Document Line No.", Rec."Line No.");
                    if PurchComLine.FindLast() then
                        LineNo := PurchComLine."Line No." + 10000;

                    PurchComLine.Reset();
                    Clear(PurchComLine);
                    PurchComLine."Document Type" := Rec."Document Type";
                    PurchComLine."No." := Rec."Document No.";
                    PurchComLine."Document Line No." := Rec."Line No.";
                    PurchComLine."Line No." := LineNo;
                    PurchComLine.SetUpNewLine;
                    PurchComLine.Comment := StrSubstNo(lText004, Rec.FieldCaption(Rec."Outstanding Quantity"), Rec."Outstanding Quantity", NewOutQty);
                    PurchComLine.Insert();

                    Rec."Outstanding Quantity" := NewOutQty;
                    Rec."Outstanding Qty. (Base)" := Rec."Outstanding Quantity";
                    Rec."Whse. Outstanding Qty. (Base)" := Rec."Outstanding Quantity";

                    Rec."Outstanding Amount" := Rec."Outstanding Quantity" * Rec."Unit Cost";
                    Rec."Outstanding Amount (LCY)" := Rec."Outstanding Quantity" * Rec."Unit Cost (LCY)";
                    Rec."Outstanding Amt. Ex. VAT (LCY)" := Rec."Outstanding Quantity" * Rec."Direct Unit Cost";

                    Rec."Quantity Received" := Rec.Quantity - Rec."Outstanding Quantity";
                    Rec."Completely Received" := Rec.Quantity = Rec."Quantity Received";
                    Rec."Quantity Invoiced" := Rec.Quantity - Rec."Outstanding Quantity";
                end;
        end;
    end;
}
