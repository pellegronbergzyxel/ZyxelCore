Page 50023 "Fix Dimension"
{
    // // PAB 24/5/18 Ticket 018051410000403
    // // Change Dimensions in sales invoice and credit memo lines.

    PageType = StandardDialog;
    Permissions = TableData "G/L Entry" = rm;
    SourceTable = "G/L Entry";

    layout
    {
        area(content)
        {
            field(DivisionCode; DivisionCode)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Division:';
                TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DIVISION'));
            }
            field(DepartmentCode; DepartmentCode)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Department:';
                TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DEPARTMENT'));
            }
            field(CountryCode; CountryCode)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Country:';
                TableRelation = "Dimension Value".Code where("Dimension Code" = filter('COUNTRY'));
            }
            field(CostTypeCode; CostTypeCode)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cost Type:';
                TableRelation = "Dimension Value".Code where("Dimension Code" = filter('COSTTYPE'));
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        DivisionCode := Rec."Global Dimension 1 Code";
        DepartmentCode := Rec."Global Dimension 2 Code";
        CountryCode := Rec.Country;
        CostTypeCode := Rec."Cost Type";
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        Jnl: Codeunit "Gen. Jnl.-Post Line";
    begin
        /*IF CloseAction = ACTION::OK THEN BEGIN
          IF DivisionCode <> '' THEN
            Update(Rec,'DIVISION',DivisionCode);
          IF DepartmentCode <> '' THEN
            Update(Rec,'DEPARTMENT',DepartmentCode);
          IF CountryCode <> '' THEN
            Update(Rec,'COUNTRY',CountryCode);
          IF CostTypeCode <> '' THEN
            Update(Rec,'COSTTYPE',CostTypeCode);
          IF DivisionCode <> '' THEN
            Jnl.ChangeGlobalDimension1(Rec."Entry No.", DivisionCode);
          IF DepartmentCode <> '' THEN
            Jnl.ChangeGlobalDimension2(Rec."Entry No.", DepartmentCode);
        END;*/

    end;

    var
        DivisionCode: Code[20];
        DepartmentCode: Code[20];
        CountryCode: Code[20];
        CostTypeCode: Code[20];
        Text19073051: label 'Fix Dimension Values';
        Text19050782: label 'Please remember for Country and Cost Type dimensions to be refreshed, please click on the Update Dimensions button.';

    local procedure Update(var TheEntry: Record "G/L Entry"; DimensionCode: Code[20]; ValueCode: Code[20])
    var
        NewDSID: Integer;
        DimMgt: Codeunit DimensionManagement;
        tDSE: Record "Dimension Set Entry" temporary;
        recSalesInvoiceLine: Record "Sales Invoice Line";
        DimensionSetID: Integer;
        recDimensionSetEntry: Record "Dimension Set Entry";
        recSalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        DimMgt.GetDimensionSet(tDSE, TheEntry."Dimension Set ID");
        tDSE.Reset;
        tDSE.SetRange("Dimension Code", DimensionCode);
        if tDSE.FindFirst then begin
            tDSE.Validate("Dimension Value Code", ValueCode);
            tDSE.Modify;
        end else begin
            tDSE.Init;
            tDSE.Validate("Dimension Code", DimensionCode);
            tDSE.Validate("Dimension Value Code", ValueCode);
            tDSE.Insert;
        end;
        tDSE.Reset;
        NewDSID := DimMgt.GetDimensionSetID(tDSE);
        if NewDSID <> TheEntry."Dimension Set ID" then begin
            TheEntry."Dimension Set ID" := NewDSID;
            TheEntry.Modify;
        end;

        //PAB
        // ** Invoice **
        if TheEntry."Document Type" = TheEntry."document type"::Invoice then begin
            recSalesInvoiceLine.SetFilter("Document No.", TheEntry."Document No.");
            if recSalesInvoiceLine.FindFirst then begin
                repeat
                    DimensionSetID := recSalesInvoiceLine."Dimension Set ID";
                    // Straight Fields
                    if DimensionCode = 'DIVISION' then begin
                        recSalesInvoiceLine."Division Code" := ValueCode;
                        recSalesInvoiceLine.Modify;
                    end;
                    if DimensionCode = 'DEPARTMENT' then begin
                        recSalesInvoiceLine."Department Code" := ValueCode;
                        recSalesInvoiceLine.Modify;
                    end;
                    if DimensionCode = 'COUNTRY' then begin
                        recSalesInvoiceLine."Country Code" := ValueCode;
                        recSalesInvoiceLine.Modify;
                    end;
                    // Dimension Set
                    recDimensionSetEntry.SetRange("Dimension Set ID", DimensionSetID);
                    recDimensionSetEntry.SetFilter("Dimension Code", DimensionCode);
                    if recDimensionSetEntry.FindFirst then begin
                        recDimensionSetEntry."Dimension Value Code" := ValueCode;
                        recDimensionSetEntry.Modify;
                    end;
                until recSalesInvoiceLine.Next() = 0;
            end;
        end;

        // ** Credit Memo **
        if TheEntry."Document Type" = TheEntry."document type"::"Credit Memo" then begin
            recSalesCrMemoLine.SetFilter("Document No.", TheEntry."Document No.");
            if recSalesCrMemoLine.FindFirst then begin
                repeat
                    DimensionSetID := recSalesCrMemoLine."Dimension Set ID";
                    // Dimension Set
                    recDimensionSetEntry.SetRange("Dimension Set ID", DimensionSetID);
                    recDimensionSetEntry.SetFilter("Dimension Code", DimensionCode);
                    if recDimensionSetEntry.FindFirst then begin
                        recDimensionSetEntry."Dimension Value Code" := ValueCode;
                        recDimensionSetEntry.Modify;
                    end;
                until recSalesCrMemoLine.Next() = 0;
            end;
        end;
    end;
}
