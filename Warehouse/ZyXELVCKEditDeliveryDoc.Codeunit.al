Codeunit 50050 "ZyXEL VCK Edit Delivery Doc."
{

    trigger OnRun()
    begin
    end;

    var
        GenericInputPage: Page "Generic Input Page";


    procedure EditQuantity(var pVCKDeliveryDocumentLine: Record "VCK Delivery Document Line")
    var
        lText001: label 'Edit %1';
        NewValue: Integer;
        lText002: label 'Do you want to change "%1" from %2 to %3?';
        lText003: label 'Remember to change the value on the sales order.';
        lText004: label 'New %1';
    begin
        begin
            Clear(GenericInputPage);
            GenericInputPage.SetInt := pVCKDeliveryDocumentLine.Quantity;
            GenericInputPage.SetPageCaption := StrSubstNo(lText001, pVCKDeliveryDocumentLine.FieldCaption(pVCKDeliveryDocumentLine.Quantity));
            GenericInputPage.SetFieldCaption := StrSubstNo(lText004, pVCKDeliveryDocumentLine.FieldCaption(pVCKDeliveryDocumentLine.Quantity));
            GenericInputPage.SetVisibleField(1);  // Integer
            if (GenericInputPage.RunModal = Action::OK) then begin
                NewValue := GenericInputPage.GetInt;
                if (pVCKDeliveryDocumentLine.Quantity <> NewValue) and (NewValue >= 0) then
                    if Confirm(lText002, false, pVCKDeliveryDocumentLine.FieldCaption(pVCKDeliveryDocumentLine.Quantity), pVCKDeliveryDocumentLine.Quantity, NewValue) then begin
                        pVCKDeliveryDocumentLine.Validate(pVCKDeliveryDocumentLine.Quantity, NewValue);
                        pVCKDeliveryDocumentLine.Modify;
                        Message(lText003);
                    end;
            end;
        end;
    end;

    procedure EditUnitPriceExclVAT(VAR pVCKDeliveryDocumentLine: Record 50042);
    VAR
        NewValue: Decimal;
        lText001: Label 'ENU=Edit %1';
        lText002: Label 'ENU=Do you want to change "%1" from %2 to %3?';
        lText003: Label 'ENU=Remember to change the value on the sales order.';
        lText004: Label 'ENU=New %1';
    BEGIN
        WITH pVCKDeliveryDocumentLine DO BEGIN
            CLEAR(GenericInputPage);
            GenericInputPage.SetDec := "Unit Price";
            GenericInputPage.SetPageCaption := STRSUBSTNO(lText001, FIELDCAPTION("Unit Price"));
            GenericInputPage.SetFieldCaption := STRSUBSTNO(lText004, FIELDCAPTION("Unit Price"));
            GenericInputPage.SetVisibleField(2);  // Decimal
            IF (GenericInputPage.RUNMODAL = ACTION::OK) THEN BEGIN
                NewValue := GenericInputPage.GetDec;
                IF ("Unit Price" <> NewValue) AND (NewValue >= 0) THEN
                    IF CONFIRM(lText002, FALSE, FIELDCAPTION("Unit Price"), "Unit Price", NewValue) THEN BEGIN
                        VALIDATE("Unit Price", NewValue);
                        MODIFY;
                    END;
            END;
        END;
    END;
}
