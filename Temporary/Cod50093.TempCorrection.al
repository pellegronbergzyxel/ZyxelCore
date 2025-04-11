codeunit 50093 TempCorrection
{
    Permissions = tabledata 32 = rmid, Tabledata 120 = rmid, Tabledata 121 = rmid, tabledata 5802 = rmid;

    trigger OnRun()
    var
        PIL: Record "Purchase Line";
    begin
        if pil.get(Pil."Document Type"::Order, '24-5012617', 10000) then begin
            PIL."Quantity (Base)" := 900;
            PIL."Quantity" := 900;
            PIL."Outstanding Qty. (Base)" := 900;
            PIL."Outstanding Quantity" := 900;
            PIL."Qty. to Invoice (Base)" := 0;
            PIL."Qty. to Invoice" := 0;
            PIL."Qty. to Receive (Base)" := 0;
            PIL."Qty. to Receive" := 0;
            PIL."Qty. Rcd. Not Invoiced (Base)" := 0;
            PIL."Qty. Rcd. Not Invoiced" := 0;
            PIL."Qty. Received (Base)" := 900;
            PIL."Quantity Received" := 900;
            PIL."Qty. Invoiced (Base)" := 900;
            PIL."Quantity Invoiced" := 900;
            PIL.Modify(true);
        end;
    end;



    procedure coritemledgersandPRFromPI(PI: Record "Purchase Header")
    var
        PPR: Record "Purch. Rcpt. Header";
        PPRL: Record "Purch. Rcpt. Line";
        PIL: Record "Purchase Line";
        IL: record "Item Ledger Entry";
        VL: record "Value Entry";
    begin
        CorPIfromPH(pi);
        PIL.setrange("Document Type", Pi."Document Type");
        PIL.Setrange("Document No.", PI."No.");
        PIL.setfilter("No.", '<>%1', '');
        PIL.Setfilter(Quantity, '<>0');
        IF PIL.findset then
            repeat

                if PIL."Receipt Line No." <> 0 then begin
                    if pprl.get(Pil."Receipt No.", PIL."Receipt Line No.") then begin
                        IL.get(PPRL."Item Rcpt. Entry No.");
                        IF (pprl.Quantity <> pprl."Quantity (Base)") OR
                           (pprl."Quantity Invoiced" <> pprl."Qty. Invoiced (Base)") then begin
                            pprl."Quantity (Base)" := pprl.Quantity;
                            pprl."Qty. Invoiced (Base)" := pprl."Quantity Invoiced";
                            pprl.modify(false);
                        end;
                        if pprl.Quantity <> il.Quantity then begin
                            il."Remaining Quantity" := il."Remaining Quantity" + (pprl.Quantity - il.Quantity);
                            il.Quantity := pprl.Quantity;
                            Il.modify(false);
                            VL.setrange("Item Ledger Entry No.", il."Entry No.");
                            if VL.findfirst then begin
                                VL."Valued Quantity" := il.Quantity;
                                VL."Item Ledger Entry Quantity" := IL.Quantity;
                                VL.Modify(false)
                            end
                        end;
                    end;
                end;
            Until Pil.Next = 0;

    end;


    procedure CorPIfromPH(PH: Record "Purchase Header")
    var
        PIL: Record "Purchase Line";
    begin
        PIL.setrange("Document Type", Ph."Document Type");
        PIL.Setrange("Document No.", Ph."No.");
        PIL.setfilter("No.", '<>%1', '');
        PIL.Setfilter(Quantity, '<>0');
        IF PIL.findset then
            repeat
                IF (PIL."Quantity (Base)" = PIL."Quantity") OR
                 (PIL."Outstanding Qty. (Base)" = PIL."Outstanding Quantity") OR
                 (PIL."Qty. to Invoice (Base)" = PIL."Qty. to Invoice") OR
                 (PIL."Qty. to Receive (Base)" = PIL."Qty. to Receive") OR
                 (PIL."Qty. Rcd. Not Invoiced (Base)" = PIL."Qty. Rcd. Not Invoiced") OR
                 (PIL."Qty. Received (Base)" = PIL."Quantity Received") OR
                 (PIL."Qty. Invoiced (Base)" = PIL."Quantity Invoiced") THEN begin

                    PIL."Quantity (Base)" := PIL."Quantity";
                    PIL."Outstanding Qty. (Base)" := PIL."Outstanding Quantity";
                    PIL."Qty. to Invoice (Base)" := PIL."Qty. to Invoice";
                    PIL."Qty. to Receive (Base)" := PIL."Qty. to Receive";
                    PIL."Qty. Rcd. Not Invoiced (Base)" := PIL."Qty. Rcd. Not Invoiced";
                    PIL."Qty. Received (Base)" := PIL."Quantity Received";
                    PIL."Qty. Invoiced (Base)" := PIL."Quantity Invoiced";
                    PIL.Modify(false);
                end;
            Until Pil.Next = 0;

    end;



    procedure CorrectPurchrcptHeader(PRH: Record "Purch. Rcpt. Header")
    var
        PPRL: Record "Purch. Rcpt. Line";
        IL: record "Item Ledger Entry";
        VL: record "Value Entry";
    begin
        pprl.setrange("Document No.", PRH."No.");
        IF PPRL.findset then
            repeat
                if not IL.get(PPRL."Item Rcpt. Entry No.") then begin
                    IL.setrange("Item No.", pprl."No.");
                    IL.setrange("Document Type", il."Document Type"::"Purchase Receipt");
                    il.setrange("Document No.", PRH."No.");
                    Il.setrange(Quantity, PPRL."Quantity (Base)");
                    IL.findset;
                end;
                IF (pprl.Quantity <> pprl."Quantity (Base)") OR
                   (pprl."Quantity Invoiced" <> pprl."Qty. Invoiced (Base)") then begin
                    pprl."Quantity (Base)" := pprl.Quantity;
                    pprl."Qty. Invoiced (Base)" := pprl."Quantity Invoiced";
                    pprl.modify(false);
                end;
                if pprl.Quantity <> il.Quantity then begin
                    il."Remaining Quantity" := il."Remaining Quantity" + (pprl.Quantity - il.Quantity);
                    il.Quantity := pprl.Quantity;
                    Il.modify(false);
                    VL.setrange("Item Ledger Entry No.", il."Entry No.");
                    if VL.findfirst then begin
                        VL."Valued Quantity" := il.Quantity;
                        VL."Item Ledger Entry Quantity" := IL.Quantity;
                        VL.Modify(false);
                    end
                end;
            until PPRL.next = 0;
    end;



    procedure correctionItemledgerqty(IL: record "Item Ledger Entry")
    var
    begin
        if NOT IL.Open then
            if il."Remaining Quantity" <> il."Quantity" THEN begin
                il."Remaining Quantity" := 0;
                IF il."Invoiced Quantity" <> 0 then
                    il."Invoiced Quantity" := il."Quantity";
                if Il."Shipped Qty. Not Returned" <> 0 then
                    Il."Shipped Qty. Not Returned" := il."Quantity";
                IL.modify(false);
            end;
    end;


    procedure CopyfromlastpickedandOpen(var recRespHead: Record "Ship Response Header")
    var

        recRespHead2: Record "Ship Response Header";
        recRespHead3: Record "Ship Response Header";
        recRespLine: Record "Ship Response Line";
        recRespLine2: Record "Ship Response Line";
    begin
        if confirm('Do want to create lines from last ready-to-pick response?', false) then begin
            recRespLine.setrange("Response No.", recRespHead."No.");
            if recRespLine.IsEmpty then begin

                recRespHead2.setrange("Customer Reference", recRespHead."Customer Reference");
                recRespHead2.setrange("Warehouse Status", recRespHead2."Warehouse Status"::"Ready to Pick");
                if recRespHead2.FindLast() then begin
                    recRespLine2.setrange("Response No.", recRespHead2."No.");
                    if recRespLine2.findset then
                        repeat
                            recRespLine.init;
                            recRespLine.TransferFields(recRespLine2);
                            recRespLine."Response No." := recRespHead."No.";
                            recRespLine."Response Line No." := recRespLine2."Response Line No.";
                            recRespLine."Warehouse Status" := recRespHead."Warehouse Status";
                            recRespLine.Open := true;
                            recRespLine.Insert(false);
                        until recRespLine2.next = 0;
                end;
                recRespHead.Open := true;
                recRespHead.modify(false);
            end;
        end;
    end;


}
