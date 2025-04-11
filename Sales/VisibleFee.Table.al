Table 76136 "Visible Fee"
{
    //       //CO4.20: Controling - Basic: Visible Fee;
    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(20; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(30; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        greItem: Record Item;
        greVisibleFee: Record "Visible Fee";
        ginLineSpacing: Integer;
        ginNextLineNo: Integer;
        gboMakeUpdateRequired: Boolean;
        gboAutoText: Boolean;
        gtcText000: label 'There is not enough space to insert extended text lines.';


    procedure SalesCheckIfAnyVisibleFee(var SalesLine: Record "Sales Line"; Unconditionally: Boolean): Boolean
    var
        SalesHeader: Record "Sales Header";
        ExtTextHeader: Record "Extended Text Header";
    begin
        gboMakeUpdateRequired := false;
        if SalesLine."Line No." <> 0 then
            gboMakeUpdateRequired := SalesDeleteVisibleFee(SalesLine);

        //15-51643 IF gboMakeUpdateRequired AND (SalesLine."No." = '') THEN
        //15-51643 No such field SalesLine."Visible Fee Line No." := 0;

        gboAutoText := false;

        if Unconditionally then
            gboAutoText := true
        else
            case SalesLine.Type of
                SalesLine.Type::Item:
                    begin
                        //15-51643       IF greItem.GET(SalesLine."No.") THEN
                        //15-51643 No such field          gboAutoText := greItem."Automatic Sales Visible Fee";
                    end;
                else
                    exit(false);
            end;

        if gboAutoText then begin
            SalesLine.TestField("Document No.");
            //15-51643 No such field   EXIT(SalesLine."Visible Fee Code" <> '');
        end;
    end;


    procedure SalesInsertVisibleFee(var SalesLine: Record "Sales Line")
    var
        ToSalesLine: Record "Sales Line";
        lreSalesHeader: Record "Sales Header";
        lreCurrency: Record "Currency Exchange Rate";
    begin
        ToSalesLine.Reset;
        ToSalesLine.SetRange("Document Type", SalesLine."Document Type");
        ToSalesLine.SetRange("Document No.", SalesLine."Document No.");
        ToSalesLine := SalesLine;
        if ToSalesLine.Find('>') then begin
            ginLineSpacing :=
              (ToSalesLine."Line No." - SalesLine."Line No.") DIV 2;
            if ginLineSpacing = 0 then
                Error(gtcText000);
        end else
            ginLineSpacing := 10000;

        ginNextLineNo := SalesLine."Line No." + ginLineSpacing;

        //15-51643 No such field greVisibleFee.GET(SalesLine."Visible Fee Code");
        lreSalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        //15-51643 No such field IF lreSalesHeader."Not Insert Visible Fee" THEN
        //  EXIT;

        ToSalesLine.Init;
        ToSalesLine."Document Type" := SalesLine."Document Type";
        ToSalesLine."Document No." := SalesLine."Document No.";
        ToSalesLine."Line No." := ginNextLineNo;
        ToSalesLine.Type := ToSalesLine.Type::"G/L Account";
        ToSalesLine.Validate("No.", greVisibleFee."G/L Account No.");
        ToSalesLine.Description := greVisibleFee.Description;
        if lreSalesHeader."Currency Code" <> '' then begin
            greVisibleFee."Amount (LCY)" := lreCurrency.ExchangeAmtLCYToFCYOnlyFactor(greVisibleFee."Amount (LCY)",
                                                                                      lreSalesHeader."Currency Factor");
        end;
        if SalesLine."Quantity (Base)" <> 0 then
            ToSalesLine.Validate(Quantity, SalesLine."Quantity (Base)");
        ToSalesLine.Validate("Unit Price", greVisibleFee."Amount (LCY)");
        //15-51643 No such field ToSalesLine."Visible Fee" := TRUE;
        ToSalesLine.Insert;

        //15-51643 No such field SalesLine."Visible Fee Line No." := ToSalesLine."Line No.";
        //15-51643 No such field SalesLine."Visible Fee Amount" := ToSalesLine."Line Amount";

        gboMakeUpdateRequired := true;
    end;


    procedure SalesDeleteVisibleFee(var SalesLine: Record "Sales Line"): Boolean
    var
        SalesLine2: Record "Sales Line";
    begin
        //15-51643 No such field IF SalesLine."Visible Fee Line No." <> 0 THEN BEGIN
        //  SalesLine2.GET(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Visible Fee Line No.");
        //  SalesLine2.DELETE;
        //  EXIT(TRUE);
        //END;
    end;


    procedure SalesMakeUpdate(): Boolean
    begin
        exit(gboMakeUpdateRequired);
    end;


    procedure SalesUpdateVisibleFee(var SalesLine: Record "Sales Line")
    var
        lreSalesLine2: Record "Sales Line";
    begin
        lreSalesLine2.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Visible Fee Line No.");
        lreSalesLine2.Validate(Quantity, SalesLine."Quantity (Base)");
        lreSalesLine2.Validate("Qty. to Ship", SalesLine."Qty. to Ship (Base)");
        lreSalesLine2.Validate("Qty. to Invoice", SalesLine."Qty. to Invoice (Base)");
        lreSalesLine2.Validate("Return Qty. to Receive", SalesLine."Return Qty. to Receive (Base)");
        lreSalesLine2.Modify;

        SalesLine."Visible Fee Amount" := lreSalesLine2."Line Amount";
    end;


    procedure PurchaseCheckIfAnyVisibleFee(var Line: Record "Purchase Line"; Unconditionally: Boolean): Boolean
    var
        Header: Record "Purchase Header";
    begin
        gboMakeUpdateRequired := false;
        if Line."Line No." <> 0 then
            gboMakeUpdateRequired := PurchaseDeleteVisibleFee(Line);

        if gboMakeUpdateRequired and (Line."No." = '') then
            Line."Visible Fee Line No." := 0;

        gboAutoText := false;

        if Unconditionally then
            gboAutoText := true
        else
            case Line.Type of
                Line.Type::Item:
                    begin
                        if greItem.Get(Line."No.") then
                            gboAutoText := greItem."Automatic Purchase Visible Fee";
                    end;
                else
                    exit(false);
            end;

        if gboAutoText then begin
            Line.TestField("Document No.");
            exit(Line."Visible Fee Code" <> '');
        end;
    end;


    procedure PurchaseInsertVisibleFee(var Line: Record "Purchase Line")
    var
        ToLine: Record "Purchase Line";
        lreHeader: Record "Purchase Header";
        lreCurrency: Record "Currency Exchange Rate";
    begin
        ToLine.Reset;
        ToLine.SetRange("Document Type", Line."Document Type");
        ToLine.SetRange("Document No.", Line."Document No.");
        ToLine := Line;
        if ToLine.Find('>') then begin
            ginLineSpacing :=
              (ToLine."Line No." - Line."Line No.") DIV 2;
            if ginLineSpacing = 0 then
                Error(gtcText000);
        end else
            ginLineSpacing := 10000;

        ginNextLineNo := Line."Line No." + ginLineSpacing;

        greVisibleFee.Get(Line."Visible Fee Code");
        lreHeader.Get(Line."Document Type", Line."Document No.");
        if lreHeader."Not Insert Visible Fee" then
            exit;

        ToLine.Init;
        ToLine."Document Type" := Line."Document Type";
        ToLine."Document No." := Line."Document No.";
        ToLine."Line No." := ginNextLineNo;
        ToLine.Type := ToLine.Type::"G/L Account";
        ToLine.Validate("No.", greVisibleFee."G/L Account No.");
        ToLine.Description := greVisibleFee.Description;
        if lreHeader."Currency Code" <> '' then begin
            greVisibleFee."Amount (LCY)" := lreCurrency.ExchangeAmtLCYToFCYOnlyFactor(greVisibleFee."Amount (LCY)",
                                                                                      lreHeader."Currency Factor");
        end;
        if Line."Quantity (Base)" <> 0 then
            ToLine.Validate(Quantity, Line."Quantity (Base)");
        ToLine.Validate("Direct Unit Cost", greVisibleFee."Amount (LCY)");
        ToLine."Visible Fee" := true;
        ToLine.Insert;

        Line."Visible Fee Line No." := ToLine."Line No.";
        Line."Visible Fee Amount" := ToLine."Line Amount";

        gboMakeUpdateRequired := true;
    end;


    procedure PurchaseDeleteVisibleFee(var Line: Record "Purchase Line"): Boolean
    var
        Line2: Record "Purchase Line";
    begin
        if Line."Visible Fee Line No." <> 0 then begin
            Line2.Get(Line."Document Type", Line."Document No.", Line."Visible Fee Line No.");
            Line2.Delete;
            exit(true);
        end;
    end;


    procedure PurchaseMakeUpdate(): Boolean
    begin
        exit(gboMakeUpdateRequired);
    end;


    procedure PurchaseUpdateVisibleFee(var Line: Record "Purchase Line")
    var
        lreLine2: Record "Purchase Line";
    begin
        lreLine2.Get(Line."Document Type", Line."Document No.", Line."Visible Fee Line No.");
        lreLine2.Validate(Quantity, Line."Quantity (Base)");
        lreLine2.Validate("Qty. to Receive", Line."Qty. to Receive (Base)");
        lreLine2.Validate("Qty. to Invoice", Line."Qty. to Invoice (Base)");
        lreLine2.Validate("Return Qty. to Ship", Line."Return Qty. to Ship (Base)");
        lreLine2.Modify;

        Line."Visible Fee Amount" := lreLine2."Line Amount";
    end;
}
