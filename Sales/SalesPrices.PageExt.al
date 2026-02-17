pageextension 50269 SalesPriceZX extends "Price List Lines"
{
    layout
    {
        modify(CurrencyCode)
        {
            Visible = true;
        }
        addafter("Asset No.")
        {
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addlast(Control1)
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
    }

    actions
    {
        addfirst(processing)
        {
            action("""Update() ""Line Discount %"" on Sales Documents""")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update "Line Discount %" on Sales Documents';
                Image = LineDiscount;

                trigger OnAction()
                begin
                    UpdateLineDiscountPct();  // 03-05-18 ZY-LD 001
                end;
            }
            action(Replace)
            {
                ApplicationArea = Basic, Suite;
                Image = Replan;

                trigger OnAction()
                var
                    Replace: Page Replace;
                begin
                    Replace.LoadDataSet(Database::"Price List Line", Rec.GetFilters());
                    Replace.SetValidations(true, true);
                    Replace.RunModal();
                    CurrPage.Update();
                    Clear(Replace);
                end;
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

                    trigger OnAction()
                    var
                        ChangeLogEntry: Record "Change Log Entry";
                    begin
                        ChangeLogEntry.SetCurrentKey("Table No.", "Date and Time");
                        ChangeLogEntry.SetAscending("Date and Time", false);
                        ChangeLogEntry.SetRange("Table No.", Database::"Price List Line");
                        ChangeLogEntry.SetRange("Primary Key Field 1 Value", Format(Rec."Price List Code"));
                        ChangeLogEntry.SetRange("Primary Key Field 2 Value", Format(Rec."Line No."));
                        Page.RunModal(Page::"Change Log Entries", ChangeLogEntry);
                    end;
                }
                action(marginApproval)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Margin Approval';
                    Image = Profit;

                    trigger OnAction()
                    var
                        Marginapproval: record "Margin Approval";
                        Marginapprovals: page "Margin Approvals";
                    begin
                        Marginapproval.setrange("Source Type", Marginapproval."Source Type"::"Price Book");
                        Marginapproval.setrange("Source No.", rec."Price List Code");
                        marginapproval.SetRange("Source Line No.", rec."Line No.");
                        Marginapprovals.SetTableView(Marginapproval);
                        Marginapprovals.Run();
                    end;
                }

            }
        }
    }

    local procedure UpdateLineDiscountPct()
    begin
        //>> 03-05-18 ZY-LD 001
        if (Rec."Line Discount %" <> 0) and (Rec."Source Type" = Rec."Source Type"::Customer) then
            UpdateAllSalesDocuments(Rec."Source No.", Rec."Starting Date", Rec."Line Discount %");
        //<< 03-05-18 ZY-LD 001
    end;

    local procedure UpdateAllSalesDocuments(pCustNo: Code[20]; pDate: Date; NewLineDiscount: Decimal)
    var
        recSalesHead: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        "PrevLineDisc%": Decimal;
        i: Integer;
        UpdateSDoc: array[3] of Integer;
        Choice: Integer;
        lText001: Label 'Updating "%1" on\%2 Sales Order(s)\%3 Sales Invoice(s)\%4 and Sales Cr. Memo(s)\\Do you want to continue?';
        lText003: Label '%1 Sales Order Line(s)\%2 Sales Invoice Line(s)\%3 and Sales Cr. Memo Line(s)\is updated.';
        lText004: Label 'Update all sales documents,Update all sales documents equal or newer than %1';
        lText005: Label 'Select Update Period';
    begin
        //>> 03-05-18 ZY-LD 003
        Choice := StrMenu(StrSubstNo(lText004, pDate), 1, lText005);  // 10-01-23 ZY-LD 004
        if Choice > 0 then begin  // 10-01-23 ZY-LD 004
            recSalesHead.SetRange("Bill-to Customer No.", pCustNo);
            recSalesHead.SetRange("Completely Invoiced", false);
            for i := 1 to 3 do begin
                //recSalesHead.RESET;
                recSalesHead.SetRange("Document Type", i);
                if Choice = 2 then  // 10-01-23 ZY-LD 004
                    if i = 1 then  // Orders
                        recSalesHead.SetFilter("Order Date", '%1..', pDate)
                    else  // Invoices and Cr. Memos
                        recSalesHead.SetFilter("Posting Date", '%1..', pDate);
                UpdateSDoc[i] += recSalesHead.Count();
            end;
            if not Confirm(lText001, false, recSalesLine.FieldCaption("Line Discount %"), UpdateSDoc[1], UpdateSDoc[2], UpdateSDoc[3]) then
                exit;

            Clear(UpdateSDoc);
            for i := 1 to 3 do begin
                //recSalesHead.RESET;
                recSalesHead.SetRange("Document Type", i);
                if Choice = 2 then  // 10-01-23 ZY-LD 004
                    if i = 1 then  // Orders
                        recSalesHead.SetFilter("Order Date", '%1..', pDate)
                    else  // Invoices and Cr. Memos
                        recSalesHead.SetFilter("Posting Date", '%1..', pDate);
                if recSalesHead.FindSet() then
                    repeat
                        recSalesLine.SetRange("Document Type", recSalesHead."Document Type");
                        recSalesLine.SetRange("Document No.", recSalesHead."No.");
                        recSalesLine.SetRange(Type, recSalesLine.Type::Item);
                        recSalesLine.SetFilter("No.", '<>%1', '');
                        recSalesLine.SetRange("Completely Invoiced", false);  // 10-01-23 ZY-LD 
                        if recSalesLine.FindSet(true) then begin
                            recSalesLine.SuspendStatusCheck(true);
                            repeat
                                //"PrevLineDisc%" := recSalesLine."Line Discount %";
                                //FindSalesLineLineDisc(recSalesHead,recSalesLine);
                                //IF "PrevLineDisc%" <> recSalesLine."Line Discount %" THEN BEGIN
                                recSalesLine.Validate("Line Discount %", NewLineDiscount);
                                recSalesLine.Modify();
                                UpdateSDoc[i] += 1;
                            //END;
                            until recSalesLine.Next() = 0;
                            recSalesLine.SuspendStatusCheck(false);
                        end;
                    until recSalesHead.Next() = 0;
            end;
            Message(lText003, UpdateSDoc[1], UpdateSDoc[2], UpdateSDoc[3]);
            //<< 03-05-18 ZY-LD 003
        end;
    end;
}
