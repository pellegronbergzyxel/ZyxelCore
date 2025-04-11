Codeunit 50072 "Overshipment Event"
{
    // 001. 18-04-23 ZY-LD 000 - No overshipment on freight cost items.
    // 002. 31-05-24 ZY-LD 000 - When the quantity on a overshipment line is changed, the unit price must remain the same.
    // #490013 pgr/20250219: additional to overshipments
    trigger OnRun()
    begin
    end;

    var
        SI: Codeunit "Single Instance";

    [EventSubscriber(Objecttype::Page, 46, 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateQuantity_Page46(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        recCustOvership: Record "Customer/Item Overshipment";
        recSalesLine: Record "Sales Line";
        OverShipLine: Record "Sales Line";
        recGenProdPostGrp: Record "Gen. Product Posting Group";
        recItem: Record Item;
        ZyXELAdditionalItems: Codeunit "ZyXEL Additional Items Mgt";
        Qty: Decimal;
        lText001: label 'Remember to update quantity on the overshipment line manually!';
        lText002: label '%1, %2% free %3';
        lText003: label '%1, %2 pct. free %3';
    begin
        begin
            recSalesLine.SetRange("Document Type", Rec."Document Type");
            recSalesLine.SetRange("Document No.", Rec."Document No.");
            recSalesLine.SetRange("Overshipment Line No.", Rec."Line No.");

            if (Rec."Document Type" = Rec."document type"::Order) and
               (Rec.Type = Rec.Type::Item) and
               ((Rec."No." <> '') or (Rec."No." <> xRec."No.")) and
               ((Rec.Quantity <> 0) and (Rec.Quantity <> xRec.Quantity)) and
               (Rec."Line No." <> 0) and
               (not recSalesLine.FindFirst)
            then begin
                if Rec."Overshipment Line No." = 0 then begin
                    //>> 18-04-23 ZY-LD 001
                    recItem.Get(Rec."No.");
                    //if not recItem."Freight Cost Item" then begin  //<< 18-04-23 ZY-LD 001  // 31-05-24 ZY-LD 000
                    if recItem.type = recItem.Type::Inventory then begin  // 31-05-24 ZY-LD 000
                        recCustOvership.SetRange("Customer No.", Rec."Sell-to Customer No.");
                        recCustOvership.SetFilter("Item No.", '%1|%2', '', Rec."No.");
                        if recCustOvership.FindLast then begin
                            recGenProdPostGrp.SetRange(Type, recGenProdPostGrp.Type::Overshipment);
                            recGenProdPostGrp.FindFirst;

                            Qty := ROUND(Rec.Quantity * (recCustOvership."Overshipment %" / 100), 1, Format(recCustOvership."Rounding Direction"));

                            recSalesLine.Reset;
                            recSalesLine.Init;
                            recSalesLine.Validate("Document Type", Rec."Document Type");
                            recSalesLine.Validate("Document No.", Rec."Document No.");
                            recSalesLine.Validate("Line No.", Rec."Line No." + 10000);
                            recSalesLine.Validate(Type, Rec.Type);
                            recSalesLine.Validate("No.", Rec."No.");
                            if recSalesLine."Country Code" = 'IT' then
                                recSalesLine.Validate(Description, StrSubstNo(lText003, Rec."No.", recCustOvership."Overshipment %", Lowercase(Format(recGenProdPostGrp.Type))))
                            else
                                recSalesLine.Validate(Description, StrSubstNo(lText002, Rec."No.", recCustOvership."Overshipment %", Lowercase(Format(recGenProdPostGrp.Type))));
                            recSalesLine.Validate(Quantity, Qty);
                            recSalesLine.Validate("Gen. Prod. Posting Group", recGenProdPostGrp.Code);
                            recSalesLine.Validate("Unit Price", recCustOvership."Unit Price");
                            recSalesLine.Insert(true);

                            if recCustOvership.Type = recCustOvership.Type::"Included in Quantity" then
                                Rec.Quantity := Rec.Quantity - recSalesLine.Quantity;
                            Rec."Overshipment Line No." := recSalesLine."Line No.";
                            Rec.Modify(true);
                            // Additonal lines to Overshipment
                            // #490013>>
                            if GuiAllowed then begin
                                ZyXELAdditionalItems.InsertAdditionalItems(recSalesLine."Document Type", recSalesLine."Document No.", recSalesLine."No.", recSalesLine."Line No.");
                                recSalesLine.Get(recSalesLine."Document Type", recSalesLine."Document No.", recSalesLine."Line No.");
                                recSalesLine.Validate(Quantity, Qty);
                                recSalesLine.Validate("Unit Price", recCustOvership."Unit Price");
                                recSalesLine.Modify(true);
                                UpdateAdditionalLine(recSalesLine);
                            end;
                            // #490013<<
                        end;
                    end;
                end else
                    Message(lText001);
            end;

            //>> 31-05-24 ZY-LD 002
            OverShipLine.SetRange("Document Type", Rec."Document Type");
            OverShipLine.SetRange("Document No.", Rec."Document No.");
            OverShipLine.SetRange("Overshipment Line No.", Rec."Line No.");

            if (Rec."Document Type" = Rec."document type"::Order) and
               (Rec.Type = Rec.Type::Item) and
               (Rec.Quantity <> xRec.Quantity) and
               (OverShipLine.FindFirst())  // The current line is the overshipment line
            then begin
                recItem.Get(Rec."No.");
                if recItem.type = recItem.Type::Inventory then begin
                    recCustOvership.SetRange("Customer No.", Rec."Sell-to Customer No.");
                    recCustOvership.SetFilter("Item No.", '%1|%2', '', Rec."No.");
                    if recCustOvership.FindLast then begin
                        Rec.Validate("Unit Price", recCustOvership."Unit Price");
                        Rec.Modify(true);
                    end;
                end;
            end;
            //<< 31-05-24 ZY-LD 002            
        end;
    end;

    [EventSubscriber(Objecttype::Page, 46, 'OnDeleteRecordEvent', '', false, false)]
    local procedure OnDeleteRecord_Page46(var Rec: Record "Sales Line"; var AllowDelete: Boolean)
    var
        recSalesLine: Record "Sales Line";
    begin
        if (Rec."Document Type" = Rec."document type"::Order) and
   (Rec.Type = Rec.Type::Item)
then begin
            if Rec."Overshipment Line No." <> 0 then begin
                if recSalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Overshipment Line No.") then
                    recSalesLine.Delete(true);
            end else
                recSalesLine.SetRange("Document Type", Rec."Document Type");
            recSalesLine.SetRange("Document No.", Rec."Document No.");
            recSalesLine.SetRange("Overshipment Line No.", Rec."Line No.");
            if recSalesLine.FindFirst then begin
                recSalesLine."Overshipment Line No." := 0;
                recSalesLine.Modify(true);
            end;
        end;
    end;


    local procedure UpdateAdditionalLine(SIL: record "Sales Line")
    var
        recSalesHead: Record "Sales Header";
        lSalesLine: Record "Sales Line";
        DecVar: Decimal;
    begin
        lSalesLine.SetRange("Document Type", SIL."Document Type");
        lSalesLine.SetRange("Document No.", SIL."Document No.");
        lSalesLine.SetRange("Additional Item Line No.", SIL."Line No.");
        if lSalesLine.FindSet() then begin
            repeat
                lSalesLine.Validate(Quantity, SIL.Quantity * lSalesLine."Additional Item Quantity");
                lSalesLine.modify();
            until lSalesLine.Next() = 0;
        end;
    end;
}
